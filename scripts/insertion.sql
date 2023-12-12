SET search_path TO projet;

-- Create a new Person and Customer in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertCustomer(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _tos_accepted BOOLEAN,
    _private_note TEXT
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_person_id INTEGER;
BEGIN
    -- Insert into Person and get the new ID
    INSERT INTO projet.person (name, phone_no, comment)
    VALUES (_name, _phone_no, _comment)
    RETURNING person_id INTO new_person_id;

    -- Insert into Customer using the new Person ID
    INSERT INTO projet.customer (customer_id, tos_accepted, private_note)
    VALUES (new_person_id, _tos_accepted, _private_note);
END;
$$;

-- Create a new Person and Collaborator in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertCollaborator(
    IN _name VARCHAR,
    IN _phone_no VARCHAR,
    IN _comment TEXT,
    IN _email TEXT,
    INOUT _collaborator_id INTEGER
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_person_id INTEGER;
BEGIN
    -- Insert into Person and get the new ID
    INSERT INTO projet.person (name, phone_no, comment)
    VALUES (_name, _phone_no, _comment)
    RETURNING person_id INTO new_person_id;

    -- Insert into Collaborator using the new Person ID
    INSERT INTO projet.collaborator (collaborator_id, email)
    VALUES (new_person_id, _email)
    RETURNING collaborator_id INTO _collaborator_id;
END;
$$;

-- Create a new Person, Collaborator and Manager in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertManager(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Manager using the new Person ID
    INSERT INTO projet.manager (manager_id)
    VALUES (new_person_id);
END;
$$;

-- Create a new Person, Collaborator and Receptionist in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertReceptionist(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Receptionist using the new Person ID
    INSERT INTO projet.receptionist (receptionist_id)
    VALUES (new_person_id);
END;
$$;

-- Create a new Person, Collaborator and Technician in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertTechnician(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Technician using the new Person ID
    INSERT INTO projet.technician (technician_id)
    VALUES (new_person_id);
END;
$$;

--
-- Customer insertion
--
CALL InsertCustomer('Jeffrey Dayne', '7509811074', 'Vivamus vel nulla eget eros elementum pellentesque.', true, null);
CALL InsertCustomer('Barris Dugue', '3869329401', null, true, null);
CALL InsertCustomer('Davey O'' Liddy', '9333998972', 'Nam tristique tortor eu pede.', true, null);
CALL InsertCustomer('Jamaal Eaglestone', '4153821884', null, true, null);
CALL InsertCustomer('Shaw Hurich', '9289485117', null, true, null);
CALL InsertCustomer('Shari Huniwall', '3748280535', null, true, null);
CALL InsertCustomer('Alvin Binch', '1576059000', null, true, null);
CALL InsertCustomer('Kordula Goulter', '2117079631', 'Vivamus vel nulla eget eros elementum pellentesque.', true, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.');
CALL InsertCustomer('Daphne Roly', '5841556990', null, true, null);
CALL InsertCustomer('Francisca Bouldon', '1554714353', null, true, null);
CALL InsertCustomer('Heidie Saenz', '1625688540', null, true, null);
CALL InsertCustomer('Marabel Lilleman', '7427338531', 'Nam nulla.', true, null);
CALL InsertCustomer('Karine Clarey', '2656777071', null, true, null);
CALL InsertCustomer('Ursuline Macari', '2252330197', null, true, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.');
CALL InsertCustomer('Jordanna Andrejs', '7272619255', null, true, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.');
CALL InsertCustomer('Dario Hardeman', '4961832403', null, true, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.');
CALL InsertCustomer('Kipp O''Shirine', '1911682485', null, true, null);
CALL InsertCustomer('Cosmo Tortice', '9425778234', null, true, null);
CALL InsertCustomer('Rodney Dagger', '2086601361', null, true, null);
CALL InsertCustomer('Marilee Greenroad', '3043025593', null, true, null);
CALL InsertCustomer('Brigham Lathey', '6681245302', 'Nulla ut erat id mauris vulputate elementum.', true, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
CALL InsertCustomer('Ronnie Gearing', '4041368171', null, true, null);
CALL InsertCustomer('Garvy Ruit', '4582711234', 'Duis ac nibh.', true, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.');
CALL InsertCustomer('Kathryne Scarasbrick', '7214950616', null, true, null);
CALL InsertCustomer('Karin Tedorenko', '9393204438', 'In congue.', true, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.');
CALL InsertCustomer('Goldy Stigers', '7788397622', null, true, null);
CALL InsertCustomer('Stefania Collihole', '8183530508', null, true, null);
CALL InsertCustomer('Chance Kirwin', '3357891471', null, true, null);
CALL InsertCustomer('Truda Raybould', '8046789823', null, true, null);
CALL InsertCustomer('Rubetta Boffin', '7644258879', null, true, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.');
CALL InsertCustomer('Jeffy Hopfer', '1086694457', null, true, null);
CALL InsertCustomer('Aggy Lee', '2356940339', null, true, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
CALL InsertCustomer('Torie Caskie', '9845978906', null, true, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
CALL InsertCustomer('Magdaia Capelin', '9631312077', null, true, null);
CALL InsertCustomer('Wylma Scamwell', '2507780331', null, true, null);
CALL InsertCustomer('Gwendolen Boulstridge', '7841546275', null, true, null);
CALL InsertCustomer('Jethro Kilfedder', '6823527703', null, true, null);
CALL InsertCustomer('Orlando Brackenbury', '6789735999', null, true, null);
CALL InsertCustomer('Torey Bolliver', '1849079988', null, true, null);
CALL InsertCustomer('Natala Gaitung', '3624483477', null, true, null);
CALL InsertCustomer('Ramon Spurdle', '4948737986', null, true, null);
CALL InsertCustomer('Brien Walklott', '5172331839', null, true, null);
CALL InsertCustomer('Martie Reilly', '6869372742', null, true, 'Aenean sit amet justo.');
CALL InsertCustomer('Joelle Mishaw', '8949495741', null, true, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.');
CALL InsertCustomer('Isahella Caplen', '7927615330', null, true, null);
CALL InsertCustomer('Ugo St. Queintain', '1673941666', null, true, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.');
CALL InsertCustomer('Drew Bircher', '9342736859', null, true, null);
CALL InsertCustomer('Lotta Ellaman', '3444095541', null, true, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.');
CALL InsertCustomer('Aryn Santos', '4406289262', null, true, 'Morbi a ipsum. Integer a nibh.');
CALL InsertCustomer('Zane Entissle', '9898594506', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', true, null);

--
-- Manager insertion
--
CALL projet.InsertManager('Hugues Marshman', '5827558909', null, 'hmarshman0@list-manage.com'); -- 51
CALL projet.InsertManager('Melanie O''Rourke', '8549739202', null, 'morourke1@addtoany.com'); -- 52
CALL projet.InsertManager('Julius Wasielewicz', '8921298385', null, 'jwasielewicz2@51.la'); -- 53

--
-- Technician insertion
--
CALL InsertTechnician('Alphonso Kerrich', '9949134373', 'Aliquam sit amet diam in magna bibendum imperdiet.', 'akerrich0@dion.ne.jp'); -- 54
CALL InsertTechnician('Andrea Millhill', '7833355818', 'Nulla mollis molestie lorem.', 'amillhill1@prnewswire.com');
CALL InsertTechnician('Angeline Archard', '1497749196', null, 'aarchard2@desdev.cn');
CALL InsertTechnician('Reg Willers', '6988015614', null, 'rwillers3@wikipedia.org');
CALL InsertTechnician('Olva Tollit', '6332366308', null, 'otollit4@adobe.com');
CALL InsertTechnician('Templeton Nortcliffe', '7481454963', null, 'tnortcliffe5@ibm.com');
CALL InsertTechnician('Alanna Weatherby', '4409610170', null, 'aweatherby6@addthis.com');
CALL InsertTechnician('Magdaia Egger', '5347026159', null, 'megger7@chronoengine.com');
CALL InsertTechnician('Lynnette Bance', '9454171346', null, 'lbance8@miibeian.gov.cn');
CALL InsertTechnician('Temp Bendtsen', '3566687660', 'In hac habitasse platea dictumst.', 'tbendtsen9@yahoo.com');
CALL InsertTechnician('Lyndell McDougal', '3173129088', 'Fusce posuere felis sed lacus.', 'lmcdougala@myspace.com');
CALL InsertTechnician('Kaila Haythorne', '5741093584', null, 'khaythorneb@hibu.com');
CALL InsertTechnician('Oliver Schroeder', '1145980270', null, 'oschroederc@cyberchimps.com');
CALL InsertTechnician('Germana Leal', '6738563042', null, 'gleald@technorati.com');
CALL InsertTechnician('Ebba Lerer', '1371807550', null, 'elerere@netvibes.com'); -- 68

--
-- Receptionist insertion
--
CALL InsertReceptionist('Alic Klagges', '1167567619', null, 'aklagges0@shop-pro.jp'); -- 69
CALL InsertReceptionist('Celestyn Deeth', '8254514158', 'Quisque ut erat.', 'cdeeth1@nydailynews.com'); -- 70
CALL InsertReceptionist('Courtney Coventry', '1103928379', null, 'ccoventry2@alexa.com'); -- 71

--
-- Language insertion
--
INSERT INTO language (name) VALUES ('English');
INSERT INTO language (name) VALUES ('French');
INSERT INTO language (name) VALUES ('Spanish');
INSERT INTO language (name) VALUES ('German');
INSERT INTO language (name) VALUES ('Italian');
INSERT INTO language (name) VALUES ('Portuguese');

--
-- Receptionist_language insertion
--
INSERT INTO receptionist_language (receptionist_id, language) VALUES (69, 'English');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (69, 'French');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (69, 'Spanish');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (70, 'English');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (70, 'French');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (70, 'Italian');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (71, 'English');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (71, 'French');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (71, 'Portuguese');
INSERT INTO receptionist_language (receptionist_id, language) VALUES (71, 'German');

--
-- Specialization insertion
--
INSERT INTO specialization (name) VALUES ('Electronics');
INSERT INTO specialization (name) VALUES ('Plumbing');
INSERT INTO specialization (name) VALUES ('Woodworking');
INSERT INTO specialization (name) VALUES ('Microelectronics');
INSERT INTO specialization (name) VALUES ('Miscellaneous');
INSERT INTO specialization (name) VALUES ('Refrigeration');
INSERT INTO specialization (name) VALUES ('Locksmith');
INSERT INTO specialization (name) VALUES ('Mechanics');
INSERT INTO specialization (name) VALUES ('Electricity');
INSERT INTO specialization (name) VALUES ('Sewing');
INSERT INTO specialization (name) VALUES ('Painting');
INSERT INTO specialization (name) VALUES ('Stonecutting');

--
-- Technician_specialization insertion
--
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (54, 'Electronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (54, 'Plumbing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (54, 'Woodworking');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (55, 'Microelectronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (55, 'Miscellaneous');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (55, 'Refrigeration');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (56, 'Locksmith');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (56, 'Mechanics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (56, 'Electricity');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (57, 'Sewing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (57, 'Painting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (57, 'Stonecutting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (58, 'Electronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (58, 'Plumbing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (58, 'Woodworking');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (59, 'Microelectronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (59, 'Miscellaneous');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (59, 'Refrigeration');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (60, 'Locksmith');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (60, 'Mechanics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (60, 'Electricity');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Sewing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Painting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Stonecutting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Electronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Plumbing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (61, 'Woodworking');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (62, 'Microelectronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (62, 'Miscellaneous');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (62, 'Refrigeration');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (63, 'Locksmith');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (63, 'Mechanics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (63, 'Electricity');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (64, 'Sewing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (64, 'Painting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (64, 'Stonecutting');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (65, 'Electronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (65, 'Plumbing');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (65, 'Woodworking');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (66, 'Microelectronics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (66, 'Miscellaneous');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (66, 'Refrigeration');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (67, 'Locksmith');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (67, 'Mechanics');
INSERT INTO technician_specialization (technician_id, spec_name) VALUES (67, 'Electricity');

--
-- Brand insertion
--
INSERT INTO brand (name) VALUES ('Apeul');
INSERT INTO brand (name) VALUES ('Bousch');
INSERT INTO brand (name) VALUES ('Jurah');
INSERT INTO brand (name) VALUES ('Karscheur');
INSERT INTO brand (name) VALUES ('Brown');
INSERT INTO brand (name) VALUES ('Samsong');
INSERT INTO brand (name) VALUES ('Sanyo');
INSERT INTO brand (name) VALUES ('Sanyu');
INSERT INTO brand (name) VALUES ('Toshibu');
INSERT INTO brand (name) VALUES ('Aipad');
INSERT INTO brand (name) VALUES ('Deel');

--
-- Category insertion
--
INSERT INTO category (name) VALUES ('Electronics');
INSERT INTO category (name) VALUES ('Computer');
INSERT INTO category (name) VALUES ('Household');
INSERT INTO category (name) VALUES ('Furniture');
INSERT INTO category (name) VALUES ('Power Tool');
INSERT INTO category (name) VALUES ('Hand Tool');
INSERT INTO category (name) VALUES ('Clothing');
INSERT INTO category (name) VALUES ('Vehicle');
INSERT INTO category (name) VALUES ('Miscellaneous');

INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES
    (1, 'Laptop', 'Not powering on', 'in_stock', 'Needs urgent repair', 'SN123456', 'Apeul', 'Electronics'),
    (2, 'Smartphone', 'Cracked screen', 'returned', 'Screen replacement needed', 'SN789012', 'Bousch', 'Electronics'),
    (3, 'Desktop Computer', 'Slow performance', 'returned', 'Software optimization required', 'SN345678', 'Jurah', 'Computer'),
    (4, 'Tablet', 'Battery not holding charge', 'returned', 'Battery replacement needed', 'SN901234', 'Karscheur', 'Computer'),
    (5, 'Vacuum Cleaner', 'Not picking up dirt', 'returned', 'Motor replacement required', 'SN567890', 'Brown', 'Household'),
    (6, 'Toaster', 'Not toasting evenly', 'returned', 'Heating element needs replacement', 'SN123789', 'Samsong', 'Household'),
    (7, 'Dining Table', 'Broken leg', 'returned', 'Leg repair needed', 'SN456012', 'Sanyo', 'Furniture'),
    (8, 'Sofa', 'Torn upholstery', 'in_stock', 'Upholstery replacement required', 'SN890123', 'Sanyu', 'Furniture'),
    (9, 'Drill', 'Not turning on', 'returned', 'Power switch replacement needed', 'SN012345', 'Toshibu', 'Power Tool'),
    (10, 'Circular Saw', 'Blade not cutting properly', 'for_sale', 'Blade sharpening required', 'SN567890', 'Aipad', 'Power Tool'),
    (11, 'Screwdriver Set', 'Handle broken', 'returned', 'Handle replacement needed', 'SN123789', 'Deel', 'Hand Tool'),
    (12, 'Wrench', 'Rust on the head', 'returned', 'Head cleaning and rust removal required', 'SN456012', 'Aipad', 'Hand Tool'),
    (13, 'Leather Jacket', 'Zipper not working', 'in_stock', 'Zipper replacement needed', 'SN890123', 'Deel', 'Clothing'),
    (14, 'Running Shoes', 'Sole worn out', 'returned', 'Sole replacement required', 'SN012345', 'Bousch', 'Clothing'),
    (15, 'Car', 'Engine not starting', 'in_stock', 'Engine repair needed', 'SN567890', 'Jurah', 'Vehicle'),
    (16, 'Bicycle', 'Flat tire', 'returned', 'Tire replacement required', 'SN123789', 'Karscheur', 'Vehicle'),
    (17, 'Watch', 'Stopped ticking', 'returned', 'Battery replacement needed', 'SN456012', 'Brown', 'Miscellaneous'),
    (18, 'Bluetooth Speaker', 'No sound output', 'in_stock', 'Speaker repair needed', 'SN890123', 'Samsong', 'Miscellaneous'),
    (19, 'Digital Camera', 'Lens not focusing', 'returned', 'Lens adjustment needed', NULL, 'Apeul', 'Electronics'),
    (20, 'Headphones', 'No audio in one ear', 'returned', 'Audio cable replacement needed', 'SN901234', 'Bousch', 'Electronics'),
    (21, 'Laser Printer', 'Paper jamming', 'returned', 'Paper feed mechanism repair required', 'SN567890', 'Jurah', 'Computer'),
    (22, 'External Hard Drive', 'Not recognized by computer', 'in_stock', 'Data recovery and cable replacement needed', 'SN123789', 'Karscheur', 'Computer'),
    (23, 'Coffee Maker', 'Not brewing', 'returned', 'Heating element replacement required', 'SN456012', 'Brown', 'Household'),
    (24, 'Blender', 'Blades not spinning', 'returned', 'Blade motor repair needed', 'SN890123', 'Samsong', 'Household'),
    (25, 'Bookshelf', 'Wobbly structure', 'in_stock', 'Stability reinforcement required', 'SN012345', 'Sanyo', 'Furniture'),
    (26, 'Office Chair', 'Torn upholstery', 'returned', 'Upholstery replacement required', 'SN567890', 'Sanyu', 'Furniture'),
    (27, 'Angle Grinder', 'Motor overheating', 'in_stock', 'Motor cooling and repair needed', 'SN123789', 'Toshibu', 'Power Tool'),
    (28, 'Electric Screwdriver', 'Not holding charge', 'returned', 'Battery replacement required', 'SN456012', 'Aipad', 'Power Tool'),
    (29, 'Tape Measure', 'Measurement not accurate', 'returned', 'Calibration needed', NULL, 'Deel', 'Hand Tool'),
    (30, 'Hacksaw', 'Blade dull', 'for_sale', 'Blade replacement required', NULL, 'Aipad', 'Hand Tool'),
    (31, 'Leather Boots', 'Sole separation', 'returned', 'Sole reattachment needed', 'SN567890', 'Deel', 'Clothing'),
    (32, 'Winter Jacket', 'Zipper stuck', 'sold', 'Zipper repair and lubrication needed', 'SN123789', 'Bousch', 'Clothing'),
    (33, 'Motorcycle', 'Brake issues', 'returned', 'Brake system repair needed', 'SN456012', 'Jurah', 'Vehicle'),
    (34, 'Skateboard', 'Cracked deck', 'sold', 'Deck replacement required', 'SN890123', 'Karscheur', 'Vehicle'),
    (35, 'Alarm Clock', 'Alarm not sounding', 'returned', 'Alarm mechanism repair needed', 'SN012345', 'Brown', 'Miscellaneous'),
    (36, 'Portable Fan', 'Not oscillating', 'returned', 'Oscillation motor repair required', 'SN567890', 'Samsong', 'Miscellaneous'),
    (37, 'Smartwatch', 'Screen not responsive', 'in_stock', 'Touchscreen replacement needed', 'SN123456', 'Apeul', 'Electronics'),
    (38, 'Bluetooth Earbuds', 'Charging issue', 'for_sale', 'Charging port repair required', 'SN789012', 'Bousch', 'Electronics'),
    (39, 'Laptop Docking Station', 'Ports not working', 'in_stock', 'Port replacement needed', 'SN345678', 'Jurah', 'Computer'),
    (40, 'Graphics Card', 'Artifacting on display', 'in_stock', 'Graphics card replacement required', 'SN901234', 'Karscheur', 'Computer'),
    (41, 'Microwave', 'Not heating', 'in_stock', 'Magnetron replacement needed', 'SN567890', 'Brown', 'Household'),
    (42, 'Air Purifier', 'Fan not working', 'sold', 'Fan motor repair required', 'SN123789', 'Samsong', 'Household'),
    (43, 'Coffee Table', 'Scratched surface', 'in_stock', 'Surface refinishing needed', 'SN456012', 'Sanyo', 'Furniture'),
    (44, 'Office Desk', 'Drawer stuck', 'in_stock', 'Drawer mechanism repair required', 'SN890123', 'Sanyu', 'Furniture'),
    (45, 'Jigsaw', 'Blade not cutting straight', 'returned', 'Blade alignment needed', 'SN012345', 'Toshibu', 'Power Tool'),
    (46, 'Impact Driver', 'Chuck not gripping', 'returned', 'Chuck replacement required', 'SN567890', 'Aipad', 'Power Tool'),
    (47, 'Utility Knife', 'Blade not retracting', 'in_stock', 'Blade retraction mechanism repair needed', 'SN123789', 'Deel', 'Hand Tool'),
    (48, 'Adjustable Wrench', 'Jaw misalignment', 'in_stock', 'Jaw realignment needed', 'SN456012', 'Aipad', 'Hand Tool'),
    (49, 'Winter Gloves', 'Torn stitching', 'in_stock', 'Stitching repair required', 'SN890123', 'Deel', 'Clothing'),
    (50, 'Hiking Backpack', 'Zipper snagging', 'in_stock', 'Zipper repair and lubrication needed', 'SN012345', 'Bousch', 'Clothing');

--
-- Sale insertion
--
INSERT INTO sale (object_id, price, date_sold)
VALUES 
    (10, 50.00, NULL),
    (30, 120.00, NULL),
    (32, 25.00, DATE '2023-6-30'),
    (34, 30.00, DATE '2023-10-11'),
    (38, 200.00, NULL),
    (42, 20.00, DATE '2023-01-01');

--
-- Reparation insertion
--
-- Reparation entries for Power Tool category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (1, 1, 69, 80.00, 'Needs urgent repair', '2 hours', 'ongoing', 'accepted'),
    (2, 2, 70, 50.00, 'Screen replacement needed', '3 hours', 'done', 'accepted'),
    (3, 3, 71, 90.00, 'Software optimization required', '4 hours', 'done', 'accepted'),
    (4, 4, 69, 60.00, 'Battery replacement needed', '5 hours', 'done', 'accepted'),
    (5, 7, 69, 70.00, 'Motor replacement required', '6 hours', 'done', 'accepted'),
    (6, 8, 71, 40.00, 'Heating element needs replacement', '7 hours', 'done', 'accepted'),
    (7, 11, 71, 80.00, 'Leg repair needed', '8 hours', 'done', 'accepted'),
    (8, 12, 70, 50.00, 'Upholstery replacement required', '9 hours', 'done', 'accepted'),
    (9, 19, 69, 90.00, 'Not turning on', '7 hours', 'done', 'accepted'),
    (10, 20, 71, 60.00, 'Blade not cutting properly', '5 hours', 'done', 'declined'),
    (11, 23, 71, 70.00, 'Handle broken', '4 hours', 'done', 'accepted'),
    (12, 24, 70, 40.00, 'Rust on the head', '2 hours', 'done', 'accepted'),
    (13, 27, 70, 80.00, 'Zipper not working', '5 hours', 'ongoing', 'accepted'),
    (14, 28, 69, 50.00, 'Sole worn out', '3 hours', 'done', 'accepted'),
    (15, 31, 69, 90.00, 'Engine not starting', '6 hours', 'ongoing', 'accepted'),
    (16, 32, 71, 60.00, 'Flat tire', '4 hours', 'done', 'accepted'),
    (17, 35, 71, 70.00, 'Stopped ticking', '3 hours', 'done', 'accepted'),
    (18, 36, 70, 40.00, 'No sound output', '9 hours', 'waiting', 'waiting'),
    (19, 39, 70, 80.00, 'Lens not focusing', '8 hours', 'done', 'accepted'),
    (20, 40, 69, 50.00, 'No audio in one ear', '6 hours', 'done', 'accepted'),
    (21, 43, 69, 90.00, 'Paper jamming', '10 hours', 'done', 'accepted'),
    (22, 44, 71, 60.00, 'Not recognized by computer', '8 hours', 'done', 'accepted'),
    (23, 47, 71, 70.00, 'Not brewing', '5 hours', 'done', 'accepted'),
    (24, 48, 70, 40.00, 'Fan not working', '3 hours', 'done', 'accepted'),
    (25, 1, 70, 80.00, 'Wobbly structure', '8 hours', 'ongoing', 'accepted'),
    (26, 2, 69, 50.00, 'Torn upholstery', '6 hours', 'abandoned', 'declined'),
    (27, 21, 70, 80.00, 'Motor overheating', '3 hours', 'ongoing', 'accepted'),
    (28, 22, 69, 50.00, 'Not holding charge', '9 hours', 'done', 'accepted'),
    (29, 25, 69, 60.00, 'Measurement not accurate', '8 hours', 'done', 'accepted'),
    (30, 26, 71, 30.00, 'Blade dull', '6 hours', 'done', 'declined'),
    (31, 29, 71, 70.00, 'Sole separation', '9 hours', 'abandoned', 'declined'),
    (32, 30, 70, 40.00, 'Zipper stuck', '7 hours', 'done', 'declined'),
    (33, 33, 70, 80.00, 'Brake issues', '10 hours', 'done', 'accepted'),
    (34, 34, 69, 50.00, 'Cracked deck', '8 hours', 'done', 'declined'),
    (35, 37, 69, 60.00, 'Alarm not sounding', '7 hours', 'done', 'accepted'),
    (36, 38, 71, 30.00, 'Not oscillating', '5 hours', 'done', 'accepted'),
    (37, 41, 71, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting'),
    (38, 42, 70, 40.00, 'Charging issue', '2 hours', 'done', 'declined'),
    (39, 45, 70, 80.00, 'Ports not working', '6 hours', 'done', 'accepted'),
    (40, 46, 69, 50.00, 'Artifacting on display', '4 hours', 'ongoing', 'accepted'),
    (41, 49, 69, 60.00, 'Not heating', '9 hours', 'waiting', 'accepted'),
    (42, 50, 71, 30.00, 'Heating element replacement needed', '7 hours', 'done', 'declined'),
    (43, 3, 71, 70.00, 'Scratched surface', '4 hours', 'ongoing', 'accepted'),
    (44, 4, 70, 40.00, 'Drawer stuck', '2 hours', 'ongoing', 'accepted'),
    (45, 5, 69, 90.00, 'Blade not cutting straight', '7 hours', 'done', 'accepted'),
    (46, 6, 71, 60.00, 'Chuck not gripping', '5 hours', 'done', 'accepted'),
    (47, 9, 71, 70.00, 'Blade not retracting', '4 hours', 'ongoing', 'accepted'),
    (48, 10, 70, 40.00, 'Jaw misalignment', '2 hours', 'ongoing', 'accepted'),
    (49, 13, 70, 80.00, 'Torn stitching', '5 hours', 'ongoing', 'accepted'),
    (50, 14, 69, 50.00, 'Zipper snagging', '3 hours', 'ongoing', 'accepted');
-- TODO: modifier date_created et date_modified

--
-- Technician_reparation insertion
--
-- Technician IDs: 54 to 68
-- Specializations: Electronics, Electrical, Woodworking, Mechanics, Sewing, Miscellaneous

-- Technician ID 54 (Electronics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 1, '2 hours'); -- Laptop reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 2, '1.5 hours'); -- Smartphone reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 3, '2.5 hours'); -- Desktop Computer reparation

-- Technician ID 55 (Electrical specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (55, 5, '1 hour'); -- Vacuum Cleaner reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (55, 6, '1.5 hours'); -- Toaster reparation

-- Technician ID 56 (Woodworking specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (56, 7, '3 hours'); -- Dining Table reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (56, 8, '2 hours'); -- Sofa reparation
-- ...

-- Technician ID 57 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 9, '2 hours'); -- Drill reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 10, '2.5 hours'); -- Circular Saw reparation

-- Technician ID 58 (Sewing specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (58, 13, '1.5 hours'); -- Leather Jacket reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (58, 14, '1 hour'); -- Running Shoes reparation

    -- Technician ID 59 (Miscellaneous specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (59, 17, '2 hours'); -- Watch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (59, 18, '1.5 hours'); -- Bluetooth Speaker reparation

-- Technician ID 60 (Electronics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (60, 19, '3 hours'); -- Digital Camera reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (60, 20, '2 hours'); -- Headphones reparation
-- ...

-- Technician ID 61 (Electrical specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (61, 21, '2.5 hours'); -- Laser Printer reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (61, 22, '2 hours'); -- External Hard Drive reparation

-- Technician ID 62 (Woodworking specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (62, 25, '3.5 hours'); -- Bookshelf reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (62, 26, '2.5 hours'); -- Office Chair reparation

-- Technician ID 63 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (63, 27, '4 hours'); -- Angle Grinder reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (63, 28, '3 hours'); -- Electric Screwdriver reparation

-- Technician ID 64 (Sewing specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (64, 31, '2 hours'); -- Leather Boots reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (64, 32, '1.5 hours'); -- Winter Jacket reparation

-- Technician ID 65 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (65, 33, '3.5 hours'); -- Motorcycle reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (65, 34, '2 hours'); -- Skateboard reparation

-- Technician ID 66 (Electronics specialization)
-- Assuming these technicians also take on Electronics-related tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (66, 37, '2.5 hours'); -- Smartwatch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (66, 38, '2 hours'); -- Bluetooth Earbuds reparation

-- Technician ID 67 (Electrical specialization)
-- Assuming these technicians also take on Electrical-related tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (67, 41, '3 hours'); -- Microwave reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (67, 42, '1.5 hours'); -- Air Purifier reparation

-- Technician ID 68 (Miscellaneous specialization)
-- Assigning miscellaneous tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (68, 35, '2 hours'); -- Alarm Clock reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (68, 36, '2.5 hours'); -- Portable Fan reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (68, 29, '2 hours'); -- Tape Measure reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (68, 30, '1 hour'); -- Hacksaw reparation

-- Looping back to Technician ID 54 (Electronics specialization) for remaining Electronics reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 37, '2 hours'); -- Smartwatch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 38, '1.5 hours'); -- Bluetooth Earbuds reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 39, '3 hours'); -- Laptop Docking Station reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (54, 40, '2.5 hours'); -- Graphics Card reparation

-- Technician ID 55 (Electrical specialization) for remaining Electrical reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (55, 41, '2 hours'); -- Microwave reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (55, 42, '1.5 hours'); -- Air Purifier reparation

-- Technician ID 56 (Woodworking specialization) for remaining Woodworking reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (56, 43, '2 hours'); -- Coffee Table reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (56, 44, '2.5 hours'); -- Office Desk reparation

-- Technician ID 57 (Mechanics specialization) for remaining Mechanics reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 45, '3 hours'); -- Jigsaw reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 46, '2 hours'); -- Impact Driver reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 47, '1.5 hours'); -- Utility Knife reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (57, 48, '2 hours'); -- Adjustable Wrench reparation

-- Technician ID 58 (Sewing specialization) for remaining Sewing reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (58, 49, '2 hours'); -- Winter Gloves reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked) VALUES (58, 50, '1.5 hours'); -- Hiking Backpack reparation


--
-- Specialization_reparation insertion
--
-- For Electronics and Computer category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 1); -- Laptop reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 2); -- Smartphone reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 3); -- Desktop Computer reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 4); -- Tablet reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 19); -- Digital Camera reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 20); -- Headphones reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 21); -- Laser Printer reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 22); -- External Hard Drive reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 37); -- Smartwatch reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 38); -- Bluetooth Earbuds reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 39); -- Laptop Docking Station reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 40); -- Graphics Card reparation
-- For Household category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 5); -- Vacuum Cleaner reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 6); -- Toaster reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 23); -- Coffee Maker reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 24); -- Blender reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 41); -- Microwave reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electricity', 42); -- Air Purifier reparation
-- For Furniture category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 7); -- Dining Table reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 8); -- Sofa reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 25); -- Bookshelf reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 26); -- Office Chair reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 43); -- Coffee Table reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Woodworking', 44); -- Office Desk reparation
-- For Power Tool and Hand Tool category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 9);  -- Drill reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 10); -- Circular Saw reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 11); -- Screwdriver Set reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 12); -- Wrench reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 45); -- Jigsaw reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 46); -- Impact Driver reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 47); -- Utility Knife reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 48); -- Adjustable Wrench reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 27); -- Angle Grinder reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 28); -- Electric Screwdriver reparation
-- For Clothing category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 13); -- Leather Jacket reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 14); -- Running Shoes reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 31); -- Leather Boots reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 32); -- Winter Jacket reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 49); -- Winter Gloves reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Sewing', 50); -- Hiking Backpack reparation
-- For Vehicle category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 15); -- Car reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 16); -- Bicycle reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 33); -- Motorcycle reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Mechanics', 34); -- Skateboard reparation
-- For Miscellaneous category
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 17); -- Watch reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 18); -- Bluetooth Speaker reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 35); -- Alarm Clock reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 36); -- Portable Fan reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 29); -- Tape Measure reparation
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 30); -- Hacksaw reparation
-- Adding some examples where reparations fall into multiple categories
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Electronics', 15); -- Car reparation also requires Electronics specialization
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Painting', 7);  -- Dining Table also requires Woodworking specialization
INSERT INTO specialization_reparation (spec_name, reparation_id) VALUES ('Miscellaneous', 9);   -- Drill reparation also requires Mechanics specialization

--
-- Sms insertion
--
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (1, 'The repair cost for your laptop is CHF 80.00.', '+1234567890', '7509811074', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (1, 'Your quote for the laptop repair has been accepted.', '+1234567890', '7509811074', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (2, 'The repair cost for your smartphone is CHF 50.00.', '+1234567890', '3869329401', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (2, 'Your quote for the smartphone repair has been accepted.', '+1234567890', '3869329401', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (3, 'The repair cost for your desktop computer is CHF 90.00.', '+1234567890', '9333998972', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (3, 'Your quote for the desktop computer repair has been accepted.', '+1234567890', '9333998972', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (4, 'The repair cost for your tablet is CHF 60.00.', '+1234567890', '4153821884', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (4, 'Your quote for the tablet repair has been accepted.', '+1234567890', '4153821884', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (5, 'The repair cost for your vacuum cleaner is CHF 70.00.', '+1234567890', '9289485117', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (5, 'Your quote for the vacuum cleaner repair has been accepted.', '+1234567890', '9289485117', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (6, 'The repair cost for your toaster is CHF 40.00.', '+1234567890', '3748280535', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (6, 'Your quote for the toaster repair has been accepted.', '+1234567890', '3748280535', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (7, 'The repair cost for your dining table is CHF 80.00.', '+1234567890', '1576059000', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (7, 'Your quote for the dining table repair has been accepted.', '+1234567890', '1576059000', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (8, 'The repair cost for your sofa is CHF 50.00.', '+1234567890', '2117079631', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (8, 'Your quote for the sofa repair has been accepted.', '+1234567890', '2117079631', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (9, 'The repair cost for your drill is CHF 90.00.', '+1234567890', '5841556990', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (9, 'Your quote for the drill repair has been accepted.', '+1234567890', '5841556990', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (10, 'The repair cost for your circular saw is CHF 60.00.', '+1234567890', '1554714353', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (10, 'Your quote for the circular saw repair has been declined.', '+1234567890', '1554714353', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (11, 'The repair cost for your screwdriver set is CHF 70.00.', '+1234567890', '1625688540', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (11, 'Your quote for the screwdriver set repair has been accepted.', '+1234567890', '1625688540', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (12, 'The repair cost for your wrench is CHF 40.00.', '+1234567890', '7427338531', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (12, 'Your quote for the wrench repair has been accepted.', '+1234567890', '7427338531', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (13, 'The repair cost for your leather jacket is CHF 80.00.', '+1234567890', '2656777071', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (13, 'OK', '2656777071', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (14, 'The repair cost for your running shoes is CHF 50.00.', '+1234567890', '2252330197', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (14, 'I accept', '2252330197', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (15, 'The repair cost for your car is CHF 90.00.', '+1234567890', '7272619255', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (15, 'OK', '7272619255', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (16, 'The repair cost for your bicycle is CHF 60.00.', '+1234567890', '4961832403', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (16, 'I accept', '4961832403', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (17, 'The repair cost for your watch is CHF 70.00.', '+1234567890', '1911682485', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (17, 'OK', '1911682485', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (18, 'The repair cost for your Bluetooth speaker is CHF 40.00.', '+1234567890', '9425778234', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (18, 'I accept', '9425778234', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (19, 'The repair cost for your digital camera is CHF 80.00.', '+1234567890', '2086601361', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (19, 'OK', '2086601361', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (20, 'The repair cost for your headphones is CHF 50.00.', '+1234567890', '3043025593', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (20, 'I accept', '3043025593', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (21, 'The repair cost for your laser printer is CHF 90.00.', '+1234567890', '6681245302', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (21, 'OK', '6681245302', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (22, 'The repair cost for your external hard drive is CHF 60.00.', '+1234567890', '4041368171', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (22, 'I accept', '4041368171', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (23, 'The repair cost for your coffee maker is CHF 70.00.', '+1234567890', '4582711234', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (23, 'I accept', '4582711234', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (24, 'The repair cost for your blender is CHF 40.00.', '+1234567890', '7214950616', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (24, 'OK', '7214950616', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (25, 'The repair cost for your bookshelf is CHF 80.00.', '+1234567890', '9393204438', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (25, 'I accept', '9393204438', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (26, 'The repair cost for your office chair is CHF 50.00.', '+1234567890', '7788397622', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (26, 'OK', '7788397622', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (27, 'The repair cost for your angle grinder is CHF 80.00.', '+1234567890', '8183530508', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (27, 'I accept', '8183530508', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (28, 'The repair cost for your electric screwdriver is CHF 50.00.', '+1234567890', '3357891471', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (28, 'OK', '3357891471', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (29, 'The repair cost for your tape measure is CHF 60.00.', '+1234567890', '8046789823', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (29, 'I accept', '8046789823', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (30, 'The repair cost for your hacksaw is CHF 30.00.', '+1234567890', '7644258879', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (30, 'OK', '7644258879', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (31, 'The repair cost for your leather boots is CHF 70.00.', '+1234567890', '1086694457', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (31, 'I accept', '1086694457', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (32, 'The repair cost for your winter jacket is CHF 40.00.', '+1234567890', '2356940339', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (32, 'OK', '2356940339', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (33, 'The repair cost for your motorcycle is CHF 80.00.', '+1234567890', '9845978906', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (33, 'I accept', '9845978906', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (34, 'The repair cost for your skateboard is CHF 50.00.', '+1234567890', '9631312077', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (34, 'OK', '9631312077', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (35, 'The repair cost for your alarm clock is CHF 60.00.', '+1234567890', '2507780331', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (35, 'I accept', '2507780331', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (36, 'The repair cost for your portable fan is CHF 30.00.', '+1234567890', '7841546275', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (36, 'OK', '7841546275', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (37, 'The repair cost for your smartwatch is CHF 70.00.', '+1234567890', '6823527703', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (37, 'I accept', '6823527703', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (38, 'The repair cost for your Bluetooth earbuds is CHF 40.00.', '+1234567890', '6789735999', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (38, 'OK', '6789735999', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (39, 'The repair cost for your laptop docking station is CHF 80.00.', '+1234567890', '1849079988', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (39, 'I accept', '1849079988', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (40, 'The repair cost for your graphics card is CHF 50.00.', '+1234567890', '3624483477', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (40, 'OK', '3624483477', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (41, 'The repair cost for your microwave is CHF 60.00.', '+1234567890', '4948737986', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (41, 'I accept', '4948737986', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (42, 'The repair cost for your air purifier is CHF 30.00.', '+1234567890', '5172331839', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (42, 'OK', '5172331839', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (43, 'The repair cost for your coffee table is CHF 70.00.', '+1234567890', '6869372742', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (43, 'I accept', '6869372742', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (44, 'The repair cost for your office desk is CHF 40.00.', '+1234567890', '8949495741', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (44, 'OK', '8949495741', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (45, 'The repair cost for your jigsaw is CHF 90.00.', '+1234567890', '7927615330', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (45, 'I accept', '7927615330', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (46, 'The repair cost for your impact driver is CHF 60.00.', '+1234567890', '1673941666', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (46, 'OK', '1673941666', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (47, 'The repair cost for your utility knife is CHF 70.00.', '+1234567890', '9342736859', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (47, 'I accept', '9342736859', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (48, 'The repair cost for your adjustable wrench is CHF 40.00.', '+1234567890', '3444095541', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (48, 'OK', '3444095541', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (49, 'The repair cost for your winter gloves is CHF 80.00.', '+1234567890', '4406289262', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (49, 'I accept', '4406289262', '+1234567890', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (50, 'The repair cost for your hiking backpack is CHF 50.00.', '+1234567890', '9898594506', 'processed');
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state)
VALUES (50, 'OK', '9898594506', '+1234567890', 'processed');
