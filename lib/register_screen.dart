import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import buat ngisi variabel global

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Isi nama lu bro" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (value) => !value!.contains("@") ? "Email salah" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                validator: (value) => value!.length < 6 ? "Minimal 6 karakter" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // SIMPAN KE VARIABEL GLOBAL
                      registeredName = _nameController.text;
                      registeredEmail = _emailController.text;
                      registeredPassword = _passController.text;

                      Navigator.pop(context); // Balik ke Login
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Akun berhasil dibuat! Silakan Login.")),
                      );
                    }
                  },
                  child: const Text("DAFTAR SEKARANG"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}