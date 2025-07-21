-- Active: 1752771415104@@127.0.0.1@5432@psql


/*São ações engatilhados que quando um certo evento acontece no banco de dados, para poder dispara a ação.
Podem ser eventos de INSERT , UPDATE e delete.
Os gatilhos podem ser feitas antes ou até mesmo depois do evento.
quando for atualizar colunas dever ser feito uma caracterização dos dados . colocando um NEW.nome_coluna (para novos dados), OLD.nome_coluna (para representa dados antigos )
*/


/* CREATE TRIGGER name
    {BEFORE | AFTER | INSTEAD OF} -- quando vai ser disparada (instead of = no ludar de)
    {event [or ... ] } ON table -- 1. especifica o evento de ser inserção , update ou ate delete
    [FROM referenced_table_name] -- referencia a tabela (posso especificar a column) ou ate mesmo em view
    [ FOR [ EACH ] { ROW | STATEMENT } ]  -- FOR EACH STATEMENT para cada linha uma transação / FOR EACH STATEMENT para cada comando esecutar uma transação
    EXECUTE PROCEDURE function_name ( arguments ) -- mostro o script que vai ser assionado apos cumprir os requisitos

1.evento pode ser um dentre: INSERT UPDATE [ OF column_name [, ... ]] DELETE TRUNCATE
*/

CREATE TABLE Produto
(
 cod_prod INT PRIMARY KEY,
 descricao VARCHAR(50) UNIQUE,
 qtde_disponivel INT NOT NULL DEFAULT 0
);

INSERT INTO Produto VALUES (1, 'Feijão', 10);
INSERT INTO Produto VALUES (2, 'Arroz', 5);
INSERT INTO Produto VALUES (3, 'Farinha', 15);

CREATE TABLE ItensVenda
(
 cod_venda  INT,
 id_produto VARCHAR(3),
 qtde_vendida INT,
 FOREIGN KEY (cod_venda) REFERENCES Produto(cod_prod) ON DELETE CASCADE
);