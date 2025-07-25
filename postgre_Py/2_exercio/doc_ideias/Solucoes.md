# Ideias 
Este documento serve para registrar ideias e informações importantes durante o desenvolvimento do exercício, permitindo maior facilidade na busca de dados ao longo de todo o processo.

## Solucoes DQL

### Saber o idbloco
1. inserir o idbloco manuelmente no cadastro de salas
    1.Para resolver esse atraso decidir adcionar uma coluna.1

     nomebloco CHAR(1) NOT NULL,

    3. Isso facilita para o usuário, pois ele não precisará inserir diretamente o id do bloco, e sim apenas selecionar o nome do bloco. A partir disso, uma function fará a busca pelo idbloco correspondente e preencherá automaticamente o campo idbloco.

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

### Reservas trabalhoso

Para fazer uma reserva, são necessários vários INSERTs no banco. Para facilitar os testes e simulações, foi criada a função inserir_reserva.

Um dos maiores problemas nas simulações era a necessidade constante de fornecer os IDs (como o idsala). Para tornar as simulações mais realistas, foram criadas triggers e functions que automatizam esse processo.

📂 O código está na pasta:
/home/guinomio/banco_dados/postgre_Py/2_exercio/banco_dados/reserva02.sql

O codigo esta na pasta banco de dados tem 2 versoes. 

1. A primeira versão foi criada com o objetivo de testar a ideia e verificar se os dados estavam sendo inseridos corretamente.

2. A segunda versão foi feita para melhorar principalmente a questão do idsala, que ainda precisava ser passado manualmente. Nela, foi adicionada uma busca automática pela sala com base no número e no bloco informados.

