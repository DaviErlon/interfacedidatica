import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _mensagem = "";

Future<void> _fazerLogin() async {
  try {
    final response = await http.post(
      Uri.parse("http://localhost:8080/api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "login": _loginController.text,
        "senha": _senhaController.text,
      }),
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        _mensagem = "Login autorizado!";
      });
    } else if (response.statusCode == 404) {
      setState(() {
        _mensagem = "Página não encontrada (404)";
      });
    } else {
      setState(() {
        _mensagem = "Credenciais inválidas ou outro erro";
      });
    }
  } catch (e) {
    print("Erro de conexão: $e");
    setState(() {
      _mensagem = "Não foi possível conectar ao servidor";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 300,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(labelText: "Login"),
                ),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Senha"),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _fazerLogin,
                  child: Text("Entrar"),
                ),
                SizedBox(height: 20),
                Text(_mensagem),
              ],
              ),
            ), 
          ),
        ),
      ),
    );
  }
}
