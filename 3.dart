import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: FetchRawApiScreen(), debugShowCheckedModeBanner: false));

class FetchRawApiScreen extends StatefulWidget {
  const FetchRawApiScreen({super.key});

  @override
  State<FetchRawApiScreen> createState() => _FetchRawApiScreenState();
}

class _FetchRawApiScreenState extends State<FetchRawApiScreen> {
  String _responseBody = 'Press button to fetch data';
  bool _isLoading = false;

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      setState(() {
        _responseBody = response.body;
      });
    } catch (e) {
      setState(() => _responseBody = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program 3: http.get() Raw Body')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(onPressed: _isLoading ? null : _fetchData, child: const Text('Fetch Data')),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Text(_responseBody, style: const TextStyle(fontFamily: 'monospace')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}