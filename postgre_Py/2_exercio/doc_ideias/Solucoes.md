# Ideias 
Esse documento e para registra ideias e coisas importantes durante o desenvolvimento do exercio permitindo maior facilidade na buscar de informacoes durante todo o processo

## Solucoes DQL

1. inserir o idbloco manuelmente no cadastro de salas
    1.Para resolver esse atraso decidir adcionar uma coluna.1

     nomebloco CHAR(1) NOT NULL,

     1.Que para o usuario vai facilitar, pois nao tera que adcionar id do bloco e sim selecionar o bloco e de acordo com esse bloco selecionado ela vai fazer uma busca por meio de uma function para achar o id e prencher a coluna idbloco.1

                -- Function necessaria para buscar e retorna o idbloco
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
             
            -- criando a trigger que vai ser solta no momento do insert sala
            CREATE TRIGGER trigger_idbloco
            BEFORE INSERT ON sala
            FOR EACH ROW 
            EXECUTE FUNCTION set_idbloco_from_nomebloco();


2.
