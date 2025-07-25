-- Active: 1751900289641@@127.0.0.1@5432@reservadb
SELECT * FROM turma LIMIT 300;

SELECT * FROM sala;

SELECT * FROM usuario;

SELECT
    r.datainicial,
    r.datafinal,
    r.codturma,
    rs.turno,
    rs.responsavel,
    rs.statusreserva,
    s.numerosala,
    p.primeiro,
    p.segundo,
    p.terceiro,
    p.quarto,
    p.integral,
    d.segunda,
    d.terca,
    d.quarta,
    d.quinta,
    d.sexta,
    d.sabado,
    d.domingo
FROM reserva r 
LEFT JOIN reservasala rs ON rs.idreserva = r.idreserva
LEFT JOIN sala s ON rs.idsala = s.idsala
LEFT JOIN diasemana d ON rs.idreservasala = d.idreservasala
LEFT JOIN periodo p ON rs.idreservasala = p.idreservasala
WHERE rs.statusreserva = TRUE;





