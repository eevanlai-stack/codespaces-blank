from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


# 1. GPS定位
@app.route('/gps', methods=['GET'])
def get_location():
    # 这里需要调用GPS定位的API，获取用户的经纬度信息
    # 由于GPS定位需要在移动设备上才能实现，这里我们只返回一个模拟数据
    location = {'latitude': 31.2304, 'longitude': 121.4737}
    return jsonify(location)


# 2. EPF (Employee Provident Fund) 公积金计算
@app.route('/epf', methods=['POST'])
def calculate_epf():
    data = request.get_json(silent=True) or {}
    if 'salary' not in data:
        raise BadRequest('Missing field: salary')
    try:
        salary = float(data.get('salary'))
    except (TypeError, ValueError):
        raise BadRequest('Invalid salary')

    # EPF的计算逻辑，这里假设员工和雇主各缴纳11%和13%
    employee_contribution = round(salary * 0.11, 2)
    employer_contribution = round(salary * 0.13, 2)
    total_contribution = round(employee_contribution + employer_contribution, 2)
    return jsonify({
        'employee_contribution': employee_contribution,
        'employer_contribution': employer_contribution,
        'total_contribution': total_contribution
    })


# 3. PERKESO (Social Security Organization) 社险计算
@app.route('/perkeso', methods=['POST'])
def calculate_perkeso():
    data = request.get_json(silent=True) or {}
    if 'salary' not in data:
        raise BadRequest('Missing field: salary')
    try:
        salary = float(data.get('salary'))
    except (TypeError, ValueError):
        raise BadRequest('Invalid salary')

    # PERKESO的计算逻辑，具体费率需要参考官方数据
    employee_contribution = round(salary * 0.005, 2)
    employer_contribution = round(salary * 0.01, 2)
    total_contribution = round(employee_contribution + employer_contribution, 2)
    return jsonify({
        'employee_contribution': employee_contribution,
        'employer_contribution': employer_contribution,
        'total_contribution': total_contribution
    })


# 4. PCB (Potongan Cukai Bulanan) 月度所得税计算
@app.route('/pcb', methods=['POST'])
def calculate_pcb():
    data = request.get_json(silent=True) or {}
    if 'salary' not in data:
        raise BadRequest('Missing field: salary')
    try:
        salary = float(data.get('salary'))
    except (TypeError, ValueError):
        raise BadRequest('Invalid salary')

    # PCB的计算逻辑非常复杂，需要参考LHDN的官方指南
    # 这里我们只返回一个模拟数据
    pcb = round(salary * 0.1, 2)
    return jsonify({'pcb': pcb})


# 5. 打卡功能
@app.route('/clock_in', methods=['POST'])
def clock_in():
    data = request.get_json(silent=True) or {}
    employee_id = data.get('employee_id')
    if not employee_id:
        raise BadRequest('Missing field: employee_id')
    # 这里需要记录打卡的时间和地点
    return jsonify({'message': 'Clock in successful'})


# 6. 考勤表
@app.route('/attendance', methods=['GET'])
def get_attendance():
    employee_id = request.args.get('employee_id')
    if not employee_id:
        raise BadRequest('Missing query param: employee_id')
    # 这里需要从数据库中查询考勤记录
    attendance_records = [
        {'date': '2023-11-01', 'clock_in': '09:00', 'clock_out': '18:00'},
        {'date': '2023-11-02', 'clock_in': '09:05', 'clock_out': '17:55'}
    ]
    return jsonify(attendance_records)


# 7. 个人Payroll，加入Advance
@app.route('/payroll', methods=['GET'])
def get_payroll():
    employee_id = request.args.get('employee_id')
    if not employee_id:
        raise BadRequest('Missing query param: employee_id')
    # 这里需要从数据库中查询Payroll记录
    payroll_data = {
        'salary': 5000,
        'epf': 550,
        'perkeso': 50,
        'pcb': 500,
        'advance': 200,
        'net_salary': 4600
    }
    return jsonify(payroll_data)


# 8. Advance 预支工资
@app.route('/advance', methods=['POST'])
def request_advance():
    data = request.get_json(silent=True) or {}
    employee_id = data.get('employee_id')
    amount = data.get('amount')
    if not employee_id:
        raise BadRequest('Missing field: employee_id')
    try:
        amount = float(amount)
    except (TypeError, ValueError):
        raise BadRequest('Invalid amount')
    # 这里需要记录预支工资的请求
    return jsonify({'message': 'Advance request submitted'})


# 9. 个人资料
@app.route('/profile', methods=['GET'])
def get_profile():
    employee_id = request.args.get('employee_id')
    if not employee_id:
        raise BadRequest('Missing query param: employee_id')
    # 这里需要从数据库中查询个人资料
    profile_data = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '123-456-7890'
    }
    return jsonify(profile_data)


# 10. 聊天功能
@app.route('/chat', methods=['POST'])
def send_message():
    data = request.get_json(silent=True) or {}
    sender_id = data.get('sender_id')
    receiver_id = data.get('receiver_id')
    message = data.get('message')
    if not sender_id or not receiver_id or not message:
        raise BadRequest('Missing sender_id, receiver_id or message')
    # 这里需要将消息保存到数据库中，并通知接收方
    return jsonify({'message': 'Message sent'})


# 11. 语言翻译
@app.route('/translate', methods=['POST'])
def translate_text():
    data = request.get_json(silent=True) or {}
    text = data.get('text')
    target_language = data.get('target_language')
    if not text or not target_language:
        raise BadRequest('Missing text or target_language')
    # 这里需要调用翻译API，将文本翻译成目标语言
    # 这里我们只返回一个模拟数据
    translated_text = f'Translated to {target_language}: {text}'
    return jsonify({'translated_text': translated_text})


@app.errorhandler(BadRequest)
def handle_bad_request(err):
    return jsonify({'error': str(err)}), 400


@app.route('/healthz')
def healthz():
    return jsonify({'status': 'ok'})


if __name__ == '__main__':
    # For local development; in production, use gunicorn with wsgi:app
    app.run(host='0.0.0.0', port=8000, debug=True)

