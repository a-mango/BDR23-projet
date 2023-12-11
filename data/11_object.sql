SET search_path TO projet;

-- Electronics category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (1, 'Laptop', 'Not powering on', 'in_stock', 'Needs urgent repair', 'SN123456', 'Apeul', 'Electronics');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (2, 'Smartphone', 'Cracked screen', 'in_stock', 'Screen replacement needed', 'SN789012', 'Bousch', 'Electronics');

-- Computer category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (3, 'Desktop Computer', 'Slow performance', 'in_stock', 'Software optimization required', 'SN345678', 'Jurah', 'Computer');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (4, 'Tablet', 'Battery not holding charge', 'in_stock', 'Battery replacement needed', 'SN901234', 'Karscheur', 'Computer');

-- Household category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (5, 'Vacuum Cleaner', 'Not picking up dirt', 'in_stock', 'Motor replacement required', 'SN567890', 'Brown', 'Household');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (6, 'Toaster', 'Not toasting evenly', 'in_stock', 'Heating element needs replacement', 'SN123789', 'Samsong', 'Household');

-- Furniture category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (7, 'Dining Table', 'Broken leg', 'in_stock', 'Leg repair needed', 'SN456012', 'Sanyo', 'Furniture');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (8, 'Sofa', 'Torn upholstery', 'in_stock', 'Upholstery replacement required', 'SN890123', 'Sanyu', 'Furniture');

-- Power Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (9, 'Drill', 'Not turning on', 'in_stock', 'Power switch replacement needed', 'SN012345', 'Toshibu', 'Power Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (10, 'Circular Saw', 'Blade not cutting properly', 'for_sale', 'Blade sharpening required', 'SN567890', 'Aipad', 'Power Tool');

-- Hand Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (11, 'Screwdriver Set', 'Handle broken', 'in_stock', 'Handle replacement needed', 'SN123789', 'Deel', 'Hand Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (12, 'Wrench', 'Rust on the head', 'in_stock', 'Head cleaning and rust removal required', 'SN456012', 'Aipad', 'Hand Tool');

-- Clothing category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (13, 'Leather Jacket', 'Zipper not working', 'in_stock', 'Zipper replacement needed', 'SN890123', 'Deel', 'Clothing');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (14, 'Running Shoes', 'Sole worn out', 'in_stock', 'Sole replacement required', 'SN012345', 'Bousch', 'Clothing');

-- Vehicle category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (15, 'Car', 'Engine not starting', 'in_stock', 'Engine repair needed', 'SN567890', 'Jurah', 'Vehicle');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (16, 'Bicycle', 'Flat tire', 'in_stock', 'Tire replacement required', 'SN123789', 'Karscheur', 'Vehicle');

-- Miscellaneous category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (17, 'Watch', 'Stopped ticking', 'in_stock', 'Battery replacement needed', 'SN456012', 'Brown', 'Miscellaneous');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (18, 'Bluetooth Speaker', 'No sound output', 'in_stock', 'Speaker repair needed', 'SN890123', 'Samsong', 'Miscellaneous');

-- Electronics category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (19, 'Digital Camera', 'Lens not focusing', 'in_stock', 'Lens adjustment needed', NULL, 'Apeul', 'Electronics');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (20, 'Headphones', 'No audio in one ear', 'in_stock', 'Audio cable replacement needed', 'SN901234', 'Bousch', 'Electronics');

-- Computer category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (21, 'Laser Printer', 'Paper jamming', 'in_stock', 'Paper feed mechanism repair required', 'SN567890', 'Jurah', 'Computer');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (22, 'External Hard Drive', 'Not recognized by computer', 'in_stock', 'Data recovery and cable replacement needed', 'SN123789', 'Karscheur', 'Computer');

-- Household category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (23, 'Coffee Maker', 'Not brewing', 'in_stock', 'Heating element replacement required', 'SN456012', 'Brown', 'Household');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (24, 'Blender', 'Blades not spinning', 'in_stock', 'Blade motor repair needed', 'SN890123', 'Samsong', 'Household');

-- Furniture category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (25, 'Bookshelf', 'Wobbly structure', 'in_stock', 'Stability reinforcement required', 'SN012345', 'Sanyo', 'Furniture');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (26, 'Office Chair', 'Torn upholstery', 'in_stock', 'Upholstery replacement required', 'SN567890', 'Sanyu', 'Furniture');

-- Power Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (27, 'Angle Grinder', 'Motor overheating', 'in_stock', 'Motor cooling and repair needed', 'SN123789', 'Toshibu', 'Power Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (28, 'Electric Screwdriver', 'Not holding charge', 'in_stock', 'Battery replacement required', 'SN456012', 'Aipad', 'Power Tool');

-- Hand Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (29, 'Tape Measure', 'Measurement not accurate', 'in_stock', 'Calibration needed', NULL, 'Deel', 'Hand Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (30, 'Hacksaw', 'Blade dull', 'for_sale', 'Blade replacement required', NULL, 'Aipad', 'Hand Tool');

-- Clothing category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (31, 'Leather Boots', 'Sole separation', 'in_stock', 'Sole reattachment needed', 'SN567890', 'Deel', 'Clothing');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (32, 'Winter Jacket', 'Zipper stuck', 'for_sale', 'Zipper repair and lubrication needed', 'SN123789', 'Bousch', 'Clothing');

-- Vehicle category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (33, 'Motorcycle', 'Brake issues', 'in_stock', 'Brake system repair needed', 'SN456012', 'Jurah', 'Vehicle');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (34, 'Skateboard', 'Cracked deck', 'for_sale', 'Deck replacement required', 'SN890123', 'Karscheur', 'Vehicle');

-- Miscellaneous category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (35, 'Alarm Clock', 'Alarm not sounding', 'in_stock', 'Alarm mechanism repair needed', 'SN012345', 'Brown', 'Miscellaneous');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (36, 'Portable Fan', 'Not oscillating', 'in_stock', 'Oscillation motor repair required', 'SN567890', 'Samsong', 'Miscellaneous');

-- Electronics category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (37, 'Smartwatch', 'Screen not responsive', 'in_stock', 'Touchscreen replacement needed', 'SN123456', 'Apeul', 'Electronics');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (38, 'Bluetooth Earbuds', 'Charging issue', 'for_sale', 'Charging port repair required', 'SN789012', 'Bousch', 'Electronics');

-- Computer category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (39, 'Laptop Docking Station', 'Ports not working', 'in_stock', 'Port replacement needed', 'SN345678', 'Jurah', 'Computer');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (40, 'Graphics Card', 'Artifacting on display', 'in_stock', 'Graphics card replacement required', 'SN901234', 'Karscheur', 'Computer');

-- Household category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (41, 'Microwave', 'Not heating', 'in_stock', 'Magnetron replacement needed', 'SN567890', 'Brown', 'Household');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (42, 'Air Purifier', 'Fan not working', 'for_sale', 'Fan motor repair required', 'SN123789', 'Samsong', 'Household');

-- Furniture category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (43, 'Coffee Table', 'Scratched surface', 'in_stock', 'Surface refinishing needed', 'SN456012', 'Sanyo', 'Furniture');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (44, 'Office Desk', 'Drawer stuck', 'in_stock', 'Drawer mechanism repair required', 'SN890123', 'Sanyu', 'Furniture');

-- Power Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (45, 'Jigsaw', 'Blade not cutting straight', 'in_stock', 'Blade alignment needed', 'SN012345', 'Toshibu', 'Power Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (46, 'Impact Driver', 'Chuck not gripping', 'in_stock', 'Chuck replacement required', 'SN567890', 'Aipad', 'Power Tool');

-- Hand Tool category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (47, 'Utility Knife', 'Blade not retracting', 'in_stock', 'Blade retraction mechanism repair needed', 'SN123789', 'Deel', 'Hand Tool');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (48, 'Adjustable Wrench', 'Jaw misalignment', 'in_stock', 'Jaw realignment needed', 'SN456012', 'Aipad', 'Hand Tool');

-- Clothing category
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (49, 'Winter Gloves', 'Torn stitching', 'in_stock', 'Stitching repair required', 'SN890123', 'Deel', 'Clothing');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (50, 'Hiking Backpack', 'Zipper snagging', 'in_stock', 'Zipper repair and lubrication needed', 'SN012345', 'Bousch', 'Clothing');
