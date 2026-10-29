import 'dart:convert';

class Student {
  final int id;
  final String name;
  final String course;

  Student({required this.id, required this.name, required this.course});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      course: json['course'] as String,
    );
  }

  @override
  String toString() => 'Student(id: $id, name: $name, course: $course)';
}

void main() {
  const jsonString = '''
  [
    {"id": 101, "name": "Aarav Sharma", "course": "BCA"},
    {"id": 102, "name": "Priya Verma", "course": "B.Tech CSE"},
    {"id": 103, "name": "Rohan Patel", "course": "MCA"}
  ]
  ''';

  List<dynamic> jsonList = jsonDecode(jsonString);
  List<Student> students = jsonList.map((item) => Student.fromJson(item)).toList();

  print('--- Parsed Student Objects ---');
  for (var student in students) {
    print(student);
  }
}