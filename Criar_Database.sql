-- ========================================================
-- 1. CRIAR O BANCO DE DADOS E USÁ-LO
-- ========================================================
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

-- ========================================================
-- 2. CRIAR AS TABELAS
-- ========================================================

-- Table `mydb`.`TIPO_PERFIL`
CREATE TABLE IF NOT EXISTS `mydb`.`TIPO_PERFIL` (
  `id_perfil` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL UNIQUE,
  `descricao` VARCHAR(255) NULL,
  PRIMARY KEY (`id_perfil`)
);

-- Table `mydb`.`GRUPO_CANAL`
CREATE TABLE IF NOT EXISTS `mydb`.`GRUPO_CANAL` (
  `id_grupo` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL UNIQUE,
  `descricao` VARCHAR(255) NOT NULL,
  `data_criacao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`)
);

-- Table `mydb`.`USUARIO`
CREATE TABLE IF NOT EXISTS `mydb`.`USUARIO` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `senha` VARCHAR(100) NOT NULL,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `data_cadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TIPO_PERFIL_id_perfil` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  FOREIGN KEY (`TIPO_PERFIL_id_perfil`)
    REFERENCES `mydb`.`TIPO_PERFIL` (`id_perfil`)
);

-- Table `mydb`.`MEMBRO_GRUPO`
CREATE TABLE IF NOT EXISTS `mydb`.`MEMBRO_GRUPO` (
  `id_membro_grupo` INT NOT NULL AUTO_INCREMENT,
  `data_entrada` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `GRUPO_CANAL_id_grupo` INT NOT NULL,
  `USUARIO_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_membro_grupo`),
  FOREIGN KEY (`GRUPO_CANAL_id_grupo`)
    REFERENCES `mydb`.`GRUPO_CANAL` (`id_grupo`)
  FOREIGN KEY (`USUARIO_id_usuario`)
    REFERENCES `mydb`.`USUARIO` (`id_usuario`)
);

-- Table `mydb`.`MENSAGEM`
CREATE TABLE IF NOT EXISTS `mydb`.`MENSAGEM` (
  `id_mensagem` INT NOT NULL AUTO_INCREMENT,
  `conteudo` TEXT(1000) NOT NULL,
  `data_envio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_id_usuario` INT NOT NULL,
  `GRUPO_CANAL_id_grupo` INT NOT NULL,
  PRIMARY KEY (`id_mensagem`),
  FOREIGN KEY (`USUARIO_id_usuario`)
    REFERENCES `mydb`.`USUARIO` (`id_usuario`)
  FOREIGN KEY (`GRUPO_CANAL_id_grupo`)
    REFERENCES `mydb`.`GRUPO_CANAL` (`id_grupo`)
);

-- Table `mydb`.`COMENTARIO`
CREATE TABLE IF NOT EXISTS `mydb`.`COMENTARIO` (
  `id_comentario` INT NOT NULL AUTO_INCREMENT,
  `texto` VARCHAR(500) NOT NULL,
  `data_comentario` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MENSAGEM_id_mensagem` INT NOT NULL,
  `USUARIO_id_usuario` INT NOT NULL,
  `COMENTARIO_id_comentario` INT NULL, 
  PRIMARY KEY (`id_comentario`),
  FOREIGN KEY (`MENSAGEM_id_mensagem`)
    REFERENCES `mydb`.`MENSAGEM` (`id_mensagem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (`USUARIO_id_usuario`)
    REFERENCES `mydb`.`USUARIO` (`id_usuario`)
  FOREIGN KEY (`COMENTARIO_id_comentario`)
    REFERENCES `mydb`.`COMENTARIO` (`id_comentario`)
);

-- Table `mydb`.`REAÇÃO_CURTIDA`
CREATE TABLE IF NOT EXISTS `mydb`.`REACAO_CURTIDA` (
  `id_reacao` INT NOT NULL AUTO_INCREMENT,
  `tipo_reacao` VARCHAR(25) NOT NULL,
  `data_reacao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `MENSAGEM_id_mensagem` INT NOT NULL,
  `USUARIO_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_reacao`),
  FOREIGN KEY (`MENSAGEM_id_mensagem`)
    REFERENCES `mydb`.`MENSAGEM` (`id_mensagem`)
  FOREIGN KEY (`USUARIO_id_usuario`)
    REFERENCES `mydb`.`USUARIO` (`id_usuario`)
);

-- ========================================================
-- DADOS DE TESTE (MOCK DATA)
-- ========================================================

-- Inserir Tipos de Perfil
INSERT INTO `mydb`.`TIPO_PERFIL` (`nome`, `descricao`) VALUES 
('Administrador', 'Acesso total a todas as configurações e moderação do sistema.'),
('Moderador', 'Pode gerir mensagens e comentários.'),
('Membro', 'Utilizador comum.');

-- Inserir Grupos / Canais
INSERT INTO `mydb`.`GRUPO_CANAL` (`nome`, `descricao`) VALUES 
('Programação Web', 'Espaço para dúvidas de HTML, CSS e Flask.'),
('Banco de Dados', 'Discussões sobre modelagem SQL e MySQL.'),
('Geral', 'Conversas livres.');

-- Inserir Utilizadores
INSERT INTO `mydb`.`USUARIO` (`nome`, `email`, `senha`, `username`, `TIPO_PERFIL_id_perfil`) VALUES 
('Vinicius Silva', 'vinicius@email.com', 'hash1', 'vini_dev', 1),
('Ana Souza', 'ana@email.com', 'hash2', 'anasouza', 2),
('Carlos Eduardo', 'carlos@email.com', 'hash3', 'carlosedu', 3),
('Mariana Lima', 'mariana@email.com', 'hash4', 'marilima', 3);

-- Inserir Membros dos Grupos
INSERT INTO `mydb`.`MEMBRO_GRUPO` (`GRUPO_CANAL_id_grupo`, `USUARIO_id_usuario`) VALUES 
(1, 1),
(2, 1),
(2, 2),
(1, 3);

-- Inserir Mensagens
INSERT INTO `mydb`.`MENSAGEM` (`conteudo`, `USUARIO_id_usuario`, `GRUPO_CANAL_id_grupo`) VALUES 
('Olá pessoal! Alguém me sabe dizer como estruturar chaves estrangeiras?', 1, 2),
('Alguem sabe qual são os melhores frameworks para back-end no Python?', 3, 1);

-- Inserir Comentários
INSERT INTO `mydb`.`COMENTARIO` (`texto`, `MENSAGEM_id_mensagem`, `USUARIO_id_usuario`, `COMENTARIO_id_comentario`) VALUES 
('Vinicius, deve usar a restrição FOREIGN KEY.', 1, 2, NULL),
('Obrigado pela explicação, Ana Souza!', 1, 1, 1),
('Carlos, eu recomendo utilizar o Flask ou Django para criar seus projetos back-end utilizando o Python!', 2, 1, NULL),
('Interessante, agradeço as recomendações Vinícius!', 2, 3, 3);

-- Inserir Reações / Curtidas
INSERT INTO `mydb`.`REACAO_CURTIDA` (`tipo_reacao`, `MENSAGEM_id_mensagem`, `USUARIO_id_usuario`) VALUES 
('Gosto', 1, 2),
('Amei', 2, 1);
