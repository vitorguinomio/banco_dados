-- Active: 1751900289641@@127.0.0.1@5432@escolar

CREATE TABLE alunos(
    id_aluno SERIAL,
    nome VARCHAR(70),
    e_mail VARCHAR(80),
    PRIMARY KEY(id_aluno)
);

CREATE TABLE notas (
    id_notas SERIAL PRIMARY KEY,
    ano_letivo INTEGER,
    id_aluno INTEGER,
    bimestre_1 NUMERIC(4,1),
    bimestre_2 NUMERIC(4,1),
    bimestre_3 NUMERIC(4,1),
    bimestre_4 NUMERIC(4,1),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno)
);
