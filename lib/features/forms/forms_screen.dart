import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kontrolery pól
  final _standardController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _multilineController = TextEditingController();

  bool _obscurePassword = true;
  String? _asyncUsernameStatus;
  bool _isCheckingUsername = false;
  Timer? _debounceTimer;

  // Kontrolki wyboru
  bool _newsletterChecked = false;
  bool _termsChecked = false;
  bool? _tristateValue = null; // null = stan częściowy
  String _selectedRadio = 'Option 1';
  bool _switchNotifications = true;
  double _volumeSlider = 40.0;
  RangeValues _priceRange = const RangeValues(20.0, 80.0);
  String _selectedCountry = 'Polska';
  String _selectedPriority = 'Średni';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Dynamiczne pola
  final List<TextEditingController> _dynamicControllers = [];

  bool _formSubmitted = false;

  @override
  void dispose() {
    _standardController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cardNumberController.dispose();
    _usernameController.dispose();
    _multilineController.dispose();
    for (var c in _dynamicControllers) {
      c.dispose();
    }
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _debounceTimer?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _isCheckingUsername = false;
        _asyncUsernameStatus = null;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _asyncUsernameStatus = 'Sprawdzanie dostępności...';
    });

    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isCheckingUsername = false;
        if (value.toLowerCase() == 'admin' || value.toLowerCase() == 'tester') {
          _asyncUsernameStatus = 'Błąd: Login "$value" jest już zajęty!';
        } else {
          _asyncUsernameStatus = 'Sukces: Login "$value" jest wolny!';
        }
      });
    });
  }

  void _addDynamicField() {
    setState(() {
      _dynamicControllers.add(TextEditingController());
    });
  }

  void _removeDynamicField(int index) {
    setState(() {
      _dynamicControllers[index].dispose();
      _dynamicControllers.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_termsChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Musisz zaakceptować regulamin!')),
        );
        return;
      }
      setState(() {
        _formSubmitted = true;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _standardController.clear();
    _emailController.clear();
    _passwordController.clear();
    _cardNumberController.clear();
    _usernameController.clear();
    _multilineController.clear();
    for (var c in _dynamicControllers) {
      c.dispose();
    }
    setState(() {
      _dynamicControllers.clear();
      _newsletterChecked = false;
      _termsChecked = false;
      _tristateValue = null;
      _selectedRadio = 'Option 1';
      _switchNotifications = true;
      _volumeSlider = 40.0;
      _priceRange = const RangeValues(20.0, 80.0);
      _selectedCountry = 'Polska';
      _selectedPriority = 'Średni';
      _selectedDate = null;
      _selectedTime = null;
      _asyncUsernameStatus = null;
      _formSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.formsStandardInput,
      AppKeys.formsEmailInput,
      AppKeys.formsPasswordInput,
      AppKeys.formsPasswordToggleBtn,
      AppKeys.formsCardNumberInput,
      AppKeys.formsAsyncUsernameInput,
      AppKeys.formsMultilineInput,
      AppKeys.formsDisabledInput,
      AppKeys.formsReadonlyInput,
      AppKeys.formsCheckboxNewsletter,
      AppKeys.formsCheckboxTerms,
      AppKeys.formsCheckboxTristate,
      AppKeys.formsRadioOption1,
      AppKeys.formsRadioOption2,
      AppKeys.formsSwitchNotifications,
      AppKeys.formsSliderVolume,
      AppKeys.formsRangeSliderPrice,
      AppKeys.formsDropdownCountry,
      AppKeys.formsDatePickerBtn,
      AppKeys.formsTimePickerBtn,
      AppKeys.formsAddDynamicFieldBtn,
      AppKeys.formsSubmitBtn,
      AppKeys.formsResetBtn,
      AppKeys.formsSuccessBanner,
    ];

    return TestInspectorOverlay(
      currentRoute: '/forms',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.formsScreen),
        appBar: AppBar(
          title: const Text('Formularze & Kontrolki'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_formSubmitted) ...[
                  TestableWidget(
                    keyId: AppKeys.formsSuccessBanner,
                    semanticLabel: 'Formularz przesłany pomyślnie',
                    child: Card(
                      color: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'Formularz pomyślnie zatwierdzony!',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('E-mail: ${_emailController.text}'),
                            Text('Kraj: $_selectedCountry'),
                            Text('Priorytet: $_selectedPriority'),
                            Text('Głośność: ${_volumeSlider.round()}%'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Sekcja: Pola Tekstowe
                _buildSectionHeader('1. Pola Tekstowe i Maskowanie'),
                const SizedBox(height: 8),

                TestableWidget(
                  keyId: AppKeys.formsStandardInput,
                  semanticLabel: 'Standardowy tekst',
                  child: TextFormField(
                    controller: _standardController,
                    decoration: const InputDecoration(
                      labelText: 'Standardowy tekst',
                      hintText: 'Wpisz dowolny tekst...',
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TestableWidget(
                  keyId: AppKeys.formsEmailInput,
                  semanticLabel: 'Adres e-mail',
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adres e-mail *',
                      hintText: 'np. jan@example.com',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pole e-mail jest wymagane';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Wprowadź poprawny adres e-mail';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),

                TestableWidget(
                  keyId: AppKeys.formsPasswordInput,
                  semanticLabel: 'Hasło',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Hasło *',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: TestableWidget(
                        keyId: AppKeys.formsPasswordToggleBtn,
                        child: IconButton(
                          tooltip: _obscurePassword ? 'Pokaż hasło' : 'Ukryj hasło',
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Hasło musi mieć minimum 6 znaków';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Numer karty z maskowaniem
                TestableWidget(
                  keyId: AppKeys.formsCardNumberInput,
                  semanticLabel: 'Numer karty kredytowej',
                  child: TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    decoration: const InputDecoration(
                      labelText: 'Numer karty kredytowej (XXXX-XXXX-XXXX-XXXX)',
                      prefixIcon: Icon(Icons.credit_card),
                      counterText: '',
                    ),
                    onChanged: (text) {
                      final digits = text.replaceAll('-', '').replaceAll(' ', '');
                      final buffer = StringBuffer();
                      for (int i = 0; i < digits.length; i++) {
                        if (i > 0 && i % 4 == 0) buffer.write('-');
                        buffer.write(digits[i]);
                      }
                      final formatted = buffer.toString();
                      if (formatted != text) {
                        _cardNumberController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Asynchroniczne sprawdzanie loginu
                TestableWidget(
                  keyId: AppKeys.formsAsyncUsernameInput,
                  semanticLabel: 'Unikalna nazwa użytkownika',
                  child: TextFormField(
                    controller: _usernameController,
                    onChanged: _onUsernameChanged,
                    decoration: InputDecoration(
                      labelText: 'Login (asynchroniczna walidacja: "admin" i "tester" zajęte)',
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: _isCheckingUsername
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                if (_asyncUsernameStatus != null) ...[
                  const SizedBox(height: 4),
                  TestableWidget(
                    keyId: AppKeys.formsAsyncStatusIndicator,
                    semanticLabel: _asyncUsernameStatus,
                    child: Text(
                      _asyncUsernameStatus!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _asyncUsernameStatus!.contains('Błąd')
                            ? Colors.red
                            : _asyncUsernameStatus!.contains('Sukces')
                                ? Colors.green
                                : Colors.orange,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                TestableWidget(
                  keyId: AppKeys.formsMultilineInput,
                  semanticLabel: 'Wielolinijkowy opis',
                  child: TextFormField(
                    controller: _multilineController,
                    maxLines: 3,
                    maxLength: 150,
                    decoration: const InputDecoration(
                      labelText: 'Wielolinijkowy opis / notatki',
                      hintText: 'Możesz wpisać kilka wierszy tekstu...',
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsDisabledInput,
                        child: TextFormField(
                          initialValue: 'Pole zablokowane',
                          enabled: false,
                          decoration: const InputDecoration(labelText: 'Pole wyłączone (disabled)'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsReadonlyInput,
                        child: TextFormField(
                          initialValue: 'Tylko do odczytu',
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Tylko odczyt (readOnly)'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sekcja: Kontrolki Wyboru
                _buildSectionHeader('2. Kontrolki Wyboru (Checkboxy, Radio, Switch)'),
                const SizedBox(height: 8),

                TestableWidget(
                  keyId: AppKeys.formsCheckboxNewsletter,
                  child: CheckboxListTile(
                    title: const Text('Zapisz mnie na newsletter'),
                    value: _newsletterChecked,
                    onChanged: (val) => setState(() => _newsletterChecked = val ?? false),
                  ),
                ),
                TestableWidget(
                  keyId: AppKeys.formsCheckboxTerms,
                  child: CheckboxListTile(
                    title: const Text('Akceptuję regulamin i warunki *'),
                    value: _termsChecked,
                    onChanged: (val) => setState(() => _termsChecked = val ?? false),
                  ),
                ),
                TestableWidget(
                  keyId: AppKeys.formsCheckboxTristate,
                  child: CheckboxListTile(
                    tristate: true,
                    title: const Text('Powiadomienia grupowe (Trójstanowy: Tak/Nie/Częściowo)'),
                    subtitle: Text('Stan: ${_tristateValue == null ? "Częściowy" : (_tristateValue! ? "Wszystkie" : "Brak")}'),
                    value: _tristateValue,
                    onChanged: (val) => setState(() => _tristateValue = val),
                  ),
                ),
                const SizedBox(height: 8),

                const Text('Wybierz metodę dostawy (Radio):', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsRadioOption1,
                        child: RadioListTile<String>(
                          title: const Text('Kurier'),
                          value: 'Option 1',
                          groupValue: _selectedRadio,
                          onChanged: (val) => setState(() => _selectedRadio = val!),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsRadioOption2,
                        child: RadioListTile<String>(
                          title: const Text('Paczkomat'),
                          value: 'Option 2',
                          groupValue: _selectedRadio,
                          onChanged: (val) => setState(() => _selectedRadio = val!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                TestableWidget(
                  keyId: AppKeys.formsSwitchNotifications,
                  child: SwitchListTile(
                    title: const Text('Włącz powiadomienia dźwiękowe'),
                    value: _switchNotifications,
                    onChanged: (val) => setState(() => _switchNotifications = val),
                  ),
                ),
                const SizedBox(height: 16),
                // Sekcja: Suwaki
                _buildSectionHeader('3. Suwaki i Zakresy (Sliders)'),
                const SizedBox(height: 8),
                Text('Poziom głośności: ${_volumeSlider.round()}%'),
                ExcludeSemantics(
                  child: Slider(
                    value: _volumeSlider,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_volumeSlider.round()}',
                    onChanged: (val) => setState(() => _volumeSlider = val),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Zakres cenowy: ${_priceRange.start.round()} PLN - ${_priceRange.end.round()} PLN'),
                ExcludeSemantics(
                  child: RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels('${_priceRange.start.round()}', '${_priceRange.end.round()}'),
                    onChanged: (vals) => setState(() => _priceRange = vals),
                  ),
                ),
                const SizedBox(height: 16),

                // Sekcja: Listy Rozwijane i Przyciski Segmentowe
                _buildSectionHeader('4. Dropdown i SegmentedButton'),
                const SizedBox(height: 8),
                TestableWidget(
                  keyId: AppKeys.formsDropdownCountry,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: const InputDecoration(labelText: 'Kraj wysyłki'),
                    items: const [
                      DropdownMenuItem(value: 'Polska', child: Text('Polska')),
                      DropdownMenuItem(value: 'Niemcy', child: Text('Niemcy')),
                      DropdownMenuItem(value: 'Wielka Brytania', child: Text('Wielka Brytania')),
                      DropdownMenuItem(value: 'USA', child: Text('USA')),
                    ],
                    onChanged: (val) => setState(() => _selectedCountry = val!),
                  ),
                ),
                const SizedBox(height: 12),

                const Text('Priorytet zgłoszenia:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TestableWidget(
                  keyId: AppKeys.formsSegmentedPriority,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Niski', label: Text('Niski')),
                      ButtonSegment(value: 'Średni', label: Text('Średni')),
                      ButtonSegment(value: 'Wysoki', label: Text('Wysoki')),
                    ],
                    selected: {_selectedPriority},
                    onSelectionChanged: (set) => setState(() => _selectedPriority = set.first),
                  ),
                ),
                const SizedBox(height: 16),

                // Sekcja: Date & Time Pickers
                _buildSectionHeader('5. Wybór Daty i Godziny (Pickers)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsDatePickerBtn,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Wybierz Datę'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsTimePickerBtn,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('Wybierz Czas'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) setState(() => _selectedTime = picked);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wybrana data: ${_selectedDate == null ? "Brak" : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"}',
                      key: const Key(AppKeys.formsSelectedDateText),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Godzina: ${_selectedTime == null ? "Brak" : _selectedTime!.format(context)}',
                      key: const Key(AppKeys.formsSelectedTimeText),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sekcja: Dynamiczne Pola Formularza
                _buildSectionHeader('6. Dynamiczne Pola Formularza (Form Arrays)'),
                const SizedBox(height: 8),
                TestableWidget(
                  keyId: AppKeys.formsAddDynamicFieldBtn,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Dodaj kolejną uwagę do formularza'),
                    onPressed: _addDynamicField,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    for (int index = 0; index < _dynamicControllers.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: Key('forms_dynamic_input_$index'),
                                controller: _dynamicControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Uwaga #${index + 1}',
                                  hintText: 'Wpisz dodatkowy komentarz...',
                                ),
                              ),
                            ),
                            IconButton(
                              key: Key('forms_dynamic_remove_btn_$index'),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeDynamicField(index),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Przyciski akcji
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TestableWidget(
                        keyId: AppKeys.formsSubmitBtn,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text('Zatwierdź Formularz', style: TextStyle(fontSize: 16)),
                          onPressed: _submitForm,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TestableWidget(
                        keyId: AppKeys.formsResetBtn,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _resetForm,
                          child: const Text('Resetuj'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
      ),
    );
  }
}
