-- 03_alunos_sem_curso.sql
-- Lista os alunos que não estão matrículados em nenhum curso

SELECT
	a.nome
FROM estudo.alunos a
LEFT JOIN estudo.matriculas m ON a.id = m.aluno_id
WHERE m.id IS NULL;
