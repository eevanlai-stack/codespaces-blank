import 'package:flutter/material.dart';

import 'api_client.dart';
import 'config.dart';
import 'pages.dart';

void main() {
  runApp(const PayrollApp());
}

class PayrollApp extends StatelessWidget {
  const PayrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient(baseUrl: apiBaseUrl);
    return MaterialApp(
      title: 'Payroll HR',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: HomeScreen(api: api),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api});
  final ApiClient api;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      EpfPage(api: widget.api),
      PerkesoPage(api: widget.api),
      PcbPage(api: widget.api),
      ClockInPage(api: widget.api),
      AttendancePage(api: widget.api),
      PayrollPage(api: widget.api),
      AdvancePage(api: widget.api),
      ProfilePage(api: widget.api),
      ChatPage(api: widget.api),
      TranslatePage(api: widget.api),
    ];

    final items = const [
      BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'EPF'),
      BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'PERKESO'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'PCB'),
      BottomNavigationBarItem(icon: Icon(Icons.punch_clock), label: 'Clock'),
      BottomNavigationBarItem(icon: Icon(Icons.fact_check), label: 'Attend'),
      BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payroll'),
      BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Advance'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Translate'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Payroll HR Demo')),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

