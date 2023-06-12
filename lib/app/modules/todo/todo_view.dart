import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'todo_controller.dart';

class TodoView extends StatelessWidget {
  TodoView({Key? key}) : super(key: key);
  final TodoController controller = Get.put(TodoController());
  @override
  Widget build(BuildContext context) {
    // print(controller.todoList.map((e) => e.isCompleted));
    // print(controller.todoList.map((e) => e.toJson()).toString());
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("TODO APP",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: Colors.black))),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextField(
                        controller: controller.textEditingController,
                        focusNode: controller.focusNode,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            controller.onAddTask();
                          }
                        },
                      )),
                      ElevatedButton(
                        onPressed: () {
                          controller.onAddTask();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(0)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: GetBuilder<TodoController>(
                          id: 'list-builder',
                          builder: (controller) => ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.tasksList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                              value: controller
                                                  .tasksList[index].isCompleted,
                                              onChanged: (value) {
                                                if (value == null) {
                                                  return;
                                                }
                                                if (value) {
                                                  controller.onCheckTask(index);
                                                } else {
                                                  controller
                                                      .onUncheckTask(index);
                                                }
                                              }),
                                          Expanded(
                                              child: Text(
                                                  controller
                                                      .tasksList[index].name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  )))
                                        ],
                                      ));
                                },
                              )))
                ],
              ))),
    );
  }
}
