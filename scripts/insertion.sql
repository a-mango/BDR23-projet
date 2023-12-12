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
SET search_path TO projet;

--
-- Sale insertion
--
INSERT INTO sale (object_id, price, date_sold)
VALUES 
    (10, 50.00, NULL),
    (30, 120.00, NULL),
    (32, 25.00, NULL),
    (34, 30.00, NULL),
    (38, 200.00, NULL),
    (42, 20.00, NULL);

-- TODO: add some `sold` items ?

-- 69,70,71

--
-- Reparation insertion
--
-- Reparation entries for Power Tool category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (9, 19, 69, 90.00, 'Not turning on', '7 hours', 'waiting', 'waiting'),
    (10, 20, 71, 60.00, 'Blade not cutting properly', '5 hours', 'waiting', 'waiting'),
    (27, 21, 70, 80.00, 'Motor overheating', '3 hours', 'waiting', 'waiting'),
    (28, 22, 69, 50.00, 'Not holding charge', '9 hours', 'waiting', 'waiting'),
    (45, 5, 69, 90.00, 'Blade not cutting straight', '7 hours', 'waiting', 'waiting'),
    (46, 6, 71, 60.00, 'Chuck not gripping', '5 hours', 'waiting', 'waiting');

-- Reparation entries for Hand Tool category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (11, 23, 71, 70.00, 'Handle broken', '4 hours', 'waiting', 'waiting'),
    (12, 24, 70, 40.00, 'Rust on the head', '2 hours', 'waiting', 'waiting'),
    (29, 25, 69, 60.00, 'Measurement not accurate', '8 hours', 'waiting', 'waiting'),
    (30, 26, 71, 30.00, 'Blade dull', '6 hours', 'waiting', 'waiting');

-- Reparation entries for Clothing category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (13, 27, 70, 80.00, 'Zipper not working', '5 hours', 'waiting', 'waiting'),
    (14, 28, 69, 50.00, 'Sole worn out', '3 hours', 'waiting', 'waiting'),
    (31, 29, 71, 70.00, 'Sole separation', '9 hours', 'waiting', 'waiting'),
    (32, 30, 70, 40.00, 'Zipper stuck', '7 hours', 'waiting', 'waiting');

-- Reparation entries for Vehicle category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (15, 31, 69, 90.00, 'Engine not starting', '6 hours', 'waiting', 'waiting'),
    (16, 32, 71, 60.00, 'Flat tire', '4 hours', 'waiting', 'waiting'),
    (33, 33, 70, 80.00, 'Brake issues', '10 hours', 'waiting', 'waiting'),
    (34, 34, 69, 50.00, 'Cracked deck', '8 hours', 'waiting', 'waiting');

-- Reparation entries for Miscellaneous category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (17, 35, 71, 70.00, 'Stopped ticking', '3 hours', 'waiting', 'waiting'),
    (18, 36, 70, 40.00, 'No sound output', '9 hours', 'waiting', 'waiting'),
    (35, 37, 69, 60.00, 'Alarm not sounding', '7 hours', 'waiting', 'waiting'),
    (36, 38, 71, 30.00, 'Not oscillating', '5 hours', 'waiting', 'waiting');

-- Reparation entries for Electronics category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (19, 39, 70, 80.00, 'Lens not focusing', '8 hours', 'waiting', 'waiting'),
    (20, 40, 69, 50.00, 'No audio in one ear', '6 hours', 'waiting', 'waiting'),
    (37, 41, 71, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting'),
    (38, 42, 70, 40.00, 'Charging issue', '2 hours', 'waiting', 'waiting');

-- Reparation entries for Computer category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (21, 43, 69, 90.00, 'Paper jamming', '10 hours', 'waiting', 'waiting'),
    (22, 44, 71, 60.00, 'Not recognized by computer', '8 hours', 'waiting', 'waiting'),
    (39, 45, 70, 80.00, 'Ports not working', '6 hours', 'waiting', 'waiting'),
    (40, 46, 69, 50.00, 'Artifacting on display', '4 hours', 'waiting', 'waiting');

-- Reparation entries for Household category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (23, 47, 71, 70.00, 'Not brewing', '5 hours', 'waiting', 'waiting'),
    (24, 48, 70, 40.00, 'Fan not working', '3 hours', 'waiting', 'waiting'),
    (41, 49, 69, 60.00, 'Not heating', '9 hours', 'waiting', 'waiting'),
    (42, 50, 71, 30.00, 'Heating element replacement needed', '7 hours', 'waiting', 'waiting');

-- Reparation entries for Furniture category
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state, quote_state)
VALUES
    (25, 1, 70, 80.00, 'Wobbly structure', '8 hours', 'waiting', 'waiting'),
    (26, 2, 69, 50.00, 'Torn upholstery', '6 hours', 'waiting', 'waiting'),
    (43, 3, 71, 70.00, 'Scratched surface', '4 hours', 'waiting', 'waiting'),
    (44, 4, 70, 40.00, 'Drawer stuck', '2 hours', 'waiting', 'waiting');
