-- SCRIPT DE RESET
DROP DATABASE IF EXISTS projeto_db_escola;
CREATE DATABASE projeto_db_escola;
USE projeto_db_escola;

-- FASE 1: DDL - CRIAÇÃO DE TABELAS 

-- MÓDULO FINANCEIRO
  
CREATE TABLE tb_mensalidade (
  matricula INT NOT NULL,
  valor DECIMAL(10,2),
  mes_referencia DATE,
  status ENUM('Ativo','Inativo','Cancelado','Nao_pago'),
  PRIMARY KEY (mes_referencia, matricula)
);

CREATE TABLE tb_folha_pagamento (
  id_folha INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  salario_atual DECIMAL(10,2) NOT NULL,
  descontos ENUM('descontado','nenhum') DEFAULT 'nenhum' COMMENT 'Checar se houver descontos',
  data_pagamento  DATE NOT NULL
);

CREATE TABLE tb_historico_pagamento (
  id_historico_pagamento INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  salario_anterior DECIMAL(10,2) NOT NULL COMMENT 'Valor antes do reajuste',
  salario_atual DECIMAL(10,2) NOT NULL CHECK (salario_atual > 0),
  data_alteracao DATE NOT NULL,
  data_pagamento DATE NOT NULL
);

CREATE TABLE tb_historico_valor_hora (
  id_historico_valorh INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  valor_hora DECIMAL(10,2) NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE
);

-- MÓDULO ACADÊMICO

CREATE TABLE tb_pessoa (
  cpf CHAR(11) PRIMARY KEY,
  primeiro_nome VARCHAR(50) NOT NULL,
  sobrenome VARCHAR(60)  NOT NULL,
  data_nasc DATE,
  genero ENUM('Masculino','Feminino','Outro')
);

CREATE TABLE tb_formacao (
  id_formacao INT PRIMARY KEY AUTO_INCREMENT,
  nome_formacao VARCHAR(255) NOT NULL
);

CREATE TABLE tb_disciplina (
  id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
  nome_disciplina ENUM('Portugues','Matematica','Ciencias','Historia','Geografia','Ingles','Artes','Educacao_Fisica') NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  sala INT COMMENT 'Temporario: deve migrar para tb_turma quando criada',
  carga_horaria_semanal  INT  NOT NULL
);

CREATE TABLE tb_matricula (
  matricula INT NOT NULL,
  id_disciplina INT NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  status ENUM('Ativo','Inativo','Cancelado'),
  PRIMARY KEY (matricula, id_disciplina)
);

CREATE TABLE tb_aluno (
  cpf CHAR(11) NOT NULL UNIQUE,
  matricula INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE tb_professor_disciplina (
  n_contratacao INT NOT NULL,
  id_disciplina INT NOT NULL,
  carga_horaria_professor INT NOT NULL,
  PRIMARY KEY (n_contratacao, id_disciplina)
);

CREATE TABLE tb_nota (
  matricula INT NOT NULL,
  id_disciplina INT NOT NULL,
  tipo ENUM('Prova','Trabalho','Recuperacao') NOT NULL,
  nota DECIMAL(4,2) NOT NULL CHECK (nota >= 0 AND nota <= 10),
  data_avaliacao  DATE,
  PRIMARY KEY (matricula, id_disciplina, tipo)
);

CREATE TABLE tb_falta (
  id_falta INT  PRIMARY KEY AUTO_INCREMENT,
  matricula INT  NOT NULL,
  id_disciplina INT  NOT NULL,
  data_falta DATE NOT NULL,
  justificada ENUM('Sim','Nao') DEFAULT 'Nao'
);

-- MÓDULO RH
   
CREATE TABLE tb_departamento (
  id_departamento INT  PRIMARY KEY AUTO_INCREMENT,
  departamento ENUM('Direcao','Coordenacao','Secretaria_ADM','Financeiro','Zeladoria','Inspetoria_Seguranca','Biblioteca','Recursos_Humanos') NOT NULL
);

CREATE TABLE tb_cargo (
  id_cargo INT PRIMARY KEY AUTO_INCREMENT,
  nome_cargo VARCHAR(255) NOT NULL,
  tipo_cargo ENUM('Docente','Administrativo','Operacional') NOT NULL
);

CREATE TABLE tb_funcionario_cargo (
  id_func_cargo INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  id_cargo INT NOT NULL,
  id_departamento INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE
);

CREATE TABLE tb_funcionario (
  n_contratacao INT PRIMARY KEY AUTO_INCREMENT,
  cpf CHAR(11) NOT NULL UNIQUE,
  status_funcionario ENUM('Ativado','Desativado'),
  dt_admissao DATE,
  dt_desligamento DATE,
  id_formacao INT
);

CREATE TABLE tb_ponto (
  id_ponto INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  data_ponto DATE,
  hora_entrada TIME,
  hora_saida TIME
);

CREATE TABLE tb_ferias (
  id_ferias INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  num_ferias INT,
  data_inicio DATE,
  data_fim DATE,
  status_ferias ENUM('Agendado','EmAndamento','Concluido','Cancelado') NOT NULL DEFAULT 'Agendado'
);

CREATE TABLE tb_afastamento (
  id_afastamento INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  motivo TEXT,
  status_afastamento ENUM('EmAndamento','Concluido'),
  data_inicio DATE,
  data_fim DATE
);

CREATE TABLE tb_treinamento (
  id_treinamento INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  tipo_treinamento VARCHAR(255),
  carga_horaria TIME,
  data_conclusao DATE
);

CREATE TABLE tb_telefone (
  ddd CHAR(3) NOT NULL,
  numero CHAR(11) NOT NULL,
  cpf CHAR(11) NOT NULL,
  PRIMARY KEY (ddd, numero, cpf)
);

CREATE TABLE tb_email (
  id_email INT PRIMARY KEY AUTO_INCREMENT,
  endereco_email VARCHAR(255) NOT NULL UNIQUE,
  cpf CHAR(11) NOT NULL
);

-- CHAVES ESTRANGEIRAS 

-- RECURSOS HUMANOS
ALTER TABLE tb_funcionario ADD CONSTRAINT fk_func_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf);
ALTER TABLE tb_funcionario ADD CONSTRAINT fk_func_formacao FOREIGN KEY (id_formacao) REFERENCES tb_formacao(id_formacao);
ALTER TABLE tb_funcionario_cargo ADD CONSTRAINT fk_hist_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_funcionario_cargo ADD CONSTRAINT fk_hist_cargo FOREIGN KEY (id_cargo) REFERENCES tb_cargo(id_cargo);
ALTER TABLE tb_funcionario_cargo ADD CONSTRAINT fk_hist_dept FOREIGN KEY (id_departamento) REFERENCES tb_departamento(id_departamento);
ALTER TABLE tb_ponto ADD CONSTRAINT fk_ponto_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_ferias ADD CONSTRAINT fk_ferias_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_afastamento ADD CONSTRAINT fk_afast_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_treinamento  ADD CONSTRAINT fk_trein_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);

-- FINANCEIRO
ALTER TABLE tb_folha_pagamento ADD CONSTRAINT fk_folha_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_historico_pagamento ADD CONSTRAINT fk_histpag_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_historico_valor_hora ADD CONSTRAINT fk_histvh_func  FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_mensalidade ADD CONSTRAINT fk_mensal_aluno FOREIGN KEY (matricula) REFERENCES tb_aluno(matricula);

-- ACADÊMICO
ALTER TABLE tb_aluno ADD CONSTRAINT fk_aluno_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf);
ALTER TABLE tb_matricula ADD CONSTRAINT fk_mat_aluno FOREIGN KEY (matricula) REFERENCES tb_aluno(matricula);
ALTER TABLE tb_matricula ADD CONSTRAINT fk_mat_disc FOREIGN KEY (id_disciplina) REFERENCES tb_disciplina(id_disciplina);
ALTER TABLE tb_professor_disciplina ADD CONSTRAINT fk_profdisc_func FOREIGN KEY (n_contratacao) REFERENCES tb_funcionario(n_contratacao);
ALTER TABLE tb_professor_disciplina ADD CONSTRAINT fk_profdisc_disc FOREIGN KEY (id_disciplina) REFERENCES tb_disciplina(id_disciplina);
ALTER TABLE tb_nota  ADD CONSTRAINT fk_nota_mat_disc FOREIGN KEY (matricula, id_disciplina) REFERENCES tb_matricula(matricula, id_disciplina);
ALTER TABLE tb_falta ADD CONSTRAINT fk_falta_mat_disc FOREIGN KEY (matricula, id_disciplina) REFERENCES tb_matricula(matricula, id_disciplina);
ALTER TABLE tb_telefone ADD CONSTRAINT fk_tel_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf);
ALTER TABLE tb_email ADD CONSTRAINT fk_email_pessoa FOREIGN KEY (cpf) REFERENCES tb_pessoa(cpf);

  -- FASE 2: CARGA DE DADOS (DML) - ESTRATÉGIA IDEMPOTENTE

-- DADOS GERAIS
INSERT IGNORE INTO tb_pessoa (cpf, primeiro_nome, sobrenome, data_nasc, genero) VALUES
('11111111111', 'Ana', 'Silva', '2010-04-15', 'Feminino'),
('22222222222', 'Bruno', 'Costa', '2011-10-20', 'Masculino'),
('33333333333', 'Carlos', 'Mendes', '1985-05-10', 'Masculino'),
('44444444444', 'Diana', 'Souza', '1990-08-22', 'Feminino'),
('55555555555', 'Eduardo', 'Lima', '1980-01-30', 'Masculino');

INSERT IGNORE INTO tb_telefone (ddd, numero, cpf) VALUES
('011', '988887777', '11111111111'),
('011', '977776666', '33333333333');

INSERT IGNORE INTO tb_email (id_email, endereco_email, cpf) VALUES
(1, 'ana.silva@email.com', '11111111111'),
(2, 'carlos.mendes@escola.com', '33333333333');

-- RECURSOS HUMANOS
INSERT IGNORE INTO tb_departamento (id_departamento, departamento) VALUES
(1, 'Direcao'), (2, 'Coordenacao'), (3, 'Financeiro');

INSERT IGNORE INTO tb_cargo (id_cargo, nome_cargo, tipo_cargo) VALUES
(1, 'Diretor Geral', 'Administrativo'),
(2, 'Professor Titular', 'Docente'),
(3, 'Analista Financeiro', 'Administrativo');

INSERT IGNORE INTO tb_formacao (id_formacao, nome_formacao) VALUES
(1, 'Pedagogia'), (2, 'Matematica'), (3, 'Letras');

INSERT IGNORE INTO tb_funcionario (n_contratacao, cpf, status_funcionario, dt_admissao, id_formacao) VALUES
(1, '33333333333', 'Ativado', '2020-02-01', 2),
(2, '44444444444', 'Ativado', '2021-03-15', 3),
(3, '55555555555', 'Ativado', '2015-01-10', 1);

INSERT IGNORE INTO tb_funcionario_cargo (id_func_cargo, n_contratacao, id_cargo, id_departamento, data_inicio) VALUES
(1, 1, 2, 2, '2020-02-01'),
(2, 2, 2, 2, '2021-03-15'),
(3, 3, 1, 1, '2015-01-10');

INSERT IGNORE INTO tb_folha_pagamento (id_folha, n_contratacao, salario_atual, descontos, data_pagamento) VALUES
(1, 1, 3000.00, 'nenhum', '2026-05-05'),
(2, 2, 3200.00, 'nenhum', '2026-05-05'),
(3, 3, 8500.00, 'nenhum', '2026-05-05');

-- ACADÊMICO
INSERT IGNORE INTO tb_aluno (matricula, cpf) VALUES
(1, '11111111111'), (2, '22222222222');

INSERT IGNORE INTO tb_disciplina (id_disciplina, nome_disciplina, data_inicio, data_fim, sala, carga_horaria_semanal) VALUES
(1, 'Matematica', '2026-02-01', '2026-12-15', 101, 4),
(2, 'Portugues', '2026-02-01', '2026-12-15', 102, 4);

INSERT IGNORE INTO tb_professor_disciplina (n_contratacao, id_disciplina, carga_horaria_professor) VALUES
(1, 1, 20), (2, 2, 20);

INSERT IGNORE INTO tb_matricula (matricula, id_disciplina, data_inicio, data_fim, status) VALUES
(1, 1, '2026-02-01', '2026-12-15', 'Ativo'),
(1, 2, '2026-02-01', '2026-12-15', 'Ativo'),
(2, 1, '2026-02-01', '2026-12-15', 'Ativo');

INSERT IGNORE INTO tb_nota (matricula, id_disciplina, tipo, nota, data_avaliacao) VALUES
(1, 1, 'Prova', 8.50, '2026-04-10'),
(1, 2, 'Prova', 9.00, '2026-04-12'),
(2, 1, 'Prova', 6.00, '2026-04-10');

-- FINANCEIRO
INSERT IGNORE INTO tb_mensalidade (matricula, valor, mes_referencia, status) VALUES
(1, 600.00, '2026-02-01', 'Ativo'),
(1, 600.00, '2026-03-01', 'Ativo'),
(1, 600.00, '2026-04-01', 'Nao_pago'),
(2, 600.00, '2026-02-01', 'Ativo'),
(2, 600.00, '2026-03-01', 'Ativo'),
(2, 600.00, '2026-04-01', 'Ativo');

-- VALIDAÇÃO DA IDEMPOTÊNCIA

SELECT 'tb_pessoa' AS Tabela, COUNT(*) AS Quantidade_Registros FROM tb_pessoa
UNION ALL
SELECT 'tb_funcionario', COUNT(*) FROM tb_funcionario
UNION ALL
SELECT 'tb_aluno', COUNT(*) FROM tb_aluno
UNION ALL
SELECT 'tb_mensalidade', COUNT(*) FROM tb_mensalidade;

-- FASE 3: OPERAÇÕES OLTP

SELECT f.n_contratacao, p.primeiro_nome, p.sobrenome, fp.salario_atual 
FROM tb_funcionario f
JOIN tb_pessoa p ON f.cpf = p.cpf
JOIN tb_folha_pagamento fp ON f.n_contratacao = fp.n_contratacao
WHERE f.status_funcionario = 'Ativado';

SELECT n_contratacao, salario_atual 
FROM tb_folha_pagamento 
WHERE salario_atual > (SELECT AVG(salario_atual) FROM tb_folha_pagamento);

-- CENÁRIO ROLLBACK

START TRANSACTION;
INSERT INTO tb_historico_pagamento (n_contratacao, salario_anterior, salario_atual, data_alteracao, data_pagamento)
VALUES (1, 3000.00, 3300.00, CURDATE(), CURDATE());
UPDATE tb_folha_pagamento SET salario_atual = 3300.00 WHERE n_contratacao = 1;
ROLLBACK;

SELECT 'VALIDAÇÃO ROLLBACK' AS Teste, salario_atual FROM tb_folha_pagamento WHERE n_contratacao = 1;

-- CENÁRIO COMMIT

START TRANSACTION;
INSERT INTO tb_historico_pagamento (n_contratacao, salario_anterior, salario_atual, data_alteracao, data_pagamento)
VALUES (1, 3000.00, 3300.00, CURDATE(), CURDATE());
UPDATE tb_folha_pagamento SET salario_atual = 3300.00 WHERE n_contratacao = 1;
COMMIT;

SELECT 'VALIDAÇÃO COMMIT' AS Teste, salario_atual FROM tb_folha_pagamento WHERE n_contratacao = 1;

-- FASE 4: CONVERSÃO OLAP 
 
-- DIMENSÕES
CREATE TABLE dim_tempo (
    sk_tempo INT PRIMARY KEY AUTO_INCREMENT,
    data_completa DATE UNIQUE,
    ano INT, mes INT, nome_mes VARCHAR(20), trimestre INT
);

CREATE TABLE dim_aluno (
    sk_aluno INT PRIMARY KEY AUTO_INCREMENT,
    matricula_original INT UNIQUE,
    nome_completo VARCHAR(150), genero VARCHAR(20)
);

CREATE TABLE dim_disciplina (
    sk_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    id_disciplina_original INT UNIQUE,
    nome_disciplina VARCHAR(100)
);

CREATE TABLE dim_funcionario (
    sk_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    n_contratacao_original INT UNIQUE,
    nome_completo VARCHAR(150),
    nome_cargo VARCHAR(255),
    departamento VARCHAR(100)
);

-- TABELAS FATO 
CREATE TABLE fato_mensalidades (
    sk_aluno INT,
    sk_tempo INT,
    valor_total DECIMAL(10,2),
    status_pagamento VARCHAR(20),
    PRIMARY KEY (sk_aluno, sk_tempo),
    FOREIGN KEY (sk_aluno) REFERENCES dim_aluno(sk_aluno),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

CREATE TABLE fato_despesas_folha (
    sk_funcionario INT,
    sk_tempo INT,
    salario_pago DECIMAL(10,2),
    PRIMARY KEY (sk_funcionario, sk_tempo),
    FOREIGN KEY (sk_funcionario) REFERENCES dim_funcionario(sk_funcionario),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

-- PROCESSO ETL
INSERT IGNORE INTO dim_tempo (data_completa, ano, mes, nome_mes, trimestre) VALUES
('2026-02-01', 2026, 2, 'Fevereiro', 1),
('2026-03-01', 2026, 3, 'Março', 1),
('2026-04-01', 2026, 4, 'Abril', 2),
('2026-05-05', 2026, 5, 'Maio', 2); 

INSERT IGNORE INTO dim_aluno (matricula_original, nome_completo, genero)
SELECT a.matricula, CONCAT(p.primeiro_nome, ' ', p.sobrenome), p.genero
FROM tb_aluno a JOIN tb_pessoa p ON a.cpf = p.cpf;

INSERT IGNORE INTO dim_disciplina (id_disciplina_original, nome_disciplina)
SELECT id_disciplina, nome_disciplina FROM tb_disciplina;

INSERT IGNORE INTO dim_funcionario (n_contratacao_original, nome_completo, nome_cargo, departamento)
SELECT 
    f.n_contratacao, CONCAT(p.primeiro_nome, ' ', p.sobrenome), c.nome_cargo, d.departamento
FROM tb_funcionario f
JOIN tb_pessoa p ON f.cpf = p.cpf
JOIN tb_funcionario_cargo fc ON f.n_contratacao = fc.n_contratacao
JOIN tb_cargo c ON fc.id_cargo = c.id_cargo
JOIN tb_departamento d ON fc.id_departamento = d.id_departamento;

-- ETL DA FATO MENSALIDADE (RECEITA)
INSERT IGNORE INTO fato_mensalidades (sk_aluno, sk_tempo, valor_total, status_pagamento)
SELECT
    da.sk_aluno, dt.sk_tempo, m.valor, m.status
FROM tb_mensalidade m
JOIN dim_aluno da ON m.matricula = da.matricula_original
JOIN dim_tempo dt ON m.mes_referencia = dt.data_completa;

-- ETL DA FATO FOLHA (DESPESA)
INSERT IGNORE INTO fato_despesas_folha (sk_funcionario, sk_tempo, salario_pago)
SELECT 
    df.sk_funcionario, dt.sk_tempo, fp.salario_atual
FROM tb_folha_pagamento fp
JOIN dim_funcionario df ON fp.n_contratacao = df.n_contratacao_original
JOIN dim_tempo dt ON fp.data_pagamento = dt.data_completa;

-- VALIDAÇÃO OLAP E CONSULTA ANALÍTICA MASTER (FLUXO DE CAIXA)
SELECT 'OLTP' AS Origem, SUM(valor) AS Total FROM tb_mensalidade
UNION ALL
SELECT 'OLAP' AS Origem, SUM(valor_total) FROM fato_mensalidades;

-- FASE 5: DESEMPENHO E OTIMIZAÇÃO (ÍNDICES E EXPLAIN)
 
-- Criação de Índices em colunas frequentemente usadas em WHERE e JOINs
CREATE INDEX idx_mensalidade_matricula ON tb_mensalidade(matricula);
CREATE INDEX idx_folha_funcionario ON tb_folha_pagamento(n_contratacao);
CREATE INDEX idx_nota_disciplina ON tb_nota(id_disciplina);

-- Demonstração do uso do índice com "KEY"
EXPLAIN SELECT m.mes_referencia, m.valor, m.status 
FROM tb_mensalidade m 
WHERE m.matricula = 1;