-- Active: 1751900289641@@127.0.0.1@5432@peso

/*CREATE DATABASE nome_do_banco
WITH 
    OWNER = nome_do_dono
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TEMPLATE = template0; */


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

CREATE TABLE habito (
    id SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id),
    fumante BOOLEAN,
    etilista BOOLEAN,
    pratica_atividade BOOLEAN,
    sono_media_horas NUMERIC(3,1),
    atualizacao DATE DEFAULT CURRENT_DATE
);


CREATE TABLE pressao_glicose (
    id SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id),
    data_registro DATE DEFAULT CURRENT_DATE,
    pressao_sistolica INT,
    glicose_mg_dl DECIMAL(5,2)
);
