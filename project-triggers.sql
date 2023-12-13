--
-- Triggers
--

-- When reparation table is updated, reparation.date_modified is updated
-- works as expected

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
-- works as expected

/*CREATE OR REPLACE FUNCTION quote_state_is_declined()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS (SELECT 1
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

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined
BEFORE INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION quote_state_is_declined();*/

-- When object.location is updated into 'for_sale' or 'sold',  check that quote_state is 'declined'
-- works as expected

CREATE OR REPLACE FUNCTION quote_state_is_declined_for_object()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.location IN ('for_sale', 'sold')
        AND NOT EXISTS (
            SELECT *
            FROM reparation r
            JOIN object o ON r.object_id = o.object_id
            WHERE o.object_id = NEW.object_id AND r.quote_state <> 'declined'
        )
    THEN
        RAISE EXCEPTION 'quote_state must be "declined"';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_is_declined_for_object
BEFORE UPDATE OF location ON object
FOR EACH ROW
EXECUTE FUNCTION quote_state_is_declined_for_object();

-- When reparation.reparation_state is updated into 'ongoing' or 'done', check that quote_state is 'accepted'
--work as expected

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
EXECUTE FUNCTION quote_state_is_accepted();

-- When there is an insertion on reparation table, check that customer.tos_accepted
-- works as expected

/*CREATE OR REPLACE FUNCTION tos_accepted()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NOT EXISTS (SELECT *
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
BEFORE INSERT ON reparation
FOR EACH ROW
EXECUTE FUNCTION tos_accepted();*/

-- When there is an insertion on reparation table, set quote_state to 'waiting', reparation_state to 'waiting'
-- and location to in_stock
-- useless :( to delete and put default values in the table creation of reparation

/*CREATE OR REPLACE FUNCTION default_values_reparation()
  RETURNS TRIGGER AS $$
BEGIN

    NEW.quote_state = 'waiting';
    NEW.reparation_state = 'waiting';
   /* WITH reparation_object AS (
        SELECT *
        FROM object o
        JOIN reparation r
        ON o.object_id = r.object_id
    )
    UPDATE reparation_object
    SET location = 'in_stock'
    WHERE reparation_id = NEW.reparation_id;*/

  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_default_values_reparation
BEFORE INSERT ON reparation
FOR EACH ROW
EXECUTE FUNCTION default_values_reparation();*/

-- When reparation.quote_state is updated to 'accepted', reparation.reparation becomes 'ongoing'
-- works as expected

CREATE OR REPLACE FUNCTION reservation_state_ongoing()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.reparation_state = 'ongoing';
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_reservation_state_ongoing
BEFORE UPDATE OF quote_state ON reparation
FOR EACH ROW EXECUTE FUNCTION reservation_state_ongoing();

-- When sms.processing_state is updated, check that the state change is correct

CREATE OR REPLACE FUNCTION processing_state_consistency()
  RETURNS TRIGGER AS $$
BEGIN
  IF (NEW.processing_state = 'read'
      AND OLD.processing_state <> 'received') OR
     (NEW.processing_state = 'processed'
      AND OLD.processing_state <> 'read')
  THEN
    RAISE EXCEPTION 'This update of processing_state is invalid.';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_processing_state_consistency
BEFORE UPDATE OF processing_state ON sms
FOR EACH ROW
EXECUTE FUNCTION processing_state_consistency();

-- When object.location is updated, check that the state change is correct

CREATE OR REPLACE FUNCTION location_consistency()
  RETURNS TRIGGER AS $$
BEGIN
  IF (NEW.location IN ('for_sale', 'returned')
      AND OLD.location <> 'in_stock') OR
     (NEW.location = 'sold'
      AND OLD.location <> 'for_sale')
  THEN
    RAISE EXCEPTION 'This update of location is invalid.';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_location_consistency
BEFORE UPDATE OF location ON object
FOR EACH ROW
EXECUTE FUNCTION location_consistency();

-- When reparation.reparation_state is updated, check that the state change is correct

CREATE OR REPLACE FUNCTION reparation_state_consistency()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (NEW.reparation_state IN ('ongoing', 'abandoned')
           AND OLD.reparation_state <> 'waiting') OR
       (NEW.reparation_state = 'abandoned'
           AND OLD.reparation_state NOT IN ('waiting', 'ongoing')) OR
       (NEW.reparation_state = 'done'
           AND OLD.reparation_state <> 'ongoing')
    THEN
        RAISE EXCEPTION 'This update of reparation_state is invalid.';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER reparation_state_verify_location_consistency
    BEFORE UPDATE OF reparation_state
    ON reparation
    FOR EACH ROW
EXECUTE FUNCTION reparation_state_consistency();

-- When reparation.quote_state is updated, check that the state change is correct

CREATE OR REPLACE FUNCTION quote_state_consistency()
  RETURNS TRIGGER AS $$
BEGIN
  IF (NEW.quote_state IN ('declined', 'accepted')
      AND OLD.quote_state <> 'waiting')
  THEN
    RAISE EXCEPTION 'This update of quote_state is invalid.';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER verify_quote_state_consistency
BEFORE UPDATE OF quote_state ON reparation
FOR EACH ROW
EXECUTE FUNCTION quote_state_consistency();

