import 'package:flutter/material.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/testable_widget.dart';
import '../../../dev_tools/test_inspector_overlay.dart';
import '../controllers/shop_state.dart';

class ShopCheckoutScreen extends StatefulWidget {
  const ShopCheckoutScreen({super.key});

  @override
  State<ShopCheckoutScreen> createState() => _ShopCheckoutScreenState();
}

class _ShopCheckoutScreenState extends State<ShopCheckoutScreen> {
  final _state = ShopState.instance;
  int _currentStep = 0;

  // Formularze kroków
  final _addressFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();

  // Krok 2: Dostawa
  String _deliveryMethod = 'courier';

  // Krok 3: Płatność
  String _paymentMethod = 'card';
  final _blikController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _blikController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_addressFormKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_paymentMethod == 'blik' && _blikController.text.trim().length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wprowadź poprawny 6-cyfrowy kod BLIK!')),
        );
        return;
      }

      // Finalizacja zamówienia
      final orderId = _state.checkout();
      Navigator.of(context).pushReplacementNamed(AppRoutes.shopSuccess);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.shopCheckoutStepper,
      AppKeys.shopCheckoutNameInput,
      AppKeys.shopCheckoutStreetInput,
      AppKeys.shopCheckoutZipInput,
      AppKeys.shopCheckoutCityInput,
      AppKeys.shopCheckoutDeliveryCourierRadio,
      AppKeys.shopCheckoutDeliveryLockerRadio,
      AppKeys.shopCheckoutPaymentCardRadio,
      AppKeys.shopCheckoutPaymentBlikRadio,
      AppKeys.shopCheckoutBlikCodeInput,
      AppKeys.shopCheckoutNextBtn,
      AppKeys.shopCheckoutBackBtn,
      AppKeys.shopCheckoutPlaceOrderBtn,
    ];

    return TestInspectorOverlay(
      currentRoute: '/shop/checkout',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.shopCheckoutScreen),
        appBar: AppBar(title: const Text('Kasa (Checkout Multi-Step)')),
        body: Stepper(
          key: const Key(AppKeys.shopCheckoutStepper),
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            final isLastStep = _currentStep == 2;
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  TestableWidget(
                    keyId: isLastStep ? AppKeys.shopCheckoutPlaceOrderBtn : AppKeys.shopCheckoutNextBtn,
                    semanticLabel: isLastStep ? 'Złóż zamówienie i zapłać' : 'Dalej',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastStep ? Colors.green.shade700 : Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(isLastStep ? 'Złóż zamówienie i zapłać' : 'Dalej'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TestableWidget(
                    keyId: AppKeys.shopCheckoutBackBtn,
                    semanticLabel: _currentStep == 0 ? 'Wróć do koszyka' : 'Wstecz',
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text(_currentStep == 0 ? 'Wróć do koszyka' : 'Wstecz'),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Krok 1: Adres
            Step(
              title: const Text('Dane adresowe'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    TestableWidget(
                      keyId: AppKeys.shopCheckoutNameInput,
                      semanticLabel: 'Imię i Nazwisko',
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Imię i Nazwisko *'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Wymagane pole' : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TestableWidget(
                      keyId: AppKeys.shopCheckoutStreetInput,
                      semanticLabel: 'Ulica i numer',
                      child: TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Ulica i numer *'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Wymagane pole' : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TestableWidget(
                            keyId: AppKeys.shopCheckoutZipInput,
                            semanticLabel: 'Kod pocztowy',
                            child: TextFormField(
                              controller: _zipController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Kod pocztowy (00-000) *'),
                              validator: (v) => (v == null || !RegExp(r'^\d{2}-\d{3}$').hasMatch(v)) ? 'Format 00-000' : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TestableWidget(
                            keyId: AppKeys.shopCheckoutCityInput,
                            semanticLabel: 'Miejscowość',
                            child: TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(labelText: 'Miejscowość *'),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wymagane pole' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Krok 2: Dostawa
            Step(
              title: const Text('Sposób dostawy'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TestableWidget(
                    keyId: AppKeys.shopCheckoutDeliveryCourierRadio,
                    semanticLabel: 'Kurier Express',
                    child: RadioListTile<String>(
                      title: const Text('Kurier Express (1-2 dni robocze)'),
                      subtitle: const Text('15.00 PLN'),
                      value: 'courier',
                      groupValue: _deliveryMethod,
                      onChanged: (val) => setState(() => _deliveryMethod = val!),
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.shopCheckoutDeliveryLockerRadio,
                    semanticLabel: 'Paczkomat 24/7',
                    child: RadioListTile<String>(
                      title: const Text('Paczkomat 24/7'),
                      subtitle: const Text('11.99 PLN'),
                      value: 'locker',
                      groupValue: _deliveryMethod,
                      onChanged: (val) => setState(() => _deliveryMethod = val!),
                    ),
                  ),
                ],
              ),
            ),

            // Krok 3: Płatność
            Step(
              title: const Text('Metoda płatności'),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  TestableWidget(
                    keyId: AppKeys.shopCheckoutPaymentCardRadio,
                    semanticLabel: 'Karta płatnicza',
                    child: RadioListTile<String>(
                      title: const Text('Karta płatnicza (Visa / Mastercard)'),
                      value: 'card',
                      groupValue: _paymentMethod,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.shopCheckoutPaymentBlikRadio,
                    semanticLabel: 'Płatność kodem BLIK',
                    child: RadioListTile<String>(
                      title: const Text('Płatność kodem BLIK'),
                      value: 'blik',
                      groupValue: _paymentMethod,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                  ),
                  if (_paymentMethod == 'blik') ...[
                    const SizedBox(height: 8),
                    TestableWidget(
                      keyId: AppKeys.shopCheckoutBlikCodeInput,
                      semanticLabel: 'Wpisz 6-cyfrowy kod BLIK',
                      child: TextField(
                        controller: _blikController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: 'Wpisz 6-cyfrowy kod BLIK',
                          hintText: '123456',
                          prefixIcon: Icon(Icons.security),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
