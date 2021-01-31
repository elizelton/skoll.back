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
	
-- Triggers e Functions para Insert e Update sem FK (Geral)
--Regras Pessoa
CREATE FUNCTION pessoa_trigger() RETURNS trigger AS $pessoa_trigger$
    BEGIN
        IF NEW.Nome IS NULL or NEW.Nome = '' THEN
            RAISE EXCEPTION 'O Nome do Cadastrado não pode ser vazio';
        END IF;		
		IF NEW.cpfCnpj IS NULL or NEW.cpfCnpj = '' THEN
            RAISE EXCEPTION 'O Documento do Cadastrado não pode ser vazio';
        END IF;
        IF EXISTS (SELECT 1 FROM PESSOA WHERE cpfCnpj = NEW.cpfCnpj and idPessoa <> NEW.idPessoa) THEN
            RAISE EXCEPTION 'CPF ou CNPJ já cadastrado';
        END IF;
		RETURN NEW;
    END;
  $pessoa_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER pessoa_trigger BEFORE INSERT OR UPDATE ON Pessoa
    FOR EACH ROW EXECUTE PROCEDURE pessoa_trigger();
	
-- Regras Usuario
CREATE FUNCTION usuario_trigger() RETURNS trigger AS $usuario_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O Nome do Usuário não pode ser vazio';
        END IF;
		IF NEW.userName IS NULL or NEW.userName = '' THEN
            RAISE EXCEPTION 'O Usuário deve possuir um nome de usuário';
        END IF;
        IF NEW.email IS NULL or NEW.email = '' THEN
            RAISE EXCEPTION 'O Usuário deve possuir um e-mail';
        END IF;
        IF EXISTS (SELECT 1 FROM USUARIO WHERE userName = NEW.userName and idUsuario <> NEW.idUsuario) THEN
            RAISE EXCEPTION 'Nome de usuário já cadastrado';
        END IF;
		IF NEW.senha IS NULL or NEW.senha = '' THEN
            RAISE EXCEPTION 'O Usuário deve ter uma senha';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $usuario_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER usuario_trigger BEFORE INSERT OR UPDATE ON Usuario
    FOR EACH ROW EXECUTE PROCEDURE usuario_trigger();

-- Regras Fornecedor
CREATE FUNCTION fornecedorinsert_trigger() RETURNS trigger AS $fornecedorinsert_trigger$
    BEGIN
        IF NEW.tipoFornecedor IS NULL or NEW.tipoFornecedor <= 0 or NEW.tipoFornecedor > 2 THEN
            RAISE EXCEPTION 'O Tipo de Fornecedor deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Fornecedor deve estar atrelado a uma Pessoa';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $fornecedorinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER fornecedorinsert_trigger BEFORE INSERT ON Fornecedor
    FOR EACH ROW EXECUTE PROCEDURE fornecedorinsert_trigger();
	
-- Regras Cliente
CREATE FUNCTION clienteinsert_trigger() RETURNS trigger AS $clienteinsert_trigger$
    BEGIN
        IF NEW.tipoCliente IS NULL or NEW.tipoCliente <= 0 or NEW.tipoCliente > 2 THEN
            RAISE EXCEPTION 'O Tipo de Cliente deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Cliente deve estar atrelado a uma Pessoa';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $clienteinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER clienteinsert_trigger BEFORE INSERT ON Cliente
    FOR EACH ROW EXECUTE PROCEDURE clienteinsert_trigger();
	
-- Regras Telefone
CREATE FUNCTION telefoneinsert_trigger() RETURNS trigger AS $telefoneinsert_trigger$
    BEGIN
        IF NEW.ddd IS NULL or NEW.ddd = '' THEN
            RAISE EXCEPTION 'O DDD deve ser informado';
        END IF;
		IF NEW.telefone IS NULL or NEW.telefone = '' THEN
            RAISE EXCEPTION 'O Telefone deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Telefone deve estar atrelado a uma Pessoa';
        END IF;
        IF NEW.tipoTelefone IS NULL or NEW.tipoTelefone <= 0 or NEW.tipoTelefone > 3 THEN
            RAISE EXCEPTION 'O Tipo do Telefone deve ser informado';
        END IF;
		RETURN NEW;
    END;
  $telefoneinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER telefoneinsert_trigger BEFORE INSERT ON Telefone
    FOR EACH ROW EXECUTE PROCEDURE telefoneinsert_trigger();
	
-- Regras Produto
CREATE FUNCTION produto_trigger() RETURNS trigger AS $produto_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O nome do Produto deve ser informado';
        END IF;
        IF EXISTS (SELECT 1 FROM PRODUTO WHERE nome = NEW.nome) THEN
            RAISE EXCEPTION 'Nome de produto já cadastrado';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;        
		RETURN NEW;
    END;
  $produto_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER produto_trigger BEFORE INSERT OR UPDATE ON Produto
    FOR EACH ROW EXECUTE PROCEDURE produto_trigger();
	
-- Regras Serviço Prestado
CREATE FUNCTION servicoprestadoinsert_trigger() RETURNS trigger AS $servicoprestadoinsert_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O nome do Serviço Prestado deve ser informado';
        END IF;
		IF NEW.valorUnitario IS NULL or NEW.valorUnitario <= 0 THEN
            RAISE EXCEPTION 'O Serviço Prestado deve ter um valor unitário';
        END IF;
		IF NEW.fk_IdProduto IS NULL or NEW.fk_IdProduto <= 0 THEN
            RAISE EXCEPTION 'O Serviço Prestado deve estar atrelado a um Produto';
        END IF;
        IF EXISTS (SELECT 1 FROM ServicoPrestado WHERE nome = NEW.nome AND fk_IdProduto = new.fk_IdProduto and idServPrest <> NEW.idServPrest) THEN
            RAISE EXCEPTION 'Nome de serviço já cadastrado para o produto selecionado';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM PRODUTO WHERE idProduto = NEW.fk_IdProduto and ativo = true) THEN
            RAISE EXCEPTION 'Produto não está ativo';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $servicoprestadoinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER servicoprestadoinsert_trigger BEFORE INSERT ON ServicoPrestado
    FOR EACH ROW EXECUTE PROCEDURE servicoprestadoinsert_trigger();
	
-- Regras Formas de Pagamento
CREATE FUNCTION formapagamento_trigger() RETURNS trigger AS $formapagamento_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O nome da Forma de Pagamento deve ser informada';
        END IF;
		IF NEW.qtdParcela IS NULL or NEW.qtdParcela <= 0 THEN
            RAISE EXCEPTION 'A forma de pagamento deve ter um valor máximo de parcelas';
        END IF;
        IF EXISTS (SELECT 1 FROM FormaPagamento WHERE nome = NEW.nome and idFormaPag <> NEW.idFormaPag) THEN
            RAISE EXCEPTION 'Nome de forma de pagamento já cadastrado';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $formapagamento_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER formapagamento_trigger BEFORE INSERT OR UPDATE ON FormaPagamento
    FOR EACH ROW EXECUTE PROCEDURE formapagamento_trigger();
	
-- Regras Vendedor
CREATE FUNCTION vendedor_trigger() RETURNS trigger AS $vendedor_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O nome do Vendedor deve ser informada';
        END IF;
		IF NEW.percComis IS NULL or NEW.percComis <= 0 THEN
            RAISE EXCEPTION 'O Vendedor deve ter um percentual de comissão válido';
        END IF;
        IF NEW.Cpf is not null and NEW.Cpf <> '' THEN
            IF EXISTS (SELECT 1 FROM Vendedor WHERE cpf = NEW.cpf) THEN
                RAISE EXCEPTION 'CPF de Vendedor já cadastrado';
            END IF;
        END IF;
        IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $vendedor_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER vendedor_trigger BEFORE INSERT OR UPDATE ON Vendedor
    FOR EACH ROW EXECUTE PROCEDURE vendedor_trigger();
	
-- Regras Contrato Parcela
CREATE FUNCTION contratoparcelainsert_trigger() RETURNS trigger AS $contratoparcelainsert_trigger$
    BEGIN
        IF NEW.numParcela IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O número da parcela do contrato deve ser informado';
        END IF;
		IF NEW.valorParcela IS NULL or NEW.valorParcela <= 0 THEN
            RAISE EXCEPTION 'O valor da parcela do contrato deve ser informado';
        END IF;
		IF NEW.dataVencimento IS NULL THEN
            RAISE EXCEPTION 'A data de vencimento da parcela do contrato deve ser informada';
        END IF;
		IF NEW.fk_IdContrato IS NULL or NEW.fk_IdContrato <= 0 THEN
            RAISE EXCEPTION 'A parcela deve estar atrelada a um contrato';
        END IF;
		IF NEW.Situacao IS NULL or NEW.Situacao <= 0 or NEW.Situacao > 3 THEN
            NEW.Situacao := 1;
        END IF;
		RETURN NEW;
    END;
  $contratoparcelainsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoparcelainsert_trigger BEFORE INSERT ON ContratoParcela
    FOR EACH ROW EXECUTE PROCEDURE contratoparcelainsert_trigger();
	
-- Regras Conta Pagar Parcela
CREATE FUNCTION contapagarparcelainsert_trigger() RETURNS trigger AS $contapagarparcelainsert_trigger$
    BEGIN
        IF NEW.numParcela IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O número da parcela da conta a pagar deve ser informado';
        END IF;
		IF NEW.valorParcela IS NULL or NEW.valorParcela <= 0 THEN
            RAISE EXCEPTION 'O valor da parcela da conta a pagar deve ser informado';
        END IF;
		IF NEW.dataVencimento IS NULL THEN
            RAISE EXCEPTION 'A data de vencimento da parcela da conta a pagar deve ser informada';
        END IF;
		IF NEW.pk_IdContaPagar IS NULL or NEW.pk_IdContaPagar <= 0 THEN
            RAISE EXCEPTION 'A parcela deve estar atrelada a uma conta a pagar';
        END IF;
		IF NEW.Situacao IS NULL or NEW.Situacao <= 0 or NEW.Situacao > 3 THEN
            NEW.Situacao := 1;
        END IF;
		RETURN NEW;
    END;
  $contapagarparcelainsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarparcelainsert_trigger BEFORE INSERT ON ContaPagarParcela
    FOR EACH ROW EXECUTE PROCEDURE contapagarparcelainsert_trigger();
	
-- Regras Contrato Serviço
CREATE FUNCTION contratoservicoinsert_trigger() RETURNS trigger AS $contratoservicoinsert_trigger$
    BEGIN
        IF NEW.valorUnitario IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O valor unitário do Serviço Prestado no contrato deve ser informado';
        END IF;
		IF NEW.quantidade IS NULL or NEW.quantidade <= 0 THEN
            RAISE EXCEPTION 'A quantidade deve ser informada';
        END IF;
		IF NEW.valorTotal IS NULL or NEW.valorTotal < 0 THEN
            RAISE EXCEPTION 'O valor total não deve ser menor que 0';
        END IF;
		IF NEW.fk_IdContrato IS NULL or NEW.fk_IdContrato <= 0 THEN
            RAISE EXCEPTION 'O registro deve estar atrelado a um contrato';
        END IF;
		IF NEW.fk_IdServicoPrestado IS NULL or NEW.fk_IdServicoPrestado <= 0 THEN
            RAISE EXCEPTION 'O registro deve possuir um serviço prestado';
        END IF;
		RETURN NEW;
    END;
  $contratoservicoinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoservicoinsert_trigger BEFORE INSERT ON ContratoServico
    FOR EACH ROW EXECUTE PROCEDURE contratoservicoinsert_trigger();
	
-- Regras Contrato Parcela Pagamento
CREATE FUNCTION contratoparcelapagamentoinsert_trigger() RETURNS trigger AS $contratoparcelapagamentoinsert_trigger$
    BEGIN
        IF NEW.dataPagamento IS NULL THEN
            RAISE EXCEPTION 'A data de pagamento deve ser informada';
        END IF;
		IF NEW.valorPagamento IS NULL or NEW.valorPagamento = 0 THEN
            RAISE EXCEPTION 'O valor de pagamento não deve ser igual a 0';
        END IF;
		IF NEW.fk_IdContratoParcela IS NULL or NEW.fk_IdContratoParcela <= 0 THEN
            RAISE EXCEPTION 'O pagamento deve estar atlelado a uma parcela';
        END IF;
		RETURN NEW;
    END;
  $contratoparcelapagamentoinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoparcelapagamentoinsert_trigger BEFORE INSERT ON ContratoParcelaPagamento
    FOR EACH ROW EXECUTE PROCEDURE contratoparcelapagamentoinsert_trigger();
	
-- Regras Conta Pagar Parcela Pagamento
CREATE FUNCTION contapagarparcelapagamentoinsert_trigger() RETURNS trigger AS $contapagarparcelapagamentoinsert_trigger$
    BEGIN
        IF NEW.dataPagamento IS NULL THEN
            RAISE EXCEPTION 'A data de pagamento deve ser informada';
        END IF;
		IF NEW.valorPagamento IS NULL or NEW.valorPagamento = 0 THEN
            RAISE EXCEPTION 'O valor de pagamento não deve ser igual a 0';
        END IF;
		IF NEW.fk_IdContaPagarParcela IS NULL or NEW.fk_IdContaPagarParcela <= 0 THEN
            RAISE EXCEPTION 'O pagamento deve estar atlelado a uma parcela';
        END IF;
		RETURN NEW;
    END;
  $contapagarparcelapagamentoinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarparcelapagamentoinsert_trigger BEFORE INSERT ON ContaPagarParcelaPagamento
    FOR EACH ROW EXECUTE PROCEDURE contapagarparcelapagamentoinsert_trigger();
	
-- Regras Conta Pagar 
CREATE FUNCTION contapagarinsert_trigger() RETURNS trigger AS $contapagarinsert_trigger$
    BEGIN
        IF NEW.mesInicial IS NULL or NEW.mesInicial <= 0 or NEW.mesInicial > 12 THEN
            RAISE EXCEPTION 'O mês inicial deve ser informado';
        END IF;
		IF NEW.numParcelas IS NULL or NEW.numParcelas <= 0 THEN
            RAISE EXCEPTION 'O número de parcelas deve ser informado';
        END IF;
		IF (NEW.valorTotal IS NULL or NEW.valorTotal <= 0) and (NEW.valorMensal IS NULL or NEW.valorMensal <= 0) THEN
            RAISE EXCEPTION 'O valor total ou mensal deve ser informado';
        END IF;
		IF NEW.fk_IdFornecedor IS NULL or NEW.fk_IdFornecedor <= 0 THEN
            RAISE EXCEPTION 'A conta deve estar atlelada a um fornecedor';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'A conta deve estar atlelada a uma Pessoa';
        END IF;
		RETURN NEW;
    END;
  $contapagarinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarinsert_trigger BEFORE INSERT ON ContaPagar
    FOR EACH ROW EXECUTE PROCEDURE contapagarinsert_trigger();
	
-- Regras Contrato
CREATE FUNCTION contratoinsert_trigger() RETURNS trigger AS $contratoinsert_trigger$
    BEGIN
		IF NEW.dataInicio IS NULL THEN
            RAISE EXCEPTION 'A data de início do Contrato deve ser informada';
        END IF;
        IF NEW.dataTermino IS NULL THEN
            RAISE EXCEPTION 'A data de término do Contrato deve ser informada';
        END IF;
		IF NEW.periodoMeses IS NULL or NEW.periodoMeses <= 0 THEN
            RAISE EXCEPTION 'A quantidade de meses do Contrato deve ser informada';
        END IF;
		IF NEW.tipoDocumento IS NULL or NEW.tipoDocumento <= 0 or NEW.tipoDocumento > 2 THEN
            RAISE EXCEPTION 'O tipo de documento deve ser informado';
        END IF;
        IF NEW.numParcelas IS NULL or NEW.numParcelas <= 0 THEN
            RAISE EXCEPTION 'O número de parcelas deve ser informado';
        END IF;
		IF NEW.valorTotal IS NULL or NEW.valorTotal <= 0 THEN
            RAISE EXCEPTION 'O valor total deve ser informado';
        END IF;
		IF NEW.fk_IdFormaPag IS NULL or NEW.fk_IdFormaPag <= 0 THEN
            RAISE EXCEPTION 'A forma de pagamento deve ser informada';
        END IF;
		IF NEW.fk_IdVendedor IS NULL or NEW.fk_IdVendedor <= 0 THEN
            RAISE EXCEPTION 'O Vendedor deve ser informado';
        END IF;
		IF NEW.fk_IdUsuario IS NULL or NEW.fk_IdUsuario <= 0 THEN
            RAISE EXCEPTION 'O Usuário que está incluindo deve ser informado';
        END IF;
		IF NEW.fk_IdCliente IS NULL or NEW.fk_IdCliente <= 0 THEN
            RAISE EXCEPTION 'O Contrato deve estar atlelada a um Cliente';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Contrato deve estar atlelada a uma Pessoa';
        END IF;
        IF EXISTS (SELECT 1 FROM FORMAPAGAMENTO WHERE idFormaPag = NEW.fk_IdFormaPag and qtdParcela < NEW.numParcelas) THEN
            RAISE EXCEPTION 'O número de parcelas do contrato excede o permitido pela forma de pagamento';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $contratoinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoinsert_trigger BEFORE INSERT ON Contrato
    FOR EACH ROW EXECUTE PROCEDURE contratoinsert_trigger();

--Regras Cidades
CREATE FUNCTION cidadesinsert_trigger() RETURNS trigger AS $cidadesinsert_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM CIDADES WHERE cidade = NEW.cidade and estado = NEW.estado) THEN
            RAISE EXCEPTION 'Cidade já cadastrada';
        END IF;
		RETURN NEW;
    END;
  $cidadesinsert_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER cidadesinsert_trigger BEFORE INSERT OR UPDATE ON Cidades
    FOR EACH ROW EXECUTE PROCEDURE cidadesinsert_trigger();
	
-- Triggers e Functions para Update
-- Regras Fornecedor
CREATE FUNCTION fornecedorupdate_trigger() RETURNS trigger AS $fornecedorupdate_trigger$
    BEGIN
        IF NEW.tipoFornecedor IS NULL or NEW.tipoFornecedor <= 0 or NEW.tipoFornecedor > 2 THEN
            RAISE EXCEPTION 'O Tipo de Fornecedor deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Fornecedor deve estar atrelado a uma Pessoa';
        END IF;
        IF NEW.fk_IdPessoa <> OLD.fk_IdPessoa THEN
            RAISE EXCEPTION 'A Pessoa atrelada ao fornecedor não pode ser alterada';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $fornecedorupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER fornecedorupdate_trigger BEFORE UPDATE ON Fornecedor
    FOR EACH ROW EXECUTE PROCEDURE fornecedorupdate_trigger();
	
-- Regras Cliente
CREATE FUNCTION clienteupdate_trigger() RETURNS trigger AS $clienteupdate_trigger$
    BEGIN
        IF NEW.tipoCliente IS NULL or NEW.tipoCliente <= 0 or NEW.tipoCliente > 2 THEN
            RAISE EXCEPTION 'O Tipo de Cliente deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Cliente deve estar atrelado a uma Pessoa';
        END IF;
        IF NEW.fk_IdPessoa <> OLD.fk_IdPessoa THEN
            RAISE EXCEPTION 'A Pessoa atrelada ao cliente não pode ser alterada';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $clienteupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER clienteupdate_trigger BEFORE UPDATE ON Cliente
    FOR EACH ROW EXECUTE PROCEDURE clienteupdate_trigger();
	
-- Regras Telefone
CREATE FUNCTION telefoneupdate_trigger() RETURNS trigger AS $telefoneupdate_trigger$
    BEGIN
        IF NEW.ddd IS NULL or NEW.ddd = '' THEN
            RAISE EXCEPTION 'O DDD deve ser informado';
        END IF;
		IF NEW.telefone IS NULL or NEW.telefone = '' THEN
            RAISE EXCEPTION 'O Telefone deve ser informado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Telefone deve estar atrelado a uma Pessoa';
        END IF;
        IF NEW.fk_IdPessoa <> OLD.fk_IdPessoa THEN
            RAISE EXCEPTION 'A Pessoa atrelada ao telefone não pode ser alterada';
        END IF;
        IF NEW.tipoTelefone IS NULL or NEW.tipoTelefone <= 0 or NEW.tipoTelefone > 3 THEN
            RAISE EXCEPTION 'O Tipo do Telefone deve ser informado';
        END IF;
		RETURN NEW;
    END;
  $telefoneupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER telefoneupdate_trigger BEFORE UPDATE ON Telefone
    FOR EACH ROW EXECUTE PROCEDURE telefoneupdate_trigger();
	
-- Regras Serviço Prestado
CREATE FUNCTION servicoprestadoupdate_trigger() RETURNS trigger AS $servicoprestadoupdate_trigger$
    BEGIN
        IF NEW.nome IS NULL or NEW.nome = '' THEN
            RAISE EXCEPTION 'O nome do Serviço Prestado deve ser informado';
        END IF;
		IF NEW.valorUnitario IS NULL or NEW.valorUnitario <= 0 THEN
            RAISE EXCEPTION 'O Serviço Prestado deve ter um valor unitário';
        END IF;
		IF NEW.fk_IdProduto IS NULL or NEW.fk_IdProduto <= 0 THEN
            RAISE EXCEPTION 'O Serviço Prestado deve estar atrelado a um Produto';
        END IF;
        IF NEW.fk_IdProduto <> OLD.fk_IdProduto THEN
            RAISE EXCEPTION 'O Produto atrelado ao serviço prestado não pode ser alterado';
        END IF;
        IF EXISTS (SELECT 1 FROM ServicoPrestado WHERE nome = NEW.nome AND fk_IdProduto = new.fk_IdProduto) THEN
            RAISE EXCEPTION 'Nome de serviço já cadastrado para o produto selecionado';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM PRODUTO WHERE idProduto = NEW.fk_IdProduto and ativo = true) THEN
            RAISE EXCEPTION 'Produto não está ativo';
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $servicoprestadoupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER servicoprestadoupdate_trigger BEFORE UPDATE ON ServicoPrestado
    FOR EACH ROW EXECUTE PROCEDURE servicoprestadoupdate_trigger();
	
-- Regras Contrato Parcela
CREATE FUNCTION contratoparcelaupdate_trigger() RETURNS trigger AS $contratoparcelaupdate_trigger$
    BEGIN
        IF NEW.numParcela IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O número da parcela do contrato deve ser informado';
        END IF;
		IF NEW.valorParcela IS NULL or NEW.valorParcela <= 0 THEN
            RAISE EXCEPTION 'O valor da parcela do contrato deve ser informado';
        END IF;
		IF NEW.dataVencimento IS NULL THEN
            RAISE EXCEPTION 'A data de vencimento da parcela do contrato deve ser informada';
        END IF;
		IF NEW.fk_IdContrato IS NULL or NEW.fk_IdContrato <= 0 THEN
            RAISE EXCEPTION 'A parcela deve estar atrelada a um contrato';
        END IF;
        IF NEW.fk_IdContrato <> OLD.fk_IdContrato THEN
            RAISE EXCEPTION 'O Contrato correspondente a parcela não pode ser alterado';
        END IF;
		IF NEW.Situacao IS NULL or NEW.Situacao <= 0 or NEW.Situacao > 3 THEN
            NEW.Situacao := 1;
        END IF;
		RETURN NEW;
    END;
  $contratoparcelaupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoparcelaupdate_trigger BEFORE UPDATE ON ContratoParcela
    FOR EACH ROW EXECUTE PROCEDURE contratoparcelaupdate_trigger();
	
-- Regras Conta Pagar Parcela
CREATE FUNCTION contapagarparcelaupdate_trigger() RETURNS trigger AS $contapagarparcelaupdate_trigger$
    BEGIN
        IF NEW.numParcela IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O número da parcela da conta a pagar deve ser informado';
        END IF;
		IF NEW.valorParcela IS NULL or NEW.valorParcela <= 0 THEN
            RAISE EXCEPTION 'O valor da parcela da conta a pagar deve ser informado';
        END IF;
		IF NEW.dataVencimento IS NULL THEN
            RAISE EXCEPTION 'A data de vencimento da parcela da conta a pagar deve ser informada';
        END IF;
		IF NEW.fk_IdContaPagar IS NULL or NEW.fk_IdContaPagar <= 0 THEN
            RAISE EXCEPTION 'A parcela deve estar atrelada a uma conta a pagar';
        END IF;
        IF NEW.fk_IdContaPagar <> OLD.fk_IdContaPagar THEN
            RAISE EXCEPTION 'A Conta a Pagar correspondente a parcela não pode ser alterado';
        END IF;
		IF NEW.Situacao IS NULL or NEW.Situacao <= 0 or NEW.Situacao > 3 THEN
            NEW.Situacao := 1;
        END IF;
		RETURN NEW;
    END;
  $contapagarparcelaupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarparcelaupdate_trigger BEFORE UPDATE ON ContaPagarParcela
    FOR EACH ROW EXECUTE PROCEDURE contapagarparcelaupdate_trigger();
	
-- Regras Contrato Serviço
CREATE FUNCTION contratoservicoupdate_trigger() RETURNS trigger AS $contratoservicoupdate_trigger$
    BEGIN
        IF NEW.valorUnitario IS NULL or NEW.numParcela <= 0 THEN
            RAISE EXCEPTION 'O valor unitário do Serviço Prestado no contrato deve ser informado';
        END IF;
		IF NEW.quantidade IS NULL or NEW.quantidade <= 0 THEN
            RAISE EXCEPTION 'A quantidade deve ser informada';
        END IF;
		IF NEW.valorTotal IS NULL or NEW.valorTotal < 0 THEN
            RAISE EXCEPTION 'O valor total não deve ser menor que 0';
        END IF;
		IF NEW.fk_IdContrato IS NULL or NEW.fk_IdContrato <= 0 THEN
            RAISE EXCEPTION 'O registro deve estar atrelado a um contrato';
        END IF;
        IF NEW.fk_IdContrato <> OLD.fk_IdContrato THEN
            RAISE EXCEPTION 'A Contrato correspondente ao serviço prestado não pode ser alterado';
        END IF;
		IF NEW.fk_IdServicoPrestado IS NULL or NEW.fk_IdServicoPrestado <= 0 THEN
            RAISE EXCEPTION 'O registro deve possuir um serviço prestado';
        END IF;
        IF NEW.fk_IdServicoPrestado <> OLD.fk_IdServicoPrestado THEN
            RAISE EXCEPTION 'O serviço prestado não pode ser alterado';
        END IF;
        IF EXISTS (SELECT 1 FROM ContratoServico WHERE fk_IdContrato = NEW.fk_IdContrato and fk_IdServicoPrestado = NEW.fk_IdServicoPrestado) THEN
            RAISE EXCEPTION 'Serviço Prestado já adicionado ao contrato';
        END IF;
		RETURN NEW;
    END;
  $contratoservicoupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoservicoupdate_trigger BEFORE UPDATE ON ContratoServico
    FOR EACH ROW EXECUTE PROCEDURE contratoservicoupdate_trigger();
	
-- Regras Contrato Parcela Pagamento
CREATE FUNCTION contratoparcelapagamentoupdate_trigger() RETURNS trigger AS $contratoparcelapagamentoupdate_trigger$
    BEGIN
        IF NEW.dataPagamento IS NULL THEN
            RAISE EXCEPTION 'A data de pagamento deve ser informada';
        END IF;
		IF NEW.valorPagamento IS NULL or NEW.valorPagamento = 0 THEN
            RAISE EXCEPTION 'O valor de pagamento não deve ser igual a 0';
        END IF;
		IF NEW.fk_IdContratoParcela IS NULL or NEW.fk_IdContratoParcela <= 0 THEN
            RAISE EXCEPTION 'O pagamento deve estar atlelado a uma parcela';
        END IF;
        IF NEW.fk_IdContratoParcela <> OLD.fk_IdContratoParcela THEN
            RAISE EXCEPTION 'A Parcela de contrato correspondente ao pagamento não pode ser alterada';
        END IF;
		RETURN NEW;
    END;
  $contratoparcelapagamentoupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoparcelapagamentoupdate_trigger BEFORE UPDATE ON ContratoParcelaPagamento
    FOR EACH ROW EXECUTE PROCEDURE contratoparcelapagamentoupdate_trigger();
	
-- Regras Conta Pagar Parcela Pagamento
CREATE FUNCTION contapagarparcelapagamentoupdate_trigger() RETURNS trigger AS $contapagarparcelapagamentoupdate_trigger$
    BEGIN
        IF NEW.dataPagamento IS NULL THEN
            RAISE EXCEPTION 'A data de pagamento deve ser informada';
        END IF;
		IF NEW.valorPagamento IS NULL or NEW.valorPagamento = 0 THEN
            RAISE EXCEPTION 'O valor de pagamento não deve ser igual a 0';
        END IF;
		IF NEW.fk_IdContaPagarParcela IS NULL or NEW.fk_IdContaPagarParcela <= 0 THEN
            RAISE EXCEPTION 'O pagamento deve estar atlelado a uma parcela';
        END IF;
        IF NEW.fk_IdContaPagarParcela <> OLD.fk_IdContaPagarParcela THEN
            RAISE EXCEPTION 'A Parcela de conta a pagar correspondente ao pagamento não pode ser alterada';
        END IF;
		RETURN NEW;
    END;
  $contapagarparcelapagamentoupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarparcelapagamentoupdate_trigger BEFORE UPDATE ON ContaPagarParcelaPagamento
    FOR EACH ROW EXECUTE PROCEDURE contapagarparcelapagamentoupdate_trigger();
	
-- Regras Conta Pagar 
CREATE FUNCTION contapagarupdate_trigger() RETURNS trigger AS $contapagarupdate_trigger$
    BEGIN
        IF NEW.mesInicial IS NULL or NEW.mesInicial <= 0 or NEW.mesInicial > 12 THEN
            RAISE EXCEPTION 'O mês inicial deve ser informado';
        END IF;
		IF NEW.numParcelas IS NULL or NEW.numParcelas <= 0 THEN
            RAISE EXCEPTION 'O número de parcelas deve ser informado';
        END IF;
		IF (NEW.valorTotal IS NULL or NEW.valorTotal <= 0) and (NEW.valorMensal IS NULL or NEW.valorMensal <= 0) THEN
            RAISE EXCEPTION 'O valor total ou mensal deve ser informado';
        END IF;
		IF NEW.fk_IdFornecedor IS NULL or NEW.fk_IdFornecedor <= 0 THEN
            RAISE EXCEPTION 'A conta deve estar atlelada a um fornecedor';
        END IF;
        IF NEW.fk_IdFornecedor <> OLD.fk_IdFornecedor THEN
            RAISE EXCEPTION 'O Fornecedor não pode ser alterado';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'A conta deve estar atlelada a uma Pessoa';
        END IF;
        IF NEW.fk_IdPessoa <> OLD.fk_IdPessoa THEN
            RAISE EXCEPTION 'A Pessoa não pode ser alterada';
        END IF;
        IF EXISTS (SELECT 1 FROM CONTAPAGARPARCELAPAGAMENTO T1, CONTRATOPARCELA T2 WHERE T2.fk_IdContaPagar = NEW.idContaPagar and t1.fk_IdContaPagarParcela = t2.idContaPagarParcela and t1.valorPagamento <> 0) THEN
            IF NEW.valorTotal <> OLD.valorTotal THEN
                 RAISE EXCEPTION 'Já houve pagamento de parcela(s) para essa Conta. Não é possível alterar o valor total. Para alterar o valor total do contrato é necessário inserir uma nova parcela de ajuste.';
            END IF;
        END IF;
		RETURN NEW;
    END;
  $contapagarupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarupdate_trigger BEFORE UPDATE ON ContaPagar
    FOR EACH ROW EXECUTE PROCEDURE contapagarupdate_trigger();
	
-- Regras Contrato
CREATE FUNCTION contratoupdate_trigger() RETURNS trigger AS $contratoupdate_trigger$
    BEGIN
		IF NEW.dataInicio IS NULL THEN
            RAISE EXCEPTION 'A data de início do Contrato deve ser informada';
        END IF;
        IF NEW.dataTermino IS NULL THEN
            RAISE EXCEPTION 'A data de término do Contrato deve ser informada';
        END IF;
		IF NEW.periodoMeses IS NULL or NEW.periodoMeses <= 0 THEN
            RAISE EXCEPTION 'A quantidade de meses do Contrato deve ser informada';
        END IF;
		IF NEW.tipoDocumento IS NULL or NEW.tipoDocumento <= 0 or NEW.tipoDocumento > 2 THEN
            RAISE EXCEPTION 'O tipo de documento deve ser informado';
        END IF;
        IF NEW.numParcelas IS NULL or NEW.numParcelas <= 0 THEN
            RAISE EXCEPTION 'O número de parcelas deve ser informado';
        END IF;
		IF NEW.valorTotal IS NULL or NEW.valorTotal <= 0 THEN
            RAISE EXCEPTION 'O valor total deve ser informado';
        END IF;
		IF NEW.fk_IdFormaPag IS NULL or NEW.fk_IdFormaPag <= 0 THEN
            RAISE EXCEPTION 'A forma de pagamento deve ser informada';
        END IF;
		IF NEW.fk_IdVendedor IS NULL or NEW.fk_IdVendedor <= 0 THEN
            RAISE EXCEPTION 'O Vendedor deve ser informado';
        END IF;
        IF NEW.fk_IdVendedor <> OLD.fk_IdVendedor THEN
            RAISE EXCEPTION 'O Vendedor não pode ser alterado';
        END IF;
		IF NEW.fk_IdUsuario IS NULL or NEW.fk_IdUsuario <= 0 THEN
            RAISE EXCEPTION 'O Usuário que está incluindo deve ser informado';
        END IF;
        IF NEW.fk_IdUsuario <> OLD.fk_IdUsuario THEN
            RAISE EXCEPTION 'O Usuário responsável não pode ser alterado';
        END IF;
		IF NEW.fk_IdCliente IS NULL or NEW.fk_IdCliente <= 0 THEN
            RAISE EXCEPTION 'O Contrato deve estar atlelada a um Cliente';
        END IF;
		IF NEW.fk_IdPessoa IS NULL or NEW.fk_IdPessoa <= 0 THEN
            RAISE EXCEPTION 'O Contrato deve estar atlelada a uma Pessoa';
        END IF;
        IF NEW.fk_IdCliente <> OLD.fk_IdCliente THEN
            RAISE EXCEPTION 'O Cliente não pode ser alterado';
        END IF;
        IF NEW.fk_IdPessoa <> OLD.fk_IdPessoa THEN
            RAISE EXCEPTION 'A Pessoa não pode ser alterada';
        END IF;
        IF EXISTS (SELECT 1 FROM FORMAPAGAMENTO WHERE idFormaPag = NEW.fk_IdFormaPag and qtdParcela < NEW.numParcelas) THEN
            RAISE EXCEPTION 'O número de parcelas do contrato excede o permitido pela forma de pagamento';
        END IF;
        IF EXISTS (SELECT 1 FROM CONTRATOPARCELAPAGAMENTO T1, CONTRATOPARCELA T2 WHERE T2.fk_IdContrato = NEW.idContrato and t1.fk_IdContratoParcela = t2.idContratoParcela and t1.valorPagamento <> 0) THEN
            IF NEW.valorTotal <> OLD.valorTotal THEN
                 RAISE EXCEPTION 'Já houve pagamento de parcela(s) para esse Contrato. Não é possível alterar o valor total. Para alterar o valor total do contrato é necessário inserir uma nova parcela de ajuste.';
            END IF;
        END IF;
		IF NEW.Ativo IS NULL THEN
            NEW.Ativo := true;
        END IF;
		RETURN NEW;
    END;
  $contratoupdate_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoupdate_trigger BEFORE UPDATE ON Contrato
    FOR EACH ROW EXECUTE PROCEDURE contratoupdate_trigger();

--Regras Cidades
CREATE FUNCTION cidadesupdate_trigger() RETURNS trigger as $cidadesupdate_trigger$
    BEGIN
        RAISE EXCEPTION 'A Cidade não pode ser alterada';
    END 
   $cidadesupdate_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER cidadesupdate_trigger BEFORE UPDATE ON Cidades
    FOR EACH ROW EXECUTE PROCEDURE cidadesupdate_trigger();   
	
-- Triggers e Functions para Delete
--Regras Pessoa
CREATE FUNCTION pessoadelete_trigger() RETURNS trigger AS $pessoadelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM Fornecedor WHERE fk_IdPessoa = OLD.IdPessoa) OR EXISTS (SELECT 1 FROM Cliente WHERE fk_IdPessoa = OLD.IdPessoa) THEN
            RAISE EXCEPTION 'Pessoa ja atrelada a um fornecedor ou cliente';
        END IF;
        IF EXISTS (SELECT 1 FROM ContaPagar WHERE fk_IdPessoa = OLD.IdPessoa) OR EXISTS (SELECT 1 FROM Contrato WHERE fk_IdPessoa = OLD.IdPessoa) THEN
            RAISE EXCEPTION 'Pessoa ja atribuída a um Contrato ou Conta a Pagar';
        END IF;
		RETURN NEW;
    END;
  $pessoadelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER pessoadelete_trigger BEFORE DELETE ON Pessoa
    FOR EACH ROW EXECUTE PROCEDURE pessoadelete_trigger();
	
-- Regras Usuario
CREATE FUNCTION usuariodelete_trigger() RETURNS trigger AS $usuariodelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM Contrato WHERE fk_IdUsuario = OLD.IdUsuario) THEN
            RAISE EXCEPTION 'Usuário ja atribuído a um Contrato';
        END IF;
		RETURN NEW;
    END;
  $usuariodelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER usuariodelete_trigger BEFORE DELETE ON Usuario
    FOR EACH ROW EXECUTE PROCEDURE usuariodelete_trigger();

-- Regras Fornecedor
CREATE FUNCTION fornecedordelete_trigger() RETURNS trigger AS $fornecedordelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM ContaPagar WHERE fk_IdFornecedor = OLD.IdFornecedor and fk_IdPessoa = OLD.IdPessoa) THEN
            RAISE EXCEPTION 'Fornecedor ja atribuído a uma Conta a Pagar';
        END IF;
		RETURN NEW;
    END;
  $fornecedordelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER fornecedordelete_trigger BEFORE DELETE ON Fornecedor
    FOR EACH ROW EXECUTE PROCEDURE fornecedordelete_trigger();
	
-- Regras Cliente
CREATE FUNCTION clientedelete_trigger() RETURNS trigger AS $clientedelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM Contrato WHERE fk_IdCliente = OLD.IdCliente and fk_IdPessoa = OLD.IdPessoa) THEN
            RAISE EXCEPTION 'Cliente ja atribuído a um Contrato';
        END IF;
		RETURN NEW;
    END;
  $clientedelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER clientedelete_trigger BEFORE DELETE ON Cliente
    FOR EACH ROW EXECUTE PROCEDURE clientedelete_trigger();
	
-- Regras Produto
CREATE FUNCTION produtodelete_trigger() RETURNS trigger AS $produtodelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM ServicoPrestado WHERE fk_IdProduto = OLD.IdProduto) THEN
            RAISE EXCEPTION 'Produto ja atribuído a um Serviço Prestado';
        END IF;     
		RETURN NEW;
    END;
  $produtodelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER produtodelete_trigger BEFORE DELETE ON Produto
    FOR EACH ROW EXECUTE PROCEDURE produtodelete_trigger();
	
-- Regras Serviço Prestado
CREATE FUNCTION servicoprestadodelete_trigger() RETURNS trigger AS $servicoprestadodelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM ContratoServico WHERE fk_IdServicoPrestado = OLD.idServPrest) THEN
            RAISE EXCEPTION 'Serviço Prestado ja atribuído a um Contrato';
        END IF;     
		RETURN NEW;
    END;
  $servicoprestadodelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER servicoprestadodelete_trigger BEFORE DELETE ON ServicoPrestado
    FOR EACH ROW EXECUTE PROCEDURE servicoprestadodelete_trigger();
	
-- Regras Formas de Pagamento
CREATE FUNCTION formapagamentodelete_trigger() RETURNS trigger AS $formapagamentodelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM Contrato WHERE fk_IdFormaPag = OLD.idFormaPag) THEN
            RAISE EXCEPTION 'Forma de Pagamento ja atribuída a um Contrato';
        END IF;  
		RETURN NEW;
    END;
  $formapagamentodelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER formapagamentodelete_trigger BEFORE DELETE ON FormaPagamento
    FOR EACH ROW EXECUTE PROCEDURE formapagamentodelete_trigger();
	
-- Regras Vendedor
CREATE FUNCTION vendedordelete_trigger() RETURNS trigger AS $vendedordelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM Contrato WHERE fk_IdVendedor = OLD.IdVendedor) THEN
            RAISE EXCEPTION 'Vendedor ja atribuída a um Contrato';
        END IF; 
		RETURN NEW;
    END;
  $vendedordelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER vendedordelete_trigger BEFORE DELETE ON Vendedor
    FOR EACH ROW EXECUTE PROCEDURE vendedordelete_trigger();
	
-- Regras Contrato Parcela
CREATE FUNCTION contratoparceladelete_trigger() RETURNS trigger AS $contratoparceladelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM ContratoParcelaPagamento WHERE fk_IdContratoParcela = OLD.IdContratoParcela) THEN
            RAISE EXCEPTION 'Parcela já possui um pagamento';
        END IF; 
		RETURN NEW;
    END;
  $contratoparceladelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratoparceladelete_trigger BEFORE DELETE ON ContratoParcela
    FOR EACH ROW EXECUTE PROCEDURE contratoparceladelete_trigger();
	
-- Regras Conta Pagar Parcela
CREATE FUNCTION contapagarparceladelete_trigger() RETURNS trigger AS $contapagarparceladelete_trigger$
    BEGIN
        IF EXISTS (SELECT 1 FROM ContaPagarParcelaPagamento WHERE fk_IdContaPagarParcela = OLD.IdContaPagarParcela) THEN
            RAISE EXCEPTION 'Parcela já possui um pagamento';
        END IF; 
		RETURN NEW;
    END;
  $contapagarparceladelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagarparceladelete_trigger BEFORE DELETE ON ContaPagarParcela
    FOR EACH ROW EXECUTE PROCEDURE contapagarparceladelete_trigger();

-- Regras Conta Pagar 
CREATE FUNCTION contapagardelete_trigger() RETURNS trigger AS $contapagardelete_trigger$
    BEGIN
        RAISE EXCEPTION 'A Conta a Pagar não pode ser excluída';
    END;
  $contapagardelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contapagardelete_trigger BEFORE DELETE ON ContaPagar
    FOR EACH ROW EXECUTE PROCEDURE contapagardelete_trigger();
	
-- Regras Contrato
CREATE FUNCTION contratodelete_trigger() RETURNS trigger AS $contratodelete_trigger$
    BEGIN
		RAISE EXCEPTION 'O Contrato não pode ser excluído';
    END;
  $contratodelete_trigger$ LANGUAGE plpgsql;
  
CREATE TRIGGER contratodelete_trigger BEFORE DELETE ON Contrato
    FOR EACH ROW EXECUTE PROCEDURE contratodelete_trigger();

--Regras Cidades
CREATE FUNCTION cidadesdelete_trigger() RETURNS trigger as $cidadesdelete_trigger$
    BEGIN
        RAISE EXCEPTION 'A Cidade não pode ser excluída';
    END 
   $cidadesdelete_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER cidadesdelete_trigger BEFORE DELETE ON Cidades
    FOR EACH ROW EXECUTE PROCEDURE cidadesdelete_trigger();   
	
CREATE OR REPLACE FUNCTION USERADMINSKOLL() RETURNS void AS 
$useradminskoll$
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE USERNAME = 'skolladmin') THEN
        INSERT INTO usuario (nome, username, email, senha, ativo) values ('SKOLL ADMIN', 'skolladmin', 'skoll.uepg@gmail.com', 'ae497acaa685e822b04965787f53d1730994134e', true);
    END IF;
END
$useradminskoll$
LANGUAGE plpgsql;

select USERADMINSKOLL();

CREATE OR REPLACE FUNCTION PARCELAAJUSTECONTRATO (valorDiferenca decimal, contratoId integer, vencimentoAjuste date) RETURNS TEXT AS 
$PARCELAAJUSTECONTRATO$ 
    DECLARE comiss decimal;
BEGIN
    select t1.percComis into comiss from vendedor t1, contrato t2 where t1.idVendedor = t2.fk_idVendedor and t2.idContrato = contratoId;
    IF comiss <> 0
    THEN 
        INSERT INTO contratoParcela (numParcela, ajuste, dataVencimento, situacao, comissao, fk_idContrato, valorParcela)
        values ((select max(numParcela) + 1 from contratoParcela where fk_idContrato = contratoId), valorDiferenca,
               vencimentoAjuste,
               1, ROUND((valorDiferenca * (comiss/100)),2), contratoId,0);
    ELSE
        INSERT INTO contratoParcela (numParcela, ajuste, dataVencimento, situacao, comissao, fk_idContrato, valorParcela)
        values ((select max(numParcela) + 1 from contratoParcela where fk_idContrato = contratoId), valorDiferenca,
               vencimentoAjuste,
               1, 0, contratoId,0);
    END IF;

    UPDATE CONTRATO SET ajuste = (select sum(ajuste) from contratoParcela where fk_idContrato= contratoId) where idContrato = contratoId;

    RETURN 'PARCELA CRIADA COM SUCESSO!';
    
    EXCEPTION WHEN others then
        RAISE NOTICE 'NÃO FOI POSSÍVEL CRIAR A PARCELA DE AJUSTE. CONTATE O ADMINISTRADOR DO SISTEMA';
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        
END
$PARCELAAJUSTECONTRATO$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION PARCELAAJUSTECONTA (valorDiferenca decimal, contaIdPagar integer, vencimentoAjuste date) RETURNS TEXT AS 
$PARCELAAJUSTECONTA$ 
BEGIN
    INSERT INTO contaPagarParcela (numParcela, ajuste, dataVencimento, situacao, fk_idContaPagar, valorParcela)
        values ((select max(numParcela) + 1 from contaPagarParcela where fk_idContaPagar = contaIdPagar), valorDiferenca,
               vencimentoAjuste,
               1, contaIdPagar, 0);
    
    UPDATE CONTAPAGAR SET ajuste = (select sum(ajuste) from contaPagarParcela where fk_idContaPagar = contaIdPagar) where idContaPagar = contaIdPagar;

    RETURN 'PARCELA CRIADA COM SUCESSO!';
    
    EXCEPTION WHEN others then
        RAISE NOTICE 'NÃO FOI POSSÍVEL CRIAR A PARCELA DE AJUSTE. CONTATE O ADMINISTRADOR DO SISTEMA';
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        
END
$PARCELAAJUSTECONTA$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTRATO() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTRATO$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContrato into idCont from ContratoParcela where idContratoParcela = NEW.fk_IdContratoParcela;

    UPDATE CONTRATO SET juros = juros + NEW.juros where idContrato = idCont;
    RETURN NEW;        
END
$VALORJUROSPAGAMENTOCONTRATO$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContratoTrigger
AFTER INSERT OR UPDATE ON ContratoParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTRATO();

CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTRATODELETE() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTRATODELETE$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContrato into idCont from ContratoParcela where idContratoParcela = OLD.fk_IdContratoParcela;

    UPDATE CONTRATO SET juros = (select sum(juros) from contratoParcelaPagamento where fk_IdContratoParcela in (select idContratoParcela from ContratoParcela where fk_idContrato = idCont)) where idContrato = idCont;
    RETURN OLD;        
END
$VALORJUROSPAGAMENTOCONTRATODELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContratoDeleteTrigger
AFTER DELETE ON ContratoParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTRATODELETE();

CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTA() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTA$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContaPagar into idCont from ContaPagarParcela where idContaPagarParcela = NEW.fk_IdContaPagarParcela;

    UPDATE ContaPagar SET juros = juros + NEW.juros where idContaPagar = idCont;
    RETURN NEW;        
END
$VALORJUROSPAGAMENTOCONTA$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContaTrigger
AFTER INSERT OR UPDATE ON ContaPagarParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTA();

CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTADELETE() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTADELETE$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContaPagar into idCont from ContaPagarParcela where idContaPagarParcela = OLD.fk_IdContaPagarParcela;

    UPDATE CONTAPAGAR SET juros = (select sum(juros) from ContaPagarParcelaPagamento where fk_IdContaPagarParcela in (select idContaPagarParcela from ContaPagarParcela where fk_idContaPagar = idCont)) where idContaPagar = idCont;
    RETURN OLD;      
END
$VALORJUROSPAGAMENTOCONTADELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContaDeleteTrigger
AFTER DELETE ON ContaPagarParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTADELETE();

CREATE OR REPLACE FUNCTION SituacaoParcelaContratoInUp() RETURNS trigger AS 
$SituacaoParcelaContratoInUp$ 
    DECLARE valorTot DECIMAL;
    DECLARE valorParc DECIMAL;
BEGIN    
    select sum(valorPagamento) into valorTot from ContratoParcelaPagamento where fk_idContratoParcela = NEW.fk_idContratoParcela;
    select valorParcela into valorParc from ContratoParcela where idContratoParcela = NEW.fk_idContratoParcela;
    
    IF valorTot = valorParc
    THEN
        UPDATE ContratoParcela SET situacao = 3 where idContratoParcela = NEW.fk_idContratoParcela;
    ELSE
        UPDATE ContratoParcela SET situacao = 2 where idContratoParcela = NEW.fk_idContratoParcela;
    END IF;
    RETURN NEW;        
END
$SituacaoParcelaContratoInUp$
LANGUAGE plpgsql;

CREATE TRIGGER SituacaoParcelaContratoInUp
AFTER INSERT OR UPDATE ON ContratoParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE SituacaoParcelaContratoInUp();

CREATE OR REPLACE FUNCTION SituacaoParcelaContratoDel() RETURNS trigger AS 
$SituacaoParcelaContratoDel$ 
    DECLARE valorTot DECIMAL;
    DECLARE valorParc DECIMAL;
BEGIN    
    select sum(valorPagamento) into valorTot from ContratoParcelaPagamento where fk_idContratoParcela = OLD.fk_idContratoParcela;
    select valorParcela into valorParc from ContratoParcela where idContratoParcela = OLD.fk_idContratoParcela;

    IF valorTot = valorParc
    THEN
        UPDATE ContratoParcela SET situacao = 3 where idContratoParcela = OLD.fk_idContratoParcela;
    ELSE
        UPDATE ContratoParcela SET situacao = 2 where idContratoParcela = OLD.fk_idContratoParcela;
    END IF;
    RETURN OLD;      
END
$SituacaoParcelaContratoDel$
LANGUAGE plpgsql;

CREATE TRIGGER SituacaoParcelaContratoDel
AFTER DELETE ON ContratoParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE SituacaoParcelaContratoDel();


CREATE OR REPLACE FUNCTION VALORTOTALCONTRATOPARCELA() RETURNS trigger AS 
$VALORTOTALCONTRATOPARCELA$ 
BEGIN    
    UPDATE Contrato SET valorTotal = valorTotal + NEW.valorParcela where idContrato = NEW.fk_idContrato;
    RETURN NEW;        
END
$VALORTOTALCONTRATOPARCELA$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaTotalContratoTrigger
AFTER INSERT OR UPDATE ON ContratoParcela
FOR EACH ROW
EXECUTE PROCEDURE VALORTOTALCONTRATOPARCELA();

CREATE OR REPLACE FUNCTION VALORTOTALCONTRATOPARCELADELETE() RETURNS trigger AS 
$VALORTOTALCONTRATOPARCELADELETE$ 
BEGIN    
    UPDATE Contrato SET valorTotal = valorTotal - OLD.valorParcela where idContrato = OLD.fk_idContrato;
    RETURN OLD;      
END
$VALORTOTALCONTRATOPARCELADELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaTotalContratoDeleteTrigger
AFTER DELETE ON ContratoParcela
FOR EACH ROW
EXECUTE PROCEDURE VALORTOTALCONTRATOPARCELADELETE();



