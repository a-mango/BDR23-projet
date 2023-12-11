SET search_path TO projet;

INSERT INTO sale (object_id, price, date_sold)
VALUES 
    (10, 50.00, NULL),
    (30, 120.00, NULL),
    (32, 25.00, NULL),
    (34, 30.00, NULL),
    (38, 200.00, NULL),
    (42, 20.00, NULL);

-- TODO: add some `sold` items ?