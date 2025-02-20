from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from joblib import load
import pandas as pd

app = FastAPI()

# Cargar modelos y scaler al iniciar el servidor
try:
    regressor = load('modelo_regresion_hcy.joblib')
    scaler = load('scaler.joblib')
except FileNotFoundError:
    raise RuntimeError("No se pudieron cargar los archivos del modelo o scaler.")

# Crear una estructura de datos esperada usando Pydantic
class DatosEntrada(BaseModel):
    edad: float
    imc: float
    colesterol_total: float
    trigliceridos: float
    ldl: float
    glucosa: float

@app.post("/predecir")
def predecir_hcy(datos: DatosEntrada):
    try:
        # Convertir a DataFrame para el modelo
        input_data = pd.DataFrame([datos.dict()])

        # Escalar los datos
        input_data_scaled = scaler.transform(input_data)

        # Hacer la predicción
        predicted_hcy = regressor.predict(input_data_scaled)[0]

        # Devolver el resultado como JSON
        return {"hcy_predicho": float(predicted_hcy)}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error en predicción: {str(e)}")

