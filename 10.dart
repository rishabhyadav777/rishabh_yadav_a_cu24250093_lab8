import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: ErrorHandlingScreen(), debugShowCheckedModeBanner: false));

class ErrorHandlingScreen extends StatefulWidget {
  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadApiData();
  }

  Future<void> _loadApiData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Testing with a valid URL or deliberate typo to demonstrate error
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() => _data = jsonDecode(response.body));
      } else {
        setState(() => _errorMessage = 'Server error: Status ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to connect. Please check your internet connection.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program 10: Error & Retry')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadApiData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: _data?.length ?? 0,
          itemBuilder: (ctx, i) => ListTile(
            title: Text(_data![i]['name']),
            subtitle: Text(_data![i]['email']),
          ),
        ),
      ),
    );
  }
}