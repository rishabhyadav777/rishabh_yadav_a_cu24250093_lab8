import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: UserListScreen(), debugShowCheckedModeBanner: false));

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<dynamic>> _getUsers() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program 11: Users Master-Detail')),
      body: FutureBuilder<List<dynamic>>(
        future: _getUsers(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final users = snap.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (c, i) => ListTile(
              leading: CircleAvatar(child: Text('${users[i]['id']}')),
              title: Text(users[i]['name']),
              subtitle: Text(users[i]['email']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: users[i])),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(leading: const Icon(Icons.person), title: const Text('Username'), subtitle: Text(user['username'])),
                ListTile(leading: const Icon(Icons.email), title: const Text('Email'), subtitle: Text(user['email'])),
                ListTile(leading: const Icon(Icons.phone), title: const Text('Phone'), subtitle: Text(user['phone'])),
                ListTile(leading: const Icon(Icons.web), title: const Text('Website'), subtitle: Text(user['website'])),
                ListTile(leading: const Icon(Icons.business), title: const Text('Company'), subtitle: Text(user['company']['name'])),
                ListTile(leading: const Icon(Icons.location_city), title: const Text('City'), subtitle: Text(user['address']['city'])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}