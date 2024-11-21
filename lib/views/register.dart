import 'package:flutter/material.dart';
import 'package:fluttertest/services/authService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  AuthService authServiceInstance = AuthService();

  bool isSignUpPasswordObscure = true;

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
          'Registrar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Form(
        key: signUpFormKey,
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
                controller: nameInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  label: Text('Nome'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: emailInputController,
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
              child: TextFormField(
                controller: passwordInputController,
                obscureText: isSignUpPasswordObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isSignUpPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isSignUpPasswordObscure = !isSignUpPasswordObscure;
                      });
                    },
                  ),
                  label: Text('Senha'),
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
                  if (signUpFormKey.currentState?.validate() ?? false) {
                    String name = nameInputController.text;
                    String email = emailInputController.text;
                    String password = passwordInputController.text;
                    authServiceInstance
                        .registerUser(
                            name: name, email: email, password: password)
                        .then((erro) {
                      if (erro != null) {
                        _showDialog('Erro', erro, true);
                      } else {
                        _showDialog(
                            'Sucesso', 'Usuário registrado com sucesso', false);
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: const Text(
                  'Registrar',
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
