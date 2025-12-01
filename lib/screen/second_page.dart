import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../provider/todo_provider.dart';

class AddTodoItemPage extends StatefulWidget {
  final TodoModel? todo;

  const AddTodoItemPage({super.key, this.todo});

  @override
  State<AddTodoItemPage> createState() => _AddTodoItemPageState();
}

class _AddTodoItemPageState extends State<AddTodoItemPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final minCtrl = TextEditingController();
  final secCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      titleCtrl.text = widget.todo!.title;
      descCtrl.text = widget.todo!.description;

      minCtrl.text = (widget.todo!.totalSeconds ~/ 60).toString();
      secCtrl.text = (widget.todo!.totalSeconds % 60).toString();
    }
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xffF4F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff6A5AE0), Color(0xff8D7BFF)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  widget.todo == null ? "Add Todo" : "Edit Todo",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// TITLE
            TextField(controller: titleCtrl, decoration: _inputStyle("Title")),

            const SizedBox(height: 15),

            /// DESCRIPTION
            TextField(
              controller: descCtrl,
              decoration: _inputStyle("Description"),
            ),

            const SizedBox(height: 15),

            /// MIN - SEC INPUT ROW
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minCtrl,
                    decoration: _inputStyle("Min (0-5)"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: secCtrl,
                    decoration: _inputStyle("Sec (0-59)"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ACTION BUTTONS
            Row(
              children: [
                /// CANCEL BUTTON
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(width: 12),

                /// SAVE BUTTON
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xff6A5AE0),
                    ),
                    onPressed: () async {
                      int min = int.tryParse(minCtrl.text) ?? 0;
                      int sec = int.tryParse(secCtrl.text) ?? 0;

                      int totalSec = (min * 60) + sec;

                      if (totalSec > 300) totalSec = 300;

                      if (widget.todo == null) {
                        await provider.addTodo(
                          TodoModel(
                            title: titleCtrl.text,
                            description: descCtrl.text,
                            totalSeconds: totalSec,
                            remainingSeconds: totalSec,
                            status: "todo",
                          ),
                        );
                      } else {
                        await provider.updateTodo(
                          widget.todo!.copyWith(
                            title: titleCtrl.text,
                            description: descCtrl.text,
                            totalSeconds: totalSec,
                            remainingSeconds: totalSec,
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
