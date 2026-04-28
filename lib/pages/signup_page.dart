import 'package:flutter/material.dart';
import 'package:audio_app/services/auth_service.dart';
import 'package:audio_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();

  DateTime? selectedDate;
  final auth = AuthService();

  void signup() async {
    if (nomController.text.isEmpty ||
        prenomController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Remplir tous les champs")),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Choisir date de naissance")),
      );
      return;
    }

    int age = DateTime.now().year - selectedDate!.year;

    if (age < 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Âge minimum 13 ans")),
      );
      return;
    }

    try {
      await auth.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'nom': nomController.text,
        'prenom': prenomController.text,
        'email': emailController.text,
        'date_naissance': selectedDate.toString(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomController, decoration: InputDecoration(labelText: "Nom")),
            TextField(controller: prenomController, decoration: InputDecoration(labelText: "Prénom")),

            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2005),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Text(selectedDate == null
                  ? "Choisir date de naissance"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
            ),

            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),

            SizedBox(height: 20),

            ElevatedButton(onPressed: signup, child: Text("Créer compte")),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Déjà un compte ? Login"),
            )
          ],
        ),
      ),
    );
  }
}