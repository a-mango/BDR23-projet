SET search_path TO projet;

-- Reparation entries for Power Tool category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (9, 19, 2, 90.00, 'Not turning on', '7 hours', 'waiting', 'waiting'),
    (10, 20, 3, 60.00, 'Blade not cutting properly', '5 hours', 'waiting', 'waiting'),
    (27, 21, 1, 80.00, 'Motor overheating', '3 hours', 'waiting', 'waiting'),
    (28, 22, 2, 50.00, 'Not holding charge', '9 hours', 'waiting', 'waiting');
    (45, 5, 2, 90.00, 'Blade not cutting straight', '7 hours', 'waiting', 'waiting'),
    (46, 6, 3, 60.00, 'Chuck not gripping', '5 hours', 'waiting', 'waiting')
    (45, 5, 2, 90.00, 'Blade not cutting straight', '7 hours', 'waiting', 'waiting'),
    (46, 6, 3, 60.00, 'Chuck not gripping', '5 hours', 'waiting', 'waiting');

-- Reparation entries for Hand Tool category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (11, 23, 3, 70.00, 'Handle broken', '4 hours', 'waiting', 'waiting'),
    (12, 24, 1, 40.00, 'Rust on the head', '2 hours', 'waiting', 'waiting'),
    (29, 25, 2, 60.00, 'Measurement not accurate', '8 hours', 'waiting', 'waiting'),
    (30, 26, 3, 30.00, 'Blade dull', '6 hours', 'waiting', 'waiting');

-- Reparation entries for Clothing category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (13, 27, 1, 80.00, 'Zipper not working', '5 hours', 'waiting', 'waiting'),
    (14, 28, 2, 50.00, 'Sole worn out', '3 hours', 'waiting', 'waiting'),
    (31, 29, 3, 70.00, 'Sole separation', '9 hours', 'waiting', 'waiting'),
    (32, 30, 1, 40.00, 'Zipper stuck', '7 hours', 'waiting', 'waiting');

-- Reparation entries for Vehicle category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (15, 31, 2, 90.00, 'Engine not starting', '6 hours', 'waiting', 'waiting'),
    (16, 32, 3, 60.00, 'Flat tire', '4 hours', 'waiting', 'waiting'),
    (33, 33, 1, 80.00, 'Brake issues', '10 hours', 'waiting', 'waiting'),
    (34, 34, 2, 50.00, 'Cracked deck', '8 hours', 'waiting', 'waiting');

-- Reparation entries for Miscellaneous category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (17, 35, 3, 70.00, 'Stopped ticking', '3 hours', 'waiting', 'waiting'),
    (18, 36, 1, 40.00, 'No sound output', '9 hours', 'waiting', 'waiting'),
    (35, 37, 2, 60.00, 'Alarm not sounding', '7 hours', 'waiting', 'waiting'),
    (36, 38, 3, 30.00, 'Not oscillating', '5 hours', 'waiting', 'waiting');

-- Reparation entries for Electronics category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (19, 39, 1, 80.00, 'Lens not focusing', '8 hours', 'waiting', 'waiting'),
    (20, 40, 2, 50.00, 'No audio in one ear', '6 hours', 'waiting', 'waiting'),
    (37, 41, 3, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting'),
    (38, 42, 1, 40.00, 'Charging issue', '2 hours', 'waiting', 'waiting'),
    (19, 39, 1, 80.00, 'Lens not focusing', '8 hours', 'waiting', 'waiting'),
    (20, 40, 2, 50.00, 'No audio in one ear', '6 hours', 'waiting', 'waiting'),
    (37, 41, 3, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting'),
    (38, 42, 1, 40.00, 'Charging issue', '2 hours', 'waiting', 'waiting')

-- Reparation entries for Computer category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (21, 43, 2, 90.00, 'Paper jamming', '10 hours', 'waiting', 'waiting'),
    (22, 44, 3, 60.00, 'Not recognized by computer', '8 hours', 'waiting', 'waiting'),
    (39, 45, 1, 80.00, 'Ports not working', '6 hours', 'waiting', 'waiting'),
    (40, 46, 2, 50.00, 'Artifacting on display', '4 hours', 'waiting', 'waiting'),
    (21, 43, 2, 90.00, 'Paper jamming', '10 hours', 'waiting', 'waiting'),
    (22, 44, 3, 60.00, 'Not recognized by computer', '8 hours', 'waiting', 'waiting'),
    (39, 45, 1, 80.00, 'Ports not working', '6 hours', 'waiting', 'waiting'),
    (40, 46, 2, 50.00, 'Artifacting on display', '4 hours', 'waiting', 'waiting');    

-- Reparation entries for Household category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (23, 47, 3, 70.00, 'Not brewing', '5 hours', 'waiting', 'waiting'),
    (24, 48, 1, 40.00, 'Fan not working', '3 hours', 'waiting', 'waiting'),
    (41, 49, 2, 60.00, 'Not heating', '9 hours', 'waiting', 'waiting'),
    (42, 50, 3, 30.00, 'Heating element replacement needed', '7 hours', 'waiting', 'waiting'),
    (23, 47, 3, 70.00, 'Not brewing', '5 hours', 'waiting', 'waiting'),
    (24, 48, 1, 40.00, 'Fan not working', '3 hours', 'waiting', 'waiting'),
    (41, 49, 2, 60.00, 'Not heating', '9 hours', 'waiting', 'waiting'),
    (42, 50, 3, 30.00, 'Heating element replacement needed', '7 hours', 'waiting', 'waiting');

-- Reparation entries for Furniture category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (25, 1, 1, 80.00, 'Wobbly structure', '8 hours', 'waiting', 'waiting'),
    (26, 2, 2, 50.00, 'Torn upholstery', '6 hours', 'waiting', 'waiting'),
    (43, 3, 3, 70.00, 'Scratched surface', '4 hours', 'waiting', 'waiting'),
    (44, 4, 1, 40.00, 'Drawer stuck', '2 hours', 'waiting', 'waiting'),
    (25, 1, 1, 80.00, 'Wobbly structure', '8 hours', 'waiting', 'waiting'),
    (26, 2, 2, 50.00, 'Torn upholstery', '6 hours', 'waiting', 'waiting'),
    (43, 3, 3, 70.00, 'Scratched surface', '4 hours', 'waiting', 'waiting'),
    (44, 4, 1, 40.00, 'Drawer stuck', '2 hours', 'waiting', 'waiting');
