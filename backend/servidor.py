from flask import Flask
from flask_cors import CORS

# Importar Blueprints
from Usuarios_Controller.control_usuarios import usuarios_bp
from Entrenadores_Controller.control_entrenadores import entrenadores_bp
from Supervisores_Controller.control_supervisores import supervisores_bp
from Rutinas_Controller.control_rutinas import rutinas_bp
from Pagos_Controller.control_pagos import pagos_bp
from Planes_Controller.control_planes import planes_bp

app = Flask(__name__)
CORS(app)

# Registrar Blueprints
app.register_blueprint(usuarios_bp)
app.register_blueprint(entrenadores_bp)
app.register_blueprint(supervisores_bp)
app.register_blueprint(rutinas_bp)
app.register_blueprint(pagos_bp)
app.register_blueprint(planes_bp)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
