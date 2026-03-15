-- 02_cursos_num_alunos.sql
-- Mostra cada curso e o total de alunos matrículados


SELECT
	c.nome AS curso,
	COUNT(m.aluno_id) AS total_alunos
FROM estudo.cursos c
LEFT JOIN estudo.matriculas m ON c.id = m.curso_id
GROUP BY c.nome;
