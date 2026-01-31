import 'package:flutter/material.dart';
import 'package:actav1/views/home.dart';
import 'package:actav1/services/storage_servico.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // **FUNDO**
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/waves.png',
              fit: BoxFit.cover,
            ),
          ),

          // **LOGO E SLOGAN**
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'ACTA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w100,
                      letterSpacing: 20,
                    ),
                  ),
                  const Text(
                    'organize, estruture, resolva.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const Spacer(),

                  // **TEXTOS**
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá 👋',
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Vamos organizar o\nque precisa ser feito.',
                          style: TextStyle(color: Colors.white, fontSize: 32),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // **APENAS VISUAL**
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Seu nome',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // **APENAS NAVEGAÇÃO**
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        String nomeDigitado = nameController.text;

                        if (nomeDigitado.isNotEmpty) {
                          // 1. Salva o nome
                          await StorageService.saveName(nomeDigitado);

                          // 2. Vai para a Home e impede o usuário de voltar para o Onboarding
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('COMEÇAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}