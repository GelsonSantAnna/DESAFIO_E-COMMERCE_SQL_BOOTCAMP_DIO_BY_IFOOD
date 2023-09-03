-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--                        E-COMMERCE REFINADO                        -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Verifica se um banco de dados chamado "ecommerce" já existe e, se existir, o exclui.
DROP DATABASE IF EXISTS ecommerce;

-- Cria um banco de dados para armazenar informações de um sistema de e-commerce.

CREATE DATABASE IF NOT EXISTS ecommerce;

-- Seleciona o banco de dados "ecommerce" para uso.
USE ecommerce;

-- Tabela de Produtos:
-- Armazena os detalhes sobre os produtos disponíveis no e-commerce.

CREATE TABLE produtos (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(100) NOT NULL,
    categoria ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    descricao TEXT,
    valor DECIMAL(10, 2) NOT NULL,
    avaliacao DECIMAL(3, 2) NOT NULL DEFAULT 0
);

-- Tabela de Fornecedores:
-- Armazena as informações sobre os fornecedores dos produtos.

CREATE TABLE fornecedores (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj CHAR(14) NOT NULL UNIQUE,
    razaoSocial VARCHAR(100) NOT NULL,
    contato CHAR(11) NOT NULL
);

-- Tabela de Vendedores:
-- Armazenas as informações sobre os vendedores.

CREATE TABLE vendedores (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE,
    cpf CHAR(11) UNIQUE,
    localidade VARCHAR(50),
    nomeFantasia VARCHAR(100)
);

-- Tabela de Estoque:
-- Armazena e mantém o controle do estoque de produtos.

CREATE TABLE estoqueProdutos (
    idProduto INT,
    quantidade INT DEFAULT 0,
    localidade VARCHAR(50),
    PRIMARY KEY (idProduto, localidade),
    FOREIGN KEY (idProduto) REFERENCES produtos(idProduto)
);

-- Tabela de Clientes:
-- Armazena as informações sobre os clientes do e-commerce.

CREATE TABLE clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    tipoCliente ENUM('Pessoa Física', 'Pessoa Jurídica') NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpfCnpj CHAR(14) NOT NULL UNIQUE,
    endereco VARCHAR(255),
    dataNascimento DATE
);

-- Tabela de Pedidos:
-- Armazena as informações dos pedidos feitos pelos clientes.

CREATE TABLE pedidos (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    statusPedido ENUM('Em andamento', 'Em processamento', 'Enviado', 'Entregue') DEFAULT 'Em andamento',
    descricao TEXT,
    frete DECIMAL(10, 2) DEFAULT 10,
    pagamento BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

-- Tabela de Entrega:
-- Armazena as informações sobre as entregas dos pedidos.

CREATE TABLE entregas (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    statusEntrega ENUM('Em trânsito', 'Entregue') NOT NULL,
    codigoRastreio VARCHAR(50) NOT NULL,
    FOREIGN KEY (idPedido) REFERENCES pedidos(idPedido)
);

-- Tabela de Pagamentos:
-- Armazena as informações sobre as formas de pagamento cadastradas pelos clientes.

CREATE TABLE pagamentos (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    formaPagamento VARCHAR(50) NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

-- Tabela de Produtos Vendidos por Vendedor:
-- Estabelece uma relação entre produtos e vendedores.

CREATE TABLE produtosVendedores (
    idProduto INT,
    idVendedor INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idProduto, idVendedor),
    FOREIGN KEY (idProduto) REFERENCES produtos(idProduto),
    FOREIGN KEY (idVendedor) REFERENCES vendedores(idVendedor)
);

-- Tabela de Produtos em Pedidos:
-- Relaciona produtos e pedidos.

CREATE TABLE produtosPedidos (
    idProduto INT,
    idPedido INT,
    quantidade INT DEFAULT 1,
    statusPedido ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProduto, idPedido),
    FOREIGN KEY (idProduto) REFERENCES produtos(idProduto),
    FOREIGN KEY (idPedido) REFERENCES pedidos(idPedido)
);

-- Tabela de Produtos Fornecidos por Fornecedor:
-- Estabelece uma relação entre produtos e fornecedores.

CREATE TABLE produtosFornecedores (
    idProduto INT,
    idFornecedor INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (idProduto, idFornecedor),
    FOREIGN KEY (idProduto) REFERENCES produtos(idProduto),
    FOREIGN KEY (idFornecedor) REFERENCES fornecedores(idFornecedor)
);

-- -- -- -- -- -- -- -- -- -- -- -- INSERINDO DADOS -- -- -- -- -- -- -- -- -- -- -- --

-- Dados fictícios de CLIENTES.
INSERT INTO clientes (tipoCliente, nome, cpfCnpj, endereco, dataNascimento) VALUES
('Pessoa Física', 'Gabriel Santos', '39976546714', 'Rua das Pedras, 127', '1988-03-10'),
('Pessoa Física', 'Luciana Salvatori', '92937654616', 'Rua São Pedro, 77', '1992-07-23'),
('Pessoa Física', 'André Oliveira', '37378967217', 'Rua das Margaridas, 604', '1998-11-28'),
('Pessoa Física', 'Mirian Andreas', '93888765262', 'Rua da Prata, 98', '1990-10-18'),
('Pessoa Física', 'Miguel Soares', '46567728912', 'Rua Rio Branco, 402', '1978-08-13');

-- Métodos fictícios de PAGAMENTOS.
INSERT INTO pagamentos (idCliente, formaPagamento) VALUES
(1, 'Cartão de Crédito'),
(2, 'Cartão de Débito'),
(3, 'Boleto Bancário'),
(4, 'Transferência Bancária'),
(5, 'PayPal');

-- Dados fictícios de PRODUTOS.
INSERT INTO produtos (nomeProduto, categoria, descricao, valor, avaliacao) VALUES
('Smartphone TechLite', 'Eletrônico', 'Smartphone TechLite 4RAM 64GB Tela 6.3 Preto', 999.99, 4.5),
('Camiseta Basic', 'Vestimenta', 'Camiseta Moda basic Tam:M Cor Preta', 34.99, 4.0),
('Quebra-cabeça', 'Brinquedos', 'Quebra-cabeça infantil 500 peças', 29.99, 4.2),
('Feijão Carioca', 'Alimentos', 'Feijão Carioca 1kg Tipo1', 8.99, 4.5),
('Sofá Suede Confort', 'Móveis', 'Sofá Suede Confort Cinza Dois lugares', 899.99, 4.3);

-- Dados fictícios de FORNECEDORES.
INSERT INTO fornecedores (cnpj, razaoSocial, contato) VALUES
('38915845680001', 'All Eletronics', '11964787636'),
('75905799050001', 'Fina Moda', '11998326672'),
('96583256750001', 'Mania Kids', '11988367723'),
('83564767560001', 'Cultiva Alimentos', '11967485920'),
('46578219930001', 'Stilo Móveis', '11987334766');

-- Dados fictícios de ESTOQUE PRODUTOS.
INSERT INTO estoqueProdutos (idProduto, quantidade, localidade) VALUES
(1, 62, 'Centro de Distribuição All Eletronics'),
(2, 118, 'Centro de Distribuição Fina Moda'),
(3, 40, 'Centro de Distribuição Mania Kids'),
(4, 73, 'Centro de Distribuição Cultiva Alimentos'),
(5, 126, 'Centro de Distribuição Stilo Móveis');

-- Dados fictícios de PEDIDOS.
INSERT INTO pedidos (idCliente, statusPedido, descricao, frete, pagamento) VALUES
(1, 'Entregue', 'Pedido entregue com sucesso', 15.00, TRUE),
(2, 'Em processamento', 'Pedido em processo de preparação', 20.00, TRUE),
(3, 'Em andamento', 'Aguardando confirmação de pagamento', 18.00, FALSE),
(4, 'Enviado', 'Pedido enviado para entrega', 20.00, TRUE),
(5, 'Entregue', 'Pedido entregue com sucesso', 15.00, TRUE);

-- Dados fictícios de ENTREGAS.
INSERT INTO entregas (idPedido, statusEntrega, codigoRastreio) VALUES
(1, 'Entregue', 'C12BG56JH78'),
(2, 'Em trânsito', 'L65LM66FD54'),
(3, 'Em trânsito', 'D57GB67CC88'),
(4, 'Entregue', 'A45MC96KJ64'),
(5, 'Entregue', 'K45LJ47DF62');

-- -- -- -- -- -- -- -- -- -- -- -- FAZENDO CONSULTAS -- -- -- -- -- -- -- -- -- -- -- --

-- QUERY 1: Qual o total de pedidos feitos por cada cliente?

SELECT c.nome AS Cliente, COUNT(p.idPedido) AS TotalPedidos
FROM clientes c
LEFT JOIN pedidos p ON c.idCliente = p.idCliente
GROUP BY c.nome;

-- Query 2: Quais os nomes dos fornecedores e nomes dos produtos?

SELECT f.razaoSocial AS Fornecedor, p.nomeProduto AS Produto
FROM fornecedores f
INNER JOIN produtosFornecedores pf ON f.idFornecedor = pf.idFornecedor
INNER JOIN produtos p ON pf.idProduto = p.idProduto;

-- QUERY 3: Qual a média de valor de frete por status de entrega?

SELECT statusEntrega, AVG(frete) AS MediaFrete
FROM entregas e
INNER JOIN pedidos p ON e.idPedido = p.idPedido
GROUP BY statusEntrega;

-- Query 4: Qual o total de produtos em estoque por categoria?

SELECT categoria,COUNT(idProduto) AS TotalProdutos
FROM produtos
GROUP BY categoria;

-- QUERY 5:  Quais os produtos fornecidos e seus estoques?
SELECT p.nomeProduto AS Produto, f.razaoSocial AS Fornecedor, e.quantidade AS Estoque
FROM produtos p
INNER JOIN produtosFornecedores pf ON p.idProduto = pf.idProduto
INNER JOIN fornecedores f ON pf.idFornecedor = f.idFornecedor
INNER JOIN estoqueProdutos e ON p.idProduto = e.idProduto;

-- Query 6: Quais os produtos mais avaliados?
SELECT nomeProduto, avaliacao
FROM produtos
ORDER BY avaliacao DESC
LIMIT 5;


