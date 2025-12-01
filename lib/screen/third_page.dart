import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_practical/screen/second_page.dart';

import '../model/todo_model.dart';
import '../provider/todo_provider.dart';

class TodoDetailsPage extends StatelessWidget {
  final TodoModel todo;

  const TodoDetailsPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        title: Text(
          todo.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A5AE0), Color(0xff8D7BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                builder: (_) => AddTodoItemPage(todo: todo),
              );
            },
          ),
        ],
      ),

      body: Consumer<TodoProvider>(
        builder: (_, provider, __) {
          final updated = provider.todos.firstWhere((e) => e.id == todo.id);

          final mins = updated.calculatedRemainingSeconds ~/ 60;
          final secs = updated.calculatedRemainingSeconds % 60;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// DESCRIPTION CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    updated.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

                const SizedBox(height: 30),

                /// TIMER DISPLAY CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff6A5AE0), Color(0xff8D7BFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Remaining Time",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${mins.toString().padLeft(2, '0')}:"
                        "${secs.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(
                      icon: Icons.play_arrow,
                      color: Colors.green,
                      onTap: () => provider.startTimer(updated),
                    ),
                    _actionButton(
                      icon: Icons.pause,
                      color: Colors.orange,
                      onTap: () => provider.pauseTimer(updated),
                    ),
                    _actionButton(
                      icon: Icons.stop,
                      color: Colors.red,
                      onTap: () => provider.stopTimer(updated),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Button Widget
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
      ),
      child: IconButton(
        icon: Icon(icon, size: 34, color: color),
        onPressed: onTap,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
