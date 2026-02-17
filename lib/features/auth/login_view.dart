import 'package:flutter/material.dart';
import 'package:logbook_app_088/features/auth/login_controller.dart';
import 'package:logbook_app_088/features/logbook/counter_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _obscurePassword = true; 
  String? _errorMessage; 

  void _handleLogin() {
    setState(() {
      _errorMessage = null; 
    });

    final username = _userController.text.trim();
    final password = _passController.text;

    final isSuccess = _controller.login(username, password);

    if (isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CounterView(username: username),
        ),
      );
    } else {
      setState(() {
        if (username.isEmpty || password.isEmpty) {
          _errorMessage = "Username dan password tidak boleh kosong!";
        } else {
          _errorMessage = "Username atau password salah!";
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? "Login Gagal!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Gatekeeper")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _controller.isBlocked ? null : _handleLogin,
              child: _controller.isBlocked
                  ? const Text("Tunggu 10 detik...")
                  : const Text("Masuk"),
            ),
          ],
        ),
      ),
    );
  }
}