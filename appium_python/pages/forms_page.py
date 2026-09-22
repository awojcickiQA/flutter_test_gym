from .base_page import BasePage

class FormsPage(BasePage):
    """Page Object dla modułu Formularze & Kontrolki."""
    FORMS_SCREEN = "forms_screen"
    STANDARD_INPUT = "forms_standard_input"
    EMAIL_INPUT = "forms_email_input"
    PASSWORD_INPUT = "forms_password_input"
    PASSWORD_TOGGLE_BTN = "forms_password_toggle_btn"
    CARD_NUMBER_INPUT = "forms_card_number_input"
    ASYNC_USERNAME_INPUT = "forms_async_username_input"
    ASYNC_STATUS_INDICATOR = "forms_async_status_indicator"
    MULTILINE_INPUT = "forms_multiline_input"
    DISABLED_INPUT = "forms_disabled_input"
    READONLY_INPUT = "forms_readonly_input"

    CHECKBOX_NEWSLETTER = "forms_checkbox_newsletter"
    CHECKBOX_TERMS = "forms_checkbox_terms"
    CHECKBOX_TRISTATE = "forms_checkbox_tristate"
    RADIO_OPTION_1 = "forms_radio_option_1"
    RADIO_OPTION_2 = "forms_radio_option_2"
    SWITCH_NOTIFICATIONS = "forms_switch_notifications"
    SLIDER_VOLUME = "forms_slider_volume"
    RANGE_SLIDER_PRICE = "forms_range_slider_price"
    DROPDOWN_COUNTRY = "forms_dropdown_country"
    SEGMENTED_PRIORITY = "forms_segmented_priority"

    DATE_PICKER_BTN = "forms_date_picker_btn"
    TIME_PICKER_BTN = "forms_time_picker_btn"
    ADD_DYNAMIC_FIELD_BTN = "forms_add_dynamic_field_btn"
    SUBMIT_BTN = "forms_submit_btn"
    RESET_BTN = "forms_reset_btn"
    SUCCESS_BANNER = "forms_success_banner"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.STANDARD_INPUT, timeout=3) or
            self.is_displayed(self.SUBMIT_BTN, timeout=1) or
            self.is_displayed(self.ADD_DYNAMIC_FIELD_BTN, timeout=1) or
            self.is_displayed(self.FORMS_SCREEN, timeout=1)
        )

    def fill_standard_text(self, text: str):
        self.type_text(self.STANDARD_INPUT, text)

    def fill_email(self, email: str):
        self.type_text(self.EMAIL_INPUT, email)

    def fill_password(self, password: str):
        self.type_text(self.PASSWORD_INPUT, password)

    def toggle_password_visibility(self):
        self.click(self.PASSWORD_TOGGLE_BTN)

    def fill_card_number(self, card_number: str):
        self.type_text(self.CARD_NUMBER_INPUT, card_number)

    def fill_async_username(self, username: str):
        self.type_text(self.ASYNC_USERNAME_INPUT, username)

    def get_async_username_status(self, timeout: int = 5) -> str:
        return self.get_text(self.ASYNC_STATUS_INDICATOR, timeout=timeout)

    def fill_multiline(self, notes: str):
        self.type_text(self.MULTILINE_INPUT, notes)

    def toggle_newsletter(self):
        self.click(self.CHECKBOX_NEWSLETTER)

    def accept_terms(self):
        self.scroll_to_element(self.CHECKBOX_TERMS)
        self.click(self.CHECKBOX_TERMS)

    def select_delivery_courier(self):
        self.scroll_to_element(self.RADIO_OPTION_1)
        self.click(self.RADIO_OPTION_1)

    def select_delivery_locker(self):
        self.scroll_to_element(self.RADIO_OPTION_2)
        self.click(self.RADIO_OPTION_2)

    def toggle_notifications(self):
        self.scroll_to_element(self.SWITCH_NOTIFICATIONS)
        self.click(self.SWITCH_NOTIFICATIONS)

    def add_dynamic_field(self):
        self.scroll_to_element(self.ADD_DYNAMIC_FIELD_BTN)
        self.click(self.ADD_DYNAMIC_FIELD_BTN)

    def submit_form(self):
        self.scroll_to_element(self.SUBMIT_BTN)
        self.click(self.SUBMIT_BTN)

    def reset_form(self):
        self.scroll_to_element(self.RESET_BTN)
        self.click(self.RESET_BTN)

    def is_success_banner_displayed(self) -> bool:
        if self.is_displayed(self.SUCCESS_BANNER, timeout=1):
            return True
        self.swipe_down(percent=0.7)
        self.swipe_down(percent=0.7)
        return self.is_displayed(self.SUCCESS_BANNER, timeout=3)
