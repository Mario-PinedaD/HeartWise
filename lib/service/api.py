from flask import Flask, request, jsonify, render_template_string, redirect, url_for
import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.tree import DecisionTreeRegressor, DecisionTreeClassifier
from sklearn.metrics import mean_squared_error, accuracy_score, precision_score, recall_score
from sklearn.preprocessing import StandardScaler
import joblib
import mysql.connector  # Para MariaDB
from datetime import datetime
import logging
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Cargar modelos y escalador pre-entrenados de los Antropometricos
scaler_antro = joblib.load('/var/www/flask/MiFlask/modelos/escalador.pkl')
regressor_antro = joblib.load('/var/www/flask/MiFlask/modelos/modelo_regresion.pkl')
classifier_antro = joblib.load('/var/www/flask/MiFlask/modelos/modelo_clasificacion.pkl')

# Cargar modelos y escalador pre-entrenados de los Antropometricos Hematologicos
scaler_antro_hema = joblib.load('/var/www/flask/MiFlask/modelos/escalador_hema.pkl')
regressor_hema = joblib.load('/var/www/flask/MiFlask/modelos/modelo_regresion_hema.pkl')
classifier_hema = joblib.load('/var/www/flask/MiFlask/modelos/modelo_clasificacion_hema.pkl')

# Cargar modelos y escalador pre-entrenados de los Antropometricos Hematologicos de ADN
scaler_antro_hema_dna = joblib.load('/var/www/flask/MiFlask/modelos/escalador_hema_dna.pkl')
regressor_hemat_dna = joblib.load('/var/www/flask/MiFlask/modelos/modelo_regresion_hema_dna.pkl')
classifier_hemat_dna = joblib.load('/var/www/flask/MiFlask/modelos/modelo_clasificacion_hema_dna.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    """
    Función que recibe los datos del formulario, los preprocesa y realiza predicciones
    con los modelos de regresión y clasificación.
    """
    try:
        # 1. Recibir datos del formulario
        data = request.get_json()
        input_data_antro = [data['Genero'], data['Edad'], data['Talla'], data['Peso'], data['IMC'], data['GrasaT'], data['Musculo'], data['MetabBasal'], data['GrasaVisc']]

        input_data_hema = [data['Genero'], data['Edad'], data['Talla'], data['Peso'], data['IMC'], data['GrasaT'], data['Musculo'], data['MetabBasal'], data['GrasaVisc'], data['Colesterol'], data['Trigliceridos'], data['Hdl'], data['Ldl'], data['Vldl']]

        input_data_hema_dna = [data['Genero'], data['Edad'], data['Talla'], data['Peso'], data['IMC'], data['GrasaT'], data['Musculo'], data['MetabBasal'], data['GrasaVisc'], data['Colesterol'], data['Trigliceridos'], data['Hdl'], data['Ldl'], data['Vldl'], data['alu'], data['line'], data['sat']]

        condition_data = [data['tipo']]

        if condition_data == 1:

            # 2. Preprocesar los datos
            input_scaled = scaler_antro.transform([input_data_antro])

            # 3. Realizar predicciones
            hcy_prediction = regressor_antro.predict(input_scaled)[0]
            hcy_level_prediction = classifier_antro.predict(input_scaled)[0]
        
        elif condition_data == 2:
            # 2. Preprocesar los datos
            input_scaled = scaler_antro_hema.transform([input_data_hema])

            # 3. Realizar predicciones
            hcy_prediction = regressor_hema.predict(input_scaled)[0]
            hcy_level_prediction = classifier_hema.predict(input_scaled)[0]

        else:
            # 2. Preprocesar los datos
            input_scaled = scaler_antro_hema_dna.transform([input_data_hema_dna])

            # 3. Realizar predicciones
            hcy_prediction = regressor_hemat_dna.predict(input_scaled)[0]
            hcy_level_prediction = classifier_hemat_dna.predict(input_scaled)[0]


        if 0 <= hcy_level_prediction <= 4:
            hcy_level_enum = 'bajo'
        elif 5 <= hcy_level_prediction <= 9:
            hcy_level_enum = 'medio'
        elif 10 <= hcy_level_prediction <= 15:
            hcy_level_enum = 'alto'

        insert_prediction_data(data, int(hcy_prediction), hcy_level_enum)

        # 4. Devolver la respuesta
        return jsonify({
            'Prueba': 'Antropometría' if condition_data == 1 else 'Hematologica' if condition_data == 2 else 'Hematologica + ADN',
            'HCY': int(hcy_prediction),
            'HCY_Level': hcy_level_enum
        })

    except Exception as e:
        return jsonify({'error': str(e)})

def insert_prediction_data(data, hcy_prediction, hcy_level_prediction):
    """Función para insertar los datos y las predicciones en la base de datos MariaDB,
    dependiendo del tipo de prueba."""
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        print("correo: ", data.get('Correo'))

        tipo_prueba = data.get('tipo')

        if tipo_prueba == 1:  # Antropometría
            query = """
            INSERT INTO Resultados (correo_usuario, genero, edad, talla_cm, peso_kg, imc, grasa_total, musculo, metabolismo_basal, grasa_visceral, hcy_level, procesado, hcy)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                data.get('Correo'),
                data.get('Genero'),
                data.get('Edad'),
                data.get('Talla'),
                data.get('Peso'),
                data.get('IMC'),
                data.get('GrasaT'),
                data.get('Musculo'),
                data.get('MetabBasal'),
                data.get('GrasaVisc'),
                hcy_level_prediction,
                0,
                hcy_prediction
            )
            print("Guardando datos de Antropometrica")
        elif tipo_prueba == 2:  # Hematología
            query = """
            INSERT INTO Resultados (correo_usuario, genero, edad, talla_cm, peso_kg, imc, grasa_total, musculo, metabolismo_basal, grasa_visceral, colesterol, trigliceridos, hdl, ldl, vldl, hcy_level, procesado, hcy)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                data.get('Correo'),
                data.get('Genero'),
                data.get('Edad'),
                data.get('Talla'),
                data.get('Peso'),
                data.get('IMC'),
                data.get('GrasaT'),
                data.get('Musculo'),
                data.get('MetabBasal'),
                data.get('GrasaVisc'),
                data.get('Colesterol'),
                data.get('Trigliceridos'),
                data.get('Hdl'),
                data.get('Ldl'),
                data.get('Vldl'),
                hcy_level_prediction,
                0,
                hcy_prediction
            )
            print("Guardando datos de Hematologica")
        elif tipo_prueba == 3: #Hematología + ADN
            query = """
            INSERT INTO Resultados (correo_usuario, genero, edad, talla_cm, peso_kg, imc, grasa_total, musculo, metabolismo_basal, grasa_visceral, colesterol, trigliceridos, hdl, ldl, vldl, alu, line, sat, hcy_level, procesado, hcy)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                data.get('Correo'),
                data.get('Genero'),
                data.get('Edad'),
                data.get('Talla'),
                data.get('Peso'),
                data.get('IMC'),
                data.get('GrasaT'),
                data.get('Musculo'),
                data.get('MetabBasal'),
                data.get('GrasaVisc'),
                data.get('Colesterol'),
                data.get('Trigliceridos'),
                data.get('Hdl'),
                data.get('Ldl'),
                data.get('Vldl'),
                data.get('alu'),
                data.get('line'),
                data.get('sat'),
                hcy_level_prediction,
                0,
                hcy_prediction
            )
            print("Guardando datos de Hematologica + ADN")
        else:
            raise ValueError("Tipo de prueba no válido.")

        cursor.execute(query, values)
        conn.commit()

        if cursor.rowcount > 0:
            print("Datos insertados correctamente.")
        else:
            print("No se insertaron datos.")

    except mysql.connector.Error as e:
        print(f"Error al insertar datos en la base de datos MariaDB: {e}")
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/registrar', methods=['POST'])
def registrar():
    """Maneja la solicitud de registro de usuario desde la ruta /registrar."""
    data = request.get_json()
    nombre = data.get('nombre')
    email = data.get('email')
    fecha_nacimiento = data.get('fechaNacimiento')
    genero = data.get('genero')
    password = data.get('password')

    if not nombre or not email or not fecha_nacimiento or not genero or not password:
        return jsonify({'error': 'Faltan datos para el registro'}), 400

    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        query = "INSERT INTO Usuarios (correo, nombre, contraseña, fecnac, genero, rol, estado) VALUES (%s, %s, %s, %s, %s, %s, %s)"

        logging.debug(f"Consulta SQL: {query}")
        logging.debug(f"Valores: {email}, {nombre}, {password}, {fecha_nacimiento}, {genero}, 'publico', 'Veracruz'")

        cursor.execute(query, (email, nombre, password, fecha_nacimiento, genero, 'publico', 'Veracruz'))
        conn.commit()

        logging.debug('Usuario registrado exitosamente')
        return jsonify({'message': 'Usuario registrado exitosamente'}), 200

    except mysql.connector.Error as err:
        logging.error(f"Error al registrar el usuario: {err}")
        return jsonify({'error': 'Error al registrar el usuario'}), 500

    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

    return "Exito"

@app.route('/connectionpy')
def connection():
    return "!El servidor Flask está funcionando correctamente!"

@app.route('/')
def principal():
   return "Hola tilin"

def iniciar_sesion(email, password):
    """Verifica las credenciales de inicio de sesión del usuario y devuelve sus datos."""
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        query = "SELECT * FROM Usuarios WHERE correo = %s AND contraseña = %s"
        cursor.execute(query, (email, password))
        results = cursor.fetchall()
        if results:
            return results[0]
        else:
            return None
    except mysql.connector.Error as err:
        print(f"Error durante inicio de sesión: '{err}'")
        return None
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/login', methods=['POST'])
def login():
    """Maneja la solicitud de inicio de sesión desde la ruta /login."""
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Faltan correo electrónico o contraseña'}), 400

    usuario = iniciar_sesion(email, password)

    if usuario:
        return jsonify({'message': 'Inicio de sesión exitoso', 'usuario': usuario}), 200
    else:
        return jsonify({'error': 'Credenciales incorrectas'}), 401

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)





