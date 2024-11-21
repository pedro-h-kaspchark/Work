import 'package:flutter/material.dart';
import 'package:fluttertest/services/authService.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AuthService authServiceInstance = AuthService();
  final recoveryFormKey = GlobalKey<FormState>();
  final TextEditingController recoveryEmailController = TextEditingController();

  void _showDialog(String title, String message, bool isError) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
          backgroundColor: isError ? Colors.red[100] : Colors.green[100],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recuperar senha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Form(
        key: recoveryFormKey,
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              'assets/ticket.webp',
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: recoveryEmailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  label: Text('Email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: () {
                  if (recoveryFormKey.currentState?.validate() ?? false) {
                    authServiceInstance
                        .passwordReset(recoveryEmailController.text)
                        .then((erro) {
                      if (erro != null) {
                        _showDialog('Erro', erro, true);
                      } else {
                        _showDialog(
                            'Sucesso', 'Link enviado com sucesso', false);
                      }
                    });
                  }
                },
                child: const Text(
                  'Enviar e-mail',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Spacer(flex: 2)
          ],
        ),
      ),
    );
  }
}
