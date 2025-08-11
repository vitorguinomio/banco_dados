SELECT * FROM paciente LIMIT 300;

SELECT COUNT(*) FROM paciente;

SELECT sexo,nome,id
FROM paciente
WHERE sexo = 'F';

SELECT sexo,nome,id
FROM paciente
WHERE sexo = 'M';

SELECT sexo,id,altura, nome 
FROM paciente
WHERE nome = 'Vitor' AND sobrenome = 'Sousa';

SELECT nacionalidade, COUNT(*) FROM paciente GROUP BY nacionalidade;

SELECT nacionalidade, AVG(peso / (altura * altura)) AS imc_medio, COUNT(*) AS total_pacientes 
FROM paciente 
GROUP BY nacionalidade;