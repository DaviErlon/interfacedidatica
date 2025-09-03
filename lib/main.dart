import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
      home: const MainPage(),
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();  
}

class _MainPageState extends State<MainPage>{

  int _pageIndex = 0;

  void _mudarIndex(int i){
    setState(() {
      _pageIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF3F4F6FF),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            child: Container(
              width: 250,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_rounded,
                          size: 80,
                          color: Color(0xFF757BEA),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " User",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Color(0xFF757BEA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "@caixa1",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Color(0xFF757BEA),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ), 
                    
                  ),
                  const Divider(),
                  SizedBox(
                    height: 40,
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 0, 
                    name: "INÍCIO", 
                    index: 0, 
                    icon: Icons.home
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 1, 
                    name: "PRODUTOS", 
                    index: 1, 
                    icon: Icons.inventory_2
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 2, 
                    name: "PESSOAS", 
                    index: 2, 
                    icon: Icons.people
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 3, 
                    name: "FINANCEIRO", 
                    index: 3, 
                    icon: Icons.attach_money
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 4, 
                    name: "VENDER", 
                    index: 4, 
                    icon: Icons.shopping_cart
                  ),
                  _Botao(
                    acao: _mudarIndex, 
                    selected: _pageIndex == 5, 
                    name: "REPOR", 
                    index: 5, 
                    icon: Icons.add_shopping_cart
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  color: Color(0xFF757BEA),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            width: 750,
                            height: 520,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ), 
          ),
        ],
      ), 
    );
  }
}

class _Botao extends StatelessWidget {
  final void Function(int) acao;
  final bool selected;
  final String name;
  final int index;
  final IconData icon;

  const _Botao({
    super.key,
    required this.acao,
    required this.selected,
    required this.name,
    required this.index,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton(
        onPressed: () {
          acao(index);
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          ),
          backgroundColor: WidgetStateProperty.all(
            selected ? const Color(0xFF757BEA) : Colors.white,
          ),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          fixedSize: WidgetStateProperty.all(const Size(250, 50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 62, right: 8),
              child: Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : const Color(0xFF757BEA),
              ),
            ),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: selected ? Colors.white : const Color(0xFF757BEA),
              ),
            ),
          ],
        ),
      )

    );
  }
}
