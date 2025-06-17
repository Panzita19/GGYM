from flask import Blueprint, jsonify, request
from Entrenadores_Model.Bd_entrenadores import Entrenador

entrenadores_bp = Blueprint('entrenadores', __name__)

@entrenadores_bp.route('/entrenadores', methods=['POST'])
def crear_entrenador_api():
    try:
        data = request.json
        entrenador = Entrenador(
            nombre_completo=data.get('nombre_completo'),
            cedula=data.get('cedula'),
            correo=data.get('correo'),
            telefono=data.get('telefono'),
            fecha_nacimiento=data.get('fecha_nacimiento'),
            direccion=data.get('direccion'),
            especialidad=data.get('especialidad'),
            certificacion=data.get('certificacion')
        )

        if not all([entrenador.nombre_completo, entrenador.cedula, entrenador.correo, entrenador.telefono,
                    entrenador.fecha_nacimiento, entrenador.direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el entrenador.'}), 400

        entrenador_id = entrenador.insertar()
        if entrenador_id:
            return jsonify({'message': f'Entrenador con ID {entrenador_id} insertado correctamente.', 'entrenador_id': entrenador_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el entrenador.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@entrenadores_bp.route('/entrenadores/<int:entrenador_id>', methods=['DELETE'])
def eliminar_entrenador_api(entrenador_id):
    try:
        if Entrenador.eliminar(entrenador_id):
            return jsonify({'message': f'Entrenador {entrenador_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el entrenador {entrenador_id}.'}), 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@entrenadores_bp.route('/entrenadores', methods=['GET'])
def listar_entrenadores_api():
    try:
        entrenadores = Entrenador.listar()
        return jsonify(entrenadores), 200 if entrenadores else 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
