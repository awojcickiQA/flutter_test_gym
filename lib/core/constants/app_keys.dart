/// Centralny rejestr kluczy selektorów testowych dla całej aplikacji Flutter Test Gym.
/// Używaj tych stałych w kodzie aplikacji (`Key(AppKeys.xyz)`) oraz w testach.
abstract class AppKeys {
  // --- EKRAN GŁÓWNY & NAWIGACJA ---
  static const homeScreen = 'home_screen';
  static const navModuleForms = 'nav_module_forms';
  static const navModuleGestures = 'nav_module_gestures';
  static const navModuleLists = 'nav_module_lists';
  static const navModuleAsync = 'nav_module_async';
  static const navModuleOverlays = 'nav_module_overlays';
  static const navModuleShop = 'nav_module_shop';
  static const navModuleDevice = 'nav_module_device';
  static const navModuleAccessibility = 'nav_module_accessibility';
  static const toggleInspectorBtn = 'toggle_inspector_btn';
  static const toggleThemeBtn = 'toggle_theme_btn';

  // --- MODUŁ 1: FORMULARZE & KONTROLKI ---
  static const formsScreen = 'forms_screen';
  static const formsStandardInput = 'forms_standard_input';
  static const formsEmailInput = 'forms_email_input';
  static const formsPasswordInput = 'forms_password_input';
  static const formsPasswordToggleBtn = 'forms_password_toggle_btn';
  static const formsCardNumberInput = 'forms_card_number_input';
  static const formsAsyncUsernameInput = 'forms_async_username_input';
  static const formsAsyncStatusIndicator = 'forms_async_status_indicator';
  static const formsMultilineInput = 'forms_multiline_input';
  static const formsDisabledInput = 'forms_disabled_input';
  static const formsReadonlyInput = 'forms_readonly_input';

  static const formsCheckboxNewsletter = 'forms_checkbox_newsletter';
  static const formsCheckboxTerms = 'forms_checkbox_terms';
  static const formsCheckboxTristate = 'forms_checkbox_tristate';
  static const formsRadioOption1 = 'forms_radio_option_1';
  static const formsRadioOption2 = 'forms_radio_option_2';
  static const formsRadioOption3 = 'forms_radio_option_3';
  static const formsSwitchNotifications = 'forms_switch_notifications';
  static const formsSliderVolume = 'forms_slider_volume';
  static const formsRangeSliderPrice = 'forms_range_slider_price';
  static const formsDropdownCountry = 'forms_dropdown_country';
  static const formsSegmentedPriority = 'forms_segmented_priority';

  static const formsDatePickerBtn = 'forms_date_picker_btn';
  static const formsSelectedDateText = 'forms_selected_date_text';
  static const formsTimePickerBtn = 'forms_time_picker_btn';
  static const formsSelectedTimeText = 'forms_selected_time_text';

  static const formsAddDynamicFieldBtn = 'forms_add_dynamic_field_btn';
  static const formsSubmitBtn = 'forms_submit_btn';
  static const formsResetBtn = 'forms_reset_btn';
  static const formsSuccessBanner = 'forms_success_banner';

  // --- MODUŁ 2: GESTY & INTERAKCJE ---
  static const gesturesScreen = 'gestures_screen';
  static const gesturesSingleTapArea = 'gestures_single_tap_area';
  static const gesturesSingleTapCounter = 'gestures_single_tap_counter';
  static const gesturesDoubleTapArea = 'gestures_double_tap_area';
  static const gesturesDoubleTapCounter = 'gestures_double_tap_counter';
  static const gesturesLongPressArea = 'gestures_long_press_area';
  static const gesturesLongPressFeedback = 'gestures_long_press_feedback';

  static const gesturesReorderableList = 'gestures_reorderable_list';
  static String gesturesReorderableItem(int id) => 'gestures_reorder_item_$id';

  static const gesturesDraggableItem = 'gestures_draggable_item';
  static const gesturesDragTargetBin = 'gestures_drag_target_bin';
  static const gesturesDragScoreText = 'gestures_drag_score_text';

  static const gesturesSwipeDismissibleList = 'gestures_swipe_list';
  static String gesturesSwipeItem(int id) => 'gestures_swipe_item_$id';

  static const gesturesInteractiveViewer = 'gestures_interactive_viewer';
  static const gesturesCanvasSignature = 'gestures_canvas_signature';
  static const gesturesCanvasClearBtn = 'gestures_canvas_clear_btn';

  // --- MODUŁ 3: LISTY & PRZEWIJANIE ---
  static const listsScreen = 'lists_screen';
  static const listsSearchInput = 'lists_search_input';
  static const listsSearchClearBtn = 'lists_search_clear_btn';
  static const listsItemCountText = 'lists_item_count_text';
  static const listsInfiniteListView = 'lists_infinite_list_view';
  static const listsRefreshIndicator = 'lists_refresh_indicator';
  static const listsEmptyState = 'lists_empty_state';
  static const listsLoadingMoreSpinner = 'lists_loading_more_spinner';
  static String listsItemTile(int id) => 'lists_item_tile_$id';
  static String listsItemTitle(int id) => 'lists_item_title_$id';

  // --- MODUŁ 4: ASYNCHRONICZNOŚĆ & FLAKINESS ---
  static const asyncScreen = 'async_screen';
  static const asyncDelaySelectorSegment = 'async_delay_selector_segment';
  static const asyncFetchDataBtn = 'async_fetch_data_btn';
  static const asyncLoadingSpinner = 'async_loading_spinner';
  static const asyncResultText = 'async_result_text';
  static const asyncInfiniteAnimationWidget = 'async_infinite_animation_widget';
  static const asyncAnimationToggleBtn = 'async_animation_toggle_btn';
  static const asyncFlakyBtn = 'async_flaky_btn';
  static const asyncFlakySuccessBadge = 'async_flaky_success_badge';
  static const asyncFlakyErrorBadge = 'async_flaky_error_badge';
  static const asyncFlakyRetryBtn = 'async_flaky_retry_btn';
  static const asyncTriggerToastBtn = 'async_trigger_toast_btn';
  static const asyncTransientToast = 'async_transient_toast';

  // --- MODUŁ 5: DIALOGI & NAKŁADKI ---
  static const overlaysScreen = 'overlays_screen';
  static const overlaysShowAlertBtn = 'overlays_show_alert_btn';
  static const overlaysShowConfirmBtn = 'overlays_show_confirm_btn';
  static const overlaysShowPromptBtn = 'overlays_show_prompt_btn';
  static const overlaysShowBottomSheetBtn = 'overlays_show_bottom_sheet_btn';
  static const overlaysShowSnackbarBtn = 'overlays_show_snackbar_btn';
  static const overlaysOpenDrawerBtn = 'overlays_open_drawer_btn';

  static const overlaysAlertDialog = 'overlays_alert_dialog';
  static const overlaysAlertOkBtn = 'overlays_alert_ok_btn';
  static const overlaysConfirmDialog = 'overlays_confirm_dialog';
  static const overlaysConfirmYesBtn = 'overlays_confirm_yes_btn';
  static const overlaysConfirmNoBtn = 'overlays_confirm_no_btn';
  static const overlaysPromptDialog = 'overlays_prompt_dialog';
  static const overlaysPromptInput = 'overlays_prompt_input';
  static const overlaysPromptSubmitBtn = 'overlays_prompt_submit_btn';
  static const overlaysDialogResultText = 'overlays_dialog_result_text';

  static const overlaysBottomSheet = 'overlays_bottom_sheet';
  static const overlaysBottomSheetCloseBtn = 'overlays_bottom_sheet_close_btn';
  static const overlaysSnackbarActionBtn = 'overlays_snackbar_action_btn';
  static const overlaysNavDrawer = 'overlays_nav_drawer';

  // --- MODUŁ 6: E-COMMERCE E2E ---
  static const shopLoginScreen = 'shop_login_screen';
  static const shopLoginEmailInput = 'shop_login_email_input';
  static const shopLoginPasswordInput = 'shop_login_password_input';
  static const shopLoginRememberCheckbox = 'shop_login_remember_checkbox';
  static const shopLoginSubmitBtn = 'shop_login_submit_btn';
  static const shopLoginErrorText = 'shop_login_error_text';
  static const shopLoginQuickFillBtn = 'shop_login_quick_fill_btn';

  static const shopCatalogScreen = 'shop_catalog_screen';
  static const shopCatalogSearchInput = 'shop_catalog_search_input';
  static const shopCatalogFilterChipPrefix = 'shop_catalog_filter_';
  static const shopCatalogSortDropdown = 'shop_catalog_sort_dropdown';
  static const shopCatalogCartBadge = 'shop_catalog_cart_badge';
  static const shopCatalogCartBtn = 'shop_catalog_cart_btn';
  static String shopProductCard(String id) => 'shop_product_card_$id';
  static String shopProductAddBtn(String id) => 'shop_product_add_btn_$id';

  static const shopCartScreen = 'shop_cart_screen';
  static const shopCartItemsList = 'shop_cart_items_list';
  static String shopCartItem(String id) => 'shop_cart_item_$id';
  static String shopCartQtyIncrease(String id) => 'shop_cart_qty_increase_$id';
  static String shopCartQtyDecrease(String id) => 'shop_cart_qty_decrease_$id';
  static String shopCartItemDelete(String id) => 'shop_cart_item_delete_$id';
  static const shopCartCouponInput = 'shop_cart_coupon_input';
  static const shopCartCouponApplyBtn = 'shop_cart_coupon_apply_btn';
  static const shopCartCouponBadge = 'shop_cart_coupon_badge';
  static const shopCartSubtotalText = 'shop_cart_subtotal_text';
  static const shopCartDiscountText = 'shop_cart_discount_text';
  static const shopCartTotalText = 'shop_cart_total_text';
  static const shopCartCheckoutBtn = 'shop_cart_checkout_btn';

  static const shopCheckoutScreen = 'shop_checkout_screen';
  static const shopCheckoutStepper = 'shop_checkout_stepper';
  // Krok 1: Adres
  static const shopCheckoutNameInput = 'shop_checkout_name_input';
  static const shopCheckoutStreetInput = 'shop_checkout_street_input';
  static const shopCheckoutZipInput = 'shop_checkout_zip_input';
  static const shopCheckoutCityInput = 'shop_checkout_city_input';
  // Krok 2: Dostawa
  static const shopCheckoutDeliveryCourierRadio = 'shop_checkout_delivery_courier';
  static const shopCheckoutDeliveryLockerRadio = 'shop_checkout_delivery_locker';
  // Krok 3: Płatność
  static const shopCheckoutPaymentCardRadio = 'shop_checkout_payment_card';
  static const shopCheckoutPaymentBlikRadio = 'shop_checkout_payment_blik';
  static const shopCheckoutBlikCodeInput = 'shop_checkout_blik_code_input';
  // Stepper nawigacja
  static const shopCheckoutNextBtn = 'shop_checkout_next_btn';
  static const shopCheckoutBackBtn = 'shop_checkout_back_btn';
  static const shopCheckoutPlaceOrderBtn = 'shop_checkout_place_order_btn';

  static const shopOrderSuccessScreen = 'shop_order_success_screen';
  static const shopOrderIdText = 'shop_order_id_text';
  static const shopOrderSuccessHomeBtn = 'shop_order_success_home_btn';

  // --- MODUŁ 7: DEVICE & SYSTEM INTEGRATIONS ---
  static const deviceScreen = 'device_screen';
  static const deviceReqLocationBtn = 'device_req_location_btn';
  static const deviceLocationStatusText = 'device_location_status_text';
  static const deviceReqCameraBtn = 'device_req_camera_btn';
  static const deviceCameraStatusText = 'device_camera_status_text';
  static const deviceReqBiometricsBtn = 'device_req_biometrics_btn';
  static const deviceBiometricsStatusText = 'device_biometrics_status_text';
  static const deviceMockNotificationBtn = 'device_mock_notification_btn';
  static const deviceNotificationBanner = 'device_notification_banner';
  static const deviceNetworkToggle = 'device_network_toggle';
  static const deviceOfflineWarningBanner = 'device_offline_warning_banner';

  // --- MODUŁ 8: DOSTĘPNOŚĆ & EDGE CASES ---
  static const a11yScreen = 'a11y_screen';
  static const a11yLanguageToggleBtn = 'a11y_language_toggle_btn';
  static const a11yCurrentDirectionText = 'a11y_current_direction_text';
  static const a11yHighContrastToggle = 'a11y_high_contrast_toggle';
  static const a11ySemanticsCard = 'a11y_semantics_card';
  static const a11yCustomPaintArea = 'a11y_custom_paint_area';

  // --- WBUDOWANY INSPECTOR / CHEAT PANEL ---
  static const inspectorOverlayPanel = 'inspector_overlay_panel';
  static const inspectorCloseBtn = 'inspector_close_btn';
  static const inspectorActiveScreenText = 'inspector_active_screen_text';
  static const inspectorKeyList = 'inspector_key_list';
}
