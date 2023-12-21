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
SELECT v.role, v.id, p.name, p.phone_no, c.email
FROM collab_role_id_view v
         INNER JOIN person p ON v.id = p.person_id
         INNER JOIN collaborator c ON p.person_id = c.collaborator_id;

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

-- View with collaborators info
CREATE OR REPLACE VIEW collab_info_view AS
SELECT *
FROM collaborator c
INNER JOIN person p
ON c.collaborator_id = p.person_id;

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
