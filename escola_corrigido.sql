CREATE DATABASE projeto_db_escola;
USE projeto_db_escola;

CREATE TABLE pessoa (
  cpf CHAR(11) PRIMARY KEY,
  primeiro_nome VARCHAR(15),
  sobrenome VARCHAR(38),
  data_nasc DATE,
  genero ENUM('Masculino','Feminino','Outro')
);

CREATE TABLE formacao (
  id_formacao INT PRIMARY KEY AUTO_INCREMENT,
  nome_formacao VARCHAR(255) NOT NULL
);

CREATE TABLE departamento (
  id_departamento INT PRIMARY KEY AUTO_INCREMENT,
  departamento ENUM('Direcao','Coordenacao','Secretaria_ADM','Financeiro','Zeladoria','Inspetoria_Seguranca','Biblioteca','Recursos_Humanos') NOT NULL
);

CREATE TABLE disciplina (
  id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
  nome_disciplina ENUM('Portugues','Matematica','Ciencias','Historia','Geografia','Ingles','Artes','Educacao_Fisica') NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  sala INT,
  carga_horaria_semanal INT NOT NULL
);

CREATE TABLE cargo (
  id_cargo INT PRIMARY KEY AUTO_INCREMENT,
  nome_cargo VARCHAR(255) NOT NULL,
  tipo_cargo ENUM('Docente','Administrativo','Operacional') NOT NULL,
  id_departamento INT,
  FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
);

CREATE TABLE funcionario (
  n_contratacao INT PRIMARY KEY AUTO_INCREMENT,
  cpf CHAR(11) NOT NULL,
  status_funcionario  ENUM('Ativado','Desativado'),
  id_cargo INT,
  dt_admissao DATE,
  dt_desligamento DATE,
  id_formacao INT,
  FOREIGN KEY (cpf) REFERENCES pessoa (cpf),
  FOREIGN KEY (id_cargo) REFERENCES cargo (id_cargo),
  FOREIGN KEY (id_formacao) REFERENCES formacao (id_formacao)
);

CREATE TABLE professor_disciplina (
  n_contratacao INT NOT NULL,
  id_disciplina INT NOT NULL,
  carga_horaria_semanal INT NOT NULL,
  PRIMARY KEY (n_contratacao, id_disciplina),
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao),
  FOREIGN KEY (id_disciplina) REFERENCES disciplina  (id_disciplina)
);

CREATE TABLE aluno (
  cpf CHAR(11) NOT NULL,
  matricula INT NOT NULL,
  PRIMARY KEY (cpf, matricula),
  FOREIGN KEY (cpf) REFERENCES pessoa (cpf)
);

CREATE TABLE matricula (
  matricula INT  NOT NULL,
  id_disciplina INT  NOT NULL,
  cpf CHAR(11) NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  status ENUM('Ativo','Inativo','Cancelado'),
  PRIMARY KEY (matricula, id_disciplina, cpf),
  FOREIGN KEY (id_disciplina) REFERENCES disciplina (id_disciplina)
);

CREATE TABLE contato (
  ddd CHAR(3) NOT NULL,
  numero CHAR(11) NOT NULL,
  cpf CHAR(11) NOT NULL,
  email   VARCHAR(255),
  PRIMARY KEY (ddd, numero, cpf),
  FOREIGN KEY (cpf) REFERENCES pessoa (cpf)
);

CREATE TABLE mensalidade (
  matricula INT NOT NULL,
  cpf CHAR(11) NOT NULL,
  valor DECIMAL(10,2),
  mes_referencia DATE,
  status ENUM('Ativo','Inativo','Cancelado','Nao_pago'),
  PRIMARY KEY (valor,mes_referencia),
  FOREIGN KEY (cpf) REFERENCES aluno (cpf),
  FOREIGN KEY (matricula) REFERENCES matricula (matricula)
);

CREATE TABLE nota (
  matricula INT NOT NULL,
  id_disciplina INT NOT NULL,
  tipo ENUM('Prova','Trabalho','Recuperacao') NOT NULL,
  nota DECIMAL(4,2) NOT NULL,
  data_avaliacao DATE,
  PRIMARY KEY (matricula, id_disciplina, tipo),
  FOREIGN KEY (id_disciplina) REFERENCES disciplina (id_disciplina)
);

CREATE TABLE falta (
  id_falta INT PRIMARY KEY AUTO_INCREMENT,
  matricula INT,
  id_disciplina INT,
  data_falta DATE NOT NULL,
  justificada ENUM('Sim','Nao') DEFAULT 'Nao',
  FOREIGN KEY (id_disciplina) REFERENCES disciplina (id_disciplina)
);

CREATE TABLE ponto (
  id_ponto INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT,
  data DATE,
  hora_entrada TIME,
  hora_saida TIME,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE ferias (
  id_ferias INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT,
  num_ferias INT,
  data_inicio DATE,
  data_fim DATE,
  status_ferias VARCHAR(255),
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE afastamento (
  id_afastamento INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT,
  motivo TEXT,
  status ENUM('EmAndamento','Concluido'),
  data_inicio DATE,
  data_fim DATE,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE treinamento (
  id_treinamento INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT,
  tipo_treinamento VARCHAR(255),
  carga_horaria TIME,
  data_conclusao DATE,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE folha_pagamento (
  id_folha INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  salario_atual DECIMAL(10,2) NOT NULL,
  descontos ENUM('descontado','nenhum') DEFAULT 'nenhum' COMMENT 'Checar se houver descontos',
  data_pagamento  DATE NOT NULL,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE historico_pagamento (
  id_historico INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT NOT NULL,
  salario_anterior DECIMAL(10,2) NOT NULL COMMENT 'Valor antes do reajuste',
  salario_atual DECIMAL(10,2) NOT NULL CHECK (salario_atual > 0),
  data_alteracao DATE NOT NULL,
  data_pagamento DATE NOT NULL,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);

CREATE TABLE historico_valor_hora (
  id_historico INT PRIMARY KEY AUTO_INCREMENT,
  n_contratacao INT,
  valor_hora DECIMAL(10,2)  NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  FOREIGN KEY (n_contratacao) REFERENCES funcionario (n_contratacao)
);
