import 'package:flutter/material.dart';
import 'package:audio_app/services/auth_service.dart';
import 'package:audio_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_app/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final auth = AuthService();

  void login() async {
    try {
      await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login réussi ✅")));

      // 🔥 Aller vers Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void resetPasswordDirect() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Remplir tous les champs")));
      return;
    }

    try {
      // 🔥 récupérer user
      final user = FirebaseAuth.instance.currentUser;

      // 🔥 créer credential
      AuthCredential credential = EmailAuthProvider.credential(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 🔥 re-authentification (IMPORTANT)
      await user!.reauthenticateWithCredential(credential);

      // 🔥 changer mot de passe
      await user.updatePassword(newPasswordController.text.trim());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Mot de passe modifié ✅")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Firebase')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: "Nouveau mot de passe"),
              obscureText: true,
            ),

            SizedBox(height: 20),

            ElevatedButton(onPressed: login, child: Text("Login")),

            ElevatedButton(
              onPressed: resetPasswordDirect,
              child: Text("Reset Password"),
            ),

            // 🔥 AJOUT ICI
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupPage()),
                );
              },
              child: Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
