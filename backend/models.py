from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta

db = SQLAlchemy()
def init_db(app):
    db.init_app(app)
    with app.app_context():
        db.create_all()

class PipeMaterial(db.Model):
    __tablename__ = 'PipeMaterial'
    material_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), unique=True, nullable=False)

    def serialize(self):
        return {
            'material_id': self.material_id,
            'name': self.name
        }
    
class Pipe(db.Model):
    __tablename__ = 'Pipe'
    pipe_id = db.Column(db.String(20), primary_key=True)
    diameter = db.Column(db.Float, nullable=False)
    length = db.Column(db.Float, nullable=False)
    thickness = db.Column(db.Float, nullable=False)
    material_id = db.Column(db.Integer, db.ForeignKey('PipeMaterial.material_id'), nullable=False)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)

    valve = db.relationship('Valve', backref='pipe', uselist=False)
    flow_meter_tuple = db.relationship('FlowMeterTuple', backref='pipe', uselist=False)
    vibrator = db.relationship('VibrationSensor', backref='pipe', uselist=False)
    material = db.relationship("PipeMaterial", backref="pipes", lazy='joined')

    def serialize(self):
        flow_meter_tuple_serialized = self.flow_meter_tuple.serialize() if self.flow_meter_tuple else None
        valve_serialized = self.valve.serialize() if self.valve else None
        vibrator_serialized = self.vibrator.serialize() if self.vibrator else None
        material_serialized = self.material.serialize() if self.material else None

        return {
            'pipe_id': self.pipe_id,
            'diameter': self.diameter,
            'length': self.length,
            'thickness': self.thickness,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date,
            'valve': valve_serialized,
            'flow_meter_tuple': flow_meter_tuple_serialized,
            'vibrator': vibrator_serialized,
            'material': material_serialized
        }
    
    def get_water_flow(self, from_date=None, to_date=None):
        if from_date is None:
            from_date = datetime(year=1900, month=1, day=1)
        if to_date is None:
            to_date = datetime.now()
        
        flowmeter_input_logs = FlowMeterInputLog.query.filter(
            FlowMeterInputLog.timestamp >= from_date,
            FlowMeterInputLog.timestamp <= to_date,
            FlowMeterInputLog.meter_id == self.pipe_id
        ).order_by(FlowMeterInputLog.timestamp.desc()).all()
        
        if not flowmeter_input_logs:
            print("No flowmeter input logs found")
            return 0
        
        total_volume = 0
        for log in flowmeter_input_logs:
            total_volume += log.volume

        return total_volume

class WaterTank(db.Model):
    __tablename__ = 'WaterTank'
    tank_id = db.Column(db.String(20), primary_key=True)
    capacity = db.Column(db.Float, nullable=False)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)
    inpipe = db.Column(db.String(20), nullable=False)
    outpipe = db.Column(db.String(20), nullable=False)

    def serialize(self):
        return {
            'tank_id': self.tank_id,
            'capacity': self.capacity,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date,
            'inpipe': self.inpipe,
            'outpipe': self.outpipe
        }
    
    def graph_node(self):
        return {
            'id': self.tank_id,
            'group': 'tank',
            'out_pipes': [self.outpipe],
            'in_pipes': [self.inpipe]
        }
    
class WaterTankLog(db.Model):
    __tablename__ = 'WaterTankLog'
    log_id = db.Column(db.Integer, primary_key=True)
    tank_id = db.Column(db.String(20), db.ForeignKey('WaterTank.tank_id'), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    level = db.Column(db.Float, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'tank_id': self.tank_id,
            'timestamp': self.timestamp,
            'level': self.level
        }
    
class Valve(db.Model):
    __tablename__ = 'Valve'
    valve_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)
    subzone_id = db.Column(db.String(20), db.ForeignKey('Subzone.subzone_id'), nullable=False)

    subzone = db.relationship('Subzone', backref='valves', lazy='joined', uselist=False)

    def serialize(self):
        valve_log = ValveLog.query.filter(
            ValveLog.timestamp >= datetime.now() - timedelta(days=30),
            ValveLog.valve_id == self.valve_id
        ).order_by(ValveLog.timestamp.desc()).all()

        if len(valve_log) != 0:
            pressure = 0
            for log in valve_log:
                pressure += log.pressure
            pressure /= len(valve_log)
        else:
            pressure = None

        return {
            'valve_id': self.valve_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date,
            'subzone': self.subzone.serialize(),
            'mean_pressure': pressure
        }

class FlowMeterInput(db.Model):
    __tablename__ = 'FlowMeterInput'
    meter_id = db.Column(db.String(20), db.ForeignKey('FlowMeterTuple.meter_tuple_id'), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)

    def serialize(self):
        return {
            'meter_id': self.meter_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date
        }
    
class FlowMeterOutput(db.Model):
    __tablename__ = 'FlowMeterOutput'
    meter_id = db.Column(db.String(20), db.ForeignKey('FlowMeterTuple.meter_tuple_id'), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)

    def serialize(self):
        return {
            'meter_id': self.meter_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date
        }

class FlowMeterTuple(db.Model):
    __tablename__ = 'FlowMeterTuple'
    meter_tuple_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), primary_key=True)
    meter_input = db.relationship('FlowMeterInput', backref='flow_meter_tuple', uselist=False)
    meter_output = db.relationship('FlowMeterOutput', backref='flow_meter_tuple', uselist=False)

    def serialize(self):
        # Serialize the related objects properly
        meter_input_serialized = self.meter_input.serialize() if self.meter_input else None
        meter_output_serialized = self.meter_output.serialize() if self.meter_output else None


        flowmeter_input_logs = FlowMeterInputLog.query.filter(
            FlowMeterInputLog.timestamp >= datetime.now() - timedelta(days=30),
            FlowMeterInputLog.meter_id == self.meter_input.meter_id
        ).order_by(FlowMeterInputLog.timestamp.desc()).all()
        water_input = 0
        for log in flowmeter_input_logs:
            water_input += log.volume

        flowmeter_output_logs = FlowMeterOutputLog.query.filter(
            FlowMeterOutputLog.timestamp >= datetime.now() - timedelta(days=30),
            FlowMeterOutputLog.meter_id == self.meter_output.meter_id
        ).order_by(FlowMeterOutputLog.timestamp.desc()).all()   
        water_output = 0
        for log in flowmeter_output_logs:
            water_output += log.volume

        leaked_water = water_input - water_output
        if water_input == 0:
            water_input = None
            leaked_water = None

        return {
            'meter_tuple_id': self.meter_tuple_id,
            'meter_input': meter_input_serialized,
            'meter_output': meter_output_serialized,
            'water_input': water_input,
            'water_leaked': leaked_water,
        }

class Zone(db.Model):
    __tablename__ = 'Zone'
    zone_id = db.Column(db.String(20), primary_key=True)
    name = db.Column(db.String(20), unique=True, nullable=False)

    def serialize(self):
        return {
            'zone_id': self.zone_id,
            'name': self.name
        }

class Subzone(db.Model):
    __tablename__ = 'Subzone'
    subzone_id = db.Column(db.String(20), primary_key=True)
    zone_id = db.Column(db.String(20), db.ForeignKey('Zone.zone_id'), nullable=False)
    name = db.Column(db.String(20), unique=True, nullable=False)
    priority = db.Column(db.Integer, nullable=False)
    zone = db.relationship('Zone', backref='subzones', lazy='joined')

    def serialize(self):
        zone_serialized = self.zone.serialize() if self.zone else None
        return {
            'subzone_id': self.subzone_id,
            'zone': zone_serialized,
            'name': self.name,
            'priority': self.priority
        }

class WaterInput(db.Model):
    __tablename__ = 'WaterInput'
    waterinput_id = db.Column(db.String(20), primary_key=True)
    capacity = db.Column(db.Float, nullable=False)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)
    connected_pipe_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), nullable=False)

    def serialize(self):
        return {
            'waterinput_id': self.waterinput_id,
            'capacity': self.capacity,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date
        }
    
    def graph_node(self):
        return {
            'id': self.waterinput_id,
            'group': 'waterinput',
            'out_pipes': [self.connected_pipe_id],
            'in_pipes': []
        }
    
class WaterInputLog(db.Model):
    __tablename__ = 'WaterInputLog'
    log_id = db.Column(db.Integer, primary_key=True)
    waterinput_id = db.Column(db.String(20), db.ForeignKey('WaterInput.waterinput_id'), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    level = db.Column(db.Float, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'waterinput_id': self.waterinput_id,
            'timestamp': self.timestamp,
            'level': self.level
        }

class WaterOutput(db.Model):
    __tablename__ = 'WaterOutput'
    wateroutput_id = db.Column(db.String(20), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)
    connected_pipe_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), nullable=False)

    def serialize(self):
        return {
            'wateroutput_id': self.wateroutput_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date
        }
    
    def graph_node(self):
        return {
            'id': self.wateroutput_id,
            'group': 'wateroutput',
            'out_pipes': [],
            'in_pipes': [self.connected_pipe_id]
        }

class WaterOutputLog(db.Model):
    __tablename__ = 'WaterOutputLog'
    log_id = db.Column(db.Integer, primary_key=True)
    wateroutput_id = db.Column(db.String(20), db.ForeignKey('WaterOutput.wateroutput_id'), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    volume = db.Column(db.Float, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'wateroutput_id': self.wateroutput_id,
            'timestamp': self.timestamp,
            'volume': self.volume
        }

class ValveLog(db.Model):
    __tablename__ = 'ValveLog'
    log_id = db.Column(db.Integer, primary_key=True)
    valve_id = db.Column(db.String(20), db.ForeignKey('Valve.valve_id'), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    pressure = db.Column(db.Float, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'valve_id': self.valve_id,
            'timestamp': self.timestamp,
            'pressure': self.pressure
        }

class FlowMeterInputLog(db.Model):
    __tablename__ = 'FlowMeterInputLog'
    log_id = db.Column(db.Integer, primary_key=True)
    meter_id = db.Column(db.String(20), db.ForeignKey('FlowMeterInput.meter_id'), nullable=False)
    volume = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'meter_id': self.meter_id,
            'volume': self.volume,
            'timestamp': self.timestamp
        }

class FlowMeterOutputLog(db.Model):
    __tablename__ = 'FlowMeterOutputLog'
    log_id = db.Column(db.Integer, primary_key=True)
    meter_id = db.Column(db.String(20), db.ForeignKey('FlowMeterOutput.meter_id'), nullable=False)
    volume = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'meter_id': self.meter_id,
            'volume': self.volume,
            'timestamp': self.timestamp
        }

class Junction(db.Model):
    __tablename__ = 'Junction'
    junction_id = db.Column(db.String(20), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)
    in_pipes = db.relationship('InPipes', backref='junction')
    out_pipes = db.relationship('OutPipes', backref='junction')

    def serialize(self):
        in_pipes_serialized = [in_pipe.serialize() for in_pipe in self.in_pipes]
        out_pipes_serialized = [out_pipe.serialize() for out_pipe in self.out_pipes]
        return {
            'junction_id': self.junction_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date,
            'in_pipes': in_pipes_serialized,
            'out_pipes': out_pipes_serialized
        }
    
    def graph_node(self):
        in_pipes_serialized = [in_pipe.pipe_id for in_pipe in self.in_pipes]
        out_pipes_serialized = [out_pipe.pipe_id for out_pipe in self.out_pipes]
        return {
            'id': self.junction_id,
            'group': 'junction',
            'out_pipes': out_pipes_serialized,
            'in_pipes': in_pipes_serialized
        }

class InPipes(db.Model):
    __tablename__ = 'InPipes'
    junction_id = db.Column(db.String(20), db.ForeignKey('Junction.junction_id'), primary_key=True, nullable=False)
    pipe_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), primary_key=True, nullable=False)

    def serialize(self):
        return {
            'junction_id': self.junction_id,
            'pipe_id': self.pipe_id
        }

class OutPipes(db.Model):
    __tablename__ = 'OutPipes'
    junction_id = db.Column(db.String(20), db.ForeignKey('Junction.junction_id'), primary_key=True, nullable=False)
    pipe_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), primary_key=True, nullable=False)

    def serialize(self):
        return {
            'junction_id': self.junction_id,
            'pipe_id': self.pipe_id
        }

class DroughtForecast(db.Model):
    __tablename__ = 'DroughtForecast'
    forecast_id = db.Column(db.Integer, primary_key=True)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)

    def serialize(self):
        return {
            'forecast_id': self.forecast_id,
            'start_date': self.start_date,
            'end_date': self.end_date
        }
    
class VibrationSensor(db.Model):
    __tablename__ = 'VibrationSensor'
    sensor_id = db.Column(db.String(20), db.ForeignKey('Pipe.pipe_id'), primary_key=True)
    installation_date = db.Column(db.Date, nullable=False)
    revised_date = db.Column(db.Date)

    def serialize(self):
        return {
            'sensor_id': self.sensor_id,
            'installation_date': self.installation_date,
            'revised_date': self.revised_date
        }

class VibrationSensorLog(db.Model):
    __tablename__ = 'VibrationSensorLog'
    log_id = db.Column(db.Integer, primary_key=True)
    sensor_id = db.Column(db.String(20), db.ForeignKey('VibrationSensor.sensor_id'), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    vibration = db.Column(db.Float, nullable=False)

    def serialize(self):
        return {
            'log_id': self.log_id,
            'sensor_id': self.sensor_id,
            'timestamp': self.timestamp,
            'vibration': self.vibration
        }
