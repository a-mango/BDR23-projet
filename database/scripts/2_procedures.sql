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

-- Used in the API to create a new receptionist
CREATE OR REPLACE PROCEDURE createReceptionist(
    IN in_name VARCHAR(128),
    IN in_phone_no VARCHAR(11),
    IN in_comment TEXT,
    IN in_email VARCHAR(128),
    IN in_languages VARCHAR(32)[],
    OUT _new_id INTEGER
)
    LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
BEGIN
    -- Insert into person table
    INSERT INTO person(name, phone_no, comment)
    VALUES (in_name, in_phone_no, in_comment)
    RETURNING person_id INTO i;

    -- Insert into collaborator table
    INSERT INTO collaborator(collaborator_id, email)
    VALUES (i, in_email);

    -- Insert into receptionist table
    INSERT INTO receptionist(receptionist_id)
    VALUES (i)
    RETURNING receptionist_id INTO _new_id;

    -- Insert languages into receptionist_language table
    FOR j IN 1..array_length(in_languages, 1)
        LOOP
            INSERT INTO receptionist_language(receptionist_id, language)
            VALUES (_new_id, in_languages[j]);
        END LOOP;
END;
$$;

-- Used in the API to update a receptionist
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
$$;