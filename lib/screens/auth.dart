import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_upsert_dto.dart';
import '../providers/notes_provider.dart';
import 'home.dart';

class AuthScreen extends StatefulWidget {
  final NotesProvider notesProvider;
  const AuthScreen({super.key, required this.notesProvider});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late NotesProvider _notesProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
    void initState() {
      super.initState();
      _notesProvider = widget.notesProvider;
    }

  String? _validatePassword(String? value) {
      if (value!.length < 5) {
        return 'Password must be at least 5 characters long';
      }
      if (!value.contains(RegExp(r'\d'))) {
        return 'Password must contain at least one digit';
      }
      if (!value.contains(RegExp(r'[a-zA-Z]'))) {
        return 'Password must contain at least one letter';
      }
      return null; 
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.grey.shade800,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20), // Ограничение на длину пароля (максимум 20 символов)
                  ],
                  validator: _validatePassword ,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var loginResult = await _notesProvider.loginUser(
                      UserUpsertDto(
                        name: _nameController.text,
                        password: _passwordController.text,
                      ),
                    );
                    if (loginResult) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(notesProvider: _notesProvider),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Цвет текста кнопки
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Размеры отступов
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Закругленные углы
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18), // Размер текста
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var additionResult = await _notesProvider.addUser(
                      UserUpsertDto(
                        name: _nameController.text,
                        password: _passwordController.text,
                      ),
                    );
                    if (additionResult) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(notesProvider: _notesProvider),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Цвет текста кнопки
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Размеры отступов
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Закругленные углы
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18), // Размер текста
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}