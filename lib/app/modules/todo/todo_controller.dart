import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

part 'todo_controller.g.dart';

@HiveType(typeId: 1)
class AllTasks extends HiveObject {
  @HiveField(1)
  List<TaskItem> tasks;

  AllTasks({
    required this.tasks,
  });

  factory AllTasks.fromJson(Map<String, dynamic> json) => AllTasks(
        tasks: List<TaskItem>.from(
            json["TaskItem"].map((x) => TaskItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TaskItem": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 2)
class TaskItem extends HiveObject {
  @HiveField(1)
  final String name;
  @HiveField(2)
  bool isCompleted;

  TaskItem({required this.name, required this.isCompleted});

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        name: json["name"],
        isCompleted: json["isCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "isCompleted": isCompleted,
      };
}

class TodoController extends GetxController {
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;

  late final Box box;
  @override
  void onInit() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    initializedPrefs();

    super.onInit();
  }

  Future<void> initializedPrefs() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(AllTasksAdapter());
    Hive.registerAdapter(TaskItemAdapter());

    // Opening the box
    box = await Hive.openBox<AllTasks>('todos');

    final allTasks = box.get("tasks");
    if (allTasks != null) {
      tasksList = (allTasks as AllTasks).tasks;
      update(['list-builder']);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  List<TaskItem> tasksList = [];

  Future<void> onAddTask() async {
    if (textEditingController.text.isNotEmpty) {
      tasksList.insert(
          0, TaskItem(name: textEditingController.text, isCompleted: false));
      textEditingController.text = "";
      focusNode.unfocus();
    }
    update(['list-builder']);
    await box.put('tasks', AllTasks(tasks: tasksList));
  }

  Future<void> onCheckTask(int index) async {
    tasksList[index].isCompleted = true;

    final item = tasksList.removeAt(index);
    tasksList.add(item);
    update(['list-builder']);
    await box.put('tasks', AllTasks(tasks: tasksList));
  }

  Future<void> onUncheckTask(int index) async {
    final firstCheckedItemIndex =
        tasksList.indexWhere((element) => element.isCompleted);

    final item = tasksList.removeAt(index);

    item.isCompleted = false;

    tasksList.insert(firstCheckedItemIndex, item);

    update(['list-builder']);
    await box.put('tasks', AllTasks(tasks: tasksList));
  }
}
