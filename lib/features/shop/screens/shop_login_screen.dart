import 'package:flutter/material.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/testable_widget.dart';
import '../../../dev_tools/test_inspector_overlay.dart';

class ShopLoginScreen extends StatefulWidget {
  const ShopLoginScreen({super.key});

  @override
  State<ShopLoginScreen> createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  String? _errorMessage;
  int _failedAttempts = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _quickFill() {
    setState(() {
      _emailController.text = 'tester@example.com';
      _passwordController.text = 'Password123!';
      _errorMessage = null;
    });
  }

  void _handleLogin() {
    if (_failedAttempts >= 3) {
      setState(() {
        _errorMessage = 'Konto zostało zablokowane z powodu 3 nieudanych prób logowania!';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Akceptowane dane logowania
      if (email == 'tester@example.com' && password == 'Password123!') {
        setState(() => _errorMessage = null);
        Navigator.of(context).pushReplacementNamed(AppRoutes.shopCatalog);
      } else {
        setState(() {
          _failedAttempts++;
          _errorMessage = 'Niepoprawny e-mail lub hasło (Próba $_failedAttempts z 3)';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.shopLoginEmailInput,
      AppKeys.shopLoginPasswordInput,
      AppKeys.shopLoginRememberCheckbox,
      AppKeys.shopLoginSubmitBtn,
      AppKeys.shopLoginQuickFillBtn,
      AppKeys.shopLoginErrorText,
    ];

    return TestInspectorOverlay(
      currentRoute: '/shop/login',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.shopLoginScreen),
        appBar: AppBar(title: const Text('Sklep E2E: Logowanie')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.shopping_bag, size: 60, color: Colors.indigo),
                      const SizedBox(height: 12),
                      const Text(
                        'Zaloguj się do Sklepu QA',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Moduł testowania pełnego przepływu E2E',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: TestableWidget(
                            keyId: AppKeys.shopLoginErrorText,
                            semanticLabel: _errorMessage!,
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      TestableWidget(
                        keyId: AppKeys.shopLoginEmailInput,
                        semanticLabel: 'Adres E-mail',
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Adres E-mail',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (v) => (v == null || !v.contains('@')) ? 'Podaj poprawny e-mail' : null,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TestableWidget(
                        keyId: AppKeys.shopLoginPasswordInput,
                        semanticLabel: 'Hasło',
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Hasło',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (v) => (v == null || v.length < 6) ? 'Hasło musi mieć min. 6 znaków' : null,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TestableWidget(
                        keyId: AppKeys.shopLoginRememberCheckbox,
                        semanticLabel: 'Zapamiętaj mnie na tym urządzeniu',
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Zapamiętaj mnie na tym urządzeniu'),
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val ?? false),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TestableWidget(
                        keyId: AppKeys.shopLoginSubmitBtn,
                        semanticLabel: 'Zaloguj się',
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _handleLogin,
                          child: const Text('Zaloguj się', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TestableWidget(
                        keyId: AppKeys.shopLoginQuickFillBtn,
                        semanticLabel: 'Autouzupełnij poprawne dane',
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.auto_fix_high),
                          label: const Text('Autouzupełnij poprawne dane'),
                          onPressed: _quickFill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
