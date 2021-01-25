drop schema public cascade;
create schema public;

--Criação das Tabelas
CREATE TABLE Pessoa (
    idPessoa SERIAL PRIMARY KEY,
    cpfCnpj varchar(14) UNIQUE NOT NULL,
    numero varchar(5),
    complemento varchar(15),
    bairro varchar(20),
    Nome varchar(50) NOT NULL,
    email varchar(30),
    cep varchar(8),
    logradouro varchar(30),
    fk_IdCidade int     
);

CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome varchar(50) NOT NULL,
    userName varchar(100) UNIQUE NOT NULL,
    email varchar(45) UNIQUE NOT NULL,
    senha varchar(1000) NOT NULL,
    ativo boolean
);

CREATE TABLE Fornecedor (
    idFornecedor SERIAL,
    fk_IdPessoa int NOT NULL,
    ativo boolean,
    tipoFornecedor int NOT NULL,    
    PRIMARY KEY (idFornecedor, fk_IdPessoa)
);

CREATE TABLE Cliente (
    idCliente SERIAL,
    fk_IdPessoa int NOT NULL,
    tipoCliente int NOT NULL,
    ativo boolean,
    nascimento date,
    PRIMARY KEY (idCliente, fk_IdPessoa)
);

CREATE TABLE Telefone (
    idTelefone SERIAL PRIMARY KEY,
    fk_IdPessoa int NOT NULL,
    ddd varchar(3) NOT NULL,
    telefone varchar(9) NOT NULL,
    tipoTelefone int,
    whatsApp boolean
);

CREATE TABLE Produto (
    idProduto SERIAL PRIMARY KEY,
    nome varchar(30) UNIQUE NOT NULL,
    ativo boolean
);

CREATE TABLE ServicoPrestado (
    idServPrest SERIAL PRIMARY KEY,
    fk_IdProduto int NOT NULL,
    nome varchar(35) NOT NULL,
    valorUnitario decimal NOT NULL,
    ativo boolean    
);

CREATE TABLE FormaPagamento (
    idFormaPag SERIAL PRIMARY KEY,
    nome varchar(30) NOT NULL,
    qtdParcela int NOT NULL,
    ativo boolean
);

CREATE TABLE ContratoParcela (
    idContratoParcela SERIAL PRIMARY KEY,
    fk_IdContrato int NOT NULL,
    numParcela int NOT NULL,
    valorParcela decimal NOT NULL,
    dataVencimento date NOT NULL,
    situacao int,
    comissao decimal,
    ajuste decimal    
);

CREATE TABLE ContratoServico (
    idContratoServicoPrestado SERIAL PRIMARY KEY,
    fk_IdContrato int NOT NULL,
    fk_IdServicoPrestado int NOT NULL,
    valorUnitario decimal NOT NULL,
    quantidade int NOT NULL,
    valorTotal decimal NOT NULL    
);

CREATE TABLE Vendedor (
    idVendedor SERIAL PRIMARY KEY,
    nome varchar(50) NOT NULL,
    cpf varchar(11),
    ativo boolean,
    codigo varchar(4),
    percComis decimal NOT NULL
);

CREATE TABLE ContratoParcelaPagamento (
    idContratoParcelaPgto SERIAL PRIMARY KEY,
    fk_IdContratoParcela int NOT NULL,
    dataPagamento date NOT NULL,
    comissao decimal,
    valorPagamento decimal NOT NULL,
    juros decimal    
);

CREATE TABLE Contrato (
    idContrato SERIAL PRIMARY KEY,
    fk_IdCliente int NOT NULL,
    qntdExemplares int,
    tipoDocumento int NOT NULL,
    numParcelas int NOT NULL,
    valorTotal decimal NOT NULL,
    juros decimal,
    ajuste decimal,
    observacoes varchar(300),    
    ativo boolean,
    dataInicio date NOT NULL,
    periodoMeses int NOT NULL,
    dataTermino date NOT NULL,
    fk_IdFormaPag int NOT NULL,
    fk_IdVendedor int NOT NULL,
    fk_IdUsuario int NOT NULL,    
    fk_IdPessoa int NOT NULL
);

CREATE TABLE ContaPagar (
    idContaPagar SERIAL PRIMARY KEY,
    fk_IdFornecedor int NOT NULL,
    valorTotal decimal,
    valorMensal decimal,
    mesInicial int NOT NULL,
    diaInicial int,
    diasPagamento varchar(15),
    numParcelas int NOT NULL,
    juros decimal,
    ajuste decimal,       
    fk_IdPessoa int NOT NULL
);

CREATE TABLE ContaPagarParcela (
    idContaPagarParcela SERIAL PRIMARY KEY,
    fk_IdContaPagar int NOT NULL,
    dataVencimento date NOT NULL,
    valorParcela decimal NOT NULL,
    numParcela int NOT NULL,
    ajuste decimal    
);

CREATE TABLE ContaPagarParcelaPagamento (
    idContaPagarParcelaPgto SERIAL PRIMARY KEY,
    fk_IdContaPagarParcela int NOT NULL,
    dataPagamento date NOT NULL,
    valorPagamento decimal NOT NULL,
    juros decimal
);

CREATE TABLE Cidades (
    idCidade SERIAL PRIMARY KEY,
    cidade varchar(35) NOT NULL,
    estado varchar(2) NOT NULL
);
 
-- Atribuição de Chaves Estrangeiras
ALTER TABLE Pessoa ADD CONSTRAINT FK_Pessoa
    FOREIGN KEY (fk_IdCidade)
    REFERENCES Cidades (idCidade)
    ON DELETE CASCADE;

ALTER TABLE Fornecedor ADD CONSTRAINT FK_Fornecedor
    FOREIGN KEY (fk_IdPessoa)
    REFERENCES Pessoa (idPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente
    FOREIGN KEY (fk_IdPessoa)
    REFERENCES Pessoa (idPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE Telefone ADD CONSTRAINT FK_Telefone
    FOREIGN KEY (fk_IdPessoa)
    REFERENCES Pessoa (idPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE ServicoPrestado ADD CONSTRAINT FK_ServicoPrestado
    FOREIGN KEY (fk_IdProduto)
    REFERENCES Produto (idProduto)
    ON DELETE RESTRICT;
 
ALTER TABLE ContratoParcela ADD CONSTRAINT FK_ContratoParcela
    FOREIGN KEY (fk_IdContrato)
    REFERENCES Contrato (idContrato)
    ON DELETE CASCADE;
 
ALTER TABLE ContratoServico ADD CONSTRAINT FK_ContratoServico
    FOREIGN KEY (fk_IdContrato)
    REFERENCES Contrato (idContrato)
    ON DELETE CASCADE;
 
ALTER TABLE ContratoServico ADD CONSTRAINT FK_ContratoServico_2
    FOREIGN KEY (fk_IdServicoPrestado)
    REFERENCES ServicoPrestado (idServPrest)
    ON DELETE CASCADE;
 
ALTER TABLE ContratoParcelaPagamento ADD CONSTRAINT FK_ContratoParcelaPagamento
    FOREIGN KEY (fk_IdContratoParcela)
    REFERENCES ContratoParcela (idContratoParcela)
    ON DELETE CASCADE;
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato
    FOREIGN KEY (fk_IdFormaPag)
    REFERENCES FormaPagamento (idFormaPag)
    ON DELETE CASCADE;
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_2
    FOREIGN KEY (fk_IdVendedor)
    REFERENCES Vendedor (idVendedor)
    ON DELETE CASCADE;
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_3
    FOREIGN KEY (fk_IdUsuario)
    REFERENCES Usuario (idUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_4
    FOREIGN KEY (fk_IdCliente, fk_IdPessoa)
    REFERENCES Cliente (idCliente, fk_IdPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE ContaPagar ADD CONSTRAINT FK_ContaPagar
    FOREIGN KEY (fk_IdFornecedor, fk_IdPessoa)
    REFERENCES Fornecedor (idFornecedor, fk_IdPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE ContaPagarParcela ADD CONSTRAINT FK_ContaPagarParcela
    FOREIGN KEY (fk_IdContaPagar)
    REFERENCES ContaPagar (idContaPagar);
 
ALTER TABLE ContaPagarParcelaPagamento ADD CONSTRAINT FK_ContaPagarParcelaPagamento
    FOREIGN KEY (fk_IdContaPagarParcela)
    REFERENCES ContaPagarParcela (idContaPagarParcela)
    ON DELETE CASCADE;