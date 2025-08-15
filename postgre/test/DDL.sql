-- Active: 1755255188134@@127.0.0.1@5432@aplicalist
CREATE TABLE usuario (
    idusuario SERIAL PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL, -- md5 criptografia guardada aqui
    Quant_treino INT,
    data_nasc DATE,
    dthinsart TIMESTAMP DEFAULT NOW(),
    dthdelete TIMESTAMP NULL,
    CHECK (dthdelete >= dthinsart OR dthdelete IS NULL)
);

CREATE TABLE assinatura (
    idassinatura SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuario(idusuario),
    plano VARCHAR(50),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ativa',
    descricao VARCHAR(80)
);

CREATE TABLE treino (
    idtreino SERIAL PRIMARY KEY,
    tipo_treino VARCHAR(50) NOT NULL,
    grupo_muscular_treino VARCHAR(50) NOT NULL,
    descricao VARCHAR(200)
);

CREATE TABLE exercicio (
    idexercicio SERIAL PRIMARY KEY,
    nome_exercicio VARCHAR(80) NOT NULL,
    grupo_muscular VARCHAR(100),
    descricao VARCHAR(200)
);

CREATE TABLE treino_exercicio (
    idtreinoexerc SERIAL PRIMARY KEY,
    idtreino INT REFERENCES treino(idtreino),
    idexercicio INT REFERENCES exercicio(idexercicio),
    series VARCHAR(10),
    repeticoes VARCHAR(100),
    descanso VARCHAR(20),
    ordem INT
);

CREATE TABLE treino_user (
    idusertreino SERIAL PRIMARY KEY,
    idusuario INT REFERENCES usuario(idusuario),
    idtreino INT REFERENCES treino(idtreino)
);


