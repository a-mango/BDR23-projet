--
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
