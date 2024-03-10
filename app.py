from flask import Flask, request, jsonify
from flask_socketio import SocketIO
from data_processing import *
import os
from datetime import datetime

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'water_network.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
socketio = SocketIO(app)

init_db(app)

@app.route('/valves', methods=['GET'])
def get_valves():
    valves = Valve.query.all()
    return jsonify([valve.serialize() for valve in valves])

@app.route('/flow_meter_tuples', methods=['GET'])
def get_flowmetertuples():
    flowmetertuples = FlowMeterTuple.query.all()
    return jsonify([flowmetertuple.serialize() for flowmetertuple in flowmetertuples])

@app.route('/pipes', methods=['GET'])
def get_pipes():
    pipes = Pipe.query.all()
    return jsonify([pipe.serialize() for pipe in pipes])

@app.route('/water_tanks', methods=['GET'])
def get_water_tanks():
    water_tanks = WaterTank.query.all()
    return jsonify([water_tank.serialize() for water_tank in water_tanks])

@app.route('/pipe_materials', methods=['GET'])
def get_pipe_materials():
    pipe_materials = PipeMaterial.query.all()
    return jsonify([pipe_material.serialize() for pipe_material in pipe_materials])

@app.route('/flow_meter_inputs', methods=['GET'])
def get_flow_meter_inputs():
    flow_meter_inputs = FlowMeterInput.query.all()
    return jsonify([flow_meter_input.serialize() for flow_meter_input in flow_meter_inputs])

@app.route('/flow_meter_outputs', methods=['GET'])
def get_flow_meter_outputs():
    flow_meter_outputs = FlowMeterOutput.query.all()
    return jsonify([flow_meter_output.serialize() for flow_meter_output in flow_meter_outputs])

@app.route('/zones', methods=['GET'])
def get_zones():
    zones = Zone.query.all()
    return jsonify([zone.serialize() for zone in zones])

@app.route('/subzones', methods=['GET'])
def get_subzones():
    subzones = Subzone.query.all()
    return jsonify([subzone.serialize() for subzone in subzones])

@app.route('/water_inputs', methods=['GET'])
def get_water_inputs():
    water_inputs = WaterInput.query.all()
    return jsonify([water_input.serialize() for water_input in water_inputs])

@app.route('/water_input_logs', methods=['GET'])
def get_water_input_logs():
    water_input_logs = WaterInputLog.query.all()
    return jsonify([water_input_log.serialize() for water_input_log in water_input_logs])

@app.route('/water_outputs', methods=['GET'])
def get_water_outputs():
    water_outputs = WaterOutput.query.all()
    return jsonify([water_output.serialize() for water_output in water_outputs])

@app.route('/water_output_logs', methods=['GET'])
def get_water_output_logs():
    water_output_logs = WaterOutputLog.query.all()
    return jsonify([water_output_log.serialize() for water_output_log in water_output_logs])

@app.route('/valve_logs', methods=['GET'])
def get_valve_logs():
    valve_logs = ValveLog.query.all()
    return jsonify([valve_log.serialize() for valve_log in valve_logs])

@app.route('/flow_meter_input_logs', methods=['GET'])
def get_flow_meter_input_logs():
    flow_meter_input_logs = FlowMeterInputLog.query.all()
    return jsonify([flow_meter_input_log.serialize() for flow_meter_input_log in flow_meter_input_logs])

@app.route('/flow_meter_output_logs', methods=['GET'])
def get_flow_meter_output_logs():
    flow_meter_output_logs = FlowMeterOutputLog.query.all()
    return jsonify([flow_meter_output_log.serialize() for flow_meter_output_log in flow_meter_output_logs])

@app.route('/junctions', methods=['GET'])
def get_junctions():
    junctions = Junction.query.all()
    return jsonify([junction.serialize() for junction in junctions])

@app.route('/in_pipes', methods=['GET'])
def get_in_pipes():
    in_pipes = InPipes.query.all()
    return jsonify([in_pipe.serialize() for in_pipe in in_pipes])

@app.route('/out_pipes', methods=['GET'])
def get_out_pipes():
    out_pipes = OutPipes.query.all()
    return jsonify([out_pipe.serialize() for out_pipe in out_pipes])

@app.route('/drought_forecasts', methods=['GET'])
def get_drought_forecasts():
    drought_forecasts = DroughtForecast.query.all()
    return jsonify([drought_forecast.serialize() for drought_forecast in drought_forecasts])

@app.route('/node_mapping', methods=['GET'])
def get_node_mapping():
    return jsonify(nodes())

@app.route('/pipe_mapping', methods=['GET'])
def get_pipe_mapping():
    return jsonify(pipes())

@app.route('/water_input_zone', methods=['GET'])
def get_water_input_zone():
    return jsonify(water_input_zone())

@app.route('/zone_markers', methods=['GET'])
def get_zone_markers():
    return jsonify(subzone_markers())

@app.route('/element_subzone', methods=['GET'])
def get_element_subzone():
    return jsonify(init_dfs()[0])

@app.route('/resume', methods=['GET'])
def get_resume():
    return jsonify(resume())

@app.route('/leakage', methods=['GET'])
def get_leakage():
    return jsonify(leakage())

@app.route('/leakage_resume', methods=['GET'])
def get_leakage_resume():
    return jsonify(leakage_resume())

@app.route('/serial/<serial_number>', methods=['GET'])
def get_serial(serial_number):
    return jsonify(serial(serial_number))

@app.route('/serials', methods=['GET'])
def get_serials():
    return jsonify(serials())

@app.route('/leakage_per_zone', methods=['GET'])
def get_leakage_per_zone():
    return jsonify(leakage_per_zone())

@app.route('/leakage_per_subzone', methods=['GET'])
def get_leakage_per_subzone():
    return jsonify(leakage_per_subzone())

@app.route('/water_leakage_per_day', methods=['GET'])
def get_water_leakage_per_day():
    return jsonify(water_leakage_per_day())

@app.route('/vibration', methods=['GET'])
def get_vibration():
    return jsonify(vibration())

@app.route('/maintview/<subzone_id>', methods=['GET'])
def get_maintview(subzone_id):
    return jsonify(maintview(subzone_id))

# WebSocket ejemplo
@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

# run in 10.22.213.33
if __name__ == '__main__':
    socketio.run(app, debug=True)