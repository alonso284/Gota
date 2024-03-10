PRAGMA foreign_keys = ON;

INSERT INTO Zone (zone_id, name) VALUES 
('G1', 'General'),
('T1', 'Torre 1'),
('T2', 'Torre 2');

INSERT INTO Subzone (subzone_id, zone_id, name, priority) VALUES 
-- Water Output
('G1F0', 'G1', 'Salida de Agua', 1),

-- Edificio 1
('T1F0', 'T1', 'Abierto Edificio 1', 1),
('T1F1', 'T1', 'Lobby', 1),
('T1F2', 'T1', 'Gimnasio', 2),
('T1F3', 'T1', 'Habitaciones 1', 3),
('T1F4', 'T1', 'Habitaciones 2', 4),

-- Edificio 2
('T2F0', 'T2', 'Abierto Edificio 2', 1),
('T2F1', 'T2', 'Lobby', 1),
('T2F2', 'T2', 'Gimnasio', 2),
('T2F3', 'T2', 'Habitaciones 1', 3),
('T2F4', 'T2', 'Habitaciones 2', 4);


INSERT INTO PipeMaterial (material_id, name) VALUES 
(0, 'Cobre'),
(1, 'PVC');

INSERT INTO Pipe (pipe_id, diameter, length, thickness, material_id, installation_date, revised_date) VALUES
-- General
('G1P0', 1, 100, 0.2, 0, '2024-01-01', NULL),
('G1P1', 1, 100, 0.2, 0, '2024-01-01', NULL),

-- Tank System Tower 1
('T1P00', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T1P01', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T1P11', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T1P02', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T1P22', 1, 100, 0.2, 0, '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
('T1P1', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T1P2', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T1P3', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T1P4', 1, 20, 0.1, 0, '2024-01-01', NULL),

-- Tower 1 Floor 1
('T1F1P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T1F1P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 2 Floor 2
('T1F2P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T1F2P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 3 Floor 3
('T1F3P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T1F3P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 4
('T1F4P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T1F4P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),

-- Tank System Tower 2
('T2P00', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T2P01', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T2P11', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T2P02', 1, 100, 0.2, 0, '2024-01-01', NULL),
('T2P22', 1, 100, 0.2, 0, '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
('T2P1', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T2P2', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T2P3', 1, 20, 0.1, 0, '2024-01-01', NULL),
('T2P4', 1, 20, 0.1, 0, '2024-01-01', NULL),

-- Tower 2 Floor 1
('T2F1P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T2F1P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 2 Floor 2
('T2F2P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T2F2P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 2
('T2F3P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T2F3P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
-- Tower 2
('T2F4P1', 0.5, 10, 0.1, 1, '2024-01-01', NULL),
('T2F4P2', 0.5, 10, 0.1, 1, '2024-01-01', NULL);


INSERT INTO WaterTank (tank_id, capacity, installation_date, revised_date, inpipe, outpipe) VALUES
('T1W1', 250, '2024-01-01', NULL, 'T1P01', 'T1P11'),
('T1W2', 250, '2024-01-01', NULL, 'T1P02', 'T1P22'),

('T2W1', 250, '2024-01-01', NULL, 'T2P01', 'T2P11'),
('T2W2', 250, '2024-01-01', NULL, 'T2P02', 'T2P22');


INSERT INTO Valve (valve_id, subzone_id ,installation_date, revised_date) VALUES
('G1P0', 'G1F0', '2024-01-01', NULL),

('T1P00', 'T1F0', '2024-01-01', NULL),
('T2P00', 'T2F0', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
-- ('T1P1', 'T1F0', '2024-01-01', NULL),
-- ('T1P2', 'T1F0', '2024-01-01', NULL),
-- ('T1P3', 'T1F0', '2024-01-01', NULL),
-- ('T1P4', 'T1F0', '2024-01-01', NULL),

-- Tower Floors Tower 1
('T1F1P1', 'T1F1', '2024-01-01', NULL),
('T1F2P1', 'T1F2', '2024-01-01', NULL),
('T1F3P1', 'T1F3', '2024-01-01', NULL),
('T1F4P1', 'T1F4', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
-- ('T2P1', 'T2F0', '2024-01-01', NULL),
-- ('T2P2', 'T2F0', '2024-01-01', NULL),
-- ('T2P3', 'T2F0', '2024-01-01', NULL),
-- ('T2P4', 'T2F0', '2024-01-01', NULL),

-- Tower Floors Tower 2
('T2F1P1', 'T2F1', '2024-01-01', NULL),
('T2F2P1', 'T2F2', '2024-01-01', NULL),
('T2F3P1', 'T2F3', '2024-01-01', NULL),
('T2F4P1', 'T2F4', '2024-01-01', NULL);

INSERT INTO FlowMeterTuple (meter_tuple_id) VALUES
('G1P0'),

('T1P00'),
('T2P00'),

-- ('T1P1'),
-- ('T1P2'),
-- ('T1P3'),
-- ('T1P4'),
('T1F1P1'),
('T1F2P1'),
('T1F3P1'),
('T1F4P1'),
-- ('T2P1'),
-- ('T2P2'),
-- ('T2P3'),
-- ('T2P4'),
('T2F1P1'),
('T2F2P1'),
('T2F3P1'),
('T2F4P1');

INSERT INTO FlowMeterInput (meter_id, installation_date, revised_date) VALUES
-- General
('G1P0', '2024-01-01', NULL),

('T1P00', '2024-01-01', NULL),
('T2P00', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
-- ('T1P1', '2024-01-01', NULL),
-- ('T1P2', '2024-01-01', NULL),
-- ('T1P3', '2024-01-01', NULL),
-- ('T1P4', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
('T1F1P1', '2024-01-01', NULL),
('T1F2P1', '2024-01-01', NULL),
('T1F3P1', '2024-01-01', NULL),
('T1F4P1', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
-- ('T2P1', '2024-01-01', NULL),
-- ('T2P2', '2024-01-01', NULL),
-- ('T2P3', '2024-01-01', NULL),
-- ('T2P4', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
('T2F1P1', '2024-01-01', NULL),
('T2F2P1', '2024-01-01', NULL),
('T2F3P1', '2024-01-01', NULL),
('T2F4P1', '2024-01-01', NULL);

INSERT INTO FlowMeterOutput (meter_id, installation_date, revised_date) VALUES
-- General
('G1P0', '2024-01-01', NULL),

('T1P00', '2024-01-01', NULL),
('T2P00', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
-- ('T1P1', '2024-01-01', NULL),
-- ('T1P2', '2024-01-01', NULL),
-- ('T1P3', '2024-01-01', NULL),
-- ('T1P4', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
('T1F1P1', '2024-01-01', NULL),
('T1F2P1', '2024-01-01', NULL),
('T1F3P1', '2024-01-01', NULL),
('T1F4P1', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
-- ('T2P1', '2024-01-01', NULL),
-- ('T2P2', '2024-01-01', NULL),
-- ('T2P3', '2024-01-01', NULL),
-- ('T2P4', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
('T2F1P1', '2024-01-01', NULL),
('T2F2P1', '2024-01-01', NULL),
('T2F3P1', '2024-01-01', NULL),
('T2F4P1', '2024-01-01', NULL);

INSERT INTO Junction (junction_id, installation_date, revised_date) VALUES
-- General
('G1J0', '2024-01-01', NULL),
('G1J1', '2024-01-01', NULL),

-- Tank System Tower 1
('T1J00', '2024-01-01', NULL),
('T1J01', '2024-01-01', NULL),

-- Tower 1 NO SUBZONE
('T1J1', '2024-01-01', NULL),
('T1J2', '2024-01-01', NULL),
('T1J3', '2024-01-01', NULL),
('T1J4', '2024-01-01', NULL),

-- Tower 1 Floor 1
('T1F1J1', '2024-01-01', NULL),
-- Tower 1 Floor 2
('T1F2J1', '2024-01-01', NULL),
-- Tower 1Floor 3
('T1F3J1', '2024-01-01', NULL),
-- Tower 1 Floor 4
('T1F4J1', '2024-01-01', NULL),

-- Tank System Tower 2
('T2J00', '2024-01-01', NULL),
('T2J01', '2024-01-01', NULL),

-- Tower 2 NO SUBZONE
('T2J1', '2024-01-01', NULL),
('T2J2', '2024-01-01', NULL),
('T2J3', '2024-01-01', NULL),
('T2J4', '2024-01-01', NULL),

-- Tower 2 Floor 1
('T2F1J1', '2024-01-01', NULL),
-- Tower 2 Floor 2
('T2F2J1', '2024-01-01', NULL),
-- Tower 2
('T2F3J1', '2024-01-01', NULL),
-- Tower 2
('T2F4J1', '2024-01-01', NULL);

INSERT INTO InPipes (junction_id, pipe_id) VALUES
-- General
('G1J0', 'G1P0'),
('G1J1', 'G1P1'),

-- Tank System Tower 1
('T1J00', 'T1P00'),
('T1J01', 'T1P11'),
('T1J01', 'T1P22'),

-- Tower 1 NO SUBZONE
('T1J1', 'T1P1'),
('T1J2', 'T1P2'),
('T1J3', 'T1P3'),
('T1J4', 'T1P4'),

-- Tower 1 Floor 1
('T1F1J1', 'T1F1P1'),
-- Tower 1 Floor 2
('T1F2J1', 'T1F2P1'),
-- Tower 1 Floor 3
('T1F3J1', 'T1F3P1'),
-- Tower 1 Floor 4
('T1F4J1', 'T1F4P1'),

-- Tank System Tower 2
('T2J00', 'T2P00'),
('T2J01', 'T2P11'),
('T2J01', 'T2P22'),

-- Tower 2 NO SUBZONE
('T2J1', 'T2P1'),
('T2J2', 'T2P2'),
('T2J3', 'T2P3'),
('T2J4', 'T2P4'),

-- Tower 2 Floor 1
('T2F1J1', 'T2F1P1'),
-- Tower 2 Floor 2
('T2F2J1', 'T2F2P1'),
-- Tower 2 Floor 3
('T2F3J1', 'T2F3P1'),
-- Tower 2 Floor 4
('T2F4J1', 'T2F4P1');

INSERT INTO OutPipes (junction_id, pipe_id) VALUES
-- Into Tank System
('G1J0', 'G1P1'),
('G1J1', 'T1P00'),
('G1J1', 'T2P00'),

-- Out of Tank System Tower 1
('T1J01', 'T1P1'),
-- Out of Tank System Tower 2
('T2J01', 'T2P1'),

-- Tank System Tower 1
('T1J00', 'T1P01'),
('T1J01', 'T1P02'),

-- Tower 1 NO SUBZONE
('T1J1', 'T1P2'),
('T1J1', 'T1F1P1'),
('T1J2', 'T1P3'),
('T1J2', 'T1F2P1'),
('T1J3', 'T1P4'),
('T1J3', 'T1F3P1'),
('T1J4', 'T1F4P1'),

-- Tower 1 Floor 1
('T1F1J1', 'T1F1P2'),
-- Tower 1 Floor 2
('T1F2J1', 'T1F2P2'),
-- Tower 1 Floor 3
('T1F3J1', 'T1F3P2'),
-- Tower 1 Floor 4
('T1F4J1', 'T1F4P2'),

-- Tank System Tower 2
('T2J00', 'T2P01'),
('T2J01', 'T2P02'),

-- Tower 2 NO SUBZONE
('T2J1', 'T2P2'),
('T2J1', 'T2F1P1'),
('T2J2', 'T2P3'),
('T2J2', 'T2F2P1'),
('T2J3', 'T2P4'),
('T2J3', 'T2F3P1'),
('T2J4', 'T2F4P1'),

-- Tower 2 Floor 1
('T2F1J1', 'T2F1P2'),
-- Tower 2 Floor 2
('T2F2J1', 'T2F2P2'),
-- Tower 2 Floor 3
('T2F3J1', 'T2F3P2'),
-- Tower 2 Floor 4
('T2F4J1', 'T2F4P2');

INSERT INTO WaterInput (waterinput_id, capacity, installation_date, revised_date, connected_pipe_id) VALUES
-- General
('G1W0', 25000, '2024-01-01', NULL, 'G1P0');

INSERT INTO WaterOutput (wateroutput_id, installation_date, revised_date, connected_pipe_id) VALUES
('T1F1W1', '2024-01-01', NULL, 'T1F1P2'),
('T1F2W1', '2024-01-01', NULL, 'T1F2P2'),
('T1F3W1', '2024-01-01', NULL, 'T1F3P2'),
('T1F4W1', '2024-01-01', NULL, 'T1F4P2'),

('T2F1W1', '2024-01-01', NULL, 'T2F1P2'),
('T2F2W1', '2024-01-01', NULL, 'T2F2P2'),
('T2F3W1', '2024-01-01', NULL, 'T2F3P2'),
('T2F4W1', '2024-01-01', NULL, 'T2F4P2');

INSERT INTO WaterTankLog (tank_id, timestamp, level) VALUES
('T1W1', '2024-01-01 00:00:00', 150),
('T1W2', '2024-01-01 00:00:00', 150),
('T2W1', '2024-01-01 00:00:00', 150),
('T2W2', '2024-01-01 00:00:00', 150);

INSERT INTO VibrationSensor (sensor_id, installation_date, revised_date) VALUES
('G1P0', '2024-01-01', NULL),
('G1P1', '2024-01-01', NULL),

('T1P00', '2024-01-01', NULL),
('T1P01', '2024-01-01', NULL),
('T1P11', '2024-01-01', NULL),
('T1P02', '2024-01-01', NULL),
('T1P22', '2024-01-01', NULL),

('T1P1', '2024-01-01', NULL),
('T1P2', '2024-01-01', NULL),
('T1P3', '2024-01-01', NULL),
('T1P4', '2024-01-01', NULL),

('T1F1P1', '2024-01-01', NULL),
('T1F1P2', '2024-01-01', NULL),
('T1F2P1', '2024-01-01', NULL),
('T1F2P2', '2024-01-01', NULL),
('T1F3P1', '2024-01-01', NULL),
('T1F3P2', '2024-01-01', NULL),
('T1F4P1', '2024-01-01', NULL),
('T1F4P2', '2024-01-01', NULL),

('T2P00', '2024-01-01', NULL),
('T2P01', '2024-01-01', NULL),
('T2P11', '2024-01-01', NULL),
('T2P02', '2024-01-01', NULL),
('T2P22', '2024-01-01', NULL),

('T2P1', '2024-01-01', NULL),
('T2P2', '2024-01-01', NULL),
('T2P3', '2024-01-01', NULL),
('T2P4', '2024-01-01', NULL),

('T2F1P1', '2024-01-01', NULL),
('T2F1P2', '2024-01-01', NULL),
('T2F2P1', '2024-01-01', NULL),
('T2F2P2', '2024-01-01', NULL),
('T2F3P1', '2024-01-01', NULL),
('T2F3P2', '2024-01-01', NULL),
('T2F4P1', '2024-01-01', NULL),
('T2F4P2', '2024-01-01', NULL);