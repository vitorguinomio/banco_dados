-- Active: 1751900289641@@127.0.0.1@5432@pl_pg
-- Estrutura de uma Function no PLGSQL



-- caso a funcao ja exista eu quero atualizar ela basta colocar (OR REPLACE ) depois de CREATEA.
CREATE FUNCTION olaMundo() RETURNS varchar AS
$$
DECLARE
    msg VARCHAR := 'Ola, mundo!'; 
BEGIN
    RETURN msg;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION olaMundo (msg varchar) RETURNS varchar AS 
$$
BEGIN
    return msg;
END;
$$
LANGUAGE plpgsql;


SELECT olaMundo ('Ola, vitor')





-- Criacao de funcoes, com parametros

CREATE TABLE professor (
    id  SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    dt_nasc DATE,
    salario NUMERIC
);

CREATE OR REPLACE FUNCTION adcionaProfessor (nome varchar, dt_nasc date, salario numeric)
RETURNS VOID AS
$$
BEGIN
    --Vou inserir os dados na tabela professor
    INSERT INTO professor (nome, dt_nasc,salario)
    VALUES (nome,dt_nasc, salario);

END;
$$ LANGUAGE PLPGSQL;

SELECT adcionaProfessor ('Leso', '15/12/1990', 12000)

SELECT * FROM professor;




-- FUNCTION DE ENTRADA E SAIDA COM PARAMETROS
/*IN (opcional) faz a entrada de parametros
OUT faz saida 
INOUT para entrada e saida*/
-- com select sem from a funcao retorna uma lista
-- com from no select da funcao retorna em 1 tupla e cada uma categoria


INSERT INTO professor (
    nome, dt_nasc, salario
)VALUES
('Raul Seixas', '02/02/1978', 12150.34),
('Gil Gomes', '01/04/1962', 8642.60),
('Renata Costa', '02/05/1988', 1250.30),
('Renato Gil', '01/01/1997', 998.00),
('Pedro Silva', '03/05/2001', 3500),
('Raquel Souza', '29/10/1996', 2400),
('Borges Bento', '11/11/1990', 6700.34),
('Harry Potter', '01/04/1998', 998),
('Adélia Moura', '01/12/1986', 12150.34),
('Jimmy Page', '03/05/2001', 1200),
('Marco Aurélio', '03/12/2000', 998),
('Helena Silva', '02/01/1997', 998),
('Fábio Duarte', '29/10/1995', 3200),
('Mata Rocha', '03/12/2001', 3570),
('Maria Carla', '02/01/1997', 1998),
('Renato Feliz', '01/07/2001', 6789.34),
('Lucas Sávio', '29/10/2000', 3410);


-- functionpara mostra maior e menor e a media de salario

CREATE OR REPLACE