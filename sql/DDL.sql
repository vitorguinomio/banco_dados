-- Active: 1750340161485@@127.0.0.1@5432@postgres

CREATE DATABASE nome_do_banco
WITH 
    OWNER = nome_do_dono
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TEMPLATE = template0;


CREATE TABLE paciente (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50),
    nasc DATE,
    sexo CHAR(1) DEFAULT 'M' CHECK (sexo IN ('M', 'F')),
    peso DECIMAL(5,2),
    altura DECIMAL(3,2),
    nacionalidade VARCHAR(50) DEFAULT 'Brasileiro'
);