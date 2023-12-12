--
-- Views
--

-- View to show the id of the ongoing reparations and the time worked for a technician

CREATE OR REPLACE VIEW works_on
AS
SELECT r.reparation_id, time_worked
FROM reparation r
INNER JOIN technician_reparation tr
ON r.reparation_id = tr.reparation_id
INNER JOIN technician t
ON tr.technician_id = t.technician_id
WHERE t.technician_id = 1 AND r.reparation_state = 'ongoing';

-- View to show the SMS linked to a reparation from newest to oldest

CREATE OR REPLACE VIEW sms_exchange
AS
SELECT date_created, message, sender, receiver, processing_state
FROM sms
WHERE reparation_id = 1
ORDER BY date_created DESC;

-- View with the information that a technician can access

CREATE OR REPLACE VIEW technician_view
AS
SELECT r.reparation_id, r.date_created, r.description, r.estimated_duration, r.reparation_state,
       o.name, o.fault_desc, o.location, o.remark, o.serial_no, o.brand, o.category
FROM reparation r
INNER JOIN technician_reparation tr
ON r.reparation_id = tr.reparation_id
INNER JOIN technician t
ON tr.technician_id = t.technician_id
INNER JOIN object o
ON o.object_id = r.object_id
WHERE t.technician_id = 1;
