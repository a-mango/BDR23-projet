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