-- Active: 1755255188134@@127.0.0.1@5432@aplicalist
SELECT * FROM usuario;

SELECT * FROM treino;

SELECT * FROM exercicio;

SELECT * FROM assinatura;


SELECT 
    u.idusuario,
    u.nome_completo,
    t.idtreino,
    t.tipo_treino,
    t.grupo_muscular_treino,
    t.descricao AS descricao_treino,
    e.idexercicio,
    e.nome_exercicio,
    e.grupo_muscular,
    e.descricao AS descricao_exercicio,
    te.series,
    te.repeticoes,
    te.descanso,
    te.ordem
FROM usuario u
JOIN treino_user tu ON u.idusuario = tu.idusuario
JOIN treino t ON tu.idtreino = t.idtreino
JOIN treino_exercicio te ON t.idtreino = te.idtreino
JOIN exercicio e ON te.idexercicio = e.idexercicio
WHERE u.idusuario = 4
ORDER BY t.idtreino, te.ordem;


