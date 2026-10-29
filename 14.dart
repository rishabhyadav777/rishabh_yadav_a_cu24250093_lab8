import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: PostFormScreen(), debugShowCheckedModeBanner: false));

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _statusMsg = '';
  bool _isSubmitting = false;

  Future<void> _submitData() async {
    if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) return;

    setState(() => _isSubmitting = true);
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': _titleCtrl.text,
        'body': _bodyCtrl.text,
        'userId': 1,
      }),
    );

    setState(() {
      _isSubmitting = false;
      if (response.statusCode == 201) {
        _statusMsg = 'Success 201: Created!\nResponse:\n${response.body}';
      } else {
        _statusMsg = 'Error code: ${response.statusCode}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program 14: http.post() Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Post Title', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _bodyCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Post Body', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitData,
              child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Send POST Request'),
            ),
            const SizedBox(height: 16),
            Text(_statusMsg, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}