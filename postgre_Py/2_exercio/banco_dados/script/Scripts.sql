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



-- Procura idcurso somente com o codigo turma e nao ter que inserir manuelmente
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
-- trigger que vai usar a function de idcurso
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
-- Criando a trigger para garantir que a sala sendo reservada esta ativa.
CREATE TRIGGER trigger_validate_idsala
BEFORE INSERT ON reservasala
FOR EACH ROW
EXECUTE FUNCTION validate_idsala();




--Visualizar reservas
    WITH dias_marcados AS (
        SELECT idreservasala, 'segunda' AS dia FROM diasemana WHERE segunda = TRUE
        UNION
        SELECT idreservasala, 'terca' FROM diasemana WHERE terca = TRUE
        UNION
        SELECT idreservasala, 'quarta' FROM diasemana WHERE quarta = TRUE
        UNION
        SELECT idreservasala, 'quinta' FROM diasemana WHERE quinta = TRUE
        UNION
        SELECT idreservasala, 'sexta' FROM diasemana WHERE sexta = TRUE
        UNION
        SELECT idreservasala, 'sabado' FROM diasemana WHERE sabado = TRUE
        UNION
        SELECT idreservasala, 'domingo' FROM diasemana WHERE domingo = TRUE
    ),
    periodos_marcados AS (
        SELECT idreservasala, 'primeiro' AS periodo FROM periodo WHERE primeiro = TRUE
        UNION
        SELECT idreservasala, 'segundo' FROM periodo WHERE segundo = TRUE
        UNION
        SELECT idreservasala, 'terceiro' FROM periodo WHERE terceiro = TRUE
        UNION
        SELECT idreservasala, 'quarto' FROM periodo WHERE quarto = TRUE
        UNION
        SELECT idreservasala, 'integral' FROM periodo WHERE integral = TRUE
    ),
    dias_agrupados AS (
        SELECT dm.idreservasala, STRING_AGG(dm.dia, ', ' ORDER BY dm.dia) AS dias
        FROM dias_marcados dm
        GROUP BY dm.idreservasala
    ),
    periodos_agrupados AS (
        SELECT pm.idreservasala, STRING_AGG(pm.periodo, ', ' ORDER BY pm.periodo) AS periodos
        FROM periodos_marcados pm
        GROUP BY pm.idreservasala
    )
    SELECT
        d.idreservasala, -- Qualificando explicitamente idreservasala com o alias 'd'
        d.dias,
        p.periodos,
        r.responsavel
    FROM dias_agrupados d 
    LEFT JOIN periodos_agrupados p ON d.idreservasala = p.idreservasala
    LEFT JOIN reservasala r ON d.idreservasala = r.idreservasala;