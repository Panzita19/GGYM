from flask import Blueprint, jsonify, request
from Supervisores_Model.Bd_supervisores import Supervisor

supervisores_bp = Blueprint('supervisores', __name__)

@supervisores_bp.route('/supervisores', methods=['POST'])
def crear_supervisor_api():
    try:
        data = request.json
        supervisor = Supervisor(
            nombre_completo=data.get('nombre_completo'),
            cedula=data.get('cedula'),
            correo=data.get('correo'),
            telefono=data.get('telefono'),
            fecha_nacimiento=data.get('fecha_nacimiento'),
            direccion=data.get('direccion')
        )

        if not all([supervisor.nombre_completo, supervisor.cedula, supervisor.correo, supervisor.telefono,
                    supervisor.fecha_nacimiento, supervisor.direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el supervisor.'}), 400

        supervisor_id = supervisor.insertar()
        if supervisor_id:
            return jsonify({'message': f'Supervisor con ID {supervisor_id} insertado correctamente.', 'supervisor_id': supervisor_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el supervisor.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@supervisores_bp.route('/supervisores/<int:supervisor_id>', methods=['DELETE'])
def eliminar_supervisor_api(supervisor_id):
    try:
        if Supervisor.eliminar(supervisor_id):
            return jsonify({'message': f'Supervisor {supervisor_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el supervisor {supervisor_id}.'}), 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@supervisores_bp.route('/supervisores', methods=['GET'])
def listar_supervisores_api():
    try:
        supervisores = Supervisor.listar()
        return jsonify(supervisores), 200 if supervisores else 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
