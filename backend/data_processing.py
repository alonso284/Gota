from models import db, init_db, Valve, FlowMeterTuple, Pipe, WaterTank, PipeMaterial, FlowMeterInput, FlowMeterOutput, Zone, Subzone, WaterInput, WaterInputLog, WaterOutput, WaterOutputLog, ValveLog, FlowMeterInputLog, FlowMeterOutputLog, Junction, InPipes, OutPipes, DroughtForecast, WaterTankLog
from sqlalchemy import func, text

from sqlalchemy import text

def water_leakage_per_day():
    with db.engine.connect() as connection:
        result = connection.execute(text("""
        SELECT
            SUM(fmil.volume) AS input_volume,
            SUM(fmol.volume) AS output_volume,
            SUM(fmil.volume) - SUM(fmol.volume) AS leaked,
            DATE(fmil.timestamp) AS log_date
        FROM FlowMeterInputLog AS fmil
        INNER JOIN FlowMeterOutputLog AS fmol
            ON DATE(fmil.timestamp) = DATE(fmol.timestamp)
        WHERE
            fmil.meter_id = "G1P0"
        GROUP BY DATE(fmil.timestamp)
        """))
            # AND fmil.timestamp >= DATETIME('now', '-14 days')
            # AND fmol.timestamp >= DATETIME('now', '-14 days')
    
    info = list()
    for row in result.fetchall():
        info.append({
            "type": "leakage",
            "date": row[3],
            "value": row[2]})
        info.append({
            "type": "consumed",
            "date": row[3],
            "value": row[0]})
    return info

def water_leakage():
    with db.engine.connect() as connection:
        result = connection.execute(text("""
        SELECT
            fmil.meter_id,
            SUM(fmil.volume) AS input_volume,
            SUM(fmol.volume) AS output_volume,
            SUM(fmil.volume) - SUM(fmol.volume) AS leaked,
            vl.subzone_id
        FROM FlowMeterInputLog AS fmil
        INNER JOIN FlowMeterOutputLog AS fmol
            ON fmil.meter_id = fmol.meter_id
        LEFT JOIN Valve AS vl
            ON vl.valve_id = fmil.meter_id
        GROUP BY fmil.meter_id, vl.subzone_id
        """))
        # WHERE
        #     fmil.timestamp >= DATETIME('now', '-30 days')
        #     AND fmol.timestamp >= DATETIME('now', '-30 days')
    
   
    info = {row[4]:{
        "total_input_volume": row[1],
        "total_output_volume": row[2],
        "leaked": row[3],
        "subzone_id": row[4]
    } for row in result.fetchall()}
    return info

def leakage():
    info = water_leakage()
    res = list(info.values())
    return res

def leakage_resume():
    # data = water_leakage()

    # consumed = 0
    # leaked = 0

    # for _, row in data:
    #     consumed += row["total_input_volume"]
    #     leaked += row["leaked"]

    # return {
    #     "consumed": consumed,
    #     "leaked": leaked  
    # }
    data = water_leakage()
    total_consumed = 0
    total_leaked = 0
    for _, row in data.items():
        total_consumed += row["total_input_volume"]
        total_leaked += row["leaked"]
    return {
        "consumed": total_consumed,
        "leaked": total_leaked
    }


def leakage_per_zone():
    leaks = water_leakage()
    subzone = Subzone.query.all()

    info = {}
    for subzone in subzone:
        if subzone.zone.name == "General":
            continue
        if subzone.zone.zone_id not in info:
            info[subzone.zone.zone_id] = dict()
            info[subzone.zone.zone_id]['subzones'] = list()
            info[subzone.zone.zone_id]['consumed'] = 0
            info[subzone.zone.zone_id]['leaked'] = 0
            info[subzone.zone.zone_id]['zone_id'] = subzone.zone.zone_id
            info[subzone.zone.zone_id]['name'] = subzone.zone.name
        info[subzone.zone.zone_id]['subzones'].append(leaks[subzone.subzone_id])
        info[subzone.zone.zone_id]['subzones'].append(subzone.name)
        info[subzone.zone.zone_id]['consumed'] += leaks[subzone.subzone_id]["total_input_volume"]
        info[subzone.zone.zone_id]['leaked'] += leaks[subzone.subzone_id]["leaked"]

    # turn info into a list
    info = list(info.values())

    return  {"zones": info }

def leakage_per_subzone():
    leaks = water_leakage()
    subzone = Subzone.query.all()

    info = {}
    for subzone in subzone:
        if subzone.zone.name == "General":
            continue
        info[subzone.subzone_id] = leaks[subzone.subzone_id]
        info[subzone.subzone_id]['name'] = subzone.name
        info[subzone.subzone_id]['zone_id'] = subzone.zone.zone_id

    # order by zone name
    info = dict(sorted(info.items(), key=lambda item: item[1]['name']))

    return list(info.values())



# None = all
# 1 = wi_nodes
# 2 = wo_nodes
# 3 = junction_nodes
# 4 = water_tanks

# GET ALL NODES WITH THEIR INPUT AND OUTPUT PIPES
def nodes(node_type=None):

    graph = dict()

    if node_type is None or node_type == 1:
        wi_nodes = WaterInput.query.all()
        for wi in wi_nodes:
            graph[wi.waterinput_id] = wi.graph_node()

    if node_type is None or node_type == 2:
        wo_nodes = WaterOutput.query.all()
        for wo in wo_nodes:
            graph[wo.wateroutput_id] = wo.graph_node()

    if node_type is None or node_type == 3:
        junction_nodes = Junction.query.all()
        for junction in junction_nodes:
            graph[junction.junction_id] = junction.graph_node()

    if node_type is None or node_type == 4:
        water_tanks = WaterTank.query.all()
        for tank in water_tanks:
            graph[tank.tank_id] = tank.graph_node()

    return graph

# GET ALL PIPES AND THEIR INPUT AND OUTPUT SOURCES
def pipes():
    pipes = Pipe.query.all()
    pipes_dict = dict()

    for pipe in pipes:

        # Search For Input Source
        input = OutPipes.query.filter_by(pipe_id=pipe.pipe_id).first()
        input_type = None
        if input is not None:
            input = input.junction_id
            input_type = "junction"
        else:
            input = WaterTank.query.filter_by(outpipe=pipe.pipe_id).first()
            if input is not None:
                input = input.tank_id
                input_type = "tank"
            else:
                input = WaterInput.query.filter_by(connected_pipe_id=pipe.pipe_id).first()
                if input is not None:
                    input = input.waterinput_id
                    input_type = "waterinput"
                else:
                    print("No Input Found for Pipe: ", pipe.pipe_id)

        # Search For Output Source
        output = InPipes.query.filter_by(pipe_id=pipe.pipe_id).first()
        output_type = None
        if output is not None:
            output = output.junction_id
            output_type = "junction"
        else:
            output = WaterTank.query.filter_by(inpipe=pipe.pipe_id).first()
            if output is not None:
                output = output.tank_id
                output_type = "tank"
            else:
                output = WaterOutput.query.filter_by(connected_pipe_id=pipe.pipe_id).first()
                if output is not None:
                    output = output.wateroutput_id
                    output_type = "wateroutput"
                else:
                    print("No Output Found for Pipe: ", pipe.pipe_id)

        pipes_dict[pipe.pipe_id] = {
            "id": pipe.pipe_id,
            "input": {
                "id": input,
                "group": input_type
            },
            "output": {
                "id": output,
                "group": output_type
            }
        }

    return pipes_dict

# GET THE ZONES IN WHICH EACH WATER INPUT IS SUPPLYING TO
# CHECK EACH WATER INPUT OUTPUT PIPE AND CHECK THE SUBZONE OF THE VALVE
# AN ERROR OCCURS IF THERE IS NO VALVE CONNECTED TO THE PIPE
def water_input_zone():
    water_inputs = WaterInput.query.all()

    water_input_zone = dict()
    for water_input in water_inputs:
        valve = Valve.query.filter_by(valve_id=water_input.connected_pipe_id).first()
        if valve is not None:
            water_input_zone[water_input.waterinput_id] = {
                "water_input_id": water_input.waterinput_id,
                "subzone": valve.subzone.serialize()
            }
        else:
            print("An error occured, pipe connected to water input not found", water_input.waterinput_id)

        return water_input_zone


# A SUBZONE MARKER IS A JUNCTION THAT INPUT PIPE IS CONNECTED TO A VALVE
# AN ERROR OCCURS IF A PIPE IS ZONE MARKER FOR MORE THAT ONE SUBZONE
    
# TODO CHECK FOR ERROR CONDITIONS
def load_subzone_markers():
    valves = Valve.query.all()
    subzone_markers = dict()

    for valve in valves:
        junction = InPipes.query.filter_by(pipe_id=valve.valve_id).first()
        if junction is not None:
            subzone_markers[junction.junction_id] = valve.subzone.serialize()
        else:
            print("An error occured, valve not found", valve.valve_id)
        

    return subzone_markers

"""
"G1J0": {
        "name": "Salida de Agua",
        "priority": 1,
        "subzone_id": "G1F0",
        "zone": {
            "name": "General",
            "zone_id": "G1"
        }
    },
"""
def subzone_markers():
    markers = load_subzone_markers()
    res = []
    for marker_id, marker in markers.items():
        res.append({
            "id": marker_id,
            "subzone": marker['name'],
            "priority": marker['priority'],
            "subzone_id": marker['subzone_id'],
            "zone": marker['zone']['name'],
            "zone_id": marker['zone']['zone_id']
        })

    return res

#  SUBZONE OF EACH NODE
def init_dfs():
    # GRAPH MODELED AS A DICTIONARY
    node_map = nodes()
    pipe_map = pipes()

    # DFS ROOTS
    water_input_zones = water_input_zone()
    # JUNCTIONS THAT ARE SUBZONE MARKERS
    subzone_markers  = load_subzone_markers()

    # STORES THE CASCADING SUBZONE OF EACH NODE
    node_zones = dict()
    # VISITED NODES
    visited = set()

    # FOR EACH WATER INPUT ZONE, STORE THE ZONES IT SUPPLIES TO
    child_zone = dict()
    # EACH SUBZONE OF A ZONE THAT IS NOT A WATER INPUT ZONE THAT STORES THE TANKS
    tank_zone = dict()

    def dfs(node, subzone_id, water_input_id):
        if node in visited:
            return
        visited.add(node)

        # IF THE NODE IS A SUBZONE MARKER, 
            # MARK THAT YOU ENTERED A NEW SUBZONE
            # ADD THE ZONE TO THE WATER INPUT ZONE
        if node in subzone_markers:
            child_zone[water_input_id].add(subzone_markers[node]['zone']['zone_id'])
            subzone_id = subzone_markers[node]

        node_zones[node] = subzone_id

        # IF THE NODE IS A TANK, ADD ITS ZONE: SUBZONE TO THE TANK_ZONE
        if node_map[node]["group"] == "tank":
            tank_zone[subzone_id['zone']['zone_id']] = subzone_id['subzone_id']
        
        for child in node_map[node]["out_pipes"]:
            dfs(pipe_map[child]['output']['id'], subzone_id, water_input_id)

    for node in water_input_zones:
        child_zone[water_input_zones[node]['water_input_id']] = set()
        dfs(node, water_input_zones[node]['subzone']['subzone_id'], water_input_zones[node]['water_input_id'])
        child_zone[water_input_zones[node]['water_input_id']].remove(water_input_zones[node]['subzone']['zone']['zone_id'])

    return node_zones, node_map, pipe_map, water_input_zones, subzone_markers, child_zone, tank_zone

""" water system
{
    "waterinputs":
    [
        {
            "water_input_id": string,
            "zones": [
                "zone_id": string,
                "water_storage": {
                    "zone_id": string,
                    "capacity": double,
                    "level": double
                },
                "subzones": [
                    {
                        "subzone_id": string,
                        "zone_id": string,
                    }
            ],

        }
    ]
}
"""
def resume():
    (node_zones, node_map, pipe_map, water_input_zones, zone_markers, child_zone, tank_zone) = init_dfs()

    zone = dict()
    # FOR EACH WATER TANK, DETECT THE ZONE IT BELONGS TO AND ADD TO THE CAPACITY AND LEVEL
    for tank in WaterTank.query.all():
        zone_id = node_zones[tank.tank_id]['zone']['zone_id']
        # INITIATE THE ZONE IF IT DOES NOT EXIST
        if zone_id not in zone:
            zone[zone_id] = {'zone_id': zone_id}
            zone[zone_id]['capacity'] = 0
            zone[zone_id]['level'] = 0
        # zone[zone_id].append(tank.tank_id)
        zone[zone_id]['capacity'] = zone[zone_id]['capacity'] + tank.capacity
        zone[zone_id]['level'] = zone[zone_id]['level'] + WaterTankLog.query.filter_by(tank_id=tank.tank_id).order_by(WaterTankLog.timestamp.asc()).first().level
        
    # FOR EACH WATER INPUT SOURCE, DETECT ALL THE ZONES IT GIVES WATER TO, AND ADD THE WATER STORAGE
        # FOR EACH SUBZONE, DETECT THE WATER CONSUMED
    resume = {}
    for wi in water_input_zones:
        resume[wi] = {}
        resume[wi]["water_input_id"] = wi
        resume[wi]["zones"] = {}
        for zone_id in child_zone[wi]:
            resume[wi]["zones"][zone_id] = {}
            resume[wi]["zones"][zone_id]["zone_id"] = zone_id
            resume[wi]["zones"][zone_id]["water_storage"] = zone[zone_id]
            resume[wi]["zones"][zone_id]["subzones"] = {}
            resume[wi]["zones"][zone_id]['consumed'] = None
            consumed = 0
            for subzone in Subzone.query.filter_by(zone_id=zone_id).all():
                # GET THE VALVE CONNECTED TO THE SUBZONE
                valve = Valve.query.filter_by(subzone_id=subzone.subzone_id).first()
                if valve is None:
                    print("An error occured, valve not found", subzone.subzone_id)
                    continue
                water_flow = Pipe.query.filter_by(pipe_id=valve.valve_id).first().get_water_flow()

                # IF THE SUBZONE IS A TANK SUBZONE, ADD IT TO THE CONSUMED FIELD OF ZONE
                if subzone.subzone_id == tank_zone[zone_id]:
                    resume[wi]["zones"][zone_id]['consumed'] = water_flow
                # OTHERWISE ADD IT TO THE SUBZONE
                else:
                    resume[wi]["zones"][zone_id]["subzones"][subzone.subzone_id] = {'subzone_id': subzone.subzone_id}
                    resume[wi]["zones"][zone_id]["subzones"][subzone.subzone_id]['consumed'] = water_flow
                    consumed = consumed + water_flow

            if resume[wi]["zones"][zone_id]['consumed'] is None:
                resume[wi]["zones"][zone_id]['consumed'] = 0
                print("An error occured, consumed not found", zone_id)
            else:
                if resume[wi]["zones"][zone_id]['consumed'] != consumed:
                    print("An error occured, consumed not equal to sum of subzones", zone_id)


    # TURN ALL DICTS INTO LISTS
    for wi in resume:
        for zone in resume[wi]['zones']:
            resume[wi]['zones'][zone]['subzones'] = list(resume[wi]['zones'][zone]['subzones'].values())
        resume[wi]['zones'] = list(resume[wi]['zones'].values())
    resume = list(resume.values())

    return {"watersystem": resume}

"""
 {
        "diameter": 1.0,
        "flow_meter_tuple": {
            "meter_input": {
                "installation_date": "Mon, 01 Jan 2024 00:00:00 GMT",
                "meter_id": "G1P0",
                "revised_date": null
            },
            "meter_output": {
                "installation_date": "Mon, 01 Jan 2024 00:00:00 GMT",
                "meter_id": "G1P0",
                "revised_date": null
            },
            "meter_tuple_id": "G1P0",
            "water_input": 1304265.858016741,
            "water_leaked": 65213.292900836794
        },
        "installation_date": "Mon, 01 Jan 2024 00:00:00 GMT",
        "length": 100.0,
        "material": {
            "material_id": 0,
            "name": "Cobre"
        },
        "pipe_id": "G1P0",
        "revised_date": null,
        "thickness": 0.2,
        "valve": {
            "installation_date": "Mon, 01 Jan 2024 00:00:00 GMT",
            "mean_pressure": null,
            "revised_date": null,
            "subzone": {
                "name": "Salida de Agua",
                "priority": 1,
                "subzone_id": "G1F0",
                "zone": {
                    "name": "General",
                    "zone_id": "G1"
                }
            },
            "valve_id": "G1P0"
        },
        "vibrator": {
            "installation_date": "Mon, 01 Jan 2024 00:00:00 GMT",
            "revised_date": null,
            "sensor_id": "G1P0"
        }
    },
"""
def serial(serial_number):
    pipe = Pipe.query.filter_by(pipe_id=serial_number).first()

    return {
        "pipe_id": pipe.pipe_id,
        "diameter": pipe.diameter,
        "length": pipe.length,
        "thickness": pipe.thickness,
        "material": pipe.material.name,
        "priority": pipe.valve.subzone.priority if pipe.valve is not None else None,
        "zone": pipe.valve.subzone.zone.name if pipe.valve is not None else None,
        "subzone": pipe.valve.subzone.name if pipe.valve is not None else None,
        "revision_date": pipe.revised_date,
        "valve": True if pipe.valve is not None else False,
        "vibrator": True if pipe.vibrator is not None else False,
        "flow_meter_tuple": True if pipe.flow_meter_tuple is not None else False
    }

def serials():
    pipes = Pipe.query.all()
    return [
        {
            "pipe_id": pipe.pipe_id,
            "diameter": pipe.diameter,
            "length": pipe.length,
            "thickness": pipe.thickness,
            "material": pipe.material.name,
            "priority": pipe.valve.subzone.priority if pipe.valve is not None else None,
            "zone": pipe.valve.subzone.zone.name if pipe.valve is not None else None,
            "subzone": pipe.valve.subzone.name if pipe.valve is not None else None,
            "revision_date": pipe.revised_date,
            "valve": True if pipe.valve is not None else False,
            "vibrator": True if pipe.vibrator is not None else False,
            "flow_meter_tuple": True if pipe.flow_meter_tuple is not None else False
         } for pipe in pipes
        ]

def vibration():
    with db.engine.connect() as connection:
        result = connection.execute(text("""
        SELECT 
            vsl.sensor_id, 
            AVG(vibration) as average_vibration, 
            p.diameter, 
            p."length", 
            p.thickness ,
            pm.name, 
            s.name, 
            s.subzone_id, 
            z.name, 
            z.zone_id  
        FROM VibrationSensorLog vsl 
        LEFT JOIN Pipe p 
        ON p.pipe_id  = vsl.sensor_id 
        LEFT JOIN PipeMaterial pm 
        ON p.material_id = pm.material_id 
        LEFT JOIN Valve v 
        ON vsl.sensor_id = v.valve_id 
        LEFT JOIN Subzone s 
        ON v.subzone_id  = s.subzone_id 
        LEFT JOIN Zone z
        ON s.zone_id = z.zone_id 
        GROUP BY vsl.sensor_id;
        """))
        # WHERE vsl."timestamp" >= DATETIME('now', '-60 days')

    info = []
    for row in result.fetchall():
        info.append({
            "sensor_id": row[0],
            "average_vibration": row[1],
            "diameter": row[2],
            "length": row[3],
            "thickness": row[4],
            "material": row[5],
            "subzone": row[6],
            "subzone_id": row[7],
            "zone": row[8],
            "zone_id": row[9]
        })

    return info


"""
"G1J0": {
        "group": "junction",
        "id": "G1J0",
        "in_pipes": [
            "G1P0"
        ],
        "out_pipes": [
            "G1P1"
        ]
    },
"""
def maintview(subzone_id):
    (node_zones, nodes_map, pipe_map, water_input_zones, zone_markers, child_zone, tank_zone) = init_dfs()

    res = []
    print(node_zones)
    for node_id,  node in nodes_map.items():
        if node_id == "G1W0":
            continue
        print(node_zones[node_id], subzone_id)
        if node_zones[node_id]['subzone_id'] != subzone_id:
            continue
        res.append({
            "id": node_id,
            "group": node["group"],
        })

    return res
