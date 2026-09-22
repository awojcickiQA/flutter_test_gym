import os
import pytest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.options.ios import XCUITestOptions

def pytest_addoption(parser):
    parser.addoption(
        "--platform",
        action="store",
        default=os.environ.get("APPIUM_PLATFORM", "android").lower(),
        help="Target platform: android or ios"
    )
    parser.addoption(
        "--appium-url",
        action="store",
        default=os.environ.get("APPIUM_SERVER_URL", "http://127.0.0.1:4723"),
        help="Appium server URL"
    )

@pytest.fixture(scope="function")
def driver(request):
    """
    Appium Driver fixture z obsługą Android (UiAutomator2) oraz iOS (XCUITest).
    Automatycznie wykonuje zrzut ekranu w przypadku błędu testu.
    """
    platform = request.config.getoption("--platform").lower()
    appium_server_url = request.config.getoption("--appium-url")

    if platform == "ios":
        options = XCUITestOptions()
        options.platform_name = "iOS"
        options.automation_name = "XCUITest"

        platform_version = os.environ.get("IOS_PLATFORM_VERSION")
        if platform_version:
            options.platform_version = platform_version

        udid = os.environ.get("IOS_UDID")
        if udid:
            options.udid = udid

        device_name = os.environ.get("IOS_DEVICE_NAME")
        if device_name:
            options.device_name = device_name
        elif not udid:
            options.device_name = "iPhone"

        app_path = os.environ.get("APP_PATH")
        if app_path:
            options.app = app_path

        options.bundle_id = "com.example.flutterTestGym"
        options.no_reset = True
        options.new_command_timeout = 240
        options.wda_launch_timeout = 180000
        options.wda_startup_retries = 4
        options.wda_startup_retry_interval = 20000
    else:
        options = UiAutomator2Options()
        options.platform_name = "Android"
        options.automation_name = "UiAutomator2"
        options.device_name = os.environ.get("ANDROID_DEVICE_NAME", "Android Emulator")
        options.app_package = "com.example.flutter_test_gym"
        options.app_activity = ".MainActivity"
        options.no_reset = False
        options.new_command_timeout = 240
        options.auto_grant_permissions = True
        options.uiautomator2_server_install_timeout = 120000
        options.uiautomator2_server_launch_timeout = 120000
        options.adb_exec_timeout = 120000

        app_path = os.environ.get("APP_PATH")
        if app_path:
            options.app = app_path

    driver = webdriver.Remote(appium_server_url, options=options)
    driver.implicitly_wait(0)

    if platform == "ios":
        try:
            driver.terminate_app("com.example.flutterTestGym")
            driver.activate_app("com.example.flutterTestGym")
            import time
            time.sleep(1.0)
        except Exception:
            pass

    yield driver

    # Przechwytywanie zrzutu ekranu w razie błędu
    if hasattr(request.node, "rep_call") and request.node.rep_call.failed:
        screenshots_dir = os.path.join(os.path.dirname(__file__), "reports", "screenshots")
        os.makedirs(screenshots_dir, exist_ok=True)
        screenshot_path = os.path.join(screenshots_dir, f"{request.node.name}.png")
        try:
            driver.save_screenshot(screenshot_path)
        except Exception:
            pass

    if platform == "ios":
        try:
            driver.terminate_app("com.example.flutterTestGym")
        except Exception:
            pass

    driver.quit()

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep = outcome.get_result()
    setattr(item, f"rep_{rep.when}", rep)
