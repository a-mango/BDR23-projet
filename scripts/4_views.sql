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

-- Update person and collaborator when there is an insert on collab_info_view

CREATE OR REPLACE FUNCTION update_collaborator_person_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertCollaborator(NEW.name, NEW.phone_no, NEW.comment, NEW.email, NEW.collaborator_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_collaborator_person_trigger_on_insert
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

CREATE TRIGGER delete_collaborator_person_trigger_on_delete
INSTEAD OF DELETE ON collab_info_view
FOR EACH ROW EXECUTE PROCEDURE delete_collaborator_person_on_delete();

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

-- Update Person and Customer when there is an insert on customer_info_view

CREATE OR REPLACE FUNCTION update_customer_person_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertCustomer(NEW.Name, NEW.phone_no, NEW.comment, NEW.tos_accepted, NEW.private_note);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_customer_person_trigger_on_insert
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

CREATE TRIGGER delete_customer_person_trigger_on_delete
INSTEAD OF DELETE ON customer_info_view
FOR EACH ROW EXECUTE PROCEDURE delete_customer_person_on_delete();

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

-- Update person, collaborator and receptionist when there is an insert on receptionist_info_view

CREATE OR REPLACE FUNCTION update_collaborator_person_receptionist_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertReceptionist(NEW.name, NEW.phone_no, NEW.comment, NEW.email);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_collaborator_person_receptionist_trigger_on_insert
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

CREATE TRIGGER delete_receptionist_person_trigger_on_delete
INSTEAD OF DELETE ON receptionist_info_view
FOR EACH ROW EXECUTE PROCEDURE delete_receptionist_person_on_delete();

-- View with technician info
CREATE OR REPLACE VIEW technician_info_view AS
SELECT *
FROM technician t
INNER JOIN collaborator c
ON t.technician_id = c.collaborator_id
INNER JOIN person p
ON t.technician_id = p.person_id;

-- Update person, collaborator and technician when technician_info_view is updated

CREATE TRIGGER update_collaborator_person_receptionist_trigger
INSTEAD OF UPDATE ON technician_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person, collaborator and technician when there is an insert on technician_info_view

CREATE OR REPLACE FUNCTION update_collaborator_person_technician_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertTechnician(NEW.name, NEW.phone_no, NEW.comment, NEW.email);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_collaborator_person_technician_trigger_on_insert
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

CREATE TRIGGER delete_technician_person_trigger_on_delete
INSTEAD OF DELETE ON technician_info_view
FOR EACH ROW EXECUTE PROCEDURE delete_technician_person_on_delete();

-- View with manager info
CREATE OR REPLACE VIEW manager_info_view AS
SELECT *
FROM manager m
INNER JOIN collaborator c
ON m.manager_id = c.collaborator_id
INNER JOIN person p
ON m.manager_id = p.person_id;

-- Update person, collaborator and manager when manager_info_view is updated

CREATE TRIGGER update_collaborator_person_manager_trigger
INSTEAD OF UPDATE ON manager_info_view
FOR EACH ROW EXECUTE PROCEDURE update_collaborator_person();

-- Update person, collaborator and manager when there is an insert on manager_info_view

CREATE OR REPLACE FUNCTION update_collaborator_person_manager_on_insert() RETURNS TRIGGER AS $$
BEGIN

    CALL InsertManager(NEW.name, NEW.phone_no, NEW.comment, NEW.email);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_collaborator_person_manager_trigger_on_insert
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

CREATE TRIGGER delete_manager_person_trigger_on_delete
INSTEAD OF DELETE ON manager_info_view
FOR EACH ROW EXECUTE PROCEDURE delete_manager_person_on_delete();

