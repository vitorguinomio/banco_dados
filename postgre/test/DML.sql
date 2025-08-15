-- Active: 1755255188134@@127.0.0.1@5432@aplicalist
-- Inserindo usuário
INSERT INTO usuario (nome_completo, email, senha, Quant_treino, data_nasc)
VALUES ('João da Silva', 'joao.silva@example.com', MD5('senha123'), 1, '1990-05-20');

-- Inserindo assinatura
INSERT INTO assinatura (plano, data_inicio, data_fim, status, descricao)
VALUES ('Mensal', NOW(), NOW() + INTERVAL '30 days', 'ativa', 'Plano mensal básico');

-- Inserindo treino
INSERT INTO treino (tipo_treino, grupo_muscular_treino, descricao)
VALUES ('Hipertrofia', 'Peito e Tríceps', 'Treino voltado para ganho de massa muscular');

-- Inserindo exercícios
INSERT INTO exercicio (nome_exercicio, grupo_muscular, descricao)
VALUES 
('Supino Reto', 'Peito', 'Exercício para desenvolver o peitoral maior'),
('Supino Inclinado', 'Peito', 'Enfatiza a parte superior do peitoral'),
('Tríceps Pulley', 'Tríceps', 'Exercício para o tríceps com polia');

-- Associando exercícios ao treino
INSERT INTO treino_exercicio (idexercicio, series, repeticoes, descanso, ordem)
VALUES 
(7, '4', '10-12', '60s', 1),
(8, '3', '10', '60s', 2),
(9, '3', '12', '45s', 3);

-- Ligando o treino ao usuário
INSERT INTO treino_user (idusuario, idtreino)
VALUES ('4', '4');






-- Inserindo um usuário
INSERT INTO usuario (nome_completo, email, senha, Quant_treino, data_nasc)
VALUES ('Carlos Souza', 'carlos@example.com', MD5('senha123'), 1, '1992-07-15');

-- Pegar o ID do usuário inserido
-- (suponha que o ID gerado foi 1, ajuste se necessário)

-- Inserindo um treino
INSERT INTO treino (tipo_treino, grupo_muscular_treino, descricao)
VALUES ('Hipertrofia', 'Peito e Tríceps', 'Treino voltado para ganho de massa muscular');

-- Suponha que o ID do treino foi 1

-- Associando o treino ao usuário
INSERT INTO treino_user (idusuario, idtreino)
VALUES (5, 5);

-- Inserindo exercícios
INSERT INTO exercicio (nome_exercicio, grupo_muscular, descricao)
VALUES 
('Supino Reto', 'Peito', 'Exercício para desenvolver o peitoral maior'),
('Supino Inclinado', 'Peito', 'Trabalha a parte superior do peitoral'),
('Tríceps Pulley', 'Tríceps', 'Isolamento do tríceps com polia');

-- Suponha que os IDs dos exercícios são 1, 2 e 3

-- Associando exercícios ao treino (com o novo campo idtreino)
INSERT INTO treino_exercicio (idtreino, idexercicio, series, repeticoes, descanso, ordem)
VALUES 
(5, 13, '4', '10-12', '60s', 1),
(5, 14, '3', '10', '60s', 2),
(5, 15, '3', '12', '45s', 3);
