CREATE TABLE estudo.matriculas (
	id SERIAL PRIMARY KEY,
	aluno_id INT NOT NULL,
	curso_id INT NOT NULL,
	data_matricula DATE DEFAULT CURRENT_DATE
);
