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

-- trigger para idbloco
CREATE TRIGGER trigger_idbloco
BEFORE INSERT ON sala
FOR EACH ROW 
EXECUTE FUNCTION set_idbloco_from_nomebloco();




CREATE OR REPLACE FUNCTION idcurso_from_reserva()
RETURNS TRIGGER AS
$$
DECLARE
    v_prefixo TEXT;
BEGIN
    v_prefixo := LEFT(NEW.codturma, 3);

    SELECT t.idcurso INTO NEW.idcurso
    FROM turma t
    WHERE LEFT(t.codturma, 3) = v_prefixo
    LIMIT 1;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_idcurso
BEFORE INSERT ON reserva
FOR EACH ROW 
EXECUTE FUNCTION idcurso_from_reserva();








-- Criando a função da trigger para validar idsala
CREATE OR REPLACE FUNCTION validate_idsala()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o idsala existe e não está deletado
    IF NOT EXISTS (
        SELECT 1 FROM sala
        WHERE idsala = NEW.idsala
        AND statusdelete = FALSE
    ) THEN
        RAISE EXCEPTION 'Sala com idsala % não encontrada ou está inativa.', NEW.idsala;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criando a trigger
CREATE TRIGGER trigger_validate_idsala
BEFORE INSERT ON reservasala
FOR EACH ROW
EXECUTE FUNCTION validate_idsala();




