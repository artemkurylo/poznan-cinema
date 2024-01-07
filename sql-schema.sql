-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.movie
(
    id serial NOT NULL,
    title character varying(256) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.showtime
(
    id serial NOT NULL,
    movie_id bigint NOT NULL,
    scheduled_date timestamp with time zone NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.ticket
(
    id serial NOT NULL,
    showtime_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    seat_id bigint,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.customer
(
    id bigint NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.cinema
(
    id serial NOT NULL,
    cinema_address_id bigint NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.cinema_address
(
    id serial NOT NULL,
    city character varying(255) NOT NULL,
    street character varying(255) NOT NULL,
    zip_code character varying(255),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.hall
(
    id serial NOT NULL,
    letter character(1) NOT NULL,
    cinema_id bigint NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.seat
(
    id serial NOT NULL,
    hall_id bigint NOT NULL,
    "column" smallint NOT NULL,
    "row" smallint NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT unique_seat_per_hall UNIQUE ("column", "row", hall_id)
);

ALTER TABLE IF EXISTS public.showtime
    ADD CONSTRAINT fk_movie_id FOREIGN KEY (movie_id)
    REFERENCES public.movie (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.ticket
    ADD CONSTRAINT fk_showtime_id FOREIGN KEY (showtime_id)
    REFERENCES public.showtime (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.ticket
    ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
    REFERENCES public.customer (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.ticket
    ADD CONSTRAINT fk_seat_id FOREIGN KEY (seat_id)
    REFERENCES public.seat (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.cinema
    ADD CONSTRAINT fk_cinema_address_id FOREIGN KEY (cinema_address_id)
    REFERENCES public.cinema_address (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.hall
    ADD CONSTRAINT fk_cinema_id FOREIGN KEY (cinema_id)
    REFERENCES public.cinema (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.seat
    ADD CONSTRAINT fk_hall_id FOREIGN KEY (hall_id)
    REFERENCES public.hall (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;