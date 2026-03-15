-- 002_add_carga_horaria_cursos.sql
-- Adiciona coluna carga_horaria na tabela cursos

ALTER TABLE estudo.cursos
ADD COLUMN carga_horaria INT DEFAULT 60;

COMMENT ON COLUMN estudo.cursos.carga_horaria IS 'Carga horária do curso em horas';

