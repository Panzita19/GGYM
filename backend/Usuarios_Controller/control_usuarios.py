from flask import Blueprint, jsonify, request
from Usuarios_Model.Bd_usuarios import Usuario

usuarios_bp = Blueprint('usuarios', __name__)

@usuarios_bp.route('/usuarios', methods=['POST'])
def crear_usuario_api():
    try:
        data = request.json
        usuario = Usuario(
            nombre_completo=data.get('nombre_completo'),
            cedula=data.get('cedula'),
            correo=data.get('correo'),
            telefono=data.get('telefono'),
            fecha_nacimiento=data.get('fecha_nacimiento'),
            direccion=data.get('direccion')
        )

        if not all([usuario.nombre_completo, usuario.cedula, usuario.correo, usuario.telefono,
                    usuario.fecha_nacimiento, usuario.direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el usuario.'}), 400

        usuario_id = usuario.insertar()
        if usuario_id:
            return jsonify({'message': f'Usuario con ID {usuario_id} insertado correctamente.', 'usuario_id': usuario_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el usuario.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@usuarios_bp.route('/usuarios/<int:usuario_id>', methods=['DELETE'])
def eliminar_usuario_api(usuario_id):
    try:
        if Usuario.eliminar(usuario_id):
            return jsonify({'message': f'Usuario {usuario_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el usuario {usuario_id}.'}), 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@usuarios_bp.route('/usuarios', methods=['GET'])
def listar_usuarios_api():
    try:
        usuarios = Usuario.listar()
        return jsonify(usuarios), 200 if usuarios else 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@usuarios_bp.route('/usuarios/total', methods=['GET'])
def total_usuarios_api():
    try:
        total = Usuario.total()
        return jsonify({'total_usuarios': total}), 200
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
