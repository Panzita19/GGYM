from flask import Blueprint, jsonify, request
from Planes_Model.Bd_planes import Plan

planes_bp = Blueprint('planes', __name__)

@planes_bp.route('/planes', methods=['POST'])
def crear_plan_api():
    try:
        data = request.json
        plan = Plan(
            duracion=data.get('duracion'),
            monto=data.get('monto'),
            descripcion=data.get('descripcion'),
            beneficios=data.get('beneficios')
        )

        if not all([plan.duracion, plan.monto]):
            return jsonify({'error': 'Faltan datos obligatorios para el plan.'}), 400

        plan_id = plan.insertar()
        if plan_id:
            return jsonify({'message': f'Plan con ID {plan_id} insertado correctamente.', 'plan_id': plan_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el plan.'}), 500
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@planes_bp.route('/planes', methods=['GET'])
def listar_planes_api():
    try:
        planes = Plan.listar()
        return jsonify(planes), 200 if planes else 404
    except Exception as e:
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
