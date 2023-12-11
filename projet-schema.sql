DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
COMMENT ON SCHEMA projet IS 'Projet de semestre BDR';

SET search_path = projet;

--
-- Enumerations
--
CREATE TYPE reparation_state AS ENUM ('waiting', 'ongoing', 'done', 'abandoned');
CREATE TYPE quote_state AS ENUM ('accepted', 'declined', 'waiting');
CREATE TYPE location AS ENUM ('in_stock', 'for_sale', 'returned', 'sold');
CREATE TYPE processing_state AS ENUM ('received', 'read', 'processed');

--
-- Table `person`
--
CREATE TABLE person
(
    person_id SERIAL PRIMARY KEY,
    name      VARCHAR(128) NOT NULL,
    phone_no  VARCHAR(11)  NOT NULL UNIQUE CHECK (phone_no ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    comment   TEXT
);

--
-- Table `customer`
--
CREATE TABLE customer
(
    customer_id  INT PRIMARY KEY REFERENCES person (person_id) ON UPDATE CASCADE ON DELETE SET NULL,
    tos_accepted BOOLEAN         NOT NULL,
    private_note TEXT
);

--
-- Table `collaborator`
--
CREATE TABLE collaborator
(
    collaborator_id INT PRIMARY KEY REFERENCES person (person_id) ON UPDATE CASCADE ON DELETE SET NULL,
    email           VARCHAR(128)    NOT NULL UNIQUE CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

--
-- Table `manager`
--
CREATE TABLE manager
(
    manager_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE SET NULL
);

--
-- Table `technician`
--
CREATE TABLE technician
(
    technician_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE SET NULL
);

--
-- Table `receptionist`
--
CREATE TABLE receptionist
(
    receptionist_id INT PRIMARY KEY REFERENCES collaborator (collaborator_id) ON UPDATE CASCADE ON DELETE SET NULL
);

--
-- Table `language`
--
CREATE TABLE language
(
    name VARCHAR(32) PRIMARY KEY
);

--
-- Table `receptionist_language`
--
CREATE TABLE receptionist_language
(
    receptionist_id INT REFERENCES receptionist (receptionist_id) ON UPDATE CASCADE ON DELETE SET NULL,
    language        VARCHAR(32) REFERENCES language (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (receptionist_id, language)
);

--
-- Table `specialization`
--
CREATE TABLE specialization
(
    name VARCHAR(64) PRIMARY KEY
);

--
-- Table `technician_specialization`
--
CREATE TABLE technician_specialization
(
    technician_id INT REFERENCES technician (technician_id) ON UPDATE CASCADE ON DELETE SET NULL,
    spec_name     VARCHAR(64) REFERENCES specialization (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (technician_id, spec_name)
);

--
-- Table `brand`
--
CREATE TABLE brand
(
    name VARCHAR(128) PRIMARY KEY
);

--
-- Table `category`
--
CREATE TABLE category
(
    name VARCHAR(128) PRIMARY KEY
);

--
-- Table `object`
--
CREATE TABLE object
(
    object_id   SERIAL PRIMARY KEY,
    customer_id INT          REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE SET NULL,
    name        VARCHAR(128) NOT NULL,
    fault_desc  TEXT         NOT NULL,
    location    location     NOT NULL,
    remark      TEXT,
    serial_no   VARCHAR(128),
    brand       VARCHAR(128) REFERENCES brand (name) ON UPDATE CASCADE ON DELETE SET NULL,
    category    VARCHAR(128) NOT NULL REFERENCES category (name) ON UPDATE CASCADE ON DELETE RESTRICT
);

--
-- Table `sale`
--
CREATE TABLE sale
(
    object_id    INT            REFERENCES object (object_id) ON UPDATE CASCADE ON DELETE CASCADE,
    id_sale      VARCHAR(128)   NOT NULL,
    price        NUMERIC(10, 2) NOT NULL,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    date_sold    TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (object_id, id_sale)
);

--
-- Table `reparation`
--
CREATE TABLE reparation
(
    reparation_id      SERIAL PRIMARY KEY,
    object_id          INT UNIQUE               REFERENCES object (object_id) ON UPDATE CASCADE ON DELETE CASCADE,
    customer_id        INT                      NOT NULL REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    receptionist_id    INT                      REFERENCES receptionist (receptionist_id) ON UPDATE CASCADE ON DELETE SET NULL,
    date_created       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    date_modified      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    quote              NUMERIC(10, 2),
    description        TEXT                     NOT NULL,
    estimated_duration INTERVAL                 NOT NULL,
    reparation_state   reparation_state         NOT NULL,
    quote_state        quote_state              NOT NULL
);

--
-- Table `technician_reparation`
--
CREATE TABLE technician_reparation
(
    technician_id INT REFERENCES technician (technician_id) ON UPDATE CASCADE ON DELETE SET NULL,
    reparation_id INT REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE SET NULL,
    time_worked   INT,
    PRIMARY KEY (technician_id, reparation_id)
);

--
-- Table `specialization_reparation`
--
CREATE TABLE specialization_reparation
(
    spec_name     VARCHAR(64) REFERENCES specialization (name) ON UPDATE CASCADE ON DELETE RESTRICT,
    reparation_id INT REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE SET NULL,
    PRIMARY KEY (spec_name, reparation_id)
);

--
-- Table `sms`
--
CREATE TABLE sms
(
    sms_id           SERIAL PRIMARY KEY,
    reparation_id    INT              NOT NULL REFERENCES reparation (reparation_id) ON UPDATE CASCADE ON DELETE CASCADE,
    date_created     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    message          TEXT             NOT NULL,
    sender           VARCHAR(128)     NOT NULL CHECK (sender ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    receiver         VARCHAR(128)     NOT NULL CHECK (receiver ~ '^(?:\+[1-9]\d{0,3}|\d{1,4})(?:[ -]?\d{1,14})*$'),
    processing_state processing_state NOT NULL
);