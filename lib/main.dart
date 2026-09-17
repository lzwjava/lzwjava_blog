import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

void main() {
  runApp(const NoteUploaderApp());
}

class NoteUploaderApp extends StatelessWidget {
  const NoteUploaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Uploader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NoteUploaderHomePage(),
    );
  }
}

class NoteUploaderHomePage extends StatefulWidget {
  const NoteUploaderHomePage({super.key});

  @override
  State<NoteUploaderHomePage> createState() => _NoteUploaderHomePageState();
}

class _NoteUploaderHomePageState extends State<NoteUploaderHomePage> {
  final TextEditingController _noteController = TextEditingController();
  String _selectedModel = Config.defaultModel;
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isSuccess = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitNote() async {
    final noteContent = _noteController.text.trim();

    if (noteContent.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter note content';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}/create-note'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': noteContent,
          'model': _selectedModel,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = 'Note created successfully!';
          _isSuccess = true;
          _noteController.clear();
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to create note: ${response.body}';
          _isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Network error: $e';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Uploader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Model selection dropdown
            DropdownButtonFormField<String>(
              value: _selectedModel,
              decoration: const InputDecoration(
                labelText: 'AI Model',
                border: OutlineInputBorder(),
              ),
              items: Config.availableModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedModel = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Note content text field
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null, // Allow unlimited lines
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Enter your note content here...',
                  border: OutlineInputBorder(),
                  labelText: 'Note Content',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status message
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                  border: Border.all(
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitNote,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Note'),
            ),
          ],
        ),
      ),
    );
  }
}
