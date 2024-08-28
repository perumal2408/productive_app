import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  List<JournalEntry> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedEntries = prefs.getStringList('journalEntries');
    if (savedEntries != null) {
      setState(() {
        _journalEntries = savedEntries.map((e) => JournalEntry.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveJournalEntry(String text) async {
    final entry = JournalEntry(
      content: text,
      dateTime: DateTime.now(),
    );

    setState(() {
      _journalEntries.add(entry);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> entriesJson = _journalEntries.map((e) => e.toJson()).toList();
    await prefs.setStringList('journalEntries', entriesJson);
    _controller.clear();
  }

  void _editJournalEntry(int index, String newText) {
    setState(() {
      _journalEntries[index].content = newText;
    });
    _saveJournalEntries();
  }

  void _deleteJournalEntry(int index) {
    setState(() {
      _journalEntries.removeAt(index);
    });
    _saveJournalEntries();
  }

  Future<void> _saveJournalEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> entriesJson = _journalEntries.map((e) => e.toJson()).toList();
    await prefs.setStringList('journalEntries', entriesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: 200,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Write your journal...',
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
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  _saveJournalEntry(_controller.text.trim());
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _journalEntries.length,
                itemBuilder: (context, index) {
                  final entry = _journalEntries[index];
                  return JournalCard(
                    entry: entry,
                    onEdit: (newText) => _editJournalEntry(index, newText),
                    onDelete: () => _deleteJournalEntry(index),
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

class JournalEntry {
  String content;
  DateTime dateTime;

  JournalEntry({required this.content, required this.dateTime});

  String toJson() {
    return jsonEncode({'content': content, 'dateTime': dateTime.toIso8601String()});
  }

  static JournalEntry fromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return JournalEntry(
      content: data['content'],
      dateTime: DateTime.parse(data['dateTime']),
    );
  }
}

class JournalCard extends StatefulWidget {
  final JournalEntry entry;
  final Function(String) onEdit;
  final Function onDelete;

  JournalCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _JournalCardState createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMd().add_jm().format(widget.entry.dateTime),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                widget.entry.content,
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog();
                  } else if (value == 'delete') {
                    widget.onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    final TextEditingController _editController = TextEditingController(text: widget.entry.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Journal Entry'),
          content: TextField(
            controller: _editController,
            maxLength: 200,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onEdit(_editController.text.trim());
                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 236, 236, 236),
              ),
            ),
          ],
        );
      },
    );
  }
}
