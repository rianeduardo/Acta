import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'A C T A',
              style: TextStyle(color: Colors.white, fontSize: 32, letterSpacing: 8),
            ),
            const Text(
              'organize, estruture, resolva.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Olá, Usuário 👋",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 2
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4DBFFF),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: const Text(
                        'MINHAS TAREFAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    Expanded(
                      child: _buildEmptyState(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
        },
        backgroundColor: const Color(0xFF4DBFFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 70),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Não há nada aqui ainda.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Experimente criar listas de tarefas tocando em +',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFD9D9D9),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home_rounded, size: 36, color: Color(0XFF0F172A)),
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.delete_rounded, size: 36, color: Color(0X99242424)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}