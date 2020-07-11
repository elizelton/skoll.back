-- SEQUENCE: public."Usuario_ID_seq"

-- DROP SEQUENCE public."Usuario_ID_seq";

CREATE SEQUENCE public."Usuario_Id_seq"
    INCREMENT 1
    START 4
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."Usuario_Id_seq"
    OWNER TO postgres;
    
-- Table: public."Usuario"

-- DROP TABLE public."Usuario";

CREATE TABLE public."Usuario"
(
    "Situacao" boolean NOT NULL,
    "Senha" text COLLATE pg_catalog."default" NOT NULL,
    "Nome" text COLLATE pg_catalog."default",
    "Id" integer NOT NULL DEFAULT nextval('"Usuario_Id_seq"'::regclass),
    "Login" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT id_pk PRIMARY KEY ("Id")
)

TABLESPACE pg_default;

ALTER TABLE public."Usuario"
    OWNER to postgres;