import 'package:flutter/material.dart';
import 'counter_controller.dart';
import 'package:logbook_app_088/features/onboarding/onboarding_view.dart'; 

class CounterView extends StatefulWidget {
  final String username;

  const CounterView({super.key, required this.username});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();
  final TextEditingController _stepController = TextEditingController(text: '1');

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _confirmReset() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Reset', style: TextStyle(color: Colors.deepPurple)),
        content: const Text('Yakin ingin mereset counter ke 0?\nRiwayat tetap tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _controller.reset());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Counter berhasil direset!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout', style: TextStyle(color: Colors.deepPurple)),
        content: const Text('Yakin ingin logout?\nAnda akan kembali ke onboarding.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
        (route) => false, 
      );
    }
  }

  Color _getHistoryColor(String entry) {
    final lower = entry.toLowerCase();
    if (lower.contains('menambah')) return Colors.green[700]!;
    if (lower.contains('mengurangi') || lower.contains('mencoba kurang')) return Colors.red[700]!;
    return Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("LogBook Counter - ${widget.username}"), 
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout, 
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Selamat Datang, ${widget.username}!",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            "Total Hitungan",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_controller.value}',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _stepController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Langkah (Step)',
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurple.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          int? newStep = int.tryParse(value);
                          if (newStep != null && newStep >= 1) {
                            _controller.setStep(newStep);
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'decrement',
                        backgroundColor: Colors.redAccent,
                        onPressed: () => setState(() => _controller.decrement()),
                        child: const Icon(Icons.remove, size: 32),
                      ),
                      const SizedBox(width: 24),
                      FloatingActionButton(
                        heroTag: 'reset',
                        backgroundColor: Colors.deepPurple,
                        onPressed: _confirmReset,
                        child: const Icon(Icons.refresh, size: 28),
                      ),
                      const SizedBox(width: 24),
                      FloatingActionButton(
                        heroTag: 'increment',
                        backgroundColor: Colors.greenAccent.shade700,
                        onPressed: () => setState(() => _controller.increment()),
                        child: const Icon(Icons.add, size: 32),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Riwayat Aktivitas",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 250,
                    child: _controller.history.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada aktivitas",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _controller.history.length,
                            itemBuilder: (context, index) {
                              final entry = _controller.history[index];
                              final color = _getHistoryColor(entry);

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    entry,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}