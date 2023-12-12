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
UPDATE reparation
SET reparation_state = :reparation_state
WHERE reparation_id = :reparation_id
  AND :reparation_state IN ('waiting', 'ongoing', 'done', 'abandoned');;

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
UPDATE customer
SET tos_accepted = :new_status,
    private_note = :new_note
WHERE customer_id = :customer_id
  AND :new_time IN (TRUE, FALSE);

-- Create customer
WITH new_customer AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:text, :phone, :text)
        RETURNING person_id)

INSERT
INTO customer(customer_id, tos_accepted, private_note)
VALUES ((SELECT person_id FROM new_customer), TRUE, :text)
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
UPDATE reparation
SET date_modified      = NOW(),
    quote              = :quote,
    description        = :description,
    estimated_duration = :estimated_duration,
    reparation_state   = :reparation_state,
    quote_state        = :quote_state
WHERE reparation_id = :reparation_id
  AND :reparation_state IN ('waiting', 'ongoing', 'done', 'abandoned')
  AND :quote_state IN ('accepted', 'declined', 'waiting');

-- Modify quoteState status
UPDATE reparation
SET quote_state = :new_quote_status
WHERE reparation_id = :reparation_id
  AND :quote_state IN ('accepted', 'declined', 'waiting');

-- Consult a sale
SELECT *
FROM sale
WHERE id_sale = :sale_id;

-- Create a sale
INSERT INTO sale(object_id, id_sale, price, date_created, date_sold)
VALUES (:object_id, :id_sale, :price, NOW(), NULL)
RETURNING *;

-- Modify a sale
UPDATE sale
SET price     = :price,
    date_sold = :date_sold
WHERE sale.id_sale = :id_sale;

-- Send SMS
INSERT INTO sms(sms_id, reparation_id, date_created, message, sender, receiver, processing_state)
VALUES (:sms_id, :reparation_id, NOW(), :message, :sender, :receiver, 'received'::processing_state)
RETURNING *;

-- Modify SMS processing state
UPDATE sms
SET processing_state = :new_processing_state
WHERE sms_id = :sms_id
  AND :new_processing_state IN ('received', 'read', 'processed');

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

-- Delete sale
DELETE
FROM sale
WHERE object_id = :sale_object_id;

--
-- Statistics requests
--

-- Total number of on going reparations
SELECT COUNT(*) AS nb_ongoing_rep
FROM reparation
WHERE reparation_state = 'ongoing'::reparation_state;

-- Total number of on going repairs per category
SELECT o.category, COUNT(*) nb_ongoing_rep_per_cat
FROM reparation r
         INNER JOIN object o
                    ON r.object_id = o.object_id
WHERE r.reparation_state = 'ongoing'::reparation_state
GROUP BY o.category;

-- Total number of repairs
SELECT COUNT(*) AS nb_done_rep
FROM reparation
WHERE reparation_state = 'done'::reparation_state;

-- Total number of repairs per category
SELECT o.category, COUNT(*) AS nb_done_rep_per_cat
FROM reparation r
         INNER JOIN object o
                    ON r.object_id = o.object_id
WHERE reparation_state = 'done'::reparation_state
GROUP BY o.category;

-- Total number of for sale objects
SELECT COUNT(*) AS nb_forsale_obj
FROM object
WHERE location = 'for_sale'::location;

-- Total number of sold objects
SELECT COUNT(*) AS nb_sold_obj
FROM object
WHERE location = 'sold'::location;

-- Total number of objets per category
SELECT category, COUNT(*) AS nb_obj_per_cat
FROM object
GROUP BY category;

-- Total number of objets per brand
SELECT brand, COUNT(*) AS nb_obj_per_brand
FROM object
GROUP BY brand;

-- Total number of worked hours per specialization
SELECT sr.spec_name, (CAST(SUM(tr.time_worked) AS DECIMAL) / 60) AS total_worked_time_hours
FROM technician_reparation tr
         INNER JOIN specialization_reparation sr
                    ON sr.reparation_id = tr.reparation_id
GROUP BY sr.spec_name;

-- Total number of repairs per month
SELECT date_trunc('month', date_created) AS date, COUNT(*) AS nb_rep_per_month
FROM reparation
GROUP BY date;

-- Total number of repairs created per receptionist
SELECT receptionist_id, COUNT(*) AS nb_rep_per_recept
FROM reparation
GROUP BY receptionist_id;

-- Total number of receptionist per language
SELECT language, COUNT(*) AS nb_recept_per_lang
FROM receptionist_language
GROUP BY language;

-- Total number of received SMS per day
SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_rec_sms_per_day
FROM sms
WHERE processing_state = 'read'::processing_state
GROUP BY date;

-- Total number of sent SMS per day
SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_sent_sms_per_day
FROM sms
WHERE processing_state = 'sent'::processing_state
GROUP BY date;
