import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _editingTaskId;

  void _showAddEditTaskDialog({Task? existingTask}) {
    _editingTaskId = existingTask?.id;
    _taskController.text = existingTask?.title ?? '';
    _selectedDate = existingTask?.date ?? DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Row(
              children: [
                Icon(
                  existingTask == null ? Icons.add_task : Icons.edit_note,
                  color: Colors.purple[800],
                ),
                const SizedBox(width: 10),
                Text(
                  existingTask == null ? 'Nova Tarefa' : 'Editar Tarefa',
                  style: TextStyle(color: Colors.purple[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Digite a tarefa...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.calendar_today, color: Colors.purple[800]),
                  title: Text(
                    'Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_calendar, color: Colors.purple[800]),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) => Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.purple[800],
                            colorScheme: ColorScheme.light(primary: Colors.purple[800]!),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCELAR', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    final provider = Provider.of<TaskProvider>(context, listen: false);
                    if (_editingTaskId == null) {
                      provider.addTask(_taskController.text, _selectedDate);
                    } else {
                      provider.editTask(_editingTaskId!, _taskController.text, _selectedDate);
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(existingTask == null ? 'ADICIONAR' : 'SALVAR'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma tarefa cadastrada',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (ctx, index) {
                final task = tasks[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: task.isDone ? Colors.green : Colors.purple.shade100,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged: (_) => taskProvider.toggleTask(task.id),
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  color: task.isDone ? Colors.grey : Colors.black87,
                                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${task.date.day}/${task.date.month}/${task.date.year}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                          onPressed: () => _showAddEditTaskDialog(existingTask: task),
                          splashRadius: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.push_pin,
                            color: taskProvider.tasks.indexOf(task) == 0 && taskProvider.tasks.isNotEmpty
                                ? Colors.purple[800]
                                : Colors.grey,
                          ),
                          onPressed: () => taskProvider.pinTask(task.id),
                          splashRadius: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward, color: Colors.grey),
                          onPressed: () => taskProvider.moveTaskUp(task.id),
                          splashRadius: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward, color: Colors.grey),
                          onPressed: () => taskProvider.moveTaskDown(task.id),
                          splashRadius: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => taskProvider.removeTask(task.id),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTaskDialog(),
        backgroundColor: Colors.purple[800],
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
