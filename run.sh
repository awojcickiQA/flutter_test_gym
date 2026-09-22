#!/usr/bin/env bash
# Skrypt ułatwiający uruchamianie Flutter Test Gym na symulatorach oraz testów Appium

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

echo "🏋️‍♂️ Flutter Test Gym Runner & QA Suite"

# Obsługa składni test-ios/<test>, test-ios//<test>, test-android/<test>, test/<test>
RAW_ARG="$1"
if [[ "$RAW_ARG" =~ ^test-ios/+(.*)$ ]]; then
    TARGET="test-ios"
    SPECIFIC_TEST="${BASH_REMATCH[1]}"
    shift
    set -- "test-ios" "$SPECIFIC_TEST" "$@"
elif [[ "$RAW_ARG" =~ ^test-android/+(.*)$ ]] || [[ "$RAW_ARG" =~ ^test/+(.*)$ ]]; then
    TARGET="test-android"
    SPECIFIC_TEST="${BASH_REMATCH[1]}"
    shift
    set -- "test-android" "$SPECIFIC_TEST" "$@"
else
    TARGET="${1:-menu}"
fi

start_ios() {
    echo "📱 Uruchamianie symulatora iOS..."
    open -a Simulator
    IOS_DEVICE=$(xcrun simctl list devices | grep -E "iPhone.*\(Booted\)" | head -n 1 | sed -E 's/.*\(([0-9A-F-]+)\).*/\1/' || echo "")
    if [ -n "$IOS_DEVICE" ]; then
        flutter run -d "$IOS_DEVICE"
    else
        flutter run -d "iPhone"
    fi
}

start_android() {
    echo "🤖 Uruchamianie emulatora Android..."
    export PATH="/Users/arturwojcicki/Library/Android/sdk/platform-tools:$PATH"
    if ! adb devices 2>/dev/null | grep -q "emulator-"; then
        flutter emulators --launch Pixel_7_API_34 || true
        adb wait-for-device 2>/dev/null || true
    fi
    flutter run -d emulator-5554
}

start_all() {
    echo "📱 Uruchamianie symulatora iOS..."
    open -a Simulator
    echo "🤖 Uruchamianie emulatora Android..."
    export PATH="/Users/arturwojcicki/Library/Android/sdk/platform-tools:$PATH"
    if ! adb devices 2>/dev/null | grep -q "emulator-"; then
        flutter emulators --launch Pixel_7_API_34 || true
    fi
    echo "🚀 Uruchamianie aplikacji na wszystkich urządzeniach..."
    flutter run -d all
}

ensure_android_emulator() {
    export PATH="/Users/arturwojcicki/Library/Android/sdk/platform-tools:$PATH"
    if ! adb devices 2>/dev/null | grep -q "emulator-"; then
        echo "🤖 Emulator Android nie jest uruchomiony. Uruchamianie Pixel_7_API_34..."
        flutter emulators --launch Pixel_7_API_34 || true
        echo "⏳ Oczekiwanie na gotowość emulatora Android..."
        adb wait-for-device 2>/dev/null || true
        local RETRIES=30
        while [ $RETRIES -gt 0 ]; do
            local BOOT=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
            if [ "$BOOT" = "1" ]; then
                break
            fi
            sleep 2
            RETRIES=$((RETRIES - 1))
        done
        echo "✅ Emulator Android jest gotowy!"
    fi
}

ensure_ios_simulator() {
    if ! xcrun simctl list devices | grep -E "iPhone.*\(Booted\)" >/dev/null 2>&1; then
        echo "📱 Symulator iOS nie jest uruchomiony. Uruchamianie..."
        open -a Simulator
        sleep 4
    fi
}

run_tests_android() {
    ensure_android_emulator
    echo "🧪 Uruchamianie testów Appium na Android..."
    cd "$DIR/appium_python"
    ./run_tests.sh --platform android "${@:2}"
}

run_tests_ios() {
    ensure_ios_simulator
    echo "🧪 Uruchamianie testów Appium na iOS..."
    cd "$DIR/appium_python"
    ./run_tests.sh --platform ios "${@:2}"
}

case "$TARGET" in
    ios)
        start_ios
        ;;
    android)
        start_android
        ;;
    all|both)
        start_all
        ;;
    test|test-android)
        run_tests_android "$@"
        ;;
    test-ios)
        run_tests_ios "$@"
        ;;
    *)
        echo "Wybierz opcję:"
        echo "  1) Uruchom aplikację na iOS Simulator"
        echo "  2) Uruchom aplikację na Android Emulator"
        echo "  3) Uruchom aplikację na obu (all)"
        echo "  4) Uruchom wszystkie testy Appium (Android)"
        echo "  5) Uruchom wszystkie testy Appium (iOS)"
        echo "  6) Uruchom pojedynczy test lub filtr (Android)"
        echo "  7) Uruchom pojedynczy test lub filtr (iOS)"
        echo ""
        echo "Możesz także wywołać bezpośrednio:"
        echo "  ./run.sh ios | android | all"
        echo "  ./run.sh test-android [plik | plik::test | -k filtr | nazwa_testu]"
        echo "  ./run.sh test-ios [plik | plik::test | -k filtr | nazwa_testu]"
        echo ""
        echo "Przykłady uruchamiania pojedynczych testów:"
        echo "  ./run.sh test-ios test_device.py::test_device_offline_mode_toggle"
        echo "  ./run.sh test-ios/test_device.py::test_device_offline_mode_toggle"
        echo "  ./run.sh test-ios test_device_offline_mode_toggle"
        echo "  ./run.sh test-ios -k offline"
        echo "  ./run.sh test-ios test_forms.py"
        echo ""
        read -p "Wybór [1-7]: " choice
        case "$choice" in
            1) start_ios ;;
            2) start_android ;;
            3) start_all ;;
            4) run_tests_android "test-android" ;;
            5) run_tests_ios "test-ios" ;;
            6)
                read -p "Podaj test, plik lub filtr (np. test_device.py::test_device_offline_mode_toggle lub -k offline): " custom_test
                run_tests_android "test-android" "$custom_test"
                ;;
            7)
                read -p "Podaj test, plik lub filtr (np. test_device.py::test_device_offline_mode_toggle lub -k offline): " custom_test
                run_tests_ios "test-ios" "$custom_test"
                ;;
            *) echo "Niepoprawny wybór."; exit 1 ;;
        esac
        ;;
esac
