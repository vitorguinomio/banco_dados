-- Active: 1752684971431@@127.0.0.1@5432@lindo
-- Aprendendo a usar nome_da_tabela%ROWTYPE.
-- ele vai gera uma tabela imaginaria que teria os mesmo tipo da tabela selecionada.
-- Record tipo generico de uma tupla
-- '%', rec.title  --> pode ser usado para se referir a uma variavel que sera mostrada

CREATE TABLE DEPARTAMENTO (
 nro_depto INTEGER, 
 nome_depto VARCHAR(20),
 PRIMARY KEY (nro_depto)
 );
 
CREATE TABLE EMPREGADO (
 cod_emp INTEGER, 
 p_nome VARCHAR(15) NOT NULL, 
 sobrenome VARCHAR(30), 
 dt_niver DATE, 
 end_emp VARCHAR(50),
 sexo CHAR, 
 salario NUMERIC, 
 cod_supervisor INTEGER NOT NULL,
 nro_depto INTEGER NOT NULL,
 PRIMARY KEY (cod_emp),
 FOREIGN KEY (cod_supervisor) REFERENCES EMPREGADO(cod_emp) ON DELETE CASCADE,
 FOREIGN KEY (nro_depto) REFERENCES DEPARTAMENTO(nro_depto) ON DELETE CASCADE
 );
 
/* INSERÇÃO DE DADOS NAS TABELAS */
INSERT INTO DEPARTAMENTO(nro_depto, nome_depto) VALUES (1, 'Papaleguas');
INSERT INTO DEPARTAMENTO(nro_depto, nome_depto) VALUES (2, 'Frajola');
INSERT INTO DEPARTAMENTO(nro_depto, nome_depto) VALUES (3, 'Piu Piu');

INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (1, 'Carla', 'Perez', '12-12-1988', 'Rua X, 123', 'F', 20000.50, 1, 1);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (2, 'Carlos', 'Magno', '12-05-1978', 'Rua X, 200', 'M', 1500, 1, 1);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (3, 'João', 'Silva', '07/02/1990', 'Rua Y, 200', 'M', 2730.83, 1, 2);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (9, 'Carla', 'Perez', '12-12-1988', 'Rua X, 123', 'F', 20000.50, 1, 1);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (8, 'Carlos', 'Magno', '12-05-1978', 'Rua X, 200', 'M', 1500, 1, 1);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (7, 'João', 'Silva', '07/02/1990', 'Rua Y, 200', 'M', 2730.83, 1, 2);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (4, 'Manu', 'Gomez', '05-12-1998', 'Rua X, 100', 'F', 25000.50, 3, 2);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (5, 'Miguel', 'Ruan', '01-12-2000', 'Rua T, 200', 'M', 2500, 1, 3);
INSERT INTO EMPREGADO (cod_emp, p_nome, sobrenome, dt_niver, end_emp, sexo, salario, cod_supervisor, nro_depto) VALUES (6, 'Joana', 'Souza', '07/04/1995', 'Rua ASX, 1345', 'F', 3130, 3, 2);


CREATE OR REPLACE FUNCTION mostraFunc () RETURNS void
AS 
$$
DECLARE
    tupla record;
    cont INTEGER :=1;
BEGIN
    for tupla in
        SELECT * FROM empregado order by cod_emp
    loop
        raise notice 'Funcionário %- Código: % | Nome: % %', cont, tupla.cod_emp, tupla.p_nome, tupla.sobrenome;
        cont := cont +1;
    end loop;
END;
$$ LANGUAGE PLPGSQL;

SELECT mostraFunc();



-- Arrawys , não precisa ter tamanho pré-definido
/*
    nome_array tipo[]
    Você inserir em cada elemento e começar a contagem do 0
    array [0] = 8;
    array [1] = 9;
    ou em chaves 
    array = {8,9}
*/
CREATE OR REPLACE FUNCTION aniversariantes_mes(mes int) RETURNS INT[] AS
$$
DECLARE
    res INT[];
    tupla record;
    mes_aniversario int;
    i int := 0;
BEGIN
    for tupla in select * from empregado
    LOOP
        select extract (MONTH from tupla.dt_niver) into  mes_aniversario;
        if (mes_aniversario = mes) then
            res[i] := tupla.cod_emp;
            i := i + 1;
        end if;
    END loop;
    return res;
END;
$$ LANGUAGE PLPGSQL;

select aniversariantes_mes(12);