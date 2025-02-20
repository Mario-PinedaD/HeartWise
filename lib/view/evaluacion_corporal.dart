import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/resultados_screen.dart';
import 'package:intl/intl.dart';

class EvaluacionCorporalScreen extends StatefulWidget {
  @override
  _EvaluacionCorporalScreen createState() => _EvaluacionCorporalScreen();
}

class _EvaluacionCorporalScreen extends State<EvaluacionCorporalScreen> {
  DateTime? _fechaSeleccionada;
  int?
      edad; // Esta será calcularda con: Fecha nacimiento - fecha actual (obteniendo solo el año)
  String? _selectedGender;
  int? genero; //1 = Hombre | 2 = Mujer
  double? peso; //Peso, no sabes leer o q?
  double? altura; //Es lo mismo que 'Talla'
  //Estos son para comenzar con los análisis y predicciones:
  double? metabBasal;
  double? grasaT;
  double? imc;
  double? grasaVisc;
  double? musculo;

  @override
  Widget build(BuildContext context) {
    double? screenAlto = MediaQuery.of(this.context).size.height;
    double screenAncho = MediaQuery.of(this.context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFDC3644),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de regreso
                InkWell(
                  onTap: () => (Navigator.pop(context)),
                  //Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evaluación Corporal Básica',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'La Evaluación Corporal Básica ofrece un análisis esencial de los principales indicadores físicos y '
                        'de composición corporal del usuario. Este test es ideal para obtener una visión rápida y '
                        'sencilla del estado físico general. Con estos datos, el usuario puede comprender mejor '
                        'su composición física y recibir alertas tempranas sobre posibles riesgos de salud '
                        'relacionados con el peso o la grasa visceral.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Paciente',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Usuario Guapo Precioso',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de ingreso de información
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ingresa la información',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Fila de datos (Edad y Sexo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                //antes estaba _fechaSeleecionada
                                setState(() {
                                  _fechaSeleccionada = pickedDate;
                                  edad = DateTime.now()
                                          .difference(_fechaSeleccionada!)
                                          .inDays ~/
                                      365;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  /*Ahora lo que hace es obtener la diferencia entre las 2 fechas
                                   Lo divide entre los días y puede obtener con precisión los años
                                   Habría que compararla con la edad del usuario para sustituir la _fechaSeleccionada
                                   con la fecha del usuario a la hora de registrarse
                                  */
                                  _fechaSeleccionada == null
                                      ? 'Edad'
                                      : (DateTime.now()
                                                  .difference(
                                                      _fechaSeleccionada!)
                                                  .inDays ~/
                                              365)
                                          .toString(),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            // No necesita acción aquí, el PopupMenuButton manejará el tap
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red, // Fondo rojo
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Bordes redondeados
                              ),
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: (String newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                  if (_selectedGender == "Hombre") {
                                    genero = 1;
                                  } else {
                                    genero = 2;
                                  }
                                });
                              },
                              color: Colors.white,
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    value: "Hombre", child: Text("Hombre")),
                                PopupMenuItem(
                                    value: "Mujer", child: Text("Mujer")),
                              ],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.male, color: Colors.white),
                                  // Icono en blanco
                                  SizedBox(width: 8),
                                  Text(
                                    _selectedGender ?? "Sexo",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Texto en blanco
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  // Flecha blanca
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Fila de datos (Peso y Altura)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showInputDialog(context, "Peso"),
                            icon: Icon(
                              Icons.scale,
                              color: Colors.white,
                            ),
                            label: Text(
                              peso == null ? "Peso" : "${peso} kg",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Altura"),
                                //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: Icon(
                              Icons.height,
                              color: Colors.white,
                            ),
                            label: Text(
                              altura == null ? "Altura" : "${altura} cm",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // TERCER FILA (METABOLISMO Y GRASA TOTAL)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Músculo"),
                            icon: Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              musculo == null ? "Músculo" : "${musculo}%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Grasa Total"),
                            icon: Icon(
                              Icons.opacity,
                              color: Colors.white,
                            ),
                            label: Text(
                              grasaT == null ? "Grasa" : "${grasaT}%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showInputDialog(context, "IMC"),
                            icon: Icon(
                              Icons.monitor_weight,
                              color: Colors.white,
                            ),
                            label: Text(
                              imc == null ? "IMC" : "${imc}",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Grasa Visceral"),
                            icon: Icon(
                              Icons.opacity_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              grasaVisc == null
                                  ? "Grasa Visceral"
                                  : "${grasaVisc}%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Metabolismo"),
                            icon: Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                            ),
                            label: Text(
                              metabBasal == null
                                  ? "Metabolismo"
                                  : "${metabBasal}",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Botón Finalizar
                      ElevatedButton(
                        onPressed: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultadosScreen()));*/
                          print(edad);
                          print(genero);
                          print(peso);
                          print(altura);
                          print(musculo);
                          print(grasaT);
                          print(imc);
                          print(grasaVisc);
                          print(metabBasal);
                          print("ESTE ES EL RESULTADO DE LA REGRESION");
                          print(calcularRegresion(
                              edad!,
                              genero!,
                              peso!,
                              altura!,
                              musculo!,
                              grasaT!,
                              imc!,
                              grasaVisc!,
                              metabBasal!));
                          print("ESTE ES EL RESULTADO DE LA CLASIFICACION");
                          print(calcularClasificacion(
                              edad!,
                              genero!,
                              peso!,
                              altura!,
                              musculo!,
                              grasaT!,
                              imc!,
                              grasaVisc!,
                              metabBasal!));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                        ),
                        child: Text(
                          'Finalizar',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para las tarjetas de información
  Widget infoCard(IconData icon, String label, String value) {
    return Card(
      color: Colors.red[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '$label $value',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialog(
    BuildContext context,
    String titulo,
    double variable,
    String unidad,
    ValueChanged<double> onValueChanged,
  ) {
    TextEditingController controller = TextEditingController(text: variable.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingrese: $titulo ($unidad)",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Ingrese el valor"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                double? value = double.tryParse(controller.text);
                if (value != null && value >= 0) {
                  onValueChanged(value);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Aceptar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInputDialog(BuildContext context, String type) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingrese su $type",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: ""),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                double? value = double.tryParse(controller.text);
                if (value != null && value >= 0) {
                  setState(() {
                    if (type == "Peso") {
                      peso = value;
                    } else if (type == "Altura") {
                      altura = value.toDouble();
                    } else if (type == "Músculo") {
                      musculo = value;
                    } else if (type == "Grasa Total") {
                      grasaT = value;
                    } else if (type == "IMC") {
                      imc = value;
                    } else if (type == "Grasa Visceral") {
                      grasaVisc = value;
                    } else {
                      metabBasal = value;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Aceptar",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  double calcularRegresion(
      int Edad,
      int Genero,
      double Peso,
      double Talla,
      double Musculo,
      double GrasaT,
      double IMC,
      double GrasaVisceral,
      double MetabBasal) {
    if (IMC <= 31.14) {
      if (Musculo <= 43.71) {
        if (Peso <= 61.20) {
          if (IMC <= 17.51) {
            if (Musculo <= 28.42)
              return 10.22126;
            else
              return 14.20329805;
          } else {
            if (MetabBasal <= 1080.73)
              return 8.10861737;
            else
              return 9.55598545;
          }
        } else {
          if (Talla <= 158.00) {
            if (Genero <= 1.50)
              return 9.71924446;
            else
              return 12.76163559;
          } else {
            if (IMC <= 24.30)
              return 10.13882596;
            else
              return 11.33274658;
          }
        }
      } else {
        if (GrasaVisceral <= 4.82) {
          if (Peso <= 50.56)
            return 15.78270056;
          else {
            if (GrasaVisceral <= 3.04)
              return 9.16494345;
            else
              return 12.04795312;
          }
        } else
          return 25.82548498;
      }
    } else {
      if (Peso <= 69.00)
        return 32.42158015;
      else {
        if (GrasaVisceral <= 13.69) {
          if (Edad <= 21.48) {
            if (MetabBasal <= 1460.27)
              return 13.4277745;
            else
              return 10.86314948;
          } else
            return 16.86646289;
        } else {
          if (Peso <= 108.15) {
            if (Musculo <= 30.16)
              return 16.72637142;
            else
              return 14.90399254;
          } else
            return 19.66379629;
        }
      }
    }
  }

  List<double> calcularClasificacion(
      int Edad,
      int Sexo,
      double Peso,
      double Talla,
      double Musculo,
      double GrasaTotal,
      double IMC,
      double GrasaVisc,
      double MetabBasal) {
    if (Peso <= 64.81 && Talla <= 173.29) {
      if (Talla <= 154.95) {
        if (Peso <= 62.28) {
          if (Peso <= 56.46) {
            if (MetabBasal <= 1080.16)
              return [1.0, 0.0, 0.0];
            else {
              if (Talla <= 145.40)
                return [1.0, 0.0, 0.0];
              else {
                if (MetabBasal <= 1166.47) {
                  if (GrasaTotal <= 34.43) {
                    if (Edad <= 18.18) {
                      if (Peso <= 48.10)
                        return [1.0, 0.0, 0.0];
                      else {
                        if (GrasaTotal <= 31.90)
                          return [0.25, 0.75, 0.0];
                        else
                          return [1.0, 0.0, 0.0];
                      }
                    } else {
                      if (Peso <= 45.63) {
                        if (Edad <= 20.50)
                          return [0.0, 1.0, 0.0];
                        else
                          return [1.0, 0.0, 0.0];
                      } else {
                        if (Peso <= 49.25) {
                          if (Musculo <= 25.08)
                            return [0.0, 1.0, 0.0];
                          else {
                            if (MetabBasal <= 1158.86)
                              return [1.0, 0.0, 0.0];
                            else
                              return [0.0, 1.0, 0.0];
                          }
                        } else
                          return [0.0, 1.0, 0.0];
                      }
                    }
                  } else
                    return [0.0, 1.0, 0.0];
                } else {
                  if (MetabBasal <= 1185.66) {
                    if (Talla <= 149.11)
                      return [0.0, 1.0, 0.0];
                    else {
                      if (Talla <= 152.75)
                        return [1.0, 0.0, 0.0];
                      else
                        return [0.8, 0.2, 0.0];
                    }
                  } else {
                    if (MetabBasal <= 1196.25)
                      return [0.0, 1.0, 0.0];
                    else {
                      if (Talla <= 152.34) {
                        if (Talla <= 150.21)
                          return [1.0, 0.0, 0.0];
                        else
                          return [0.0, 1.0, 0.0];
                      } else
                        return [1.0, 0.0, 0.0];
                    }
                  }
                }
              }
            }
          } else {
            if (Edad <= 21.07) {
              if (IMC <= 27.86) {
                if (Talla <= 153.44)
                  return [1.0, 0.0, 0.0];
                else
                  return [0.8, 0.2, 0.0];
              } else
                return [0.0, 1.0, 0.0];
            } else
              return [0.0, 0.0, 1.0];
          }
        } else {
          if (GrasaVisc <= 5.56) return [0.0, 1.0, 0.0];
        }
      }
    }
    return [0.0, 0.0, 0.0]; // Valor por defecto
  }
}
