/// API base URL used by the client.
/// For Android emulator, use http://10.0.2.2:8000
/// For iOS simulator, use http://127.0.0.1:8000
/// For physical devices, use your machine's LAN IP, e.g. http://192.168.1.10:8000
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
