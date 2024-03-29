DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
COMMENT ON SCHEMA projet IS 'Projet de semestre BDR';

SET search_path = projet;

--
-- Enumerations
--
CREATE TYPE reparation_state AS ENUM ('waiting', 'ongoing', 'done', 'abandoned');
CREATE TYPE quote_state AS ENUM ('accepted', 'declined', 'waiting');
CREATE TYPE location AS ENUM ('in_stock', 'for_sale', 'returned', 'sold');
CREATE TYPE processing_state AS ENUM ('received', 'read', 'processed');

--
-- Table `person`
--
CREATE TABLE person
(
    person_id SERIAL PRIMARY KEY,
    name      VARCHAR(128) NOT NULL,
    phone_no  VARCHAR(11)  NOT NULL UNIQUE CHECK (phone_no ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    comment   TEXT
);

--
-- Table `customer`
--
CREATE TABLE customer
(
    customer_id  INT PRIMARY KEY REFERENCES person (person_id) ON UPDATE CASCADE ON DELETE CASCADE,
    tos_accepted BOOLEAN NOT NULL DEFAULT FALSE,
    private_note TEXT
);

--
-- Table `collaborator`
--
CREATE TABLE collaborator
(
    collaborator_id INT PRIMARY KEY REFERENCES person (person_id) ON UPDATE CASCADE ON DELETE CASCADE,
    email           VARCHAR(128) NOT NULL UNIQUE CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

--
-- Table `manager`
--
CREATE TABLE manager
(
    manager_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE CASCADE
);

--
-- Table `technician`
--
CREATE TABLE technician
(
    technician_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE CASCADE
);

--
-- Table `receptionist`
--
CREATE TABLE receptionist
(
    receptionist_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE CASCADE
);

--
-- Table `language`
--
CREATE TABLE language
(
    name VARCHAR(32) PRIMARY KEY
);

--
-- Table `receptionist_language`
--
CREATE TABLE receptionist_language
(
    receptionist_id INT REFERENCES receptionist (receptionist_id) ON UPDATE CASCADE ON DELETE CASCADE,
    language        VARCHAR(32) REFERENCES language (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (receptionist_id, language)
);

--
-- Table `specialization`
--
CREATE TABLE specialization
(
    name VARCHAR(64) PRIMARY KEY
);

--
-- Table `technician_specialization`
--
CREATE TABLE technician_specialization
(
    technician_id INT REFERENCES technician (technician_id) ON UPDATE CASCADE ON DELETE CASCADE,
    spec_name     VARCHAR(64) REFERENCES specialization (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (technician_id, spec_name)
);

--
-- Table `brand`
--
CREATE TABLE brand
(
    name VARCHAR(128) PRIMARY KEY
);

--
-- Table `category`
--
CREATE TABLE category
(
    name VARCHAR(128) PRIMARY KEY
);

--
-- Table `object`
--
CREATE TABLE object
(
    object_id   SERIAL PRIMARY KEY,
    customer_id INT          REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE SET NULL,
    name        VARCHAR(128) NOT NULL,
    fault_desc  TEXT         NOT NULL,
    location    location     NOT NULL DEFAULT 'in_stock'::location,
    remark      TEXT,
    serial_no   VARCHAR(128),
    brand       VARCHAR(128) REFERENCES brand (name) ON UPDATE CASCADE ON DELETE SET NULL,
    category    VARCHAR(128) NOT NULL REFERENCES category (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

--
-- Table `sale`
--
CREATE TABLE sale
(
    object_id    INT REFERENCES object (object_id) ON UPDATE CASCADE ON DELETE CASCADE,
    id_sale      SERIAL         NOT NULL,
    price        NUMERIC(10, 2) NOT NULL,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    date_sold    TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    PRIMARY KEY (object_id, id_sale)
);

--
-- Table `reparation`
--
CREATE TABLE reparation
(
    reparation_id      SERIAL PRIMARY KEY,
    object_id          INT UNIQUE               NOT NULL REFERENCES object (object_id) ON UPDATE CASCADE ON DELETE CASCADE,
    customer_id        INT                      REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE SET NULL,
    receptionist_id    INT                      REFERENCES receptionist (receptionist_id) ON UPDATE CASCADE ON DELETE SET NULL,
    date_created       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    date_modified      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    quote              NUMERIC(10, 2),
    description        TEXT                     NOT NULL,
    estimated_duration INTERVAL                 NOT NULL,
    reparation_state   reparation_state         NOT NULL DEFAULT 'waiting'::reparation_state,
    quote_state        quote_state              NOT NULL DEFAULT 'waiting'::quote_state
);

--
-- Table `technician_reparation`
--
CREATE TABLE technician_reparation
(
    technician_id INT REFERENCES technician (technician_id) ON UPDATE CASCADE ON DELETE CASCADE,
    reparation_id INT REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE CASCADE,
    time_worked   INTERVAL,
    PRIMARY KEY (technician_id, reparation_id)
);

--
-- Table `specialization_reparation`
--
CREATE TABLE specialization_reparation
(
    spec_name     VARCHAR(64) REFERENCES specialization (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    reparation_id INT REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (spec_name, reparation_id)
);

--
-- Table `sms`
--
CREATE TABLE sms
(
    sms_id           SERIAL PRIMARY KEY,
    reparation_id    INT              NOT NULL REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE CASCADE,
    date_created     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    message          TEXT             NOT NULL,
    sender           VARCHAR(128)     NOT NULL CHECK (sender ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    receiver         VARCHAR(128)     NOT NULL CHECK (receiver ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    processing_state processing_state NOT NULL DEFAULT 'received'::processing_state
);--
-- Triggers
--

-- When reparation table is updated, reparation.date_modified is updated

-- Function to update the date to current date
CREATE OR REPLACE FUNCTION date_updated()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.date_modified = NOW();
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_reparation_update_update_date
    BEFORE UPDATE
    ON reparation
    FOR EACH ROW
EXECUTE FUNCTION date_updated();

-- When there is an insertion on sale table, check that reparation.quote_state is 'declined'
CREATE OR REPLACE FUNCTION quote_state_is_declined()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT id_sale
        FROM reparation r
                 JOIN object o ON r.object_id = o.object_id
                 JOIN sale s ON o.object_id = s.object_id
        WHERE s.id_sale = NEW.id_sale
          AND r.quote_state <> 'declined')
    THEN
        RAISE EXCEPTION 'quote_state must be "declined"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined_for_reparation
    BEFORE INSERT
    ON sale
    FOR EACH ROW
EXECUTE FUNCTION quote_state_is_declined();

-- When object.location is updated into 'for_sale' or 'sold',  check that quote_state is 'declined'
CREATE OR REPLACE FUNCTION quote_state_is_declined_for_object()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.location IN ('for_sale', 'sold')
        AND NOT EXISTS (SELECT *
                        FROM reparation r
                                 JOIN object o ON r.object_id = o.object_id
                        WHERE o.object_id = NEW.object_id
                          AND r.quote_state <> 'declined')
    THEN
        RAISE EXCEPTION 'quote_state must be "declined"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined_for_object
    BEFORE UPDATE OF location
    ON object
    FOR EACH ROW
EXECUTE FUNCTION quote_state_is_declined_for_object();

-- When reparation.reparation_state is updated into 'ongoing' or 'done', check that quote_state is 'accepted'
CREATE OR REPLACE FUNCTION quote_state_is_accepted()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.reparation_state IN ('ongoing', 'done')
        AND OLD.quote_state <> 'accepted'
    THEN
        RAISE EXCEPTION 'quote_state must be "accepted"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_accepted
    BEFORE UPDATE OF reparation_state
    ON reparation
    FOR EACH ROW
EXECUTE FUNCTION quote_state_is_accepted();

-- When there is an insertion on reparation table, check that customer.tos_accepted is 'accepted'
CREATE OR REPLACE FUNCTION tos_accepted()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT c.customer_id
        FROM customer c
                 JOIN reparation r ON c.customer_id = r.customer_id
        WHERE r.reparation_id = NEW.reparation_id
          AND c.tos_accepted <> TRUE)
    THEN
        RAISE EXCEPTION 'The tos must be accepted.';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_tos_accepted
    BEFORE INSERT
    ON reparation
    FOR EACH ROW
EXECUTE FUNCTION tos_accepted();

-- When reparation.quote_state is updated to 'accepted', reparation.reparation_state becomes 'ongoing'
CREATE OR REPLACE FUNCTION reservation_state_ongoing()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.reparation_state = 'ongoing';
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_reservation_state_ongoing
    BEFORE UPDATE OF quote_state
    ON reparation
    FOR EACH ROW
EXECUTE FUNCTION reservation_state_ongoing();

-- When a row is inserted in receptionist_language with a language that is not yet present in the language table,
-- the new language is added to the table
CREATE OR REPLACE FUNCTION insert_language_if_not_exists()
    RETURNS TRIGGER AS
$$
BEGIN

    IF NOT EXISTS (SELECT 1 FROM language WHERE name = NEW.language) THEN
        INSERT INTO language(name) VALUES (NEW.language);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER before_insert_receptionist_language
BEFORE INSERT ON receptionist_language
FOR EACH ROW
EXECUTE FUNCTION insert_language_if_not_exists();

-- Update person and collaborator when there is an update on collab_info_view
CREATE OR REPLACE FUNCTION update_collaborator_person() RETURNS TRIGGER AS $$
BEGIN
    -- Update person table
    UPDATE person
    SET name = NEW.name, phone_no = NEW.phone_no, comment = NEW.comment
    WHERE person_id = NEW.collaborator_id;

    -- Update collaborator table
    UPDATE collaborator
    SET email = NEW.email
    WHERE collaborator_id = NEW.collaborator_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_collaborator_person_trigger
    INSTEAD OF UPDATE ON collab_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person and collaborator when there is an insert on collab_info_view
CREATE OR REPLACE FUNCTION update_collaborator_person_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertCollaborator(NEW.name, NEW.phone_no, NEW.comment, NEW.email, NEW.collaborator_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_collaborator_person_trigger_on_insert
    INSTEAD OF INSERT ON collab_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person_on_insert();

-- Delete person and collaborator when there is an delete on collab_info_view
CREATE OR REPLACE FUNCTION delete_collaborator_person_on_delete() RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM person
    WHERE person_id = OLD.collaborator_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_collaborator_person_trigger_on_delete
    INSTEAD OF DELETE ON collab_info_view
    FOR EACH ROW EXECUTE PROCEDURE delete_collaborator_person_on_delete();

-- Update Person and Customer when there is an update on customer_info_view
CREATE OR REPLACE FUNCTION update_customer_person() RETURNS TRIGGER AS $$
BEGIN
    -- Update person table
    UPDATE person
    SET name = NEW.name, phone_no = NEW.phone_no, comment = NEW.comment
    WHERE person_id = NEW.customer_id;

    -- Update customer table
    UPDATE customer
    SET tos_accepted = NEW.tos_accepted, private_note = NEW.private_note
    WHERE customer_id = NEW.customer_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_customer_person_trigger
    INSTEAD OF UPDATE ON customer_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_customer_person();

-- Update Person and Customer when there is an insert on customer_info_view
CREATE OR REPLACE FUNCTION update_customer_person_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertCustomer(NEW.Name, NEW.phone_no, NEW.comment, NEW.tos_accepted, NEW.private_note);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_customer_person_trigger_on_insert
    INSTEAD OF INSERT ON customer_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_customer_person_on_insert();

-- Delete person and customer when there is an delete on customer_info_view
CREATE OR REPLACE FUNCTION delete_customer_person_on_delete() RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM person
    WHERE person_id = OLD.customer_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_customer_person_trigger_on_delete
    INSTEAD OF DELETE ON customer_info_view
    FOR EACH ROW EXECUTE PROCEDURE delete_customer_person_on_delete();


-- Update person, collaborator and receptionist when receptionist_info_view is updated
CREATE OR REPLACE TRIGGER update_collaborator_person_receptionist_trigger
    INSTEAD OF UPDATE ON receptionist_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person, collaborator and receptionist when there is an insert on receptionist_info_view
CREATE OR REPLACE FUNCTION update_collaborator_person_receptionist_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL createReceptionist(NEW.name, NEW.phone_no, NEW.comment, NEW.email, NEW.languages);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_collaborator_person_receptionist_trigger_on_insert
    INSTEAD OF INSERT ON receptionist_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person_receptionist_on_insert();

-- Delete person and receptionist when there is an delete on receptionist_info_view
CREATE OR REPLACE FUNCTION delete_receptionist_person_on_delete() RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM person
    WHERE person_id = OLD.receptionist_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_receptionist_person_trigger_on_delete
    INSTEAD OF DELETE ON receptionist_info_view
    FOR EACH ROW EXECUTE PROCEDURE delete_receptionist_person_on_delete();


-- Update person, collaborator and technician when technician_info_view is updated
CREATE OR REPLACE TRIGGER update_collaborator_person_technician_trigger
    INSTEAD OF UPDATE ON technician_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person, collaborator and technician when there is an insert on technician_info_view
CREATE OR REPLACE FUNCTION update_collaborator_person_technician_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertTechnician(NEW.name, NEW.phone_no, NEW.comment, NEW.email);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_collaborator_person_technician_trigger_on_insert
    INSTEAD OF INSERT ON technician_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person_technician_on_insert();

-- Delete person and technician when there is an delete on technician_info_view
CREATE OR REPLACE FUNCTION delete_technician_person_on_delete() RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM person
    WHERE person_id = OLD.technician_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_technician_person_trigger_on_delete
    INSTEAD OF DELETE ON technician_info_view
    FOR EACH ROW EXECUTE PROCEDURE delete_technician_person_on_delete();


-- Update person, collaborator and manager when manager_info_view is updated
CREATE OR REPLACE TRIGGER update_collaborator_person_manager_trigger
    INSTEAD OF UPDATE ON manager_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person, collaborator and manager when there is an insert on manager_info_view
CREATE OR REPLACE FUNCTION update_collaborator_person_manager_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertManager(NEW.name, NEW.phone_no, NEW.comment, NEW.email);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_collaborator_person_manager_trigger_on_insert
    INSTEAD OF INSERT ON manager_info_view
    FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person_manager_on_insert();

-- Delete person and manager when there is an delete on manager_info_view
CREATE OR REPLACE FUNCTION delete_manager_person_on_delete() RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM person
    WHERE person_id = OLD.manager_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_manager_person_trigger_on_delete
    INSTEAD OF DELETE ON manager_info_view
    FOR EACH ROW EXECUTE PROCEDURE delete_manager_person_on_delete();
SET search_path TO projet;

-- Create a new person
CREATE OR REPLACE PROCEDURE projet.InsertPerson(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- Insert into Person and get the new ID
    INSERT INTO projet.person (name, phone_no, comment)
    VALUES (_name, _phone_no, _comment)
    RETURNING person_id INTO _new_id;
END;
$$;

-- Create a new Person and Customer in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertCustomer(
    IN _name VARCHAR,
    IN _phone_no VARCHAR,
    IN _comment TEXT,
    IN _tos_accepted BOOLEAN,
    IN _private_note TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_person_id INTEGER := 0;
BEGIN
    -- Insert into Person and get the new ID
    CALL projet.InsertPerson(_name, _phone_no, _comment, new_person_id);

    -- Insert into Customer using the new Person ID
    INSERT INTO projet.customer (customer_id, tos_accepted, private_note)
    VALUES (new_person_id, _tos_accepted, _private_note)
    RETURNING customer_id INTO _new_id;
END;
$$;

-- Create a new Person and Collaborator in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertCollaborator(
    IN _name VARCHAR,
    IN _phone_no VARCHAR,
    IN _comment TEXT,
    IN _email TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_person_id INTEGER := 0;
BEGIN
    -- Insert into Person and get the new ID
    CALL projet.InsertPerson(_name, _phone_no, _comment, new_person_id);

    -- Insert into Collaborator using the new Person ID
    INSERT INTO projet.collaborator (collaborator_id, email)
    VALUES (new_person_id, _email)
    RETURNING collaborator_id INTO _new_id;
END;
$$;

-- Create a new Person, Collaborator and Manager in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertManager(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER := 0;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Manager using the new Person ID
    INSERT INTO projet.manager (manager_id)
    VALUES (new_person_id)
    RETURNING manager_id INTO _new_id;
END;
$$;

-- Create a new Person, Collaborator and Receptionist in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertReceptionist(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER := 0;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Receptionist using the new Person ID
    INSERT INTO projet.receptionist (receptionist_id)
    VALUES (new_person_id)
    RETURNING receptionist_id INTO _new_id;

END;
$$;

-- Create a new Person, Collaborator, Receptionist and language into receptionist_language in one transaction
CREATE OR REPLACE PROCEDURE createReceptionist(
    IN _name VARCHAR(128),
    IN _phone_no VARCHAR(11),
    IN _comment TEXT,
    IN _email VARCHAR(128),
    IN _languages VARCHAR(32)[],
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS $$
BEGIN

    CALL projet.InsertReceptionist(_name, _phone_no, _comment, _email, _new_id);

    -- Insert languages into receptionist_language table
    FOR j IN 1..array_length(_languages, 1)
        LOOP
            INSERT INTO receptionist_language(receptionist_id, language)
            VALUES (_new_id, _languages[j]);
        END LOOP;
END;
$$;

-- Update a new Person, Collaborator, Receptionist and language into receptionist_language in one transaction
CREATE OR REPLACE PROCEDURE updateReceptionist(
    IN in_receptionist_id INT,
    IN in_name VARCHAR(128),
    IN in_phone_no VARCHAR(11),
    IN in_comment TEXT,
    IN in_email VARCHAR(128),
    IN in_new_languages VARCHAR(32)[],  -- New array of languages
    IN in_current_languages VARCHAR(32)[]  -- Current array of languages
)
    LANGUAGE plpgsql
AS $$
BEGIN
    -- Update person table
    UPDATE person
    SET name = in_name, phone_no = in_phone_no, comment = in_comment
    WHERE person_id = in_receptionist_id;

    -- Update collaborator table
    UPDATE collaborator
    SET email = in_email
    WHERE collaborator_id = in_receptionist_id;

    -- Delete old languages that aren't in new languages
    DELETE FROM receptionist_language
    WHERE receptionist_id = in_receptionist_id AND language = ANY(in_current_languages)
      AND language NOT IN (SELECT * FROM UNNEST(in_new_languages));

    -- Add new languages that aren't in old languages
    INSERT INTO receptionist_language(receptionist_id, language)
    SELECT in_receptionist_id, lang
    FROM UNNEST(in_new_languages) AS lang
    WHERE lang NOT IN (SELECT language FROM receptionist_language WHERE receptionist_id = in_receptionist_id);
END;
$$;

-- Create a new Person, Collaborator and Technician in one transaction
CREATE OR REPLACE PROCEDURE projet.InsertTechnician(
    _name VARCHAR,
    _phone_no VARCHAR,
    _comment TEXT,
    _email TEXT,
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS $$
DECLARE
    new_person_id INTEGER := 0;
BEGIN
    -- Insert into a Collaborator and get the new ID
    CALL projet.InsertCollaborator(_name, _phone_no, _comment, _email, new_person_id);

    -- Insert into Technician using the new Person ID
    INSERT INTO projet.technician (technician_id)
    VALUES (new_person_id)
    RETURNING technician_id INTO _new_id;
END;
$$;


-- Create a new Reparation and Object in one transaction

CREATE OR REPLACE PROCEDURE create_reparation(
    IN in_quote INT,
    IN in_repair_description TEXT,
    IN in_estimated_duration INTERVAL,
    IN in_receptionist_id INT,
    IN in_customer_id INT,
    IN in_object_name VARCHAR(128),
    IN in_fault_description TEXT,
    IN in_remark TEXT,
    IN in_serial_no VARCHAR(128),
    IN in_brand_name VARCHAR(128),
    IN in_category_name VARCHAR(128),
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_object_id INT;
BEGIN
    -- Insert into object table
    INSERT INTO object(name, fault_desc, remark, serial_no, brand, category, customer_id)
    VALUES (in_object_name, in_fault_description, in_remark, in_serial_no, in_brand_name,
            in_category_name, in_customer_id)
    RETURNING object_id INTO new_object_id;

    -- Insert into reparation table
    INSERT INTO reparation(quote, description, estimated_duration, receptionist_id, customer_id, object_id)
    VALUES (in_quote, in_repair_description, in_estimated_duration, in_receptionist_id, in_customer_id, new_object_id)
    RETURNING reparation_id INTO _new_id;
END;
$$;SET search_path TO projet;

--
-- Customer insertion
-- Returns IDs 1 to 50
--
CALL InsertCustomer('Jeffrey Dayne', '7509811074', 'Vivamus vel nulla eget eros elementum pellentesque.', TRUE, NULL, NULL);
CALL InsertCustomer('Barris Dugue', '3869329401', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Davey O'' Liddy', '9333998972', 'Nam tristique tortor eu pede.', TRUE, NULL, NULL);
CALL InsertCustomer('Jamaal Eaglestone', '4153821884', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Shaw Hurich', '9289485117', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Shari Huniwall', '3748280535', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Alvin Binch', '1576059000', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Kordula Goulter', '2117079631', 'Vivamus vel nulla eget eros elementum pellentesque.', TRUE, NULL,
                    'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', NULL);
CALL InsertCustomer('Daphne Roly', '5841556990', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Francisca Bouldon', '1554714353', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Heidie Saenz', '1625688540', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Marabel Lilleman', '7427338531', 'Nam nulla.', TRUE, NULL, NULL);
CALL InsertCustomer('Karine Clarey', '2656777071', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Ursuline Macari', '2252330197', NULL, TRUE, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', NULL);
CALL InsertCustomer('Jordanna Andrejs', '7272619255', NULL, TRUE, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', NULL);
CALL InsertCustomer('Dario Hardeman', '4961832403', NULL, TRUE, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', NULL);
CALL InsertCustomer('Kipp O''Shirine', '1911682485', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Cosmo Tortice', '9425778234', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Rodney Dagger', '2086601361', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Marilee Greenroad', '3043025593', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Brigham Lathey', '6681245302', 'Nulla ut erat id mauris vulputate elementum.', TRUE, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', NULL);
CALL InsertCustomer('Ronnie Gearing', '4041368171', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Garvy Ruit', '4582711234', 'Duis ac nibh.', TRUE, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', NULL);
CALL InsertCustomer('Kathryne Scarasbrick', '7214950616', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Karin Tedorenko', '9393204438', 'In congue.', TRUE, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', NULL);
CALL InsertCustomer('Goldy Stigers', '7788397622', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Stefania Collihole', '8183530508', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Chance Kirwin', '3357891471', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Truda Raybould', '8046789823', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Rubetta Boffin', '7644258879', NULL, TRUE, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', NULL);
CALL InsertCustomer('Jeffy Hopfer', '1086694457', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Aggy Lee', '2356940339', NULL, TRUE,
                    'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',
                    NULL);
CALL InsertCustomer('Torie Caskie', '9845978906', NULL, TRUE, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', NULL);
CALL InsertCustomer('Magdaia Capelin', '9631312077', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Wylma Scamwell', '2507780331', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Gwendolen Boulstridge', '7841546275', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Jethro Kilfedder', '6823527703', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Orlando Brackenbury', '6789735999', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Torey Bolliver', '1849079988', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Natala Gaitung', '3624483477', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Ramon Spurdle', '4948737986', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Brien Walklott', '5172331839', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Martie Reilly', '6869372742', NULL, TRUE, 'Aenean sit amet justo.', NULL);
CALL InsertCustomer('Joelle Mishaw', '8949495741', NULL, TRUE, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', NULL);
CALL InsertCustomer('Isahella Caplen', '7927615330', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Ugo St. Queintain', '1673941666', NULL, TRUE, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', NULL);
CALL InsertCustomer('Drew Bircher', '9342736859', NULL, TRUE, NULL, NULL);
CALL InsertCustomer('Lotta Ellaman', '3444095541', NULL, TRUE, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', NULL);
CALL InsertCustomer('Aryn Santos', '4406289262', NULL, TRUE, 'Morbi a ipsum. Integer a nibh.', NULL);
CALL InsertCustomer('Zane Entissle', '9898594506', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', TRUE, NULL, NULL);
CALL InsertCustomer('Jane Doe', '1238594506', '', TRUE, NULL, NULL);

--
-- Manager insertion
-- Returns IDs 51 to 53
--
CALL projet.InsertManager('Hugues Marshman', '5827558909', NULL, 'hmarshman0@list-manage.com', NULL);
CALL projet.InsertManager('Melanie O''Rourke', '8549739202', NULL, 'morourke1@addtoany.com', NULL);
CALL projet.InsertManager('Julius Wasielewicz', '8921298385', NULL, 'jwasielewicz2@51.la', NULL);

--
-- Technician insertion
-- Returns IDs 54 to 68
--
CALL InsertTechnician('Alphonso Kerrich', '9949134373', 'Aliquam sit amet diam in magna bibendum imperdiet.',
                      'akerrich0@dion.ne.jp', NULL); -- 54
CALL InsertTechnician('Andrea Millhill', '7833355818', 'Nulla mollis molestie lorem.', 'amillhill1@prnewswire.com', NULL);
CALL InsertTechnician('Angeline Archard', '1497749196', NULL, 'aarchard2@desdev.cn', NULL);
CALL InsertTechnician('Reg Willers', '6988015614', NULL, 'rwillers3@wikipedia.org', NULL);
CALL InsertTechnician('Olva Tollit', '6332366308', NULL, 'otollit4@adobe.com', NULL);
CALL InsertTechnician('Templeton Nortcliffe', '7481454963', NULL, 'tnortcliffe5@ibm.com', NULL);
CALL InsertTechnician('Alanna Weatherby', '4409610170', NULL, 'aweatherby6@addthis.com', NULL);
CALL InsertTechnician('Magdaia Egger', '5347026159', NULL, 'megger7@chronoengine.com', NULL);
CALL InsertTechnician('Lynnette Bance', '9454171346', NULL, 'lbance8@miibeian.gov.cn', NULL);
CALL InsertTechnician('Temp Bendtsen', '3566687660', 'In hac habitasse platea dictumst.', 'tbendtsen9@yahoo.com', NULL);
CALL InsertTechnician('Lyndell McDougal', '3173129088', 'Fusce posuere felis sed lacus.', 'lmcdougala@myspace.com', NULL);
CALL InsertTechnician('Kaila Haythorne', '5741093584', NULL, 'khaythorneb@hibu.com', NULL);
CALL InsertTechnician('Oliver Schroeder', '1145980270', NULL, 'oschroederc@cyberchimps.com', NULL);
CALL InsertTechnician('Germana Leal', '6738563042', NULL, 'gleald@technorati.com', NULL);
CALL InsertTechnician('Ebba Lerer', '1371807550', NULL, 'elerere@netvibes.com', NULL);

--
-- Receptionist insertion
-- Returns IDs 69 to 71
--
CALL InsertReceptionist('Alic Klagges', '1167567619', NULL, 'aklagges0@shop-pro.jp', NULL); -- 69
CALL InsertReceptionist('Celestyn Deeth', '8254514158', 'Quisque ut erat.', 'cdeeth1@nydailynews.com', NULL); -- 70
CALL InsertReceptionist('Courtney Coventry', '1103928379', NULL, 'ccoventry2@alexa.com', NULL);
-- 71

--
-- Language insertion
--
INSERT INTO language (name)
VALUES ('English'),
       ('French'),
       ('Spanish'),
       ('German'),
       ('Italian'),
       ('Portuguese');

--
-- Receptionist_language insertion
--
INSERT INTO receptionist_language (receptionist_id, language)
VALUES (69, 'English'),
       (69, 'French'),
       (69, 'Spanish'),
       (70, 'English'),
       (70, 'French'),
       (70, 'Italian'),
       (71, 'English'),
       (71, 'French'),
       (71, 'Portuguese'),
       (71, 'German');

--
-- Specialization insertion
--
INSERT INTO specialization (name)
VALUES ('Electronics'),
       ('Plumbing'),
       ('Woodworking'),
       ('Microelectronics'),
       ('Miscellaneous'),
       ('Refrigeration'),
       ('Locksmith'),
       ('Mechanics'),
       ('Electricity'),
       ('Sewing'),
       ('Painting'),
       ('Stonecutting');

--
-- Technician_specialization insertion
--
INSERT INTO technician_specialization (technician_id, spec_name)
VALUES (54, 'Electronics'),
       (54, 'Plumbing'),
       (54, 'Woodworking'),
       (55, 'Microelectronics'),
       (55, 'Miscellaneous'),
       (55, 'Refrigeration'),
       (56, 'Locksmith'),
       (56, 'Mechanics'),
       (56, 'Electricity'),
       (57, 'Sewing'),
       (57, 'Painting'),
       (57, 'Stonecutting'),
       (58, 'Electronics'),
       (58, 'Plumbing'),
       (58, 'Woodworking'),
       (59, 'Microelectronics'),
       (59, 'Miscellaneous'),
       (59, 'Refrigeration'),
       (60, 'Locksmith'),
       (60, 'Mechanics'),
       (60, 'Electricity'),
       (61, 'Sewing'),
       (61, 'Painting'),
       (61, 'Stonecutting'),
       (61, 'Electronics'),
       (61, 'Plumbing'),
       (61, 'Woodworking'),
       (62, 'Microelectronics'),
       (62, 'Miscellaneous'),
       (62, 'Refrigeration'),
       (63, 'Locksmith'),
       (63, 'Mechanics'),
       (63, 'Electricity'),
       (64, 'Sewing'),
       (64, 'Painting'),
       (64, 'Stonecutting'),
       (65, 'Electronics'),
       (65, 'Plumbing'),
       (65, 'Woodworking'),
       (66, 'Microelectronics'),
       (66, 'Miscellaneous'),
       (66, 'Refrigeration'),
       (67, 'Locksmith'),
       (67, 'Mechanics'),
       (67, 'Electricity');

--
-- Brand insertion
--
INSERT INTO brand (name)
VALUES ('Apeul'),
       ('Bousch'),
       ('Jurah'),
       ('Karscheur'),
       ('Brown'),
       ('Samsong'),
       ('Sanyo'),
       ('Sanyu'),
       ('Toshibu'),
       ('Aipad'),
       ('Deel');

--
-- Category insertion
--
INSERT INTO category (name)
VALUES ('Electronics'),
       ('Computer'),
       ('Household'),
       ('Furniture'),
       ('Power Tool'),
       ('Hand Tool'),
       ('Clothing'),
       ('Vehicle'),
       ('Miscellaneous');

--
-- Object insertion
--
INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
VALUES (1, 'Laptop', 'Not powering on', 'in_stock', 'Needs urgent repair', 'SN123456', 'Apeul', 'Electronics'),
       (2, 'Smartphone', 'Cracked screen', 'returned', 'Screen replacement needed', 'SN789012', 'Bousch',
        'Electronics'),
       (3, 'Desktop Computer', 'Slow performance', 'returned', 'Software optimization required', 'SN345678', 'Jurah',
        'Computer'),
       (4, 'Tablet', 'Battery not holding charge', 'returned', 'Battery replacement needed', 'SN901234', 'Karscheur',
        'Computer'),
       (5, 'Vacuum Cleaner', 'Not picking up dirt', 'returned', 'Motor replacement required', 'SN567890', 'Brown',
        'Household'),
       (6, 'Toaster', 'Not toasting evenly', 'returned', 'Heating element needs replacement', 'SN123789', 'Samsong',
        'Household'),
       (7, 'Dining Table', 'Broken leg', 'returned', 'Leg repair needed', 'SN456012', 'Sanyo', 'Furniture'),
       (8, 'Sofa', 'Torn upholstery', 'in_stock', 'Upholstery replacement required', 'SN890123', 'Sanyu', 'Furniture'),
       (9, 'Drill', 'Not turning on', 'returned', 'Power switch replacement needed', 'SN012345', 'Toshibu',
        'Power Tool'),
       (10, 'Circular Saw', 'Blade not cutting properly', 'for_sale', 'Blade sharpening required', 'SN567890', 'Aipad',
        'Power Tool'),
       (11, 'Screwdriver Set', 'Handle broken', 'returned', 'Handle replacement needed', 'SN123789', 'Deel',
        'Hand Tool'),
       (12, 'Wrench', 'Rust on the head', 'returned', 'Head cleaning and rust removal required', 'SN456012', 'Aipad',
        'Hand Tool'),
       (13, 'Leather Jacket', 'Zipper not working', 'in_stock', 'Zipper replacement needed', 'SN890123', 'Deel',
        'Clothing'),
       (14, 'Running Shoes', 'Sole worn out', 'returned', 'Sole replacement required', 'SN012345', 'Bousch',
        'Clothing'),
       (15, 'Car', 'Engine not starting', 'in_stock', 'Engine repair needed', 'SN567890', 'Jurah', 'Vehicle'),
       (16, 'Bicycle', 'Flat tire', 'returned', 'Tire replacement required', 'SN123789', 'Karscheur', 'Vehicle'),
       (17, 'Watch', 'Stopped ticking', 'returned', 'Battery replacement needed', 'SN456012', 'Brown', 'Miscellaneous'),
       (18, 'Bluetooth Speaker', 'No sound output', 'in_stock', 'Speaker repair needed', 'SN890123', 'Samsong',
        'Miscellaneous'),
       (19, 'Digital Camera', 'Lens not focusing', 'returned', 'Lens adjustment needed', NULL, 'Apeul', 'Electronics'),
       (20, 'Headphones', 'No audio in one ear', 'returned', 'Audio cable replacement needed', 'SN901234', 'Bousch',
        'Electronics'),
       (21, 'Laser Printer', 'Paper jamming', 'returned', 'Paper feed mechanism repair required', 'SN567890', 'Jurah',
        'Computer'),
       (22, 'External Hard Drive', 'Not recognized by computer', 'in_stock',
        'Data recovery and cable replacement needed', 'SN123789', 'Karscheur', 'Computer'),
       (23, 'Coffee Maker', 'Not brewing', 'returned', 'Heating element replacement required', 'SN456012', 'Brown',
        'Household'),
       (24, 'Blender', 'Blades not spinning', 'returned', 'Blade motor repair needed', 'SN890123', 'Samsong',
        'Household'),
       (25, 'Bookshelf', 'Wobbly structure', 'in_stock', 'Stability reinforcement required', 'SN012345', 'Sanyo',
        'Furniture'),
       (26, 'Office Chair', 'Torn upholstery', 'returned', 'Upholstery replacement required', 'SN567890', 'Sanyu',
        'Furniture'),
       (27, 'Angle Grinder', 'Motor overheating', 'in_stock', 'Motor cooling and repair needed', 'SN123789', 'Toshibu',
        'Power Tool'),
       (28, 'Electric Screwdriver', 'Not holding charge', 'returned', 'Battery replacement required', 'SN456012',
        'Aipad', 'Power Tool'),
       (29, 'Tape Measure', 'Measurement not accurate', 'returned', 'Calibration needed', NULL, 'Deel', 'Hand Tool'),
       (30, 'Hacksaw', 'Blade dull', 'for_sale', 'Blade replacement required', NULL, 'Aipad', 'Hand Tool'),
       (31, 'Leather Boots', 'Sole separation', 'returned', 'Sole reattachment needed', 'SN567890', 'Deel', 'Clothing'),
       (32, 'Winter Jacket', 'Zipper stuck', 'sold', 'Zipper repair and lubrication needed', 'SN123789', 'Bousch',
        'Clothing'),
       (33, 'Motorcycle', 'Brake issues', 'returned', 'Brake system repair needed', 'SN456012', 'Jurah', 'Vehicle'),
       (34, 'Skateboard', 'Cracked deck', 'sold', 'Deck replacement required', 'SN890123', 'Karscheur', 'Vehicle'),
       (35, 'Alarm Clock', 'Alarm not sounding', 'returned', 'Alarm mechanism repair needed', 'SN012345', 'Brown',
        'Miscellaneous'),
       (36, 'Portable Fan', 'Not oscillating', 'returned', 'Oscillation motor repair required', 'SN567890', 'Samsong',
        'Miscellaneous'),
       (37, 'Smartwatch', 'Screen not responsive', 'in_stock', 'Touchscreen replacement needed', 'SN123456', 'Apeul',
        'Electronics'),
       (38, 'Bluetooth Earbuds', 'Charging issue', 'for_sale', 'Charging port repair required', 'SN789012', 'Bousch',
        'Electronics'),
       (39, 'Laptop Docking Station', 'Ports not working', 'in_stock', 'Port replacement needed', 'SN345678', 'Jurah',
        'Computer'),
       (40, 'Graphics Card', 'Artifacting on display', 'in_stock', 'Graphics card replacement required', 'SN901234',
        'Karscheur', 'Computer'),
       (41, 'Microwave', 'Not heating', 'in_stock', 'Magnetron replacement needed', 'SN567890', 'Brown', 'Household'),
       (42, 'Air Purifier', 'Fan not working', 'sold', 'Fan motor repair required', 'SN123789', 'Samsong', 'Household'),
       (43, 'Coffee Table', 'Scratched surface', 'in_stock', 'Surface refinishing needed', 'SN456012', 'Sanyo',
        'Furniture'),
       (44, 'Office Desk', 'Drawer stuck', 'in_stock', 'Drawer mechanism repair required', 'SN890123', 'Sanyu',
        'Furniture'),
       (45, 'Jigsaw', 'Blade not cutting straight', 'returned', 'Blade alignment needed', 'SN012345', 'Toshibu',
        'Power Tool'),
       (46, 'Impact Driver', 'Chuck not gripping', 'returned', 'Chuck replacement required', 'SN567890', 'Aipad',
        'Power Tool'),
       (47, 'Utility Knife', 'Blade not retracting', 'in_stock', 'Blade retraction mechanism repair needed', 'SN123789',
        'Deel', 'Hand Tool'),
       (48, 'Adjustable Wrench', 'Jaw misalignment', 'in_stock', 'Jaw realignment needed', 'SN456012', 'Aipad',
        'Hand Tool'),
       (49, 'Winter Gloves', 'Torn stitching', 'in_stock', 'Stitching repair required', 'SN890123', 'Deel', 'Clothing'),
       (50, 'Hiking Backpack', 'Zipper snagging', 'in_stock', 'Zipper repair and lubrication needed', 'SN012345',
        'Bousch', 'Clothing');

--
-- Reparation insertion
--
INSERT INTO reparation (object_id, customer_id, receptionist_id, quote, description, estimated_duration,
                        reparation_state, quote_state, date_created, date_modified)
VALUES (1, 1, 69, 80.00, 'Needs urgent repair', '2 hours', 'ongoing', 'accepted', '2022-01-01 00:08:00', '2022-01-02 21:08:00'),
       (2, 2, 70, 50.00, 'Screen replacement needed', '3 hours', 'done', 'accepted', '2022-01-01 20:08:00', '2022-01-04 21:08:00'),
       (3, 3, 71, 90.00, 'Software optimization required', '4 hours', 'done', 'accepted', '2022-01-02 15:08:00', '2022-01-05 22:08:00'),
       (4, 4, 69, 60.00, 'Battery replacement needed', '5 hours', 'done', 'accepted', '2022-01-05 17:08:00', '2022-01-08 01:08:00'),
       (5, 7, 69, 70.00, 'Motor replacement required', '6 hours', 'done', 'accepted', '2022-01-06 19:08:00', '2022-01-08 12:08:00'),
       (6, 8, 71, 40.00, 'Heating element needs replacement', '7 hours', 'done', 'accepted', '2022-01-10 00:08:00', '2022-01-13 00:08:00'),
       (7, 11, 71, 80.00, 'Leg repair needed', '8 hours', 'done', 'accepted', '2022-01-14 10:08:00', '2022-01-17 13:08:00'),
       (8, 12, 70, 50.00, 'Upholstery replacement required', '9 hours', 'done', 'accepted', '2022-01-18 02:08:00', '2022-01-21 01:08:00'),
       (9, 19, 69, 90.00, 'Not turning on', '7 hours', 'done', 'accepted', '2022-01-20 02:08:00', '2022-01-21 11:08:00'),
       (10, 20, 71, 60.00, 'Blade not cutting properly', '5 hours', 'done', 'declined', '2022-01-22 06:08:00', '2022-01-22 23:08:00'),
       (11, 23, 71, 70.00, 'Handle broken', '4 hours', 'done', 'accepted', '2022-01-25 08:08:00', '2022-01-26 11:08:00'),
       (12, 24, 70, 40.00, 'Rust on the head', '2 hours', 'done', 'accepted', '2022-01-26 23:08:00', '2022-01-29 03:08:00'),
       (13, 27, 70, 80.00, 'Zipper not working', '5 hours', 'ongoing', 'accepted', '2022-01-28 05:08:00', '2022-01-30 07:08:00'),
       (14, 28, 69, 50.00, 'Sole worn out', '3 hours', 'done', 'accepted', '2022-01-31 17:08:00', '2022-02-02 06:08:00'),
       (15, 31, 69, 90.00, 'Engine not starting', '6 hours', 'ongoing', 'accepted', '2022-02-02 12:08:00', '2022-02-04 08:08:00'),
       (16, 32, 71, 60.00, 'Flat tire', '4 hours', 'done', 'accepted', '2022-02-06 18:08:00', '2022-02-08 13:08:00'),
       (17, 35, 71, 70.00, 'Stopped ticking', '3 hours', 'done', 'accepted', '2022-02-09 16:08:00', '2022-02-12 03:08:00'),
       (18, 36, 70, 40.00, 'No sound output', '9 hours', 'waiting', 'waiting', '2022-02-14 03:08:00', '2022-02-16 08:08:00'),
       (19, 39, 70, 80.00, 'Lens not focusing', '8 hours', 'done', 'accepted', '2022-02-15 02:08:00', '2022-02-18 21:08:00'),
       (20, 40, 69, 50.00, 'No audio in one ear', '6 hours', 'done', 'accepted', '2022-02-16 17:08:00', '2022-02-20 00:08:00'),
       (21, 43, 69, 90.00, 'Paper jamming', '10 hours', 'done', 'accepted', '2022-02-20 05:08:00', '2022-02-22 13:08:00'),
       (22, 44, 71, 60.00, 'Not recognized by computer', '8 hours', 'done', 'accepted', '2022-02-20 05:08:00', '2022-02-21 15:08:00'),
       (23, 47, 71, 70.00, 'Not brewing', '5 hours', 'done', 'accepted', '2022-02-25 00:08:00', '2022-02-26 17:08:00'),
       (24, 48, 70, 40.00, 'Fan not working', '3 hours', 'done', 'accepted', '2022-02-25 15:08:00', '2022-02-28 00:08:00'),
       (25, 1, 70, 80.00, 'Wobbly structure', '8 hours', 'ongoing', 'accepted', '2022-02-26 06:08:00', '2022-03-01 03:08:00'),
       (26, 2, 69, 50.00, 'Torn upholstery', '6 hours', 'abandoned', 'declined', '2022-02-26 09:08:00', '2022-03-01 13:08:00'),
       (27, 21, 70, 80.00, 'Motor overheating', '3 hours', 'ongoing', 'accepted', '2022-03-01 08:08:00', '2022-03-02 17:08:00'),
       (28, 22, 69, 50.00, 'Not holding charge', '9 hours', 'done', 'accepted', '2022-03-02 22:08:00', '2022-03-05 17:08:00'),
       (29, 25, 69, 60.00, 'Measurement not accurate', '8 hours', 'done', 'accepted', '2022-03-07 11:08:00', '2022-03-09 04:08:00'),
       (30, 26, 71, 30.00, 'Blade dull', '6 hours', 'done', 'declined', '2022-03-08 09:08:00', '2022-03-12 15:08:00'),
       (31, 29, 71, 70.00, 'Sole separation', '9 hours', 'abandoned', 'declined', '2022-03-09 09:08:00', '2022-03-11 02:08:00'),
       (32, 30, 70, 40.00, 'Zipper stuck', '7 hours', 'done', 'declined', '2022-03-12 16:08:00', '2022-03-16 05:08:00'),
       (33, 33, 70, 80.00, 'Brake issues', '10 hours', 'done', 'accepted', '2022-03-13 14:08:00', '2022-03-16 00:08:00'),
       (34, 34, 69, 50.00, 'Cracked deck', '8 hours', 'done', 'declined', '2022-03-18 03:08:00', '2022-03-21 23:08:00'),
       (35, 37, 69, 60.00, 'Alarm not sounding', '7 hours', 'done', 'accepted', '2022-03-22 13:08:00', '2022-03-26 01:08:00'),
       (36, 38, 71, 30.00, 'Not oscillating', '5 hours', 'done', 'accepted', '2022-03-25 01:08:00', '2022-03-27 02:08:00'),
       (37, 41, 71, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting', '2022-03-25 10:08:00', '2022-03-29 11:08:00'),
       (38, 42, 70, 40.00, 'Charging issue', '2 hours', 'done', 'declined', '2022-03-30 08:08:00', '2022-03-31 17:08:00'),
       (39, 45, 70, 80.00, 'Ports not working', '6 hours', 'done', 'accepted', '2022-04-02 14:08:00', '2022-04-05 11:08:00'),
       (40, 46, 69, 50.00, 'Artifacting on display', '4 hours', 'ongoing', 'accepted', '2022-04-07 03:08:00', '2022-04-07 16:08:00'),
       (41, 49, 69, 60.00, 'Not heating', '9 hours', 'waiting', 'accepted', '2022-04-08 06:08:00', '2022-04-10 19:08:00'),
       (42, 50, 71, 30.00, 'Heating element replacement needed', '7 hours', 'done', 'declined', '2022-04-08 10:08:00', '2022-04-11 00:08:00'),
       (43, 3, 71, 70.00, 'Scratched surface', '4 hours', 'ongoing', 'accepted', '2022-04-12 01:08:00', '2022-04-16 20:08:00'),
       (44, 4, 70, 40.00, 'Drawer stuck', '2 hours', 'ongoing', 'accepted', '2022-04-15 09:08:00', '2022-04-17 05:08:00'),
       (45, 5, 69, 90.00, 'Blade not cutting straight', '7 hours', 'done', 'accepted', '2022-04-18 07:08:00', '2022-04-21 20:08:00'),
       (46, 6, 71, 60.00, 'Chuck not gripping', '5 hours', 'done', 'accepted', '2022-04-18 22:08:00', '2022-04-22 01:08:00'),
       (47, 9, 71, 70.00, 'Blade not retracting', '4 hours', 'ongoing', 'accepted', '2022-04-23 09:08:00', '2022-04-25 00:08:00'),
       (48, 10, 70, 40.00, 'Jaw misalignment', '2 hours', 'ongoing', 'accepted', '2022-04-24 09:08:00', '2022-04-27 16:08:00'),
       (49, 13, 70, 80.00, 'Torn stitching', '5 hours', 'ongoing', 'accepted', '2022-04-25 16:08:00', '2022-04-28 17:08:00'),
       (50, 14, 69, 50.00, 'Zipper snagging', '3 hours', 'ongoing', 'accepted', '2022-04-26 01:08:00', '2022-04-29 21:08:00');

--
-- Reparation insertion
--
-- Reparation entries for Power Tool category
INSERT INTO sale (object_id, price, date_sold)
VALUES (10, 50.00, NULL),
       (30, 120.00, NULL),
       (32, 25.00, DATE '2023-6-30'),
       (34, 30.00, DATE '2023-10-11'),
       (38, 200.00, NULL),
       (42, 20.00, DATE '2023-01-01');

--
-- Technician_reparation insertion
--
-- Technician IDs: 54 to 68
-- Specializations: Electronics, Electrical, Woodworking, Mechanics, Sewing, Miscellaneous

-- Technician ID 54 (Electronics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 1, '2 hours'); -- Laptop reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 2, '1.5 hours'); -- Smartphone reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 3, '2.5 hours'); -- Desktop Computer reparation

-- Technician ID 55 (Electrical specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (55, 5, '1 hour'); -- Vacuum Cleaner reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (55, 6, '1.5 hours'); -- Toaster reparation

-- Technician ID 56 (Woodworking specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (56, 7, '3 hours'); -- Dining Table reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (56, 8, '2 hours'); -- Sofa reparation

-- Technician ID 57 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 9, '2 hours'); -- Drill reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 10, '2.5 hours'); -- Circular Saw reparation

-- Technician ID 58 (Sewing specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (58, 13, '1.5 hours'); -- Leather Jacket reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (58, 14, '1 hour'); -- Running Shoes reparation

-- Technician ID 59 (Miscellaneous specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (59, 17, '2 hours'); -- Watch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (59, 18, '1.5 hours'); -- Bluetooth Speaker reparation

-- Technician ID 60 (Electronics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (60, 19, '3 hours'); -- Digital Camera reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (60, 20, '2 hours'); -- Headphones reparation

-- Technician ID 61 (Electrical specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (61, 21, '2.5 hours'); -- Laser Printer reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (61, 22, '2 hours'); -- External Hard Drive reparation

-- Technician ID 62 (Woodworking specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (62, 25, '3.5 hours'); -- Bookshelf reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (62, 26, '2.5 hours'); -- Office Chair reparation

-- Technician ID 63 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (63, 27, '4 hours'); -- Angle Grinder reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (63, 28, '3 hours'); -- Electric Screwdriver reparation

-- Technician ID 64 (Sewing specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (64, 31, '2 hours'); -- Leather Boots reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (64, 32, '1.5 hours'); -- Winter Jacket reparation

-- Technician ID 65 (Mechanics specialization)
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (65, 33, '3.5 hours'); -- Motorcycle reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (65, 34, '2 hours'); -- Skateboard reparation

-- Technician ID 66 (Electronics specialization)
-- Assuming these technicians also take on Electronics-related tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (66, 37, '2.5 hours'); -- Smartwatch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (66, 38, '2 hours'); -- Bluetooth Earbuds reparation

-- Technician ID 67 (Electrical specialization)
-- Assuming these technicians also take on Electrical-related tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (67, 41, '3 hours'); -- Microwave reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (67, 42, '1.5 hours'); -- Air Purifier reparation

-- Technician ID 68 (Miscellaneous specialization)
-- Assigning miscellaneous tasks
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (68, 35, '2 hours'); -- Alarm Clock reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (68, 36, '2.5 hours'); -- Portable Fan reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (68, 29, '2 hours'); -- Tape Measure reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (68, 30, '1 hour'); -- Hacksaw reparation

-- Looping back to Technician ID 54 (Electronics specialization) for remaining Electronics reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 37, '2 hours'); -- Smartwatch reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 38, '1.5 hours'); -- Bluetooth Earbuds reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 39, '3 hours'); -- Laptop Docking Station reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (54, 40, '2.5 hours'); -- Graphics Card reparation

-- Technician ID 55 (Electrical specialization) for remaining Electrical reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (55, 41, '2 hours'); -- Microwave reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (55, 42, '1.5 hours'); -- Air Purifier reparation

-- Technician ID 56 (Woodworking specialization) for remaining Woodworking reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (56, 43, '2 hours'); -- Coffee Table reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (56, 44, '2.5 hours'); -- Office Desk reparation

-- Technician ID 57 (Mechanics specialization) for remaining Mechanics reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 45, '3 hours'); -- Jigsaw reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 46, '2 hours'); -- Impact Driver reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 47, '1.5 hours'); -- Utility Knife reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (57, 48, '2 hours'); -- Adjustable Wrench reparation

-- Technician ID 58 (Sewing specialization) for remaining Sewing reparations
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (58, 49, '2 hours'); -- Winter Gloves reparation
INSERT INTO technician_reparation (technician_id, reparation_id, time_worked)
VALUES (58, 50, '1.5 hours'); -- Hiking Backpack reparation


--
-- Specialization_reparation insertion
--
INSERT INTO specialization_reparation (spec_name, reparation_id)
VALUES ('Electronics', 1),    -- Laptop reparation
       ('Electronics', 2),    -- Smartphone reparation
       ('Electronics', 3),    -- Desktop Computer reparation
       ('Electronics', 4),    -- Tablet reparation
       ('Electronics', 19),   -- Digital Camera reparation
       ('Electronics', 20),   -- Headphones reparation
       ('Electronics', 21),   -- Laser Printer reparation
       ('Electronics', 22),   -- External Hard Drive reparation
       ('Electronics', 37),   -- Smartwatch reparation
       ('Electronics', 38),   -- Bluetooth Earbuds reparation
       ('Electronics', 39),   -- Laptop Docking Station reparation
       ('Electronics', 40),
       ('Electricity', 5),    -- Vacuum Cleaner reparation
       ('Electricity', 6),    -- Toaster reparation
       ('Electricity', 23),   -- Coffee Maker reparation
       ('Electricity', 24),   -- Blender reparation
       ('Electricity', 41),   -- Microwave reparation
       ('Electricity', 42),
       ('Woodworking', 7),    -- Dining Table reparation
       ('Woodworking', 8),    -- Sofa reparation
       ('Woodworking', 25),   -- Bookshelf reparation
       ('Woodworking', 26),   -- Office Chair reparation
       ('Woodworking', 43),   -- Coffee Table reparation
       ('Woodworking', 44),
       ('Mechanics', 9),      -- Drill reparation
       ('Mechanics', 10),     -- Circular Saw reparation
       ('Mechanics', 11),     -- Screwdriver Set reparation
       ('Mechanics', 12),     -- Wrench reparation
       ('Mechanics', 45),     -- Jigsaw reparation
       ('Mechanics', 46),     -- Impact Driver reparation
       ('Mechanics', 47),     -- Utility Knife reparation
       ('Mechanics', 48),     -- Adjustable Wrench reparation
       ('Mechanics', 27),     -- Angle Grinder reparation
       ('Mechanics', 28),
       ('Sewing', 13),        -- Leather Jacket reparation
       ('Sewing', 14),        -- Running Shoes reparation
       ('Sewing', 31),        -- Leather Boots reparation
       ('Sewing', 32),        -- Winter Jacket reparation
       ('Sewing', 49),        -- Winter Gloves reparation
       ('Sewing', 50),
       ('Mechanics', 15),     -- Car reparation
       ('Mechanics', 16),     -- Bicycle reparation
       ('Mechanics', 33),     -- Motorcycle reparation
       ('Mechanics', 34),
       ('Miscellaneous', 17), -- Watch reparation
       ('Miscellaneous', 18), -- Bluetooth Speaker reparation
       ('Miscellaneous', 35), -- Alarm Clock reparation
       ('Miscellaneous', 36), -- Portable Fan reparation
       ('Miscellaneous', 29), -- Tape Measure reparation
       ('Miscellaneous', 30),
       ('Electronics', 15),   -- Car reparation also requires Electronics specialization
       ('Painting', 7),       -- Dining Table also requires Woodworking specialization
       ('Miscellaneous', 9);

--
-- Sms insertion
--
INSERT INTO sms (reparation_id, message, sender, receiver, processing_state, date_created)
VALUES (1, 'The repair cost for your laptop is CHF 80.00.', '+1234567890', '7509811074', 'processed',
        '2022-01-01 01:08:00'),
       (1, 'Your quote for the laptop repair has been accepted.', '7509811074', '+1234567890', 'processed',
        '2022-01-01 16:08:00'),
       (2, 'The repair cost for your smartphone is CHF 50.00.', '+1234567890', '3869329401', 'processed',
        '2022-01-02 16:08:00'),
       (2, 'Your quote for the smartphone repair has been accepted.', '3869329401', '+1234567890', 'processed',
        '2022-01-03 12:08:00'),
       (3, 'The repair cost for your desktop computer is CHF 90.00.', '+1234567890', '9333998972', 'processed',
        '2022-01-03 05:08:00'),
       (3, 'Your quote for the desktop computer repair has been accepted.', '9333998972', '+1234567890', 'processed',
        '2022-01-04 18:08:00'),
       (4, 'The repair cost for your tablet is CHF 60.00.', '+1234567890', '4153821884', 'processed',
        '2022-01-05 22:08:00'),
       (4, 'Your quote for the tablet repair has been accepted.', '4153821884', '+1234567890', 'processed',
        '2022-01-06 11:08:00'),
       (5, 'The repair cost for your vacuum cleaner is CHF 70.00.', '+1234567890', '9289485117', 'processed',
        '2022-01-06 21:08:00'),
       (5, 'Your quote for the vacuum cleaner repair has been accepted.', '9289485117', '+1234567890', 'processed',
        '2022-01-07 21:08:00'),
       (6, 'The repair cost for your toaster is CHF 40.00.', '+1234567890', '3748280535', 'processed',
        '2022-01-11 10:08:00'),
       (6, 'Your quote for the toaster repair has been accepted.', '3748280535', '+1234567890', 'processed',
        '2022-01-13 00:08:00'),
       (7, 'The repair cost for your dining table is CHF 80.00.', '+1234567890', '1576059000', 'processed',
        '2022-01-14 22:08:00'),
       (7, 'Your quote for the dining table repair has been accepted.', '1576059000', '+1234567890', 'processed',
        '2022-01-16 15:08:00'),
       (8, 'The repair cost for your sofa is CHF 50.00.', '+1234567890', '2117079631', 'processed',
        '2022-01-18 23:08:00'),
       (8, 'Your quote for the sofa repair has been accepted.', '2117079631', '+1234567890', 'processed',
        '2022-01-19 23:08:00'),
       (9, 'The repair cost for your drill is CHF 90.00.', '+1234567890', '5841556990', 'processed',
        '2022-01-20 05:08:00'),
       (9, 'Your quote for the drill repair has been accepted.', '5841556990', '+1234567890', 'processed',
        '2022-01-21 00:08:00'),
       (10, 'The repair cost for your circular saw is CHF 60.00.', '+1234567890', '1554714353', 'processed',
        '2022-01-22 08:08:00'),
       (10, 'Your quote for the circular saw repair has been declined.', '1554714353', '+1234567890', 'processed',
        '2022-01-22 11:08:00'),
       (11, 'The repair cost for your screwdriver set is CHF 70.00.', '+1234567890', '1625688540', 'processed',
        '2022-01-25 17:08:00'),
       (11, 'Your quote for the screwdriver set repair has been accepted.', '1625688540', '+1234567890', 'processed',
        '2022-01-25 23:08:00'),
       (12, 'The repair cost for your wrench is CHF 40.00.', '+1234567890', '7427338531', 'processed',
        '2022-01-27 06:08:00'),
       (12, 'Your quote for the wrench repair has been accepted.', '7427338531', '+1234567890', 'processed',
        '2022-01-28 20:08:00'),
       (13, 'The repair cost for your leather jacket is CHF 80.00.', '+1234567890', '2656777071', 'processed',
        '2022-01-29 07:08:00'),
       (13, 'OK', '2656777071', '+1234567890', 'received', '2022-01-30 02:08:00'),
       (14, 'The repair cost for your running shoes is CHF 50.00.', '+1234567890', '2252330197', 'processed',
        '2022-01-31 19:08:00'),
       (14, 'I accept', '2252330197', '+1234567890', 'received', '2022-02-01 14:08:00'),
       (15, 'The repair cost for your car is CHF 90.00.', '+1234567890', '7272619255', 'processed',
        '2022-02-02 21:08:00'),
       (15, 'OK', '7272619255', '+1234567890', 'received', '2022-02-03 07:08:00'),
       (16, 'The repair cost for your bicycle is CHF 60.00.', '+1234567890', '4961832403', 'processed',
        '2022-02-07 01:08:00'),
       (16, 'I accept', '4961832403', '+1234567890', 'received', '2022-02-08 13:08:00'),
       (17, 'The repair cost for your watch is CHF 70.00.', '+1234567890', '1911682485', 'processed',
        '2022-02-10 23:08:00'),
       (17, 'OK', '1911682485', '+1234567890', 'received', '2022-02-11 01:08:00'),
       (18, 'The repair cost for your Bluetooth speaker is CHF 40.00.', '+1234567890', '9425778234', 'processed',
        '2022-02-14 05:08:00'),
       (18, 'I accept', '9425778234', '+1234567890', 'received', '2022-02-14 22:08:00'),
       (19, 'The repair cost for your digital camera is CHF 80.00.', '+1234567890', '2086601361', 'processed',
        '2022-02-16 20:08:00'),
       (19, 'OK', '2086601361', '+1234567890', 'received', '2022-02-17 18:08:00'),
       (20, 'The repair cost for your headphones is CHF 50.00.', '+1234567890', '3043025593', 'processed',
        '2022-02-17 04:08:00'),
       (20, 'I accept', '3043025593', '+1234567890', 'received', '2022-02-18 18:08:00'),
       (21, 'The repair cost for your laser printer is CHF 90.00.', '+1234567890', '6681245302', 'processed',
        '2022-02-21 10:08:00'),
       (21, 'OK', '6681245302', '+1234567890', 'received', '2022-02-21 13:08:00'),
       (22, 'The repair cost for your external hard drive is CHF 60.00.', '+1234567890', '4041368171', 'processed',
        '2022-02-20 16:08:00'),
       (22, 'I accept', '4041368171', '+1234567890', 'received', '2022-02-20 19:08:00'),
       (23, 'The repair cost for your coffee maker is CHF 70.00.', '+1234567890', '4582711234', 'processed',
        '2022-02-25 23:08:00'),
       (23, 'I accept', '4582711234', '+1234567890', 'received', '2022-02-26 05:08:00'),
       (24, 'The repair cost for your blender is CHF 40.00.', '+1234567890', '7214950616', 'processed',
        '2022-02-26 21:08:00'),
       (24, 'OK', '7214950616', '+1234567890', 'received', '2022-02-27 14:08:00'),
       (25, 'The repair cost for your bookshelf is CHF 80.00.', '+1234567890', '9393204438', 'processed',
        '2022-02-27 02:08:00'),
       (25, 'I accept', '9393204438', '+1234567890', 'received', '2022-02-28 06:08:00'),
       (26, 'The repair cost for your office chair is CHF 50.00.', '+1234567890', '7788397622', 'processed',
        '2022-02-27 21:08:00'),
       (26, 'OK', '7788397622', '+1234567890', 'received', '2022-03-01 04:08:00'),
       (27, 'The repair cost for your angle grinder is CHF 80.00.', '+1234567890', '8183530508', 'processed',
        '2022-03-01 19:08:00'),
       (27, 'I accept', '8183530508', '+1234567890', 'received', '2022-03-01 21:08:00'),
       (28, 'The repair cost for your electric screwdriver is CHF 50.00.', '+1234567890', '3357891471', 'processed',
        '2022-03-04 09:08:00'),
       (28, 'OK', '3357891471', '+1234567890', 'received', '2022-03-04 18:08:00'),
       (29, 'The repair cost for your tape measure is CHF 60.00.', '+1234567890', '8046789823', 'processed',
        '2022-03-07 18:08:00'),
       (29, 'I accept', '8046789823', '+1234567890', 'received', '2022-03-08 20:08:00'),
       (30, 'The repair cost for your hacksaw is CHF 30.00.', '+1234567890', '7644258879', 'processed',
        '2022-03-09 17:08:00'),
       (30, 'OK', '7644258879', '+1234567890', 'received', '2022-03-11 10:08:00'),
       (31, 'The repair cost for your leather boots is CHF 70.00.', '+1234567890', '1086694457', 'processed',
        '2022-03-10 03:08:00'),
       (31, 'I accept', '1086694457', '+1234567890', 'received', '2022-03-10 03:08:00'),
       (32, 'The repair cost for your winter jacket is CHF 40.00.', '+1234567890', '2356940339', 'processed',
        '2022-03-14 00:08:00'),
       (32, 'OK', '2356940339', '+1234567890', 'received', '2022-03-14 14:08:00'),
       (33, 'The repair cost for your motorcycle is CHF 80.00.', '+1234567890', '9845978906', 'processed',
        '2022-03-13 21:08:00'),
       (33, 'I accept', '9845978906', '+1234567890', 'received', '2022-03-14 18:08:00'),
       (34, 'The repair cost for your skateboard is CHF 50.00.', '+1234567890', '9631312077', 'processed',
        '2022-03-19 15:08:00'),
       (34, 'OK', '9631312077', '+1234567890', 'received', '2022-03-21 03:08:00'),
       (35, 'The repair cost for your alarm clock is CHF 60.00.', '+1234567890', '2507780331', 'processed',
        '2022-03-23 21:08:00'),
       (35, 'I accept', '2507780331', '+1234567890', 'received', '2022-03-24 23:08:00'),
       (36, 'The repair cost for your portable fan is CHF 30.00.', '+1234567890', '7841546275', 'processed',
        '2022-03-25 03:08:00'),
       (36, 'OK', '7841546275', '+1234567890', 'received', '2022-03-26 06:08:00'),
       (37, 'The repair cost for your smartwatch is CHF 70.00.', '+1234567890', '6823527703', 'processed',
        '2022-03-26 06:08:00'),
       (37, 'I accept', '6823527703', '+1234567890', 'received', '2022-03-27 23:08:00'),
       (38, 'The repair cost for your Bluetooth earbuds is CHF 40.00.', '+1234567890', '6789735999', 'processed',
        '2022-03-30 11:08:00'),
       (38, 'OK', '6789735999', '+1234567890', 'received', '2022-03-30 18:08:00'),
       (39, 'The repair cost for your laptop docking station is CHF 80.00.', '+1234567890', '1849079988', 'processed',
        '2022-04-03 00:08:00'),
       (39, 'I accept', '1849079988', '+1234567890', 'received', '2022-04-04 08:08:00'),
       (40, 'The repair cost for your graphics card is CHF 50.00.', '+1234567890', '3624483477', 'processed',
        '2022-04-07 03:08:00'),
       (40, 'OK', '3624483477', '+1234567890', 'received', '2022-04-07 12:08:00'),
       (41, 'The repair cost for your microwave is CHF 60.00.', '+1234567890', '4948737986', 'processed',
        '2022-04-09 23:08:00'),
       (41, 'I accept', '4948737986', '+1234567890', 'received', '2022-04-10 18:08:00'),
       (42, 'The repair cost for your air purifier is CHF 30.00.', '+1234567890', '5172331839', 'processed',
        '2022-04-09 01:08:00'),
       (42, 'OK', '5172331839', '+1234567890', 'received', '2022-04-10 03:08:00'),
       (43, 'The repair cost for your coffee table is CHF 70.00.', '+1234567890', '6869372742', 'processed',
        '2022-04-13 19:08:00'),
       (43, 'I accept', '6869372742', '+1234567890', 'received', '2022-04-15 10:08:00'),
       (44, 'The repair cost for your office desk is CHF 40.00.', '+1234567890', '8949495741', 'processed',
        '2022-04-15 12:08:00'),
       (44, 'OK', '8949495741', '+1234567890', 'received', '2022-04-16 19:08:00'),
       (45, 'The repair cost for your jigsaw is CHF 90.00.', '+1234567890', '7927615330', 'processed',
        '2022-04-19 19:08:00'),
       (45, 'I accept', '7927615330', '+1234567890', 'received', '2022-04-20 06:08:00'),
       (46, 'The repair cost for your impact driver is CHF 60.00.', '+1234567890', '1673941666', 'processed',
        '2022-04-20 11:08:00'),
       (46, 'OK', '1673941666', '+1234567890', 'received', '2022-04-21 06:08:00'),
       (47, 'The repair cost for your utility knife is CHF 70.00.', '+1234567890', '9342736859', 'processed',
        '2022-04-24 07:08:00'),
       (47, 'I accept', '9342736859', '+1234567890', 'received', '2022-04-24 11:08:00'),
       (48, 'The repair cost for your adjustable wrench is CHF 40.00.', '+1234567890', '3444095541', 'processed',
        '2022-04-26 02:08:00'),
       (48, 'OK', '3444095541', '+1234567890', 'received', '2022-04-26 20:08:00'),
       (49, 'The repair cost for your winter gloves is CHF 80.00.', '+1234567890', '4406289262', 'processed',
        '2022-04-26 03:08:00'),
       (49, 'I accept', '4406289262', '+1234567890', 'received', '2022-04-27 17:08:00'),
       (50, 'The repair cost for your hiking backpack is CHF 50.00.', '+1234567890', '9898594506', 'processed',
        '2022-04-27 14:08:00'),
       (50, 'OK', '9898594506', '+1234567890', 'received', '2022-04-28 13:08:00');
--
-- Views
--

-- Views with id and roles of all collaborators
CREATE OR REPLACE VIEW collab_role_id_view AS
SELECT 'Manager'  AS role,
       manager_id AS id
FROM manager
UNION ALL
SELECT 'Technician'  AS role,
       technician_id AS id
FROM technician
UNION ALL
SELECT 'Receptionist'  AS role,
       receptionist_id AS id
FROM receptionist;

-- View with collaborators informations
CREATE OR REPLACE VIEW collab_info_view AS
SELECT *
FROM collaborator c
INNER JOIN person p
ON c.collaborator_id = p.person_id;

-- View with the information that a receptionist can access
CREATE OR REPLACE VIEW receptionist_view AS
SELECT r.customer_id,
       r.reparation_id,
       o.name,
       o.fault_desc,
       r.quote_state,
       r.date_created,
       r.reparation_state,
       o.location
FROM reparation r
         INNER JOIN object o ON r.object_id = o.object_id;

-- View with customer info
CREATE OR REPLACE VIEW customer_info_view AS
SELECT *
FROM customer c
INNER JOIN person p
ON c.customer_id = p.person_id;

-- View with receptionist info
CREATE OR REPLACE VIEW receptionist_info_view AS
SELECT *
FROM receptionist r
INNER JOIN collaborator c
ON r.receptionist_id = c.collaborator_id
INNER JOIN person p
ON r.receptionist_id = p.person_id;

-- View with technician info
CREATE OR REPLACE VIEW technician_info_view AS
SELECT *
FROM technician t
INNER JOIN collaborator c
ON t.technician_id = c.collaborator_id
INNER JOIN person p
ON t.technician_id = p.person_id;

-- View with manager info
CREATE OR REPLACE VIEW manager_info_view AS
SELECT *
FROM manager m
INNER JOIN collaborator c
ON m.manager_id = c.collaborator_id
INNER JOIN person p
ON m.manager_id = p.person_id;
