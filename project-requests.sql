--
-- Requests
--

-- Consult all reparations
SELECT *
FROM reparation;

--
-- Technician
--

-- Consult all reparations from a given technician
SELECT r.*
FROM reparation r
         INNER JOIN technician_reparation tr ON r.reparation_id = tr.reparation_id
WHERE tr.technician_id = :technician_id;

-- Modify ReparationState
-- Constraint: :new_state must be a value from reparation_state enumeration
UPDATE reparation
SET reparation_state = :new_state
WHERE reparation_id = :reparation_id;

-- Modify reparation description
UPDATE reparation
SET description = :new_description
WHERE reparation_id = :reparation_id;

-- Add time_worked on a reparation
UPDATE technician_reparation
SET time_worked = time_worked + :new_time
WHERE technician_id = :technician_id
  AND reparation_id = : reparation_id;


--
-- Receptionist
--

-- Consult client
SELECT *
FROM customer;

-- Modify client
-- TODO
/*
BEGIN
DECLARE
        customer_id INT := :customer_id
        new_name VARCHAR(128) := :new_name
        new_phone VARCHAR(11) := :new_phone
        new_text TEXT := :new_text
        new_status BOOLEAN := :new_status
        new_note TEXT := :new_note;

UPDATE person
SET person_id = :customer_id, name = :new_name, phone_no = :new_phone, comment = :new_text
WHERE person_id = :customer_id;

UPDATE customer
SET tos_accepted = :new_status, private_note = :new_note
WHERE customer_id = :customer_id;

COMMIT;
END;
*/

-- Create customer
WITH customer AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:text, :phone, :text)
        RETURNING person_id)

INSERT
INTO customer(customer_id, tos_accepted, private_note)
VALUES ((SELECT person_id FROM customer), true, :text)
RETURNING *;

-- Consult reparation
SELECT *
FROM reparation
WHERE reparation_id = :reparation_id;

-- Create reparation
WITH new_object AS (
    INSERT INTO object (object_id, customer_id, name, fault_desc, location, remark, serial_no, brand, category)
        VALUES (:object_id, :customer_id, :name, :fault_desc, 'in_stock'::location, :remark, :serial_no, :brand,
                :category)
        RETURNING object_id)

INSERT
INTO reparation(object_id, customer_id, receptionist_id, quote, description, estimated_duration, reparation_state,
                quote_state)
VALUES ((SELECT object_id FROM new_object),
        :customer_id, :receptionist_id, :quote, :description, :estimated_duration, 'waiting'::reparation_state,
        'waiting'::quote_state)
RETURNING *;

-- Modify reparation
-- TODO

-- Modify quoteState status
-- Constraint: :new_quote_status must be a value from quote_status enumeration
UPDATE reparation
SET quote_state = :new_quote_status
WHERE reparation_id = :reparation_id;

-- Consult a sale
SELECT *
FROM sale
WHERE id_sale = :sale_id;

-- Create a sale
INSERT INTO sale(object_id, id_sale, price, date_created, date_sold)
VALUES (:object_id, :id_sale, :price, NOW(), NULL)
RETURNING *;

-- Modify a sale
-- TODO

-- Send SMS
INSERT INTO sms(sms_id, reparation_id, date_created, message, sender, receiver, processing_state)
VALUES (:sms_id, :reparation_id, NOW(), :message, :sender, :receiver, 'received'::processing_state)
RETURNING *;

-- Modify SMS processing state
UPDATE sms
SET processing_state = :new_processing_state;

-- Consult SMS
SELECT *
FROM sms
WHERE sms_id = :sms_id;

--
-- Manager
--

-- All requests above

-- Create collaborator
WITH new_person AS (
    INSERT INTO person (person_id, name, phone_no, comment)
        VALUES (:person_id, :name, :phone_no, :comment)
        RETURNING person_id)
INSERT
INTO collaborator(collaborator_id, email)
VALUES ((SELECT person_id FROM new_person),
        :email);

-- Modify collaborator
UPDATE person
SET name     = :name,
    phone_no = :phone_no,
    comment  = :comment
WHERE person_id = :collaborator_id;

UPDATE collaborator
SET email = :email
WHERE collaborator_id = :collaborator_id;

-- Delete collaborator
DELETE
FROM person
WHERE person_id = :collaborator_id;

DELETE
FROM collaborator
WHERE collaborator_id = :collaborator_id;

-- Assign roles (?)

-- Delete customers
DELETE
FROM person
WHERE person_id = :customer_id;

DELETE
FROM customer
WHERE customer_id = :customer_id;

-- Delete sales
DELETE
FROM sale
WHERE object_id = :sale_object_id;

--
-- Statistics requests
--

-- Total number of on going reparations
SELECT COUNT(*)
FROM reparation
WHERE reparation_state = 'ongoing'::reparation_state;

-- Total number of on going repairs per category
SELECT o.category, COUNT(*)
FROM reparation r
         INNER JOIN object o
                    ON r.object_id = o.object_id
WHERE r.reparation_state = 'ongoing'::reparation_state
GROUP BY o.category;

-- Total number of repairs
SELECT COUNT(*)
FROM reparation
WHERE reparation_state = 'done'::reparation_state;

-- Total number of repairs per category
SELECT o.category, COUNT(*)
FROM reparation r
         INNER JOIN object o
                    ON r.object_id = o.object_id
WHERE reparation_state = 'done'::reparation_state
GROUP BY o.category;

-- Total number of for sale objects
SELECT COUNT(*)
FROM object
WHERE location = 'for_sale'::location;

-- Total number of sold objects
SELECT COUNT(*)
FROM object
WHERE location = 'sold'::location;

-- Total number of objets per category
SELECT category, COUNT(*)
FROM object
GROUP BY category;

-- Total number of objets per category
SELECT brand, COUNT(*)
FROM object
GROUP BY brand;

-- Total number of worked hours per specialization
SELECT sr.spec_name, (CAST(SUM(tr.time_worked) AS DECIMAL) / 60) AS total_worked_time_hours
FROM technician_reparation tr
         INNER JOIN specialization_reparation sr
                    ON sr.reparation_id = tr.reparation_id
GROUP BY sr.spec_name;

-- Total number of repairs per month
-- TODO

-- Total number of repairs created per receptionist
SELECT receptionist_id, COUNT(*)
FROM reparation
GROUP BY receptionist_id;

-- Total number of receptionist per language
SELECT language, COUNT(*)
FROM receptionist_language
GROUP BY language;

-- Total number of collaborators per role
-- TODO vue?

-- Total number of received SMS per day

-- Total number of sent SMS per day


