-- Chave estrangeiras
ALTER TABLE estudo.matriculas
	ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES estudo.alunos(id);

ALTER TABLE estudo.matriculas
	ADD CONSTRAINT fk_curso FOREIGN KEY (curso_id) REFERENCES estudo.cursos(id);

-- Garantir que não existam duplicadas de matrículas
ALTER TABLE estudo.matriculas
	ADD CONSTRAINT uq_matricula UNIQUE (aluno_id, curso_id);
