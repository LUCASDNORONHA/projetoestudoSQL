-- 01_alunos_cursos.sql
-- Lista todos os alunos com os cursos em que estão matriculados
-- Inclui a data da matrícula

SELECT
	a.nome AS aluno,
	c.nome AS curso,
	m.data_matricula
FROM estudo.alunos a
JOIN estudo.matriculas m ON a.id = m.aluno_id
JOIN estudo.cursos c ON c.id = m.curso_id;
