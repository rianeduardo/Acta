import 'package:flutter/material.dart';
import 'package:actav1/models/tarefa_model.dart';
import 'package:actav1/services/storage_servico.dart';
import 'package:actav1/widgets/modal_tarefa.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<TaskModel> _trashTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTrashTasks();
  }

  Future<void> _loadTrashTasks() async {
    final allTasks = await StorageService.getTasks();
    setState(() {
      _trashTasks = allTasks.where((t) => t.isDeleted).toList();
      _trashTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _restoreTask(TaskModel tarefa) async {
    final allTasks = await StorageService.getTasks();
    int index = allTasks.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      allTasks[index].isDeleted = false;
      await StorageService.saveTasks(allTasks);
      _loadTrashTasks();
    }
  }

  void _permanentDelete(TaskModel tarefa) async {
    final allTasks = await StorageService.getTasks();
    allTasks.removeWhere((t) => t.id == tarefa.id);
    await StorageService.saveTasks(allTasks);
    _loadTrashTasks();
  }

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
                        'LIXEIRA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _trashTasks.isEmpty
                          ? const Center(child: Text('Lixeira vazia', style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                        itemCount: _trashTasks.length,
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return _buildTrashItem(_trashTasks[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Espaço para o botão flutuante
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskModal(),
          );
          // Se o cara adicionar uma tarefa nova tando na lixeira,
          // ela some (vai pra home), mas damos reload pra garantir.
          _loadTrashTasks();
        },
        backgroundColor: const Color(0xFF4DBFFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 70),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              // Cor cinza porque não estamos na Home
              icon: const Icon(Icons.home_rounded, size: 36, color: Color(0X99242424)),
              onPressed: () => Navigator.pop(context), // Volta para a Home
            ),
            const SizedBox(width: 40),
            IconButton(
              // Cor azul/escura porque a Lixeira está ativa
              icon: const Icon(Icons.delete_rounded, size: 36, color: Color(0XFF0F172A)),
              onPressed: () {
                // Já estamos na lixeira, não faz nada ou só dá um refresh
                _loadTrashTasks();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrashItem(TaskModel tarefa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(tarefa.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tarefa.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore_from_trash, color: Colors.blue),
              onPressed: () => _restoreTask(tarefa),
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () => _permanentDelete(tarefa),
            ),
          ],
        ),
      ),
    );
  }
}