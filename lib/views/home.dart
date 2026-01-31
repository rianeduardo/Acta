import 'package:flutter/material.dart';
import 'package:actav1/widgets/modal_tarefa.dart';
import 'package:actav1/models/tarefa_model.dart';
import 'package:actav1/services/storage_servico.dart';
import 'package:actav1/views/lixeira.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // 1. Lista que guarda as tarefas vindas do Storage
  List<TaskModel> _tasks = [];

  // 2. Função para carregar, ordenar e atualizar a tela
  Future<void> _loadAndSortTasks() async {
    final allTasks = await StorageService.getTasks();
    final loadedTasks = allTasks.where((t) => !t.isDeleted).toList();

    Map<String, int> priorityValue = {
      'Alta': 1,
      'Média': 2,
      'Baixa': 3,
    };

    loadedTasks.sort((a, b) {
      // 1º Critério: Prioridade
      int pComp = priorityValue[a.priority]!.compareTo(priorityValue[b.priority]!);
      if (pComp != 0) return pComp;
      // 2º Critério: Data de criação
      return a.createdAt.compareTo(b.createdAt);
    });

    setState(() {
      _tasks = loadedTasks;
    });
  }

  String _userName = "";
  // 1. Função para chamar o nome
  Future<void> _loadUserData() async {
    final name = await StorageService.getName(); // 2. Busca no SharedPreferences
    setState(() {
      _userName = name ?? "Usuário"; // 3. Atualiza a tela. Se for nulo, usa "Usuário"
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 1. Carrega os dados do usuário assim que abre o app
    _loadAndSortTasks(); // 2. Carrega e ordena as tarefas assim que abre o app
  }

  void _toggleTaskDone(TaskModel tarefa) async {
    setState(() {
      tarefa.isDone = !tarefa.isDone;
    });
    await StorageService.saveTasks(_tasks);
  }

  void _deleteTask(TaskModel tarefa) async {
    // 1. Pega TUDO o que existe no banco (Ativas + Lixeira)
    List<TaskModel> allTasks = await StorageService.getTasks();

    // 2. Localiza o item específico na lista mestre pelo ID
    int index = allTasks.indexWhere((t) => t.id == tarefa.id);

    if (index != -1) {
      setState(() {
        // 3. Atualiza o status na lista mestre
        allTasks[index].isDeleted = true;
      });

      // 4. Salva a lista mestre completa de volta no SharedPreferences
      await StorageService.saveTasks(allTasks);

      // 5. Recarrega a tela
      _loadAndSortTasks();
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Olá, $_userName 👋",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Card Principal
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // Cabeçalho do Card
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

                    // Área da lista
                    Expanded(
                      child: _tasks.isEmpty
                          ? _buildEmptyState() // Se não tiver tarefa, mostra o texto
                          : ListView.builder(
                        itemCount: _tasks.length,
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return _buildTaskItem(_tasks[index]);
                        },
                      ),
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
        onPressed: () async {
          // Espera o modal fechar para recarregar a lista
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskModal(),
          );
          _loadAndSortTasks();
        },
        backgroundColor: const Color(0xFF4DBFFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 70),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- WIDGETS AUXILIARES PARA LIMPEZA DO CÓDIGO ---

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

  Widget _buildTaskItem(TaskModel tarefa) {
    return Dismissible(
      key: Key(tarefa.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _tasks.removeWhere((t) => t.id == tarefa.id);
        });
        _deleteTask(tarefa);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(
            Icons.circle,
            size: 14,
            color: _getPriorityColor(tarefa.priority),
          ),
          title: Text(
            tarefa.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: tarefa.isDone ? TextDecoration.lineThrough : null,
              color: tarefa.isDone ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(tarefa.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão de Check
              IconButton(
                icon: Icon(
                  tarefa.isDone ? Icons.check_circle_rounded : Icons.check_circle_rounded,
                  color: tarefa.isDone ? Colors.green : Colors.grey,
                ),
                onPressed: () => _toggleTaskDone(tarefa),
              ),
              // Botão de Lixeira
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                onPressed: () => _deleteTask(tarefa),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String p) {
    if (p == 'Alta') return Colors.redAccent;
    if (p == 'Média') return Colors.orangeAccent;
    return Colors.greenAccent;
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
              onPressed: () async {
                await
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const TrashPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ).then((_) => _loadAndSortTasks());
              },
            ),
          ],
        ),
      ),
    );
  }
}