from datetime import datetime, timedelta
import random
import sqlite3
import os


# conn = sqlite3.connect('/Users/alonso284/Desktop/Gota_backend/water_network.db')
# USE RELATIVE PATHS
conn = sqlite3.connect('water_network.db')

# DELETE CONTENTS FROM FlowMeterInputLog, FlowMeterOutputLog and ValveLog
conn.execute("DELETE FROM ValveLog;")
conn.execute("DELETE FROM FlowMeterInputLog;")
conn.execute("DELETE FROM FlowMeterOutputLog;")
conn.execute("DELETE FROM VibrationSensorLog;")

conn.commit()

"""
CREATE TABLE FlowMeterInputLog (
    log_id INTEGER PRIMARY KEY,
    meter_id TEXT NOT NULL,

    volume REAL NOT NULL,
    timestamp DATETIME NOT NULL,

    FOREIGN KEY (meter_id) REFERENCES FlowMeterInput(meter_id)
);

CREATE TABLE ValveLog (
    log_id INTEGER PRIMARY KEY,
    valve_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    pressure REAL NOT NULL,

    FOREIGN KEY (valve_id) REFERENCES Valve(valve_id)
);
"""


installed = datetime(year=2024, month=2, day=1, hour=0, minute=0, second=0)
actual = datetime(year=2024, month=3, day=1, hour=0, minute=0, second=0)
# Time delta step of 1 hour
time_delta = timedelta(hours=1)

comsumed_per_delta_max = 100
comsumed_per_delta_delta = 10

pipes = {
    'G1P0': {
        'T1P00': ['T1F1P1', 'T1F2P1', 'T1F3P1', 'T1F4P1'],
        'T2P00': ['T2F1P1', 'T2F2P1', 'T2F3P1', 'T2F4P1'],
    }
}

leakage_pipes = {
    'G1P0': 0.05,
    'T1P00': 0.1,
    'T1F2P1': 0.2,
    'T2F3P1': 0.3,
}

pressure_mean_percentage = {
    'G1P0': 1.0,
    'T1P00': 0.95,
    'T2P00': 0.95,
    'T1F1P1': 0.5,
    'T1F2P1': 0.3,
    'T1F3P1': 0.80,
    'T1F4P1': 0.80,
    'T2F1P1': 0.5,
    'T2F2P1': 0.3,
    'T2F3P1': 0.80,
    'T2F4P1': 0.80,
}

current_time = installed
while current_time < actual:
    for water_input_zone_id, water_input_zones in pipes.items():
        wi_volume = 0
        for zone_id, subzones in water_input_zones.items():
            z_volume = 0
            for subzone_id in subzones:

                # LOG FLOW METER TUPLE INFO
                input = random.uniform(comsumed_per_delta_max, comsumed_per_delta_max - comsumed_per_delta_delta)
                input *= random.uniform(0.7, 1.1)
                output = input * (1 - leakage_pipes[subzone_id]) if subzone_id in leakage_pipes else input
                pressure = pressure_mean_percentage[subzone_id] + random.uniform(-0.05, 0.05)
                pressure = min(1, pressure)
                conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {input}, \'{current_time}\');')
                conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {output}, \'{current_time}\');')
                conn.execute(f'INSERT INTO ValveLog (valve_id, pressure, timestamp) VALUES (\'{subzone_id}\', {pressure}, \'{current_time}\');')
                
                z_volume += input

                # LOG VALVE INFO

            # LOG FLOW METER TUPLE INFO
            z_output = z_volume
            z_input = z_output / (1 - leakage_pipes[zone_id]) if zone_id in leakage_pipes else z_output
            pressure = pressure_mean_percentage[zone_id] + random.uniform(-0.05, 0.05)
            pressure = min(1, pressure)
            conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_input}, \'{current_time}\');')
            conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_output}, \'{current_time}\');')
            conn.execute(f'INSERT INTO ValveLog (valve_id, pressure, timestamp) VALUES (\'{zone_id}\', {pressure}, \'{current_time}\');')
            
            wi_volume += z_input

        # LOG FLOW METER TUPLE INFO
        wi_output = wi_volume
        wi_input = wi_output / (1 - leakage_pipes[water_input_zone_id]) if water_input_zone_id in leakage_pipes else wi_output

        pressure = pressure_mean_percentage[water_input_zone_id] + random.uniform(-0.05, 0.05)
        pressure = min(1, pressure)
        conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_input}, \'{current_time}\');')
        conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_output}, \'{current_time}\');')
        conn.execute(f'INSERT INTO ValveLog (valve_id, pressure, timestamp) VALUES (\'{water_input_zone_id}\', {pressure}, \'{current_time}\');')

    current_time += time_delta
            
conn.commit()

"""
CREATE TABLE FlowMeterInputLog (
    log_id INTEGER PRIMARY KEY,
    meter_id TEXT NOT NULL,

    volume REAL NOT NULL,
    timestamp DATETIME NOT NULL,

    FOREIGN KEY (meter_id) REFERENCES FlowMeterInput(meter_id)
);
"""
# current_time = installed
# while current_time < actual:
#     for water_input_zone_id, water_input_zones in valves.items():
#         wi_volume = 0
#         for zone_id, subzones in water_input_zones.items():
#             z_volume = 0
#             for subzone_id in subzones:
#                 # print(f'Water input zone: {water_input_zone_id}, zone: {zone_id}, subzone: {subzone_id}')
#                 # generate random double from comsumed_per_delta_max to comsumed_per_delta_max - comsumed_per_delta_delta
#                 input = random.uniform(comsumed_per_delta_max, comsumed_per_delta_max - comsumed_per_delta_delta)
#                 output = input * (1 - leakage_pipes[subzone_id]) if subzone_id in leakage_pipes else input
#                 # print(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {input}, \'{current_time}\');')
#                 # print(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {output}, \'{current_time}\');')
#                 # print()
#                 conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {input}, \'{current_time}\');')
#                 conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{subzone_id}\', {output}, \'{current_time}\');')
#                 # print(f'{subzone_id} {input} {output} {current_time}')
#                 z_volume += input
#             z_output = z_volume
#             z_input = z_output / (1 - leakage_pipes[zone_id]) if zone_id in leakage_pipes else z_output
#             # print(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_input}, \'{current_time}\');')
#             # print(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_output}, \'{current_time}\');')
#             # print()
#             conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_input}, \'{current_time}\');')
#             conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{zone_id}\', {z_output}, \'{current_time}\');')
#             # print(f'{zone_id} {z_input} {z_output} {current_time}')
#             wi_volume += z_input
#         wi_output = wi_volume
#         wi_input = wi_output / (1 - leakage_pipes[water_input_zone_id]) if water_input_zone_id in leakage_pipes else wi_output
#         # print(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_input}, \'{current_time}\');')
#         # print(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_output}, \'{current_time}\');')
#         # print()
#         conn.execute(f'INSERT INTO FlowMeterInputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_input}, \'{current_time}\');')
#         conn.execute(f'INSERT INTO FlowMeterOutputLog (meter_id, volume, timestamp) VALUES (\'{water_input_zone_id}\', {wi_output}, \'{current_time}\');')
#         # print(f'{water_input_zone_id} {wi_input} {wi_output} {current_time}')
#     current_time += time_delta
            
# conn.commit()

"""
LOG FOR VIBRATION SENSOR
"""

"""
CREATE TABLE VibrationSensorLog (
    log_id INTEGER PRIMARY KEY,
    sensor_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    vibration REAL NOT NULL,

    FOREIGN KEY (sensor_id) REFERENCES VibrationSensor(sensor_id)
);
"""

"""
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
"""

"""

"""

pipes_with_vibration = {
    'T1F2P1': 0.5,
    'T2F3P1': 0.7,
}

# Create a cursor object to execute SQL queries
cursor = conn.cursor()



base_frenquency_when_ok = 700
base_frenquency_when_leaking_slow = 500
base_frenquency_when_leaking_medium = 300
base_frenquency_when_leaking_fast = 100


# Execute the SELECT query
cursor.execute("SELECT * FROM Pipe;")

# # Fetch all rows from the result set
rows = cursor.fetchall()
installed = datetime(year=2024, month=2, day=1, hour=0, minute=0, second=0)
actual = datetime(year=2024, month=3, day=1, hour=0, minute=0, second=0)
# Time delta step of 1 hour
time_delta = timedelta(days=1)

leaking_tubes = {
    'G1P0':{
        'leakage': 'slow',
        'time_of_leakage': datetime(year=2024, month=2, day=6, hour=0, minute=0, second=0)
    },
    'T1P00':{
        'leakage': 'slow',
        'time_of_leakage': datetime(year=2024, month=2, day=3, hour=0, minute=0, second=0)
    },
    'T1F2P1':{
        'leakage': 'slow',
        'time_of_leakage': datetime(year=2024, month=2, day=18, hour=0, minute=0, second=0)
    },
    'T2F3P1':{
        'leakage': 'slow',
        'time_of_leakage': datetime(year=2024, month=2, day=23, hour=0, minute=0, second=0)
    },
    'T2F4P2':{
        'leakage': 'medium',
        'time_of_leakage': datetime(year=2024, month=2, day=20, hour=0, minute=0, second=0)
    },
    'T2P02':{
        'leakage': 'fast',
        'time_of_leakage': datetime(year=2024, month=2, day=13, hour=0, minute=0, second=0)
    }
}

"""
CREATE TABLE VibrationSensorLog (
    log_id INTEGER PRIMARY KEY,
    sensor_id TEXT NOT NULL,

    timestamp DATETIME NOT NULL,
    vibration REAL NOT NULL,

    FOREIGN KEY (sensor_id) REFERENCES VibrationSensor(sensor_id)
);
"""

def determine_frequency(diameter, length, thickness, material, frequency):
    return frequency * diameter * (length / 10) * (0.3 if material == "Cobre" else 0.7)

file = open('test.csv', 'w')
file.write('pipe_id,diameter,length,thickness,material,frequency,leaking\n')
while installed < actual:
    for row in rows:
        pipe_id = row[0]
        diameter = row[1]
        length = row[2]
        thickness = row[3]
        material = "Cobre" if row[4] == 0 else "PVC"


        frequency = base_frenquency_when_ok
        leaking = "none"
        if pipe_id in leaking_tubes and leaking_tubes[pipe_id]['time_of_leakage'] <= installed:
            if leaking_tubes[pipe_id]['leakage'] == 'slow':
                frequency = base_frenquency_when_leaking_slow
            elif leaking_tubes[pipe_id]['leakage'] == 'medium':
                frequency = base_frenquency_when_leaking_medium
            else:
                frequency = base_frenquency_when_leaking_fast
            leaking = leaking_tubes[pipe_id]['leakage']
        frequency = determine_frequency(diameter, length, thickness, material, frequency)
        frequency += random.uniform(-10, 10)

        file.write(f'{pipe_id},{diameter},{length},{thickness},{material},{frequency},{leaking}\n')
        conn.execute(f'INSERT INTO VibrationSensorLog (sensor_id, vibration, timestamp) VALUES (\'{pipe_id}\', {frequency}, \'{installed}\');')

    installed += time_delta

conn.commit()


cursor.execute("SELECT diameter, length, thickness, material_id  FROM Pipe GROUP BY diameter, length, thickness, material_id;")
rows = cursor.fetchall()
# Print the rows
different_pipes = list()
for row in rows:
    different_pipes.append({
        "diameter": row[0],
        "length": row[1],
        "thickness": row[2],
        "material": "Cobre" if row[3] == 0 else "PVC",
        "frenquency_ok": base_frenquency_when_ok * row[0] * (row[1] / 10) * (0.3 if row[3] == 0 else 0.7),
        "base_frenquency_when_leaking_slow": base_frenquency_when_leaking_slow * row[0] * (row[1] / 10) * (0.3 if row[3] == 0 else 0.7),
        "base_frenquency_when_leaking_medium": base_frenquency_when_leaking_medium * row[0] * (row[1] / 10) * (0.3 if row[3] == 0 else 0.7),
        "base_frenquency_when_leaking_fast": base_frenquency_when_leaking_fast * row[0] * (row[1] / 10) * (0.3 if row[3] == 0 else 0.7),
    })
    print("diameter", different_pipes[-1]["diameter"])
    print("length", different_pipes[-1]["length"])
    print("thickness", different_pipes[-1]["thickness"])
    print("material", different_pipes[-1]["material"])

    print("frequency when ok", different_pipes[-1]["frenquency_ok"])
    print("frequency when leaking slow", different_pipes[-1]["base_frenquency_when_leaking_slow"])
    print("frequency when leaking medium", different_pipes[-1]["base_frenquency_when_leaking_medium"])
    print("frequency when leaking fast", different_pipes[-1]["base_frenquency_when_leaking_fast"])
    print()



