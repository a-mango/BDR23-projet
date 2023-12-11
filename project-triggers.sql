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

CREATE OR REPLACE TRIGGER before_reparation_state_insert
BEFORE UPDATE
ON reparation
FOR EACH ROW
EXECUTE FUNCTION date_updated();

-- When there is an insertion on sale table, check that reparation.quote_state is 'declined'

CREATE OR REPLACE FUNCTION quote_state_is_declined()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (SELECT quote_state
        FROM reparation r
                 JOIN object o ON r.object_id = o.object_id
                 JOIN sale s ON o.object_id = s.object_id
        WHERE s.id_sale = NEW.id_sale) <> 'declined'
    THEN
        RAISE EXCEPTION 'quote_state must be "declined"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined
BEFORE INSERT ON sale
FOR EACH ROW
EXECUTE PROCEDURE quote_state_is_declined();

-- When object.location is updated into 'for_sale' or 'sold',  check that quote_state is 'declined'

CREATE OR REPLACE FUNCTION quote_state_is_declined_for_object()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.location IN ('for_sale', 'sold')
        AND (SELECT quote_state
             FROM reparation r
                      JOIN object o ON r.object_id = o.object_id
             WHERE o.object_id = NEW.object_id) <> 'declined'
    THEN
        RAISE EXCEPTION 'quote_state must be "declined"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined_for_object
BEFORE UPDATE OF location ON object
FOR EACH ROW
EXECUTE PROCEDURE quote_state_is_declined_for_object();

-- When reparation.reparation_state is updated into 'ongoing' or 'done', check that quote_state is 'accepted'

CREATE OR REPLACE FUNCTION quote_state_is_accepted()
  RETURNS TRIGGER AS $$
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
BEFORE UPDATE OF reparation_state ON reparation
FOR EACH ROW
EXECUTE PROCEDURE quote_state_is_accepted();

-- When there is an insertion on reparation table, check that customer.tos_accepted

CREATE OR REPLACE FUNCTION tos_accepted()
  RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT tos_accepted
      FROM customer c
      JOIN reparation r
          ON c.customer_id = r.customer_id
      WHERE r.reparation_id = NEW.reparation_id) <> true
  THEN
    RAISE EXCEPTION 'The tos must be accepted.';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_tos_accepted
BEFORE INSERT ON reparation
FOR EACH ROW
EXECUTE PROCEDURE tos_accepted();

-- When there is an insertion on reparation table, set quote_state to 'waiting', reparation_state to 'waiting'
-- and location to in_stock

CREATE OR REPLACE FUNCTION default_values_reparation()
  RETURNS TRIGGER AS $$
BEGIN

    NEW.quote_state = 'waiting';
    NEW.reparation_state = 'waiting';
    WITH reparation_object AS (
        SELECT *
        FROM object o
        JOIN reparation r
        ON o.object_id = r.object_id
    )
    UPDATE reparation_object
    SET location = 'in_stock'
    WHERE reparation_id = NEW.reparation_id;

  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_default_values_reparation
BEFORE INSERT ON reparation
FOR EACH ROW
EXECUTE PROCEDURE default_values_reparation();

-- When reservation.quote_state is updated to 'accepted', reservation.reservation_state becomes 'ongoing'

CREATE OR REPLACE FUNCTION reservation_state_ongoing()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.reparation_state = 'ongoing';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_reservation_state_ongoing
BEFORE UPDATE OF quote_state ON reparation
FOR EACH ROW EXECUTE PROCEDURE reservation_state_ongoing();

