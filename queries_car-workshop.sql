-- Quais são os nomes e os e-mails de todos os clientes cadastrados no sistema com um carro da marca Toyota?
SELECT c.nome, c.email
	FROM tb_cliente as c
	INNER JOIN tb_veiculo as v
	ON c.id = v.id_cliente
	WHERE UPPER(v.marca) LIKE 'TOYOTA';

-- Quem são os donos dos veículos do sistema foram fabricados a partir do ano 2015, assim como modelo, marca e ano?
SELECT c.nome, v.modelo, v.marca, v.ano
	FROM tb_cliente as c
	INNER JOIN tb_veiculo as v
	ON c.id = v.id_cliente
	WHERE v.ano >= 2015;

-- Qual o valor total (quantidade × valor unitário) de cada peça utilizada nas ordens de serviço?
SELECT p.id as id_peca, os.id as id_os, p.valor * osp.qtd as valor_total
	FROM tb_peca as p
	INNER JOIN tb_os_peca as osp
	ON p.id = osp.id_peca
	INNER JOIN tb_os as os
	ON os.id = osp.id_os
	GROUP BY p.id, os.id, osp.qtd, p.valor;

-- Liste todas as ordens de serviço (e seus valores) com o valor incorreto em relação ao valor das peças
SELECT os.id as id_os, os.valor as valor_os
	FROM tb_os as os
	INNER JOIN (SELECT os.id as id_os, 
       			SUM(p.valor * osp.qtd) as total_pecas
			FROM tb_os as os
			INNER JOIN tb_os_peca as osp ON os.id = osp.id_os
			INNER JOIN tb_peca as p ON osp.id_peca = p.id
			GROUP BY os.id) as subq
	ON os.id = subq.id_os
	WHERE os.valor <> subq.total_pecas;


-- Liste todas as ordens de serviço cadastradas, ordenadas pelo valor total em ordem decrescente.
SELECT id, valor
	FROM tb_os
	ORDER BY valor DESC;

-- Quais equipes possuem mais de 5 ordens de serviço associadas?
SELECT e.id as id_equipe, COUNT(os.id) as n_os
	FROM tb_equipe as e
	INNER JOIN tb_os as os
	ON e.id = os.id_equipe
	GROUP BY e.id
	HAVING COUNT(os.id) > 5;

-- Quais clientes possuem veículos com ordens de serviço em aberto, incluindo o nome do cliente e o modelo do veículo?
SELECT c.nome as cliente, v.modelo as modelo
	FROM tb_cliente as c
	INNER JOIN tb_veiculo as v
	ON c.id = v.id_cliente
	INNER JOIN tb_os as os
	ON v.id = os.id_veiculo
	INNER JOIN tb_status as s
	ON s.id = os.id_status
	WHERE s.status = 'Em aberto';

