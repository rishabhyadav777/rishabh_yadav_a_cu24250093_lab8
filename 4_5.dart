import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: SinglePostCardScreen(), debugShowCheckedModeBanner: false));

class SinglePostCardScreen extends StatefulWidget {
  const SinglePostCardScreen({super.key});

  @override
  State<SinglePostCardScreen> createState() => _SinglePostCardScreenState();
}

class _SinglePostCardScreenState extends State<SinglePostCardScreen> {
  Map<String, dynamic>? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSinglePost();
  }

  Future<void> _fetchSinglePost() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if (response.statusCode == 200) {
        setState(() => _post = jsonDecode(response.body));
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program 4 & 5: Post Card & Indicator')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Program 5
            : _post == null
            ? const Text('Failed to load post')
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card( // Program 4
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _post!['title'].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 20),
                  Text(
                    _post!['body'],
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}