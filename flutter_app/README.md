## Flutter Payroll HR App

This is a simple Flutter client for the Flask backend.

### Prerequisites
- Flutter SDK 3.22+
- An Android emulator or iOS simulator/device

### Initialize project (if platforms missing)
Inside `flutter_app`:
```bash
flutter create .
```

### Configure API base URL
Default base URL is `http://10.0.2.2:8000` for Android emulator.
Change it via `--dart-define`:
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
```

### Install dependencies
```bash
flutter pub get
```

### Run
Make sure the Flask backend is running on port 8000.
```bash
flutter run
```

### Android permissions and HTTP
Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```
Inside `<application ...>` enable cleartext for local HTTP during dev:
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
    <!-- existing -->
</application>
```

### iOS permissions and HTTP (dev only)
Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is used for clock-in.</string>
```
For plain HTTP during development, add ATS exception or use HTTPS:
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <!-- Prefer domain-specific exceptions in real apps -->
</dict>
```

### Notes
- Location permission is requested on the Clock In page.
- Endpoints are rough demos and expect simple inputs.
