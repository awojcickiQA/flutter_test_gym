import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // Stan uprawnień
  String _locationStatus = 'Nie zapytano (Unknown)';
  String _cameraStatus = 'Nie zapytano (Unknown)';
  String _biometricsStatus = 'Oczekuje na autoryzację';

  // Stan sieci
  bool _isOnline = true;

  // Powiadomienie
  bool _showNotificationBanner = false;

  void _requestPermission(String type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Uprawnienie systemowe: $type'),
        content: Text('Aplikacja prosi o dostęp do: $type. Czy zezwalasz na dostęp?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                if (type == 'Lokalizacja') _locationStatus = 'Odrzucono (Denied)';
                if (type == 'Aparat') _cameraStatus = 'Odrzucono (Denied)';
              });
            },
            child: const Text('Odmów'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                if (type == 'Lokalizacja') _locationStatus = 'Przyznano (Granted: 52.2297° N, 21.0122° E)';
                if (type == 'Aparat') _cameraStatus = 'Przyznano (Granted: Aparat gotowy)';
              });
            },
            child: const Text('Zezwól podczas używania'),
          ),
        ],
      ),
    );
  }

  void _triggerBiometrics() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.fingerprint, size: 28, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Autoryzacja Biometryczna'),
          ],
        ),
        content: const Text('Przytknij palec do czytnika lub spójrz w obiektyw (FaceID / Fingerprint).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _biometricsStatus = 'Błąd: Nie rozpoznano odcisku / Anulowano');
            },
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _biometricsStatus = 'Sukces: Zalogowano biometrycznie (FaceID potwierdzone)');
            },
            child: const Text('Symuluj poprawny skan'),
          ),
        ],
      ),
    );
  }

  void _sendNotification() {
    setState(() => _showNotificationBanner = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showNotificationBanner = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.deviceReqLocationBtn,
      AppKeys.deviceLocationStatusText,
      AppKeys.deviceReqCameraBtn,
      AppKeys.deviceCameraStatusText,
      AppKeys.deviceReqBiometricsBtn,
      AppKeys.deviceBiometricsStatusText,
      AppKeys.deviceMockNotificationBtn,
      AppKeys.deviceNotificationBanner,
      AppKeys.deviceNetworkToggle,
      AppKeys.deviceOfflineWarningBanner,
    ];

    return TestInspectorOverlay(
      currentRoute: '/device',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.deviceScreen),
        appBar: AppBar(title: const Text('Integracje Systemowe & Device (Patrol/Appium)')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Powiadomienie push symulowane
              if (_showNotificationBanner) ...[
                TestableWidget(
                  keyId: AppKeys.deviceNotificationBanner,
                  semanticLabel: 'Nowe powiadomienie Push: Twój kod weryfikacyjny to 883-102',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade800,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.notifications_active, color: Colors.amber),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nowe powiadomienie Push', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('Twój kod weryfikacyjny to 883-102', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Stan sieci i tryb offline
              if (!_isOnline) ...[
                TestableWidget(
                  keyId: AppKeys.deviceOfflineWarningBanner,
                  semanticLabel: 'Tryb OFFLINE aktywny: Brak połączenia z serwerem!',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tryb OFFLINE aktywny: Brak połączenia z serwerem!',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 1. Uprawnienia systemowe
              _buildSectionTitle('1. Uprawnienia Systemowe (Permissions - Patrol/Appium)'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Lokalizacja GPS:'),
                          TestableWidget(
                            keyId: AppKeys.deviceReqLocationBtn,
                            semanticLabel: 'Poproś o dostęp do lokalizacji',
                            child: ElevatedButton(
                              onPressed: () => _requestPermission('Lokalizacja'),
                              child: const Text('Poproś o dostęp'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TestableWidget(
                          keyId: AppKeys.deviceLocationStatusText,
                          semanticLabel: 'Status: $_locationStatus',
                          child: Text(
                            'Status: $_locationStatus',
                            style: TextStyle(
                              fontSize: 12,
                              color: _locationStatus.contains('Przyznano') ? Colors.green : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Aparat fotograficzny:'),
                          TestableWidget(
                            keyId: AppKeys.deviceReqCameraBtn,
                            semanticLabel: 'Poproś o dostęp do aparatu',
                            child: ElevatedButton(
                              onPressed: () => _requestPermission('Aparat'),
                              child: const Text('Poproś o dostęp'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TestableWidget(
                          keyId: AppKeys.deviceCameraStatusText,
                          semanticLabel: 'Status: $_cameraStatus',
                          child: Text(
                            'Status: $_cameraStatus',
                            style: TextStyle(
                              fontSize: 12,
                              color: _cameraStatus.contains('Przyznano') ? Colors.green : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Biometria
              _buildSectionTitle('2. Biometria (FaceID / Fingerprint Mock)'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TestableWidget(
                        keyId: AppKeys.deviceReqBiometricsBtn,
                        semanticLabel: 'Wywołaj autoryzację biometryczną',
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Wywołaj autoryzację biometryczną'),
                          onPressed: _triggerBiometrics,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TestableWidget(
                        keyId: AppKeys.deviceBiometricsStatusText,
                        semanticLabel: 'Status biometrii: $_biometricsStatus',
                        child: Text(
                          'Status biometrii: $_biometricsStatus',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _biometricsStatus.contains('Sukces')
                                ? Colors.green
                                : _biometricsStatus.contains('Błąd')
                                    ? Colors.red
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Powiadomienia lokalne
              _buildSectionTitle('3. Powiadomienia Lokalne & Push'),
              const SizedBox(height: 8),
              TestableWidget(
                keyId: AppKeys.deviceMockNotificationBtn,
                semanticLabel: 'Wyślij powiadomienie testowe',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send_to_mobile),
                  label: const Text('Wyślij powiadomienie testowe'),
                  onPressed: _sendNotification,
                ),
              ),
              const SizedBox(height: 20),

              // 4. Przełącznik stanu sieci
              _buildSectionTitle('4. Stan Połączenia Sieciowego'),
              const SizedBox(height: 8),
              TestableWidget(
                keyId: AppKeys.deviceNetworkToggle,
                semanticLabel: _isOnline ? 'Internet dostępny (Online)' : 'Brak internetu (Offline)',
                child: SwitchListTile(
                  title: Text(_isOnline ? 'Internet dostępny (Online)' : 'Brak internetu (Offline)'),
                  value: _isOnline,
                  onChanged: (val) => setState(() => _isOnline = val),
                ),
              ),
              const SizedBox(height: 20),

              // 5. WebView Mock (Hybrid Testing)
              _buildSectionTitle('5. Kontener Hybrydowy (Symulacja WebView)'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.language, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Kontekst WEBVIEW (Hybrid Context)', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'W testach Appium ten blok symuluje komponent WebView. '
                      'Narzędzie musi wykonać przełączenie kontekstu: driver.switch_to.context("WEBVIEW_com.example.app").',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo),
    );
  }
}
