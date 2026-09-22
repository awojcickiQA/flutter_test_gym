import pytest
from pages.home_page import HomePage
from pages.lists_page import ListsPage

@pytest.fixture(autouse=True)
def open_lists_screen(driver):
    home_page = HomePage(driver)
    home_page.open_lists_module()
    lists_page = ListsPage(driver)
    assert lists_page.is_loaded()
    yield lists_page

@pytest.mark.lists
@pytest.mark.smoke
def test_filter_list_by_search_query(driver):
    """Weryfikacja filtrowania listy za pomocą wyszukiwarki."""
    lists_page = ListsPage(driver)
    initial_text = lists_page.get_item_count_text()

    lists_page.search("Rekord danych #1")
    filtered_text = lists_page.get_item_count_text()
    assert initial_text != filtered_text, "Licznik elementów nie uległ zmianie po przefiltrowaniu!"

    lists_page.clear_search()
    cleared_text = lists_page.get_item_count_text()
    assert cleared_text == initial_text, "Licznik elementów nie powrócił do pierwotnego po wyczyszczeniu!"

@pytest.mark.lists
def test_empty_state_when_no_matches(driver):
    """Weryfikacja stanu pustego (Empty State) przy braku dopasowań wyszukiwania."""
    lists_page = ListsPage(driver)
    lists_page.search("NIEISTNIEJACY_ELEMENT_XYZ_999")

    assert lists_page.is_empty_state_displayed(), "Ekran pusty nie pojawił się po wyszukaniu nieistniejącego elementu!"

@pytest.mark.lists
def test_scroll_infinite_list(driver):
    """Weryfikacja przewijania wirtualizowanej listy w dół."""
    lists_page = ListsPage(driver)
    # Sprawdzenie, czy element o wyższym indeksie staje się dostępny po przewinięciu
    found = lists_page.scroll_to_item(15, max_swipes=6)
    assert found, "Element o indeksie 15 nie został odnaleziony podczas przewijania!"
