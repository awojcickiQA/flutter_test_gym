import pytest
from pages.home_page import HomePage
from pages.shop_login_page import ShopLoginPage
from pages.shop_catalog_page import ShopCatalogPage
from pages.shop_cart_page import ShopCartPage
from pages.shop_checkout_page import ShopCheckoutPage
from pages.shop_order_success_page import ShopOrderSuccessPage

@pytest.fixture(autouse=True)
def open_shop_screen(driver):
    """Przejście do modułu sklepu z ekranu głównego."""
    home_page = HomePage(driver)
    home_page.open_shop_module()
    login_page = ShopLoginPage(driver)
    assert login_page.is_loaded()
    yield login_page

@pytest.mark.shop
def test_login_invalid_credentials_shows_error(driver):
    """Weryfikacja komunikatu błędu przy podaniu błędnych danych logowania."""
    login_page = ShopLoginPage(driver)
    login_page.login("niepoprawny@email.pl", "bledne_haslo")

    error_msg = login_page.get_error_message()
    assert "niepoprawny" in error_msg.lower() or "błąd" in error_msg.lower()

@pytest.mark.shop
@pytest.mark.smoke
def test_shop_full_checkout_e2e(driver):
    """
    Pełny scenariusz zakupowy E2E:
    1. Logowanie za pomocą szybkiego wypełnienia (Quick Fill)
    2. Wyszukanie i dodanie produktu 'prod_1' do koszyka
    3. Weryfikacja licznika na ikonie koszyka
    4. Przejście do koszyka i zastosowanie kodu rabatowego DISCOUNT10
    5. Przejście do kasy (Multi-step Stepper):
       - Krok 1: Wypełnienie danych adresowych
       - Krok 2: Wybór kuriera
       - Krok 3: Płatność BLIK z kodem 123456
    6. Złożenie zamówienia
    7. Weryfikacja ekranu sukcesu i formatu numeru zamówienia ORD-XXXXX
    8. Powrót na ekran główny
    """
    # 1. Logowanie
    login_page = ShopLoginPage(driver)
    login_page.quick_fill_and_submit()

    # 2. Katalog produktów
    catalog_page = ShopCatalogPage(driver)
    assert catalog_page.is_loaded(), "Katalog produktów nie został otwarty!"
    catalog_page.add_product_to_cart("prod_1")

    # 3. Weryfikacja koszyka na belce
    badge_count = catalog_page.get_cart_badge_count()
    assert "1" in badge_count

    # 4. Koszyk i kod rabatowy
    catalog_page.open_cart()
    cart_page = ShopCartPage(driver)
    assert cart_page.is_loaded(), "Ekran koszyka nie został otwarty!"

    cart_page.apply_coupon("DISCOUNT10")
    assert cart_page.is_coupon_applied(), "Kupon rabatowy nie został naliczony!"

    # 5. Kasa
    cart_page.proceed_to_checkout()
    checkout_page = ShopCheckoutPage(driver)
    assert checkout_page.is_loaded(), "Ekran kasy nie został otwarty!"

    # Krok 1: Adres
    checkout_page.fill_address(
        name="Jan Nowak",
        street="ul. Marszałkowska 10",
        zip_code="00-001",
        city="Warszawa"
    )
    checkout_page.click_next()

    # Krok 2: Dostawa
    checkout_page.select_delivery_courier()
    checkout_page.click_next()

    # Krok 3: Płatność BLIK
    checkout_page.select_payment_blik(blik_code="123456")
    checkout_page.place_order()

    # 6. Ekran sukcesu
    success_page = ShopOrderSuccessPage(driver)
    assert success_page.is_loaded(), "Ekran sukcesu zamówienia nie pojawił się!"
    assert success_page.is_valid_order_id(), f"Numer zamówienia nie pasuje do wzorca ORD-\\d+: {success_page.get_order_id()}"

    # 7. Powrót (przycisk w aplikacji wraca do katalogu sklepu)
    success_page.return_to_home()
    catalog_page = ShopCatalogPage(driver)
    assert catalog_page.is_loaded(), "Katalog produktów nie został otwarty po powrocie!"
