from flask import Blueprint, jsonify, request
from Pagos_Model.Bd_pagos import Pago

pagos_bp = Blueprint('pagos', __name__)

@pagos_bp.route('/pagos', methods=['POST'])
def crear_pago_api():
    try:
        data = request.json
        pago = Pago(
            usuario_id=data.get('usuario_id'),
            supervisor_id=data.get('supervisor_id'),
            monto=data.get('monto'),
            estado=data.get('estado', 'Pendiente'),
            fecha_pago=data.get('fecha_pago')
        )

        if not all([pago.usuario_id, pago.supervisor_id, pago.monto]):
            return jsonify({'error': 'Faltan datos obligatorios para el pago.'}), 400

        pago_id = pago.insertar()
        if pago_id:
            return jsonify({'message': f'Pago con ID {pago_id} registrado correctamente.', 'pago_id': pago_id}), 201
        else:
            return jsonify({'error': 'Fallo al registrar el pago. Verifica que el Usuario y el Supervisor existan.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@pagos_bp.route('/pagos/<int:pago_id>', methods=['DELETE'])
def eliminar_pago_api(pago_id):
    try:
        if Pago.eliminar(pago_id):
            return jsonify({'message': f'Pago {pago_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el pago {pago_id}.'}), 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
