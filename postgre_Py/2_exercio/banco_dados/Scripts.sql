-- Active: 1751900289641@@127.0.0.1@5432@reservadb

-- Automatizando o adcionar idbloco na tabela sala
CREATE OR REPLACE FUNCTION set_idbloco_from_nomebloco()
RETURNS TRIGGER AS 
$$
BEGIN
    SELECT idbloco INTO NEW.idbloco
    FROM bloco
    WHERE nomebloco = NEW.nomebloco
    AND statusdelete = FALSE;

    IF NEW.idbloco IS NULL THEN
        RAISE EXCEPTION 'Bloco com nome % nao encontrado ou esta incativo',  NEW.nomebloco;
        END IF;

        RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
-- trigger para automatizacao.
CREATE TRIGGER trigger_idbloco
BEFORE INSERT ON sala
FOR EACH ROW 
EXECUTE FUNCTION set_idbloco_from_nomebloco();


CREATE OR REPLACE FUNCTION set_idcurso_from_reserva()
RETURNS TRIGGER AS 
$$
BEGIN
    SELECT idbloco INTO NEW.idbloco
    FROM bloco
    WHERE nomebloco = NEW.nomebloco
    AND statusdelete = FALSE;

    IF NEW.idbloco IS NULL THEN
        RAISE EXCEPTION 'Bloco com nome % nao encontrado ou esta incativo',  NEW.nomebloco;
        END IF;

        RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;