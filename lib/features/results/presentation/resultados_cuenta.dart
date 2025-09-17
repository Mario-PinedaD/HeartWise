// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultadosPorCorreo extends StatefulWidget {
  final String correo;

  ResultadosPorCorreo({super.key, required this.correo});

  @override
  _ResultadosPorCorreoState createState() => _ResultadosPorCorreoState();
}

class _ResultadosPorCorreoState extends State<ResultadosPorCorreo> {
  List<dynamic>? resultados;
  String? error;
  bool isLoading = true; // Agregamos un indicador de carga

  // Método para recibir los datos de Resultados por correo
  static Future<List<dynamic>?> obtenerDatosPorCorreo(String correo) async {
    final url = Uri.parse('https://shiuko.me/resultados/$correo');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(
            'Datos recibidos correctamente. Respuesta del servidor: ${response.body}');
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

  @override
  void initState() {
    super.initState();
    _cargarDatos(); // Llama a la función para cargar los datos al iniciar el widget
  }

  Future<void> _cargarDatos() async {
    resultados = await obtenerDatosPorCorreo(
        widget.correo); // Espera a que la función termine
    setState(() {}); // Actualiza el estado para reconstruir el widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: error != null
          ? Center(child: Text(error!))
          : resultados != null
              ? ListView.builder(
                  itemCount: resultados!.length,
                  itemBuilder: (context, index) {
                    final resultado = resultados![index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        subtitle: Text(resultado
                            .toString()), // Muestra los resultados como texto
                      ),
                    );
                  },
                )
              : Center(child: Text('No hay resultados disponibles')),
    );
  }
}
