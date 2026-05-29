-- ==========================================
-- 1. POPULANDO A TABELA DE ALUNOS
-- ==========================================
INSERT INTO Alunos (id_aluno, nome, data_nascimento, matricula) VALUES
(1, 'Mariana Silva', '2015-04-12', 'MAT202601'),
(2, 'Lucas Santos', '2015-08-23', 'MAT202602'),
(3, 'Beatriz Oliveira', '2015-01-05', 'MAT202603'),
(4, 'Gabriel Rodrigues', '2015-11-30', 'MAT202604'),
(5, 'Ana Clara Costa', '2015-06-18', 'MAT202605');

-- ==========================================
-- 2. POPULANDO A TABELA DE PROFESSORES
-- ==========================================
INSERT INTO Professores (id_professor, nome, specialty) VALUES
(101, 'Carlos Alberto', 'Matemática'),
(102, 'Juliana Mendes', 'Artes'),
(103, 'Fernanda Lima', 'História');

-- ==========================================
-- 3. POPULANDO A TABELA DE DISCIPLINAS
-- ==========================================
INSERT INTO Disciplinas (id_disciplina, nome_disciplina) VALUES
(1, 'Matemática'),
(2, 'Artes'),
(3, 'História');

-- ==========================================
-- 4. POPULANDO A TABELA DE TURMAS
-- ==========================================
INSERT INTO Turmas (id_turma, nome_turma, ano_letivo, turno) VALUES
(10, '6º Ano A', 2026, 'Manhã'),
(20, '6º Ano B', 2026, 'Tarde');

-- ==========================================
-- 5. POPULANDO AS MATRÍCULAS (Quem estuda onde)
-- ==========================================
-- Alunos 1, 2 e 3 vão para o 6º Ano A
-- Alunos 4 e 5 vão para o 6º Ano B
INSERT INTO Matrículas (id_turma, id_aluno) VALUES
(10, 1),
(10, 2),
(10, 3),
(20, 4),
(20, 5);

-- ==========================================
-- 6. POPULANDO AS AVALIAÇÕES (O diário do professor)
-- ==========================================
INSERT INTO Avaliacoes (id_avaliacao, id_turma, id_disciplina, descricao, peso) VALUES
(501, 10, 1, 'Prova de Frações', 10.0),      -- Matemática no 6º Ano A
(502, 10, 2, 'Trabalho de Pintura', 10.0),   -- Artes no 6º Ano A
(503, 20, 1, 'Prova de Frações', 10.0),      -- Matemática no 6º Ano B
(504, 20, 2, 'Trabalho de Pintura', 10.0);   -- Artes no 6º Ano B

-- ==========================================
-- 7. POPULANDO AS NOTAS DOS ALUNOS
-- ==========================================
INSERT INTO Notas (id_nota, id_aluno, id_avaliacao, nota_obtida) VALUES
-- Notas da Prova de Matemática (6º Ano A)
(1001, 1, 501, 8.5),  -- Mariana tirou 8.5
(1002, 2, 501, 7.0),  -- Lucas tirou 7.0
(1003, 3, 501, 9.5),  -- Beatriz tirou 9.5

-- Notas do Trabalho de Artes (6º Ano A)
(1004, 1, 502, 9.0),
(1005, 2, 502, 10.0),
(1006, 3, 502, 8.0),

-- Notas da Prova de Matemática (6º Ano B)
(1007, 4, 503, 5.5),  -- Gabriel tirou 5.5 (precisa de atenção!)
(1008, 5, 503, 8.0),

-- Notas do Trabalho de Artes (6º Ano B)
(1009, 4, 504, 7.5),
(1010, 5, 504, 9.0);

-- ==========================================
-- 8. POPULANDO AS ADAPTAÇÕES CURRICULARES (Inclusão)
-- ==========================================
INSERT INTO Adaptacoes_Curriculares (id_adaptacao, id_aluno, id_disciplina, recursos_utilizados, data_registro) VALUES
(1, 2, 1, 'Tempo estendido para realização da prova e uso de material concreto.', '2026-03-10');
======================================================================================================
SELECT 
    a.nome AS Aluno,
    t.nome_turma AS Turma,
    d.nome_disciplina AS Disciplina,
    av.descricao AS Avaliacao,
    n.nota_obtida AS Nota
FROM Notas n
INNER JOIN Alunos a ON n.id_aluno = a.id_aluno
INNER JOIN Avaliacoes av ON n.id_avaliacao = av.id_avaliacao
INNER JOIN Disciplinas d ON av.id_disciplina = d.id_disciplina
INNER JOIN Turmas t ON av.id_turma = t.id_turma
ORDER BY t.nome_turma, d.nome_disciplina, n.nota_obtida DESC;


===================================================================================================
SELECT 
    d.nome_disciplina AS Disciplina,
    ROUND(AVG(n.nota_obtida), 2) AS Media_Geral
FROM Notas n
INNER JOIN Avaliacoes av ON n.id_avaliacao = av.id_avaliacao
INNER JOIN Disciplinas d ON av.id_disciplina = d.id_disciplina
GROUP BY d.nome_disciplina;

==================================================================================================
SELECT 
    a.nome AS Aluno,
    d.nome_disciplina AS Disciplina,
    COALESCE(ac.recursos_utilizados, 'Sem adaptação necessária') AS Recursos_Utilizados
FROM Alunos a
LEFT JOIN Adaptacoes_Curriculares ac ON a.id_aluno = ac.id_aluno
LEFT JOIN Disciplinas d ON ac.id_disciplina = d.id_disciplina;

==================================================================================================
