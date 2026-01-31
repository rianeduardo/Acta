import 'package:flutter/material.dart';
import 'package:actav1/models/tarefa_model.dart';
import 'package:actav1/services/storage_servico.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedPriority = 'Baixa';

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Faz o modal subir quando o teclado aparece
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cabeçalho Azul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4DBFFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Text(
                'C R I A Ç Ã O',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(titleController, 'Título da tarefa'),
                  const SizedBox(height: 15),
                  _buildTextField(descController, 'Descrição (opc.)', maxLines: 3),
                  const SizedBox(height: 15),
                  _buildPriorityMenu(),
                  const SizedBox(height: 30),

                  // BOTÃO CRIAR - O CORAÇÃO DA LÓGICA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty) {
                          // 1. Busca as tarefas que já existem
                          List<TaskModel> tarefasAtuais = await StorageService.getTasks();

                          // 2. Cria a nova tarefa
                          TaskModel novaTarefa = TaskModel(
                            id: DateTime.now().toString(), // ID único baseado no tempo
                            title: titleController.text,
                            description: descController.text,
                            priority: selectedPriority,
                            createdAt: DateTime.now(),
                          );

                          // 3. Adiciona na lista e salva no celular
                          tarefasAtuais.add(novaTarefa);
                          await StorageService.saveTasks(tarefasAtuais);

                          // 4. FECHA O MODAL (Volta para a Home)
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        } else {
                          // Opcional: Avisar que o título é obrigatório
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dê um título para a tarefa!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        'CRIAR',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPriorityMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPriority,
          isExpanded: true,
          items: ['Alta', 'Média', 'Baixa'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: _getColor(value)),
                  const SizedBox(width: 10),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() => selectedPriority = newValue!);
          },
        ),
      ),
    );
  }

  Color _getColor(String p) {
    if (p == 'Alta') return Colors.red;
    if (p == 'Média') return Colors.orange;
    return Colors.green;
  }
}