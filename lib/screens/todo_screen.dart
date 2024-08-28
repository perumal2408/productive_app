import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoGroup> _todoGroups = [];
  int _expandedGroupIndex = 0;
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _editGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoGroups();
  }

  Future<void> _loadTodoGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedGroups = prefs.getStringList('todoGroups');
    if (savedGroups != null) {
      setState(() {
        _todoGroups = savedGroups.map((e) => TodoGroup.fromJson(jsonDecode(e))).toList();
      });
    }
  }

  Future<void> _saveTodoGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> groupsJson = _todoGroups.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('todoGroups', groupsJson);
  }

  void _addTodoGroup(String groupName) {
    setState(() {
      _todoGroups.insert(0, TodoGroup(name: groupName, tasks: []));
      _expandedGroupIndex = 0;
    });
    _saveTodoGroups();
  }

  void _addTaskToGroup(int groupIndex, String taskName) {
    setState(() {
      _todoGroups[groupIndex].tasks.add(TodoTask(name: taskName, isCompleted: false));
    });
    _saveTodoGroups();
  }

  void _deleteTask(int groupIndex, int taskIndex) {
    setState(() {
      _todoGroups[groupIndex].tasks.removeAt(taskIndex);
    });
    _saveTodoGroups();
  }

  void _editTodoGroup(int groupIndex, String newName) {
    setState(() {
      _todoGroups[groupIndex].name = newName;
    });
    _saveTodoGroups();
  }

  void _deleteTodoGroup(int groupIndex) {
    setState(() {
      _todoGroups.removeAt(groupIndex);
    });
    _saveTodoGroups();
  }

  void _toggleGroupExpansion(int groupIndex) {
    setState(() {
      _expandedGroupIndex = _expandedGroupIndex == groupIndex ? -1 : groupIndex;
    });
  }

  void _showEditDialog(int groupIndex) {
    _editGroupController.text = _todoGroups[groupIndex].name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Group'),
          content: TextField(
            controller: _editGroupController,
            decoration: InputDecoration(labelText: 'Group Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editTodoGroup(groupIndex, _editGroupController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int groupIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Group'),
          content: Text('Are you sure you want to delete this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteTodoGroup(groupIndex);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupController,
              decoration: InputDecoration(
                labelText: 'Add a new todo group...',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_groupController.text.trim().isNotEmpty) {
                  _addTodoGroup(_groupController.text.trim());
                  _groupController.clear();
                }
              },
              child: Text('Add Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _todoGroups.length,
                itemBuilder: (context, groupIndex) {
                  final group = _todoGroups[groupIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Space between cards
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(group.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _showEditDialog(groupIndex),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _showDeleteDialog(groupIndex),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _expandedGroupIndex == groupIndex ? Icons.expand_less : Icons.expand_more,
                                  ),
                                  onPressed: () => _toggleGroupExpansion(groupIndex),
                                ),
                              ],
                            ),
                            onTap: () => _toggleGroupExpansion(groupIndex),
                          ),
                          if (_expandedGroupIndex == groupIndex) ...[
                            for (int taskIndex = 0; taskIndex < group.tasks.length; taskIndex++)
                              Dismissible(
                                key: Key(group.tasks[taskIndex].name),
                                onDismissed: (direction) {
                                  _deleteTask(groupIndex, taskIndex);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                child: ListTile(
                                  title: Text(group.tasks[taskIndex].name),
                                  trailing: Checkbox(
                                    value: group.tasks[taskIndex].isCompleted,
                                    onChanged: (value) {
                                      setState(() {
                                        group.tasks[taskIndex].isCompleted = value ?? false;
                                      });
                                      _saveTodoGroups();
                                    },
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _taskController,
                                decoration: InputDecoration(
                                  labelText: 'Add a new task...',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onSubmitted: (taskName) {
                                  if (taskName.trim().isNotEmpty) {
                                    _addTaskToGroup(groupIndex, taskName.trim());
                                    _taskController.clear();
                                  }
                                },
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoGroup {
  String name;
  List<TodoTask> tasks;

  TodoGroup({
    required this.name,
    required this.tasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  static TodoGroup fromJson(Map<String, dynamic> json) {
    return TodoGroup(
      name: json['name'],
      tasks: (json['tasks'] as List).map((task) => TodoTask.fromJson(task)).toList(),
    );
  }
}

class TodoTask {
  String name;
  bool isCompleted;

  TodoTask({
    required this.name,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted,
    };
  }

  static TodoTask fromJson(Map<String, dynamic> json) {
    return TodoTask(
      name: json['name'],
      isCompleted: json['isCompleted'],
    );
  }
}
