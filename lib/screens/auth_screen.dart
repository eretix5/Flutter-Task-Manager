import 'package:flutter/material.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pinController = TextEditingController();
  bool _isError = false;

  void _login() {
    // Имитация проверки ключа/PIN из задания 2
    if (_pinController.text == '1234') {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const MainScreen())
      );
    } else {
      setState(() => _isError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Введите PIN (1234)',
                  errorText: _isError ? 'Неверный PIN' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _login,
                child: const Text('Войти'),
              )
            ],
          ),
        ),
      ),
    );
  }
}