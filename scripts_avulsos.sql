-- ========================================================
-- BATERIA DE SCRIPTS OFICIAIS - TEMA 4 (CHAT & FÓRUM)
-- Disciplina: Modelagem e Implementação de Banco de Dados
-- ========================================================
USE `mydb`;

-- ========================================================
-- Membro 1: VINICIUS LUNARDI - Responsavel por JOINs
-- ========================================================

-- Script 1: Listar usuários e seus perfis (JOIN de 2 tabelas)
SELECT 
    u.id_usuario,
    u.nome AS nome_usuario,
    u.username,
    u.email,
    p.nome AS perfil
FROM `USUARIO` u
JOIN `TIPO_PERFIL` p ON u.TIPO_PERFIL_id_perfil = p.id_perfil
ORDER BY u.id_usuario ASC;

-- Script 2: Listar mensagens com autor e grupo (JOIN de 3 tabelas)
SELECT 
    m.id_mensagem,
    u.nome AS autor,
    u.username,
    g.nome AS nome_grupo,
    m.conteudo,
    m.data_envio
FROM `MENSAGEM` m
JOIN `USUARIO` u ON m.USUARIO_id_usuario = u.id_usuario
JOIN `GRUPO_CANAL` g ON m.GRUPO_CANAL_id_grupo = g.id_grupo
ORDER BY m.data_envio DESC;


-- ========================================================
-- Membro 2: BEATRIZ NAOMI - Responsavel por Filtros e Buscas
-- ========================================================

-- Script 3: Buscar usuários por nome e ordenar por cadastro (WHERE, LIKE, ORDER BY)
SELECT 
    id_usuario,
    nome,
    username,
    email,
    data_cadastro
FROM `USUARIO`
WHERE nome LIKE '%a%' OR username LIKE '%a%'
ORDER BY data_cadastro DESC;

-- Script 4: Filtrar mensagens por intervalo de IDs e ordenar por data (BETWEEN, ORDER BY)
SELECT 
    id_mensagem,
    conteudo,
    data_envio,
    USUARIO_id_usuario,
    GRUPO_CANAL_id_grupo
FROM `MENSAGEM`
WHERE id_mensagem BETWEEN 1 AND 5
ORDER BY data_envio ASC;


-- ========================================================
-- Membro 3: GIOVANA ENEAS - Responsavel por Métricas e Relatórios
-- ========================================================

-- Script 5: Contagem de mensagens por usuário (COUNT, GROUP BY)
SELECT 
    u.id_usuario,
    u.nome AS nome_usuario,
    COUNT(m.id_mensagem) AS total_mensagens
FROM `USUARIO` u
LEFT JOIN `MENSAGEM` m ON u.id_usuario = m.USUARIO_id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY total_mensagens DESC;

-- Script 6: Grupos com membros ativos (COUNT, GROUP BY, HAVING)
SELECT 
    g.id_grupo,
    g.nome AS nome_grupo,
    COUNT(mg.USUARIO_id_usuario) AS total_membros
FROM `GRUPO_CANAL` g
JOIN `MEMBRO_GRUPO` mg ON g.id_grupo = mg.GRUPO_CANAL_id_grupo
GROUP BY g.id_grupo, g.nome
HAVING COUNT(mg.USUARIO_id_usuario) >= 2
ORDER BY total_membros DESC;

-- Script 7: Resumo geral por grupo (Múltiplos JOINs + Agregação)
SELECT 
    g.id_grupo,
    g.nome AS nome_grupo,
    COUNT(DISTINCT mg.id_membro_grupo) AS total_membros,
    COUNT(DISTINCT m.id_mensagem) AS total_mensagens
FROM `GRUPO_CANAL` g
LEFT JOIN `MEMBRO_GRUPO` mg ON g.id_grupo = mg.GRUPO_CANAL_id_grupo
LEFT JOIN `MENSAGEM` m ON g.id_grupo = m.GRUPO_CANAL_id_grupo
GROUP BY g.id_grupo, g.nome
ORDER BY g.id_grupo ASC;


-- ========================================================
-- Membro 4: VITHOR ALBUQUERQUE - Responsavel por Transações, DML, Self-Join e View 
-- ========================================================

-- Script 8: Atualizar a descrição de um grupo (UPDATE)
UPDATE `GRUPO_CANAL`
SET `descricao` = 'Espaço oficial para dúvidas e discussões avançadas sobre MySQL e Modelagem.'
WHERE `id_grupo` = 2;

-- Consulta de confirmação ao vivo:
SELECT id_grupo, nome, descricao FROM `GRUPO_CANAL` WHERE id_grupo = 2;

-- Script 9: Remover uma reação de curtida indesejada (DELETE)
DELETE FROM `REACAO_CURTIDA`
WHERE `id_reacao` = 1;

-- Consulta de confirmação ao vivo:
SELECT * FROM `REACAO_CURTIDA`;

-- Script 10: Relacionar comentários e suas respostas (Self-Join)
SELECT 
    pai.id_comentario AS id_comentario_original,
    pai.texto AS comentario_original,
    filho.id_comentario AS id_resposta,
    filho.texto AS resposta_encadeada,
    filho.data_comentario AS data_resposta
FROM `COMENTARIO` filho
INNER JOIN `COMENTARIO` pai ON filho.COMENTARIO_id_comentario = pai.id_comentario
ORDER BY pai.id_comentario ASC, filho.data_comentario ASC;

-- ========================================================
-- VIEW ESTRATÉGICA OBRIGATÓRIA (Dashboard do Projeto)
-- ========================================================

-- Criação da View Executiva
CREATE OR REPLACE VIEW `vw_dashboard_engajamento_canais` AS
SELECT 
    g.id_grupo,
    g.nome AS nome_canal,
    COUNT(DISTINCT mg.id_membro_grupo) AS qtd_membros,
    COUNT(DISTINCT m.id_mensagem) AS qtd_mensagens,
    COUNT(DISTINCT c.id_comentario) AS qtd_comentarios,
    COUNT(DISTINCT r.id_reacao) AS qtd_reações
FROM `GRUPO_CANAL` g
LEFT JOIN `MEMBRO_GRUPO` mg ON g.id_grupo = mg.GRUPO_CANAL_id_grupo
LEFT JOIN `MENSAGEM` m ON g.id_grupo = m.GRUPO_CANAL_id_grupo
LEFT JOIN `COMENTARIO` c ON m.id_mensagem = c.MENSAGEM_id_mensagem
LEFT JOIN `REACAO_CURTIDA` r ON m.id_mensagem = r.MENSAGEM_id_mensagem
GROUP BY g.id_grupo, g.nome
ORDER BY qtd_mensagens DESC;

-- Script de Consulta View 
SELECT * FROM `vw_dashboard_engajamento_canais`;