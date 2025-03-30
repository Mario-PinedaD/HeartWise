// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService {
  static Future<MySqlConnection> getConnection() async {
    await dotenv.load(fileName: ".env"); // Cargar el archivo .env

    var settings = ConnectionSettings(
      host: dotenv.env['DB_HOST'].toString(),
      port: int.parse(dotenv.env['DB_PORT'].toString()),
      user: dotenv.env['DB_USER'],
      password: dotenv.env['DB_PASSWORD'],
      db: dotenv.env['DB_NAME'],
    );
    return await MySqlConnection.connect(settings);
  }

  static Future<Map<String, dynamic>?> enviarUsuario(Map<String, dynamic> datos) async {
    final url = Uri.parse('https://shiuko.me/login');
    final response = await http.post(
      url,
      body: json.encode(datos),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Datos enviados correctamente. Respuesta del servidor: ${response.body}');
      // Decodifica la respuesta JSON y la devuelve
      return json.decode(response.body);
    } else {
      print('Error al enviar datos: ${response.statusCode}');
      return null; // Indica fallo
    }
  }

  static Future<Map<String, dynamic>?> registrarUsuario (Map<String, dynamic> datos) async {
    final url = Uri.parse('https://shiuko.me/registrar');
    final response = await http.post(
      url,
      body: json.encode(datos),
      headers: {'Content-Type': 'application/json'},
    );

    print("Datos enviados: $datos");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Datos enviados correctamente. Respuesta del servidor: ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Error al enviar datos: ${response.statusCode}, ${response.body}');
    }
  }
}