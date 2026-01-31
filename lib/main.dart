import 'package:flutter/material.dart';
import 'package:actav1/views/onboarding.dart';
import 'package:actav1/views/home.dart';
import 'package:actav1/services/storage_servico.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. Adicionamos o 'async' aqui
void main() async {
  // 2. Como o main é async, precisamos avisar ao Flutter
  // para garantir que o SharedPreferences carregue antes de tudo
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Buscamos o nome salvo
  String? nomeSalvo = await StorageService.getName();

  // 4. Passamos o resultado para o MyApp decidir a tela inicial
  runApp(MyApp(nomeUsuario: nomeSalvo));
}

class MyApp extends StatelessWidget {
  final String? nomeUsuario;

  // 5. Recebemos o nome no construtor
  const MyApp({super.key, this.nomeUsuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme()
      ),
      // 6. Lógica de decisão: Se tem nome, vai para Home. Se não, Onboarding.
      home: nomeUsuario == null ? const WelcomePage() : const HomePage(),
    );
  }
}