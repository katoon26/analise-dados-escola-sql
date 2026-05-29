# analise-dados-escola-sql
Projeto de modelagem e análise de dadios de um sistema utilizando SQL

# 📊 Análise de Dados e Modelagem SQL: Sistema de Gestão Escolar

Seja bem-vindo ao meu projeto de portfólio de Análise de Dados! Neste repositório, apresento a modelagem e a carga de dados para um sistema de gestão escolar, além de consultas (queries) estratégicas focadas em responder empreendedores de negócio, como desempenho acadêmico e inclusão escolar.

---

## 🎯 Contexto do Projeto

O objetivo deste projeto é simular o banco de dados de uma instituição de ensino básico em 2026. A estrutura foi desenhada para conectar Alunos, Professores, Disciplinas, Turmas e Notas. 

Um grande diferencial deste modelo é a tabela de **Adaptações Curriculares**, criada para acompanhar os recursos pedagógicos utilizados por alunos que necessitam de suporte inclusivo (ex: tempo estendido, materiais concretos).

---

## 🗄️ Estrutura e Carga de Dados (DML)

Abaixo está o script utilizado para popular o banco de dados com dados fictícios para testes e análises:

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
-- ==========================================

🚀 Desafios e Consultas Analíticas (Queries)
Como Analista de Dados, propus três cenários reais que a gestão escolar precisaria extrair desse banco:
1. Boletim Geral da Turma (Uso de INNER JOIN)
Objetivo: Cruzar tabelas para exibir a listagem de notas de forma legível para a secretaria ou responsáveis.
-----------------------------------------------------------------------------------------------------
    SELECT 
        a.nome AS Aluno,
        d.nome_disciplina AS Disciplina,
        COALESCE(ac.recursos_utilizados, 'Sem adaptação necessária') AS Recursos_Utilizados
    FROM Alunos a
    LEFT JOIN Adaptacoes_Curriculares ac ON a.id_aluno = ac.id_aluno
    LEFT JOIN Disciplinas d ON ac.id_disciplina = d.id_disciplina;
-----------------------------------------------------------------------------------------------------
2. Média de Notas por Disciplina (Agregação com GROUP BY)
Objetivo: Fornecer à coordenação pedagógica uma visão geral de qual matéria está com desempenho abaixo do esperado.
-----------------------------------------------------------------------------------------------------
    SELECT 
        d.nome_disciplina AS Disciplina,
        ROUND(AVG(n.nota_obtida), 2) AS Media_Geral
    FROM Notas n
    INNER JOIN Avaliacoes av ON n.id_avaliacao = av.id_avaliacao
    INNER JOIN Disciplinas d ON av.id_disciplina = d.id_disciplina
    GROUP BY d.nome_disciplina;
-----------------------------------------------------------------------------------------------------
3. Relatório de Inclusão e Desempenho (Uso de LEFT JOIN)
Objetivo: Mapear quais alunos possuem adaptações curriculares ativas, garantindo que mesmo os alunos sem adaptações apareçam no relatório geral de monitoramento.
------------------------------------------------------------------------------------------------------
    SELECT 
    a.nome AS Aluno,
    d.nome_disciplina AS Disciplina,
    COALESCE(ac.recursos_utilizados, 'Sem adaptação necessária') AS Recursos_Utilizados
    FROM Alunos a
    LEFT JOIN Adaptacoes_Curriculares ac ON a.id_aluno = ac.id_aluno
    LEFT JOIN Disciplinas d ON ac.id_disciplina = d.id_disciplina;
----------------------------------------------------------------------------------------

**Tecnologias Utilizadas**
SQL / Bancos de Dados Relacionais
Lógica de Análise de Processos
📬 Contato
LinkedIn: [Everton Fernando de Jesus Gabriel](www.linkedin.com/in/everton-gabriel-57084124a)
E-mail: faceevt@gmail.com
