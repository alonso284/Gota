PRAGMA foreign_keys = ON;

CREATE TABLE PipeMaterial (
    material_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE Pipe (
    pipe_id TEXT PRIMARY KEY,

    diameter REAL NOT NULL,
    length REAL NOT NULL,
    thickness REAL NOT NULL,
    material_id INTEGER NOT NULL,

    installation_date DATE NOT NULL,
	revised_date DATE,

    FOREIGN KEY (material_id) REFERENCES PipeMaterial(material_id)
);

CREATE TABLE VibrationSensor (
    sensor_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
    revised_date DATE,
    
    FOREIGN KEY (sensor_id) REFERENCES Pipe(pipe_id)
);

CREATE TABLE Valve (
    valve_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
	revised_date DATE,

    subzone_id TEXT NOT NULL UNIQUE,

    FOREIGN KEY (valve_id) REFERENCES Pipe(pipe_id),
    FOREIGN KEY (subzone_id) REFERENCES Subzone(subzone_id)
);

CREATE TABLE FlowMeterInput (
    meter_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
	revised_date DATE,
    
    FOREIGN KEY (meter_id) REFERENCES FlowMeterTuple(meter_tuple_id)
);

CREATE TABLE FlowMeterOutput (
    meter_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
    revised_date DATE,
    
    FOREIGN KEY (meter_id) REFERENCES FlowMeterTuple(meter_tuple_id)
);


CREATE TABLE FlowMeterTuple (
    meter_tuple_id TEXT PRIMARY KEY,
    FOREIGN KEY (meter_tuple_id) REFERENCES Pipe(pipe_id)
);

CREATE TABLE Zone (
    zone_id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE Subzone (
    subzone_id TEXT PRIMARY KEY,
    zone_id TEXT NOT NULL,
    name TEXT NOT NULL,
    priority INTEGER NOT NULL,

    UNIQUE (zone_id, name),
    FOREIGN KEY (zone_id) REFERENCES Zone(zone_id)
);

CREATE TABLE WaterInput (
    waterinput_id TEXT PRIMARY KEY,

    capacity REAL NOT NULL,

    installation_date DATE NOT NULL,
	revised_date DATE,

    connected_pipe_id INTEGER NOT NULL,
    FOREIGN KEY (connected_pipe_id) REFERENCES Pipe(pipe_id)
);

CREATE TABLE WaterInputLog (
    log_id INTEGER PRIMARY KEY,
    waterinput_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    level REAL NOT NULL,

    FOREIGN KEY (waterinput_id) REFERENCES WaterInput(waterinput_id)
);

CREATE TABLE WaterOutput (
    wateroutput_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
	revised_date DATE,

    connected_pipe_id INTEGER NOT NULL,
    FOREIGN KEY (connected_pipe_id) REFERENCES Pipe(pipe_id)
);

-- NOT IN USE
CREATE TABLE WaterOutputLog (
    log_id INTEGER PRIMARY KEY,
    wateroutput_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    volume REAL NOT NULL,

    FOREIGN KEY (wateroutput_id) REFERENCES WaterOutput(wateroutput_id)
);

CREATE TABLE ValveLog (
    log_id INTEGER PRIMARY KEY,
    valve_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    pressure REAL NOT NULL,

    FOREIGN KEY (valve_id) REFERENCES Valve(valve_id)
);

CREATE TABLE VibrationSensorLog (
    log_id INTEGER PRIMARY KEY,
    sensor_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    vibration REAL NOT NULL,

    FOREIGN KEY (sensor_id) REFERENCES VibrationSensor(sensor_id)
);

CREATE TABLE FlowMeterInputLog (
    log_id INTEGER PRIMARY KEY,
    meter_id TEXT NOT NULL,

    volume REAL NOT NULL,
    timestamp DATETIME NOT NULL,

    FOREIGN KEY (meter_id) REFERENCES FlowMeterInput(meter_id)
);

CREATE TABLE FlowMeterOutputLog (
    log_id INTEGER PRIMARY KEY,
    meter_id TEXT NOT NULL,

    volume REAL NOT NULL,
    timestamp DATETIME NOT NULL,

    FOREIGN KEY (meter_id) REFERENCES FlowMeterOutput(meter_id)
);

CREATE TABLE WaterTank (
    tank_id TEXT PRIMARY KEY,

    capacity REAL NOT NULL,
    installation_date DATE NOT NULL,
    revised_date DATE,

    inpipe TEXT NOT NULL,
    outpipe TEXT NOT NULL,
    FOREIGN KEY (inpipe) REFERENCES Pipe(pipe_id),
    FOREIGN KEY (outpipe) REFERENCES Pipe(pipe_id)
);

CREATE TABLE WaterTankLog (
    log_id INTEGER PRIMARY KEY,
    tank_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    level REAL NOT NULL,

    FOREIGN KEY (tank_id) REFERENCES WaterTank(tank_id)
);

CREATE TABLE Junction (
    junction_id TEXT PRIMARY KEY,

    installation_date DATE NOT NULL,
	revised_date DATE
);

CREATE TABLE InPipes (
    junction_id TEXT NOT NULL,
    pipe_id TEXT NOT NULL,

    PRIMARY KEY (junction_id, pipe_id),
    FOREIGN KEY (junction_id) REFERENCES Junction(junction_id),
    FOREIGN KEY (pipe_id) REFERENCES Pipe(pipe_id)
);

CREATE TABLE OutPipes (
    junction_id TEXT NOT NULL,
    pipe_id TEXT NOT NULL,

    PRIMARY KEY (junction_id, pipe_id),
    FOREIGN KEY (junction_id) REFERENCES Junction(junction_id),
    FOREIGN KEY (pipe_id) REFERENCES Pipe(pipe_id)
);

CREATE TABLE DroughtForecast (
    forecast_id INTEGER PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);