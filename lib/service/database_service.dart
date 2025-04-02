// Importaciones necesarias para el funcionamiento del servicio
// ignore_for_file: depend_on_referenced_packages

import 'package:http/http.dart' as http;  // Para realizar peticiones HTTP
import 'dart:convert';                    // Para codificación/decodificación JSON

/// Clase que maneja todas las interacciones con el servidor
class DatabaseService {

  /// Método para autenticar usuarios
  /// Recibe un mapa con las credenciales y retorna la respuesta del servidor
  static Future<Map<String, dynamic>?> enviarUsuario(Map<String, dynamic> datos) async {
    // URL del endpoint de login
    final url = Uri.parse('https://shiuko.me/login');
    
    // Realiza la petición POST con los datos del usuario
    final response = await http.post(
      url,
      body: json.encode(datos),          // Convierte datos a JSON
      headers: {'Content-Type': 'application/json'}, // Define tipo de contenido
    );

    // Verifica si la petición fue exitosa (códigos 200 o 201)
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Datos enviados correctamente. Respuesta del servidor: ${response.body}');
      return json.decode(response.body); // Retorna datos decodificados
    } else {
      print('Error al enviar datos: ${response.statusCode}');
      return null; // Retorna null en caso de error
    }
  }

  /// Método para registrar nuevos usuarios
  /// Recibe los datos del usuario y retorna la respuesta del servidor
  static Future<Map<String, dynamic>?> registrarUsuario(Map<String, dynamic> datos) async {
    // URL del endpoint de registro
    final url = Uri.parse('https://shiuko.me/registrar');
    
    // Realiza la petición POST
    final response = await http.post(
      url,
      body: json.encode(datos),
      headers: {'Content-Type': 'application/json'},
    );

    print("Datos enviados: $datos"); // Log para depuración

    // Verifica respuesta del servidor
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Datos enviados correctamente. Respuesta del servidor: ${response.body}');
      return json.decode(response.body);
    } else {
      // Lanza excepción con detalles del error
      throw Exception('Error al enviar datos: ${response.statusCode}, ${response.body}');
    }
  }

  /// Método para enviar datos al modelo predictivo
  /// Recibe datos médicos/antropométricos y retorna predicciones
  static Future<Map<String, dynamic>?> enviarDatos01(Map<String, dynamic> datos) async {
    // URL del endpoint de predicción
    final url = Uri.parse('https://shiuko.me/predict');
    
    // Realiza la petición POST con los datos
    final response = await http.post(
      url,
      body: json.encode(datos),
      headers: {'Content-Type': 'application/json'},
    );

    // Verifica respuesta
    if (response.statusCode == 200) {
      print('Datos enviados correctamente. Respuesta del servidor: ${response.body}');
      return json.decode(response.body); // Retorna predicción
    } else {
      print('Error al enviar datos: ${response.statusCode}');
      return null; // Retorna null en caso de error
    }
  }

  // Método para recibir los datos de Resultados por correo
  static Future<Map<String, dynamic>?> obtenerDatosPorCorreo(String correo) async {
    final url = Uri.parse('https://shiuko.me/resultados/$correo');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Datos recibidos correctamente. Respuesta del servidor: ${response.body}');
        return json.decode(response.body); // Retorna datos decodificados
      } else {
        print('Error al recibir datos: ${response.statusCode}');
        return null; // Retorna null en caso de error
      }
    } catch (e) {
      print('Error al realizar la petición: $e');
      return null; // Retorna null en caso de excepción
    }
  }
}