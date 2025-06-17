from flask import Blueprint, jsonify, request
from Rutinas_Model.Bd_rutinas import Rutina

rutinas_bp = Blueprint('rutinas', __name__)

@rutinas_bp.route('/rutinas', methods=['POST'])
def crear_rutina_api():
    try:
        data = request.json
        rutina = Rutina(
            entrenador_id=data.get('entrenador_id'),
            nombre_rutina=data.get('nombre_rutina'),
            descripcion=data.get('descripcion')
        )

        if not all([rutina.entrenador_id, rutina.nombre_rutina]):
            return jsonify({'error': 'Faltan datos obligatorios para la rutina.'}), 400

        rutina_id = rutina.insertar()
        if rutina_id:
            return jsonify({'message': f'Rutina con ID {rutina_id} insertada correctamente.', 'rutina_id': rutina_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar la rutina. Asegúrate de que el EntrenadorID exista.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@rutinas_bp.route('/rutinas/<int:rutina_id>', methods=['DELETE'])
def eliminar_rutina_api(rutina_id):
    try:
        if Rutina.eliminar(rutina_id):
            return jsonify({'message': f'Rutina {rutina_id} eliminada correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró la rutina {rutina_id}.'}), 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@rutinas_bp.route('/rutinas_entrenador/<int:entrenador_id>', methods=['GET'])
def listar_rutinas_entrenador(entrenador_id):
    try:
        rutinas = Rutina.listar_por_entrenador(entrenador_id)
        return jsonify(rutinas), 200 if rutinas else 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
