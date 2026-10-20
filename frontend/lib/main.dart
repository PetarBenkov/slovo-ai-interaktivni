import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Задължителна инициализация за async операции преди runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Зареждане на .env файла
  await dotenv.load(fileName: ".env");

  // Изпечатване в конзолата за проверка
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  debugPrint('Зареден API ключ: ${apiKey != null && apiKey.isNotEmpty ? "УСПЕШНО" : "ГРЕШКА"}');

  runApp(const MyApp());
}

/// Главен Widget на приложението
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final isLoaded = apiKey != null && apiKey.isNotEmpty;

    return MaterialApp(
      title: 'Slovo AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Slovo AI - Проверка на API ключ'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLoaded ? Icons.check_circle : Icons.error,
                color: isLoaded ? Colors.green : Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                isLoaded
                    ? 'API ключът е зареден успешно!'
                    : 'Грешка: API ключът НЕ е открит в .env файла.',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}