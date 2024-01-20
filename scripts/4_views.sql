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

-- Update person and collaborator when collab_info_view is updated

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

CREATE TRIGGER update_collaborator_person_trigger
INSTEAD OF UPDATE ON collab_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

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

-- Update Person and Customer when customer_info_view is updated

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

CREATE TRIGGER update_customer_person_trigger
INSTEAD OF UPDATE ON customer_info_view
FOR EACH ROW EXECUTE PROCEDURE update_customer_person();

-- View with receptionist info
CREATE OR REPLACE VIEW receptionist_info_view AS
SELECT *
FROM receptionist r
INNER JOIN collaborator c
ON r.receptionist_id = c.collaborator_id
INNER JOIN person p
ON r.receptionist_id = p.person_id;

-- Update person, collaborator and receptionist when receptionist_info_view is updated

CREATE TRIGGER update_collaborator_person_receptionist_trigger
INSTEAD OF UPDATE ON receptionist_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- View with technician info
CREATE OR REPLACE VIEW technician_info_view AS
SELECT *
FROM technician t
INNER JOIN collaborator c
ON t.technician_id = c.collaborator_id
INNER JOIN person p
ON t.technician_id = p.person_id;

-- Update person, collaborator and technician when receptionist_info_view is updated

CREATE TRIGGER update_collaborator_person_receptionist_trigger
INSTEAD OF UPDATE ON technician_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- View with manager info
CREATE OR REPLACE VIEW manager_info_view AS
SELECT *
FROM manager m
INNER JOIN collaborator c
ON m.manager_id = c.collaborator_id
INNER JOIN person p
ON m.manager_id = p.person_id;

-- Update person, collaborator and technician when receptionist_info_view is updated

CREATE TRIGGER update_collaborator_person_manager_trigger
INSTEAD OF UPDATE ON manager_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();
