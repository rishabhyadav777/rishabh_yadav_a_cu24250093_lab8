Future<String> fetchUserGreeting() async {
  print('Fetching data from remote server...');
  // Simulating network delay of 3 seconds
  await Future.delayed(const Duration(seconds: 3));
  return 'Hello! Data retrieved successfully after delay.';
}

void main() async {
  print('Program started.');
  String result = await fetchUserGreeting();
  print('Result: $result');
  print('Program ended.');
}