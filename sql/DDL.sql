-- Active: 1750340161485@@127.0.0.1@5432@postgres

CREATE DATABASE pysql;

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