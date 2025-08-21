import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'api_client.dart';

class EpfPage extends StatefulWidget {
  const EpfPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<EpfPage> createState() => _EpfPageState();
}

class _EpfPageState extends State<EpfPage> {
  final TextEditingController _salary = TextEditingController(text: '5000');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final salary = double.tryParse(_salary.text.trim());
      if (salary == null) throw 'Invalid salary';
      final res = await widget.api.epf(salary);
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'EPF',
      fields: [
        _NumField(controller: _salary, label: 'Salary'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class PerkesoPage extends StatefulWidget {
  const PerkesoPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<PerkesoPage> createState() => _PerkesoPageState();
}

class _PerkesoPageState extends State<PerkesoPage> {
  final TextEditingController _salary = TextEditingController(text: '5000');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final salary = double.tryParse(_salary.text.trim());
      if (salary == null) throw 'Invalid salary';
      final res = await widget.api.perkeso(salary);
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'PERKESO',
      fields: [
        _NumField(controller: _salary, label: 'Salary'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class PcbPage extends StatefulWidget {
  const PcbPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<PcbPage> createState() => _PcbPageState();
}

class _PcbPageState extends State<PcbPage> {
  final TextEditingController _salary = TextEditingController(text: '5000');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final salary = double.tryParse(_salary.text.trim());
      if (salary == null) throw 'Invalid salary';
      final res = await widget.api.pcb(salary);
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'PCB',
      fields: [
        _NumField(controller: _salary, label: 'Salary'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  final TextEditingController _employeeId = TextEditingController(text: 'E001');
  String _result = '';
  Position? _position;
  bool _loading = false;

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _result = 'Location services are disabled');
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _result = 'Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() => _result = 'Location permissions are permanently denied');
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() => _position = pos);
  }

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      await _getLocation();
      final res = await widget.api.clockIn(_employeeId.text.trim());
      setState(() => _result = 'Clocked in. ${res.toString()}\nLocation: ${_position?.latitude}, ${_position?.longitude}');
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Clock In',
      fields: [
        _TextField(controller: _employeeId, label: 'Employee ID'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.api});
  final ApiClient api;
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TextEditingController _employeeId = TextEditingController(text: 'E001');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.attendance(_employeeId.text.trim());
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Attendance',
      fields: [
        _TextField(controller: _employeeId, label: 'Employee ID'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  final TextEditingController _employeeId = TextEditingController(text: 'E001');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.payroll(_employeeId.text.trim());
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Payroll',
      fields: [
        _TextField(controller: _employeeId, label: 'Employee ID'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class AdvancePage extends StatefulWidget {
  const AdvancePage({super.key, required this.api});
  final ApiClient api;
  @override
  State<AdvancePage> createState() => _AdvancePageState();
}

class _AdvancePageState extends State<AdvancePage> {
  final TextEditingController _employeeId = TextEditingController(text: 'E001');
  final TextEditingController _amount = TextEditingController(text: '200');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final amount = double.tryParse(_amount.text.trim());
      if (amount == null) throw 'Invalid amount';
      final res = await widget.api.advance(_employeeId.text.trim(), amount);
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Advance',
      fields: [
        _TextField(controller: _employeeId, label: 'Employee ID'),
        _NumField(controller: _amount, label: 'Amount'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.api});
  final ApiClient api;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _employeeId = TextEditingController(text: 'E001');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.profile(_employeeId.text.trim());
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Profile',
      fields: [
        _TextField(controller: _employeeId, label: 'Employee ID'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.api});
  final ApiClient api;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _sender = TextEditingController(text: 'E001');
  final TextEditingController _receiver = TextEditingController(text: 'E002');
  final TextEditingController _message = TextEditingController(text: 'Hello');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.sendMessage(
        senderId: _sender.text.trim(),
        receiverId: _receiver.text.trim(),
        message: _message.text.trim(),
      );
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Chat',
      fields: [
        _TextField(controller: _sender, label: 'Sender ID'),
        _TextField(controller: _receiver, label: 'Receiver ID'),
        _TextField(controller: _message, label: 'Message'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key, required this.api});
  final ApiClient api;
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final TextEditingController _text = TextEditingController(text: '你好');
  final TextEditingController _lang = TextEditingController(text: 'en');
  String _result = '';
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.translate(
        text: _text.text.trim(),
        targetLanguage: _lang.text.trim(),
      );
      setState(() => _result = res.toString());
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Translate',
      fields: [
        _TextField(controller: _text, label: 'Text'),
        _TextField(controller: _lang, label: 'Target Language'),
      ],
      loading: _loading,
      onSubmit: _run,
      result: _result,
    );
  }
}

// Shared UI
class _FormScaffold extends StatelessWidget {
  const _FormScaffold({
    required this.title,
    required this.fields,
    required this.loading,
    required this.onSubmit,
    required this.result,
  });
  final String title;
  final List<Widget> fields;
  final bool loading;
  final VoidCallback onSubmit;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...fields,
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading ? null : onSubmit,
            child: Text(loading ? 'Loading…' : 'Submit'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(result, style: const TextStyle(fontFamily: 'monospace')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      );
}

class _NumField extends StatelessWidget {
  const _NumField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      );
}
