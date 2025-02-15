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
    int? edad; // Esta será calcularda con: Fecha nacimiento - fecha actual (obteniendo solo el año)
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
                  onTap: () => ( Navigator.pop(context)), //Navigator.pop(context),
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
                                      : (DateTime.now().difference(_fechaSeleccionada!).inDays ~/ 365).toString(),
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
                              musculo == null ? "Músculo" : "${musculo}",
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
                            onPressed: () => _showInputDialog(context, "Grasa Total"),
                            icon: Icon(
                              Icons.opacity,
                              color: Colors.white,
                            ),
                            label: Text(
                              grasaT == null ? "Grasa" : "${grasaT}",
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
                                  : "${grasaVisc}",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultadosScreen()));
                          print(edad);
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
                if (value != null &&
                    value >= 0 &&
                    value <= (type == 'Peso' ? 300.0 : 999.0)) {
                  setState(() {
                    if (type == "Peso") {
                      peso = value;
                    } else if (type == "Altura") {
                      altura = value.toDouble();
                    } else if (type == "Músculo"){
                      musculo = value;
                    } else if (type == "Grasa Total"){
                      grasaT = value;
                    } else if (type == "IMC"){
                      imc = value;
                    }else if (type == "Grasa Visceral"){
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

  double clasificar(
      double peso,
      double talla,
      double metabBasal,
      double grasaT,
      double edad,
      double imc,
      double grasaVisc,
      double musculo,
      double genero) {
    if (peso <= 0.06) {
      if (talla <= 1.43) {
        if (talla <= -0.61) {
          if (peso <= -0.13) {
            if (peso <= -0.56) {
              if (metabBasal <= -1.00) {
                return 0;
              } else {
                if (talla <= -1.67) {
                  return 0;
                } else {
                  if (metabBasal <= -0.70) {
                    if (grasaT <= 0.12) {
                      if (edad <= -0.41) {
                        if (peso <= -1.17) {
                          return 0;
                        } else {
                          // truncated branch of depth 2
                          return 0; // Asumiendo que la clase es 0
                        }
                      } else {
                        if (peso <= -1.35) {
                          // truncated branch of depth 2
                          return 0; // Asumiendo que la clase es 0
                        } else {
                          // truncated branch of depth 4
                          return 0; // Asumiendo que la clase es 0
                        }
                      }
                    } else {
                      return 5;
                    }
                  } else {
                    if (metabBasal <= -0.63) {
                      if (talla <= -1.26) {
                        return 5;
                      } else {
                        if (talla <= -0.85) {
                          return 0;
                        } else {
                          return 0;
                        }
                      }
                    } else {
                      if (metabBasal <= -0.59) {
                        return 5;
                      } else {
                        if (talla <= -0.90) {
                          // truncated branch of depth 2
                          return 0; // Asumiendo que la clase es 0
                        } else {
                          return 0;
                        }
                      }
                    }
                  }
                }
              }
            } else {
              if (edad <= 1.32) {
                if (imc <= 0.66) {
                  if (talla <= -0.78) {
                    return 0;
                  } else {
                    return 0;
                  }
                } else {
                  return 5;
                }
              } else {
                return 10;
              }
            }
          } else {
            if (grasaVisc <= 0.24) {
              return 5;
            } else {
              return 0;
            }
          }
        } else {
          if (grasaVisc <= -0.38) {
            if (edad <= 0.47) {
              if (metabBasal <= -0.63) {
                if (grasaT <= -0.32) {
                  if (peso <= -1.26) {
                    if (imc <= -1.49) {
                      return 5;
                    } else {
                      return 0;
                    }
                  } else {
                    return 5;
                  }
                } else {
                  if (metabBasal <= -0.66) {
                    if (talla <= 0.24) {
                      return 0;
                    } else {
                      return 10;
                    }
                  } else {
                    return 5;
                  }
                }
              } else {
                if (imc <= -0.76) {
                  if (grasaVisc <= -1.09) {
                    if (grasaT <= -2.15) {
                      if (peso <= -0.99) {
                        return 10;
                      } else {
                        return 0;
                      }
                    } else {
                      if (imc <= -1.35) {
                        return 0;
                      } else {
                        if (edad <= 0.05) {
                          return 5;
                        } else {
                          return 0;
                        }
                      }
                    }
                  } else {
                    if (edad <= -0.13) {
                      if (musculo <= -0.50) {
                        return 5;
                      } else {
                        if (grasaT <= -0.48) {
                          return 0;
                        } else {
                          // truncated branch of depth 3
                          return 0; // Asumiendo que la clase es 0
                        }
                      }
                    } else {
                      if (grasaT <= -0.34) {
                        return 5;
                      } else {
                        return 0;
                      }
                    }
                  }
                } else {
                  if (peso <= -0.07) {
                    if (metabBasal <= -0.18) {
                      if (metabBasal <= -0.44) {
                        if (musculo <= -0.26) {
                          // truncated branch of depth 3
                          return 0; // Asumiendo que la clase es 0
                        } else {
                          return 5;
                        }
                      } else {
                        if (peso <= -0.19) {
                          // truncated branch of depth 4
                          return 0; // Asumiendo que la clase es 0
                        } else {
                          return 5;
                        }
                      }
                    } else {
                      if (imc <= -0.70) {
                        return 0;
                      } else {
                        return 5;
                      }
                    }
                  } else {
                    return 0;
                  }
                }
              }
            } else {
              if (grasaT <= -0.58) {
                if (grasaVisc <= -0.97) {
                  return 0;
                } else {
                  return 5;
                }
              } else {
                return 0;
              }
            }
          } else {
            if (grasaVisc <= 0.07) {
              if (metabBasal <= 0.72) {
                if (musculo <= -0.73) {
                  if (imc <= -0.14) {
                    return 0;
                  } else {
                    return 5;
                  }
                } else {
                  if (talla <= 0.68) {
                    if (musculo <= 1.99) {
                      if (imc <= 0.08) {
                        if (peso <= -0.50) {
                          return 5;
                        } else {
                          return 5;
                        }
                      } else {
                        if (imc <= 0.10) {
                          return 0;
                        } else {
                          // truncated branch of depth 2
                          return 0; // Asumiendo que la clase es 0
                        }
                      }
                    } else {
                      return 10;
                    }
                  } else {
                    return 10;
                  }
                }
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          }
        }
      } else {
        if (genero <= 0.39) {
          return 5;
        } else {
          return 0;
        }
      }
    } else {
      if (grasaVisc <= 3.52) {
        if (grasaVisc <= 0.54) {
          if (grasaVisc <= 0.16) {
            if (peso <= 0.82) {
              if (musculo <= -0.75) {
                if (metabBasal <= -0.23) {
                  return 5;
                } else {
                  if (edad <= -0.46) {
                    return 5;
                  } else {
                    return 0;
                  }
                }
              } else {
                if (imc <= -0.53) {
                  if (edad <= -0.80) {
                    return 5;
                  } else {
                    if (grasaVisc <= -0.66) {
                      return 5;
                    } else {
                      return 0;
                    }
                  }
                } else {
                  if (talla <= -0.66) {
                    return 0;
                  } else {
                    if (edad <= -0.58) {
                      return 5;
                    } else {
                      return 5;
                    }
                  }
                }
              }
            } else {
              if (musculo <= -0.08) {
                return 0;
              } else {
                return 5;
              }
            }
          } else {
            if (grasaT <= 1.51) {
              if (talla <= 0.21) {
                if (imc <= 1.31) {
                  if (genero <= 0.39) {
                    if (talla <= -0.38) {
                      if (talla <= -0.58) {
                        if (grasaVisc <= 0.50) {
                          return 0;
                        } else {
                          return 5;
                        }
                      } else {
                        return 5;
                      }
                    } else {
                      return 0;
                    }
                  } else {
                    return 5;
                  }
                } else {
                  if (grasaT <= 1.37) {
                    return 0;
                  } else {
                    return 10;
                  }
                }
              } else {
                if (grasaT <= -1.04) {
                  return 0;
                } else {
                  if (edad <= -0.40) {
                    if (grasaT <= -0.82) {
                      return 5;
                    } else {
                      if (grasaVisc <= 0.33) {
                        return 5;
                      } else {
                        return 0;
                      }
                    }
                  } else {
                    if (edad <= 1.65) {
                      return 5;
                    } else {
                      return 10;
                    }
                  }
                }
              }
            } else {
              return 5;
            }
          }
        } else {
          if (metabBasal <= -0.10) {
            if (grasaT <= 1.23) {
              return 0;
            } else {
              return 10;
            }
          } else {
            if (peso <= 2.47) {
              if (peso <= 0.45) {
                if (metabBasal <= 0.84) {
                  return 0;
                } else {
                  if (peso <= 0.41) {
                    return 5;
                  } else {
                    return 0;
                  }
                }
              } else {
                if (talla <= 3.02) {
                  if (grasaVisc <= 2.98) {
                    if (edad <= 1.56) {
                      if (grasaVisc <= 0.63) {
                        if (peso <= 1.12) {
                          return 10;
                        } else {
                          // truncated branch of depth 2
                          return 0; // Asumiendo que la clase es 0
                        }
                      } else {
                        if (peso <= 0.53) {
                          return 5;
                        } else {
                          return 5;
                        }
                      }
                    } else {
                      return 5;
                    }
                  } else {
                    return 0;
                  }
                } else {
                  return 0;
                }
              }
            } else {
              if (grasaVisc <= 3.10) {
                return 0;
              } else {
                return 5;
              }
            }
          }
        }
      } else {
        return 10;
      }
    }
  }
}
