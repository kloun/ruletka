--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: updateuserraiting(); Type: FUNCTION; Schema: public; Owner: me
--

CREATE FUNCTION updateuserraiting() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
	update users set raiting=raiting+NEW.points where id=NEW.userid;
	return NULL;
END; $$;


ALTER FUNCTION public.updateuserraiting() OWNER TO me;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: games; Type: TABLE; Schema: public; Owner: me
--

CREATE TABLE games (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    userid integer NOT NULL,
    points integer NOT NULL,
    CONSTRAINT games_points_check CHECK ((points = ANY (ARRAY[3, 1, '-3'::integer])))
);


ALTER TABLE games OWNER TO me;

--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: me
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE games_id_seq OWNER TO me;

--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: me
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: games_userid_seq; Type: SEQUENCE; Schema: public; Owner: me
--

CREATE SEQUENCE games_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE games_userid_seq OWNER TO me;

--
-- Name: games_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: me
--

ALTER SEQUENCE games_userid_seq OWNED BY games.userid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: me
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(200),
    regdate timestamp without time zone DEFAULT now(),
    raiting integer DEFAULT 0 NOT NULL,
    CONSTRAINT users_id_check CHECK ((id >= 0))
);


ALTER TABLE users OWNER TO me;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: me
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO me;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: me
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: me
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: games userid; Type: DEFAULT; Schema: public; Owner: me
--

ALTER TABLE ONLY games ALTER COLUMN userid SET DEFAULT nextval('games_userid_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: me
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: me
--

COPY games (id, date, userid, points) FROM stdin;
\.


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: me
--

SELECT pg_catalog.setval('games_id_seq', 831, true);


--
-- Name: games_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: me
--

SELECT pg_catalog.setval('games_userid_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: me
--

COPY users (id, name, regdate, raiting) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: me
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: me
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: me
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: games uprainting; Type: TRIGGER; Schema: public; Owner: me
--

CREATE TRIGGER uprainting AFTER INSERT ON games FOR EACH ROW EXECUTE PROCEDURE updateuserraiting();


--
-- Name: games games_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: me
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_userid_fkey FOREIGN KEY (userid) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

