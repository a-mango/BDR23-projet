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
WHERE tr.technician_id = :reparation_id;

-- Modify ReparationState
UPDATE reparation
SET reparation_state = :reparation_state,
    date_modified    = NOW()
WHERE reparation_id = :reparation_id
  AND :reparation_state IN ('waiting', 'ongoing', 'done', 'abandoned')
RETURNING *;

-- Modify reparation description
UPDATE reparation
SET description   = :description,
    date_modified = NOW()
WHERE reparation_id = :reparation_id
RETURNING *;


-- Add time_worked on a reparation
UPDATE technician_reparation
SET time_worked = time_worked + :time_worked
WHERE technician_id = :technician_id
  AND reparation_id = :reparation_id
RETURNING *;
--
-- Receptionist
--

-- Consult client
SELECT *
FROM customer;

-- Modify client
UPDATE customer
SET tos_accepted = :tos_accepted,
    private_note = :private_note
WHERE customer_id = :customer_id
  AND :tos_accepted IN (TRUE, FALSE)
RETURNING *;

-- Create customer
WITH new_customer AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:name, :phone_no, :comment)
        RETURNING person_id)

INSERT
INTO customer(customer_id, tos_accepted, private_note)
VALUES ((SELECT person_id FROM new_customer), TRUE, :private_note)
RETURNING *;

-- Consult reparation
SELECT *
FROM reparation
WHERE reparation_id = :reparation_id;

-- Create reparation
WITH new_object AS (
    INSERT INTO object (customer_id, name, fault_desc, location, remark, serial_no, brand, category)
        VALUES (:customer_id, :name, :fault_desc, 'in_stock'::location, :remark, :serial_no, :brand,
                :category)
        RETURNING object_id)

INSERT
INTO reparation(object_id, customer_id, receptionist_id, date_created, date_modified, quote, description,
                estimated_duration, reparation_state, quote_state)
VALUES ((SELECT object_id FROM new_object),
        :customer_id, :receptionist_id, NOW(), NOW(), :quote, :description, :estimated_duration,
        'waiting'::reparation_state,
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
  AND :quote_state IN ('accepted', 'declined', 'waiting')
RETURNING *;

-- Modify quoteState status
UPDATE reparation
SET quote_state   = :quote_state,
    date_modified = NOW()
WHERE reparation_id = :reparation_id
  AND :quote_state IN ('accepted', 'declined', 'waiting')
RETURNING *;

-- Consult a sale
SELECT *
FROM sale
WHERE id_sale = :sale_id;

-- Create a sale
INSERT INTO sale(object_id, price, date_created, date_sold)
VALUES (:object_id, :price, NOW(), NULL)
RETURNING *;

-- Modify a sale
UPDATE sale
SET price     = :price,
    date_sold = :date_sold
WHERE sale.id_sale = :id_sale
RETURNING *;

-- Collaborator send SMS
INSERT INTO sms(reparation_id, date_created, message, sender, receiver, processing_state)
VALUES (:reparation_id, NOW(), :message, :sender, :receiver, 'processed'::processing_state)
RETURNING *;

-- Modify SMS processing state
UPDATE sms
SET processing_state = :new_processing_state
WHERE sms_id = :sms_id
  AND :new_processing_state IN ('received', 'read', 'processed')
RETURNING *;

-- Consult SMS
SELECT *
FROM sms
WHERE sms_id = :sms_id;

--
-- Manager
--

-- All requests above and:

-- Create collaborator
WITH new_person AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:name, :phone_no, :comment)
        RETURNING person_id)
INSERT
INTO collaborator(collaborator_id, email)
VALUES ((SELECT person_id FROM new_person),
        :email)
RETURNING *;

-- Create manager
WITH new_person AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:name, :phone_no, :comment)
        RETURNING person_id),

     new_collaborator AS (
         INSERT INTO collaborator (collaborator_id, email)
             VALUES ((SELECT person_id FROM new_person),
                     :email))
INSERT
INTO manager(manager_id)
VALUES ((SELECT person_id FROM new_person))
RETURNING *;

-- Create technician
WITH new_person AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:name, :phone_no, :comment)
        RETURNING person_id),

     new_collaborator AS (
         INSERT INTO collaborator (collaborator_id, email)
             VALUES ((SELECT person_id FROM new_person),
                     :email)),
     new_technician AS (
         INSERT INTO technician (technician_id)
             VALUES ((SELECT person_id FROM new_person)))
INSERT
INTO technician_specialization(technician_id, spec_name)
VALUES ((SELECT person_id FROM new_person), :spec_name)
RETURNING *;

-- Create receptionist
WITH new_person AS (
    INSERT INTO person (name, phone_no, comment)
        VALUES (:name, :phone_no, :comment)
        RETURNING person_id),

     new_collaborator AS (
         INSERT INTO collaborator (collaborator_id, email)
             VALUES ((SELECT person_id FROM new_person),
                     :email)),
     new_receptionist AS (
         INSERT INTO receptionist (receptionist_id)
             VALUES ((SELECT person_id FROM new_person)))
INSERT
INTO receptionist_language(receptionist_id, language)
VALUES ((SELECT person_id FROM new_person), :language)
RETURNING *;

-- Modify collaborator
UPDATE collaborator
SET email = :email
WHERE collaborator_id = :collaborator_id
RETURNING *;

SELECT *
FROM collaborator;

-- Delete perosn
DELETE
FROM person
WHERE person_id = :person_id;

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
GROUP BY o.category
ORDER BY nb_ongoing_rep_per_cat DESC;

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
GROUP BY o.category
ORDER BY nb_done_rep_per_cat DESC;

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
GROUP BY category
ORDER BY nb_obj_per_cat DESC;

-- Total number of objets per brand
SELECT brand, COUNT(*) AS nb_obj_per_brand
FROM object
GROUP BY brand
ORDER BY nb_obj_per_brand DESC;

-- Total number of worked hours per specialization
SELECT sr.spec_name, ((CAST(SUM(EXTRACT(EPOCH FROM tr.time_worked)) AS DECIMAL)) / 360) AS total_worked_time_hours
FROM technician_reparation tr
         INNER JOIN specialization_reparation sr
                    ON sr.reparation_id = tr.reparation_id
GROUP BY sr.spec_name;

-- Total number of repairs per month
SELECT date_trunc('month', date_created) AS date, COUNT(*) AS nb_rep_per_month
FROM reparation
GROUP BY date
ORDER BY date DESC;

-- Total number of repairs created per receptionist
SELECT receptionist_id, COUNT(*) AS nb_rep_per_recept
FROM reparation
GROUP BY receptionist_id;

-- Total number of receptionist per language
SELECT language, COUNT(*) AS nb_recept_per_lang
FROM receptionist_language
GROUP BY language
ORDER BY nb_recept_per_lang DESC;

-- Total number of received SMS per day
SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_rec_sms_per_day
FROM sms
WHERE processing_state = 'received'::processing_state
GROUP BY date
ORDER BY date DESC;

-- Total number of sent SMS per day
SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_sent_sms_per_day
FROM sms
WHERE processing_state = 'processed'::processing_state
GROUP BY date
ORDER BY date DESC;
