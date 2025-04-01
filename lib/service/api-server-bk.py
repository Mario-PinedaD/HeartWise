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

# Configuración de la carpeta de carga al servidor
UPLOAD_FOLDER = '/var/www/flask/MiFlask/uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Verificar que la carpeta uploads exista para guardar los archivos
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if 'file' not in request.files:
            return 'No file part'
        file = request.files['file']
        if file.filename == '':
            return 'No selected file'
        if file:
            filename = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
            file.save(filename)
            return 'File uploaded successfully'

    # Contenido HTML directamente en una cadena
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Subir Archivo</title>
    </head>
    <body>
        <h1>Subir Archivo</h1>
        <form method="POST" enctype="multipart/form-data">
            <input type="file" name="file">
            <input type="submit" value="Subir">
        </form>
    </body>
    </html>
    """

    # Renderizar la cadena HTML usando render_template_string
    return render_template_string(html_content)

# Cargar modelos y escalador pre-entrenados
scaler = joblib.load('/var/www/flask/MiFlask/modelos/escalador.pkl')
regressor = joblib.load('/var/www/flask/MiFlask/modelos/modelo_regresion.pkl')
classifier = joblib.load('/var/www/flask/MiFlask/modelos/modelo_clasificacion.pkl')

# Configuración de la base de datos MariaDB
db_config = {
    'host': '74.249.102.86',
    'user': 'skbd_hw',
    'password': 'skcaba0305',
    'database': 'heartwise',
    'auth_plugin': 'mysql_native_password' #Importante para MariaDB
}

def insert_prediction_data(data, hcy_prediction, hcy_level_prediction):
    """Función para insertar los datos y las predicciones en la base de datos MariaDB."""
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        print("correo: ", data.get('Correo'))

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

        cursor.execute(query, values)
        conn.commit()

    except mysql.connector.Error as e: # Captura errores específicos de MariaDB
        print(f"Error al insertar datos en la base de datos MariaDB: {e}")
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

@app.route('/predict', methods=['POST'])
def predict():
    """
    Función que recibe los datos del formulario, los preprocesa y realiza predicciones
    con los modelos de regresión y clasificación.
    """
    try:
        # 1. Recibir datos del formulario
        data = request.get_json()
        input_data = [data['Genero'], data['Edad'], data['Talla'], data['Peso'], data['IMC'], data['GrasaT'], data['Musculo'], data['MetabBasal'], data['GrasaVisc']]

        # 2. Preprocesar los datos
        input_scaled = scaler.transform([input_data])

        # 3. Realizar predicciones
        hcy_prediction = regressor.predict(input_scaled)[0]
        hcy_level_prediction = classifier.predict(input_scaled)[0]

        if 0 <= hcy_level_prediction <= 4:
            hcy_level_enum = 'bajo'
        elif 5 <= hcy_level_prediction <= 9:
            hcy_level_enum = 'medio'
        elif 10 <= hcy_level_prediction <= 15:
            hcy_level_enum = 'alto'

        insert_prediction_data(data, int(hcy_prediction), hcy_level_enum)

        # 4. Devolver la respuesta
        return jsonify({
            'HCY': int(hcy_prediction),
            'HCY_Level': hcy_level_enum
        })

    except Exception as e:
        return jsonify({'error': str(e)})
    
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