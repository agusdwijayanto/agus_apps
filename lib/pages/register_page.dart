import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../db/database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nimController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final passwordController = TextEditingController();

  String? jenisKelamin;
  bool membaca = false;
  bool olahraga = false;
  bool musik = false;

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> actionRegistrasi() async {
    if (!_formKey.currentState!.validate()) return;

    final hobi = <String>[];
    if (membaca) hobi.add('Membaca');
    if (olahraga) hobi.add('Olahraga');
    if (musik) hobi.add('Musik');

    try {
      await DatabaseHelper.instance.register({
        'nim': nimController.text.trim(),
        'nama': namaController.text.trim(),
        'email': emailController.text.trim(),
        'no_hp': hpController.text.trim(),
        'jenis_kelamin': jenisKelamin ?? 'Laki-laki',
        'hobi': hobi.join(', '),
        'password': passwordController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Registrasi berhasil, silakan login')),
      );
      Navigator.pop(context);
    } on DatabaseException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIM sudah terdaftar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nimController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: hpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor HP tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Jenis Kelamin'),
            RadioListTile<String>(
              title: const Text('Laki-laki'),
              value: 'Laki-laki',
              groupValue: jenisKelamin,
              onChanged: (value) {
                setState(() {
                  jenisKelamin = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Perempuan'),
              value: 'Perempuan',
              groupValue: jenisKelamin,
              onChanged: (value) {
                setState(() {
                  jenisKelamin = value;
                });
              },
            ),
            const SizedBox(height: 8),
            const Text('Hobi'),
            CheckboxListTile(
              title: const Text('Membaca'),
              value: membaca,
              onChanged: (value) {
                setState(() {
                  membaca = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Olahraga'),
              value: olahraga,
              onChanged: (value) {
                setState(() {
                  olahraga = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Musik'),
              value: musik,
              onChanged: (value) {
                setState(() {
                  musik = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: actionRegistrasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('DAFTAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
