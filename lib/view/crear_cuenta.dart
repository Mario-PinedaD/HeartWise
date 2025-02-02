// register_screen.dart
import 'package:flutter/material.dart';
import 'package:heartwise/view/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[700],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.favorite, color: Colors.white, size: 48),
            SizedBox(height: 20),
            Text('Crear una Cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(decoration: InputDecoration(labelText: 'Nombre Completo')),
                    TextField(decoration: InputDecoration(labelText: 'Correo Electrónico')),
                    Row(
                      children: [
                        Expanded(child: TextField(decoration: InputDecoration(labelText: 'Edad'))),
                        SizedBox(width: 8),
                        Expanded(child: TextField(decoration: InputDecoration(labelText: 'Sexo'))),
                      ],
                    ),
                    TextField(obscureText: true, decoration: InputDecoration(labelText: 'Contraseña')),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Ya tienes una cuenta? Inicia Sesión', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

