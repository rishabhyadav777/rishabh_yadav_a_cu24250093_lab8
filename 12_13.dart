import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: SearchAndRefreshScreen(), debugShowCheckedModeBanner: false));

class SearchAndRefreshScreen extends StatefulWidget {
  const SearchAndRefreshScreen({super.key});

  @override
  State<SearchAndRefreshScreen> createState() => _SearchAndRefreshScreenState();
}

class _SearchAndRefreshScreenState extends State<SearchAndRefreshScreen> {
  List<dynamic> _allUsers = [];
  List<dynamic> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        _allUsers = data;
        _filteredUsers = data;
        _isLoading = false;
      });
    }
  }

  void _filter(String keyword) {
    setState(() {
      _filteredUsers = _allUsers
          .where((u) => u['name'].toString().toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prog 12 & 13: Search & Refresh')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField( // Program 12: Search TextField[cite: 14]
              decoration: const InputDecoration(
                hintText: 'Search by user name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator( // Program 13: Pull to Refresh[cite: 14]
              onRefresh: _fetchUsers,
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(child: Text('${_filteredUsers[i]['id']}')),
                  title: Text(_filteredUsers[i]['name']),
                  subtitle: Text(_filteredUsers[i]['email']),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}