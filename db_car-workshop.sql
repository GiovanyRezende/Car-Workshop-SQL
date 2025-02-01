CREATE DATABASE IF NOT EXISTS db_carworkshop
COLLATE utf8mb4_general_ci
CHARSET utf8mb4;

CREATE TABLE IF NOT EXISTS tb_endereco_mec(
	id INT PRIMARY KEY AUTO_INCREMENT,
	rua VARCHAR(100) NOT NULL,
	numero INT NOT NULL,
	cep VARCHAR(8) NOT NULL,
	cidade VARCHAR(200) NOT NULL,
	uf VARCHAR(2) NOT NULL,
	complemento VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS tb_endereco_cliente(
	id INT PRIMARY KEY AUTO_INCREMENT,
	rua VARCHAR(100) NOT NULL,
	numero INT NOT NULL,
	cep VARCHAR(8) NOT NULL,
	cidade VARCHAR(200) NOT NULL,
	uf VARCHAR(2) NOT NULL,
	complemento VARCHAR(200)
);

CREATE TABLE tb_especialidade (
	id INT PRIMARY KEY AUTO_INCREMENT,
	especialidade VARCHAR(100) NOT NULL,
	descricao VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS tb_status(
	id INT PRIMARY KEY AUTO_INCREMENT,
	status VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_referencia(
	id INT PRIMARY KEY AUTO_INCREMENT,
	referencia VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_cliente(
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(255) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	cnpj VARCHAR(14),
	email VARCHAR(100) NOT NULL,
	id_endereco INT NOT NULL,
	CONSTRAINT uq_cpf_cliente UNIQUE (cpf),
	CONSTRAINT fk_id_endereco_cliente
	FOREIGN KEY (id_endereco) REFERENCES tb_endereco_cliente (id) 
);

CREATE TABLE IF NOT EXISTS tb_peca (
	id INT PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR(255) NOT NULL,
	valor_unit FLOAT(6,2) NOT NULL
);

CREATE TABLE tb_equipe (
	id INT PRIMARY KEY,
	codigo VARCHAR(50) NOT NULL,
	nome VARCHAR(255) NOT NULL,
	CONSTRAINT uq_codigo_equipe UNIQUE (codigo)
);

CREATE TABLE tb_mecanico (
	id INT PRIMARY KEY AUTO_INCREMENT,
	codigo VARCHAR(50) NOT NULL,
	nome VARCHAR(255),
	id_equipe INT NOT NULL,
	id_endereco INT NOT NULL,
	id_especialidade INT NOT NULL,
	CONSTRAINT uq_codigo_mecanico UNIQUE (codigo),
	CONSTRAINT fk_id_equipe_mecanico
	FOREIGN KEY (id_equipe) REFERENCES tb_equipe (id),
	CONSTRAINT fk_id_endereco_mecanico
	FOREIGN KEY (id_endereco) REFERENCES tb_endereco_mec (id),
	CONSTRAINT fk_id_especialidade
	FOREIGN KEY (id_especialidade) REFERENCES tb_especialidade (id)
);

CREATE TABLE IF NOT EXISTS tb_servico(
	id INT PRIMARY KEY AUTO_INCREMENT,
	valor FLOAT(6,2) NOT NULL,
 	descricao VARCHAR(255) NOT NULL,
	id_cliente INT NOT NULL,
	CONSTRAINT fk_id_cliente_servico
	FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id)
);

CREATE TABLE IF NOT EXISTS tb_veiculo(
	id INT PRIMARY KEY AUTO_INCREMENT,
	modelo VARCHAR(100) NOT NULL,
	marca VARCHAR(100) NOT NULL,
	ano INT NOT NULL,
	id_cliente INT NOT NULL,
	CONSTRAINT fk_id_cliente_veiculo
	FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id)
);

CREATE TABLE IF NOT EXISTS tb_os(
	id INT PRIMARY KEY AUTO_INCREMENT,
	num INT NOT NULL,
    	data_emissao DATE NOT NULL,
    	valor FLOAT(10,2) NOT NULL,
	data_conclusao DATE NOT NULL,
	id_equipe INT NOT NULL,
	id_veiculo INT NOT NULL,
    	id_status INT NOT NULL,
    	id_referencia INT NOT NULL,
    	CONSTRAINT fk_id_equipe_os
	FOREIGN KEY (id_equipe) REFERENCES tb_equipe (id),
	CONSTRAINT fk_id_veiculo_os
	FOREIGN KEY (id_veiculo) REFERENCES tb_veiculo (id),
	CONSTRAINT fk_id_status_os
	FOREIGN KEY (id_status) REFERENCES tb_status (id),
	CONSTRAINT fk_id_referencia_os
	FOREIGN KEY (id_referencia) REFERENCES tb_referencia (id)
);

CREATE TABLE IF NOT EXISTS tb_os_servico(
    	id_os INT NOT NULL,
    	id_servico INT NOT NULL,
	PRIMARY KEY (id_os, id_servico),
	CONSTRAINT fk_id_os_os_servico
    	FOREIGN KEY (id_os) REFERENCES tb_os (id),
	CONSTRAINT fk_id_servico_os_servico
    	FOREIGN KEY (id_servico) REFERENCES tb_servico (id)
);

CREATE TABLE IF NOT EXISTS tb_os_peca(
	id_os INT NOT NULL,
    	id_peca INT NOT NULL,
	qtd INT NOT NULL,
	PRIMARY KEY (id_os, id_peca),
	CONSTRAINT fk_id_os_os_peca
    	FOREIGN KEY (id_os) REFERENCES tb_os (id),
	CONSTRAINT fk_id_servico_os_peca
    	FOREIGN KEY (id_peca) REFERENCES tb_peca (id)
);