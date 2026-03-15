-- 001_add_telefone_alunso.sql
-- Adiciona uma coluna telefone na tabela alunos

ALTER TABLE estudo.alunos
ADD COLUMN telefone VARCHAR(20);

COMMENT ON COLUMN estudo.alunos.telefone IS 'Telefone do aluno, no formato (xx)XXXXX-XXXX';

