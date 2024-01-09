BEGIN;

-- Book a Ticket

CREATE OR REPLACE PROCEDURE book_ticket(showtime_id BIGINT,
										customer_id BIGINT, 
										seat_id BIGINT
) AS $$
BEGIN
-- We can use 'Last one wins' here
-- If we have a website, which shows available seats - let's book a ticket if the customer proceeds to payment
-- If the payment process is aborted - we delete this row in Ticket table
-- Concurrency problem is solved and there is no overhead (optimistic locking from PostgreSQL is fine)
INSERT INTO ticket (showtime_id, customer_id, seat_id) VALUES (showtime_id, customer_id, seat_id);
END;
$$ LANGUAGE plpgsql;

-- Generate seats

CREATE OR REPLACE PROCEDURE create_rows_of_seats(
    hall_id BIGINT,
    row_num BIGINT,
    seats_per_row BIGINT
) AS $$
DECLARE
    seat_id BIGINT;
BEGIN
    -- Insert a new seat
    FOR seat_num IN 1..seats_per_row LOOP
        INSERT INTO seat (hall_id, row_num, seat_num)
        VALUES (hall_id, row_num, seat_num)
        RETURNING id INTO seat_id;

        -- Check if the seat was successfully inserted
        IF seat_id IS NOT NULL THEN
            -- Seat insertion successful
            RAISE NOTICE 'Seat % inserted successfully in hall %', seat_num, hall_id;
        ELSE
            -- Seat insertion failed
            RAISE EXCEPTION 'Seat % insertion failed in hall %', seat_num, hall_id;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Create new Cinema

INSERT INTO cinema_address(city, street, zip_code) VALUES ('Kharkiv', 'Main St.', '61144');
INSERT INTO cinema(cinema_address_id) VALUES (1);

-- Create new Halls for Cinema

INSERT INTO hall(letter, cinema_id) VALUES ('A', 1);
INSERT INTO hall(letter, cinema_id) VALUES ('B', 1);
INSERT INTO hall(letter, cinema_id) VALUES ('C', 1);

-- Create new Seats for Halls

-- Seats for Hall 'A'

CALL create_rows_of_seats(1, 1, 10);
CALL create_rows_of_seats(1, 2, 10);

-- Seats for Hall 'B'

CALL create_rows_of_seats(2, 1, 5);
CALL create_rows_of_seats(2, 2, 5);

-- Seats for Hall 'C'

CALL create_rows_of_seats(3, 1, 3);
CALL create_rows_of_seats(3, 2, 5);
CALL create_rows_of_seats(3, 3, 7);

-- Create Movies 

INSERT INTO movie (title) VALUES ('Once upon a time in America');
INSERT INTO movie (title) VALUES ('Casino');
INSERT INTO movie (title) VALUES ('Gladiator');
INSERT INTO movie (title) VALUES ('Heat');

-- Create Showtimes

INSERT INTO showtime (movie_id, scheduled_date) VALUES (1, NOW() + INTERVAL '1 day');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (1, NOW() + INTERVAL '2 day');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (1, NOW() + INTERVAL '3 day');

INSERT INTO showtime (movie_id, scheduled_date) VALUES (2, NOW() + INTERVAL '1 day' + INTERVAL '1 hour');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (2, NOW() + INTERVAL '2 day' + INTERVAL '1 hour');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (2, NOW() + INTERVAL '3 day' + INTERVAL '1 hour');

INSERT INTO showtime (movie_id, scheduled_date) VALUES (3, NOW() + INTERVAL '1 day');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (3, NOW() + INTERVAL '2 day');
INSERT INTO showtime (movie_id, scheduled_date) VALUES (3, NOW() + INTERVAL '3 day');

-- Create Customers

INSERT INTO customer (first_name, last_name) VALUES ('Artem', 'Kurylo');
INSERT INTO customer (first_name, last_name) VALUES ('John', 'Doe');
INSERT INTO customer (first_name, last_name) VALUES ('Jane', 'Doe');

-- Book Tickets

CALL book_ticket(1, 1, 1);
CALL book_ticket(2, 2, 1);
CALL book_ticket(3, 3, 1);

COMMIT;