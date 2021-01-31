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


Delete from Cidades;
Insert into Cidades (cidade, estado) values ('Alta Floresta D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Ariquemes', 'RO');
Insert into Cidades (cidade, estado) values ('Cabixi', 'RO');
Insert into Cidades (cidade, estado) values ('Cacoal', 'RO');
Insert into Cidades (cidade, estado) values ('Cerejeiras', 'RO');
Insert into Cidades (cidade, estado) values ('Colorado do Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Corumbiara', 'RO');
Insert into Cidades (cidade, estado) values ('Costa Marques', 'RO');
Insert into Cidades (cidade, estado) values ('Espigão D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Guajará-Mirim', 'RO');
Insert into Cidades (cidade, estado) values ('Jaru', 'RO');
Insert into Cidades (cidade, estado) values ('Ji-Paraná', 'RO');
Insert into Cidades (cidade, estado) values ('Machadinho D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Nova Brasilândia D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Ouro Preto do Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Pimenta Bueno', 'RO');
Insert into Cidades (cidade, estado) values ('Porto Velho', 'RO');
Insert into Cidades (cidade, estado) values ('Presidente Médici', 'RO');
Insert into Cidades (cidade, estado) values ('Rio Crespo', 'RO');
Insert into Cidades (cidade, estado) values ('Rolim de Moura', 'RO');
Insert into Cidades (cidade, estado) values ('Santa Luzia D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Vilhena', 'RO');
Insert into Cidades (cidade, estado) values ('São Miguel do Guaporé', 'RO');
Insert into Cidades (cidade, estado) values ('Nova Mamoré', 'RO');
Insert into Cidades (cidade, estado) values ('Alvorada D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Alto Alegre dos Parecis', 'RO');
Insert into Cidades (cidade, estado) values ('Alto Paraíso', 'RO');
Insert into Cidades (cidade, estado) values ('Buritis', 'RO');
Insert into Cidades (cidade, estado) values ('Novo Horizonte do Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Cacaulândia', 'RO');
Insert into Cidades (cidade, estado) values ('Campo Novo de Rondônia', 'RO');
Insert into Cidades (cidade, estado) values ('Candeias do Jamari', 'RO');
Insert into Cidades (cidade, estado) values ('Castanheiras', 'RO');
Insert into Cidades (cidade, estado) values ('Chupinguaia', 'RO');
Insert into Cidades (cidade, estado) values ('Cujubim', 'RO');
Insert into Cidades (cidade, estado) values ('Governador Jorge Teixeira', 'RO');
Insert into Cidades (cidade, estado) values ('Itapuã do Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Ministro Andreazza', 'RO');
Insert into Cidades (cidade, estado) values ('Mirante da Serra', 'RO');
Insert into Cidades (cidade, estado) values ('Monte Negro', 'RO');
Insert into Cidades (cidade, estado) values ('Nova União', 'RO');
Insert into Cidades (cidade, estado) values ('Parecis', 'RO');
Insert into Cidades (cidade, estado) values ('Pimenteiras do Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('Primavera de Rondônia', 'RO');
Insert into Cidades (cidade, estado) values ('São Felipe D''Oeste', 'RO');
Insert into Cidades (cidade, estado) values ('São Francisco do Guaporé', 'RO');
Insert into Cidades (cidade, estado) values ('Seringueiras', 'RO');
Insert into Cidades (cidade, estado) values ('Teixeirópolis', 'RO');
Insert into Cidades (cidade, estado) values ('Theobroma', 'RO');
Insert into Cidades (cidade, estado) values ('Urupá', 'RO');
Insert into Cidades (cidade, estado) values ('Vale do Anari', 'RO');
Insert into Cidades (cidade, estado) values ('Vale do Paraíso', 'RO');
Insert into Cidades (cidade, estado) values ('Acrelândia', 'AC');
Insert into Cidades (cidade, estado) values ('Assis Brasil', 'AC');
Insert into Cidades (cidade, estado) values ('Brasiléia', 'AC');
Insert into Cidades (cidade, estado) values ('Bujari', 'AC');
Insert into Cidades (cidade, estado) values ('Capixaba', 'AC');
Insert into Cidades (cidade, estado) values ('Cruzeiro do Sul', 'AC');
Insert into Cidades (cidade, estado) values ('Epitaciolândia', 'AC');
Insert into Cidades (cidade, estado) values ('Feijó', 'AC');
Insert into Cidades (cidade, estado) values ('Jordão', 'AC');
Insert into Cidades (cidade, estado) values ('Mâncio Lima', 'AC');
Insert into Cidades (cidade, estado) values ('Manoel Urbano', 'AC');
Insert into Cidades (cidade, estado) values ('Marechal Thaumaturgo', 'AC');
Insert into Cidades (cidade, estado) values ('Plácido de Castro', 'AC');
Insert into Cidades (cidade, estado) values ('Porto Walter', 'AC');
Insert into Cidades (cidade, estado) values ('Rio Branco', 'AC');
Insert into Cidades (cidade, estado) values ('Rodrigues Alves', 'AC');
Insert into Cidades (cidade, estado) values ('Santa Rosa do Purus', 'AC');
Insert into Cidades (cidade, estado) values ('Senador Guiomard', 'AC');
Insert into Cidades (cidade, estado) values ('Sena Madureira', 'AC');
Insert into Cidades (cidade, estado) values ('Tarauacá', 'AC');
Insert into Cidades (cidade, estado) values ('Xapuri', 'AC');
Insert into Cidades (cidade, estado) values ('Porto Acre', 'AC');
Insert into Cidades (cidade, estado) values ('Alvarães', 'AM');
Insert into Cidades (cidade, estado) values ('Amaturá', 'AM');
Insert into Cidades (cidade, estado) values ('Anamã', 'AM');
Insert into Cidades (cidade, estado) values ('Anori', 'AM');
Insert into Cidades (cidade, estado) values ('Apuí', 'AM');
Insert into Cidades (cidade, estado) values ('Atalaia do Norte', 'AM');
Insert into Cidades (cidade, estado) values ('Autazes', 'AM');
Insert into Cidades (cidade, estado) values ('Barcelos', 'AM');
Insert into Cidades (cidade, estado) values ('Barreirinha', 'AM');
Insert into Cidades (cidade, estado) values ('Benjamin Constant', 'AM');
Insert into Cidades (cidade, estado) values ('Beruri', 'AM');
Insert into Cidades (cidade, estado) values ('Boa Vista do Ramos', 'AM');
Insert into Cidades (cidade, estado) values ('Boca do Acre', 'AM');
Insert into Cidades (cidade, estado) values ('Borba', 'AM');
Insert into Cidades (cidade, estado) values ('Caapiranga', 'AM');
Insert into Cidades (cidade, estado) values ('Canutama', 'AM');
Insert into Cidades (cidade, estado) values ('Carauari', 'AM');
Insert into Cidades (cidade, estado) values ('Careiro', 'AM');
Insert into Cidades (cidade, estado) values ('Careiro da Várzea', 'AM');
Insert into Cidades (cidade, estado) values ('Coari', 'AM');
Insert into Cidades (cidade, estado) values ('Codajás', 'AM');
Insert into Cidades (cidade, estado) values ('Eirunepé', 'AM');
Insert into Cidades (cidade, estado) values ('Envira', 'AM');
Insert into Cidades (cidade, estado) values ('Fonte Boa', 'AM');
Insert into Cidades (cidade, estado) values ('Guajará', 'AM');
Insert into Cidades (cidade, estado) values ('Humaitá', 'AM');
Insert into Cidades (cidade, estado) values ('Ipixuna', 'AM');
Insert into Cidades (cidade, estado) values ('Iranduba', 'AM');
Insert into Cidades (cidade, estado) values ('Itacoatiara', 'AM');
Insert into Cidades (cidade, estado) values ('Itamarati', 'AM');
Insert into Cidades (cidade, estado) values ('Itapiranga', 'AM');
Insert into Cidades (cidade, estado) values ('Japurá', 'AM');
Insert into Cidades (cidade, estado) values ('Juruá', 'AM');
Insert into Cidades (cidade, estado) values ('Jutaí', 'AM');
Insert into Cidades (cidade, estado) values ('Lábrea', 'AM');
Insert into Cidades (cidade, estado) values ('Manacapuru', 'AM');
Insert into Cidades (cidade, estado) values ('Manaquiri', 'AM');
Insert into Cidades (cidade, estado) values ('Manaus', 'AM');
Insert into Cidades (cidade, estado) values ('Manicoré', 'AM');
Insert into Cidades (cidade, estado) values ('Maraã', 'AM');
Insert into Cidades (cidade, estado) values ('Maués', 'AM');
Insert into Cidades (cidade, estado) values ('Nhamundá', 'AM');
Insert into Cidades (cidade, estado) values ('Nova Olinda do Norte', 'AM');
Insert into Cidades (cidade, estado) values ('Novo Airão', 'AM');
Insert into Cidades (cidade, estado) values ('Novo Aripuanã', 'AM');
Insert into Cidades (cidade, estado) values ('Parintins', 'AM');
Insert into Cidades (cidade, estado) values ('Pauini', 'AM');
Insert into Cidades (cidade, estado) values ('Presidente Figueiredo', 'AM');
Insert into Cidades (cidade, estado) values ('Rio Preto da Eva', 'AM');
Insert into Cidades (cidade, estado) values ('Santa Isabel do Rio Negro', 'AM');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Içá', 'AM');
Insert into Cidades (cidade, estado) values ('São Gabriel da Cachoeira', 'AM');
Insert into Cidades (cidade, estado) values ('São Paulo de Olivença', 'AM');
Insert into Cidades (cidade, estado) values ('São Sebastião do Uatumã', 'AM');
Insert into Cidades (cidade, estado) values ('Silves', 'AM');
Insert into Cidades (cidade, estado) values ('Tabatinga', 'AM');
Insert into Cidades (cidade, estado) values ('Tapauá', 'AM');
Insert into Cidades (cidade, estado) values ('Tefé', 'AM');
Insert into Cidades (cidade, estado) values ('Tonantins', 'AM');
Insert into Cidades (cidade, estado) values ('Uarini', 'AM');
Insert into Cidades (cidade, estado) values ('Urucará', 'AM');
Insert into Cidades (cidade, estado) values ('Urucurituba', 'AM');
Insert into Cidades (cidade, estado) values ('Amajari', 'RR');
Insert into Cidades (cidade, estado) values ('Alto Alegre', 'RR');
Insert into Cidades (cidade, estado) values ('Boa Vista', 'RR');
Insert into Cidades (cidade, estado) values ('Bonfim', 'RR');
Insert into Cidades (cidade, estado) values ('Cantá', 'RR');
Insert into Cidades (cidade, estado) values ('Caracaraí', 'RR');
Insert into Cidades (cidade, estado) values ('Caroebe', 'RR');
Insert into Cidades (cidade, estado) values ('Iracema', 'RR');
Insert into Cidades (cidade, estado) values ('Mucajaí', 'RR');
Insert into Cidades (cidade, estado) values ('Normandia', 'RR');
Insert into Cidades (cidade, estado) values ('Pacaraima', 'RR');
Insert into Cidades (cidade, estado) values ('Rorainópolis', 'RR');
Insert into Cidades (cidade, estado) values ('São João da Baliza', 'RR');
Insert into Cidades (cidade, estado) values ('São Luiz', 'RR');
Insert into Cidades (cidade, estado) values ('Uiramutã', 'RR');
Insert into Cidades (cidade, estado) values ('Abaetetuba', 'PA');
Insert into Cidades (cidade, estado) values ('Abel Figueiredo', 'PA');
Insert into Cidades (cidade, estado) values ('Acará', 'PA');
Insert into Cidades (cidade, estado) values ('Afuá', 'PA');
Insert into Cidades (cidade, estado) values ('Água Azul do Norte', 'PA');
Insert into Cidades (cidade, estado) values ('Alenquer', 'PA');
Insert into Cidades (cidade, estado) values ('Almeirim', 'PA');
Insert into Cidades (cidade, estado) values ('Altamira', 'PA');
Insert into Cidades (cidade, estado) values ('Anajás', 'PA');
Insert into Cidades (cidade, estado) values ('Ananindeua', 'PA');
Insert into Cidades (cidade, estado) values ('Anapu', 'PA');
Insert into Cidades (cidade, estado) values ('Augusto Corrêa', 'PA');
Insert into Cidades (cidade, estado) values ('Aurora do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Aveiro', 'PA');
Insert into Cidades (cidade, estado) values ('Bagre', 'PA');
Insert into Cidades (cidade, estado) values ('Baião', 'PA');
Insert into Cidades (cidade, estado) values ('Bannach', 'PA');
Insert into Cidades (cidade, estado) values ('Barcarena', 'PA');
Insert into Cidades (cidade, estado) values ('Belém', 'PA');
Insert into Cidades (cidade, estado) values ('Belterra', 'PA');
Insert into Cidades (cidade, estado) values ('Benevides', 'PA');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Tocantins', 'PA');
Insert into Cidades (cidade, estado) values ('Bonito', 'PA');
Insert into Cidades (cidade, estado) values ('Bragança', 'PA');
Insert into Cidades (cidade, estado) values ('Brasil Novo', 'PA');
Insert into Cidades (cidade, estado) values ('Brejo Grande do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('Breu Branco', 'PA');
Insert into Cidades (cidade, estado) values ('Breves', 'PA');
Insert into Cidades (cidade, estado) values ('Bujaru', 'PA');
Insert into Cidades (cidade, estado) values ('Cachoeira do Piriá', 'PA');
Insert into Cidades (cidade, estado) values ('Cachoeira do Arari', 'PA');
Insert into Cidades (cidade, estado) values ('Cametá', 'PA');
Insert into Cidades (cidade, estado) values ('Canaã dos Carajás', 'PA');
Insert into Cidades (cidade, estado) values ('Capanema', 'PA');
Insert into Cidades (cidade, estado) values ('Capitão Poço', 'PA');
Insert into Cidades (cidade, estado) values ('Castanhal', 'PA');
Insert into Cidades (cidade, estado) values ('Chaves', 'PA');
Insert into Cidades (cidade, estado) values ('Colares', 'PA');
Insert into Cidades (cidade, estado) values ('Conceição do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('Concórdia do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Cumaru do Norte', 'PA');
Insert into Cidades (cidade, estado) values ('Curionópolis', 'PA');
Insert into Cidades (cidade, estado) values ('Curralinho', 'PA');
Insert into Cidades (cidade, estado) values ('Curuá', 'PA');
Insert into Cidades (cidade, estado) values ('Curuçá', 'PA');
Insert into Cidades (cidade, estado) values ('Dom Eliseu', 'PA');
Insert into Cidades (cidade, estado) values ('Eldorado dos Carajás', 'PA');
Insert into Cidades (cidade, estado) values ('Faro', 'PA');
Insert into Cidades (cidade, estado) values ('Floresta do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('Garrafão do Norte', 'PA');
Insert into Cidades (cidade, estado) values ('Goianésia do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Gurupá', 'PA');
Insert into Cidades (cidade, estado) values ('Igarapé-Açu', 'PA');
Insert into Cidades (cidade, estado) values ('Igarapé-Miri', 'PA');
Insert into Cidades (cidade, estado) values ('Inhangapi', 'PA');
Insert into Cidades (cidade, estado) values ('Ipixuna do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Irituia', 'PA');
Insert into Cidades (cidade, estado) values ('Itaituba', 'PA');
Insert into Cidades (cidade, estado) values ('Itupiranga', 'PA');
Insert into Cidades (cidade, estado) values ('Jacareacanga', 'PA');
Insert into Cidades (cidade, estado) values ('Jacundá', 'PA');
Insert into Cidades (cidade, estado) values ('Juruti', 'PA');
Insert into Cidades (cidade, estado) values ('Limoeiro do Ajuru', 'PA');
Insert into Cidades (cidade, estado) values ('Mãe do Rio', 'PA');
Insert into Cidades (cidade, estado) values ('Magalhães Barata', 'PA');
Insert into Cidades (cidade, estado) values ('Marabá', 'PA');
Insert into Cidades (cidade, estado) values ('Maracanã', 'PA');
Insert into Cidades (cidade, estado) values ('Marapanim', 'PA');
Insert into Cidades (cidade, estado) values ('Marituba', 'PA');
Insert into Cidades (cidade, estado) values ('Medicilândia', 'PA');
Insert into Cidades (cidade, estado) values ('Melgaço', 'PA');
Insert into Cidades (cidade, estado) values ('Mocajuba', 'PA');
Insert into Cidades (cidade, estado) values ('Moju', 'PA');
Insert into Cidades (cidade, estado) values ('Mojuí dos Campos', 'PA');
Insert into Cidades (cidade, estado) values ('Monte Alegre', 'PA');
Insert into Cidades (cidade, estado) values ('Muaná', 'PA');
Insert into Cidades (cidade, estado) values ('Nova Esperança do Piriá', 'PA');
Insert into Cidades (cidade, estado) values ('Nova Ipixuna', 'PA');
Insert into Cidades (cidade, estado) values ('Nova Timboteua', 'PA');
Insert into Cidades (cidade, estado) values ('Novo Progresso', 'PA');
Insert into Cidades (cidade, estado) values ('Novo Repartimento', 'PA');
Insert into Cidades (cidade, estado) values ('Óbidos', 'PA');
Insert into Cidades (cidade, estado) values ('Oeiras do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Oriximiná', 'PA');
Insert into Cidades (cidade, estado) values ('Ourém', 'PA');
Insert into Cidades (cidade, estado) values ('Ourilândia do Norte', 'PA');
Insert into Cidades (cidade, estado) values ('Pacajá', 'PA');
Insert into Cidades (cidade, estado) values ('Palestina do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Paragominas', 'PA');
Insert into Cidades (cidade, estado) values ('Parauapebas', 'PA');
Insert into Cidades (cidade, estado) values ('Pau D''Arco', 'PA');
Insert into Cidades (cidade, estado) values ('Peixe-Boi', 'PA');
Insert into Cidades (cidade, estado) values ('Piçarra', 'PA');
Insert into Cidades (cidade, estado) values ('Placas', 'PA');
Insert into Cidades (cidade, estado) values ('Ponta de Pedras', 'PA');
Insert into Cidades (cidade, estado) values ('Portel', 'PA');
Insert into Cidades (cidade, estado) values ('Porto de Moz', 'PA');
Insert into Cidades (cidade, estado) values ('Prainha', 'PA');
Insert into Cidades (cidade, estado) values ('Primavera', 'PA');
Insert into Cidades (cidade, estado) values ('Quatipuru', 'PA');
Insert into Cidades (cidade, estado) values ('Redenção', 'PA');
Insert into Cidades (cidade, estado) values ('Rio Maria', 'PA');
Insert into Cidades (cidade, estado) values ('Rondon do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Rurópolis', 'PA');
Insert into Cidades (cidade, estado) values ('Salinópolis', 'PA');
Insert into Cidades (cidade, estado) values ('Salvaterra', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Bárbara do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Arari', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Isabel do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Luzia do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Maria das Barreiras', 'PA');
Insert into Cidades (cidade, estado) values ('Santa Maria do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('Santana do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('Santarém', 'PA');
Insert into Cidades (cidade, estado) values ('Santarém Novo', 'PA');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Tauá', 'PA');
Insert into Cidades (cidade, estado) values ('São Caetano de Odivelas', 'PA');
Insert into Cidades (cidade, estado) values ('São Domingos do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('São Domingos do Capim', 'PA');
Insert into Cidades (cidade, estado) values ('São Félix do Xingu', 'PA');
Insert into Cidades (cidade, estado) values ('São Francisco do Pará', 'PA');
Insert into Cidades (cidade, estado) values ('São Geraldo do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('São João da Ponta', 'PA');
Insert into Cidades (cidade, estado) values ('São João de Pirabas', 'PA');
Insert into Cidades (cidade, estado) values ('São João do Araguaia', 'PA');
Insert into Cidades (cidade, estado) values ('São Miguel do Guamá', 'PA');
Insert into Cidades (cidade, estado) values ('São Sebastião da Boa Vista', 'PA');
Insert into Cidades (cidade, estado) values ('Sapucaia', 'PA');
Insert into Cidades (cidade, estado) values ('Senador José Porfírio', 'PA');
Insert into Cidades (cidade, estado) values ('Soure', 'PA');
Insert into Cidades (cidade, estado) values ('Tailândia', 'PA');
Insert into Cidades (cidade, estado) values ('Terra Alta', 'PA');
Insert into Cidades (cidade, estado) values ('Terra Santa', 'PA');
Insert into Cidades (cidade, estado) values ('Tomé-Açu', 'PA');
Insert into Cidades (cidade, estado) values ('Tracuateua', 'PA');
Insert into Cidades (cidade, estado) values ('Trairão', 'PA');
Insert into Cidades (cidade, estado) values ('Tucumã', 'PA');
Insert into Cidades (cidade, estado) values ('Tucuruí', 'PA');
Insert into Cidades (cidade, estado) values ('Ulianópolis', 'PA');
Insert into Cidades (cidade, estado) values ('Uruará', 'PA');
Insert into Cidades (cidade, estado) values ('Vigia', 'PA');
Insert into Cidades (cidade, estado) values ('Viseu', 'PA');
Insert into Cidades (cidade, estado) values ('Vitória do Xingu', 'PA');
Insert into Cidades (cidade, estado) values ('Xinguara', 'PA');
Insert into Cidades (cidade, estado) values ('Serra do Navio', 'AP');
Insert into Cidades (cidade, estado) values ('Amapá', 'AP');
Insert into Cidades (cidade, estado) values ('Pedra Branca do Amapari', 'AP');
Insert into Cidades (cidade, estado) values ('Calçoene', 'AP');
Insert into Cidades (cidade, estado) values ('Cutias', 'AP');
Insert into Cidades (cidade, estado) values ('Ferreira Gomes', 'AP');
Insert into Cidades (cidade, estado) values ('Itaubal', 'AP');
Insert into Cidades (cidade, estado) values ('Laranjal do Jari', 'AP');
Insert into Cidades (cidade, estado) values ('Macapá', 'AP');
Insert into Cidades (cidade, estado) values ('Mazagão', 'AP');
Insert into Cidades (cidade, estado) values ('Oiapoque', 'AP');
Insert into Cidades (cidade, estado) values ('Porto Grande', 'AP');
Insert into Cidades (cidade, estado) values ('Pracuúba', 'AP');
Insert into Cidades (cidade, estado) values ('Santana', 'AP');
Insert into Cidades (cidade, estado) values ('Tartarugalzinho', 'AP');
Insert into Cidades (cidade, estado) values ('Vitória do Jari', 'AP');
Insert into Cidades (cidade, estado) values ('Abreulândia', 'TO');
Insert into Cidades (cidade, estado) values ('Aguiarnópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Aliança do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Almas', 'TO');
Insert into Cidades (cidade, estado) values ('Alvorada', 'TO');
Insert into Cidades (cidade, estado) values ('Ananás', 'TO');
Insert into Cidades (cidade, estado) values ('Angico', 'TO');
Insert into Cidades (cidade, estado) values ('Aparecida do Rio Negro', 'TO');
Insert into Cidades (cidade, estado) values ('Aragominas', 'TO');
Insert into Cidades (cidade, estado) values ('Araguacema', 'TO');
Insert into Cidades (cidade, estado) values ('Araguaçu', 'TO');
Insert into Cidades (cidade, estado) values ('Araguaína', 'TO');
Insert into Cidades (cidade, estado) values ('Araguanã', 'TO');
Insert into Cidades (cidade, estado) values ('Araguatins', 'TO');
Insert into Cidades (cidade, estado) values ('Arapoema', 'TO');
Insert into Cidades (cidade, estado) values ('Arraias', 'TO');
Insert into Cidades (cidade, estado) values ('Augustinópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Aurora do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Axixá do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Babaçulândia', 'TO');
Insert into Cidades (cidade, estado) values ('Bandeirantes do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Barra do Ouro', 'TO');
Insert into Cidades (cidade, estado) values ('Barrolândia', 'TO');
Insert into Cidades (cidade, estado) values ('Bernardo Sayão', 'TO');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Brasilândia do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Brejinho de Nazaré', 'TO');
Insert into Cidades (cidade, estado) values ('Buriti do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Cachoeirinha', 'TO');
Insert into Cidades (cidade, estado) values ('Campos Lindos', 'TO');
Insert into Cidades (cidade, estado) values ('Cariri do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Carmolândia', 'TO');
Insert into Cidades (cidade, estado) values ('Carrasco Bonito', 'TO');
Insert into Cidades (cidade, estado) values ('Caseara', 'TO');
Insert into Cidades (cidade, estado) values ('Centenário', 'TO');
Insert into Cidades (cidade, estado) values ('Chapada de Areia', 'TO');
Insert into Cidades (cidade, estado) values ('Chapada da Natividade', 'TO');
Insert into Cidades (cidade, estado) values ('Colinas do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Combinado', 'TO');
Insert into Cidades (cidade, estado) values ('Conceição do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Couto Magalhães', 'TO');
Insert into Cidades (cidade, estado) values ('Cristalândia', 'TO');
Insert into Cidades (cidade, estado) values ('Crixás do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Darcinópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Dianópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Divinópolis do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Dois Irmãos do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Dueré', 'TO');
Insert into Cidades (cidade, estado) values ('Esperantina', 'TO');
Insert into Cidades (cidade, estado) values ('Fátima', 'TO');
Insert into Cidades (cidade, estado) values ('Figueirópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Filadélfia', 'TO');
Insert into Cidades (cidade, estado) values ('Formoso do Araguaia', 'TO');
Insert into Cidades (cidade, estado) values ('Fortaleza do Tabocão', 'TO');
Insert into Cidades (cidade, estado) values ('Goianorte', 'TO');
Insert into Cidades (cidade, estado) values ('Goiatins', 'TO');
Insert into Cidades (cidade, estado) values ('Guaraí', 'TO');
Insert into Cidades (cidade, estado) values ('Gurupi', 'TO');
Insert into Cidades (cidade, estado) values ('Ipueiras', 'TO');
Insert into Cidades (cidade, estado) values ('Itacajá', 'TO');
Insert into Cidades (cidade, estado) values ('Itaguatins', 'TO');
Insert into Cidades (cidade, estado) values ('Itapiratins', 'TO');
Insert into Cidades (cidade, estado) values ('Itaporã do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Jaú do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Juarina', 'TO');
Insert into Cidades (cidade, estado) values ('Lagoa da Confusão', 'TO');
Insert into Cidades (cidade, estado) values ('Lagoa do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Lajeado', 'TO');
Insert into Cidades (cidade, estado) values ('Lavandeira', 'TO');
Insert into Cidades (cidade, estado) values ('Lizarda', 'TO');
Insert into Cidades (cidade, estado) values ('Luzinópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Marianópolis do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Mateiros', 'TO');
Insert into Cidades (cidade, estado) values ('Maurilândia do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Miracema do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Miranorte', 'TO');
Insert into Cidades (cidade, estado) values ('Monte do Carmo', 'TO');
Insert into Cidades (cidade, estado) values ('Monte Santo do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Palmeiras do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Muricilândia', 'TO');
Insert into Cidades (cidade, estado) values ('Natividade', 'TO');
Insert into Cidades (cidade, estado) values ('Nazaré', 'TO');
Insert into Cidades (cidade, estado) values ('Nova Olinda', 'TO');
Insert into Cidades (cidade, estado) values ('Nova Rosalândia', 'TO');
Insert into Cidades (cidade, estado) values ('Novo Acordo', 'TO');
Insert into Cidades (cidade, estado) values ('Novo Alegre', 'TO');
Insert into Cidades (cidade, estado) values ('Novo Jardim', 'TO');
Insert into Cidades (cidade, estado) values ('Oliveira de Fátima', 'TO');
Insert into Cidades (cidade, estado) values ('Palmeirante', 'TO');
Insert into Cidades (cidade, estado) values ('Palmeirópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Paraíso do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Paranã', 'TO');
Insert into Cidades (cidade, estado) values ('Pau D''Arco', 'TO');
Insert into Cidades (cidade, estado) values ('Pedro Afonso', 'TO');
Insert into Cidades (cidade, estado) values ('Peixe', 'TO');
Insert into Cidades (cidade, estado) values ('Pequizeiro', 'TO');
Insert into Cidades (cidade, estado) values ('Colméia', 'TO');
Insert into Cidades (cidade, estado) values ('Pindorama do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Piraquê', 'TO');
Insert into Cidades (cidade, estado) values ('Pium', 'TO');
Insert into Cidades (cidade, estado) values ('Ponte Alta do Bom Jesus', 'TO');
Insert into Cidades (cidade, estado) values ('Ponte Alta do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Porto Alegre do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Porto Nacional', 'TO');
Insert into Cidades (cidade, estado) values ('Praia Norte', 'TO');
Insert into Cidades (cidade, estado) values ('Presidente Kennedy', 'TO');
Insert into Cidades (cidade, estado) values ('Pugmil', 'TO');
Insert into Cidades (cidade, estado) values ('Recursolândia', 'TO');
Insert into Cidades (cidade, estado) values ('Riachinho', 'TO');
Insert into Cidades (cidade, estado) values ('Rio da Conceição', 'TO');
Insert into Cidades (cidade, estado) values ('Rio dos Bois', 'TO');
Insert into Cidades (cidade, estado) values ('Rio Sono', 'TO');
Insert into Cidades (cidade, estado) values ('Sampaio', 'TO');
Insert into Cidades (cidade, estado) values ('Sandolândia', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Fé do Araguaia', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Maria do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Rita do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Rosa do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Tereza do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Santa Terezinha do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Bento do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Félix do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Miguel do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Salvador do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Sebastião do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('São Valério', 'TO');
Insert into Cidades (cidade, estado) values ('Silvanópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Sítio Novo do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Sucupira', 'TO');
Insert into Cidades (cidade, estado) values ('Taguatinga', 'TO');
Insert into Cidades (cidade, estado) values ('Taipas do Tocantins', 'TO');
Insert into Cidades (cidade, estado) values ('Talismã', 'TO');
Insert into Cidades (cidade, estado) values ('Palmas', 'TO');
Insert into Cidades (cidade, estado) values ('Tocantínia', 'TO');
Insert into Cidades (cidade, estado) values ('Tocantinópolis', 'TO');
Insert into Cidades (cidade, estado) values ('Tupirama', 'TO');
Insert into Cidades (cidade, estado) values ('Tupiratins', 'TO');
Insert into Cidades (cidade, estado) values ('Wanderlândia', 'TO');
Insert into Cidades (cidade, estado) values ('Xambioá', 'TO');
Insert into Cidades (cidade, estado) values ('Açailândia', 'MA');
Insert into Cidades (cidade, estado) values ('Afonso Cunha', 'MA');
Insert into Cidades (cidade, estado) values ('Água Doce do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Alcântara', 'MA');
Insert into Cidades (cidade, estado) values ('Aldeias Altas', 'MA');
Insert into Cidades (cidade, estado) values ('Altamira do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Alto Alegre do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Alto Alegre do Pindaré', 'MA');
Insert into Cidades (cidade, estado) values ('Alto Parnaíba', 'MA');
Insert into Cidades (cidade, estado) values ('Amapá do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Amarante do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Anajatuba', 'MA');
Insert into Cidades (cidade, estado) values ('Anapurus', 'MA');
Insert into Cidades (cidade, estado) values ('Apicum-Açu', 'MA');
Insert into Cidades (cidade, estado) values ('Araguanã', 'MA');
Insert into Cidades (cidade, estado) values ('Araioses', 'MA');
Insert into Cidades (cidade, estado) values ('Arame', 'MA');
Insert into Cidades (cidade, estado) values ('Arari', 'MA');
Insert into Cidades (cidade, estado) values ('Axixá', 'MA');
Insert into Cidades (cidade, estado) values ('Bacabal', 'MA');
Insert into Cidades (cidade, estado) values ('Bacabeira', 'MA');
Insert into Cidades (cidade, estado) values ('Bacuri', 'MA');
Insert into Cidades (cidade, estado) values ('Bacurituba', 'MA');
Insert into Cidades (cidade, estado) values ('Balsas', 'MA');
Insert into Cidades (cidade, estado) values ('Barão de Grajaú', 'MA');
Insert into Cidades (cidade, estado) values ('Barra do Corda', 'MA');
Insert into Cidades (cidade, estado) values ('Barreirinhas', 'MA');
Insert into Cidades (cidade, estado) values ('Belágua', 'MA');
Insert into Cidades (cidade, estado) values ('Bela Vista do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Benedito Leite', 'MA');
Insert into Cidades (cidade, estado) values ('Bequimão', 'MA');
Insert into Cidades (cidade, estado) values ('Bernardo do Mearim', 'MA');
Insert into Cidades (cidade, estado) values ('Boa Vista do Gurupi', 'MA');
Insert into Cidades (cidade, estado) values ('Bom Jardim', 'MA');
Insert into Cidades (cidade, estado) values ('Bom Jesus das Selvas', 'MA');
Insert into Cidades (cidade, estado) values ('Bom Lugar', 'MA');
Insert into Cidades (cidade, estado) values ('Brejo', 'MA');
Insert into Cidades (cidade, estado) values ('Brejo de Areia', 'MA');
Insert into Cidades (cidade, estado) values ('Buriti', 'MA');
Insert into Cidades (cidade, estado) values ('Buriti Bravo', 'MA');
Insert into Cidades (cidade, estado) values ('Buriticupu', 'MA');
Insert into Cidades (cidade, estado) values ('Buritirana', 'MA');
Insert into Cidades (cidade, estado) values ('Cachoeira Grande', 'MA');
Insert into Cidades (cidade, estado) values ('Cajapió', 'MA');
Insert into Cidades (cidade, estado) values ('Cajari', 'MA');
Insert into Cidades (cidade, estado) values ('Campestre do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Cândido Mendes', 'MA');
Insert into Cidades (cidade, estado) values ('Cantanhede', 'MA');
Insert into Cidades (cidade, estado) values ('Capinzal do Norte', 'MA');
Insert into Cidades (cidade, estado) values ('Carolina', 'MA');
Insert into Cidades (cidade, estado) values ('Carutapera', 'MA');
Insert into Cidades (cidade, estado) values ('Caxias', 'MA');
Insert into Cidades (cidade, estado) values ('Cedral', 'MA');
Insert into Cidades (cidade, estado) values ('Central do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Centro do Guilherme', 'MA');
Insert into Cidades (cidade, estado) values ('Centro Novo do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Chapadinha', 'MA');
Insert into Cidades (cidade, estado) values ('Cidelândia', 'MA');
Insert into Cidades (cidade, estado) values ('Codó', 'MA');
Insert into Cidades (cidade, estado) values ('Coelho Neto', 'MA');
Insert into Cidades (cidade, estado) values ('Colinas', 'MA');
Insert into Cidades (cidade, estado) values ('Conceição do Lago-Açu', 'MA');
Insert into Cidades (cidade, estado) values ('Coroatá', 'MA');
Insert into Cidades (cidade, estado) values ('Cururupu', 'MA');
Insert into Cidades (cidade, estado) values ('Davinópolis', 'MA');
Insert into Cidades (cidade, estado) values ('Dom Pedro', 'MA');
Insert into Cidades (cidade, estado) values ('Duque Bacelar', 'MA');
Insert into Cidades (cidade, estado) values ('Esperantinópolis', 'MA');
Insert into Cidades (cidade, estado) values ('Estreito', 'MA');
Insert into Cidades (cidade, estado) values ('Feira Nova do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Fernando Falcão', 'MA');
Insert into Cidades (cidade, estado) values ('Formosa da Serra Negra', 'MA');
Insert into Cidades (cidade, estado) values ('Fortaleza dos Nogueiras', 'MA');
Insert into Cidades (cidade, estado) values ('Fortuna', 'MA');
Insert into Cidades (cidade, estado) values ('Godofredo Viana', 'MA');
Insert into Cidades (cidade, estado) values ('Gonçalves Dias', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Archer', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Edison Lobão', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Eugênio Barros', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Luiz Rocha', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Newton Bello', 'MA');
Insert into Cidades (cidade, estado) values ('Governador Nunes Freire', 'MA');
Insert into Cidades (cidade, estado) values ('Graça Aranha', 'MA');
Insert into Cidades (cidade, estado) values ('Grajaú', 'MA');
Insert into Cidades (cidade, estado) values ('Guimarães', 'MA');
Insert into Cidades (cidade, estado) values ('Humberto de Campos', 'MA');
Insert into Cidades (cidade, estado) values ('Icatu', 'MA');
Insert into Cidades (cidade, estado) values ('Igarapé do Meio', 'MA');
Insert into Cidades (cidade, estado) values ('Igarapé Grande', 'MA');
Insert into Cidades (cidade, estado) values ('Imperatriz', 'MA');
Insert into Cidades (cidade, estado) values ('Itaipava do Grajaú', 'MA');
Insert into Cidades (cidade, estado) values ('Itapecuru Mirim', 'MA');
Insert into Cidades (cidade, estado) values ('Itinga do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Jatobá', 'MA');
Insert into Cidades (cidade, estado) values ('Jenipapo dos Vieiras', 'MA');
Insert into Cidades (cidade, estado) values ('João Lisboa', 'MA');
Insert into Cidades (cidade, estado) values ('Joselândia', 'MA');
Insert into Cidades (cidade, estado) values ('Junco do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Lago da Pedra', 'MA');
Insert into Cidades (cidade, estado) values ('Lago do Junco', 'MA');
Insert into Cidades (cidade, estado) values ('Lago Verde', 'MA');
Insert into Cidades (cidade, estado) values ('Lagoa do Mato', 'MA');
Insert into Cidades (cidade, estado) values ('Lago dos Rodrigues', 'MA');
Insert into Cidades (cidade, estado) values ('Lagoa Grande do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Lajeado Novo', 'MA');
Insert into Cidades (cidade, estado) values ('Lima Campos', 'MA');
Insert into Cidades (cidade, estado) values ('Loreto', 'MA');
Insert into Cidades (cidade, estado) values ('Luís Domingues', 'MA');
Insert into Cidades (cidade, estado) values ('Magalhães de Almeida', 'MA');
Insert into Cidades (cidade, estado) values ('Maracaçumé', 'MA');
Insert into Cidades (cidade, estado) values ('Marajá do Sena', 'MA');
Insert into Cidades (cidade, estado) values ('Maranhãozinho', 'MA');
Insert into Cidades (cidade, estado) values ('Mata Roma', 'MA');
Insert into Cidades (cidade, estado) values ('Matinha', 'MA');
Insert into Cidades (cidade, estado) values ('Matões', 'MA');
Insert into Cidades (cidade, estado) values ('Matões do Norte', 'MA');
Insert into Cidades (cidade, estado) values ('Milagres do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Mirador', 'MA');
Insert into Cidades (cidade, estado) values ('Miranda do Norte', 'MA');
Insert into Cidades (cidade, estado) values ('Mirinzal', 'MA');
Insert into Cidades (cidade, estado) values ('Monção', 'MA');
Insert into Cidades (cidade, estado) values ('Montes Altos', 'MA');
Insert into Cidades (cidade, estado) values ('Morros', 'MA');
Insert into Cidades (cidade, estado) values ('Nina Rodrigues', 'MA');
Insert into Cidades (cidade, estado) values ('Nova Colinas', 'MA');
Insert into Cidades (cidade, estado) values ('Nova Iorque', 'MA');
Insert into Cidades (cidade, estado) values ('Nova Olinda do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Olho D''Água das Cunhãs', 'MA');
Insert into Cidades (cidade, estado) values ('Olinda Nova do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Paço do Lumiar', 'MA');
Insert into Cidades (cidade, estado) values ('Palmeirândia', 'MA');
Insert into Cidades (cidade, estado) values ('Paraibano', 'MA');
Insert into Cidades (cidade, estado) values ('Parnarama', 'MA');
Insert into Cidades (cidade, estado) values ('Passagem Franca', 'MA');
Insert into Cidades (cidade, estado) values ('Pastos Bons', 'MA');
Insert into Cidades (cidade, estado) values ('Paulino Neves', 'MA');
Insert into Cidades (cidade, estado) values ('Paulo Ramos', 'MA');
Insert into Cidades (cidade, estado) values ('Pedreiras', 'MA');
Insert into Cidades (cidade, estado) values ('Pedro do Rosário', 'MA');
Insert into Cidades (cidade, estado) values ('Penalva', 'MA');
Insert into Cidades (cidade, estado) values ('Peri Mirim', 'MA');
Insert into Cidades (cidade, estado) values ('Peritoró', 'MA');
Insert into Cidades (cidade, estado) values ('Pindaré-Mirim', 'MA');
Insert into Cidades (cidade, estado) values ('Pinheiro', 'MA');
Insert into Cidades (cidade, estado) values ('Pio XII', 'MA');
Insert into Cidades (cidade, estado) values ('Pirapemas', 'MA');
Insert into Cidades (cidade, estado) values ('Poção de Pedras', 'MA');
Insert into Cidades (cidade, estado) values ('Porto Franco', 'MA');
Insert into Cidades (cidade, estado) values ('Porto Rico do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Presidente Dutra', 'MA');
Insert into Cidades (cidade, estado) values ('Presidente Juscelino', 'MA');
Insert into Cidades (cidade, estado) values ('Presidente Médici', 'MA');
Insert into Cidades (cidade, estado) values ('Presidente Sarney', 'MA');
Insert into Cidades (cidade, estado) values ('Presidente Vargas', 'MA');
Insert into Cidades (cidade, estado) values ('Primeira Cruz', 'MA');
Insert into Cidades (cidade, estado) values ('Raposa', 'MA');
Insert into Cidades (cidade, estado) values ('Riachão', 'MA');
Insert into Cidades (cidade, estado) values ('Ribamar Fiquene', 'MA');
Insert into Cidades (cidade, estado) values ('Rosário', 'MA');
Insert into Cidades (cidade, estado) values ('Sambaíba', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Filomena do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Helena', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Inês', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Luzia', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Luzia do Paruá', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Quitéria do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Santa Rita', 'MA');
Insert into Cidades (cidade, estado) values ('Santana do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Santo Amaro do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Santo Antônio dos Lopes', 'MA');
Insert into Cidades (cidade, estado) values ('São Benedito do Rio Preto', 'MA');
Insert into Cidades (cidade, estado) values ('São Bento', 'MA');
Insert into Cidades (cidade, estado) values ('São Bernardo', 'MA');
Insert into Cidades (cidade, estado) values ('São Domingos do Azeitão', 'MA');
Insert into Cidades (cidade, estado) values ('São Domingos do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('São Félix de Balsas', 'MA');
Insert into Cidades (cidade, estado) values ('São Francisco do Brejão', 'MA');
Insert into Cidades (cidade, estado) values ('São Francisco do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('São João Batista', 'MA');
Insert into Cidades (cidade, estado) values ('São João do Carú', 'MA');
Insert into Cidades (cidade, estado) values ('São João do Paraíso', 'MA');
Insert into Cidades (cidade, estado) values ('São João do Soter', 'MA');
Insert into Cidades (cidade, estado) values ('São João dos Patos', 'MA');
Insert into Cidades (cidade, estado) values ('São José de Ribamar', 'MA');
Insert into Cidades (cidade, estado) values ('São José dos Basílios', 'MA');
Insert into Cidades (cidade, estado) values ('São Luís', 'MA');
Insert into Cidades (cidade, estado) values ('São Luís Gonzaga do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('São Mateus do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('São Pedro da Água Branca', 'MA');
Insert into Cidades (cidade, estado) values ('São Pedro dos Crentes', 'MA');
Insert into Cidades (cidade, estado) values ('São Raimundo das Mangabeiras', 'MA');
Insert into Cidades (cidade, estado) values ('São Raimundo do Doca Bezerra', 'MA');
Insert into Cidades (cidade, estado) values ('São Roberto', 'MA');
Insert into Cidades (cidade, estado) values ('São Vicente Ferrer', 'MA');
Insert into Cidades (cidade, estado) values ('Satubinha', 'MA');
Insert into Cidades (cidade, estado) values ('Senador Alexandre Costa', 'MA');
Insert into Cidades (cidade, estado) values ('Senador La Rocque', 'MA');
Insert into Cidades (cidade, estado) values ('Serrano do Maranhão', 'MA');
Insert into Cidades (cidade, estado) values ('Sítio Novo', 'MA');
Insert into Cidades (cidade, estado) values ('Sucupira do Norte', 'MA');
Insert into Cidades (cidade, estado) values ('Sucupira do Riachão', 'MA');
Insert into Cidades (cidade, estado) values ('Tasso Fragoso', 'MA');
Insert into Cidades (cidade, estado) values ('Timbiras', 'MA');
Insert into Cidades (cidade, estado) values ('Timon', 'MA');
Insert into Cidades (cidade, estado) values ('Trizidela do Vale', 'MA');
Insert into Cidades (cidade, estado) values ('Tufilândia', 'MA');
Insert into Cidades (cidade, estado) values ('Tuntum', 'MA');
Insert into Cidades (cidade, estado) values ('Turiaçu', 'MA');
Insert into Cidades (cidade, estado) values ('Turilândia', 'MA');
Insert into Cidades (cidade, estado) values ('Tutóia', 'MA');
Insert into Cidades (cidade, estado) values ('Urbano Santos', 'MA');
Insert into Cidades (cidade, estado) values ('Vargem Grande', 'MA');
Insert into Cidades (cidade, estado) values ('Viana', 'MA');
Insert into Cidades (cidade, estado) values ('Vila Nova dos Martírios', 'MA');
Insert into Cidades (cidade, estado) values ('Vitória do Mearim', 'MA');
Insert into Cidades (cidade, estado) values ('Vitorino Freire', 'MA');
Insert into Cidades (cidade, estado) values ('Zé Doca', 'MA');
Insert into Cidades (cidade, estado) values ('Acauã', 'PI');
Insert into Cidades (cidade, estado) values ('Agricolândia', 'PI');
Insert into Cidades (cidade, estado) values ('Água Branca', 'PI');
Insert into Cidades (cidade, estado) values ('Alagoinha do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Alegrete do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Alto Longá', 'PI');
Insert into Cidades (cidade, estado) values ('Altos', 'PI');
Insert into Cidades (cidade, estado) values ('Alvorada do Gurguéia', 'PI');
Insert into Cidades (cidade, estado) values ('Amarante', 'PI');
Insert into Cidades (cidade, estado) values ('Angical do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Anísio de Abreu', 'PI');
Insert into Cidades (cidade, estado) values ('Antônio Almeida', 'PI');
Insert into Cidades (cidade, estado) values ('Aroazes', 'PI');
Insert into Cidades (cidade, estado) values ('Aroeiras do Itaim', 'PI');
Insert into Cidades (cidade, estado) values ('Arraial', 'PI');
Insert into Cidades (cidade, estado) values ('Assunção do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Avelino Lopes', 'PI');
Insert into Cidades (cidade, estado) values ('Baixa Grande do Ribeiro', 'PI');
Insert into Cidades (cidade, estado) values ('Barra D''Alcântara', 'PI');
Insert into Cidades (cidade, estado) values ('Barras', 'PI');
Insert into Cidades (cidade, estado) values ('Barreiras do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Barro Duro', 'PI');
Insert into Cidades (cidade, estado) values ('Batalha', 'PI');
Insert into Cidades (cidade, estado) values ('Bela Vista do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Belém do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Beneditinos', 'PI');
Insert into Cidades (cidade, estado) values ('Bertolínia', 'PI');
Insert into Cidades (cidade, estado) values ('Betânia do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Boa Hora', 'PI');
Insert into Cidades (cidade, estado) values ('Bocaina', 'PI');
Insert into Cidades (cidade, estado) values ('Bom Jesus', 'PI');
Insert into Cidades (cidade, estado) values ('Bom Princípio do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Bonfim do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Boqueirão do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Brasileira', 'PI');
Insert into Cidades (cidade, estado) values ('Brejo do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Buriti dos Lopes', 'PI');
Insert into Cidades (cidade, estado) values ('Buriti dos Montes', 'PI');
Insert into Cidades (cidade, estado) values ('Cabeceiras do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Cajazeiras do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Cajueiro da Praia', 'PI');
Insert into Cidades (cidade, estado) values ('Caldeirão Grande do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Campinas do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Campo Alegre do Fidalgo', 'PI');
Insert into Cidades (cidade, estado) values ('Campo Grande do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Campo Largo do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Campo Maior', 'PI');
Insert into Cidades (cidade, estado) values ('Canavieira', 'PI');
Insert into Cidades (cidade, estado) values ('Canto do Buriti', 'PI');
Insert into Cidades (cidade, estado) values ('Capitão de Campos', 'PI');
Insert into Cidades (cidade, estado) values ('Capitão Gervásio Oliveira', 'PI');
Insert into Cidades (cidade, estado) values ('Caracol', 'PI');
Insert into Cidades (cidade, estado) values ('Caraúbas do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Caridade do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Castelo do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Caxingó', 'PI');
Insert into Cidades (cidade, estado) values ('Cocal', 'PI');
Insert into Cidades (cidade, estado) values ('Cocal de Telha', 'PI');
Insert into Cidades (cidade, estado) values ('Cocal dos Alves', 'PI');
Insert into Cidades (cidade, estado) values ('Coivaras', 'PI');
Insert into Cidades (cidade, estado) values ('Colônia do Gurguéia', 'PI');
Insert into Cidades (cidade, estado) values ('Colônia do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Conceição do Canindé', 'PI');
Insert into Cidades (cidade, estado) values ('Coronel José Dias', 'PI');
Insert into Cidades (cidade, estado) values ('Corrente', 'PI');
Insert into Cidades (cidade, estado) values ('Cristalândia do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Cristino Castro', 'PI');
Insert into Cidades (cidade, estado) values ('Curimatá', 'PI');
Insert into Cidades (cidade, estado) values ('Currais', 'PI');
Insert into Cidades (cidade, estado) values ('Curralinhos', 'PI');
Insert into Cidades (cidade, estado) values ('Curral Novo do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Demerval Lobão', 'PI');
Insert into Cidades (cidade, estado) values ('Dirceu Arcoverde', 'PI');
Insert into Cidades (cidade, estado) values ('Dom Expedito Lopes', 'PI');
Insert into Cidades (cidade, estado) values ('Domingos Mourão', 'PI');
Insert into Cidades (cidade, estado) values ('Dom Inocêncio', 'PI');
Insert into Cidades (cidade, estado) values ('Elesbão Veloso', 'PI');
Insert into Cidades (cidade, estado) values ('Eliseu Martins', 'PI');
Insert into Cidades (cidade, estado) values ('Esperantina', 'PI');
Insert into Cidades (cidade, estado) values ('Fartura do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Flores do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Floresta do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Floriano', 'PI');
Insert into Cidades (cidade, estado) values ('Francinópolis', 'PI');
Insert into Cidades (cidade, estado) values ('Francisco Ayres', 'PI');
Insert into Cidades (cidade, estado) values ('Francisco Macedo', 'PI');
Insert into Cidades (cidade, estado) values ('Francisco Santos', 'PI');
Insert into Cidades (cidade, estado) values ('Fronteiras', 'PI');
Insert into Cidades (cidade, estado) values ('Geminiano', 'PI');
Insert into Cidades (cidade, estado) values ('Gilbués', 'PI');
Insert into Cidades (cidade, estado) values ('Guadalupe', 'PI');
Insert into Cidades (cidade, estado) values ('Guaribas', 'PI');
Insert into Cidades (cidade, estado) values ('Hugo Napoleão', 'PI');
Insert into Cidades (cidade, estado) values ('Ilha Grande', 'PI');
Insert into Cidades (cidade, estado) values ('Inhuma', 'PI');
Insert into Cidades (cidade, estado) values ('Ipiranga do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Isaías Coelho', 'PI');
Insert into Cidades (cidade, estado) values ('Itainópolis', 'PI');
Insert into Cidades (cidade, estado) values ('Itaueira', 'PI');
Insert into Cidades (cidade, estado) values ('Jacobina do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Jaicós', 'PI');
Insert into Cidades (cidade, estado) values ('Jardim do Mulato', 'PI');
Insert into Cidades (cidade, estado) values ('Jatobá do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Jerumenha', 'PI');
Insert into Cidades (cidade, estado) values ('João Costa', 'PI');
Insert into Cidades (cidade, estado) values ('Joaquim Pires', 'PI');
Insert into Cidades (cidade, estado) values ('Joca Marques', 'PI');
Insert into Cidades (cidade, estado) values ('José de Freitas', 'PI');
Insert into Cidades (cidade, estado) values ('Juazeiro do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Júlio Borges', 'PI');
Insert into Cidades (cidade, estado) values ('Jurema', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoinha do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoa Alegre', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoa do Barro do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoa de São Francisco', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoa do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Lagoa do Sítio', 'PI');
Insert into Cidades (cidade, estado) values ('Landri Sales', 'PI');
Insert into Cidades (cidade, estado) values ('Luís Correia', 'PI');
Insert into Cidades (cidade, estado) values ('Luzilândia', 'PI');
Insert into Cidades (cidade, estado) values ('Madeiro', 'PI');
Insert into Cidades (cidade, estado) values ('Manoel Emídio', 'PI');
Insert into Cidades (cidade, estado) values ('Marcolândia', 'PI');
Insert into Cidades (cidade, estado) values ('Marcos Parente', 'PI');
Insert into Cidades (cidade, estado) values ('Massapê do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Matias Olímpio', 'PI');
Insert into Cidades (cidade, estado) values ('Miguel Alves', 'PI');
Insert into Cidades (cidade, estado) values ('Miguel Leão', 'PI');
Insert into Cidades (cidade, estado) values ('Milton Brandão', 'PI');
Insert into Cidades (cidade, estado) values ('Monsenhor Gil', 'PI');
Insert into Cidades (cidade, estado) values ('Monsenhor Hipólito', 'PI');
Insert into Cidades (cidade, estado) values ('Monte Alegre do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Morro Cabeça no Tempo', 'PI');
Insert into Cidades (cidade, estado) values ('Morro do Chapéu do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Murici dos Portelas', 'PI');
Insert into Cidades (cidade, estado) values ('Nazaré do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Nazária', 'PI');
Insert into Cidades (cidade, estado) values ('Nossa Senhora de Nazaré', 'PI');
Insert into Cidades (cidade, estado) values ('Nossa Senhora dos Remédios', 'PI');
Insert into Cidades (cidade, estado) values ('Novo Oriente do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Novo Santo Antônio', 'PI');
Insert into Cidades (cidade, estado) values ('Oeiras', 'PI');
Insert into Cidades (cidade, estado) values ('Olho D''Água do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Padre Marcos', 'PI');
Insert into Cidades (cidade, estado) values ('Paes Landim', 'PI');
Insert into Cidades (cidade, estado) values ('Pajeú do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Palmeira do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Palmeirais', 'PI');
Insert into Cidades (cidade, estado) values ('Paquetá', 'PI');
Insert into Cidades (cidade, estado) values ('Parnaguá', 'PI');
Insert into Cidades (cidade, estado) values ('Parnaíba', 'PI');
Insert into Cidades (cidade, estado) values ('Passagem Franca do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Patos do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Pau D''Arco do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Paulistana', 'PI');
Insert into Cidades (cidade, estado) values ('Pavussu', 'PI');
Insert into Cidades (cidade, estado) values ('Pedro II', 'PI');
Insert into Cidades (cidade, estado) values ('Pedro Laurentino', 'PI');
Insert into Cidades (cidade, estado) values ('Nova Santa Rita', 'PI');
Insert into Cidades (cidade, estado) values ('Picos', 'PI');
Insert into Cidades (cidade, estado) values ('Pimenteiras', 'PI');
Insert into Cidades (cidade, estado) values ('Pio IX', 'PI');
Insert into Cidades (cidade, estado) values ('Piracuruca', 'PI');
Insert into Cidades (cidade, estado) values ('Piripiri', 'PI');
Insert into Cidades (cidade, estado) values ('Porto', 'PI');
Insert into Cidades (cidade, estado) values ('Porto Alegre do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Prata do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Queimada Nova', 'PI');
Insert into Cidades (cidade, estado) values ('Redenção do Gurguéia', 'PI');
Insert into Cidades (cidade, estado) values ('Regeneração', 'PI');
Insert into Cidades (cidade, estado) values ('Riacho Frio', 'PI');
Insert into Cidades (cidade, estado) values ('Ribeira do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Ribeiro Gonçalves', 'PI');
Insert into Cidades (cidade, estado) values ('Rio Grande do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Santa Cruz dos Milagres', 'PI');
Insert into Cidades (cidade, estado) values ('Santa Filomena', 'PI');
Insert into Cidades (cidade, estado) values ('Santa Luz', 'PI');
Insert into Cidades (cidade, estado) values ('Santana do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Santa Rosa do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Santo Antônio de Lisboa', 'PI');
Insert into Cidades (cidade, estado) values ('Santo Antônio dos Milagres', 'PI');
Insert into Cidades (cidade, estado) values ('Santo Inácio do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Braz do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Félix do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Francisco de Assis do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Francisco do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Gurguéia', 'PI');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São João da Canabrava', 'PI');
Insert into Cidades (cidade, estado) values ('São João da Fronteira', 'PI');
Insert into Cidades (cidade, estado) values ('São João da Serra', 'PI');
Insert into Cidades (cidade, estado) values ('São João da Varjota', 'PI');
Insert into Cidades (cidade, estado) values ('São João do Arraial', 'PI');
Insert into Cidades (cidade, estado) values ('São João do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São José do Divino', 'PI');
Insert into Cidades (cidade, estado) values ('São José do Peixe', 'PI');
Insert into Cidades (cidade, estado) values ('São José do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Julião', 'PI');
Insert into Cidades (cidade, estado) values ('São Lourenço do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Luis do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Miguel da Baixa Grande', 'PI');
Insert into Cidades (cidade, estado) values ('São Miguel do Fidalgo', 'PI');
Insert into Cidades (cidade, estado) values ('São Miguel do Tapuio', 'PI');
Insert into Cidades (cidade, estado) values ('São Pedro do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('São Raimundo Nonato', 'PI');
Insert into Cidades (cidade, estado) values ('Sebastião Barros', 'PI');
Insert into Cidades (cidade, estado) values ('Sebastião Leal', 'PI');
Insert into Cidades (cidade, estado) values ('Sigefredo Pacheco', 'PI');
Insert into Cidades (cidade, estado) values ('Simões', 'PI');
Insert into Cidades (cidade, estado) values ('Simplício Mendes', 'PI');
Insert into Cidades (cidade, estado) values ('Socorro do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Sussuapara', 'PI');
Insert into Cidades (cidade, estado) values ('Tamboril do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Tanque do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Teresina', 'PI');
Insert into Cidades (cidade, estado) values ('União', 'PI');
Insert into Cidades (cidade, estado) values ('Uruçuí', 'PI');
Insert into Cidades (cidade, estado) values ('Valença do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Várzea Branca', 'PI');
Insert into Cidades (cidade, estado) values ('Várzea Grande', 'PI');
Insert into Cidades (cidade, estado) values ('Vera Mendes', 'PI');
Insert into Cidades (cidade, estado) values ('Vila Nova do Piauí', 'PI');
Insert into Cidades (cidade, estado) values ('Wall Ferraz', 'PI');
Insert into Cidades (cidade, estado) values ('Abaiara', 'CE');
Insert into Cidades (cidade, estado) values ('Acarape', 'CE');
Insert into Cidades (cidade, estado) values ('Acaraú', 'CE');
Insert into Cidades (cidade, estado) values ('Acopiara', 'CE');
Insert into Cidades (cidade, estado) values ('Aiuaba', 'CE');
Insert into Cidades (cidade, estado) values ('Alcântaras', 'CE');
Insert into Cidades (cidade, estado) values ('Altaneira', 'CE');
Insert into Cidades (cidade, estado) values ('Alto Santo', 'CE');
Insert into Cidades (cidade, estado) values ('Amontada', 'CE');
Insert into Cidades (cidade, estado) values ('Antonina do Norte', 'CE');
Insert into Cidades (cidade, estado) values ('Apuiarés', 'CE');
Insert into Cidades (cidade, estado) values ('Aquiraz', 'CE');
Insert into Cidades (cidade, estado) values ('Aracati', 'CE');
Insert into Cidades (cidade, estado) values ('Aracoiaba', 'CE');
Insert into Cidades (cidade, estado) values ('Ararendá', 'CE');
Insert into Cidades (cidade, estado) values ('Araripe', 'CE');
Insert into Cidades (cidade, estado) values ('Aratuba', 'CE');
Insert into Cidades (cidade, estado) values ('Arneiroz', 'CE');
Insert into Cidades (cidade, estado) values ('Assaré', 'CE');
Insert into Cidades (cidade, estado) values ('Aurora', 'CE');
Insert into Cidades (cidade, estado) values ('Baixio', 'CE');
Insert into Cidades (cidade, estado) values ('Banabuiú', 'CE');
Insert into Cidades (cidade, estado) values ('Barbalha', 'CE');
Insert into Cidades (cidade, estado) values ('Barreira', 'CE');
Insert into Cidades (cidade, estado) values ('Barro', 'CE');
Insert into Cidades (cidade, estado) values ('Barroquinha', 'CE');
Insert into Cidades (cidade, estado) values ('Baturité', 'CE');
Insert into Cidades (cidade, estado) values ('Beberibe', 'CE');
Insert into Cidades (cidade, estado) values ('Bela Cruz', 'CE');
Insert into Cidades (cidade, estado) values ('Boa Viagem', 'CE');
Insert into Cidades (cidade, estado) values ('Brejo Santo', 'CE');
Insert into Cidades (cidade, estado) values ('Camocim', 'CE');
Insert into Cidades (cidade, estado) values ('Campos Sales', 'CE');
Insert into Cidades (cidade, estado) values ('Canindé', 'CE');
Insert into Cidades (cidade, estado) values ('Capistrano', 'CE');
Insert into Cidades (cidade, estado) values ('Caridade', 'CE');
Insert into Cidades (cidade, estado) values ('Cariré', 'CE');
Insert into Cidades (cidade, estado) values ('Caririaçu', 'CE');
Insert into Cidades (cidade, estado) values ('Cariús', 'CE');
Insert into Cidades (cidade, estado) values ('Carnaubal', 'CE');
Insert into Cidades (cidade, estado) values ('Cascavel', 'CE');
Insert into Cidades (cidade, estado) values ('Catarina', 'CE');
Insert into Cidades (cidade, estado) values ('Catunda', 'CE');
Insert into Cidades (cidade, estado) values ('Caucaia', 'CE');
Insert into Cidades (cidade, estado) values ('Cedro', 'CE');
Insert into Cidades (cidade, estado) values ('Chaval', 'CE');
Insert into Cidades (cidade, estado) values ('Choró', 'CE');
Insert into Cidades (cidade, estado) values ('Chorozinho', 'CE');
Insert into Cidades (cidade, estado) values ('Coreaú', 'CE');
Insert into Cidades (cidade, estado) values ('Crateús', 'CE');
Insert into Cidades (cidade, estado) values ('Crato', 'CE');
Insert into Cidades (cidade, estado) values ('Croatá', 'CE');
Insert into Cidades (cidade, estado) values ('Cruz', 'CE');
Insert into Cidades (cidade, estado) values ('Deputado Irapuan Pinheiro', 'CE');
Insert into Cidades (cidade, estado) values ('Ererê', 'CE');
Insert into Cidades (cidade, estado) values ('Eusébio', 'CE');
Insert into Cidades (cidade, estado) values ('Farias Brito', 'CE');
Insert into Cidades (cidade, estado) values ('Forquilha', 'CE');
Insert into Cidades (cidade, estado) values ('Fortaleza', 'CE');
Insert into Cidades (cidade, estado) values ('Fortim', 'CE');
Insert into Cidades (cidade, estado) values ('Frecheirinha', 'CE');
Insert into Cidades (cidade, estado) values ('General Sampaio', 'CE');
Insert into Cidades (cidade, estado) values ('Graça', 'CE');
Insert into Cidades (cidade, estado) values ('Granja', 'CE');
Insert into Cidades (cidade, estado) values ('Granjeiro', 'CE');
Insert into Cidades (cidade, estado) values ('Groaíras', 'CE');
Insert into Cidades (cidade, estado) values ('Guaiúba', 'CE');
Insert into Cidades (cidade, estado) values ('Guaraciaba do Norte', 'CE');
Insert into Cidades (cidade, estado) values ('Guaramiranga', 'CE');
Insert into Cidades (cidade, estado) values ('Hidrolândia', 'CE');
Insert into Cidades (cidade, estado) values ('Horizonte', 'CE');
Insert into Cidades (cidade, estado) values ('Ibaretama', 'CE');
Insert into Cidades (cidade, estado) values ('Ibiapina', 'CE');
Insert into Cidades (cidade, estado) values ('Ibicuitinga', 'CE');
Insert into Cidades (cidade, estado) values ('Icapuí', 'CE');
Insert into Cidades (cidade, estado) values ('Icó', 'CE');
Insert into Cidades (cidade, estado) values ('Iguatu', 'CE');
Insert into Cidades (cidade, estado) values ('Independência', 'CE');
Insert into Cidades (cidade, estado) values ('Ipaporanga', 'CE');
Insert into Cidades (cidade, estado) values ('Ipaumirim', 'CE');
Insert into Cidades (cidade, estado) values ('Ipu', 'CE');
Insert into Cidades (cidade, estado) values ('Ipueiras', 'CE');
Insert into Cidades (cidade, estado) values ('Iracema', 'CE');
Insert into Cidades (cidade, estado) values ('Irauçuba', 'CE');
Insert into Cidades (cidade, estado) values ('Itaiçaba', 'CE');
Insert into Cidades (cidade, estado) values ('Itaitinga', 'CE');
Insert into Cidades (cidade, estado) values ('Itapagé', 'CE');
Insert into Cidades (cidade, estado) values ('Itapipoca', 'CE');
Insert into Cidades (cidade, estado) values ('Itapiúna', 'CE');
Insert into Cidades (cidade, estado) values ('Itarema', 'CE');
Insert into Cidades (cidade, estado) values ('Itatira', 'CE');
Insert into Cidades (cidade, estado) values ('Jaguaretama', 'CE');
Insert into Cidades (cidade, estado) values ('Jaguaribara', 'CE');
Insert into Cidades (cidade, estado) values ('Jaguaribe', 'CE');
Insert into Cidades (cidade, estado) values ('Jaguaruana', 'CE');
Insert into Cidades (cidade, estado) values ('Jardim', 'CE');
Insert into Cidades (cidade, estado) values ('Jati', 'CE');
Insert into Cidades (cidade, estado) values ('Jijoca de Jericoacoara', 'CE');
Insert into Cidades (cidade, estado) values ('Juazeiro do Norte', 'CE');
Insert into Cidades (cidade, estado) values ('Jucás', 'CE');
Insert into Cidades (cidade, estado) values ('Lavras da Mangabeira', 'CE');
Insert into Cidades (cidade, estado) values ('Limoeiro do Norte', 'CE');
Insert into Cidades (cidade, estado) values ('Madalena', 'CE');
Insert into Cidades (cidade, estado) values ('Maracanaú', 'CE');
Insert into Cidades (cidade, estado) values ('Maranguape', 'CE');
Insert into Cidades (cidade, estado) values ('Marco', 'CE');
Insert into Cidades (cidade, estado) values ('Martinópole', 'CE');
Insert into Cidades (cidade, estado) values ('Massapê', 'CE');
Insert into Cidades (cidade, estado) values ('Mauriti', 'CE');
Insert into Cidades (cidade, estado) values ('Meruoca', 'CE');
Insert into Cidades (cidade, estado) values ('Milagres', 'CE');
Insert into Cidades (cidade, estado) values ('Milhã', 'CE');
Insert into Cidades (cidade, estado) values ('Miraíma', 'CE');
Insert into Cidades (cidade, estado) values ('Missão Velha', 'CE');
Insert into Cidades (cidade, estado) values ('Mombaça', 'CE');
Insert into Cidades (cidade, estado) values ('Monsenhor Tabosa', 'CE');
Insert into Cidades (cidade, estado) values ('Morada Nova', 'CE');
Insert into Cidades (cidade, estado) values ('Moraújo', 'CE');
Insert into Cidades (cidade, estado) values ('Morrinhos', 'CE');
Insert into Cidades (cidade, estado) values ('Mucambo', 'CE');
Insert into Cidades (cidade, estado) values ('Mulungu', 'CE');
Insert into Cidades (cidade, estado) values ('Nova Olinda', 'CE');
Insert into Cidades (cidade, estado) values ('Nova Russas', 'CE');
Insert into Cidades (cidade, estado) values ('Novo Oriente', 'CE');
Insert into Cidades (cidade, estado) values ('Ocara', 'CE');
Insert into Cidades (cidade, estado) values ('Orós', 'CE');
Insert into Cidades (cidade, estado) values ('Pacajus', 'CE');
Insert into Cidades (cidade, estado) values ('Pacatuba', 'CE');
Insert into Cidades (cidade, estado) values ('Pacoti', 'CE');
Insert into Cidades (cidade, estado) values ('Pacujá', 'CE');
Insert into Cidades (cidade, estado) values ('Palhano', 'CE');
Insert into Cidades (cidade, estado) values ('Palmácia', 'CE');
Insert into Cidades (cidade, estado) values ('Paracuru', 'CE');
Insert into Cidades (cidade, estado) values ('Paraipaba', 'CE');
Insert into Cidades (cidade, estado) values ('Parambu', 'CE');
Insert into Cidades (cidade, estado) values ('Paramoti', 'CE');
Insert into Cidades (cidade, estado) values ('Pedra Branca', 'CE');
Insert into Cidades (cidade, estado) values ('Penaforte', 'CE');
Insert into Cidades (cidade, estado) values ('Pentecoste', 'CE');
Insert into Cidades (cidade, estado) values ('Pereiro', 'CE');
Insert into Cidades (cidade, estado) values ('Pindoretama', 'CE');
Insert into Cidades (cidade, estado) values ('Piquet Carneiro', 'CE');
Insert into Cidades (cidade, estado) values ('Pires Ferreira', 'CE');
Insert into Cidades (cidade, estado) values ('Poranga', 'CE');
Insert into Cidades (cidade, estado) values ('Porteiras', 'CE');
Insert into Cidades (cidade, estado) values ('Potengi', 'CE');
Insert into Cidades (cidade, estado) values ('Potiretama', 'CE');
Insert into Cidades (cidade, estado) values ('Quiterianópolis', 'CE');
Insert into Cidades (cidade, estado) values ('Quixadá', 'CE');
Insert into Cidades (cidade, estado) values ('Quixelô', 'CE');
Insert into Cidades (cidade, estado) values ('Quixeramobim', 'CE');
Insert into Cidades (cidade, estado) values ('Quixeré', 'CE');
Insert into Cidades (cidade, estado) values ('Redenção', 'CE');
Insert into Cidades (cidade, estado) values ('Reriutaba', 'CE');
Insert into Cidades (cidade, estado) values ('Russas', 'CE');
Insert into Cidades (cidade, estado) values ('Saboeiro', 'CE');
Insert into Cidades (cidade, estado) values ('Salitre', 'CE');
Insert into Cidades (cidade, estado) values ('Santana do Acaraú', 'CE');
Insert into Cidades (cidade, estado) values ('Santana do Cariri', 'CE');
Insert into Cidades (cidade, estado) values ('Santa Quitéria', 'CE');
Insert into Cidades (cidade, estado) values ('São Benedito', 'CE');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Amarante', 'CE');
Insert into Cidades (cidade, estado) values ('São João do Jaguaribe', 'CE');
Insert into Cidades (cidade, estado) values ('São Luís do Curu', 'CE');
Insert into Cidades (cidade, estado) values ('Senador Pompeu', 'CE');
Insert into Cidades (cidade, estado) values ('Senador Sá', 'CE');
Insert into Cidades (cidade, estado) values ('Sobral', 'CE');
Insert into Cidades (cidade, estado) values ('Solonópole', 'CE');
Insert into Cidades (cidade, estado) values ('Tabuleiro do Norte', 'CE');
Insert into Cidades (cidade, estado) values ('Tamboril', 'CE');
Insert into Cidades (cidade, estado) values ('Tarrafas', 'CE');
Insert into Cidades (cidade, estado) values ('Tauá', 'CE');
Insert into Cidades (cidade, estado) values ('Tejuçuoca', 'CE');
Insert into Cidades (cidade, estado) values ('Tianguá', 'CE');
Insert into Cidades (cidade, estado) values ('Trairi', 'CE');
Insert into Cidades (cidade, estado) values ('Tururu', 'CE');
Insert into Cidades (cidade, estado) values ('Ubajara', 'CE');
Insert into Cidades (cidade, estado) values ('Umari', 'CE');
Insert into Cidades (cidade, estado) values ('Umirim', 'CE');
Insert into Cidades (cidade, estado) values ('Uruburetama', 'CE');
Insert into Cidades (cidade, estado) values ('Uruoca', 'CE');
Insert into Cidades (cidade, estado) values ('Varjota', 'CE');
Insert into Cidades (cidade, estado) values ('Várzea Alegre', 'CE');
Insert into Cidades (cidade, estado) values ('Viçosa do Ceará', 'CE');
Insert into Cidades (cidade, estado) values ('Acari', 'RN');
Insert into Cidades (cidade, estado) values ('Açu', 'RN');
Insert into Cidades (cidade, estado) values ('Afonso Bezerra', 'RN');
Insert into Cidades (cidade, estado) values ('Água Nova', 'RN');
Insert into Cidades (cidade, estado) values ('Alexandria', 'RN');
Insert into Cidades (cidade, estado) values ('Almino Afonso', 'RN');
Insert into Cidades (cidade, estado) values ('Alto do Rodrigues', 'RN');
Insert into Cidades (cidade, estado) values ('Angicos', 'RN');
Insert into Cidades (cidade, estado) values ('Antônio Martins', 'RN');
Insert into Cidades (cidade, estado) values ('Apodi', 'RN');
Insert into Cidades (cidade, estado) values ('Areia Branca', 'RN');
Insert into Cidades (cidade, estado) values ('Arês', 'RN');
Insert into Cidades (cidade, estado) values ('Augusto Severo', 'RN');
Insert into Cidades (cidade, estado) values ('Baía Formosa', 'RN');
Insert into Cidades (cidade, estado) values ('Baraúna', 'RN');
Insert into Cidades (cidade, estado) values ('Barcelona', 'RN');
Insert into Cidades (cidade, estado) values ('Bento Fernandes', 'RN');
Insert into Cidades (cidade, estado) values ('Bodó', 'RN');
Insert into Cidades (cidade, estado) values ('Bom Jesus', 'RN');
Insert into Cidades (cidade, estado) values ('Brejinho', 'RN');
Insert into Cidades (cidade, estado) values ('Caiçara do Norte', 'RN');
Insert into Cidades (cidade, estado) values ('Caiçara do Rio do Vento', 'RN');
Insert into Cidades (cidade, estado) values ('Caicó', 'RN');
Insert into Cidades (cidade, estado) values ('Campo Redondo', 'RN');
Insert into Cidades (cidade, estado) values ('Canguaretama', 'RN');
Insert into Cidades (cidade, estado) values ('Caraúbas', 'RN');
Insert into Cidades (cidade, estado) values ('Carnaúba dos Dantas', 'RN');
Insert into Cidades (cidade, estado) values ('Carnaubais', 'RN');
Insert into Cidades (cidade, estado) values ('Ceará-Mirim', 'RN');
Insert into Cidades (cidade, estado) values ('Cerro Corá', 'RN');
Insert into Cidades (cidade, estado) values ('Coronel Ezequiel', 'RN');
Insert into Cidades (cidade, estado) values ('Coronel João Pessoa', 'RN');
Insert into Cidades (cidade, estado) values ('Cruzeta', 'RN');
Insert into Cidades (cidade, estado) values ('Currais Novos', 'RN');
Insert into Cidades (cidade, estado) values ('Doutor Severiano', 'RN');
Insert into Cidades (cidade, estado) values ('Parnamirim', 'RN');
Insert into Cidades (cidade, estado) values ('Encanto', 'RN');
Insert into Cidades (cidade, estado) values ('Equador', 'RN');
Insert into Cidades (cidade, estado) values ('Espírito Santo', 'RN');
Insert into Cidades (cidade, estado) values ('Extremoz', 'RN');
Insert into Cidades (cidade, estado) values ('Felipe Guerra', 'RN');
Insert into Cidades (cidade, estado) values ('Fernando Pedroza', 'RN');
Insert into Cidades (cidade, estado) values ('Florânia', 'RN');
Insert into Cidades (cidade, estado) values ('Francisco Dantas', 'RN');
Insert into Cidades (cidade, estado) values ('Frutuoso Gomes', 'RN');
Insert into Cidades (cidade, estado) values ('Galinhos', 'RN');
Insert into Cidades (cidade, estado) values ('Goianinha', 'RN');
Insert into Cidades (cidade, estado) values ('Governador Dix-Sept Rosado', 'RN');
Insert into Cidades (cidade, estado) values ('Grossos', 'RN');
Insert into Cidades (cidade, estado) values ('Guamaré', 'RN');
Insert into Cidades (cidade, estado) values ('Ielmo Marinho', 'RN');
Insert into Cidades (cidade, estado) values ('Ipanguaçu', 'RN');
Insert into Cidades (cidade, estado) values ('Ipueira', 'RN');
Insert into Cidades (cidade, estado) values ('Itajá', 'RN');
Insert into Cidades (cidade, estado) values ('Itaú', 'RN');
Insert into Cidades (cidade, estado) values ('Jaçanã', 'RN');
Insert into Cidades (cidade, estado) values ('Jandaíra', 'RN');
Insert into Cidades (cidade, estado) values ('Janduís', 'RN');
Insert into Cidades (cidade, estado) values ('Januário Cicco', 'RN');
Insert into Cidades (cidade, estado) values ('Japi', 'RN');
Insert into Cidades (cidade, estado) values ('Jardim de Angicos', 'RN');
Insert into Cidades (cidade, estado) values ('Jardim de Piranhas', 'RN');
Insert into Cidades (cidade, estado) values ('Jardim do Seridó', 'RN');
Insert into Cidades (cidade, estado) values ('João Câmara', 'RN');
Insert into Cidades (cidade, estado) values ('João Dias', 'RN');
Insert into Cidades (cidade, estado) values ('José da Penha', 'RN');
Insert into Cidades (cidade, estado) values ('Jucurutu', 'RN');
Insert into Cidades (cidade, estado) values ('Jundiá', 'RN');
Insert into Cidades (cidade, estado) values ('Lagoa D''Anta', 'RN');
Insert into Cidades (cidade, estado) values ('Lagoa de Pedras', 'RN');
Insert into Cidades (cidade, estado) values ('Lagoa de Velhos', 'RN');
Insert into Cidades (cidade, estado) values ('Lagoa Nova', 'RN');
Insert into Cidades (cidade, estado) values ('Lagoa Salgada', 'RN');
Insert into Cidades (cidade, estado) values ('Lajes', 'RN');
Insert into Cidades (cidade, estado) values ('Lajes Pintadas', 'RN');
Insert into Cidades (cidade, estado) values ('Lucrécia', 'RN');
Insert into Cidades (cidade, estado) values ('Luís Gomes', 'RN');
Insert into Cidades (cidade, estado) values ('Macaíba', 'RN');
Insert into Cidades (cidade, estado) values ('Macau', 'RN');
Insert into Cidades (cidade, estado) values ('Major Sales', 'RN');
Insert into Cidades (cidade, estado) values ('Marcelino Vieira', 'RN');
Insert into Cidades (cidade, estado) values ('Martins', 'RN');
Insert into Cidades (cidade, estado) values ('Maxaranguape', 'RN');
Insert into Cidades (cidade, estado) values ('Messias Targino', 'RN');
Insert into Cidades (cidade, estado) values ('Montanhas', 'RN');
Insert into Cidades (cidade, estado) values ('Monte Alegre', 'RN');
Insert into Cidades (cidade, estado) values ('Monte das Gameleiras', 'RN');
Insert into Cidades (cidade, estado) values ('Mossoró', 'RN');
Insert into Cidades (cidade, estado) values ('Natal', 'RN');
Insert into Cidades (cidade, estado) values ('Nísia Floresta', 'RN');
Insert into Cidades (cidade, estado) values ('Nova Cruz', 'RN');
Insert into Cidades (cidade, estado) values ('Olho-D''Água do Borges', 'RN');
Insert into Cidades (cidade, estado) values ('Ouro Branco', 'RN');
Insert into Cidades (cidade, estado) values ('Paraná', 'RN');
Insert into Cidades (cidade, estado) values ('Paraú', 'RN');
Insert into Cidades (cidade, estado) values ('Parazinho', 'RN');
Insert into Cidades (cidade, estado) values ('Parelhas', 'RN');
Insert into Cidades (cidade, estado) values ('Rio do Fogo', 'RN');
Insert into Cidades (cidade, estado) values ('Passa e Fica', 'RN');
Insert into Cidades (cidade, estado) values ('Passagem', 'RN');
Insert into Cidades (cidade, estado) values ('Patu', 'RN');
Insert into Cidades (cidade, estado) values ('Santa Maria', 'RN');
Insert into Cidades (cidade, estado) values ('Pau dos Ferros', 'RN');
Insert into Cidades (cidade, estado) values ('Pedra Grande', 'RN');
Insert into Cidades (cidade, estado) values ('Pedra Preta', 'RN');
Insert into Cidades (cidade, estado) values ('Pedro Avelino', 'RN');
Insert into Cidades (cidade, estado) values ('Pedro Velho', 'RN');
Insert into Cidades (cidade, estado) values ('Pendências', 'RN');
Insert into Cidades (cidade, estado) values ('Pilões', 'RN');
Insert into Cidades (cidade, estado) values ('Poço Branco', 'RN');
Insert into Cidades (cidade, estado) values ('Portalegre', 'RN');
Insert into Cidades (cidade, estado) values ('Porto do Mangue', 'RN');
Insert into Cidades (cidade, estado) values ('Presidente Juscelino', 'RN');
Insert into Cidades (cidade, estado) values ('Pureza', 'RN');
Insert into Cidades (cidade, estado) values ('Rafael Fernandes', 'RN');
Insert into Cidades (cidade, estado) values ('Rafael Godeiro', 'RN');
Insert into Cidades (cidade, estado) values ('Riacho da Cruz', 'RN');
Insert into Cidades (cidade, estado) values ('Riacho de Santana', 'RN');
Insert into Cidades (cidade, estado) values ('Riachuelo', 'RN');
Insert into Cidades (cidade, estado) values ('Rodolfo Fernandes', 'RN');
Insert into Cidades (cidade, estado) values ('Tibau', 'RN');
Insert into Cidades (cidade, estado) values ('Ruy Barbosa', 'RN');
Insert into Cidades (cidade, estado) values ('Santa Cruz', 'RN');
Insert into Cidades (cidade, estado) values ('Santana do Matos', 'RN');
Insert into Cidades (cidade, estado) values ('Santana do Seridó', 'RN');
Insert into Cidades (cidade, estado) values ('Santo Antônio', 'RN');
Insert into Cidades (cidade, estado) values ('São Bento do Norte', 'RN');
Insert into Cidades (cidade, estado) values ('São Bento do Trairí', 'RN');
Insert into Cidades (cidade, estado) values ('São Fernando', 'RN');
Insert into Cidades (cidade, estado) values ('São Francisco do Oeste', 'RN');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Amarante', 'RN');
Insert into Cidades (cidade, estado) values ('São João do Sabugi', 'RN');
Insert into Cidades (cidade, estado) values ('São José de Mipibu', 'RN');
Insert into Cidades (cidade, estado) values ('São José do Campestre', 'RN');
Insert into Cidades (cidade, estado) values ('São José do Seridó', 'RN');
Insert into Cidades (cidade, estado) values ('São Miguel', 'RN');
Insert into Cidades (cidade, estado) values ('São Miguel do Gostoso', 'RN');
Insert into Cidades (cidade, estado) values ('São Paulo do Potengi', 'RN');
Insert into Cidades (cidade, estado) values ('São Pedro', 'RN');
Insert into Cidades (cidade, estado) values ('São Rafael', 'RN');
Insert into Cidades (cidade, estado) values ('São Tomé', 'RN');
Insert into Cidades (cidade, estado) values ('São Vicente', 'RN');
Insert into Cidades (cidade, estado) values ('Senador Elói de Souza', 'RN');
Insert into Cidades (cidade, estado) values ('Senador Georgino Avelino', 'RN');
Insert into Cidades (cidade, estado) values ('Serra de São Bento', 'RN');
Insert into Cidades (cidade, estado) values ('Serra do Mel', 'RN');
Insert into Cidades (cidade, estado) values ('Serra Negra do Norte', 'RN');
Insert into Cidades (cidade, estado) values ('Serrinha', 'RN');
Insert into Cidades (cidade, estado) values ('Serrinha dos Pintos', 'RN');
Insert into Cidades (cidade, estado) values ('Severiano Melo', 'RN');
Insert into Cidades (cidade, estado) values ('Sítio Novo', 'RN');
Insert into Cidades (cidade, estado) values ('Taboleiro Grande', 'RN');
Insert into Cidades (cidade, estado) values ('Taipu', 'RN');
Insert into Cidades (cidade, estado) values ('Tangará', 'RN');
Insert into Cidades (cidade, estado) values ('Tenente Ananias', 'RN');
Insert into Cidades (cidade, estado) values ('Tenente Laurentino Cruz', 'RN');
Insert into Cidades (cidade, estado) values ('Tibau do Sul', 'RN');
Insert into Cidades (cidade, estado) values ('Timbaúba dos Batistas', 'RN');
Insert into Cidades (cidade, estado) values ('Touros', 'RN');
Insert into Cidades (cidade, estado) values ('Triunfo Potiguar', 'RN');
Insert into Cidades (cidade, estado) values ('Umarizal', 'RN');
Insert into Cidades (cidade, estado) values ('Upanema', 'RN');
Insert into Cidades (cidade, estado) values ('Várzea', 'RN');
Insert into Cidades (cidade, estado) values ('Venha-Ver', 'RN');
Insert into Cidades (cidade, estado) values ('Vera Cruz', 'RN');
Insert into Cidades (cidade, estado) values ('Viçosa', 'RN');
Insert into Cidades (cidade, estado) values ('Vila Flor', 'RN');
Insert into Cidades (cidade, estado) values ('Água Branca', 'PB');
Insert into Cidades (cidade, estado) values ('Aguiar', 'PB');
Insert into Cidades (cidade, estado) values ('Alagoa Grande', 'PB');
Insert into Cidades (cidade, estado) values ('Alagoa Nova', 'PB');
Insert into Cidades (cidade, estado) values ('Alagoinha', 'PB');
Insert into Cidades (cidade, estado) values ('Alcantil', 'PB');
Insert into Cidades (cidade, estado) values ('Algodão de Jandaíra', 'PB');
Insert into Cidades (cidade, estado) values ('Alhandra', 'PB');
Insert into Cidades (cidade, estado) values ('São João do Rio do Peixe', 'PB');
Insert into Cidades (cidade, estado) values ('Amparo', 'PB');
Insert into Cidades (cidade, estado) values ('Aparecida', 'PB');
Insert into Cidades (cidade, estado) values ('Araçagi', 'PB');
Insert into Cidades (cidade, estado) values ('Arara', 'PB');
Insert into Cidades (cidade, estado) values ('Araruna', 'PB');
Insert into Cidades (cidade, estado) values ('Areia', 'PB');
Insert into Cidades (cidade, estado) values ('Areia de Baraúnas', 'PB');
Insert into Cidades (cidade, estado) values ('Areial', 'PB');
Insert into Cidades (cidade, estado) values ('Aroeiras', 'PB');
Insert into Cidades (cidade, estado) values ('Assunção', 'PB');
Insert into Cidades (cidade, estado) values ('Baía da Traição', 'PB');
Insert into Cidades (cidade, estado) values ('Bananeiras', 'PB');
Insert into Cidades (cidade, estado) values ('Baraúna', 'PB');
Insert into Cidades (cidade, estado) values ('Barra de Santana', 'PB');
Insert into Cidades (cidade, estado) values ('Barra de Santa Rosa', 'PB');
Insert into Cidades (cidade, estado) values ('Barra de São Miguel', 'PB');
Insert into Cidades (cidade, estado) values ('Bayeux', 'PB');
Insert into Cidades (cidade, estado) values ('Belém', 'PB');
Insert into Cidades (cidade, estado) values ('Belém do Brejo do Cruz', 'PB');
Insert into Cidades (cidade, estado) values ('Bernardino Batista', 'PB');
Insert into Cidades (cidade, estado) values ('Boa Ventura', 'PB');
Insert into Cidades (cidade, estado) values ('Boa Vista', 'PB');
Insert into Cidades (cidade, estado) values ('Bom Jesus', 'PB');
Insert into Cidades (cidade, estado) values ('Bom Sucesso', 'PB');
Insert into Cidades (cidade, estado) values ('Bonito de Santa Fé', 'PB');
Insert into Cidades (cidade, estado) values ('Boqueirão', 'PB');
Insert into Cidades (cidade, estado) values ('Igaracy', 'PB');
Insert into Cidades (cidade, estado) values ('Borborema', 'PB');
Insert into Cidades (cidade, estado) values ('Brejo do Cruz', 'PB');
Insert into Cidades (cidade, estado) values ('Brejo dos Santos', 'PB');
Insert into Cidades (cidade, estado) values ('Caaporã', 'PB');
Insert into Cidades (cidade, estado) values ('Cabaceiras', 'PB');
Insert into Cidades (cidade, estado) values ('Cabedelo', 'PB');
Insert into Cidades (cidade, estado) values ('Cachoeira dos Índios', 'PB');
Insert into Cidades (cidade, estado) values ('Cacimba de Areia', 'PB');
Insert into Cidades (cidade, estado) values ('Cacimba de Dentro', 'PB');
Insert into Cidades (cidade, estado) values ('Cacimbas', 'PB');
Insert into Cidades (cidade, estado) values ('Caiçara', 'PB');
Insert into Cidades (cidade, estado) values ('Cajazeiras', 'PB');
Insert into Cidades (cidade, estado) values ('Cajazeirinhas', 'PB');
Insert into Cidades (cidade, estado) values ('Caldas Brandão', 'PB');
Insert into Cidades (cidade, estado) values ('Camalaú', 'PB');
Insert into Cidades (cidade, estado) values ('Campina Grande', 'PB');
Insert into Cidades (cidade, estado) values ('Capim', 'PB');
Insert into Cidades (cidade, estado) values ('Caraúbas', 'PB');
Insert into Cidades (cidade, estado) values ('Carrapateira', 'PB');
Insert into Cidades (cidade, estado) values ('Casserengue', 'PB');
Insert into Cidades (cidade, estado) values ('Catingueira', 'PB');
Insert into Cidades (cidade, estado) values ('Catolé do Rocha', 'PB');
Insert into Cidades (cidade, estado) values ('Caturité', 'PB');
Insert into Cidades (cidade, estado) values ('Conceição', 'PB');
Insert into Cidades (cidade, estado) values ('Condado', 'PB');
Insert into Cidades (cidade, estado) values ('Conde', 'PB');
Insert into Cidades (cidade, estado) values ('Congo', 'PB');
Insert into Cidades (cidade, estado) values ('Coremas', 'PB');
Insert into Cidades (cidade, estado) values ('Coxixola', 'PB');
Insert into Cidades (cidade, estado) values ('Cruz do Espírito Santo', 'PB');
Insert into Cidades (cidade, estado) values ('Cubati', 'PB');
Insert into Cidades (cidade, estado) values ('Cuité', 'PB');
Insert into Cidades (cidade, estado) values ('Cuitegi', 'PB');
Insert into Cidades (cidade, estado) values ('Cuité de Mamanguape', 'PB');
Insert into Cidades (cidade, estado) values ('Curral de Cima', 'PB');
Insert into Cidades (cidade, estado) values ('Curral Velho', 'PB');
Insert into Cidades (cidade, estado) values ('Damião', 'PB');
Insert into Cidades (cidade, estado) values ('Desterro', 'PB');
Insert into Cidades (cidade, estado) values ('Vista Serrana', 'PB');
Insert into Cidades (cidade, estado) values ('Diamante', 'PB');
Insert into Cidades (cidade, estado) values ('Dona Inês', 'PB');
Insert into Cidades (cidade, estado) values ('Duas Estradas', 'PB');
Insert into Cidades (cidade, estado) values ('Emas', 'PB');
Insert into Cidades (cidade, estado) values ('Esperança', 'PB');
Insert into Cidades (cidade, estado) values ('Fagundes', 'PB');
Insert into Cidades (cidade, estado) values ('Frei Martinho', 'PB');
Insert into Cidades (cidade, estado) values ('Gado Bravo', 'PB');
Insert into Cidades (cidade, estado) values ('Guarabira', 'PB');
Insert into Cidades (cidade, estado) values ('Gurinhém', 'PB');
Insert into Cidades (cidade, estado) values ('Gurjão', 'PB');
Insert into Cidades (cidade, estado) values ('Ibiara', 'PB');
Insert into Cidades (cidade, estado) values ('Imaculada', 'PB');
Insert into Cidades (cidade, estado) values ('Ingá', 'PB');
Insert into Cidades (cidade, estado) values ('Itabaiana', 'PB');
Insert into Cidades (cidade, estado) values ('Itaporanga', 'PB');
Insert into Cidades (cidade, estado) values ('Itapororoca', 'PB');
Insert into Cidades (cidade, estado) values ('Itatuba', 'PB');
Insert into Cidades (cidade, estado) values ('Jacaraú', 'PB');
Insert into Cidades (cidade, estado) values ('Jericó', 'PB');
Insert into Cidades (cidade, estado) values ('João Pessoa', 'PB');
Insert into Cidades (cidade, estado) values ('Juarez Távora', 'PB');
Insert into Cidades (cidade, estado) values ('Juazeirinho', 'PB');
Insert into Cidades (cidade, estado) values ('Junco do Seridó', 'PB');
Insert into Cidades (cidade, estado) values ('Juripiranga', 'PB');
Insert into Cidades (cidade, estado) values ('Juru', 'PB');
Insert into Cidades (cidade, estado) values ('Lagoa', 'PB');
Insert into Cidades (cidade, estado) values ('Lagoa de Dentro', 'PB');
Insert into Cidades (cidade, estado) values ('Lagoa Seca', 'PB');
Insert into Cidades (cidade, estado) values ('Lastro', 'PB');
Insert into Cidades (cidade, estado) values ('Livramento', 'PB');
Insert into Cidades (cidade, estado) values ('Logradouro', 'PB');
Insert into Cidades (cidade, estado) values ('Lucena', 'PB');
Insert into Cidades (cidade, estado) values ('Mãe D''Água', 'PB');
Insert into Cidades (cidade, estado) values ('Malta', 'PB');
Insert into Cidades (cidade, estado) values ('Mamanguape', 'PB');
Insert into Cidades (cidade, estado) values ('Manaíra', 'PB');
Insert into Cidades (cidade, estado) values ('Marcação', 'PB');
Insert into Cidades (cidade, estado) values ('Mari', 'PB');
Insert into Cidades (cidade, estado) values ('Marizópolis', 'PB');
Insert into Cidades (cidade, estado) values ('Massaranduba', 'PB');
Insert into Cidades (cidade, estado) values ('Mataraca', 'PB');
Insert into Cidades (cidade, estado) values ('Matinhas', 'PB');
Insert into Cidades (cidade, estado) values ('Mato Grosso', 'PB');
Insert into Cidades (cidade, estado) values ('Maturéia', 'PB');
Insert into Cidades (cidade, estado) values ('Mogeiro', 'PB');
Insert into Cidades (cidade, estado) values ('Montadas', 'PB');
Insert into Cidades (cidade, estado) values ('Monte Horebe', 'PB');
Insert into Cidades (cidade, estado) values ('Monteiro', 'PB');
Insert into Cidades (cidade, estado) values ('Mulungu', 'PB');
Insert into Cidades (cidade, estado) values ('Natuba', 'PB');
Insert into Cidades (cidade, estado) values ('Nazarezinho', 'PB');
Insert into Cidades (cidade, estado) values ('Nova Floresta', 'PB');
Insert into Cidades (cidade, estado) values ('Nova Olinda', 'PB');
Insert into Cidades (cidade, estado) values ('Nova Palmeira', 'PB');
Insert into Cidades (cidade, estado) values ('Olho D''Água', 'PB');
Insert into Cidades (cidade, estado) values ('Olivedos', 'PB');
Insert into Cidades (cidade, estado) values ('Ouro Velho', 'PB');
Insert into Cidades (cidade, estado) values ('Parari', 'PB');
Insert into Cidades (cidade, estado) values ('Passagem', 'PB');
Insert into Cidades (cidade, estado) values ('Patos', 'PB');
Insert into Cidades (cidade, estado) values ('Paulista', 'PB');
Insert into Cidades (cidade, estado) values ('Pedra Branca', 'PB');
Insert into Cidades (cidade, estado) values ('Pedra Lavrada', 'PB');
Insert into Cidades (cidade, estado) values ('Pedras de Fogo', 'PB');
Insert into Cidades (cidade, estado) values ('Piancó', 'PB');
Insert into Cidades (cidade, estado) values ('Picuí', 'PB');
Insert into Cidades (cidade, estado) values ('Pilar', 'PB');
Insert into Cidades (cidade, estado) values ('Pilões', 'PB');
Insert into Cidades (cidade, estado) values ('Pilõezinhos', 'PB');
Insert into Cidades (cidade, estado) values ('Pirpirituba', 'PB');
Insert into Cidades (cidade, estado) values ('Pitimbu', 'PB');
Insert into Cidades (cidade, estado) values ('Pocinhos', 'PB');
Insert into Cidades (cidade, estado) values ('Poço Dantas', 'PB');
Insert into Cidades (cidade, estado) values ('Poço de José de Moura', 'PB');
Insert into Cidades (cidade, estado) values ('Pombal', 'PB');
Insert into Cidades (cidade, estado) values ('Prata', 'PB');
Insert into Cidades (cidade, estado) values ('Princesa Isabel', 'PB');
Insert into Cidades (cidade, estado) values ('Puxinanã', 'PB');
Insert into Cidades (cidade, estado) values ('Queimadas', 'PB');
Insert into Cidades (cidade, estado) values ('Quixabá', 'PB');
Insert into Cidades (cidade, estado) values ('Remígio', 'PB');
Insert into Cidades (cidade, estado) values ('Pedro Régis', 'PB');
Insert into Cidades (cidade, estado) values ('Riachão', 'PB');
Insert into Cidades (cidade, estado) values ('Riachão do Bacamarte', 'PB');
Insert into Cidades (cidade, estado) values ('Riachão do Poço', 'PB');
Insert into Cidades (cidade, estado) values ('Riacho de Santo Antônio', 'PB');
Insert into Cidades (cidade, estado) values ('Riacho dos Cavalos', 'PB');
Insert into Cidades (cidade, estado) values ('Rio Tinto', 'PB');
Insert into Cidades (cidade, estado) values ('Salgadinho', 'PB');
Insert into Cidades (cidade, estado) values ('Salgado de São Félix', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Cecília', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Cruz', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Helena', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Inês', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Luzia', 'PB');
Insert into Cidades (cidade, estado) values ('Santana de Mangueira', 'PB');
Insert into Cidades (cidade, estado) values ('Santana dos Garrotes', 'PB');
Insert into Cidades (cidade, estado) values ('Joca Claudino', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Rita', 'PB');
Insert into Cidades (cidade, estado) values ('Santa Teresinha', 'PB');
Insert into Cidades (cidade, estado) values ('Santo André', 'PB');
Insert into Cidades (cidade, estado) values ('São Bento', 'PB');
Insert into Cidades (cidade, estado) values ('São Bentinho', 'PB');
Insert into Cidades (cidade, estado) values ('São Domingos do Cariri', 'PB');
Insert into Cidades (cidade, estado) values ('São Domingos', 'PB');
Insert into Cidades (cidade, estado) values ('São Francisco', 'PB');
Insert into Cidades (cidade, estado) values ('São João do Cariri', 'PB');
Insert into Cidades (cidade, estado) values ('São João do Tigre', 'PB');
Insert into Cidades (cidade, estado) values ('São José da Lagoa Tapada', 'PB');
Insert into Cidades (cidade, estado) values ('São José de Caiana', 'PB');
Insert into Cidades (cidade, estado) values ('São José de Espinharas', 'PB');
Insert into Cidades (cidade, estado) values ('São José dos Ramos', 'PB');
Insert into Cidades (cidade, estado) values ('São José de Piranhas', 'PB');
Insert into Cidades (cidade, estado) values ('São José de Princesa', 'PB');
Insert into Cidades (cidade, estado) values ('São José do Bonfim', 'PB');
Insert into Cidades (cidade, estado) values ('São José do Brejo do Cruz', 'PB');
Insert into Cidades (cidade, estado) values ('São José do Sabugi', 'PB');
Insert into Cidades (cidade, estado) values ('São José dos Cordeiros', 'PB');
Insert into Cidades (cidade, estado) values ('São Mamede', 'PB');
Insert into Cidades (cidade, estado) values ('São Miguel de Taipu', 'PB');
Insert into Cidades (cidade, estado) values ('São Sebastião de Lagoa de Roça', 'PB');
Insert into Cidades (cidade, estado) values ('São Sebastião do Umbuzeiro', 'PB');
Insert into Cidades (cidade, estado) values ('Sapé', 'PB');
Insert into Cidades (cidade, estado) values ('São Vicente do Seridó', 'PB');
Insert into Cidades (cidade, estado) values ('Serra Branca', 'PB');
Insert into Cidades (cidade, estado) values ('Serra da Raiz', 'PB');
Insert into Cidades (cidade, estado) values ('Serra Grande', 'PB');
Insert into Cidades (cidade, estado) values ('Serra Redonda', 'PB');
Insert into Cidades (cidade, estado) values ('Serraria', 'PB');
Insert into Cidades (cidade, estado) values ('Sertãozinho', 'PB');
Insert into Cidades (cidade, estado) values ('Sobrado', 'PB');
Insert into Cidades (cidade, estado) values ('Solânea', 'PB');
Insert into Cidades (cidade, estado) values ('Soledade', 'PB');
Insert into Cidades (cidade, estado) values ('Sossêgo', 'PB');
Insert into Cidades (cidade, estado) values ('Sousa', 'PB');
Insert into Cidades (cidade, estado) values ('Sumé', 'PB');
Insert into Cidades (cidade, estado) values ('Tacima', 'PB');
Insert into Cidades (cidade, estado) values ('Taperoá', 'PB');
Insert into Cidades (cidade, estado) values ('Tavares', 'PB');
Insert into Cidades (cidade, estado) values ('Teixeira', 'PB');
Insert into Cidades (cidade, estado) values ('Tenório', 'PB');
Insert into Cidades (cidade, estado) values ('Triunfo', 'PB');
Insert into Cidades (cidade, estado) values ('Uiraúna', 'PB');
Insert into Cidades (cidade, estado) values ('Umbuzeiro', 'PB');
Insert into Cidades (cidade, estado) values ('Várzea', 'PB');
Insert into Cidades (cidade, estado) values ('Vieirópolis', 'PB');
Insert into Cidades (cidade, estado) values ('Zabelê', 'PB');
Insert into Cidades (cidade, estado) values ('Abreu e Lima', 'PE');
Insert into Cidades (cidade, estado) values ('Afogados da Ingazeira', 'PE');
Insert into Cidades (cidade, estado) values ('Afrânio', 'PE');
Insert into Cidades (cidade, estado) values ('Agrestina', 'PE');
Insert into Cidades (cidade, estado) values ('Água Preta', 'PE');
Insert into Cidades (cidade, estado) values ('Águas Belas', 'PE');
Insert into Cidades (cidade, estado) values ('Alagoinha', 'PE');
Insert into Cidades (cidade, estado) values ('Aliança', 'PE');
Insert into Cidades (cidade, estado) values ('Altinho', 'PE');
Insert into Cidades (cidade, estado) values ('Amaraji', 'PE');
Insert into Cidades (cidade, estado) values ('Angelim', 'PE');
Insert into Cidades (cidade, estado) values ('Araçoiaba', 'PE');
Insert into Cidades (cidade, estado) values ('Araripina', 'PE');
Insert into Cidades (cidade, estado) values ('Arcoverde', 'PE');
Insert into Cidades (cidade, estado) values ('Barra de Guabiraba', 'PE');
Insert into Cidades (cidade, estado) values ('Barreiros', 'PE');
Insert into Cidades (cidade, estado) values ('Belém de Maria', 'PE');
Insert into Cidades (cidade, estado) values ('Belém do São Francisco', 'PE');
Insert into Cidades (cidade, estado) values ('Belo Jardim', 'PE');
Insert into Cidades (cidade, estado) values ('Betânia', 'PE');
Insert into Cidades (cidade, estado) values ('Bezerros', 'PE');
Insert into Cidades (cidade, estado) values ('Bodocó', 'PE');
Insert into Cidades (cidade, estado) values ('Bom Conselho', 'PE');
Insert into Cidades (cidade, estado) values ('Bom Jardim', 'PE');
Insert into Cidades (cidade, estado) values ('Bonito', 'PE');
Insert into Cidades (cidade, estado) values ('Brejão', 'PE');
Insert into Cidades (cidade, estado) values ('Brejinho', 'PE');
Insert into Cidades (cidade, estado) values ('Brejo da Madre de Deus', 'PE');
Insert into Cidades (cidade, estado) values ('Buenos Aires', 'PE');
Insert into Cidades (cidade, estado) values ('Buíque', 'PE');
Insert into Cidades (cidade, estado) values ('Cabo de Santo Agostinho', 'PE');
Insert into Cidades (cidade, estado) values ('Cabrobó', 'PE');
Insert into Cidades (cidade, estado) values ('Cachoeirinha', 'PE');
Insert into Cidades (cidade, estado) values ('Caetés', 'PE');
Insert into Cidades (cidade, estado) values ('Calçado', 'PE');
Insert into Cidades (cidade, estado) values ('Calumbi', 'PE');
Insert into Cidades (cidade, estado) values ('Camaragibe', 'PE');
Insert into Cidades (cidade, estado) values ('Camocim de São Félix', 'PE');
Insert into Cidades (cidade, estado) values ('Camutanga', 'PE');
Insert into Cidades (cidade, estado) values ('Canhotinho', 'PE');
Insert into Cidades (cidade, estado) values ('Capoeiras', 'PE');
Insert into Cidades (cidade, estado) values ('Carnaíba', 'PE');
Insert into Cidades (cidade, estado) values ('Carnaubeira da Penha', 'PE');
Insert into Cidades (cidade, estado) values ('Carpina', 'PE');
Insert into Cidades (cidade, estado) values ('Caruaru', 'PE');
Insert into Cidades (cidade, estado) values ('Casinhas', 'PE');
Insert into Cidades (cidade, estado) values ('Catende', 'PE');
Insert into Cidades (cidade, estado) values ('Cedro', 'PE');
Insert into Cidades (cidade, estado) values ('Chã de Alegria', 'PE');
Insert into Cidades (cidade, estado) values ('Chã Grande', 'PE');
Insert into Cidades (cidade, estado) values ('Condado', 'PE');
Insert into Cidades (cidade, estado) values ('Correntes', 'PE');
Insert into Cidades (cidade, estado) values ('Cortês', 'PE');
Insert into Cidades (cidade, estado) values ('Cumaru', 'PE');
Insert into Cidades (cidade, estado) values ('Cupira', 'PE');
Insert into Cidades (cidade, estado) values ('Custódia', 'PE');
Insert into Cidades (cidade, estado) values ('Dormentes', 'PE');
Insert into Cidades (cidade, estado) values ('Escada', 'PE');
Insert into Cidades (cidade, estado) values ('Exu', 'PE');
Insert into Cidades (cidade, estado) values ('Feira Nova', 'PE');
Insert into Cidades (cidade, estado) values ('Fernando de Noronha', 'PE');
Insert into Cidades (cidade, estado) values ('Ferreiros', 'PE');
Insert into Cidades (cidade, estado) values ('Flores', 'PE');
Insert into Cidades (cidade, estado) values ('Floresta', 'PE');
Insert into Cidades (cidade, estado) values ('Frei Miguelinho', 'PE');
Insert into Cidades (cidade, estado) values ('Gameleira', 'PE');
Insert into Cidades (cidade, estado) values ('Garanhuns', 'PE');
Insert into Cidades (cidade, estado) values ('Glória do Goitá', 'PE');
Insert into Cidades (cidade, estado) values ('Goiana', 'PE');
Insert into Cidades (cidade, estado) values ('Granito', 'PE');
Insert into Cidades (cidade, estado) values ('Gravatá', 'PE');
Insert into Cidades (cidade, estado) values ('Iati', 'PE');
Insert into Cidades (cidade, estado) values ('Ibimirim', 'PE');
Insert into Cidades (cidade, estado) values ('Ibirajuba', 'PE');
Insert into Cidades (cidade, estado) values ('Igarassu', 'PE');
Insert into Cidades (cidade, estado) values ('Iguaraci', 'PE');
Insert into Cidades (cidade, estado) values ('Inajá', 'PE');
Insert into Cidades (cidade, estado) values ('Ingazeira', 'PE');
Insert into Cidades (cidade, estado) values ('Ipojuca', 'PE');
Insert into Cidades (cidade, estado) values ('Ipubi', 'PE');
Insert into Cidades (cidade, estado) values ('Itacuruba', 'PE');
Insert into Cidades (cidade, estado) values ('Itaíba', 'PE');
Insert into Cidades (cidade, estado) values ('Ilha de Itamaracá', 'PE');
Insert into Cidades (cidade, estado) values ('Itambé', 'PE');
Insert into Cidades (cidade, estado) values ('Itapetim', 'PE');
Insert into Cidades (cidade, estado) values ('Itapissuma', 'PE');
Insert into Cidades (cidade, estado) values ('Itaquitinga', 'PE');
Insert into Cidades (cidade, estado) values ('Jaboatão dos Guararapes', 'PE');
Insert into Cidades (cidade, estado) values ('Jaqueira', 'PE');
Insert into Cidades (cidade, estado) values ('Jataúba', 'PE');
Insert into Cidades (cidade, estado) values ('Jatobá', 'PE');
Insert into Cidades (cidade, estado) values ('João Alfredo', 'PE');
Insert into Cidades (cidade, estado) values ('Joaquim Nabuco', 'PE');
Insert into Cidades (cidade, estado) values ('Jucati', 'PE');
Insert into Cidades (cidade, estado) values ('Jupi', 'PE');
Insert into Cidades (cidade, estado) values ('Jurema', 'PE');
Insert into Cidades (cidade, estado) values ('Lagoa do Carro', 'PE');
Insert into Cidades (cidade, estado) values ('Lagoa de Itaenga', 'PE');
Insert into Cidades (cidade, estado) values ('Lagoa do Ouro', 'PE');
Insert into Cidades (cidade, estado) values ('Lagoa dos Gatos', 'PE');
Insert into Cidades (cidade, estado) values ('Lagoa Grande', 'PE');
Insert into Cidades (cidade, estado) values ('Lajedo', 'PE');
Insert into Cidades (cidade, estado) values ('Limoeiro', 'PE');
Insert into Cidades (cidade, estado) values ('Macaparana', 'PE');
Insert into Cidades (cidade, estado) values ('Machados', 'PE');
Insert into Cidades (cidade, estado) values ('Manari', 'PE');
Insert into Cidades (cidade, estado) values ('Maraial', 'PE');
Insert into Cidades (cidade, estado) values ('Mirandiba', 'PE');
Insert into Cidades (cidade, estado) values ('Moreno', 'PE');
Insert into Cidades (cidade, estado) values ('Nazaré da Mata', 'PE');
Insert into Cidades (cidade, estado) values ('Olinda', 'PE');
Insert into Cidades (cidade, estado) values ('Orobó', 'PE');
Insert into Cidades (cidade, estado) values ('Orocó', 'PE');
Insert into Cidades (cidade, estado) values ('Ouricuri', 'PE');
Insert into Cidades (cidade, estado) values ('Palmares', 'PE');
Insert into Cidades (cidade, estado) values ('Palmeirina', 'PE');
Insert into Cidades (cidade, estado) values ('Panelas', 'PE');
Insert into Cidades (cidade, estado) values ('Paranatama', 'PE');
Insert into Cidades (cidade, estado) values ('Parnamirim', 'PE');
Insert into Cidades (cidade, estado) values ('Passira', 'PE');
Insert into Cidades (cidade, estado) values ('Paudalho', 'PE');
Insert into Cidades (cidade, estado) values ('Paulista', 'PE');
Insert into Cidades (cidade, estado) values ('Pedra', 'PE');
Insert into Cidades (cidade, estado) values ('Pesqueira', 'PE');
Insert into Cidades (cidade, estado) values ('Petrolândia', 'PE');
Insert into Cidades (cidade, estado) values ('Petrolina', 'PE');
Insert into Cidades (cidade, estado) values ('Poção', 'PE');
Insert into Cidades (cidade, estado) values ('Pombos', 'PE');
Insert into Cidades (cidade, estado) values ('Primavera', 'PE');
Insert into Cidades (cidade, estado) values ('Quipapá', 'PE');
Insert into Cidades (cidade, estado) values ('Quixaba', 'PE');
Insert into Cidades (cidade, estado) values ('Recife', 'PE');
Insert into Cidades (cidade, estado) values ('Riacho das Almas', 'PE');
Insert into Cidades (cidade, estado) values ('Ribeirão', 'PE');
Insert into Cidades (cidade, estado) values ('Rio Formoso', 'PE');
Insert into Cidades (cidade, estado) values ('Sairé', 'PE');
Insert into Cidades (cidade, estado) values ('Salgadinho', 'PE');
Insert into Cidades (cidade, estado) values ('Salgueiro', 'PE');
Insert into Cidades (cidade, estado) values ('Saloá', 'PE');
Insert into Cidades (cidade, estado) values ('Sanharó', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Cruz', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Cruz da Baixa Verde', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Capibaribe', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Filomena', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Maria da Boa Vista', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Maria do Cambucá', 'PE');
Insert into Cidades (cidade, estado) values ('Santa Terezinha', 'PE');
Insert into Cidades (cidade, estado) values ('São Benedito do Sul', 'PE');
Insert into Cidades (cidade, estado) values ('São Bento do Una', 'PE');
Insert into Cidades (cidade, estado) values ('São Caitano', 'PE');
Insert into Cidades (cidade, estado) values ('São João', 'PE');
Insert into Cidades (cidade, estado) values ('São Joaquim do Monte', 'PE');
Insert into Cidades (cidade, estado) values ('São José da Coroa Grande', 'PE');
Insert into Cidades (cidade, estado) values ('São José do Belmonte', 'PE');
Insert into Cidades (cidade, estado) values ('São José do Egito', 'PE');
Insert into Cidades (cidade, estado) values ('São Lourenço da Mata', 'PE');
Insert into Cidades (cidade, estado) values ('São Vicente Ferrer', 'PE');
Insert into Cidades (cidade, estado) values ('Serra Talhada', 'PE');
Insert into Cidades (cidade, estado) values ('Serrita', 'PE');
Insert into Cidades (cidade, estado) values ('Sertânia', 'PE');
Insert into Cidades (cidade, estado) values ('Sirinhaém', 'PE');
Insert into Cidades (cidade, estado) values ('Moreilândia', 'PE');
Insert into Cidades (cidade, estado) values ('Solidão', 'PE');
Insert into Cidades (cidade, estado) values ('Surubim', 'PE');
Insert into Cidades (cidade, estado) values ('Tabira', 'PE');
Insert into Cidades (cidade, estado) values ('Tacaimbó', 'PE');
Insert into Cidades (cidade, estado) values ('Tacaratu', 'PE');
Insert into Cidades (cidade, estado) values ('Tamandaré', 'PE');
Insert into Cidades (cidade, estado) values ('Taquaritinga do Norte', 'PE');
Insert into Cidades (cidade, estado) values ('Terezinha', 'PE');
Insert into Cidades (cidade, estado) values ('Terra Nova', 'PE');
Insert into Cidades (cidade, estado) values ('Timbaúba', 'PE');
Insert into Cidades (cidade, estado) values ('Toritama', 'PE');
Insert into Cidades (cidade, estado) values ('Tracunhaém', 'PE');
Insert into Cidades (cidade, estado) values ('Trindade', 'PE');
Insert into Cidades (cidade, estado) values ('Triunfo', 'PE');
Insert into Cidades (cidade, estado) values ('Tupanatinga', 'PE');
Insert into Cidades (cidade, estado) values ('Tuparetama', 'PE');
Insert into Cidades (cidade, estado) values ('Venturosa', 'PE');
Insert into Cidades (cidade, estado) values ('Verdejante', 'PE');
Insert into Cidades (cidade, estado) values ('Vertente do Lério', 'PE');
Insert into Cidades (cidade, estado) values ('Vertentes', 'PE');
Insert into Cidades (cidade, estado) values ('Vicência', 'PE');
Insert into Cidades (cidade, estado) values ('Vitória de Santo Antão', 'PE');
Insert into Cidades (cidade, estado) values ('Xexéu', 'PE');
Insert into Cidades (cidade, estado) values ('Água Branca', 'AL');
Insert into Cidades (cidade, estado) values ('Anadia', 'AL');
Insert into Cidades (cidade, estado) values ('Arapiraca', 'AL');
Insert into Cidades (cidade, estado) values ('Atalaia', 'AL');
Insert into Cidades (cidade, estado) values ('Barra de Santo Antônio', 'AL');
Insert into Cidades (cidade, estado) values ('Barra de São Miguel', 'AL');
Insert into Cidades (cidade, estado) values ('Batalha', 'AL');
Insert into Cidades (cidade, estado) values ('Belém', 'AL');
Insert into Cidades (cidade, estado) values ('Belo Monte', 'AL');
Insert into Cidades (cidade, estado) values ('Boca da Mata', 'AL');
Insert into Cidades (cidade, estado) values ('Branquinha', 'AL');
Insert into Cidades (cidade, estado) values ('Cacimbinhas', 'AL');
Insert into Cidades (cidade, estado) values ('Cajueiro', 'AL');
Insert into Cidades (cidade, estado) values ('Campestre', 'AL');
Insert into Cidades (cidade, estado) values ('Campo Alegre', 'AL');
Insert into Cidades (cidade, estado) values ('Campo Grande', 'AL');
Insert into Cidades (cidade, estado) values ('Canapi', 'AL');
Insert into Cidades (cidade, estado) values ('Capela', 'AL');
Insert into Cidades (cidade, estado) values ('Carneiros', 'AL');
Insert into Cidades (cidade, estado) values ('Chã Preta', 'AL');
Insert into Cidades (cidade, estado) values ('Coité do Nóia', 'AL');
Insert into Cidades (cidade, estado) values ('Colônia Leopoldina', 'AL');
Insert into Cidades (cidade, estado) values ('Coqueiro Seco', 'AL');
Insert into Cidades (cidade, estado) values ('Coruripe', 'AL');
Insert into Cidades (cidade, estado) values ('Craíbas', 'AL');
Insert into Cidades (cidade, estado) values ('Delmiro Gouveia', 'AL');
Insert into Cidades (cidade, estado) values ('Dois Riachos', 'AL');
Insert into Cidades (cidade, estado) values ('Estrela de Alagoas', 'AL');
Insert into Cidades (cidade, estado) values ('Feira Grande', 'AL');
Insert into Cidades (cidade, estado) values ('Feliz Deserto', 'AL');
Insert into Cidades (cidade, estado) values ('Flexeiras', 'AL');
Insert into Cidades (cidade, estado) values ('Girau do Ponciano', 'AL');
Insert into Cidades (cidade, estado) values ('Ibateguara', 'AL');
Insert into Cidades (cidade, estado) values ('Igaci', 'AL');
Insert into Cidades (cidade, estado) values ('Igreja Nova', 'AL');
Insert into Cidades (cidade, estado) values ('Inhapi', 'AL');
Insert into Cidades (cidade, estado) values ('Jacaré dos Homens', 'AL');
Insert into Cidades (cidade, estado) values ('Jacuípe', 'AL');
Insert into Cidades (cidade, estado) values ('Japaratinga', 'AL');
Insert into Cidades (cidade, estado) values ('Jaramataia', 'AL');
Insert into Cidades (cidade, estado) values ('Jequiá da Praia', 'AL');
Insert into Cidades (cidade, estado) values ('Joaquim Gomes', 'AL');
Insert into Cidades (cidade, estado) values ('Jundiá', 'AL');
Insert into Cidades (cidade, estado) values ('Junqueiro', 'AL');
Insert into Cidades (cidade, estado) values ('Lagoa da Canoa', 'AL');
Insert into Cidades (cidade, estado) values ('Limoeiro de Anadia', 'AL');
Insert into Cidades (cidade, estado) values ('Maceió', 'AL');
Insert into Cidades (cidade, estado) values ('Major Isidoro', 'AL');
Insert into Cidades (cidade, estado) values ('Maragogi', 'AL');
Insert into Cidades (cidade, estado) values ('Maravilha', 'AL');
Insert into Cidades (cidade, estado) values ('Marechal Deodoro', 'AL');
Insert into Cidades (cidade, estado) values ('Maribondo', 'AL');
Insert into Cidades (cidade, estado) values ('Mar Vermelho', 'AL');
Insert into Cidades (cidade, estado) values ('Mata Grande', 'AL');
Insert into Cidades (cidade, estado) values ('Matriz de Camaragibe', 'AL');
Insert into Cidades (cidade, estado) values ('Messias', 'AL');
Insert into Cidades (cidade, estado) values ('Minador do Negrão', 'AL');
Insert into Cidades (cidade, estado) values ('Monteirópolis', 'AL');
Insert into Cidades (cidade, estado) values ('Murici', 'AL');
Insert into Cidades (cidade, estado) values ('Novo Lino', 'AL');
Insert into Cidades (cidade, estado) values ('Olho D''Água das Flores', 'AL');
Insert into Cidades (cidade, estado) values ('Olho D''Água do Casado', 'AL');
Insert into Cidades (cidade, estado) values ('Olho D''Água Grande', 'AL');
Insert into Cidades (cidade, estado) values ('Olivença', 'AL');
Insert into Cidades (cidade, estado) values ('Ouro Branco', 'AL');
Insert into Cidades (cidade, estado) values ('Palestina', 'AL');
Insert into Cidades (cidade, estado) values ('Palmeira dos Índios', 'AL');
Insert into Cidades (cidade, estado) values ('Pão de Açúcar', 'AL');
Insert into Cidades (cidade, estado) values ('Pariconha', 'AL');
Insert into Cidades (cidade, estado) values ('Paripueira', 'AL');
Insert into Cidades (cidade, estado) values ('Passo de Camaragibe', 'AL');
Insert into Cidades (cidade, estado) values ('Paulo Jacinto', 'AL');
Insert into Cidades (cidade, estado) values ('Penedo', 'AL');
Insert into Cidades (cidade, estado) values ('Piaçabuçu', 'AL');
Insert into Cidades (cidade, estado) values ('Pilar', 'AL');
Insert into Cidades (cidade, estado) values ('Pindoba', 'AL');
Insert into Cidades (cidade, estado) values ('Piranhas', 'AL');
Insert into Cidades (cidade, estado) values ('Poço das Trincheiras', 'AL');
Insert into Cidades (cidade, estado) values ('Porto Calvo', 'AL');
Insert into Cidades (cidade, estado) values ('Porto de Pedras', 'AL');
Insert into Cidades (cidade, estado) values ('Porto Real do Colégio', 'AL');
Insert into Cidades (cidade, estado) values ('Quebrangulo', 'AL');
Insert into Cidades (cidade, estado) values ('Rio Largo', 'AL');
Insert into Cidades (cidade, estado) values ('Roteiro', 'AL');
Insert into Cidades (cidade, estado) values ('Santa Luzia do Norte', 'AL');
Insert into Cidades (cidade, estado) values ('Santana do Ipanema', 'AL');
Insert into Cidades (cidade, estado) values ('Santana do Mundaú', 'AL');
Insert into Cidades (cidade, estado) values ('São Brás', 'AL');
Insert into Cidades (cidade, estado) values ('São José da Laje', 'AL');
Insert into Cidades (cidade, estado) values ('São José da Tapera', 'AL');
Insert into Cidades (cidade, estado) values ('São Luís do Quitunde', 'AL');
Insert into Cidades (cidade, estado) values ('São Miguel dos Campos', 'AL');
Insert into Cidades (cidade, estado) values ('São Miguel dos Milagres', 'AL');
Insert into Cidades (cidade, estado) values ('São Sebastião', 'AL');
Insert into Cidades (cidade, estado) values ('Satuba', 'AL');
Insert into Cidades (cidade, estado) values ('Senador Rui Palmeira', 'AL');
Insert into Cidades (cidade, estado) values ('Tanque D''Arca', 'AL');
Insert into Cidades (cidade, estado) values ('Taquarana', 'AL');
Insert into Cidades (cidade, estado) values ('Teotônio Vilela', 'AL');
Insert into Cidades (cidade, estado) values ('Traipu', 'AL');
Insert into Cidades (cidade, estado) values ('União dos Palmares', 'AL');
Insert into Cidades (cidade, estado) values ('Viçosa', 'AL');
Insert into Cidades (cidade, estado) values ('Amparo de São Francisco', 'SE');
Insert into Cidades (cidade, estado) values ('Aquidabã', 'SE');
Insert into Cidades (cidade, estado) values ('Aracaju', 'SE');
Insert into Cidades (cidade, estado) values ('Arauá', 'SE');
Insert into Cidades (cidade, estado) values ('Areia Branca', 'SE');
Insert into Cidades (cidade, estado) values ('Barra dos Coqueiros', 'SE');
Insert into Cidades (cidade, estado) values ('Boquim', 'SE');
Insert into Cidades (cidade, estado) values ('Brejo Grande', 'SE');
Insert into Cidades (cidade, estado) values ('Campo do Brito', 'SE');
Insert into Cidades (cidade, estado) values ('Canhoba', 'SE');
Insert into Cidades (cidade, estado) values ('Canindé de São Francisco', 'SE');
Insert into Cidades (cidade, estado) values ('Capela', 'SE');
Insert into Cidades (cidade, estado) values ('Carira', 'SE');
Insert into Cidades (cidade, estado) values ('Carmópolis', 'SE');
Insert into Cidades (cidade, estado) values ('Cedro de São João', 'SE');
Insert into Cidades (cidade, estado) values ('Cristinápolis', 'SE');
Insert into Cidades (cidade, estado) values ('Cumbe', 'SE');
Insert into Cidades (cidade, estado) values ('Divina Pastora', 'SE');
Insert into Cidades (cidade, estado) values ('Estância', 'SE');
Insert into Cidades (cidade, estado) values ('Feira Nova', 'SE');
Insert into Cidades (cidade, estado) values ('Frei Paulo', 'SE');
Insert into Cidades (cidade, estado) values ('Gararu', 'SE');
Insert into Cidades (cidade, estado) values ('General Maynard', 'SE');
Insert into Cidades (cidade, estado) values ('Gracho Cardoso', 'SE');
Insert into Cidades (cidade, estado) values ('Ilha das Flores', 'SE');
Insert into Cidades (cidade, estado) values ('Indiaroba', 'SE');
Insert into Cidades (cidade, estado) values ('Itabaiana', 'SE');
Insert into Cidades (cidade, estado) values ('Itabaianinha', 'SE');
Insert into Cidades (cidade, estado) values ('Itabi', 'SE');
Insert into Cidades (cidade, estado) values ('Itaporanga D''Ajuda', 'SE');
Insert into Cidades (cidade, estado) values ('Japaratuba', 'SE');
Insert into Cidades (cidade, estado) values ('Japoatã', 'SE');
Insert into Cidades (cidade, estado) values ('Lagarto', 'SE');
Insert into Cidades (cidade, estado) values ('Laranjeiras', 'SE');
Insert into Cidades (cidade, estado) values ('Macambira', 'SE');
Insert into Cidades (cidade, estado) values ('Malhada dos Bois', 'SE');
Insert into Cidades (cidade, estado) values ('Malhador', 'SE');
Insert into Cidades (cidade, estado) values ('Maruim', 'SE');
Insert into Cidades (cidade, estado) values ('Moita Bonita', 'SE');
Insert into Cidades (cidade, estado) values ('Monte Alegre de Sergipe', 'SE');
Insert into Cidades (cidade, estado) values ('Muribeca', 'SE');
Insert into Cidades (cidade, estado) values ('Neópolis', 'SE');
Insert into Cidades (cidade, estado) values ('Nossa Senhora Aparecida', 'SE');
Insert into Cidades (cidade, estado) values ('Nossa Senhora da Glória', 'SE');
Insert into Cidades (cidade, estado) values ('Nossa Senhora das Dores', 'SE');
Insert into Cidades (cidade, estado) values ('Nossa Senhora de Lourdes', 'SE');
Insert into Cidades (cidade, estado) values ('Nossa Senhora do Socorro', 'SE');
Insert into Cidades (cidade, estado) values ('Pacatuba', 'SE');
Insert into Cidades (cidade, estado) values ('Pedra Mole', 'SE');
Insert into Cidades (cidade, estado) values ('Pedrinhas', 'SE');
Insert into Cidades (cidade, estado) values ('Pinhão', 'SE');
Insert into Cidades (cidade, estado) values ('Pirambu', 'SE');
Insert into Cidades (cidade, estado) values ('Poço Redondo', 'SE');
Insert into Cidades (cidade, estado) values ('Poço Verde', 'SE');
Insert into Cidades (cidade, estado) values ('Porto da Folha', 'SE');
Insert into Cidades (cidade, estado) values ('Propriá', 'SE');
Insert into Cidades (cidade, estado) values ('Riachão do Dantas', 'SE');
Insert into Cidades (cidade, estado) values ('Riachuelo', 'SE');
Insert into Cidades (cidade, estado) values ('Ribeirópolis', 'SE');
Insert into Cidades (cidade, estado) values ('Rosário do Catete', 'SE');
Insert into Cidades (cidade, estado) values ('Salgado', 'SE');
Insert into Cidades (cidade, estado) values ('Santa Luzia do Itanhy', 'SE');
Insert into Cidades (cidade, estado) values ('Santana do São Francisco', 'SE');
Insert into Cidades (cidade, estado) values ('Santa Rosa de Lima', 'SE');
Insert into Cidades (cidade, estado) values ('Santo Amaro das Brotas', 'SE');
Insert into Cidades (cidade, estado) values ('São Cristóvão', 'SE');
Insert into Cidades (cidade, estado) values ('São Domingos', 'SE');
Insert into Cidades (cidade, estado) values ('São Francisco', 'SE');
Insert into Cidades (cidade, estado) values ('São Miguel do Aleixo', 'SE');
Insert into Cidades (cidade, estado) values ('Simão Dias', 'SE');
Insert into Cidades (cidade, estado) values ('Siriri', 'SE');
Insert into Cidades (cidade, estado) values ('Telha', 'SE');
Insert into Cidades (cidade, estado) values ('Tobias Barreto', 'SE');
Insert into Cidades (cidade, estado) values ('Tomar do Geru', 'SE');
Insert into Cidades (cidade, estado) values ('Umbaúba', 'SE');
Insert into Cidades (cidade, estado) values ('Abaíra', 'BA');
Insert into Cidades (cidade, estado) values ('Abaré', 'BA');
Insert into Cidades (cidade, estado) values ('Acajutiba', 'BA');
Insert into Cidades (cidade, estado) values ('Adustina', 'BA');
Insert into Cidades (cidade, estado) values ('Água Fria', 'BA');
Insert into Cidades (cidade, estado) values ('Érico Cardoso', 'BA');
Insert into Cidades (cidade, estado) values ('Aiquara', 'BA');
Insert into Cidades (cidade, estado) values ('Alagoinhas', 'BA');
Insert into Cidades (cidade, estado) values ('Alcobaça', 'BA');
Insert into Cidades (cidade, estado) values ('Almadina', 'BA');
Insert into Cidades (cidade, estado) values ('Amargosa', 'BA');
Insert into Cidades (cidade, estado) values ('Amélia Rodrigues', 'BA');
Insert into Cidades (cidade, estado) values ('América Dourada', 'BA');
Insert into Cidades (cidade, estado) values ('Anagé', 'BA');
Insert into Cidades (cidade, estado) values ('Andaraí', 'BA');
Insert into Cidades (cidade, estado) values ('Andorinha', 'BA');
Insert into Cidades (cidade, estado) values ('Angical', 'BA');
Insert into Cidades (cidade, estado) values ('Anguera', 'BA');
Insert into Cidades (cidade, estado) values ('Antas', 'BA');
Insert into Cidades (cidade, estado) values ('Antônio Cardoso', 'BA');
Insert into Cidades (cidade, estado) values ('Antônio Gonçalves', 'BA');
Insert into Cidades (cidade, estado) values ('Aporá', 'BA');
Insert into Cidades (cidade, estado) values ('Apuarema', 'BA');
Insert into Cidades (cidade, estado) values ('Aracatu', 'BA');
Insert into Cidades (cidade, estado) values ('Araças', 'BA');
Insert into Cidades (cidade, estado) values ('Araci', 'BA');
Insert into Cidades (cidade, estado) values ('Aramari', 'BA');
Insert into Cidades (cidade, estado) values ('Arataca', 'BA');
Insert into Cidades (cidade, estado) values ('Aratuípe', 'BA');
Insert into Cidades (cidade, estado) values ('Aurelino Leal', 'BA');
Insert into Cidades (cidade, estado) values ('Baianópolis', 'BA');
Insert into Cidades (cidade, estado) values ('Baixa Grande', 'BA');
Insert into Cidades (cidade, estado) values ('Banzaê', 'BA');
Insert into Cidades (cidade, estado) values ('Barra', 'BA');
Insert into Cidades (cidade, estado) values ('Barra da Estiva', 'BA');
Insert into Cidades (cidade, estado) values ('Barra do Choça', 'BA');
Insert into Cidades (cidade, estado) values ('Barra do Mendes', 'BA');
Insert into Cidades (cidade, estado) values ('Barra do Rocha', 'BA');
Insert into Cidades (cidade, estado) values ('Barreiras', 'BA');
Insert into Cidades (cidade, estado) values ('Barro Alto', 'BA');
Insert into Cidades (cidade, estado) values ('Barrocas', 'BA');
Insert into Cidades (cidade, estado) values ('Barro Preto', 'BA');
Insert into Cidades (cidade, estado) values ('Belmonte', 'BA');
Insert into Cidades (cidade, estado) values ('Belo Campo', 'BA');
Insert into Cidades (cidade, estado) values ('Biritinga', 'BA');
Insert into Cidades (cidade, estado) values ('Boa Nova', 'BA');
Insert into Cidades (cidade, estado) values ('Boa Vista do Tupim', 'BA');
Insert into Cidades (cidade, estado) values ('Bom Jesus da Lapa', 'BA');
Insert into Cidades (cidade, estado) values ('Bom Jesus da Serra', 'BA');
Insert into Cidades (cidade, estado) values ('Boninal', 'BA');
Insert into Cidades (cidade, estado) values ('Bonito', 'BA');
Insert into Cidades (cidade, estado) values ('Boquira', 'BA');
Insert into Cidades (cidade, estado) values ('Botuporã', 'BA');
Insert into Cidades (cidade, estado) values ('Brejões', 'BA');
Insert into Cidades (cidade, estado) values ('Brejolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Brotas de Macaúbas', 'BA');
Insert into Cidades (cidade, estado) values ('Brumado', 'BA');
Insert into Cidades (cidade, estado) values ('Buerarema', 'BA');
Insert into Cidades (cidade, estado) values ('Buritirama', 'BA');
Insert into Cidades (cidade, estado) values ('Caatiba', 'BA');
Insert into Cidades (cidade, estado) values ('Cabaceiras do Paraguaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Cachoeira', 'BA');
Insert into Cidades (cidade, estado) values ('Caculé', 'BA');
Insert into Cidades (cidade, estado) values ('Caém', 'BA');
Insert into Cidades (cidade, estado) values ('Caetanos', 'BA');
Insert into Cidades (cidade, estado) values ('Caetité', 'BA');
Insert into Cidades (cidade, estado) values ('Cafarnaum', 'BA');
Insert into Cidades (cidade, estado) values ('Cairu', 'BA');
Insert into Cidades (cidade, estado) values ('Caldeirão Grande', 'BA');
Insert into Cidades (cidade, estado) values ('Camacan', 'BA');
Insert into Cidades (cidade, estado) values ('Camaçari', 'BA');
Insert into Cidades (cidade, estado) values ('Camamu', 'BA');
Insert into Cidades (cidade, estado) values ('Campo Alegre de Lourdes', 'BA');
Insert into Cidades (cidade, estado) values ('Campo Formoso', 'BA');
Insert into Cidades (cidade, estado) values ('Canápolis', 'BA');
Insert into Cidades (cidade, estado) values ('Canarana', 'BA');
Insert into Cidades (cidade, estado) values ('Canavieiras', 'BA');
Insert into Cidades (cidade, estado) values ('Candeal', 'BA');
Insert into Cidades (cidade, estado) values ('Candeias', 'BA');
Insert into Cidades (cidade, estado) values ('Candiba', 'BA');
Insert into Cidades (cidade, estado) values ('Cândido Sales', 'BA');
Insert into Cidades (cidade, estado) values ('Cansanção', 'BA');
Insert into Cidades (cidade, estado) values ('Canudos', 'BA');
Insert into Cidades (cidade, estado) values ('Capela do Alto Alegre', 'BA');
Insert into Cidades (cidade, estado) values ('Capim Grosso', 'BA');
Insert into Cidades (cidade, estado) values ('Caraíbas', 'BA');
Insert into Cidades (cidade, estado) values ('Caravelas', 'BA');
Insert into Cidades (cidade, estado) values ('Cardeal da Silva', 'BA');
Insert into Cidades (cidade, estado) values ('Carinhanha', 'BA');
Insert into Cidades (cidade, estado) values ('Casa Nova', 'BA');
Insert into Cidades (cidade, estado) values ('Castro Alves', 'BA');
Insert into Cidades (cidade, estado) values ('Catolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Catu', 'BA');
Insert into Cidades (cidade, estado) values ('Caturama', 'BA');
Insert into Cidades (cidade, estado) values ('Central', 'BA');
Insert into Cidades (cidade, estado) values ('Chorrochó', 'BA');
Insert into Cidades (cidade, estado) values ('Cícero Dantas', 'BA');
Insert into Cidades (cidade, estado) values ('Cipó', 'BA');
Insert into Cidades (cidade, estado) values ('Coaraci', 'BA');
Insert into Cidades (cidade, estado) values ('Cocos', 'BA');
Insert into Cidades (cidade, estado) values ('Conceição da Feira', 'BA');
Insert into Cidades (cidade, estado) values ('Conceição do Almeida', 'BA');
Insert into Cidades (cidade, estado) values ('Conceição do Coité', 'BA');
Insert into Cidades (cidade, estado) values ('Conceição do Jacuípe', 'BA');
Insert into Cidades (cidade, estado) values ('Conde', 'BA');
Insert into Cidades (cidade, estado) values ('Condeúba', 'BA');
Insert into Cidades (cidade, estado) values ('Contendas do Sincorá', 'BA');
Insert into Cidades (cidade, estado) values ('Coração de Maria', 'BA');
Insert into Cidades (cidade, estado) values ('Cordeiros', 'BA');
Insert into Cidades (cidade, estado) values ('Coribe', 'BA');
Insert into Cidades (cidade, estado) values ('Coronel João Sá', 'BA');
Insert into Cidades (cidade, estado) values ('Correntina', 'BA');
Insert into Cidades (cidade, estado) values ('Cotegipe', 'BA');
Insert into Cidades (cidade, estado) values ('Cravolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Crisópolis', 'BA');
Insert into Cidades (cidade, estado) values ('Cristópolis', 'BA');
Insert into Cidades (cidade, estado) values ('Cruz das Almas', 'BA');
Insert into Cidades (cidade, estado) values ('Curaçá', 'BA');
Insert into Cidades (cidade, estado) values ('Dário Meira', 'BA');
Insert into Cidades (cidade, estado) values ('Dias D''Ávila', 'BA');
Insert into Cidades (cidade, estado) values ('Dom Basílio', 'BA');
Insert into Cidades (cidade, estado) values ('Dom Macedo Costa', 'BA');
Insert into Cidades (cidade, estado) values ('Elísio Medrado', 'BA');
Insert into Cidades (cidade, estado) values ('Encruzilhada', 'BA');
Insert into Cidades (cidade, estado) values ('Entre Rios', 'BA');
Insert into Cidades (cidade, estado) values ('Esplanada', 'BA');
Insert into Cidades (cidade, estado) values ('Euclides da Cunha', 'BA');
Insert into Cidades (cidade, estado) values ('Eunápolis', 'BA');
Insert into Cidades (cidade, estado) values ('Fátima', 'BA');
Insert into Cidades (cidade, estado) values ('Feira da Mata', 'BA');
Insert into Cidades (cidade, estado) values ('Feira de Santana', 'BA');
Insert into Cidades (cidade, estado) values ('Filadélfia', 'BA');
Insert into Cidades (cidade, estado) values ('Firmino Alves', 'BA');
Insert into Cidades (cidade, estado) values ('Floresta Azul', 'BA');
Insert into Cidades (cidade, estado) values ('Formosa do Rio Preto', 'BA');
Insert into Cidades (cidade, estado) values ('Gandu', 'BA');
Insert into Cidades (cidade, estado) values ('Gavião', 'BA');
Insert into Cidades (cidade, estado) values ('Gentio do Ouro', 'BA');
Insert into Cidades (cidade, estado) values ('Glória', 'BA');
Insert into Cidades (cidade, estado) values ('Gongogi', 'BA');
Insert into Cidades (cidade, estado) values ('Governador Mangabeira', 'BA');
Insert into Cidades (cidade, estado) values ('Guajeru', 'BA');
Insert into Cidades (cidade, estado) values ('Guanambi', 'BA');
Insert into Cidades (cidade, estado) values ('Guaratinga', 'BA');
Insert into Cidades (cidade, estado) values ('Heliópolis', 'BA');
Insert into Cidades (cidade, estado) values ('Iaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Ibiassucê', 'BA');
Insert into Cidades (cidade, estado) values ('Ibicaraí', 'BA');
Insert into Cidades (cidade, estado) values ('Ibicoara', 'BA');
Insert into Cidades (cidade, estado) values ('Ibicuí', 'BA');
Insert into Cidades (cidade, estado) values ('Ibipeba', 'BA');
Insert into Cidades (cidade, estado) values ('Ibipitanga', 'BA');
Insert into Cidades (cidade, estado) values ('Ibiquera', 'BA');
Insert into Cidades (cidade, estado) values ('Ibirapitanga', 'BA');
Insert into Cidades (cidade, estado) values ('Ibirapuã', 'BA');
Insert into Cidades (cidade, estado) values ('Ibirataia', 'BA');
Insert into Cidades (cidade, estado) values ('Ibitiara', 'BA');
Insert into Cidades (cidade, estado) values ('Ibititá', 'BA');
Insert into Cidades (cidade, estado) values ('Ibotirama', 'BA');
Insert into Cidades (cidade, estado) values ('Ichu', 'BA');
Insert into Cidades (cidade, estado) values ('Igaporã', 'BA');
Insert into Cidades (cidade, estado) values ('Igrapiúna', 'BA');
Insert into Cidades (cidade, estado) values ('Iguaí', 'BA');
Insert into Cidades (cidade, estado) values ('Ilhéus', 'BA');
Insert into Cidades (cidade, estado) values ('Inhambupe', 'BA');
Insert into Cidades (cidade, estado) values ('Ipecaetá', 'BA');
Insert into Cidades (cidade, estado) values ('Ipiaú', 'BA');
Insert into Cidades (cidade, estado) values ('Ipirá', 'BA');
Insert into Cidades (cidade, estado) values ('Ipupiara', 'BA');
Insert into Cidades (cidade, estado) values ('Irajuba', 'BA');
Insert into Cidades (cidade, estado) values ('Iramaia', 'BA');
Insert into Cidades (cidade, estado) values ('Iraquara', 'BA');
Insert into Cidades (cidade, estado) values ('Irará', 'BA');
Insert into Cidades (cidade, estado) values ('Irecê', 'BA');
Insert into Cidades (cidade, estado) values ('Itabela', 'BA');
Insert into Cidades (cidade, estado) values ('Itaberaba', 'BA');
Insert into Cidades (cidade, estado) values ('Itabuna', 'BA');
Insert into Cidades (cidade, estado) values ('Itacaré', 'BA');
Insert into Cidades (cidade, estado) values ('Itaeté', 'BA');
Insert into Cidades (cidade, estado) values ('Itagi', 'BA');
Insert into Cidades (cidade, estado) values ('Itagibá', 'BA');
Insert into Cidades (cidade, estado) values ('Itagimirim', 'BA');
Insert into Cidades (cidade, estado) values ('Itaguaçu da Bahia', 'BA');
Insert into Cidades (cidade, estado) values ('Itaju do Colônia', 'BA');
Insert into Cidades (cidade, estado) values ('Itajuípe', 'BA');
Insert into Cidades (cidade, estado) values ('Itamaraju', 'BA');
Insert into Cidades (cidade, estado) values ('Itamari', 'BA');
Insert into Cidades (cidade, estado) values ('Itambé', 'BA');
Insert into Cidades (cidade, estado) values ('Itanagra', 'BA');
Insert into Cidades (cidade, estado) values ('Itanhém', 'BA');
Insert into Cidades (cidade, estado) values ('Itaparica', 'BA');
Insert into Cidades (cidade, estado) values ('Itapé', 'BA');
Insert into Cidades (cidade, estado) values ('Itapebi', 'BA');
Insert into Cidades (cidade, estado) values ('Itapetinga', 'BA');
Insert into Cidades (cidade, estado) values ('Itapicuru', 'BA');
Insert into Cidades (cidade, estado) values ('Itapitanga', 'BA');
Insert into Cidades (cidade, estado) values ('Itaquara', 'BA');
Insert into Cidades (cidade, estado) values ('Itarantim', 'BA');
Insert into Cidades (cidade, estado) values ('Itatim', 'BA');
Insert into Cidades (cidade, estado) values ('Itiruçu', 'BA');
Insert into Cidades (cidade, estado) values ('Itiúba', 'BA');
Insert into Cidades (cidade, estado) values ('Itororó', 'BA');
Insert into Cidades (cidade, estado) values ('Ituaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Ituberá', 'BA');
Insert into Cidades (cidade, estado) values ('Iuiú', 'BA');
Insert into Cidades (cidade, estado) values ('Jaborandi', 'BA');
Insert into Cidades (cidade, estado) values ('Jacaraci', 'BA');
Insert into Cidades (cidade, estado) values ('Jacobina', 'BA');
Insert into Cidades (cidade, estado) values ('Jaguaquara', 'BA');
Insert into Cidades (cidade, estado) values ('Jaguarari', 'BA');
Insert into Cidades (cidade, estado) values ('Jaguaripe', 'BA');
Insert into Cidades (cidade, estado) values ('Jandaíra', 'BA');
Insert into Cidades (cidade, estado) values ('Jequié', 'BA');
Insert into Cidades (cidade, estado) values ('Jeremoabo', 'BA');
Insert into Cidades (cidade, estado) values ('Jiquiriçá', 'BA');
Insert into Cidades (cidade, estado) values ('Jitaúna', 'BA');
Insert into Cidades (cidade, estado) values ('João Dourado', 'BA');
Insert into Cidades (cidade, estado) values ('Juazeiro', 'BA');
Insert into Cidades (cidade, estado) values ('Jucuruçu', 'BA');
Insert into Cidades (cidade, estado) values ('Jussara', 'BA');
Insert into Cidades (cidade, estado) values ('Jussari', 'BA');
Insert into Cidades (cidade, estado) values ('Jussiape', 'BA');
Insert into Cidades (cidade, estado) values ('Lafaiete Coutinho', 'BA');
Insert into Cidades (cidade, estado) values ('Lagoa Real', 'BA');
Insert into Cidades (cidade, estado) values ('Laje', 'BA');
Insert into Cidades (cidade, estado) values ('Lajedão', 'BA');
Insert into Cidades (cidade, estado) values ('Lajedinho', 'BA');
Insert into Cidades (cidade, estado) values ('Lajedo do Tabocal', 'BA');
Insert into Cidades (cidade, estado) values ('Lamarão', 'BA');
Insert into Cidades (cidade, estado) values ('Lapão', 'BA');
Insert into Cidades (cidade, estado) values ('Lauro de Freitas', 'BA');
Insert into Cidades (cidade, estado) values ('Lençóis', 'BA');
Insert into Cidades (cidade, estado) values ('Licínio de Almeida', 'BA');
Insert into Cidades (cidade, estado) values ('Livramento de Nossa Senhora', 'BA');
Insert into Cidades (cidade, estado) values ('Luís Eduardo Magalhães', 'BA');
Insert into Cidades (cidade, estado) values ('Macajuba', 'BA');
Insert into Cidades (cidade, estado) values ('Macarani', 'BA');
Insert into Cidades (cidade, estado) values ('Macaúbas', 'BA');
Insert into Cidades (cidade, estado) values ('Macururé', 'BA');
Insert into Cidades (cidade, estado) values ('Madre de Deus', 'BA');
Insert into Cidades (cidade, estado) values ('Maetinga', 'BA');
Insert into Cidades (cidade, estado) values ('Maiquinique', 'BA');
Insert into Cidades (cidade, estado) values ('Mairi', 'BA');
Insert into Cidades (cidade, estado) values ('Malhada', 'BA');
Insert into Cidades (cidade, estado) values ('Malhada de Pedras', 'BA');
Insert into Cidades (cidade, estado) values ('Manoel Vitorino', 'BA');
Insert into Cidades (cidade, estado) values ('Mansidão', 'BA');
Insert into Cidades (cidade, estado) values ('Maracás', 'BA');
Insert into Cidades (cidade, estado) values ('Maragogipe', 'BA');
Insert into Cidades (cidade, estado) values ('Maraú', 'BA');
Insert into Cidades (cidade, estado) values ('Marcionílio Souza', 'BA');
Insert into Cidades (cidade, estado) values ('Mascote', 'BA');
Insert into Cidades (cidade, estado) values ('Mata de São João', 'BA');
Insert into Cidades (cidade, estado) values ('Matina', 'BA');
Insert into Cidades (cidade, estado) values ('Medeiros Neto', 'BA');
Insert into Cidades (cidade, estado) values ('Miguel Calmon', 'BA');
Insert into Cidades (cidade, estado) values ('Milagres', 'BA');
Insert into Cidades (cidade, estado) values ('Mirangaba', 'BA');
Insert into Cidades (cidade, estado) values ('Mirante', 'BA');
Insert into Cidades (cidade, estado) values ('Monte Santo', 'BA');
Insert into Cidades (cidade, estado) values ('Morpará', 'BA');
Insert into Cidades (cidade, estado) values ('Morro do Chapéu', 'BA');
Insert into Cidades (cidade, estado) values ('Mortugaba', 'BA');
Insert into Cidades (cidade, estado) values ('Mucugê', 'BA');
Insert into Cidades (cidade, estado) values ('Mucuri', 'BA');
Insert into Cidades (cidade, estado) values ('Mulungu do Morro', 'BA');
Insert into Cidades (cidade, estado) values ('Mundo Novo', 'BA');
Insert into Cidades (cidade, estado) values ('Muniz Ferreira', 'BA');
Insert into Cidades (cidade, estado) values ('Muquém de São Francisco', 'BA');
Insert into Cidades (cidade, estado) values ('Muritiba', 'BA');
Insert into Cidades (cidade, estado) values ('Mutuípe', 'BA');
Insert into Cidades (cidade, estado) values ('Nazaré', 'BA');
Insert into Cidades (cidade, estado) values ('Nilo Peçanha', 'BA');
Insert into Cidades (cidade, estado) values ('Nordestina', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Canaã', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Fátima', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Ibiá', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Itarana', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Redenção', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Soure', 'BA');
Insert into Cidades (cidade, estado) values ('Nova Viçosa', 'BA');
Insert into Cidades (cidade, estado) values ('Novo Horizonte', 'BA');
Insert into Cidades (cidade, estado) values ('Novo Triunfo', 'BA');
Insert into Cidades (cidade, estado) values ('Olindina', 'BA');
Insert into Cidades (cidade, estado) values ('Oliveira dos Brejinhos', 'BA');
Insert into Cidades (cidade, estado) values ('Ouriçangas', 'BA');
Insert into Cidades (cidade, estado) values ('Ourolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Palmas de Monte Alto', 'BA');
Insert into Cidades (cidade, estado) values ('Palmeiras', 'BA');
Insert into Cidades (cidade, estado) values ('Paramirim', 'BA');
Insert into Cidades (cidade, estado) values ('Paratinga', 'BA');
Insert into Cidades (cidade, estado) values ('Paripiranga', 'BA');
Insert into Cidades (cidade, estado) values ('Pau Brasil', 'BA');
Insert into Cidades (cidade, estado) values ('Paulo Afonso', 'BA');
Insert into Cidades (cidade, estado) values ('Pé de Serra', 'BA');
Insert into Cidades (cidade, estado) values ('Pedrão', 'BA');
Insert into Cidades (cidade, estado) values ('Pedro Alexandre', 'BA');
Insert into Cidades (cidade, estado) values ('Piatã', 'BA');
Insert into Cidades (cidade, estado) values ('Pilão Arcado', 'BA');
Insert into Cidades (cidade, estado) values ('Pindaí', 'BA');
Insert into Cidades (cidade, estado) values ('Pindobaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Pintadas', 'BA');
Insert into Cidades (cidade, estado) values ('Piraí do Norte', 'BA');
Insert into Cidades (cidade, estado) values ('Piripá', 'BA');
Insert into Cidades (cidade, estado) values ('Piritiba', 'BA');
Insert into Cidades (cidade, estado) values ('Planaltino', 'BA');
Insert into Cidades (cidade, estado) values ('Planalto', 'BA');
Insert into Cidades (cidade, estado) values ('Poções', 'BA');
Insert into Cidades (cidade, estado) values ('Pojuca', 'BA');
Insert into Cidades (cidade, estado) values ('Ponto Novo', 'BA');
Insert into Cidades (cidade, estado) values ('Porto Seguro', 'BA');
Insert into Cidades (cidade, estado) values ('Potiraguá', 'BA');
Insert into Cidades (cidade, estado) values ('Prado', 'BA');
Insert into Cidades (cidade, estado) values ('Presidente Dutra', 'BA');
Insert into Cidades (cidade, estado) values ('Presidente Jânio Quadros', 'BA');
Insert into Cidades (cidade, estado) values ('Presidente Tancredo Neves', 'BA');
Insert into Cidades (cidade, estado) values ('Queimadas', 'BA');
Insert into Cidades (cidade, estado) values ('Quijingue', 'BA');
Insert into Cidades (cidade, estado) values ('Quixabeira', 'BA');
Insert into Cidades (cidade, estado) values ('Rafael Jambeiro', 'BA');
Insert into Cidades (cidade, estado) values ('Remanso', 'BA');
Insert into Cidades (cidade, estado) values ('Retirolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Riachão das Neves', 'BA');
Insert into Cidades (cidade, estado) values ('Riachão do Jacuípe', 'BA');
Insert into Cidades (cidade, estado) values ('Riacho de Santana', 'BA');
Insert into Cidades (cidade, estado) values ('Ribeira do Amparo', 'BA');
Insert into Cidades (cidade, estado) values ('Ribeira do Pombal', 'BA');
Insert into Cidades (cidade, estado) values ('Ribeirão do Largo', 'BA');
Insert into Cidades (cidade, estado) values ('Rio de Contas', 'BA');
Insert into Cidades (cidade, estado) values ('Rio do Antônio', 'BA');
Insert into Cidades (cidade, estado) values ('Rio do Pires', 'BA');
Insert into Cidades (cidade, estado) values ('Rio Real', 'BA');
Insert into Cidades (cidade, estado) values ('Rodelas', 'BA');
Insert into Cidades (cidade, estado) values ('Ruy Barbosa', 'BA');
Insert into Cidades (cidade, estado) values ('Salinas da Margarida', 'BA');
Insert into Cidades (cidade, estado) values ('Salvador', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Bárbara', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Brígida', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Cruz Cabrália', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Cruz da Vitória', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Inês', 'BA');
Insert into Cidades (cidade, estado) values ('Santaluz', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Luzia', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Maria da Vitória', 'BA');
Insert into Cidades (cidade, estado) values ('Santana', 'BA');
Insert into Cidades (cidade, estado) values ('Santanópolis', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Rita de Cássia', 'BA');
Insert into Cidades (cidade, estado) values ('Santa Teresinha', 'BA');
Insert into Cidades (cidade, estado) values ('Santo Amaro', 'BA');
Insert into Cidades (cidade, estado) values ('Santo Antônio de Jesus', 'BA');
Insert into Cidades (cidade, estado) values ('Santo Estêvão', 'BA');
Insert into Cidades (cidade, estado) values ('São Desidério', 'BA');
Insert into Cidades (cidade, estado) values ('São Domingos', 'BA');
Insert into Cidades (cidade, estado) values ('São Félix', 'BA');
Insert into Cidades (cidade, estado) values ('São Félix do Coribe', 'BA');
Insert into Cidades (cidade, estado) values ('São Felipe', 'BA');
Insert into Cidades (cidade, estado) values ('São Francisco do Conde', 'BA');
Insert into Cidades (cidade, estado) values ('São Gabriel', 'BA');
Insert into Cidades (cidade, estado) values ('São Gonçalo dos Campos', 'BA');
Insert into Cidades (cidade, estado) values ('São José da Vitória', 'BA');
Insert into Cidades (cidade, estado) values ('São José do Jacuípe', 'BA');
Insert into Cidades (cidade, estado) values ('São Miguel das Matas', 'BA');
Insert into Cidades (cidade, estado) values ('São Sebastião do Passé', 'BA');
Insert into Cidades (cidade, estado) values ('Sapeaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Sátiro Dias', 'BA');
Insert into Cidades (cidade, estado) values ('Saubara', 'BA');
Insert into Cidades (cidade, estado) values ('Saúde', 'BA');
Insert into Cidades (cidade, estado) values ('Seabra', 'BA');
Insert into Cidades (cidade, estado) values ('Sebastião Laranjeiras', 'BA');
Insert into Cidades (cidade, estado) values ('Senhor do Bonfim', 'BA');
Insert into Cidades (cidade, estado) values ('Serra do Ramalho', 'BA');
Insert into Cidades (cidade, estado) values ('Sento Sé', 'BA');
Insert into Cidades (cidade, estado) values ('Serra Dourada', 'BA');
Insert into Cidades (cidade, estado) values ('Serra Preta', 'BA');
Insert into Cidades (cidade, estado) values ('Serrinha', 'BA');
Insert into Cidades (cidade, estado) values ('Serrolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Simões Filho', 'BA');
Insert into Cidades (cidade, estado) values ('Sítio do Mato', 'BA');
Insert into Cidades (cidade, estado) values ('Sítio do Quinto', 'BA');
Insert into Cidades (cidade, estado) values ('Sobradinho', 'BA');
Insert into Cidades (cidade, estado) values ('Souto Soares', 'BA');
Insert into Cidades (cidade, estado) values ('Tabocas do Brejo Velho', 'BA');
Insert into Cidades (cidade, estado) values ('Tanhaçu', 'BA');
Insert into Cidades (cidade, estado) values ('Tanque Novo', 'BA');
Insert into Cidades (cidade, estado) values ('Tanquinho', 'BA');
Insert into Cidades (cidade, estado) values ('Taperoá', 'BA');
Insert into Cidades (cidade, estado) values ('Tapiramutá', 'BA');
Insert into Cidades (cidade, estado) values ('Teixeira de Freitas', 'BA');
Insert into Cidades (cidade, estado) values ('Teodoro Sampaio', 'BA');
Insert into Cidades (cidade, estado) values ('Teofilândia', 'BA');
Insert into Cidades (cidade, estado) values ('Teolândia', 'BA');
Insert into Cidades (cidade, estado) values ('Terra Nova', 'BA');
Insert into Cidades (cidade, estado) values ('Tremedal', 'BA');
Insert into Cidades (cidade, estado) values ('Tucano', 'BA');
Insert into Cidades (cidade, estado) values ('Uauá', 'BA');
Insert into Cidades (cidade, estado) values ('Ubaíra', 'BA');
Insert into Cidades (cidade, estado) values ('Ubaitaba', 'BA');
Insert into Cidades (cidade, estado) values ('Ubatã', 'BA');
Insert into Cidades (cidade, estado) values ('Uibaí', 'BA');
Insert into Cidades (cidade, estado) values ('Umburanas', 'BA');
Insert into Cidades (cidade, estado) values ('Una', 'BA');
Insert into Cidades (cidade, estado) values ('Urandi', 'BA');
Insert into Cidades (cidade, estado) values ('Uruçuca', 'BA');
Insert into Cidades (cidade, estado) values ('Utinga', 'BA');
Insert into Cidades (cidade, estado) values ('Valença', 'BA');
Insert into Cidades (cidade, estado) values ('Valente', 'BA');
Insert into Cidades (cidade, estado) values ('Várzea da Roça', 'BA');
Insert into Cidades (cidade, estado) values ('Várzea do Poço', 'BA');
Insert into Cidades (cidade, estado) values ('Várzea Nova', 'BA');
Insert into Cidades (cidade, estado) values ('Varzedo', 'BA');
Insert into Cidades (cidade, estado) values ('Vera Cruz', 'BA');
Insert into Cidades (cidade, estado) values ('Vereda', 'BA');
Insert into Cidades (cidade, estado) values ('Vitória da Conquista', 'BA');
Insert into Cidades (cidade, estado) values ('Wagner', 'BA');
Insert into Cidades (cidade, estado) values ('Wanderley', 'BA');
Insert into Cidades (cidade, estado) values ('Wenceslau Guimarães', 'BA');
Insert into Cidades (cidade, estado) values ('Xique-Xique', 'BA');
Insert into Cidades (cidade, estado) values ('Abadia dos Dourados', 'MG');
Insert into Cidades (cidade, estado) values ('Abaeté', 'MG');
Insert into Cidades (cidade, estado) values ('Abre Campo', 'MG');
Insert into Cidades (cidade, estado) values ('Acaiaca', 'MG');
Insert into Cidades (cidade, estado) values ('Açucena', 'MG');
Insert into Cidades (cidade, estado) values ('Água Boa', 'MG');
Insert into Cidades (cidade, estado) values ('Água Comprida', 'MG');
Insert into Cidades (cidade, estado) values ('Aguanil', 'MG');
Insert into Cidades (cidade, estado) values ('Águas Formosas', 'MG');
Insert into Cidades (cidade, estado) values ('Águas Vermelhas', 'MG');
Insert into Cidades (cidade, estado) values ('Aimorés', 'MG');
Insert into Cidades (cidade, estado) values ('Aiuruoca', 'MG');
Insert into Cidades (cidade, estado) values ('Alagoa', 'MG');
Insert into Cidades (cidade, estado) values ('Albertina', 'MG');
Insert into Cidades (cidade, estado) values ('Além Paraíba', 'MG');
Insert into Cidades (cidade, estado) values ('Alfenas', 'MG');
Insert into Cidades (cidade, estado) values ('Alfredo Vasconcelos', 'MG');
Insert into Cidades (cidade, estado) values ('Almenara', 'MG');
Insert into Cidades (cidade, estado) values ('Alpercata', 'MG');
Insert into Cidades (cidade, estado) values ('Alpinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Alterosa', 'MG');
Insert into Cidades (cidade, estado) values ('Alto Caparaó', 'MG');
Insert into Cidades (cidade, estado) values ('Alto Rio Doce', 'MG');
Insert into Cidades (cidade, estado) values ('Alvarenga', 'MG');
Insert into Cidades (cidade, estado) values ('Alvinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Alvorada de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Amparo do Serra', 'MG');
Insert into Cidades (cidade, estado) values ('Andradas', 'MG');
Insert into Cidades (cidade, estado) values ('Cachoeira de Pajeú', 'MG');
Insert into Cidades (cidade, estado) values ('Andrelândia', 'MG');
Insert into Cidades (cidade, estado) values ('Angelândia', 'MG');
Insert into Cidades (cidade, estado) values ('Antônio Carlos', 'MG');
Insert into Cidades (cidade, estado) values ('Antônio Dias', 'MG');
Insert into Cidades (cidade, estado) values ('Antônio Prado de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Araçaí', 'MG');
Insert into Cidades (cidade, estado) values ('Aracitaba', 'MG');
Insert into Cidades (cidade, estado) values ('Araçuaí', 'MG');
Insert into Cidades (cidade, estado) values ('Araguari', 'MG');
Insert into Cidades (cidade, estado) values ('Arantina', 'MG');
Insert into Cidades (cidade, estado) values ('Araponga', 'MG');
Insert into Cidades (cidade, estado) values ('Araporã', 'MG');
Insert into Cidades (cidade, estado) values ('Arapuá', 'MG');
Insert into Cidades (cidade, estado) values ('Araújos', 'MG');
Insert into Cidades (cidade, estado) values ('Araxá', 'MG');
Insert into Cidades (cidade, estado) values ('Arceburgo', 'MG');
Insert into Cidades (cidade, estado) values ('Arcos', 'MG');
Insert into Cidades (cidade, estado) values ('Areado', 'MG');
Insert into Cidades (cidade, estado) values ('Argirita', 'MG');
Insert into Cidades (cidade, estado) values ('Aricanduva', 'MG');
Insert into Cidades (cidade, estado) values ('Arinos', 'MG');
Insert into Cidades (cidade, estado) values ('Astolfo Dutra', 'MG');
Insert into Cidades (cidade, estado) values ('Ataléia', 'MG');
Insert into Cidades (cidade, estado) values ('Augusto de Lima', 'MG');
Insert into Cidades (cidade, estado) values ('Baependi', 'MG');
Insert into Cidades (cidade, estado) values ('Baldim', 'MG');
Insert into Cidades (cidade, estado) values ('Bambuí', 'MG');
Insert into Cidades (cidade, estado) values ('Bandeira', 'MG');
Insert into Cidades (cidade, estado) values ('Bandeira do Sul', 'MG');
Insert into Cidades (cidade, estado) values ('Barão de Cocais', 'MG');
Insert into Cidades (cidade, estado) values ('Barão de Monte Alto', 'MG');
Insert into Cidades (cidade, estado) values ('Barbacena', 'MG');
Insert into Cidades (cidade, estado) values ('Barra Longa', 'MG');
Insert into Cidades (cidade, estado) values ('Barroso', 'MG');
Insert into Cidades (cidade, estado) values ('Bela Vista de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Belmiro Braga', 'MG');
Insert into Cidades (cidade, estado) values ('Belo Horizonte', 'MG');
Insert into Cidades (cidade, estado) values ('Belo Oriente', 'MG');
Insert into Cidades (cidade, estado) values ('Belo Vale', 'MG');
Insert into Cidades (cidade, estado) values ('Berilo', 'MG');
Insert into Cidades (cidade, estado) values ('Bertópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Berizal', 'MG');
Insert into Cidades (cidade, estado) values ('Betim', 'MG');
Insert into Cidades (cidade, estado) values ('Bias Fortes', 'MG');
Insert into Cidades (cidade, estado) values ('Bicas', 'MG');
Insert into Cidades (cidade, estado) values ('Biquinhas', 'MG');
Insert into Cidades (cidade, estado) values ('Boa Esperança', 'MG');
Insert into Cidades (cidade, estado) values ('Bocaina de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Bocaiúva', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Despacho', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Jardim de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Jesus da Penha', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Amparo', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Galho', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Repouso', 'MG');
Insert into Cidades (cidade, estado) values ('Bom Sucesso', 'MG');
Insert into Cidades (cidade, estado) values ('Bonfim', 'MG');
Insert into Cidades (cidade, estado) values ('Bonfinópolis de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Bonito de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Borda da Mata', 'MG');
Insert into Cidades (cidade, estado) values ('Botelhos', 'MG');
Insert into Cidades (cidade, estado) values ('Botumirim', 'MG');
Insert into Cidades (cidade, estado) values ('Brasilândia de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Brasília de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Brás Pires', 'MG');
Insert into Cidades (cidade, estado) values ('Braúnas', 'MG');
Insert into Cidades (cidade, estado) values ('Brazópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Brumadinho', 'MG');
Insert into Cidades (cidade, estado) values ('Bueno Brandão', 'MG');
Insert into Cidades (cidade, estado) values ('Buenópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Bugre', 'MG');
Insert into Cidades (cidade, estado) values ('Buritis', 'MG');
Insert into Cidades (cidade, estado) values ('Buritizeiro', 'MG');
Insert into Cidades (cidade, estado) values ('Cabeceira Grande', 'MG');
Insert into Cidades (cidade, estado) values ('Cabo Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Cachoeira da Prata', 'MG');
Insert into Cidades (cidade, estado) values ('Cachoeira de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Cachoeira Dourada', 'MG');
Insert into Cidades (cidade, estado) values ('Caetanópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Caeté', 'MG');
Insert into Cidades (cidade, estado) values ('Caiana', 'MG');
Insert into Cidades (cidade, estado) values ('Cajuri', 'MG');
Insert into Cidades (cidade, estado) values ('Caldas', 'MG');
Insert into Cidades (cidade, estado) values ('Camacho', 'MG');
Insert into Cidades (cidade, estado) values ('Camanducaia', 'MG');
Insert into Cidades (cidade, estado) values ('Cambuí', 'MG');
Insert into Cidades (cidade, estado) values ('Cambuquira', 'MG');
Insert into Cidades (cidade, estado) values ('Campanário', 'MG');
Insert into Cidades (cidade, estado) values ('Campanha', 'MG');
Insert into Cidades (cidade, estado) values ('Campestre', 'MG');
Insert into Cidades (cidade, estado) values ('Campina Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Campo Azul', 'MG');
Insert into Cidades (cidade, estado) values ('Campo Belo', 'MG');
Insert into Cidades (cidade, estado) values ('Campo do Meio', 'MG');
Insert into Cidades (cidade, estado) values ('Campo Florido', 'MG');
Insert into Cidades (cidade, estado) values ('Campos Altos', 'MG');
Insert into Cidades (cidade, estado) values ('Campos Gerais', 'MG');
Insert into Cidades (cidade, estado) values ('Canaã', 'MG');
Insert into Cidades (cidade, estado) values ('Canápolis', 'MG');
Insert into Cidades (cidade, estado) values ('Cana Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Candeias', 'MG');
Insert into Cidades (cidade, estado) values ('Cantagalo', 'MG');
Insert into Cidades (cidade, estado) values ('Caparaó', 'MG');
Insert into Cidades (cidade, estado) values ('Capela Nova', 'MG');
Insert into Cidades (cidade, estado) values ('Capelinha', 'MG');
Insert into Cidades (cidade, estado) values ('Capetinga', 'MG');
Insert into Cidades (cidade, estado) values ('Capim Branco', 'MG');
Insert into Cidades (cidade, estado) values ('Capinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Capitão Andrade', 'MG');
Insert into Cidades (cidade, estado) values ('Capitão Enéas', 'MG');
Insert into Cidades (cidade, estado) values ('Capitólio', 'MG');
Insert into Cidades (cidade, estado) values ('Caputira', 'MG');
Insert into Cidades (cidade, estado) values ('Caraí', 'MG');
Insert into Cidades (cidade, estado) values ('Caranaíba', 'MG');
Insert into Cidades (cidade, estado) values ('Carandaí', 'MG');
Insert into Cidades (cidade, estado) values ('Carangola', 'MG');
Insert into Cidades (cidade, estado) values ('Caratinga', 'MG');
Insert into Cidades (cidade, estado) values ('Carbonita', 'MG');
Insert into Cidades (cidade, estado) values ('Careaçu', 'MG');
Insert into Cidades (cidade, estado) values ('Carlos Chagas', 'MG');
Insert into Cidades (cidade, estado) values ('Carmésia', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo da Cachoeira', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo da Mata', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo do Cajuru', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo do Paranaíba', 'MG');
Insert into Cidades (cidade, estado) values ('Carmo do Rio Claro', 'MG');
Insert into Cidades (cidade, estado) values ('Carmópolis de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Carneirinho', 'MG');
Insert into Cidades (cidade, estado) values ('Carrancas', 'MG');
Insert into Cidades (cidade, estado) values ('Carvalhópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Carvalhos', 'MG');
Insert into Cidades (cidade, estado) values ('Casa Grande', 'MG');
Insert into Cidades (cidade, estado) values ('Cascalho Rico', 'MG');
Insert into Cidades (cidade, estado) values ('Cássia', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição da Barra de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Cataguases', 'MG');
Insert into Cidades (cidade, estado) values ('Catas Altas', 'MG');
Insert into Cidades (cidade, estado) values ('Catas Altas da Noruega', 'MG');
Insert into Cidades (cidade, estado) values ('Catuji', 'MG');
Insert into Cidades (cidade, estado) values ('Catuti', 'MG');
Insert into Cidades (cidade, estado) values ('Caxambu', 'MG');
Insert into Cidades (cidade, estado) values ('Cedro do Abaeté', 'MG');
Insert into Cidades (cidade, estado) values ('Central de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Centralina', 'MG');
Insert into Cidades (cidade, estado) values ('Chácara', 'MG');
Insert into Cidades (cidade, estado) values ('Chalé', 'MG');
Insert into Cidades (cidade, estado) values ('Chapada do Norte', 'MG');
Insert into Cidades (cidade, estado) values ('Chapada Gaúcha', 'MG');
Insert into Cidades (cidade, estado) values ('Chiador', 'MG');
Insert into Cidades (cidade, estado) values ('Cipotânea', 'MG');
Insert into Cidades (cidade, estado) values ('Claraval', 'MG');
Insert into Cidades (cidade, estado) values ('Claro dos Poções', 'MG');
Insert into Cidades (cidade, estado) values ('Cláudio', 'MG');
Insert into Cidades (cidade, estado) values ('Coimbra', 'MG');
Insert into Cidades (cidade, estado) values ('Coluna', 'MG');
Insert into Cidades (cidade, estado) values ('Comendador Gomes', 'MG');
Insert into Cidades (cidade, estado) values ('Comercinho', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição da Aparecida', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição das Pedras', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição das Alagoas', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição de Ipanema', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição do Mato Dentro', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição do Pará', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição do Rio Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Conceição dos Ouros', 'MG');
Insert into Cidades (cidade, estado) values ('Cônego Marinho', 'MG');
Insert into Cidades (cidade, estado) values ('Confins', 'MG');
Insert into Cidades (cidade, estado) values ('Congonhal', 'MG');
Insert into Cidades (cidade, estado) values ('Congonhas', 'MG');
Insert into Cidades (cidade, estado) values ('Congonhas do Norte', 'MG');
Insert into Cidades (cidade, estado) values ('Conquista', 'MG');
Insert into Cidades (cidade, estado) values ('Conselheiro Lafaiete', 'MG');
Insert into Cidades (cidade, estado) values ('Conselheiro Pena', 'MG');
Insert into Cidades (cidade, estado) values ('Consolação', 'MG');
Insert into Cidades (cidade, estado) values ('Contagem', 'MG');
Insert into Cidades (cidade, estado) values ('Coqueiral', 'MG');
Insert into Cidades (cidade, estado) values ('Coração de Jesus', 'MG');
Insert into Cidades (cidade, estado) values ('Cordisburgo', 'MG');
Insert into Cidades (cidade, estado) values ('Cordislândia', 'MG');
Insert into Cidades (cidade, estado) values ('Corinto', 'MG');
Insert into Cidades (cidade, estado) values ('Coroaci', 'MG');
Insert into Cidades (cidade, estado) values ('Coromandel', 'MG');
Insert into Cidades (cidade, estado) values ('Coronel Fabriciano', 'MG');
Insert into Cidades (cidade, estado) values ('Coronel Murta', 'MG');
Insert into Cidades (cidade, estado) values ('Coronel Pacheco', 'MG');
Insert into Cidades (cidade, estado) values ('Coronel Xavier Chaves', 'MG');
Insert into Cidades (cidade, estado) values ('Córrego Danta', 'MG');
Insert into Cidades (cidade, estado) values ('Córrego do Bom Jesus', 'MG');
Insert into Cidades (cidade, estado) values ('Córrego Fundo', 'MG');
Insert into Cidades (cidade, estado) values ('Córrego Novo', 'MG');
Insert into Cidades (cidade, estado) values ('Couto de Magalhães de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Crisólita', 'MG');
Insert into Cidades (cidade, estado) values ('Cristais', 'MG');
Insert into Cidades (cidade, estado) values ('Cristália', 'MG');
Insert into Cidades (cidade, estado) values ('Cristiano Otoni', 'MG');
Insert into Cidades (cidade, estado) values ('Cristina', 'MG');
Insert into Cidades (cidade, estado) values ('Crucilândia', 'MG');
Insert into Cidades (cidade, estado) values ('Cruzeiro da Fortaleza', 'MG');
Insert into Cidades (cidade, estado) values ('Cruzília', 'MG');
Insert into Cidades (cidade, estado) values ('Cuparaque', 'MG');
Insert into Cidades (cidade, estado) values ('Curral de Dentro', 'MG');
Insert into Cidades (cidade, estado) values ('Curvelo', 'MG');
Insert into Cidades (cidade, estado) values ('Datas', 'MG');
Insert into Cidades (cidade, estado) values ('Delfim Moreira', 'MG');
Insert into Cidades (cidade, estado) values ('Delfinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Delta', 'MG');
Insert into Cidades (cidade, estado) values ('Descoberto', 'MG');
Insert into Cidades (cidade, estado) values ('Desterro de Entre Rios', 'MG');
Insert into Cidades (cidade, estado) values ('Desterro do Melo', 'MG');
Insert into Cidades (cidade, estado) values ('Diamantina', 'MG');
Insert into Cidades (cidade, estado) values ('Diogo de Vasconcelos', 'MG');
Insert into Cidades (cidade, estado) values ('Dionísio', 'MG');
Insert into Cidades (cidade, estado) values ('Divinésia', 'MG');
Insert into Cidades (cidade, estado) values ('Divino', 'MG');
Insert into Cidades (cidade, estado) values ('Divino das Laranjeiras', 'MG');
Insert into Cidades (cidade, estado) values ('Divinolândia de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Divinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Divisa Alegre', 'MG');
Insert into Cidades (cidade, estado) values ('Divisa Nova', 'MG');
Insert into Cidades (cidade, estado) values ('Divisópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Dom Bosco', 'MG');
Insert into Cidades (cidade, estado) values ('Dom Cavati', 'MG');
Insert into Cidades (cidade, estado) values ('Dom Joaquim', 'MG');
Insert into Cidades (cidade, estado) values ('Dom Silvério', 'MG');
Insert into Cidades (cidade, estado) values ('Dom Viçoso', 'MG');
Insert into Cidades (cidade, estado) values ('Dona Eusébia', 'MG');
Insert into Cidades (cidade, estado) values ('Dores de Campos', 'MG');
Insert into Cidades (cidade, estado) values ('Dores de Guanhães', 'MG');
Insert into Cidades (cidade, estado) values ('Dores do Indaiá', 'MG');
Insert into Cidades (cidade, estado) values ('Dores do Turvo', 'MG');
Insert into Cidades (cidade, estado) values ('Doresópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Douradoquara', 'MG');
Insert into Cidades (cidade, estado) values ('Durandé', 'MG');
Insert into Cidades (cidade, estado) values ('Elói Mendes', 'MG');
Insert into Cidades (cidade, estado) values ('Engenheiro Caldas', 'MG');
Insert into Cidades (cidade, estado) values ('Engenheiro Navarro', 'MG');
Insert into Cidades (cidade, estado) values ('Entre Folhas', 'MG');
Insert into Cidades (cidade, estado) values ('Entre Rios de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Ervália', 'MG');
Insert into Cidades (cidade, estado) values ('Esmeraldas', 'MG');
Insert into Cidades (cidade, estado) values ('Espera Feliz', 'MG');
Insert into Cidades (cidade, estado) values ('Espinosa', 'MG');
Insert into Cidades (cidade, estado) values ('Espírito Santo do Dourado', 'MG');
Insert into Cidades (cidade, estado) values ('Estiva', 'MG');
Insert into Cidades (cidade, estado) values ('Estrela Dalva', 'MG');
Insert into Cidades (cidade, estado) values ('Estrela do Indaiá', 'MG');
Insert into Cidades (cidade, estado) values ('Estrela do Sul', 'MG');
Insert into Cidades (cidade, estado) values ('Eugenópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Ewbank da Câmara', 'MG');
Insert into Cidades (cidade, estado) values ('Extrema', 'MG');
Insert into Cidades (cidade, estado) values ('Fama', 'MG');
Insert into Cidades (cidade, estado) values ('Faria Lemos', 'MG');
Insert into Cidades (cidade, estado) values ('Felício dos Santos', 'MG');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Rio Preto', 'MG');
Insert into Cidades (cidade, estado) values ('Felisburgo', 'MG');
Insert into Cidades (cidade, estado) values ('Felixlândia', 'MG');
Insert into Cidades (cidade, estado) values ('Fernandes Tourinho', 'MG');
Insert into Cidades (cidade, estado) values ('Ferros', 'MG');
Insert into Cidades (cidade, estado) values ('Fervedouro', 'MG');
Insert into Cidades (cidade, estado) values ('Florestal', 'MG');
Insert into Cidades (cidade, estado) values ('Formiga', 'MG');
Insert into Cidades (cidade, estado) values ('Formoso', 'MG');
Insert into Cidades (cidade, estado) values ('Fortaleza de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Fortuna de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Francisco Badaró', 'MG');
Insert into Cidades (cidade, estado) values ('Francisco Dumont', 'MG');
Insert into Cidades (cidade, estado) values ('Francisco Sá', 'MG');
Insert into Cidades (cidade, estado) values ('Franciscópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Frei Gaspar', 'MG');
Insert into Cidades (cidade, estado) values ('Frei Inocêncio', 'MG');
Insert into Cidades (cidade, estado) values ('Frei Lagonegro', 'MG');
Insert into Cidades (cidade, estado) values ('Fronteira', 'MG');
Insert into Cidades (cidade, estado) values ('Fronteira dos Vales', 'MG');
Insert into Cidades (cidade, estado) values ('Fruta de Leite', 'MG');
Insert into Cidades (cidade, estado) values ('Frutal', 'MG');
Insert into Cidades (cidade, estado) values ('Funilândia', 'MG');
Insert into Cidades (cidade, estado) values ('Galiléia', 'MG');
Insert into Cidades (cidade, estado) values ('Gameleiras', 'MG');
Insert into Cidades (cidade, estado) values ('Glaucilândia', 'MG');
Insert into Cidades (cidade, estado) values ('Goiabeira', 'MG');
Insert into Cidades (cidade, estado) values ('Goianá', 'MG');
Insert into Cidades (cidade, estado) values ('Gonçalves', 'MG');
Insert into Cidades (cidade, estado) values ('Gonzaga', 'MG');
Insert into Cidades (cidade, estado) values ('Gouveia', 'MG');
Insert into Cidades (cidade, estado) values ('Governador Valadares', 'MG');
Insert into Cidades (cidade, estado) values ('Grão Mogol', 'MG');
Insert into Cidades (cidade, estado) values ('Grupiara', 'MG');
Insert into Cidades (cidade, estado) values ('Guanhães', 'MG');
Insert into Cidades (cidade, estado) values ('Guapé', 'MG');
Insert into Cidades (cidade, estado) values ('Guaraciaba', 'MG');
Insert into Cidades (cidade, estado) values ('Guaraciama', 'MG');
Insert into Cidades (cidade, estado) values ('Guaranésia', 'MG');
Insert into Cidades (cidade, estado) values ('Guarani', 'MG');
Insert into Cidades (cidade, estado) values ('Guarará', 'MG');
Insert into Cidades (cidade, estado) values ('Guarda-Mor', 'MG');
Insert into Cidades (cidade, estado) values ('Guaxupé', 'MG');
Insert into Cidades (cidade, estado) values ('Guidoval', 'MG');
Insert into Cidades (cidade, estado) values ('Guimarânia', 'MG');
Insert into Cidades (cidade, estado) values ('Guiricema', 'MG');
Insert into Cidades (cidade, estado) values ('Gurinhatã', 'MG');
Insert into Cidades (cidade, estado) values ('Heliodora', 'MG');
Insert into Cidades (cidade, estado) values ('Iapu', 'MG');
Insert into Cidades (cidade, estado) values ('Ibertioga', 'MG');
Insert into Cidades (cidade, estado) values ('Ibiá', 'MG');
Insert into Cidades (cidade, estado) values ('Ibiaí', 'MG');
Insert into Cidades (cidade, estado) values ('Ibiracatu', 'MG');
Insert into Cidades (cidade, estado) values ('Ibiraci', 'MG');
Insert into Cidades (cidade, estado) values ('Ibirité', 'MG');
Insert into Cidades (cidade, estado) values ('Ibitiúra de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Ibituruna', 'MG');
Insert into Cidades (cidade, estado) values ('Icaraí de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Igarapé', 'MG');
Insert into Cidades (cidade, estado) values ('Igaratinga', 'MG');
Insert into Cidades (cidade, estado) values ('Iguatama', 'MG');
Insert into Cidades (cidade, estado) values ('Ijaci', 'MG');
Insert into Cidades (cidade, estado) values ('Ilicínea', 'MG');
Insert into Cidades (cidade, estado) values ('Imbé de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Inconfidentes', 'MG');
Insert into Cidades (cidade, estado) values ('Indaiabira', 'MG');
Insert into Cidades (cidade, estado) values ('Indianópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Ingaí', 'MG');
Insert into Cidades (cidade, estado) values ('Inhapim', 'MG');
Insert into Cidades (cidade, estado) values ('Inhaúma', 'MG');
Insert into Cidades (cidade, estado) values ('Inimutaba', 'MG');
Insert into Cidades (cidade, estado) values ('Ipaba', 'MG');
Insert into Cidades (cidade, estado) values ('Ipanema', 'MG');
Insert into Cidades (cidade, estado) values ('Ipatinga', 'MG');
Insert into Cidades (cidade, estado) values ('Ipiaçu', 'MG');
Insert into Cidades (cidade, estado) values ('Ipuiúna', 'MG');
Insert into Cidades (cidade, estado) values ('Iraí de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Itabira', 'MG');
Insert into Cidades (cidade, estado) values ('Itabirinha', 'MG');
Insert into Cidades (cidade, estado) values ('Itabirito', 'MG');
Insert into Cidades (cidade, estado) values ('Itacambira', 'MG');
Insert into Cidades (cidade, estado) values ('Itacarambi', 'MG');
Insert into Cidades (cidade, estado) values ('Itaguara', 'MG');
Insert into Cidades (cidade, estado) values ('Itaipé', 'MG');
Insert into Cidades (cidade, estado) values ('Itajubá', 'MG');
Insert into Cidades (cidade, estado) values ('Itamarandiba', 'MG');
Insert into Cidades (cidade, estado) values ('Itamarati de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Itambacuri', 'MG');
Insert into Cidades (cidade, estado) values ('Itambé do Mato Dentro', 'MG');
Insert into Cidades (cidade, estado) values ('Itamogi', 'MG');
Insert into Cidades (cidade, estado) values ('Itamonte', 'MG');
Insert into Cidades (cidade, estado) values ('Itanhandu', 'MG');
Insert into Cidades (cidade, estado) values ('Itanhomi', 'MG');
Insert into Cidades (cidade, estado) values ('Itaobim', 'MG');
Insert into Cidades (cidade, estado) values ('Itapagipe', 'MG');
Insert into Cidades (cidade, estado) values ('Itapecerica', 'MG');
Insert into Cidades (cidade, estado) values ('Itapeva', 'MG');
Insert into Cidades (cidade, estado) values ('Itatiaiuçu', 'MG');
Insert into Cidades (cidade, estado) values ('Itaú de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Itaúna', 'MG');
Insert into Cidades (cidade, estado) values ('Itaverava', 'MG');
Insert into Cidades (cidade, estado) values ('Itinga', 'MG');
Insert into Cidades (cidade, estado) values ('Itueta', 'MG');
Insert into Cidades (cidade, estado) values ('Ituiutaba', 'MG');
Insert into Cidades (cidade, estado) values ('Itumirim', 'MG');
Insert into Cidades (cidade, estado) values ('Iturama', 'MG');
Insert into Cidades (cidade, estado) values ('Itutinga', 'MG');
Insert into Cidades (cidade, estado) values ('Jaboticatubas', 'MG');
Insert into Cidades (cidade, estado) values ('Jacinto', 'MG');
Insert into Cidades (cidade, estado) values ('Jacuí', 'MG');
Insert into Cidades (cidade, estado) values ('Jacutinga', 'MG');
Insert into Cidades (cidade, estado) values ('Jaguaraçu', 'MG');
Insert into Cidades (cidade, estado) values ('Jaíba', 'MG');
Insert into Cidades (cidade, estado) values ('Jampruca', 'MG');
Insert into Cidades (cidade, estado) values ('Janaúba', 'MG');
Insert into Cidades (cidade, estado) values ('Januária', 'MG');
Insert into Cidades (cidade, estado) values ('Japaraíba', 'MG');
Insert into Cidades (cidade, estado) values ('Japonvar', 'MG');
Insert into Cidades (cidade, estado) values ('Jeceaba', 'MG');
Insert into Cidades (cidade, estado) values ('Jenipapo de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Jequeri', 'MG');
Insert into Cidades (cidade, estado) values ('Jequitaí', 'MG');
Insert into Cidades (cidade, estado) values ('Jequitibá', 'MG');
Insert into Cidades (cidade, estado) values ('Jequitinhonha', 'MG');
Insert into Cidades (cidade, estado) values ('Jesuânia', 'MG');
Insert into Cidades (cidade, estado) values ('Joaíma', 'MG');
Insert into Cidades (cidade, estado) values ('Joanésia', 'MG');
Insert into Cidades (cidade, estado) values ('João Monlevade', 'MG');
Insert into Cidades (cidade, estado) values ('João Pinheiro', 'MG');
Insert into Cidades (cidade, estado) values ('Joaquim Felício', 'MG');
Insert into Cidades (cidade, estado) values ('Jordânia', 'MG');
Insert into Cidades (cidade, estado) values ('José Gonçalves de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('José Raydan', 'MG');
Insert into Cidades (cidade, estado) values ('Josenópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Nova União', 'MG');
Insert into Cidades (cidade, estado) values ('Juatuba', 'MG');
Insert into Cidades (cidade, estado) values ('Juiz de Fora', 'MG');
Insert into Cidades (cidade, estado) values ('Juramento', 'MG');
Insert into Cidades (cidade, estado) values ('Juruaia', 'MG');
Insert into Cidades (cidade, estado) values ('Juvenília', 'MG');
Insert into Cidades (cidade, estado) values ('Ladainha', 'MG');
Insert into Cidades (cidade, estado) values ('Lagamar', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa da Prata', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa dos Patos', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa Dourada', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa Formosa', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa Grande', 'MG');
Insert into Cidades (cidade, estado) values ('Lagoa Santa', 'MG');
Insert into Cidades (cidade, estado) values ('Lajinha', 'MG');
Insert into Cidades (cidade, estado) values ('Lambari', 'MG');
Insert into Cidades (cidade, estado) values ('Lamim', 'MG');
Insert into Cidades (cidade, estado) values ('Laranjal', 'MG');
Insert into Cidades (cidade, estado) values ('Lassance', 'MG');
Insert into Cidades (cidade, estado) values ('Lavras', 'MG');
Insert into Cidades (cidade, estado) values ('Leandro Ferreira', 'MG');
Insert into Cidades (cidade, estado) values ('Leme do Prado', 'MG');
Insert into Cidades (cidade, estado) values ('Leopoldina', 'MG');
Insert into Cidades (cidade, estado) values ('Liberdade', 'MG');
Insert into Cidades (cidade, estado) values ('Lima Duarte', 'MG');
Insert into Cidades (cidade, estado) values ('Limeira do Oeste', 'MG');
Insert into Cidades (cidade, estado) values ('Lontra', 'MG');
Insert into Cidades (cidade, estado) values ('Luisburgo', 'MG');
Insert into Cidades (cidade, estado) values ('Luislândia', 'MG');
Insert into Cidades (cidade, estado) values ('Luminárias', 'MG');
Insert into Cidades (cidade, estado) values ('Luz', 'MG');
Insert into Cidades (cidade, estado) values ('Machacalis', 'MG');
Insert into Cidades (cidade, estado) values ('Machado', 'MG');
Insert into Cidades (cidade, estado) values ('Madre de Deus de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Malacacheta', 'MG');
Insert into Cidades (cidade, estado) values ('Mamonas', 'MG');
Insert into Cidades (cidade, estado) values ('Manga', 'MG');
Insert into Cidades (cidade, estado) values ('Manhuaçu', 'MG');
Insert into Cidades (cidade, estado) values ('Manhumirim', 'MG');
Insert into Cidades (cidade, estado) values ('Mantena', 'MG');
Insert into Cidades (cidade, estado) values ('Maravilhas', 'MG');
Insert into Cidades (cidade, estado) values ('Mar de Espanha', 'MG');
Insert into Cidades (cidade, estado) values ('Maria da Fé', 'MG');
Insert into Cidades (cidade, estado) values ('Mariana', 'MG');
Insert into Cidades (cidade, estado) values ('Marilac', 'MG');
Insert into Cidades (cidade, estado) values ('Mário Campos', 'MG');
Insert into Cidades (cidade, estado) values ('Maripá de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Marliéria', 'MG');
Insert into Cidades (cidade, estado) values ('Marmelópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Martinho Campos', 'MG');
Insert into Cidades (cidade, estado) values ('Martins Soares', 'MG');
Insert into Cidades (cidade, estado) values ('Mata Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Materlândia', 'MG');
Insert into Cidades (cidade, estado) values ('Mateus Leme', 'MG');
Insert into Cidades (cidade, estado) values ('Matias Barbosa', 'MG');
Insert into Cidades (cidade, estado) values ('Matias Cardoso', 'MG');
Insert into Cidades (cidade, estado) values ('Matipó', 'MG');
Insert into Cidades (cidade, estado) values ('Mato Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Matozinhos', 'MG');
Insert into Cidades (cidade, estado) values ('Matutina', 'MG');
Insert into Cidades (cidade, estado) values ('Medeiros', 'MG');
Insert into Cidades (cidade, estado) values ('Medina', 'MG');
Insert into Cidades (cidade, estado) values ('Mendes Pimentel', 'MG');
Insert into Cidades (cidade, estado) values ('Mercês', 'MG');
Insert into Cidades (cidade, estado) values ('Mesquita', 'MG');
Insert into Cidades (cidade, estado) values ('Minas Novas', 'MG');
Insert into Cidades (cidade, estado) values ('Minduri', 'MG');
Insert into Cidades (cidade, estado) values ('Mirabela', 'MG');
Insert into Cidades (cidade, estado) values ('Miradouro', 'MG');
Insert into Cidades (cidade, estado) values ('Miraí', 'MG');
Insert into Cidades (cidade, estado) values ('Miravânia', 'MG');
Insert into Cidades (cidade, estado) values ('Moeda', 'MG');
Insert into Cidades (cidade, estado) values ('Moema', 'MG');
Insert into Cidades (cidade, estado) values ('Monjolos', 'MG');
Insert into Cidades (cidade, estado) values ('Monsenhor Paulo', 'MG');
Insert into Cidades (cidade, estado) values ('Montalvânia', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Alegre de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Azul', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Belo', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Carmelo', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Formoso', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Santo de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Montes Claros', 'MG');
Insert into Cidades (cidade, estado) values ('Monte Sião', 'MG');
Insert into Cidades (cidade, estado) values ('Montezuma', 'MG');
Insert into Cidades (cidade, estado) values ('Morada Nova de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Morro da Garça', 'MG');
Insert into Cidades (cidade, estado) values ('Morro do Pilar', 'MG');
Insert into Cidades (cidade, estado) values ('Munhoz', 'MG');
Insert into Cidades (cidade, estado) values ('Muriaé', 'MG');
Insert into Cidades (cidade, estado) values ('Mutum', 'MG');
Insert into Cidades (cidade, estado) values ('Muzambinho', 'MG');
Insert into Cidades (cidade, estado) values ('Nacip Raydan', 'MG');
Insert into Cidades (cidade, estado) values ('Nanuque', 'MG');
Insert into Cidades (cidade, estado) values ('Naque', 'MG');
Insert into Cidades (cidade, estado) values ('Natalândia', 'MG');
Insert into Cidades (cidade, estado) values ('Natércia', 'MG');
Insert into Cidades (cidade, estado) values ('Nazareno', 'MG');
Insert into Cidades (cidade, estado) values ('Nepomuceno', 'MG');
Insert into Cidades (cidade, estado) values ('Ninheira', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Belém', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Era', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Lima', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Módica', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Ponte', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Porteirinha', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Resende', 'MG');
Insert into Cidades (cidade, estado) values ('Nova Serrana', 'MG');
Insert into Cidades (cidade, estado) values ('Novo Cruzeiro', 'MG');
Insert into Cidades (cidade, estado) values ('Novo Oriente de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Novorizonte', 'MG');
Insert into Cidades (cidade, estado) values ('Olaria', 'MG');
Insert into Cidades (cidade, estado) values ('Olhos-D''Água', 'MG');
Insert into Cidades (cidade, estado) values ('Olímpio Noronha', 'MG');
Insert into Cidades (cidade, estado) values ('Oliveira', 'MG');
Insert into Cidades (cidade, estado) values ('Oliveira Fortes', 'MG');
Insert into Cidades (cidade, estado) values ('Onça de Pitangui', 'MG');
Insert into Cidades (cidade, estado) values ('Oratórios', 'MG');
Insert into Cidades (cidade, estado) values ('Orizânia', 'MG');
Insert into Cidades (cidade, estado) values ('Ouro Branco', 'MG');
Insert into Cidades (cidade, estado) values ('Ouro Fino', 'MG');
Insert into Cidades (cidade, estado) values ('Ouro Preto', 'MG');
Insert into Cidades (cidade, estado) values ('Ouro Verde de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Padre Carvalho', 'MG');
Insert into Cidades (cidade, estado) values ('Padre Paraíso', 'MG');
Insert into Cidades (cidade, estado) values ('Paineiras', 'MG');
Insert into Cidades (cidade, estado) values ('Pains', 'MG');
Insert into Cidades (cidade, estado) values ('Pai Pedro', 'MG');
Insert into Cidades (cidade, estado) values ('Paiva', 'MG');
Insert into Cidades (cidade, estado) values ('Palma', 'MG');
Insert into Cidades (cidade, estado) values ('Palmópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Papagaios', 'MG');
Insert into Cidades (cidade, estado) values ('Paracatu', 'MG');
Insert into Cidades (cidade, estado) values ('Pará de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Paraguaçu', 'MG');
Insert into Cidades (cidade, estado) values ('Paraisópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Paraopeba', 'MG');
Insert into Cidades (cidade, estado) values ('Passabém', 'MG');
Insert into Cidades (cidade, estado) values ('Passa Quatro', 'MG');
Insert into Cidades (cidade, estado) values ('Passa Tempo', 'MG');
Insert into Cidades (cidade, estado) values ('Passa-Vinte', 'MG');
Insert into Cidades (cidade, estado) values ('Passos', 'MG');
Insert into Cidades (cidade, estado) values ('Patis', 'MG');
Insert into Cidades (cidade, estado) values ('Patos de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Patrocínio', 'MG');
Insert into Cidades (cidade, estado) values ('Patrocínio do Muriaé', 'MG');
Insert into Cidades (cidade, estado) values ('Paula Cândido', 'MG');
Insert into Cidades (cidade, estado) values ('Paulistas', 'MG');
Insert into Cidades (cidade, estado) values ('Pavão', 'MG');
Insert into Cidades (cidade, estado) values ('Peçanha', 'MG');
Insert into Cidades (cidade, estado) values ('Pedra Azul', 'MG');
Insert into Cidades (cidade, estado) values ('Pedra Bonita', 'MG');
Insert into Cidades (cidade, estado) values ('Pedra do Anta', 'MG');
Insert into Cidades (cidade, estado) values ('Pedra do Indaiá', 'MG');
Insert into Cidades (cidade, estado) values ('Pedra Dourada', 'MG');
Insert into Cidades (cidade, estado) values ('Pedralva', 'MG');
Insert into Cidades (cidade, estado) values ('Pedras de Maria da Cruz', 'MG');
Insert into Cidades (cidade, estado) values ('Pedrinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Pedro Leopoldo', 'MG');
Insert into Cidades (cidade, estado) values ('Pedro Teixeira', 'MG');
Insert into Cidades (cidade, estado) values ('Pequeri', 'MG');
Insert into Cidades (cidade, estado) values ('Pequi', 'MG');
Insert into Cidades (cidade, estado) values ('Perdigão', 'MG');
Insert into Cidades (cidade, estado) values ('Perdizes', 'MG');
Insert into Cidades (cidade, estado) values ('Perdões', 'MG');
Insert into Cidades (cidade, estado) values ('Periquito', 'MG');
Insert into Cidades (cidade, estado) values ('Pescador', 'MG');
Insert into Cidades (cidade, estado) values ('Piau', 'MG');
Insert into Cidades (cidade, estado) values ('Piedade de Caratinga', 'MG');
Insert into Cidades (cidade, estado) values ('Piedade de Ponte Nova', 'MG');
Insert into Cidades (cidade, estado) values ('Piedade do Rio Grande', 'MG');
Insert into Cidades (cidade, estado) values ('Piedade dos Gerais', 'MG');
Insert into Cidades (cidade, estado) values ('Pimenta', 'MG');
Insert into Cidades (cidade, estado) values ('Pingo-D''Água', 'MG');
Insert into Cidades (cidade, estado) values ('Pintópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Piracema', 'MG');
Insert into Cidades (cidade, estado) values ('Pirajuba', 'MG');
Insert into Cidades (cidade, estado) values ('Piranga', 'MG');
Insert into Cidades (cidade, estado) values ('Piranguçu', 'MG');
Insert into Cidades (cidade, estado) values ('Piranguinho', 'MG');
Insert into Cidades (cidade, estado) values ('Pirapetinga', 'MG');
Insert into Cidades (cidade, estado) values ('Pirapora', 'MG');
Insert into Cidades (cidade, estado) values ('Piraúba', 'MG');
Insert into Cidades (cidade, estado) values ('Pitangui', 'MG');
Insert into Cidades (cidade, estado) values ('Piumhi', 'MG');
Insert into Cidades (cidade, estado) values ('Planura', 'MG');
Insert into Cidades (cidade, estado) values ('Poço Fundo', 'MG');
Insert into Cidades (cidade, estado) values ('Poços de Caldas', 'MG');
Insert into Cidades (cidade, estado) values ('Pocrane', 'MG');
Insert into Cidades (cidade, estado) values ('Pompéu', 'MG');
Insert into Cidades (cidade, estado) values ('Ponte Nova', 'MG');
Insert into Cidades (cidade, estado) values ('Ponto Chique', 'MG');
Insert into Cidades (cidade, estado) values ('Ponto dos Volantes', 'MG');
Insert into Cidades (cidade, estado) values ('Porteirinha', 'MG');
Insert into Cidades (cidade, estado) values ('Porto Firme', 'MG');
Insert into Cidades (cidade, estado) values ('Poté', 'MG');
Insert into Cidades (cidade, estado) values ('Pouso Alegre', 'MG');
Insert into Cidades (cidade, estado) values ('Pouso Alto', 'MG');
Insert into Cidades (cidade, estado) values ('Prados', 'MG');
Insert into Cidades (cidade, estado) values ('Prata', 'MG');
Insert into Cidades (cidade, estado) values ('Pratápolis', 'MG');
Insert into Cidades (cidade, estado) values ('Pratinha', 'MG');
Insert into Cidades (cidade, estado) values ('Presidente Bernardes', 'MG');
Insert into Cidades (cidade, estado) values ('Presidente Juscelino', 'MG');
Insert into Cidades (cidade, estado) values ('Presidente Kubitschek', 'MG');
Insert into Cidades (cidade, estado) values ('Presidente Olegário', 'MG');
Insert into Cidades (cidade, estado) values ('Alto Jequitibá', 'MG');
Insert into Cidades (cidade, estado) values ('Prudente de Morais', 'MG');
Insert into Cidades (cidade, estado) values ('Quartel Geral', 'MG');
Insert into Cidades (cidade, estado) values ('Queluzito', 'MG');
Insert into Cidades (cidade, estado) values ('Raposos', 'MG');
Insert into Cidades (cidade, estado) values ('Raul Soares', 'MG');
Insert into Cidades (cidade, estado) values ('Recreio', 'MG');
Insert into Cidades (cidade, estado) values ('Reduto', 'MG');
Insert into Cidades (cidade, estado) values ('Resende Costa', 'MG');
Insert into Cidades (cidade, estado) values ('Resplendor', 'MG');
Insert into Cidades (cidade, estado) values ('Ressaquinha', 'MG');
Insert into Cidades (cidade, estado) values ('Riachinho', 'MG');
Insert into Cidades (cidade, estado) values ('Riacho dos Machados', 'MG');
Insert into Cidades (cidade, estado) values ('Ribeirão das Neves', 'MG');
Insert into Cidades (cidade, estado) values ('Ribeirão Vermelho', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Acima', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Casca', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Doce', 'MG');
Insert into Cidades (cidade, estado) values ('Rio do Prado', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Espera', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Manso', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Novo', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Paranaíba', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Pardo de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Piracicaba', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Pomba', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Preto', 'MG');
Insert into Cidades (cidade, estado) values ('Rio Vermelho', 'MG');
Insert into Cidades (cidade, estado) values ('Ritápolis', 'MG');
Insert into Cidades (cidade, estado) values ('Rochedo de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Rodeiro', 'MG');
Insert into Cidades (cidade, estado) values ('Romaria', 'MG');
Insert into Cidades (cidade, estado) values ('Rosário da Limeira', 'MG');
Insert into Cidades (cidade, estado) values ('Rubelita', 'MG');
Insert into Cidades (cidade, estado) values ('Rubim', 'MG');
Insert into Cidades (cidade, estado) values ('Sabará', 'MG');
Insert into Cidades (cidade, estado) values ('Sabinópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Sacramento', 'MG');
Insert into Cidades (cidade, estado) values ('Salinas', 'MG');
Insert into Cidades (cidade, estado) values ('Salto da Divisa', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Bárbara', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Bárbara do Leste', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Bárbara do Monte Verde', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Bárbara do Tugúrio', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Cruz de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Cruz de Salinas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Escalvado', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Efigênia de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Fé de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Helena de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Juliana', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Luzia', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Margarida', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Maria de Itabira', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Maria do Salto', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Maria do Suaçuí', 'MG');
Insert into Cidades (cidade, estado) values ('Santana da Vargem', 'MG');
Insert into Cidades (cidade, estado) values ('Santana de Cataguases', 'MG');
Insert into Cidades (cidade, estado) values ('Santana de Pirapama', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Deserto', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Garambéu', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Jacaré', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Manhuaçu', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Paraíso', 'MG');
Insert into Cidades (cidade, estado) values ('Santana do Riacho', 'MG');
Insert into Cidades (cidade, estado) values ('Santana dos Montes', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita de Caldas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita de Jacutinga', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita de Ibitipoca', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita do Itueto', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rita do Sapucaí', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Rosa da Serra', 'MG');
Insert into Cidades (cidade, estado) values ('Santa Vitória', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Amparo', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Aventureiro', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Grama', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Itambé', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Jacinto', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Monte', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Retiro', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Rio Abaixo', 'MG');
Insert into Cidades (cidade, estado) values ('Santo Hipólito', 'MG');
Insert into Cidades (cidade, estado) values ('Santos Dumont', 'MG');
Insert into Cidades (cidade, estado) values ('São Bento Abade', 'MG');
Insert into Cidades (cidade, estado) values ('São Brás do Suaçuí', 'MG');
Insert into Cidades (cidade, estado) values ('São Domingos das Dores', 'MG');
Insert into Cidades (cidade, estado) values ('São Domingos do Prata', 'MG');
Insert into Cidades (cidade, estado) values ('São Félix de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('São Francisco', 'MG');
Insert into Cidades (cidade, estado) values ('São Francisco de Paula', 'MG');
Insert into Cidades (cidade, estado) values ('São Francisco de Sales', 'MG');
Insert into Cidades (cidade, estado) values ('São Francisco do Glória', 'MG');
Insert into Cidades (cidade, estado) values ('São Geraldo', 'MG');
Insert into Cidades (cidade, estado) values ('São Geraldo da Piedade', 'MG');
Insert into Cidades (cidade, estado) values ('São Geraldo do Baixio', 'MG');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Abaeté', 'MG');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Pará', 'MG');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Rio Abaixo', 'MG');
Insert into Cidades (cidade, estado) values ('São Gonçalo do Sapucaí', 'MG');
Insert into Cidades (cidade, estado) values ('São Gotardo', 'MG');
Insert into Cidades (cidade, estado) values ('São João Batista do Glória', 'MG');
Insert into Cidades (cidade, estado) values ('São João da Lagoa', 'MG');
Insert into Cidades (cidade, estado) values ('São João da Mata', 'MG');
Insert into Cidades (cidade, estado) values ('São João da Ponte', 'MG');
Insert into Cidades (cidade, estado) values ('São João das Missões', 'MG');
Insert into Cidades (cidade, estado) values ('São João del Rei', 'MG');
Insert into Cidades (cidade, estado) values ('São João do Manhuaçu', 'MG');
Insert into Cidades (cidade, estado) values ('São João do Manteninha', 'MG');
Insert into Cidades (cidade, estado) values ('São João do Oriente', 'MG');
Insert into Cidades (cidade, estado) values ('São João do Pacuí', 'MG');
Insert into Cidades (cidade, estado) values ('São João do Paraíso', 'MG');
Insert into Cidades (cidade, estado) values ('São João Evangelista', 'MG');
Insert into Cidades (cidade, estado) values ('São João Nepomuceno', 'MG');
Insert into Cidades (cidade, estado) values ('São Joaquim de Bicas', 'MG');
Insert into Cidades (cidade, estado) values ('São José da Barra', 'MG');
Insert into Cidades (cidade, estado) values ('São José da Lapa', 'MG');
Insert into Cidades (cidade, estado) values ('São José da Safira', 'MG');
Insert into Cidades (cidade, estado) values ('São José da Varginha', 'MG');
Insert into Cidades (cidade, estado) values ('São José do Alegre', 'MG');
Insert into Cidades (cidade, estado) values ('São José do Divino', 'MG');
Insert into Cidades (cidade, estado) values ('São José do Goiabal', 'MG');
Insert into Cidades (cidade, estado) values ('São José do Jacuri', 'MG');
Insert into Cidades (cidade, estado) values ('São José do Mantimento', 'MG');
Insert into Cidades (cidade, estado) values ('São Lourenço', 'MG');
Insert into Cidades (cidade, estado) values ('São Miguel do Anta', 'MG');
Insert into Cidades (cidade, estado) values ('São Pedro da União', 'MG');
Insert into Cidades (cidade, estado) values ('São Pedro dos Ferros', 'MG');
Insert into Cidades (cidade, estado) values ('São Pedro do Suaçuí', 'MG');
Insert into Cidades (cidade, estado) values ('São Romão', 'MG');
Insert into Cidades (cidade, estado) values ('São Roque de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião da Bela Vista', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião da Vargem Alegre', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Anta', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Maranhão', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Oeste', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Paraíso', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Rio Preto', 'MG');
Insert into Cidades (cidade, estado) values ('São Sebastião do Rio Verde', 'MG');
Insert into Cidades (cidade, estado) values ('São Tiago', 'MG');
Insert into Cidades (cidade, estado) values ('São Tomás de Aquino', 'MG');
Insert into Cidades (cidade, estado) values ('São Thomé das Letras', 'MG');
Insert into Cidades (cidade, estado) values ('São Vicente de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Sapucaí-Mirim', 'MG');
Insert into Cidades (cidade, estado) values ('Sardoá', 'MG');
Insert into Cidades (cidade, estado) values ('Sarzedo', 'MG');
Insert into Cidades (cidade, estado) values ('Setubinha', 'MG');
Insert into Cidades (cidade, estado) values ('Sem-Peixe', 'MG');
Insert into Cidades (cidade, estado) values ('Senador Amaral', 'MG');
Insert into Cidades (cidade, estado) values ('Senador Cortes', 'MG');
Insert into Cidades (cidade, estado) values ('Senador Firmino', 'MG');
Insert into Cidades (cidade, estado) values ('Senador José Bento', 'MG');
Insert into Cidades (cidade, estado) values ('Senador Modestino Gonçalves', 'MG');
Insert into Cidades (cidade, estado) values ('Senhora de Oliveira', 'MG');
Insert into Cidades (cidade, estado) values ('Senhora do Porto', 'MG');
Insert into Cidades (cidade, estado) values ('Senhora dos Remédios', 'MG');
Insert into Cidades (cidade, estado) values ('Sericita', 'MG');
Insert into Cidades (cidade, estado) values ('Seritinga', 'MG');
Insert into Cidades (cidade, estado) values ('Serra Azul de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Serra da Saudade', 'MG');
Insert into Cidades (cidade, estado) values ('Serra dos Aimorés', 'MG');
Insert into Cidades (cidade, estado) values ('Serra do Salitre', 'MG');
Insert into Cidades (cidade, estado) values ('Serrania', 'MG');
Insert into Cidades (cidade, estado) values ('Serranópolis de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Serranos', 'MG');
Insert into Cidades (cidade, estado) values ('Serro', 'MG');
Insert into Cidades (cidade, estado) values ('Sete Lagoas', 'MG');
Insert into Cidades (cidade, estado) values ('Silveirânia', 'MG');
Insert into Cidades (cidade, estado) values ('Silvianópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Simão Pereira', 'MG');
Insert into Cidades (cidade, estado) values ('Simonésia', 'MG');
Insert into Cidades (cidade, estado) values ('Sobrália', 'MG');
Insert into Cidades (cidade, estado) values ('Soledade de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Tabuleiro', 'MG');
Insert into Cidades (cidade, estado) values ('Taiobeiras', 'MG');
Insert into Cidades (cidade, estado) values ('Taparuba', 'MG');
Insert into Cidades (cidade, estado) values ('Tapira', 'MG');
Insert into Cidades (cidade, estado) values ('Tapiraí', 'MG');
Insert into Cidades (cidade, estado) values ('Taquaraçu de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Tarumirim', 'MG');
Insert into Cidades (cidade, estado) values ('Teixeiras', 'MG');
Insert into Cidades (cidade, estado) values ('Teófilo Otoni', 'MG');
Insert into Cidades (cidade, estado) values ('Timóteo', 'MG');
Insert into Cidades (cidade, estado) values ('Tiradentes', 'MG');
Insert into Cidades (cidade, estado) values ('Tiros', 'MG');
Insert into Cidades (cidade, estado) values ('Tocantins', 'MG');
Insert into Cidades (cidade, estado) values ('Tocos do Moji', 'MG');
Insert into Cidades (cidade, estado) values ('Toledo', 'MG');
Insert into Cidades (cidade, estado) values ('Tombos', 'MG');
Insert into Cidades (cidade, estado) values ('Três Corações', 'MG');
Insert into Cidades (cidade, estado) values ('Três Marias', 'MG');
Insert into Cidades (cidade, estado) values ('Três Pontas', 'MG');
Insert into Cidades (cidade, estado) values ('Tumiritinga', 'MG');
Insert into Cidades (cidade, estado) values ('Tupaciguara', 'MG');
Insert into Cidades (cidade, estado) values ('Turmalina', 'MG');
Insert into Cidades (cidade, estado) values ('Turvolândia', 'MG');
Insert into Cidades (cidade, estado) values ('Ubá', 'MG');
Insert into Cidades (cidade, estado) values ('Ubaí', 'MG');
Insert into Cidades (cidade, estado) values ('Ubaporanga', 'MG');
Insert into Cidades (cidade, estado) values ('Uberaba', 'MG');
Insert into Cidades (cidade, estado) values ('Uberlândia', 'MG');
Insert into Cidades (cidade, estado) values ('Umburatiba', 'MG');
Insert into Cidades (cidade, estado) values ('Unaí', 'MG');
Insert into Cidades (cidade, estado) values ('União de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Uruana de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Urucânia', 'MG');
Insert into Cidades (cidade, estado) values ('Urucuia', 'MG');
Insert into Cidades (cidade, estado) values ('Vargem Alegre', 'MG');
Insert into Cidades (cidade, estado) values ('Vargem Bonita', 'MG');
Insert into Cidades (cidade, estado) values ('Vargem Grande do Rio Pardo', 'MG');
Insert into Cidades (cidade, estado) values ('Varginha', 'MG');
Insert into Cidades (cidade, estado) values ('Varjão de Minas', 'MG');
Insert into Cidades (cidade, estado) values ('Várzea da Palma', 'MG');
Insert into Cidades (cidade, estado) values ('Varzelândia', 'MG');
Insert into Cidades (cidade, estado) values ('Vazante', 'MG');
Insert into Cidades (cidade, estado) values ('Verdelândia', 'MG');
Insert into Cidades (cidade, estado) values ('Veredinha', 'MG');
Insert into Cidades (cidade, estado) values ('Veríssimo', 'MG');
Insert into Cidades (cidade, estado) values ('Vermelho Novo', 'MG');
Insert into Cidades (cidade, estado) values ('Vespasiano', 'MG');
Insert into Cidades (cidade, estado) values ('Viçosa', 'MG');
Insert into Cidades (cidade, estado) values ('Vieiras', 'MG');
Insert into Cidades (cidade, estado) values ('Mathias Lobato', 'MG');
Insert into Cidades (cidade, estado) values ('Virgem da Lapa', 'MG');
Insert into Cidades (cidade, estado) values ('Virgínia', 'MG');
Insert into Cidades (cidade, estado) values ('Virginópolis', 'MG');
Insert into Cidades (cidade, estado) values ('Virgolândia', 'MG');
Insert into Cidades (cidade, estado) values ('Visconde do Rio Branco', 'MG');
Insert into Cidades (cidade, estado) values ('Volta Grande', 'MG');
Insert into Cidades (cidade, estado) values ('Wenceslau Braz', 'MG');
Insert into Cidades (cidade, estado) values ('Afonso Cláudio', 'ES');
Insert into Cidades (cidade, estado) values ('Águia Branca', 'ES');
Insert into Cidades (cidade, estado) values ('Água Doce do Norte', 'ES');
Insert into Cidades (cidade, estado) values ('Alegre', 'ES');
Insert into Cidades (cidade, estado) values ('Alfredo Chaves', 'ES');
Insert into Cidades (cidade, estado) values ('Alto Rio Novo', 'ES');
Insert into Cidades (cidade, estado) values ('Anchieta', 'ES');
Insert into Cidades (cidade, estado) values ('Apiacá', 'ES');
Insert into Cidades (cidade, estado) values ('Aracruz', 'ES');
Insert into Cidades (cidade, estado) values ('Atilio Vivacqua', 'ES');
Insert into Cidades (cidade, estado) values ('Baixo Guandu', 'ES');
Insert into Cidades (cidade, estado) values ('Barra de São Francisco', 'ES');
Insert into Cidades (cidade, estado) values ('Boa Esperança', 'ES');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Norte', 'ES');
Insert into Cidades (cidade, estado) values ('Brejetuba', 'ES');
Insert into Cidades (cidade, estado) values ('Cachoeiro de Itapemirim', 'ES');
Insert into Cidades (cidade, estado) values ('Cariacica', 'ES');
Insert into Cidades (cidade, estado) values ('Castelo', 'ES');
Insert into Cidades (cidade, estado) values ('Colatina', 'ES');
Insert into Cidades (cidade, estado) values ('Conceição da Barra', 'ES');
Insert into Cidades (cidade, estado) values ('Conceição do Castelo', 'ES');
Insert into Cidades (cidade, estado) values ('Divino de São Lourenço', 'ES');
Insert into Cidades (cidade, estado) values ('Domingos Martins', 'ES');
Insert into Cidades (cidade, estado) values ('Dores do Rio Preto', 'ES');
Insert into Cidades (cidade, estado) values ('Ecoporanga', 'ES');
Insert into Cidades (cidade, estado) values ('Fundão', 'ES');
Insert into Cidades (cidade, estado) values ('Governador Lindenberg', 'ES');
Insert into Cidades (cidade, estado) values ('Guaçuí', 'ES');
Insert into Cidades (cidade, estado) values ('Guarapari', 'ES');
Insert into Cidades (cidade, estado) values ('Ibatiba', 'ES');
Insert into Cidades (cidade, estado) values ('Ibiraçu', 'ES');
Insert into Cidades (cidade, estado) values ('Ibitirama', 'ES');
Insert into Cidades (cidade, estado) values ('Iconha', 'ES');
Insert into Cidades (cidade, estado) values ('Irupi', 'ES');
Insert into Cidades (cidade, estado) values ('Itaguaçu', 'ES');
Insert into Cidades (cidade, estado) values ('Itapemirim', 'ES');
Insert into Cidades (cidade, estado) values ('Itarana', 'ES');
Insert into Cidades (cidade, estado) values ('Iúna', 'ES');
Insert into Cidades (cidade, estado) values ('Jaguaré', 'ES');
Insert into Cidades (cidade, estado) values ('Jerônimo Monteiro', 'ES');
Insert into Cidades (cidade, estado) values ('João Neiva', 'ES');
Insert into Cidades (cidade, estado) values ('Laranja da Terra', 'ES');
Insert into Cidades (cidade, estado) values ('Linhares', 'ES');
Insert into Cidades (cidade, estado) values ('Mantenópolis', 'ES');
Insert into Cidades (cidade, estado) values ('Marataízes', 'ES');
Insert into Cidades (cidade, estado) values ('Marechal Floriano', 'ES');
Insert into Cidades (cidade, estado) values ('Marilândia', 'ES');
Insert into Cidades (cidade, estado) values ('Mimoso do Sul', 'ES');
Insert into Cidades (cidade, estado) values ('Montanha', 'ES');
Insert into Cidades (cidade, estado) values ('Mucurici', 'ES');
Insert into Cidades (cidade, estado) values ('Muniz Freire', 'ES');
Insert into Cidades (cidade, estado) values ('Muqui', 'ES');
Insert into Cidades (cidade, estado) values ('Nova Venécia', 'ES');
Insert into Cidades (cidade, estado) values ('Pancas', 'ES');
Insert into Cidades (cidade, estado) values ('Pedro Canário', 'ES');
Insert into Cidades (cidade, estado) values ('Pinheiros', 'ES');
Insert into Cidades (cidade, estado) values ('Piúma', 'ES');
Insert into Cidades (cidade, estado) values ('Ponto Belo', 'ES');
Insert into Cidades (cidade, estado) values ('Presidente Kennedy', 'ES');
Insert into Cidades (cidade, estado) values ('Rio Bananal', 'ES');
Insert into Cidades (cidade, estado) values ('Rio Novo do Sul', 'ES');
Insert into Cidades (cidade, estado) values ('Santa Leopoldina', 'ES');
Insert into Cidades (cidade, estado) values ('Santa Maria de Jetibá', 'ES');
Insert into Cidades (cidade, estado) values ('Santa Teresa', 'ES');
Insert into Cidades (cidade, estado) values ('São Domingos do Norte', 'ES');
Insert into Cidades (cidade, estado) values ('São Gabriel da Palha', 'ES');
Insert into Cidades (cidade, estado) values ('São José do Calçado', 'ES');
Insert into Cidades (cidade, estado) values ('São Mateus', 'ES');
Insert into Cidades (cidade, estado) values ('São Roque do Canaã', 'ES');
Insert into Cidades (cidade, estado) values ('Serra', 'ES');
Insert into Cidades (cidade, estado) values ('Sooretama', 'ES');
Insert into Cidades (cidade, estado) values ('Vargem Alta', 'ES');
Insert into Cidades (cidade, estado) values ('Venda Nova do Imigrante', 'ES');
Insert into Cidades (cidade, estado) values ('Viana', 'ES');
Insert into Cidades (cidade, estado) values ('Vila Pavão', 'ES');
Insert into Cidades (cidade, estado) values ('Vila Valério', 'ES');
Insert into Cidades (cidade, estado) values ('Vila Velha', 'ES');
Insert into Cidades (cidade, estado) values ('Vitória', 'ES');
Insert into Cidades (cidade, estado) values ('Angra dos Reis', 'RJ');
Insert into Cidades (cidade, estado) values ('Aperibé', 'RJ');
Insert into Cidades (cidade, estado) values ('Araruama', 'RJ');
Insert into Cidades (cidade, estado) values ('Areal', 'RJ');
Insert into Cidades (cidade, estado) values ('Armação dos Búzios', 'RJ');
Insert into Cidades (cidade, estado) values ('Arraial do Cabo', 'RJ');
Insert into Cidades (cidade, estado) values ('Barra do Piraí', 'RJ');
Insert into Cidades (cidade, estado) values ('Barra Mansa', 'RJ');
Insert into Cidades (cidade, estado) values ('Belford Roxo', 'RJ');
Insert into Cidades (cidade, estado) values ('Bom Jardim', 'RJ');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Itabapoana', 'RJ');
Insert into Cidades (cidade, estado) values ('Cabo Frio', 'RJ');
Insert into Cidades (cidade, estado) values ('Cachoeiras de Macacu', 'RJ');
Insert into Cidades (cidade, estado) values ('Cambuci', 'RJ');
Insert into Cidades (cidade, estado) values ('Carapebus', 'RJ');
Insert into Cidades (cidade, estado) values ('Comendador Levy Gasparian', 'RJ');
Insert into Cidades (cidade, estado) values ('Campos dos Goytacazes', 'RJ');
Insert into Cidades (cidade, estado) values ('Cantagalo', 'RJ');
Insert into Cidades (cidade, estado) values ('Cardoso Moreira', 'RJ');
Insert into Cidades (cidade, estado) values ('Carmo', 'RJ');
Insert into Cidades (cidade, estado) values ('Casimiro de Abreu', 'RJ');
Insert into Cidades (cidade, estado) values ('Conceição de Macabu', 'RJ');
Insert into Cidades (cidade, estado) values ('Cordeiro', 'RJ');
Insert into Cidades (cidade, estado) values ('Duas Barras', 'RJ');
Insert into Cidades (cidade, estado) values ('Duque de Caxias', 'RJ');
Insert into Cidades (cidade, estado) values ('Engenheiro Paulo de Frontin', 'RJ');
Insert into Cidades (cidade, estado) values ('Guapimirim', 'RJ');
Insert into Cidades (cidade, estado) values ('Iguaba Grande', 'RJ');
Insert into Cidades (cidade, estado) values ('Itaboraí', 'RJ');
Insert into Cidades (cidade, estado) values ('Itaguaí', 'RJ');
Insert into Cidades (cidade, estado) values ('Italva', 'RJ');
Insert into Cidades (cidade, estado) values ('Itaocara', 'RJ');
Insert into Cidades (cidade, estado) values ('Itaperuna', 'RJ');
Insert into Cidades (cidade, estado) values ('Itatiaia', 'RJ');
Insert into Cidades (cidade, estado) values ('Japeri', 'RJ');
Insert into Cidades (cidade, estado) values ('Laje do Muriaé', 'RJ');
Insert into Cidades (cidade, estado) values ('Macaé', 'RJ');
Insert into Cidades (cidade, estado) values ('Macuco', 'RJ');
Insert into Cidades (cidade, estado) values ('Magé', 'RJ');
Insert into Cidades (cidade, estado) values ('Mangaratiba', 'RJ');
Insert into Cidades (cidade, estado) values ('Maricá', 'RJ');
Insert into Cidades (cidade, estado) values ('Mendes', 'RJ');
Insert into Cidades (cidade, estado) values ('Mesquita', 'RJ');
Insert into Cidades (cidade, estado) values ('Miguel Pereira', 'RJ');
Insert into Cidades (cidade, estado) values ('Miracema', 'RJ');
Insert into Cidades (cidade, estado) values ('Natividade', 'RJ');
Insert into Cidades (cidade, estado) values ('Nilópolis', 'RJ');
Insert into Cidades (cidade, estado) values ('Niterói', 'RJ');
Insert into Cidades (cidade, estado) values ('Nova Friburgo', 'RJ');
Insert into Cidades (cidade, estado) values ('Nova Iguaçu', 'RJ');
Insert into Cidades (cidade, estado) values ('Paracambi', 'RJ');
Insert into Cidades (cidade, estado) values ('Paraíba do Sul', 'RJ');
Insert into Cidades (cidade, estado) values ('Paraty', 'RJ');
Insert into Cidades (cidade, estado) values ('Paty do Alferes', 'RJ');
Insert into Cidades (cidade, estado) values ('Petrópolis', 'RJ');
Insert into Cidades (cidade, estado) values ('Pinheiral', 'RJ');
Insert into Cidades (cidade, estado) values ('Piraí', 'RJ');
Insert into Cidades (cidade, estado) values ('Porciúncula', 'RJ');
Insert into Cidades (cidade, estado) values ('Porto Real', 'RJ');
Insert into Cidades (cidade, estado) values ('Quatis', 'RJ');
Insert into Cidades (cidade, estado) values ('Queimados', 'RJ');
Insert into Cidades (cidade, estado) values ('Quissamã', 'RJ');
Insert into Cidades (cidade, estado) values ('Resende', 'RJ');
Insert into Cidades (cidade, estado) values ('Rio Bonito', 'RJ');
Insert into Cidades (cidade, estado) values ('Rio Claro', 'RJ');
Insert into Cidades (cidade, estado) values ('Rio das Flores', 'RJ');
Insert into Cidades (cidade, estado) values ('Rio das Ostras', 'RJ');
Insert into Cidades (cidade, estado) values ('Rio de Janeiro', 'RJ');
Insert into Cidades (cidade, estado) values ('Santa Maria Madalena', 'RJ');
Insert into Cidades (cidade, estado) values ('Santo Antônio de Pádua', 'RJ');
Insert into Cidades (cidade, estado) values ('São Francisco de Itabapoana', 'RJ');
Insert into Cidades (cidade, estado) values ('São Fidélis', 'RJ');
Insert into Cidades (cidade, estado) values ('São Gonçalo', 'RJ');
Insert into Cidades (cidade, estado) values ('São João da Barra', 'RJ');
Insert into Cidades (cidade, estado) values ('São João de Meriti', 'RJ');
Insert into Cidades (cidade, estado) values ('São José de Ubá', 'RJ');
Insert into Cidades (cidade, estado) values ('São José do Vale do Rio Preto', 'RJ');
Insert into Cidades (cidade, estado) values ('São Pedro da Aldeia', 'RJ');
Insert into Cidades (cidade, estado) values ('São Sebastião do Alto', 'RJ');
Insert into Cidades (cidade, estado) values ('Sapucaia', 'RJ');
Insert into Cidades (cidade, estado) values ('Saquarema', 'RJ');
Insert into Cidades (cidade, estado) values ('Seropédica', 'RJ');
Insert into Cidades (cidade, estado) values ('Silva Jardim', 'RJ');
Insert into Cidades (cidade, estado) values ('Sumidouro', 'RJ');
Insert into Cidades (cidade, estado) values ('Tanguá', 'RJ');
Insert into Cidades (cidade, estado) values ('Teresópolis', 'RJ');
Insert into Cidades (cidade, estado) values ('Trajano de Moraes', 'RJ');
Insert into Cidades (cidade, estado) values ('Três Rios', 'RJ');
Insert into Cidades (cidade, estado) values ('Valença', 'RJ');
Insert into Cidades (cidade, estado) values ('Varre-Sai', 'RJ');
Insert into Cidades (cidade, estado) values ('Vassouras', 'RJ');
Insert into Cidades (cidade, estado) values ('Volta Redonda', 'RJ');
Insert into Cidades (cidade, estado) values ('Adamantina', 'SP');
Insert into Cidades (cidade, estado) values ('Adolfo', 'SP');
Insert into Cidades (cidade, estado) values ('Aguaí', 'SP');
Insert into Cidades (cidade, estado) values ('Águas da Prata', 'SP');
Insert into Cidades (cidade, estado) values ('Águas de Lindóia', 'SP');
Insert into Cidades (cidade, estado) values ('Águas de Santa Bárbara', 'SP');
Insert into Cidades (cidade, estado) values ('Águas de São Pedro', 'SP');
Insert into Cidades (cidade, estado) values ('Agudos', 'SP');
Insert into Cidades (cidade, estado) values ('Alambari', 'SP');
Insert into Cidades (cidade, estado) values ('Alfredo Marcondes', 'SP');
Insert into Cidades (cidade, estado) values ('Altair', 'SP');
Insert into Cidades (cidade, estado) values ('Altinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Alto Alegre', 'SP');
Insert into Cidades (cidade, estado) values ('Alumínio', 'SP');
Insert into Cidades (cidade, estado) values ('Álvares Florence', 'SP');
Insert into Cidades (cidade, estado) values ('Álvares Machado', 'SP');
Insert into Cidades (cidade, estado) values ('Álvaro de Carvalho', 'SP');
Insert into Cidades (cidade, estado) values ('Alvinlândia', 'SP');
Insert into Cidades (cidade, estado) values ('Americana', 'SP');
Insert into Cidades (cidade, estado) values ('Américo Brasiliense', 'SP');
Insert into Cidades (cidade, estado) values ('Américo de Campos', 'SP');
Insert into Cidades (cidade, estado) values ('Amparo', 'SP');
Insert into Cidades (cidade, estado) values ('Analândia', 'SP');
Insert into Cidades (cidade, estado) values ('Andradina', 'SP');
Insert into Cidades (cidade, estado) values ('Angatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Anhembi', 'SP');
Insert into Cidades (cidade, estado) values ('Anhumas', 'SP');
Insert into Cidades (cidade, estado) values ('Aparecida', 'SP');
Insert into Cidades (cidade, estado) values ('Aparecida D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Apiaí', 'SP');
Insert into Cidades (cidade, estado) values ('Araçariguama', 'SP');
Insert into Cidades (cidade, estado) values ('Araçatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Araçoiaba da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Aramina', 'SP');
Insert into Cidades (cidade, estado) values ('Arandu', 'SP');
Insert into Cidades (cidade, estado) values ('Arapeí', 'SP');
Insert into Cidades (cidade, estado) values ('Araraquara', 'SP');
Insert into Cidades (cidade, estado) values ('Araras', 'SP');
Insert into Cidades (cidade, estado) values ('Arco-Íris', 'SP');
Insert into Cidades (cidade, estado) values ('Arealva', 'SP');
Insert into Cidades (cidade, estado) values ('Areias', 'SP');
Insert into Cidades (cidade, estado) values ('Areiópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Ariranha', 'SP');
Insert into Cidades (cidade, estado) values ('Artur Nogueira', 'SP');
Insert into Cidades (cidade, estado) values ('Arujá', 'SP');
Insert into Cidades (cidade, estado) values ('Aspásia', 'SP');
Insert into Cidades (cidade, estado) values ('Assis', 'SP');
Insert into Cidades (cidade, estado) values ('Atibaia', 'SP');
Insert into Cidades (cidade, estado) values ('Auriflama', 'SP');
Insert into Cidades (cidade, estado) values ('Avaí', 'SP');
Insert into Cidades (cidade, estado) values ('Avanhandava', 'SP');
Insert into Cidades (cidade, estado) values ('Avaré', 'SP');
Insert into Cidades (cidade, estado) values ('Bady Bassitt', 'SP');
Insert into Cidades (cidade, estado) values ('Balbinos', 'SP');
Insert into Cidades (cidade, estado) values ('Bálsamo', 'SP');
Insert into Cidades (cidade, estado) values ('Bananal', 'SP');
Insert into Cidades (cidade, estado) values ('Barão de Antonina', 'SP');
Insert into Cidades (cidade, estado) values ('Barbosa', 'SP');
Insert into Cidades (cidade, estado) values ('Bariri', 'SP');
Insert into Cidades (cidade, estado) values ('Barra Bonita', 'SP');
Insert into Cidades (cidade, estado) values ('Barra do Chapéu', 'SP');
Insert into Cidades (cidade, estado) values ('Barra do Turvo', 'SP');
Insert into Cidades (cidade, estado) values ('Barretos', 'SP');
Insert into Cidades (cidade, estado) values ('Barrinha', 'SP');
Insert into Cidades (cidade, estado) values ('Barueri', 'SP');
Insert into Cidades (cidade, estado) values ('Bastos', 'SP');
Insert into Cidades (cidade, estado) values ('Batatais', 'SP');
Insert into Cidades (cidade, estado) values ('Bauru', 'SP');
Insert into Cidades (cidade, estado) values ('Bebedouro', 'SP');
Insert into Cidades (cidade, estado) values ('Bento de Abreu', 'SP');
Insert into Cidades (cidade, estado) values ('Bernardino de Campos', 'SP');
Insert into Cidades (cidade, estado) values ('Bertioga', 'SP');
Insert into Cidades (cidade, estado) values ('Bilac', 'SP');
Insert into Cidades (cidade, estado) values ('Birigui', 'SP');
Insert into Cidades (cidade, estado) values ('Biritiba-Mirim', 'SP');
Insert into Cidades (cidade, estado) values ('Boa Esperança do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Bocaina', 'SP');
Insert into Cidades (cidade, estado) values ('Bofete', 'SP');
Insert into Cidades (cidade, estado) values ('Boituva', 'SP');
Insert into Cidades (cidade, estado) values ('Bom Jesus dos Perdões', 'SP');
Insert into Cidades (cidade, estado) values ('Bom Sucesso de Itararé', 'SP');
Insert into Cidades (cidade, estado) values ('Borá', 'SP');
Insert into Cidades (cidade, estado) values ('Boracéia', 'SP');
Insert into Cidades (cidade, estado) values ('Borborema', 'SP');
Insert into Cidades (cidade, estado) values ('Borebi', 'SP');
Insert into Cidades (cidade, estado) values ('Botucatu', 'SP');
Insert into Cidades (cidade, estado) values ('Bragança Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Braúna', 'SP');
Insert into Cidades (cidade, estado) values ('Brejo Alegre', 'SP');
Insert into Cidades (cidade, estado) values ('Brodowski', 'SP');
Insert into Cidades (cidade, estado) values ('Brotas', 'SP');
Insert into Cidades (cidade, estado) values ('Buri', 'SP');
Insert into Cidades (cidade, estado) values ('Buritama', 'SP');
Insert into Cidades (cidade, estado) values ('Buritizal', 'SP');
Insert into Cidades (cidade, estado) values ('Cabrália Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Cabreúva', 'SP');
Insert into Cidades (cidade, estado) values ('Caçapava', 'SP');
Insert into Cidades (cidade, estado) values ('Cachoeira Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Caconde', 'SP');
Insert into Cidades (cidade, estado) values ('Cafelândia', 'SP');
Insert into Cidades (cidade, estado) values ('Caiabu', 'SP');
Insert into Cidades (cidade, estado) values ('Caieiras', 'SP');
Insert into Cidades (cidade, estado) values ('Caiuá', 'SP');
Insert into Cidades (cidade, estado) values ('Cajamar', 'SP');
Insert into Cidades (cidade, estado) values ('Cajati', 'SP');
Insert into Cidades (cidade, estado) values ('Cajobi', 'SP');
Insert into Cidades (cidade, estado) values ('Cajuru', 'SP');
Insert into Cidades (cidade, estado) values ('Campina do Monte Alegre', 'SP');
Insert into Cidades (cidade, estado) values ('Campinas', 'SP');
Insert into Cidades (cidade, estado) values ('Campo Limpo Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Campos do Jordão', 'SP');
Insert into Cidades (cidade, estado) values ('Campos Novos Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Cananéia', 'SP');
Insert into Cidades (cidade, estado) values ('Canas', 'SP');
Insert into Cidades (cidade, estado) values ('Cândido Mota', 'SP');
Insert into Cidades (cidade, estado) values ('Cândido Rodrigues', 'SP');
Insert into Cidades (cidade, estado) values ('Canitar', 'SP');
Insert into Cidades (cidade, estado) values ('Capão Bonito', 'SP');
Insert into Cidades (cidade, estado) values ('Capela do Alto', 'SP');
Insert into Cidades (cidade, estado) values ('Capivari', 'SP');
Insert into Cidades (cidade, estado) values ('Caraguatatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Carapicuíba', 'SP');
Insert into Cidades (cidade, estado) values ('Cardoso', 'SP');
Insert into Cidades (cidade, estado) values ('Casa Branca', 'SP');
Insert into Cidades (cidade, estado) values ('Cássia dos Coqueiros', 'SP');
Insert into Cidades (cidade, estado) values ('Castilho', 'SP');
Insert into Cidades (cidade, estado) values ('Catanduva', 'SP');
Insert into Cidades (cidade, estado) values ('Catiguá', 'SP');
Insert into Cidades (cidade, estado) values ('Cedral', 'SP');
Insert into Cidades (cidade, estado) values ('Cerqueira César', 'SP');
Insert into Cidades (cidade, estado) values ('Cerquilho', 'SP');
Insert into Cidades (cidade, estado) values ('Cesário Lange', 'SP');
Insert into Cidades (cidade, estado) values ('Charqueada', 'SP');
Insert into Cidades (cidade, estado) values ('Clementina', 'SP');
Insert into Cidades (cidade, estado) values ('Colina', 'SP');
Insert into Cidades (cidade, estado) values ('Colômbia', 'SP');
Insert into Cidades (cidade, estado) values ('Conchal', 'SP');
Insert into Cidades (cidade, estado) values ('Conchas', 'SP');
Insert into Cidades (cidade, estado) values ('Cordeirópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Coroados', 'SP');
Insert into Cidades (cidade, estado) values ('Coronel Macedo', 'SP');
Insert into Cidades (cidade, estado) values ('Corumbataí', 'SP');
Insert into Cidades (cidade, estado) values ('Cosmópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Cosmorama', 'SP');
Insert into Cidades (cidade, estado) values ('Cotia', 'SP');
Insert into Cidades (cidade, estado) values ('Cravinhos', 'SP');
Insert into Cidades (cidade, estado) values ('Cristais Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Cruzália', 'SP');
Insert into Cidades (cidade, estado) values ('Cruzeiro', 'SP');
Insert into Cidades (cidade, estado) values ('Cubatão', 'SP');
Insert into Cidades (cidade, estado) values ('Cunha', 'SP');
Insert into Cidades (cidade, estado) values ('Descalvado', 'SP');
Insert into Cidades (cidade, estado) values ('Diadema', 'SP');
Insert into Cidades (cidade, estado) values ('Dirce Reis', 'SP');
Insert into Cidades (cidade, estado) values ('Divinolândia', 'SP');
Insert into Cidades (cidade, estado) values ('Dobrada', 'SP');
Insert into Cidades (cidade, estado) values ('Dois Córregos', 'SP');
Insert into Cidades (cidade, estado) values ('Dolcinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Dourado', 'SP');
Insert into Cidades (cidade, estado) values ('Dracena', 'SP');
Insert into Cidades (cidade, estado) values ('Duartina', 'SP');
Insert into Cidades (cidade, estado) values ('Dumont', 'SP');
Insert into Cidades (cidade, estado) values ('Echaporã', 'SP');
Insert into Cidades (cidade, estado) values ('Eldorado', 'SP');
Insert into Cidades (cidade, estado) values ('Elias Fausto', 'SP');
Insert into Cidades (cidade, estado) values ('Elisiário', 'SP');
Insert into Cidades (cidade, estado) values ('Embaúba', 'SP');
Insert into Cidades (cidade, estado) values ('Embu das Artes', 'SP');
Insert into Cidades (cidade, estado) values ('Embu-Guaçu', 'SP');
Insert into Cidades (cidade, estado) values ('Emilianópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Engenheiro Coelho', 'SP');
Insert into Cidades (cidade, estado) values ('Espírito Santo do Pinhal', 'SP');
Insert into Cidades (cidade, estado) values ('Espírito Santo do Turvo', 'SP');
Insert into Cidades (cidade, estado) values ('Estrela D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Estrela do Norte', 'SP');
Insert into Cidades (cidade, estado) values ('Euclides da Cunha Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Fartura', 'SP');
Insert into Cidades (cidade, estado) values ('Fernandópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Fernando Prestes', 'SP');
Insert into Cidades (cidade, estado) values ('Fernão', 'SP');
Insert into Cidades (cidade, estado) values ('Ferraz de Vasconcelos', 'SP');
Insert into Cidades (cidade, estado) values ('Flora Rica', 'SP');
Insert into Cidades (cidade, estado) values ('Floreal', 'SP');
Insert into Cidades (cidade, estado) values ('Flórida Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Florínia', 'SP');
Insert into Cidades (cidade, estado) values ('Franca', 'SP');
Insert into Cidades (cidade, estado) values ('Francisco Morato', 'SP');
Insert into Cidades (cidade, estado) values ('Franco da Rocha', 'SP');
Insert into Cidades (cidade, estado) values ('Gabriel Monteiro', 'SP');
Insert into Cidades (cidade, estado) values ('Gália', 'SP');
Insert into Cidades (cidade, estado) values ('Garça', 'SP');
Insert into Cidades (cidade, estado) values ('Gastão Vidigal', 'SP');
Insert into Cidades (cidade, estado) values ('Gavião Peixoto', 'SP');
Insert into Cidades (cidade, estado) values ('General Salgado', 'SP');
Insert into Cidades (cidade, estado) values ('Getulina', 'SP');
Insert into Cidades (cidade, estado) values ('Glicério', 'SP');
Insert into Cidades (cidade, estado) values ('Guaiçara', 'SP');
Insert into Cidades (cidade, estado) values ('Guaimbê', 'SP');
Insert into Cidades (cidade, estado) values ('Guaíra', 'SP');
Insert into Cidades (cidade, estado) values ('Guapiaçu', 'SP');
Insert into Cidades (cidade, estado) values ('Guapiara', 'SP');
Insert into Cidades (cidade, estado) values ('Guará', 'SP');
Insert into Cidades (cidade, estado) values ('Guaraçaí', 'SP');
Insert into Cidades (cidade, estado) values ('Guaraci', 'SP');
Insert into Cidades (cidade, estado) values ('Guarani D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Guarantã', 'SP');
Insert into Cidades (cidade, estado) values ('Guararapes', 'SP');
Insert into Cidades (cidade, estado) values ('Guararema', 'SP');
Insert into Cidades (cidade, estado) values ('Guaratinguetá', 'SP');
Insert into Cidades (cidade, estado) values ('Guareí', 'SP');
Insert into Cidades (cidade, estado) values ('Guariba', 'SP');
Insert into Cidades (cidade, estado) values ('Guarujá', 'SP');
Insert into Cidades (cidade, estado) values ('Guarulhos', 'SP');
Insert into Cidades (cidade, estado) values ('Guatapará', 'SP');
Insert into Cidades (cidade, estado) values ('Guzolândia', 'SP');
Insert into Cidades (cidade, estado) values ('Herculândia', 'SP');
Insert into Cidades (cidade, estado) values ('Holambra', 'SP');
Insert into Cidades (cidade, estado) values ('Hortolândia', 'SP');
Insert into Cidades (cidade, estado) values ('Iacanga', 'SP');
Insert into Cidades (cidade, estado) values ('Iacri', 'SP');
Insert into Cidades (cidade, estado) values ('Iaras', 'SP');
Insert into Cidades (cidade, estado) values ('Ibaté', 'SP');
Insert into Cidades (cidade, estado) values ('Ibirá', 'SP');
Insert into Cidades (cidade, estado) values ('Ibirarema', 'SP');
Insert into Cidades (cidade, estado) values ('Ibitinga', 'SP');
Insert into Cidades (cidade, estado) values ('Ibiúna', 'SP');
Insert into Cidades (cidade, estado) values ('Icém', 'SP');
Insert into Cidades (cidade, estado) values ('Iepê', 'SP');
Insert into Cidades (cidade, estado) values ('Igaraçu do Tietê', 'SP');
Insert into Cidades (cidade, estado) values ('Igarapava', 'SP');
Insert into Cidades (cidade, estado) values ('Igaratá', 'SP');
Insert into Cidades (cidade, estado) values ('Iguape', 'SP');
Insert into Cidades (cidade, estado) values ('Ilhabela', 'SP');
Insert into Cidades (cidade, estado) values ('Ilha Comprida', 'SP');
Insert into Cidades (cidade, estado) values ('Ilha Solteira', 'SP');
Insert into Cidades (cidade, estado) values ('Indaiatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Indiana', 'SP');
Insert into Cidades (cidade, estado) values ('Indiaporã', 'SP');
Insert into Cidades (cidade, estado) values ('Inúbia Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Ipaussu', 'SP');
Insert into Cidades (cidade, estado) values ('Iperó', 'SP');
Insert into Cidades (cidade, estado) values ('Ipeúna', 'SP');
Insert into Cidades (cidade, estado) values ('Ipiguá', 'SP');
Insert into Cidades (cidade, estado) values ('Iporanga', 'SP');
Insert into Cidades (cidade, estado) values ('Ipuã', 'SP');
Insert into Cidades (cidade, estado) values ('Iracemápolis', 'SP');
Insert into Cidades (cidade, estado) values ('Irapuã', 'SP');
Insert into Cidades (cidade, estado) values ('Irapuru', 'SP');
Insert into Cidades (cidade, estado) values ('Itaberá', 'SP');
Insert into Cidades (cidade, estado) values ('Itaí', 'SP');
Insert into Cidades (cidade, estado) values ('Itajobi', 'SP');
Insert into Cidades (cidade, estado) values ('Itaju', 'SP');
Insert into Cidades (cidade, estado) values ('Itanhaém', 'SP');
Insert into Cidades (cidade, estado) values ('Itaóca', 'SP');
Insert into Cidades (cidade, estado) values ('Itapecerica da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Itapetininga', 'SP');
Insert into Cidades (cidade, estado) values ('Itapeva', 'SP');
Insert into Cidades (cidade, estado) values ('Itapevi', 'SP');
Insert into Cidades (cidade, estado) values ('Itapira', 'SP');
Insert into Cidades (cidade, estado) values ('Itapirapuã Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Itápolis', 'SP');
Insert into Cidades (cidade, estado) values ('Itaporanga', 'SP');
Insert into Cidades (cidade, estado) values ('Itapuí', 'SP');
Insert into Cidades (cidade, estado) values ('Itapura', 'SP');
Insert into Cidades (cidade, estado) values ('Itaquaquecetuba', 'SP');
Insert into Cidades (cidade, estado) values ('Itararé', 'SP');
Insert into Cidades (cidade, estado) values ('Itariri', 'SP');
Insert into Cidades (cidade, estado) values ('Itatiba', 'SP');
Insert into Cidades (cidade, estado) values ('Itatinga', 'SP');
Insert into Cidades (cidade, estado) values ('Itirapina', 'SP');
Insert into Cidades (cidade, estado) values ('Itirapuã', 'SP');
Insert into Cidades (cidade, estado) values ('Itobi', 'SP');
Insert into Cidades (cidade, estado) values ('Itu', 'SP');
Insert into Cidades (cidade, estado) values ('Itupeva', 'SP');
Insert into Cidades (cidade, estado) values ('Ituverava', 'SP');
Insert into Cidades (cidade, estado) values ('Jaborandi', 'SP');
Insert into Cidades (cidade, estado) values ('Jaboticabal', 'SP');
Insert into Cidades (cidade, estado) values ('Jacareí', 'SP');
Insert into Cidades (cidade, estado) values ('Jaci', 'SP');
Insert into Cidades (cidade, estado) values ('Jacupiranga', 'SP');
Insert into Cidades (cidade, estado) values ('Jaguariúna', 'SP');
Insert into Cidades (cidade, estado) values ('Jales', 'SP');
Insert into Cidades (cidade, estado) values ('Jambeiro', 'SP');
Insert into Cidades (cidade, estado) values ('Jandira', 'SP');
Insert into Cidades (cidade, estado) values ('Jardinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Jarinu', 'SP');
Insert into Cidades (cidade, estado) values ('Jaú', 'SP');
Insert into Cidades (cidade, estado) values ('Jeriquara', 'SP');
Insert into Cidades (cidade, estado) values ('Joanópolis', 'SP');
Insert into Cidades (cidade, estado) values ('João Ramalho', 'SP');
Insert into Cidades (cidade, estado) values ('José Bonifácio', 'SP');
Insert into Cidades (cidade, estado) values ('Júlio Mesquita', 'SP');
Insert into Cidades (cidade, estado) values ('Jumirim', 'SP');
Insert into Cidades (cidade, estado) values ('Jundiaí', 'SP');
Insert into Cidades (cidade, estado) values ('Junqueirópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Juquiá', 'SP');
Insert into Cidades (cidade, estado) values ('Juquitiba', 'SP');
Insert into Cidades (cidade, estado) values ('Lagoinha', 'SP');
Insert into Cidades (cidade, estado) values ('Laranjal Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Lavínia', 'SP');
Insert into Cidades (cidade, estado) values ('Lavrinhas', 'SP');
Insert into Cidades (cidade, estado) values ('Leme', 'SP');
Insert into Cidades (cidade, estado) values ('Lençóis Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Limeira', 'SP');
Insert into Cidades (cidade, estado) values ('Lindóia', 'SP');
Insert into Cidades (cidade, estado) values ('Lins', 'SP');
Insert into Cidades (cidade, estado) values ('Lorena', 'SP');
Insert into Cidades (cidade, estado) values ('Lourdes', 'SP');
Insert into Cidades (cidade, estado) values ('Louveira', 'SP');
Insert into Cidades (cidade, estado) values ('Lucélia', 'SP');
Insert into Cidades (cidade, estado) values ('Lucianópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Luís Antônio', 'SP');
Insert into Cidades (cidade, estado) values ('Luiziânia', 'SP');
Insert into Cidades (cidade, estado) values ('Lupércio', 'SP');
Insert into Cidades (cidade, estado) values ('Lutécia', 'SP');
Insert into Cidades (cidade, estado) values ('Macatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Macaubal', 'SP');
Insert into Cidades (cidade, estado) values ('Macedônia', 'SP');
Insert into Cidades (cidade, estado) values ('Magda', 'SP');
Insert into Cidades (cidade, estado) values ('Mairinque', 'SP');
Insert into Cidades (cidade, estado) values ('Mairiporã', 'SP');
Insert into Cidades (cidade, estado) values ('Manduri', 'SP');
Insert into Cidades (cidade, estado) values ('Marabá Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Maracaí', 'SP');
Insert into Cidades (cidade, estado) values ('Marapoama', 'SP');
Insert into Cidades (cidade, estado) values ('Mariápolis', 'SP');
Insert into Cidades (cidade, estado) values ('Marília', 'SP');
Insert into Cidades (cidade, estado) values ('Marinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Martinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Matão', 'SP');
Insert into Cidades (cidade, estado) values ('Mauá', 'SP');
Insert into Cidades (cidade, estado) values ('Mendonça', 'SP');
Insert into Cidades (cidade, estado) values ('Meridiano', 'SP');
Insert into Cidades (cidade, estado) values ('Mesópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Miguelópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Mineiros do Tietê', 'SP');
Insert into Cidades (cidade, estado) values ('Miracatu', 'SP');
Insert into Cidades (cidade, estado) values ('Mira Estrela', 'SP');
Insert into Cidades (cidade, estado) values ('Mirandópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Mirante do Paranapanema', 'SP');
Insert into Cidades (cidade, estado) values ('Mirassol', 'SP');
Insert into Cidades (cidade, estado) values ('Mirassolândia', 'SP');
Insert into Cidades (cidade, estado) values ('Mococa', 'SP');
Insert into Cidades (cidade, estado) values ('Mogi das Cruzes', 'SP');
Insert into Cidades (cidade, estado) values ('Mogi Guaçu', 'SP');
Insert into Cidades (cidade, estado) values ('Moji Mirim', 'SP');
Insert into Cidades (cidade, estado) values ('Mombuca', 'SP');
Insert into Cidades (cidade, estado) values ('Monções', 'SP');
Insert into Cidades (cidade, estado) values ('Mongaguá', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Alegre do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Alto', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Aprazível', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Azul Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Castelo', 'SP');
Insert into Cidades (cidade, estado) values ('Monteiro Lobato', 'SP');
Insert into Cidades (cidade, estado) values ('Monte Mor', 'SP');
Insert into Cidades (cidade, estado) values ('Morro Agudo', 'SP');
Insert into Cidades (cidade, estado) values ('Morungaba', 'SP');
Insert into Cidades (cidade, estado) values ('Motuca', 'SP');
Insert into Cidades (cidade, estado) values ('Murutinga do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Nantes', 'SP');
Insert into Cidades (cidade, estado) values ('Narandiba', 'SP');
Insert into Cidades (cidade, estado) values ('Natividade da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Nazaré Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Neves Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Nhandeara', 'SP');
Insert into Cidades (cidade, estado) values ('Nipoã', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Aliança', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Campina', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Canaã Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Castilho', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Europa', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Granada', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Guataporanga', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Independência', 'SP');
Insert into Cidades (cidade, estado) values ('Novais', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Luzitânia', 'SP');
Insert into Cidades (cidade, estado) values ('Nova Odessa', 'SP');
Insert into Cidades (cidade, estado) values ('Novo Horizonte', 'SP');
Insert into Cidades (cidade, estado) values ('Nuporanga', 'SP');
Insert into Cidades (cidade, estado) values ('Ocauçu', 'SP');
Insert into Cidades (cidade, estado) values ('Óleo', 'SP');
Insert into Cidades (cidade, estado) values ('Olímpia', 'SP');
Insert into Cidades (cidade, estado) values ('Onda Verde', 'SP');
Insert into Cidades (cidade, estado) values ('Oriente', 'SP');
Insert into Cidades (cidade, estado) values ('Orindiúva', 'SP');
Insert into Cidades (cidade, estado) values ('Orlândia', 'SP');
Insert into Cidades (cidade, estado) values ('Osasco', 'SP');
Insert into Cidades (cidade, estado) values ('Oscar Bressane', 'SP');
Insert into Cidades (cidade, estado) values ('Osvaldo Cruz', 'SP');
Insert into Cidades (cidade, estado) values ('Ourinhos', 'SP');
Insert into Cidades (cidade, estado) values ('Ouroeste', 'SP');
Insert into Cidades (cidade, estado) values ('Ouro Verde', 'SP');
Insert into Cidades (cidade, estado) values ('Pacaembu', 'SP');
Insert into Cidades (cidade, estado) values ('Palestina', 'SP');
Insert into Cidades (cidade, estado) values ('Palmares Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Palmeira D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Palmital', 'SP');
Insert into Cidades (cidade, estado) values ('Panorama', 'SP');
Insert into Cidades (cidade, estado) values ('Paraguaçu Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Paraibuna', 'SP');
Insert into Cidades (cidade, estado) values ('Paraíso', 'SP');
Insert into Cidades (cidade, estado) values ('Paranapanema', 'SP');
Insert into Cidades (cidade, estado) values ('Paranapuã', 'SP');
Insert into Cidades (cidade, estado) values ('Parapuã', 'SP');
Insert into Cidades (cidade, estado) values ('Pardinho', 'SP');
Insert into Cidades (cidade, estado) values ('Pariquera-Açu', 'SP');
Insert into Cidades (cidade, estado) values ('Parisi', 'SP');
Insert into Cidades (cidade, estado) values ('Patrocínio Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Paulicéia', 'SP');
Insert into Cidades (cidade, estado) values ('Paulínia', 'SP');
Insert into Cidades (cidade, estado) values ('Paulistânia', 'SP');
Insert into Cidades (cidade, estado) values ('Paulo de Faria', 'SP');
Insert into Cidades (cidade, estado) values ('Pederneiras', 'SP');
Insert into Cidades (cidade, estado) values ('Pedra Bela', 'SP');
Insert into Cidades (cidade, estado) values ('Pedranópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Pedregulho', 'SP');
Insert into Cidades (cidade, estado) values ('Pedreira', 'SP');
Insert into Cidades (cidade, estado) values ('Pedrinhas Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Pedro de Toledo', 'SP');
Insert into Cidades (cidade, estado) values ('Penápolis', 'SP');
Insert into Cidades (cidade, estado) values ('Pereira Barreto', 'SP');
Insert into Cidades (cidade, estado) values ('Pereiras', 'SP');
Insert into Cidades (cidade, estado) values ('Peruíbe', 'SP');
Insert into Cidades (cidade, estado) values ('Piacatu', 'SP');
Insert into Cidades (cidade, estado) values ('Piedade', 'SP');
Insert into Cidades (cidade, estado) values ('Pilar do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Pindamonhangaba', 'SP');
Insert into Cidades (cidade, estado) values ('Pindorama', 'SP');
Insert into Cidades (cidade, estado) values ('Pinhalzinho', 'SP');
Insert into Cidades (cidade, estado) values ('Piquerobi', 'SP');
Insert into Cidades (cidade, estado) values ('Piquete', 'SP');
Insert into Cidades (cidade, estado) values ('Piracaia', 'SP');
Insert into Cidades (cidade, estado) values ('Piracicaba', 'SP');
Insert into Cidades (cidade, estado) values ('Piraju', 'SP');
Insert into Cidades (cidade, estado) values ('Pirajuí', 'SP');
Insert into Cidades (cidade, estado) values ('Pirangi', 'SP');
Insert into Cidades (cidade, estado) values ('Pirapora do Bom Jesus', 'SP');
Insert into Cidades (cidade, estado) values ('Pirapozinho', 'SP');
Insert into Cidades (cidade, estado) values ('Pirassununga', 'SP');
Insert into Cidades (cidade, estado) values ('Piratininga', 'SP');
Insert into Cidades (cidade, estado) values ('Pitangueiras', 'SP');
Insert into Cidades (cidade, estado) values ('Planalto', 'SP');
Insert into Cidades (cidade, estado) values ('Platina', 'SP');
Insert into Cidades (cidade, estado) values ('Poá', 'SP');
Insert into Cidades (cidade, estado) values ('Poloni', 'SP');
Insert into Cidades (cidade, estado) values ('Pompéia', 'SP');
Insert into Cidades (cidade, estado) values ('Pongaí', 'SP');
Insert into Cidades (cidade, estado) values ('Pontal', 'SP');
Insert into Cidades (cidade, estado) values ('Pontalinda', 'SP');
Insert into Cidades (cidade, estado) values ('Pontes Gestal', 'SP');
Insert into Cidades (cidade, estado) values ('Populina', 'SP');
Insert into Cidades (cidade, estado) values ('Porangaba', 'SP');
Insert into Cidades (cidade, estado) values ('Porto Feliz', 'SP');
Insert into Cidades (cidade, estado) values ('Porto Ferreira', 'SP');
Insert into Cidades (cidade, estado) values ('Potim', 'SP');
Insert into Cidades (cidade, estado) values ('Potirendaba', 'SP');
Insert into Cidades (cidade, estado) values ('Pracinha', 'SP');
Insert into Cidades (cidade, estado) values ('Pradópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Praia Grande', 'SP');
Insert into Cidades (cidade, estado) values ('Pratânia', 'SP');
Insert into Cidades (cidade, estado) values ('Presidente Alves', 'SP');
Insert into Cidades (cidade, estado) values ('Presidente Bernardes', 'SP');
Insert into Cidades (cidade, estado) values ('Presidente Epitácio', 'SP');
Insert into Cidades (cidade, estado) values ('Presidente Prudente', 'SP');
Insert into Cidades (cidade, estado) values ('Presidente Venceslau', 'SP');
Insert into Cidades (cidade, estado) values ('Promissão', 'SP');
Insert into Cidades (cidade, estado) values ('Quadra', 'SP');
Insert into Cidades (cidade, estado) values ('Quatá', 'SP');
Insert into Cidades (cidade, estado) values ('Queiroz', 'SP');
Insert into Cidades (cidade, estado) values ('Queluz', 'SP');
Insert into Cidades (cidade, estado) values ('Quintana', 'SP');
Insert into Cidades (cidade, estado) values ('Rafard', 'SP');
Insert into Cidades (cidade, estado) values ('Rancharia', 'SP');
Insert into Cidades (cidade, estado) values ('Redenção da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Regente Feijó', 'SP');
Insert into Cidades (cidade, estado) values ('Reginópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Registro', 'SP');
Insert into Cidades (cidade, estado) values ('Restinga', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeira', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Bonito', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Branco', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Corrente', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão dos Índios', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Grande', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Pires', 'SP');
Insert into Cidades (cidade, estado) values ('Ribeirão Preto', 'SP');
Insert into Cidades (cidade, estado) values ('Riversul', 'SP');
Insert into Cidades (cidade, estado) values ('Rifaina', 'SP');
Insert into Cidades (cidade, estado) values ('Rincão', 'SP');
Insert into Cidades (cidade, estado) values ('Rinópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Rio Claro', 'SP');
Insert into Cidades (cidade, estado) values ('Rio das Pedras', 'SP');
Insert into Cidades (cidade, estado) values ('Rio Grande da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Riolândia', 'SP');
Insert into Cidades (cidade, estado) values ('Rosana', 'SP');
Insert into Cidades (cidade, estado) values ('Roseira', 'SP');
Insert into Cidades (cidade, estado) values ('Rubiácea', 'SP');
Insert into Cidades (cidade, estado) values ('Rubinéia', 'SP');
Insert into Cidades (cidade, estado) values ('Sabino', 'SP');
Insert into Cidades (cidade, estado) values ('Sagres', 'SP');
Insert into Cidades (cidade, estado) values ('Sales', 'SP');
Insert into Cidades (cidade, estado) values ('Sales Oliveira', 'SP');
Insert into Cidades (cidade, estado) values ('Salesópolis', 'SP');
Insert into Cidades (cidade, estado) values ('Salmourão', 'SP');
Insert into Cidades (cidade, estado) values ('Saltinho', 'SP');
Insert into Cidades (cidade, estado) values ('Salto', 'SP');
Insert into Cidades (cidade, estado) values ('Salto de Pirapora', 'SP');
Insert into Cidades (cidade, estado) values ('Salto Grande', 'SP');
Insert into Cidades (cidade, estado) values ('Sandovalina', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Adélia', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Albertina', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Bárbara D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Branca', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Clara D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Cruz da Conceição', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Cruz da Esperança', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Cruz das Palmeiras', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Rio Pardo', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Ernestina', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Fé do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Gertrudes', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Isabel', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Lúcia', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Maria da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Mercedes', 'SP');
Insert into Cidades (cidade, estado) values ('Santana da Ponte Pensa', 'SP');
Insert into Cidades (cidade, estado) values ('Santana de Parnaíba', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Rita D''Oeste', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Rita do Passa Quatro', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Rosa de Viterbo', 'SP');
Insert into Cidades (cidade, estado) values ('Santa Salete', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Anastácio', 'SP');
Insert into Cidades (cidade, estado) values ('Santo André', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Antônio da Alegria', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Antônio de Posse', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Aracanguá', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Jardim', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Pinhal', 'SP');
Insert into Cidades (cidade, estado) values ('Santo Expedito', 'SP');
Insert into Cidades (cidade, estado) values ('Santópolis do Aguapeí', 'SP');
Insert into Cidades (cidade, estado) values ('Santos', 'SP');
Insert into Cidades (cidade, estado) values ('São Bento do Sapucaí', 'SP');
Insert into Cidades (cidade, estado) values ('São Bernardo do Campo', 'SP');
Insert into Cidades (cidade, estado) values ('São Caetano do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('São Carlos', 'SP');
Insert into Cidades (cidade, estado) values ('São Francisco', 'SP');
Insert into Cidades (cidade, estado) values ('São João da Boa Vista', 'SP');
Insert into Cidades (cidade, estado) values ('São João das Duas Pontes', 'SP');
Insert into Cidades (cidade, estado) values ('São João de Iracema', 'SP');
Insert into Cidades (cidade, estado) values ('São João do Pau D''Alho', 'SP');
Insert into Cidades (cidade, estado) values ('São Joaquim da Barra', 'SP');
Insert into Cidades (cidade, estado) values ('São José da Bela Vista', 'SP');
Insert into Cidades (cidade, estado) values ('São José do Barreiro', 'SP');
Insert into Cidades (cidade, estado) values ('São José do Rio Pardo', 'SP');
Insert into Cidades (cidade, estado) values ('São José do Rio Preto', 'SP');
Insert into Cidades (cidade, estado) values ('São José dos Campos', 'SP');
Insert into Cidades (cidade, estado) values ('São Lourenço da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('São Luís do Paraitinga', 'SP');
Insert into Cidades (cidade, estado) values ('São Manuel', 'SP');
Insert into Cidades (cidade, estado) values ('São Miguel Arcanjo', 'SP');
Insert into Cidades (cidade, estado) values ('São Paulo', 'SP');
Insert into Cidades (cidade, estado) values ('São Pedro', 'SP');
Insert into Cidades (cidade, estado) values ('São Pedro do Turvo', 'SP');
Insert into Cidades (cidade, estado) values ('São Roque', 'SP');
Insert into Cidades (cidade, estado) values ('São Sebastião', 'SP');
Insert into Cidades (cidade, estado) values ('São Sebastião da Grama', 'SP');
Insert into Cidades (cidade, estado) values ('São Simão', 'SP');
Insert into Cidades (cidade, estado) values ('São Vicente', 'SP');
Insert into Cidades (cidade, estado) values ('Sarapuí', 'SP');
Insert into Cidades (cidade, estado) values ('Sarutaiá', 'SP');
Insert into Cidades (cidade, estado) values ('Sebastianópolis do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Serra Azul', 'SP');
Insert into Cidades (cidade, estado) values ('Serrana', 'SP');
Insert into Cidades (cidade, estado) values ('Serra Negra', 'SP');
Insert into Cidades (cidade, estado) values ('Sertãozinho', 'SP');
Insert into Cidades (cidade, estado) values ('Sete Barras', 'SP');
Insert into Cidades (cidade, estado) values ('Severínia', 'SP');
Insert into Cidades (cidade, estado) values ('Silveiras', 'SP');
Insert into Cidades (cidade, estado) values ('Socorro', 'SP');
Insert into Cidades (cidade, estado) values ('Sorocaba', 'SP');
Insert into Cidades (cidade, estado) values ('Sud Mennucci', 'SP');
Insert into Cidades (cidade, estado) values ('Sumaré', 'SP');
Insert into Cidades (cidade, estado) values ('Suzano', 'SP');
Insert into Cidades (cidade, estado) values ('Suzanápolis', 'SP');
Insert into Cidades (cidade, estado) values ('Tabapuã', 'SP');
Insert into Cidades (cidade, estado) values ('Tabatinga', 'SP');
Insert into Cidades (cidade, estado) values ('Taboão da Serra', 'SP');
Insert into Cidades (cidade, estado) values ('Taciba', 'SP');
Insert into Cidades (cidade, estado) values ('Taguaí', 'SP');
Insert into Cidades (cidade, estado) values ('Taiaçu', 'SP');
Insert into Cidades (cidade, estado) values ('Taiúva', 'SP');
Insert into Cidades (cidade, estado) values ('Tambaú', 'SP');
Insert into Cidades (cidade, estado) values ('Tanabi', 'SP');
Insert into Cidades (cidade, estado) values ('Tapiraí', 'SP');
Insert into Cidades (cidade, estado) values ('Tapiratiba', 'SP');
Insert into Cidades (cidade, estado) values ('Taquaral', 'SP');
Insert into Cidades (cidade, estado) values ('Taquaritinga', 'SP');
Insert into Cidades (cidade, estado) values ('Taquarituba', 'SP');
Insert into Cidades (cidade, estado) values ('Taquarivaí', 'SP');
Insert into Cidades (cidade, estado) values ('Tarabai', 'SP');
Insert into Cidades (cidade, estado) values ('Tarumã', 'SP');
Insert into Cidades (cidade, estado) values ('Tatuí', 'SP');
Insert into Cidades (cidade, estado) values ('Taubaté', 'SP');
Insert into Cidades (cidade, estado) values ('Tejupá', 'SP');
Insert into Cidades (cidade, estado) values ('Teodoro Sampaio', 'SP');
Insert into Cidades (cidade, estado) values ('Terra Roxa', 'SP');
Insert into Cidades (cidade, estado) values ('Tietê', 'SP');
Insert into Cidades (cidade, estado) values ('Timburi', 'SP');
Insert into Cidades (cidade, estado) values ('Torre de Pedra', 'SP');
Insert into Cidades (cidade, estado) values ('Torrinha', 'SP');
Insert into Cidades (cidade, estado) values ('Trabiju', 'SP');
Insert into Cidades (cidade, estado) values ('Tremembé', 'SP');
Insert into Cidades (cidade, estado) values ('Três Fronteiras', 'SP');
Insert into Cidades (cidade, estado) values ('Tuiuti', 'SP');
Insert into Cidades (cidade, estado) values ('Tupã', 'SP');
Insert into Cidades (cidade, estado) values ('Tupi Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Turiúba', 'SP');
Insert into Cidades (cidade, estado) values ('Turmalina', 'SP');
Insert into Cidades (cidade, estado) values ('Ubarana', 'SP');
Insert into Cidades (cidade, estado) values ('Ubatuba', 'SP');
Insert into Cidades (cidade, estado) values ('Ubirajara', 'SP');
Insert into Cidades (cidade, estado) values ('Uchoa', 'SP');
Insert into Cidades (cidade, estado) values ('União Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Urânia', 'SP');
Insert into Cidades (cidade, estado) values ('Uru', 'SP');
Insert into Cidades (cidade, estado) values ('Urupês', 'SP');
Insert into Cidades (cidade, estado) values ('Valentim Gentil', 'SP');
Insert into Cidades (cidade, estado) values ('Valinhos', 'SP');
Insert into Cidades (cidade, estado) values ('Valparaíso', 'SP');
Insert into Cidades (cidade, estado) values ('Vargem', 'SP');
Insert into Cidades (cidade, estado) values ('Vargem Grande do Sul', 'SP');
Insert into Cidades (cidade, estado) values ('Vargem Grande Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Várzea Paulista', 'SP');
Insert into Cidades (cidade, estado) values ('Vera Cruz', 'SP');
Insert into Cidades (cidade, estado) values ('Vinhedo', 'SP');
Insert into Cidades (cidade, estado) values ('Viradouro', 'SP');
Insert into Cidades (cidade, estado) values ('Vista Alegre do Alto', 'SP');
Insert into Cidades (cidade, estado) values ('Vitória Brasil', 'SP');
Insert into Cidades (cidade, estado) values ('Votorantim', 'SP');
Insert into Cidades (cidade, estado) values ('Votuporanga', 'SP');
Insert into Cidades (cidade, estado) values ('Zacarias', 'SP');
Insert into Cidades (cidade, estado) values ('Chavantes', 'SP');
Insert into Cidades (cidade, estado) values ('Estiva Gerbi', 'SP');
Insert into Cidades (cidade, estado) values ('Abatiá', 'PR');
Insert into Cidades (cidade, estado) values ('Adrianópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Agudos do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Almirante Tamandaré', 'PR');
Insert into Cidades (cidade, estado) values ('Altamira do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Altônia', 'PR');
Insert into Cidades (cidade, estado) values ('Alto Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Alto Piquiri', 'PR');
Insert into Cidades (cidade, estado) values ('Alvorada do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Amaporã', 'PR');
Insert into Cidades (cidade, estado) values ('Ampére', 'PR');
Insert into Cidades (cidade, estado) values ('Anahy', 'PR');
Insert into Cidades (cidade, estado) values ('Andirá', 'PR');
Insert into Cidades (cidade, estado) values ('Ângulo', 'PR');
Insert into Cidades (cidade, estado) values ('Antonina', 'PR');
Insert into Cidades (cidade, estado) values ('Antônio Olinto', 'PR');
Insert into Cidades (cidade, estado) values ('Apucarana', 'PR');
Insert into Cidades (cidade, estado) values ('Arapongas', 'PR');
Insert into Cidades (cidade, estado) values ('Arapoti', 'PR');
Insert into Cidades (cidade, estado) values ('Arapuã', 'PR');
Insert into Cidades (cidade, estado) values ('Araruna', 'PR');
Insert into Cidades (cidade, estado) values ('Araucária', 'PR');
Insert into Cidades (cidade, estado) values ('Ariranha do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Assaí', 'PR');
Insert into Cidades (cidade, estado) values ('Assis Chateaubriand', 'PR');
Insert into Cidades (cidade, estado) values ('Astorga', 'PR');
Insert into Cidades (cidade, estado) values ('Atalaia', 'PR');
Insert into Cidades (cidade, estado) values ('Balsa Nova', 'PR');
Insert into Cidades (cidade, estado) values ('Bandeirantes', 'PR');
Insert into Cidades (cidade, estado) values ('Barbosa Ferraz', 'PR');
Insert into Cidades (cidade, estado) values ('Barracão', 'PR');
Insert into Cidades (cidade, estado) values ('Barra do Jacaré', 'PR');
Insert into Cidades (cidade, estado) values ('Bela Vista da Caroba', 'PR');
Insert into Cidades (cidade, estado) values ('Bela Vista do Paraíso', 'PR');
Insert into Cidades (cidade, estado) values ('Bituruna', 'PR');
Insert into Cidades (cidade, estado) values ('Boa Esperança', 'PR');
Insert into Cidades (cidade, estado) values ('Boa Esperança do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Boa Ventura de São Roque', 'PR');
Insert into Cidades (cidade, estado) values ('Boa Vista da Aparecida', 'PR');
Insert into Cidades (cidade, estado) values ('Bocaiúva do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Bom Sucesso', 'PR');
Insert into Cidades (cidade, estado) values ('Bom Sucesso do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Borrazópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Braganey', 'PR');
Insert into Cidades (cidade, estado) values ('Brasilândia do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Cafeara', 'PR');
Insert into Cidades (cidade, estado) values ('Cafelândia', 'PR');
Insert into Cidades (cidade, estado) values ('Cafezal do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Califórnia', 'PR');
Insert into Cidades (cidade, estado) values ('Cambará', 'PR');
Insert into Cidades (cidade, estado) values ('Cambé', 'PR');
Insert into Cidades (cidade, estado) values ('Cambira', 'PR');
Insert into Cidades (cidade, estado) values ('Campina da Lagoa', 'PR');
Insert into Cidades (cidade, estado) values ('Campina do Simão', 'PR');
Insert into Cidades (cidade, estado) values ('Campina Grande do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Campo Bonito', 'PR');
Insert into Cidades (cidade, estado) values ('Campo do Tenente', 'PR');
Insert into Cidades (cidade, estado) values ('Campo Largo', 'PR');
Insert into Cidades (cidade, estado) values ('Campo Magro', 'PR');
Insert into Cidades (cidade, estado) values ('Campo Mourão', 'PR');
Insert into Cidades (cidade, estado) values ('Cândido de Abreu', 'PR');
Insert into Cidades (cidade, estado) values ('Candói', 'PR');
Insert into Cidades (cidade, estado) values ('Cantagalo', 'PR');
Insert into Cidades (cidade, estado) values ('Capanema', 'PR');
Insert into Cidades (cidade, estado) values ('Capitão Leônidas Marques', 'PR');
Insert into Cidades (cidade, estado) values ('Carambeí', 'PR');
Insert into Cidades (cidade, estado) values ('Carlópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Cascavel', 'PR');
Insert into Cidades (cidade, estado) values ('Castro', 'PR');
Insert into Cidades (cidade, estado) values ('Catanduvas', 'PR');
Insert into Cidades (cidade, estado) values ('Centenário do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Cerro Azul', 'PR');
Insert into Cidades (cidade, estado) values ('Céu Azul', 'PR');
Insert into Cidades (cidade, estado) values ('Chopinzinho', 'PR');
Insert into Cidades (cidade, estado) values ('Cianorte', 'PR');
Insert into Cidades (cidade, estado) values ('Cidade Gaúcha', 'PR');
Insert into Cidades (cidade, estado) values ('Clevelândia', 'PR');
Insert into Cidades (cidade, estado) values ('Colombo', 'PR');
Insert into Cidades (cidade, estado) values ('Colorado', 'PR');
Insert into Cidades (cidade, estado) values ('Congonhinhas', 'PR');
Insert into Cidades (cidade, estado) values ('Conselheiro Mairinck', 'PR');
Insert into Cidades (cidade, estado) values ('Contenda', 'PR');
Insert into Cidades (cidade, estado) values ('Corbélia', 'PR');
Insert into Cidades (cidade, estado) values ('Cornélio Procópio', 'PR');
Insert into Cidades (cidade, estado) values ('Coronel Domingos Soares', 'PR');
Insert into Cidades (cidade, estado) values ('Coronel Vivida', 'PR');
Insert into Cidades (cidade, estado) values ('Corumbataí do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Cruzeiro do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Cruzeiro do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Cruzeiro do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Cruz Machado', 'PR');
Insert into Cidades (cidade, estado) values ('Cruzmaltina', 'PR');
Insert into Cidades (cidade, estado) values ('Curitiba', 'PR');
Insert into Cidades (cidade, estado) values ('Curiúva', 'PR');
Insert into Cidades (cidade, estado) values ('Diamante do Norte', 'PR');
Insert into Cidades (cidade, estado) values ('Diamante do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Diamante D''Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Dois Vizinhos', 'PR');
Insert into Cidades (cidade, estado) values ('Douradina', 'PR');
Insert into Cidades (cidade, estado) values ('Doutor Camargo', 'PR');
Insert into Cidades (cidade, estado) values ('Enéas Marques', 'PR');
Insert into Cidades (cidade, estado) values ('Engenheiro Beltrão', 'PR');
Insert into Cidades (cidade, estado) values ('Esperança Nova', 'PR');
Insert into Cidades (cidade, estado) values ('Entre Rios do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Espigão Alto do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Farol', 'PR');
Insert into Cidades (cidade, estado) values ('Faxinal', 'PR');
Insert into Cidades (cidade, estado) values ('Fazenda Rio Grande', 'PR');
Insert into Cidades (cidade, estado) values ('Fênix', 'PR');
Insert into Cidades (cidade, estado) values ('Fernandes Pinheiro', 'PR');
Insert into Cidades (cidade, estado) values ('Figueira', 'PR');
Insert into Cidades (cidade, estado) values ('Floraí', 'PR');
Insert into Cidades (cidade, estado) values ('Flor da Serra do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Floresta', 'PR');
Insert into Cidades (cidade, estado) values ('Florestópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Flórida', 'PR');
Insert into Cidades (cidade, estado) values ('Formosa do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Foz do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Francisco Alves', 'PR');
Insert into Cidades (cidade, estado) values ('Francisco Beltrão', 'PR');
Insert into Cidades (cidade, estado) values ('Foz do Jordão', 'PR');
Insert into Cidades (cidade, estado) values ('General Carneiro', 'PR');
Insert into Cidades (cidade, estado) values ('Godoy Moreira', 'PR');
Insert into Cidades (cidade, estado) values ('Goioerê', 'PR');
Insert into Cidades (cidade, estado) values ('Goioxim', 'PR');
Insert into Cidades (cidade, estado) values ('Grandes Rios', 'PR');
Insert into Cidades (cidade, estado) values ('Guaíra', 'PR');
Insert into Cidades (cidade, estado) values ('Guairaçá', 'PR');
Insert into Cidades (cidade, estado) values ('Guamiranga', 'PR');
Insert into Cidades (cidade, estado) values ('Guapirama', 'PR');
Insert into Cidades (cidade, estado) values ('Guaporema', 'PR');
Insert into Cidades (cidade, estado) values ('Guaraci', 'PR');
Insert into Cidades (cidade, estado) values ('Guaraniaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Guarapuava', 'PR');
Insert into Cidades (cidade, estado) values ('Guaraqueçaba', 'PR');
Insert into Cidades (cidade, estado) values ('Guaratuba', 'PR');
Insert into Cidades (cidade, estado) values ('Honório Serpa', 'PR');
Insert into Cidades (cidade, estado) values ('Ibaiti', 'PR');
Insert into Cidades (cidade, estado) values ('Ibema', 'PR');
Insert into Cidades (cidade, estado) values ('Ibiporã', 'PR');
Insert into Cidades (cidade, estado) values ('Icaraíma', 'PR');
Insert into Cidades (cidade, estado) values ('Iguaraçu', 'PR');
Insert into Cidades (cidade, estado) values ('Iguatu', 'PR');
Insert into Cidades (cidade, estado) values ('Imbaú', 'PR');
Insert into Cidades (cidade, estado) values ('Imbituva', 'PR');
Insert into Cidades (cidade, estado) values ('Inácio Martins', 'PR');
Insert into Cidades (cidade, estado) values ('Inajá', 'PR');
Insert into Cidades (cidade, estado) values ('Indianópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Ipiranga', 'PR');
Insert into Cidades (cidade, estado) values ('Iporã', 'PR');
Insert into Cidades (cidade, estado) values ('Iracema do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Irati', 'PR');
Insert into Cidades (cidade, estado) values ('Iretama', 'PR');
Insert into Cidades (cidade, estado) values ('Itaguajé', 'PR');
Insert into Cidades (cidade, estado) values ('Itaipulândia', 'PR');
Insert into Cidades (cidade, estado) values ('Itambaracá', 'PR');
Insert into Cidades (cidade, estado) values ('Itambé', 'PR');
Insert into Cidades (cidade, estado) values ('Itapejara D''Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Itaperuçu', 'PR');
Insert into Cidades (cidade, estado) values ('Itaúna do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Ivaiporã', 'PR');
Insert into Cidades (cidade, estado) values ('Ivaté', 'PR');
Insert into Cidades (cidade, estado) values ('Ivatuba', 'PR');
Insert into Cidades (cidade, estado) values ('Jaboti', 'PR');
Insert into Cidades (cidade, estado) values ('Jacarezinho', 'PR');
Insert into Cidades (cidade, estado) values ('Jaguapitã', 'PR');
Insert into Cidades (cidade, estado) values ('Jaguariaíva', 'PR');
Insert into Cidades (cidade, estado) values ('Jandaia do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Janiópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Japira', 'PR');
Insert into Cidades (cidade, estado) values ('Japurá', 'PR');
Insert into Cidades (cidade, estado) values ('Jardim Alegre', 'PR');
Insert into Cidades (cidade, estado) values ('Jardim Olinda', 'PR');
Insert into Cidades (cidade, estado) values ('Jataizinho', 'PR');
Insert into Cidades (cidade, estado) values ('Jesuítas', 'PR');
Insert into Cidades (cidade, estado) values ('Joaquim Távora', 'PR');
Insert into Cidades (cidade, estado) values ('Jundiaí do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Juranda', 'PR');
Insert into Cidades (cidade, estado) values ('Jussara', 'PR');
Insert into Cidades (cidade, estado) values ('Kaloré', 'PR');
Insert into Cidades (cidade, estado) values ('Lapa', 'PR');
Insert into Cidades (cidade, estado) values ('Laranjal', 'PR');
Insert into Cidades (cidade, estado) values ('Laranjeiras do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Leópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Lidianópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Lindoeste', 'PR');
Insert into Cidades (cidade, estado) values ('Loanda', 'PR');
Insert into Cidades (cidade, estado) values ('Lobato', 'PR');
Insert into Cidades (cidade, estado) values ('Londrina', 'PR');
Insert into Cidades (cidade, estado) values ('Luiziana', 'PR');
Insert into Cidades (cidade, estado) values ('Lunardelli', 'PR');
Insert into Cidades (cidade, estado) values ('Lupionópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Mallet', 'PR');
Insert into Cidades (cidade, estado) values ('Mamborê', 'PR');
Insert into Cidades (cidade, estado) values ('Mandaguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Mandaguari', 'PR');
Insert into Cidades (cidade, estado) values ('Mandirituba', 'PR');
Insert into Cidades (cidade, estado) values ('Manfrinópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Mangueirinha', 'PR');
Insert into Cidades (cidade, estado) values ('Manoel Ribas', 'PR');
Insert into Cidades (cidade, estado) values ('Marechal Cândido Rondon', 'PR');
Insert into Cidades (cidade, estado) values ('Maria Helena', 'PR');
Insert into Cidades (cidade, estado) values ('Marialva', 'PR');
Insert into Cidades (cidade, estado) values ('Marilândia do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Marilena', 'PR');
Insert into Cidades (cidade, estado) values ('Mariluz', 'PR');
Insert into Cidades (cidade, estado) values ('Maringá', 'PR');
Insert into Cidades (cidade, estado) values ('Mariópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Maripá', 'PR');
Insert into Cidades (cidade, estado) values ('Marmeleiro', 'PR');
Insert into Cidades (cidade, estado) values ('Marquinho', 'PR');
Insert into Cidades (cidade, estado) values ('Marumbi', 'PR');
Insert into Cidades (cidade, estado) values ('Matelândia', 'PR');
Insert into Cidades (cidade, estado) values ('Matinhos', 'PR');
Insert into Cidades (cidade, estado) values ('Mato Rico', 'PR');
Insert into Cidades (cidade, estado) values ('Mauá da Serra', 'PR');
Insert into Cidades (cidade, estado) values ('Medianeira', 'PR');
Insert into Cidades (cidade, estado) values ('Mercedes', 'PR');
Insert into Cidades (cidade, estado) values ('Mirador', 'PR');
Insert into Cidades (cidade, estado) values ('Miraselva', 'PR');
Insert into Cidades (cidade, estado) values ('Missal', 'PR');
Insert into Cidades (cidade, estado) values ('Moreira Sales', 'PR');
Insert into Cidades (cidade, estado) values ('Morretes', 'PR');
Insert into Cidades (cidade, estado) values ('Munhoz de Melo', 'PR');
Insert into Cidades (cidade, estado) values ('Nossa Senhora das Graças', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Aliança do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Nova América da Colina', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Aurora', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Cantu', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Esperança', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Esperança do Sudoeste', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Fátima', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Laranjeiras', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Londrina', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Olímpia', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Santa Bárbara', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Santa Rosa', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Prata do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Nova Tebas', 'PR');
Insert into Cidades (cidade, estado) values ('Novo Itacolomi', 'PR');
Insert into Cidades (cidade, estado) values ('Ortigueira', 'PR');
Insert into Cidades (cidade, estado) values ('Ourizona', 'PR');
Insert into Cidades (cidade, estado) values ('Ouro Verde do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Paiçandu', 'PR');
Insert into Cidades (cidade, estado) values ('Palmas', 'PR');
Insert into Cidades (cidade, estado) values ('Palmeira', 'PR');
Insert into Cidades (cidade, estado) values ('Palmital', 'PR');
Insert into Cidades (cidade, estado) values ('Palotina', 'PR');
Insert into Cidades (cidade, estado) values ('Paraíso do Norte', 'PR');
Insert into Cidades (cidade, estado) values ('Paranacity', 'PR');
Insert into Cidades (cidade, estado) values ('Paranaguá', 'PR');
Insert into Cidades (cidade, estado) values ('Paranapoema', 'PR');
Insert into Cidades (cidade, estado) values ('Paranavaí', 'PR');
Insert into Cidades (cidade, estado) values ('Pato Bragado', 'PR');
Insert into Cidades (cidade, estado) values ('Pato Branco', 'PR');
Insert into Cidades (cidade, estado) values ('Paula Freitas', 'PR');
Insert into Cidades (cidade, estado) values ('Paulo Frontin', 'PR');
Insert into Cidades (cidade, estado) values ('Peabiru', 'PR');
Insert into Cidades (cidade, estado) values ('Perobal', 'PR');
Insert into Cidades (cidade, estado) values ('Pérola', 'PR');
Insert into Cidades (cidade, estado) values ('Pérola D''Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Piên', 'PR');
Insert into Cidades (cidade, estado) values ('Pinhais', 'PR');
Insert into Cidades (cidade, estado) values ('Pinhalão', 'PR');
Insert into Cidades (cidade, estado) values ('Pinhal de São Bento', 'PR');
Insert into Cidades (cidade, estado) values ('Pinhão', 'PR');
Insert into Cidades (cidade, estado) values ('Piraí do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Piraquara', 'PR');
Insert into Cidades (cidade, estado) values ('Pitanga', 'PR');
Insert into Cidades (cidade, estado) values ('Pitangueiras', 'PR');
Insert into Cidades (cidade, estado) values ('Planaltina do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Planalto', 'PR');
Insert into Cidades (cidade, estado) values ('Ponta Grossa', 'PR');
Insert into Cidades (cidade, estado) values ('Pontal do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Porecatu', 'PR');
Insert into Cidades (cidade, estado) values ('Porto Amazonas', 'PR');
Insert into Cidades (cidade, estado) values ('Porto Barreiro', 'PR');
Insert into Cidades (cidade, estado) values ('Porto Rico', 'PR');
Insert into Cidades (cidade, estado) values ('Porto Vitória', 'PR');
Insert into Cidades (cidade, estado) values ('Prado Ferreira', 'PR');
Insert into Cidades (cidade, estado) values ('Pranchita', 'PR');
Insert into Cidades (cidade, estado) values ('Presidente Castelo Branco', 'PR');
Insert into Cidades (cidade, estado) values ('Primeiro de Maio', 'PR');
Insert into Cidades (cidade, estado) values ('Prudentópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Quarto Centenário', 'PR');
Insert into Cidades (cidade, estado) values ('Quatiguá', 'PR');
Insert into Cidades (cidade, estado) values ('Quatro Barras', 'PR');
Insert into Cidades (cidade, estado) values ('Quatro Pontes', 'PR');
Insert into Cidades (cidade, estado) values ('Quedas do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Querência do Norte', 'PR');
Insert into Cidades (cidade, estado) values ('Quinta do Sol', 'PR');
Insert into Cidades (cidade, estado) values ('Quitandinha', 'PR');
Insert into Cidades (cidade, estado) values ('Ramilândia', 'PR');
Insert into Cidades (cidade, estado) values ('Rancho Alegre', 'PR');
Insert into Cidades (cidade, estado) values ('Rancho Alegre D''Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Realeza', 'PR');
Insert into Cidades (cidade, estado) values ('Rebouças', 'PR');
Insert into Cidades (cidade, estado) values ('Renascença', 'PR');
Insert into Cidades (cidade, estado) values ('Reserva', 'PR');
Insert into Cidades (cidade, estado) values ('Reserva do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Ribeirão Claro', 'PR');
Insert into Cidades (cidade, estado) values ('Ribeirão do Pinhal', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Azul', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Bom', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Bonito do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Branco do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Branco do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Rio Negro', 'PR');
Insert into Cidades (cidade, estado) values ('Rolândia', 'PR');
Insert into Cidades (cidade, estado) values ('Roncador', 'PR');
Insert into Cidades (cidade, estado) values ('Rondon', 'PR');
Insert into Cidades (cidade, estado) values ('Rosário do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Sabáudia', 'PR');
Insert into Cidades (cidade, estado) values ('Salgado Filho', 'PR');
Insert into Cidades (cidade, estado) values ('Salto do Itararé', 'PR');
Insert into Cidades (cidade, estado) values ('Salto do Lontra', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Amélia', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Cecília do Pavão', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Cruz de Monte Castelo', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Fé', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Helena', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Inês', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Isabel do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Izabel do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Lúcia', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Maria do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Mariana', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Mônica', 'PR');
Insert into Cidades (cidade, estado) values ('Santana do Itararé', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Tereza do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Santa Terezinha de Itaipu', 'PR');
Insert into Cidades (cidade, estado) values ('Santo Antônio da Platina', 'PR');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Caiuá', 'PR');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Paraíso', 'PR');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Sudoeste', 'PR');
Insert into Cidades (cidade, estado) values ('Santo Inácio', 'PR');
Insert into Cidades (cidade, estado) values ('São Carlos do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('São Jerônimo da Serra', 'PR');
Insert into Cidades (cidade, estado) values ('São João', 'PR');
Insert into Cidades (cidade, estado) values ('São João do Caiuá', 'PR');
Insert into Cidades (cidade, estado) values ('São João do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('São João do Triunfo', 'PR');
Insert into Cidades (cidade, estado) values ('São Jorge D''Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('São Jorge do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('São Jorge do Patrocínio', 'PR');
Insert into Cidades (cidade, estado) values ('São José da Boa Vista', 'PR');
Insert into Cidades (cidade, estado) values ('São José das Palmeiras', 'PR');
Insert into Cidades (cidade, estado) values ('São José dos Pinhais', 'PR');
Insert into Cidades (cidade, estado) values ('São Manoel do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('São Mateus do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('São Miguel do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('São Pedro do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('São Pedro do Ivaí', 'PR');
Insert into Cidades (cidade, estado) values ('São Pedro do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('São Sebastião da Amoreira', 'PR');
Insert into Cidades (cidade, estado) values ('São Tomé', 'PR');
Insert into Cidades (cidade, estado) values ('Sapopema', 'PR');
Insert into Cidades (cidade, estado) values ('Sarandi', 'PR');
Insert into Cidades (cidade, estado) values ('Saudade do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Sengés', 'PR');
Insert into Cidades (cidade, estado) values ('Serranópolis do Iguaçu', 'PR');
Insert into Cidades (cidade, estado) values ('Sertaneja', 'PR');
Insert into Cidades (cidade, estado) values ('Sertanópolis', 'PR');
Insert into Cidades (cidade, estado) values ('Siqueira Campos', 'PR');
Insert into Cidades (cidade, estado) values ('Sulina', 'PR');
Insert into Cidades (cidade, estado) values ('Tamarana', 'PR');
Insert into Cidades (cidade, estado) values ('Tamboara', 'PR');
Insert into Cidades (cidade, estado) values ('Tapejara', 'PR');
Insert into Cidades (cidade, estado) values ('Tapira', 'PR');
Insert into Cidades (cidade, estado) values ('Teixeira Soares', 'PR');
Insert into Cidades (cidade, estado) values ('Telêmaco Borba', 'PR');
Insert into Cidades (cidade, estado) values ('Terra Boa', 'PR');
Insert into Cidades (cidade, estado) values ('Terra Rica', 'PR');
Insert into Cidades (cidade, estado) values ('Terra Roxa', 'PR');
Insert into Cidades (cidade, estado) values ('Tibagi', 'PR');
Insert into Cidades (cidade, estado) values ('Tijucas do Sul', 'PR');
Insert into Cidades (cidade, estado) values ('Toledo', 'PR');
Insert into Cidades (cidade, estado) values ('Tomazina', 'PR');
Insert into Cidades (cidade, estado) values ('Três Barras do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Tunas do Paraná', 'PR');
Insert into Cidades (cidade, estado) values ('Tuneiras do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Tupãssi', 'PR');
Insert into Cidades (cidade, estado) values ('Turvo', 'PR');
Insert into Cidades (cidade, estado) values ('Ubiratã', 'PR');
Insert into Cidades (cidade, estado) values ('Umuarama', 'PR');
Insert into Cidades (cidade, estado) values ('União da Vitória', 'PR');
Insert into Cidades (cidade, estado) values ('Uniflor', 'PR');
Insert into Cidades (cidade, estado) values ('Uraí', 'PR');
Insert into Cidades (cidade, estado) values ('Wenceslau Braz', 'PR');
Insert into Cidades (cidade, estado) values ('Ventania', 'PR');
Insert into Cidades (cidade, estado) values ('Vera Cruz do Oeste', 'PR');
Insert into Cidades (cidade, estado) values ('Verê', 'PR');
Insert into Cidades (cidade, estado) values ('Alto Paraíso', 'PR');
Insert into Cidades (cidade, estado) values ('Doutor Ulysses', 'PR');
Insert into Cidades (cidade, estado) values ('Virmond', 'PR');
Insert into Cidades (cidade, estado) values ('Vitorino', 'PR');
Insert into Cidades (cidade, estado) values ('Xambrê', 'PR');
Insert into Cidades (cidade, estado) values ('Abdon Batista', 'SC');
Insert into Cidades (cidade, estado) values ('Abelardo Luz', 'SC');
Insert into Cidades (cidade, estado) values ('Agrolândia', 'SC');
Insert into Cidades (cidade, estado) values ('Agronômica', 'SC');
Insert into Cidades (cidade, estado) values ('Água Doce', 'SC');
Insert into Cidades (cidade, estado) values ('Águas de Chapecó', 'SC');
Insert into Cidades (cidade, estado) values ('Águas Frias', 'SC');
Insert into Cidades (cidade, estado) values ('Águas Mornas', 'SC');
Insert into Cidades (cidade, estado) values ('Alfredo Wagner', 'SC');
Insert into Cidades (cidade, estado) values ('Alto Bela Vista', 'SC');
Insert into Cidades (cidade, estado) values ('Anchieta', 'SC');
Insert into Cidades (cidade, estado) values ('Angelina', 'SC');
Insert into Cidades (cidade, estado) values ('Anita Garibaldi', 'SC');
Insert into Cidades (cidade, estado) values ('Anitápolis', 'SC');
Insert into Cidades (cidade, estado) values ('Antônio Carlos', 'SC');
Insert into Cidades (cidade, estado) values ('Apiúna', 'SC');
Insert into Cidades (cidade, estado) values ('Arabutã', 'SC');
Insert into Cidades (cidade, estado) values ('Araquari', 'SC');
Insert into Cidades (cidade, estado) values ('Araranguá', 'SC');
Insert into Cidades (cidade, estado) values ('Armazém', 'SC');
Insert into Cidades (cidade, estado) values ('Arroio Trinta', 'SC');
Insert into Cidades (cidade, estado) values ('Arvoredo', 'SC');
Insert into Cidades (cidade, estado) values ('Ascurra', 'SC');
Insert into Cidades (cidade, estado) values ('Atalanta', 'SC');
Insert into Cidades (cidade, estado) values ('Aurora', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Arroio do Silva', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Camboriú', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Barra do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Gaivota', 'SC');
Insert into Cidades (cidade, estado) values ('Bandeirante', 'SC');
Insert into Cidades (cidade, estado) values ('Barra Bonita', 'SC');
Insert into Cidades (cidade, estado) values ('Barra Velha', 'SC');
Insert into Cidades (cidade, estado) values ('Bela Vista do Toldo', 'SC');
Insert into Cidades (cidade, estado) values ('Belmonte', 'SC');
Insert into Cidades (cidade, estado) values ('Benedito Novo', 'SC');
Insert into Cidades (cidade, estado) values ('Biguaçu', 'SC');
Insert into Cidades (cidade, estado) values ('Blumenau', 'SC');
Insert into Cidades (cidade, estado) values ('Bocaina do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Bombinhas', 'SC');
Insert into Cidades (cidade, estado) values ('Bom Jardim da Serra', 'SC');
Insert into Cidades (cidade, estado) values ('Bom Jesus', 'SC');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('Bom Retiro', 'SC');
Insert into Cidades (cidade, estado) values ('Botuverá', 'SC');
Insert into Cidades (cidade, estado) values ('Braço do Norte', 'SC');
Insert into Cidades (cidade, estado) values ('Braço do Trombudo', 'SC');
Insert into Cidades (cidade, estado) values ('Brunópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Brusque', 'SC');
Insert into Cidades (cidade, estado) values ('Caçador', 'SC');
Insert into Cidades (cidade, estado) values ('Caibi', 'SC');
Insert into Cidades (cidade, estado) values ('Calmon', 'SC');
Insert into Cidades (cidade, estado) values ('Camboriú', 'SC');
Insert into Cidades (cidade, estado) values ('Capão Alto', 'SC');
Insert into Cidades (cidade, estado) values ('Campo Alegre', 'SC');
Insert into Cidades (cidade, estado) values ('Campo Belo do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Campo Erê', 'SC');
Insert into Cidades (cidade, estado) values ('Campos Novos', 'SC');
Insert into Cidades (cidade, estado) values ('Canelinha', 'SC');
Insert into Cidades (cidade, estado) values ('Canoinhas', 'SC');
Insert into Cidades (cidade, estado) values ('Capinzal', 'SC');
Insert into Cidades (cidade, estado) values ('Capivari de Baixo', 'SC');
Insert into Cidades (cidade, estado) values ('Catanduvas', 'SC');
Insert into Cidades (cidade, estado) values ('Caxambu do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Celso Ramos', 'SC');
Insert into Cidades (cidade, estado) values ('Cerro Negro', 'SC');
Insert into Cidades (cidade, estado) values ('Chapadão do Lageado', 'SC');
Insert into Cidades (cidade, estado) values ('Chapecó', 'SC');
Insert into Cidades (cidade, estado) values ('Cocal do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Concórdia', 'SC');
Insert into Cidades (cidade, estado) values ('Cordilheira Alta', 'SC');
Insert into Cidades (cidade, estado) values ('Coronel Freitas', 'SC');
Insert into Cidades (cidade, estado) values ('Coronel Martins', 'SC');
Insert into Cidades (cidade, estado) values ('Corupá', 'SC');
Insert into Cidades (cidade, estado) values ('Correia Pinto', 'SC');
Insert into Cidades (cidade, estado) values ('Criciúma', 'SC');
Insert into Cidades (cidade, estado) values ('Cunha Porã', 'SC');
Insert into Cidades (cidade, estado) values ('Cunhataí', 'SC');
Insert into Cidades (cidade, estado) values ('Curitibanos', 'SC');
Insert into Cidades (cidade, estado) values ('Descanso', 'SC');
Insert into Cidades (cidade, estado) values ('Dionísio Cerqueira', 'SC');
Insert into Cidades (cidade, estado) values ('Dona Emma', 'SC');
Insert into Cidades (cidade, estado) values ('Doutor Pedrinho', 'SC');
Insert into Cidades (cidade, estado) values ('Entre Rios', 'SC');
Insert into Cidades (cidade, estado) values ('Ermo', 'SC');
Insert into Cidades (cidade, estado) values ('Erval Velho', 'SC');
Insert into Cidades (cidade, estado) values ('Faxinal dos Guedes', 'SC');
Insert into Cidades (cidade, estado) values ('Flor do Sertão', 'SC');
Insert into Cidades (cidade, estado) values ('Florianópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Formosa do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Forquilhinha', 'SC');
Insert into Cidades (cidade, estado) values ('Fraiburgo', 'SC');
Insert into Cidades (cidade, estado) values ('Frei Rogério', 'SC');
Insert into Cidades (cidade, estado) values ('Galvão', 'SC');
Insert into Cidades (cidade, estado) values ('Garopaba', 'SC');
Insert into Cidades (cidade, estado) values ('Garuva', 'SC');
Insert into Cidades (cidade, estado) values ('Gaspar', 'SC');
Insert into Cidades (cidade, estado) values ('Governador Celso Ramos', 'SC');
Insert into Cidades (cidade, estado) values ('Grão Pará', 'SC');
Insert into Cidades (cidade, estado) values ('Gravatal', 'SC');
Insert into Cidades (cidade, estado) values ('Guabiruba', 'SC');
Insert into Cidades (cidade, estado) values ('Guaraciaba', 'SC');
Insert into Cidades (cidade, estado) values ('Guaramirim', 'SC');
Insert into Cidades (cidade, estado) values ('Guarujá do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Guatambú', 'SC');
Insert into Cidades (cidade, estado) values ('Herval D''Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('Ibiam', 'SC');
Insert into Cidades (cidade, estado) values ('Ibicaré', 'SC');
Insert into Cidades (cidade, estado) values ('Ibirama', 'SC');
Insert into Cidades (cidade, estado) values ('Içara', 'SC');
Insert into Cidades (cidade, estado) values ('Ilhota', 'SC');
Insert into Cidades (cidade, estado) values ('Imaruí', 'SC');
Insert into Cidades (cidade, estado) values ('Imbituba', 'SC');
Insert into Cidades (cidade, estado) values ('Imbuia', 'SC');
Insert into Cidades (cidade, estado) values ('Indaial', 'SC');
Insert into Cidades (cidade, estado) values ('Iomerê', 'SC');
Insert into Cidades (cidade, estado) values ('Ipira', 'SC');
Insert into Cidades (cidade, estado) values ('Iporã do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('Ipuaçu', 'SC');
Insert into Cidades (cidade, estado) values ('Ipumirim', 'SC');
Insert into Cidades (cidade, estado) values ('Iraceminha', 'SC');
Insert into Cidades (cidade, estado) values ('Irani', 'SC');
Insert into Cidades (cidade, estado) values ('Irati', 'SC');
Insert into Cidades (cidade, estado) values ('Irineópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Itá', 'SC');
Insert into Cidades (cidade, estado) values ('Itaiópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Itajaí', 'SC');
Insert into Cidades (cidade, estado) values ('Itapema', 'SC');
Insert into Cidades (cidade, estado) values ('Itapiranga', 'SC');
Insert into Cidades (cidade, estado) values ('Itapoá', 'SC');
Insert into Cidades (cidade, estado) values ('Ituporanga', 'SC');
Insert into Cidades (cidade, estado) values ('Jaborá', 'SC');
Insert into Cidades (cidade, estado) values ('Jacinto Machado', 'SC');
Insert into Cidades (cidade, estado) values ('Jaguaruna', 'SC');
Insert into Cidades (cidade, estado) values ('Jaraguá do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Jardinópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Joaçaba', 'SC');
Insert into Cidades (cidade, estado) values ('Joinville', 'SC');
Insert into Cidades (cidade, estado) values ('José Boiteux', 'SC');
Insert into Cidades (cidade, estado) values ('Jupiá', 'SC');
Insert into Cidades (cidade, estado) values ('Lacerdópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Lages', 'SC');
Insert into Cidades (cidade, estado) values ('Laguna', 'SC');
Insert into Cidades (cidade, estado) values ('Lajeado Grande', 'SC');
Insert into Cidades (cidade, estado) values ('Laurentino', 'SC');
Insert into Cidades (cidade, estado) values ('Lauro Muller', 'SC');
Insert into Cidades (cidade, estado) values ('Lebon Régis', 'SC');
Insert into Cidades (cidade, estado) values ('Leoberto Leal', 'SC');
Insert into Cidades (cidade, estado) values ('Lindóia do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Lontras', 'SC');
Insert into Cidades (cidade, estado) values ('Luiz Alves', 'SC');
Insert into Cidades (cidade, estado) values ('Luzerna', 'SC');
Insert into Cidades (cidade, estado) values ('Macieira', 'SC');
Insert into Cidades (cidade, estado) values ('Mafra', 'SC');
Insert into Cidades (cidade, estado) values ('Major Gercino', 'SC');
Insert into Cidades (cidade, estado) values ('Major Vieira', 'SC');
Insert into Cidades (cidade, estado) values ('Maracajá', 'SC');
Insert into Cidades (cidade, estado) values ('Maravilha', 'SC');
Insert into Cidades (cidade, estado) values ('Marema', 'SC');
Insert into Cidades (cidade, estado) values ('Massaranduba', 'SC');
Insert into Cidades (cidade, estado) values ('Matos Costa', 'SC');
Insert into Cidades (cidade, estado) values ('Meleiro', 'SC');
Insert into Cidades (cidade, estado) values ('Mirim Doce', 'SC');
Insert into Cidades (cidade, estado) values ('Modelo', 'SC');
Insert into Cidades (cidade, estado) values ('Mondaí', 'SC');
Insert into Cidades (cidade, estado) values ('Monte Carlo', 'SC');
Insert into Cidades (cidade, estado) values ('Monte Castelo', 'SC');
Insert into Cidades (cidade, estado) values ('Morro da Fumaça', 'SC');
Insert into Cidades (cidade, estado) values ('Morro Grande', 'SC');
Insert into Cidades (cidade, estado) values ('Navegantes', 'SC');
Insert into Cidades (cidade, estado) values ('Nova Erechim', 'SC');
Insert into Cidades (cidade, estado) values ('Nova Itaberaba', 'SC');
Insert into Cidades (cidade, estado) values ('Nova Trento', 'SC');
Insert into Cidades (cidade, estado) values ('Nova Veneza', 'SC');
Insert into Cidades (cidade, estado) values ('Novo Horizonte', 'SC');
Insert into Cidades (cidade, estado) values ('Orleans', 'SC');
Insert into Cidades (cidade, estado) values ('Otacílio Costa', 'SC');
Insert into Cidades (cidade, estado) values ('Ouro', 'SC');
Insert into Cidades (cidade, estado) values ('Ouro Verde', 'SC');
Insert into Cidades (cidade, estado) values ('Paial', 'SC');
Insert into Cidades (cidade, estado) values ('Painel', 'SC');
Insert into Cidades (cidade, estado) values ('Palhoça', 'SC');
Insert into Cidades (cidade, estado) values ('Palma Sola', 'SC');
Insert into Cidades (cidade, estado) values ('Palmeira', 'SC');
Insert into Cidades (cidade, estado) values ('Palmitos', 'SC');
Insert into Cidades (cidade, estado) values ('Papanduva', 'SC');
Insert into Cidades (cidade, estado) values ('Paraíso', 'SC');
Insert into Cidades (cidade, estado) values ('Passo de Torres', 'SC');
Insert into Cidades (cidade, estado) values ('Passos Maia', 'SC');
Insert into Cidades (cidade, estado) values ('Paulo Lopes', 'SC');
Insert into Cidades (cidade, estado) values ('Pedras Grandes', 'SC');
Insert into Cidades (cidade, estado) values ('Penha', 'SC');
Insert into Cidades (cidade, estado) values ('Peritiba', 'SC');
Insert into Cidades (cidade, estado) values ('Pescaria Brava', 'SC');
Insert into Cidades (cidade, estado) values ('Petrolândia', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Piçarras', 'SC');
Insert into Cidades (cidade, estado) values ('Pinhalzinho', 'SC');
Insert into Cidades (cidade, estado) values ('Pinheiro Preto', 'SC');
Insert into Cidades (cidade, estado) values ('Piratuba', 'SC');
Insert into Cidades (cidade, estado) values ('Planalto Alegre', 'SC');
Insert into Cidades (cidade, estado) values ('Pomerode', 'SC');
Insert into Cidades (cidade, estado) values ('Ponte Alta', 'SC');
Insert into Cidades (cidade, estado) values ('Ponte Alta do Norte', 'SC');
Insert into Cidades (cidade, estado) values ('Ponte Serrada', 'SC');
Insert into Cidades (cidade, estado) values ('Porto Belo', 'SC');
Insert into Cidades (cidade, estado) values ('Porto União', 'SC');
Insert into Cidades (cidade, estado) values ('Pouso Redondo', 'SC');
Insert into Cidades (cidade, estado) values ('Praia Grande', 'SC');
Insert into Cidades (cidade, estado) values ('Presidente Castello Branco', 'SC');
Insert into Cidades (cidade, estado) values ('Presidente Getúlio', 'SC');
Insert into Cidades (cidade, estado) values ('Presidente Nereu', 'SC');
Insert into Cidades (cidade, estado) values ('Princesa', 'SC');
Insert into Cidades (cidade, estado) values ('Quilombo', 'SC');
Insert into Cidades (cidade, estado) values ('Rancho Queimado', 'SC');
Insert into Cidades (cidade, estado) values ('Rio das Antas', 'SC');
Insert into Cidades (cidade, estado) values ('Rio do Campo', 'SC');
Insert into Cidades (cidade, estado) values ('Rio do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('Rio dos Cedros', 'SC');
Insert into Cidades (cidade, estado) values ('Rio do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Rio Fortuna', 'SC');
Insert into Cidades (cidade, estado) values ('Rio Negrinho', 'SC');
Insert into Cidades (cidade, estado) values ('Rio Rufino', 'SC');
Insert into Cidades (cidade, estado) values ('Riqueza', 'SC');
Insert into Cidades (cidade, estado) values ('Rodeio', 'SC');
Insert into Cidades (cidade, estado) values ('Romelândia', 'SC');
Insert into Cidades (cidade, estado) values ('Salete', 'SC');
Insert into Cidades (cidade, estado) values ('Saltinho', 'SC');
Insert into Cidades (cidade, estado) values ('Salto Veloso', 'SC');
Insert into Cidades (cidade, estado) values ('Sangão', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Cecília', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Helena', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Rosa de Lima', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Rosa do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Terezinha', 'SC');
Insert into Cidades (cidade, estado) values ('Santa Terezinha do Progresso', 'SC');
Insert into Cidades (cidade, estado) values ('Santiago do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Santo Amaro da Imperatriz', 'SC');
Insert into Cidades (cidade, estado) values ('São Bernardino', 'SC');
Insert into Cidades (cidade, estado) values ('São Bento do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('São Bonifácio', 'SC');
Insert into Cidades (cidade, estado) values ('São Carlos', 'SC');
Insert into Cidades (cidade, estado) values ('São Cristovão do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('São Domingos', 'SC');
Insert into Cidades (cidade, estado) values ('São Francisco do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('São João do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('São João Batista', 'SC');
Insert into Cidades (cidade, estado) values ('São João do Itaperiú', 'SC');
Insert into Cidades (cidade, estado) values ('São João do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('São Joaquim', 'SC');
Insert into Cidades (cidade, estado) values ('São José', 'SC');
Insert into Cidades (cidade, estado) values ('São José do Cedro', 'SC');
Insert into Cidades (cidade, estado) values ('São José do Cerrito', 'SC');
Insert into Cidades (cidade, estado) values ('São Lourenço do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('São Ludgero', 'SC');
Insert into Cidades (cidade, estado) values ('São Martinho', 'SC');
Insert into Cidades (cidade, estado) values ('São Miguel da Boa Vista', 'SC');
Insert into Cidades (cidade, estado) values ('São Miguel do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('São Pedro de Alcântara', 'SC');
Insert into Cidades (cidade, estado) values ('Saudades', 'SC');
Insert into Cidades (cidade, estado) values ('Schroeder', 'SC');
Insert into Cidades (cidade, estado) values ('Seara', 'SC');
Insert into Cidades (cidade, estado) values ('Serra Alta', 'SC');
Insert into Cidades (cidade, estado) values ('Siderópolis', 'SC');
Insert into Cidades (cidade, estado) values ('Sombrio', 'SC');
Insert into Cidades (cidade, estado) values ('Sul Brasil', 'SC');
Insert into Cidades (cidade, estado) values ('Taió', 'SC');
Insert into Cidades (cidade, estado) values ('Tangará', 'SC');
Insert into Cidades (cidade, estado) values ('Tigrinhos', 'SC');
Insert into Cidades (cidade, estado) values ('Tijucas', 'SC');
Insert into Cidades (cidade, estado) values ('Timbé do Sul', 'SC');
Insert into Cidades (cidade, estado) values ('Timbó', 'SC');
Insert into Cidades (cidade, estado) values ('Timbó Grande', 'SC');
Insert into Cidades (cidade, estado) values ('Três Barras', 'SC');
Insert into Cidades (cidade, estado) values ('Treviso', 'SC');
Insert into Cidades (cidade, estado) values ('Treze de Maio', 'SC');
Insert into Cidades (cidade, estado) values ('Treze Tílias', 'SC');
Insert into Cidades (cidade, estado) values ('Trombudo Central', 'SC');
Insert into Cidades (cidade, estado) values ('Tubarão', 'SC');
Insert into Cidades (cidade, estado) values ('Tunápolis', 'SC');
Insert into Cidades (cidade, estado) values ('Turvo', 'SC');
Insert into Cidades (cidade, estado) values ('União do Oeste', 'SC');
Insert into Cidades (cidade, estado) values ('Urubici', 'SC');
Insert into Cidades (cidade, estado) values ('Urupema', 'SC');
Insert into Cidades (cidade, estado) values ('Urussanga', 'SC');
Insert into Cidades (cidade, estado) values ('Vargeão', 'SC');
Insert into Cidades (cidade, estado) values ('Vargem', 'SC');
Insert into Cidades (cidade, estado) values ('Vargem Bonita', 'SC');
Insert into Cidades (cidade, estado) values ('Vidal Ramos', 'SC');
Insert into Cidades (cidade, estado) values ('Videira', 'SC');
Insert into Cidades (cidade, estado) values ('Vitor Meireles', 'SC');
Insert into Cidades (cidade, estado) values ('Witmarsum', 'SC');
Insert into Cidades (cidade, estado) values ('Xanxerê', 'SC');
Insert into Cidades (cidade, estado) values ('Xavantina', 'SC');
Insert into Cidades (cidade, estado) values ('Xaxim', 'SC');
Insert into Cidades (cidade, estado) values ('Zortéa', 'SC');
Insert into Cidades (cidade, estado) values ('Balneário Rincão', 'SC');
Insert into Cidades (cidade, estado) values ('Aceguá', 'RS');
Insert into Cidades (cidade, estado) values ('Água Santa', 'RS');
Insert into Cidades (cidade, estado) values ('Agudo', 'RS');
Insert into Cidades (cidade, estado) values ('Ajuricaba', 'RS');
Insert into Cidades (cidade, estado) values ('Alecrim', 'RS');
Insert into Cidades (cidade, estado) values ('Alegrete', 'RS');
Insert into Cidades (cidade, estado) values ('Alegria', 'RS');
Insert into Cidades (cidade, estado) values ('Almirante Tamandaré do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Alpestre', 'RS');
Insert into Cidades (cidade, estado) values ('Alto Alegre', 'RS');
Insert into Cidades (cidade, estado) values ('Alto Feliz', 'RS');
Insert into Cidades (cidade, estado) values ('Alvorada', 'RS');
Insert into Cidades (cidade, estado) values ('Amaral Ferrador', 'RS');
Insert into Cidades (cidade, estado) values ('Ametista do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('André da Rocha', 'RS');
Insert into Cidades (cidade, estado) values ('Anta Gorda', 'RS');
Insert into Cidades (cidade, estado) values ('Antônio Prado', 'RS');
Insert into Cidades (cidade, estado) values ('Arambaré', 'RS');
Insert into Cidades (cidade, estado) values ('Araricá', 'RS');
Insert into Cidades (cidade, estado) values ('Aratiba', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio do Meio', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio do Sal', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio do Padre', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio dos Ratos', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio do Tigre', 'RS');
Insert into Cidades (cidade, estado) values ('Arroio Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Arvorezinha', 'RS');
Insert into Cidades (cidade, estado) values ('Augusto Pestana', 'RS');
Insert into Cidades (cidade, estado) values ('Áurea', 'RS');
Insert into Cidades (cidade, estado) values ('Bagé', 'RS');
Insert into Cidades (cidade, estado) values ('Balneário Pinhal', 'RS');
Insert into Cidades (cidade, estado) values ('Barão', 'RS');
Insert into Cidades (cidade, estado) values ('Barão de Cotegipe', 'RS');
Insert into Cidades (cidade, estado) values ('Barão do Triunfo', 'RS');
Insert into Cidades (cidade, estado) values ('Barracão', 'RS');
Insert into Cidades (cidade, estado) values ('Barra do Guarita', 'RS');
Insert into Cidades (cidade, estado) values ('Barra do Quaraí', 'RS');
Insert into Cidades (cidade, estado) values ('Barra do Ribeiro', 'RS');
Insert into Cidades (cidade, estado) values ('Barra do Rio Azul', 'RS');
Insert into Cidades (cidade, estado) values ('Barra Funda', 'RS');
Insert into Cidades (cidade, estado) values ('Barros Cassal', 'RS');
Insert into Cidades (cidade, estado) values ('Benjamin Constant do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Bento Gonçalves', 'RS');
Insert into Cidades (cidade, estado) values ('Boa Vista das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Boa Vista do Buricá', 'RS');
Insert into Cidades (cidade, estado) values ('Boa Vista do Cadeado', 'RS');
Insert into Cidades (cidade, estado) values ('Boa Vista do Incra', 'RS');
Insert into Cidades (cidade, estado) values ('Boa Vista do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Bom Jesus', 'RS');
Insert into Cidades (cidade, estado) values ('Bom Princípio', 'RS');
Insert into Cidades (cidade, estado) values ('Bom Progresso', 'RS');
Insert into Cidades (cidade, estado) values ('Bom Retiro do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Boqueirão do Leão', 'RS');
Insert into Cidades (cidade, estado) values ('Bossoroca', 'RS');
Insert into Cidades (cidade, estado) values ('Bozano', 'RS');
Insert into Cidades (cidade, estado) values ('Braga', 'RS');
Insert into Cidades (cidade, estado) values ('Brochier', 'RS');
Insert into Cidades (cidade, estado) values ('Butiá', 'RS');
Insert into Cidades (cidade, estado) values ('Caçapava do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Cacequi', 'RS');
Insert into Cidades (cidade, estado) values ('Cachoeira do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Cachoeirinha', 'RS');
Insert into Cidades (cidade, estado) values ('Cacique Doble', 'RS');
Insert into Cidades (cidade, estado) values ('Caibaté', 'RS');
Insert into Cidades (cidade, estado) values ('Caiçara', 'RS');
Insert into Cidades (cidade, estado) values ('Camaquã', 'RS');
Insert into Cidades (cidade, estado) values ('Camargo', 'RS');
Insert into Cidades (cidade, estado) values ('Cambará do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Campestre da Serra', 'RS');
Insert into Cidades (cidade, estado) values ('Campina das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Campinas do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Campo Bom', 'RS');
Insert into Cidades (cidade, estado) values ('Campo Novo', 'RS');
Insert into Cidades (cidade, estado) values ('Campos Borges', 'RS');
Insert into Cidades (cidade, estado) values ('Candelária', 'RS');
Insert into Cidades (cidade, estado) values ('Cândido Godói', 'RS');
Insert into Cidades (cidade, estado) values ('Candiota', 'RS');
Insert into Cidades (cidade, estado) values ('Canela', 'RS');
Insert into Cidades (cidade, estado) values ('Canguçu', 'RS');
Insert into Cidades (cidade, estado) values ('Canoas', 'RS');
Insert into Cidades (cidade, estado) values ('Canudos do Vale', 'RS');
Insert into Cidades (cidade, estado) values ('Capão Bonito do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Capão da Canoa', 'RS');
Insert into Cidades (cidade, estado) values ('Capão do Cipó', 'RS');
Insert into Cidades (cidade, estado) values ('Capão do Leão', 'RS');
Insert into Cidades (cidade, estado) values ('Capivari do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Capela de Santana', 'RS');
Insert into Cidades (cidade, estado) values ('Capitão', 'RS');
Insert into Cidades (cidade, estado) values ('Carazinho', 'RS');
Insert into Cidades (cidade, estado) values ('Caraá', 'RS');
Insert into Cidades (cidade, estado) values ('Carlos Barbosa', 'RS');
Insert into Cidades (cidade, estado) values ('Carlos Gomes', 'RS');
Insert into Cidades (cidade, estado) values ('Casca', 'RS');
Insert into Cidades (cidade, estado) values ('Caseiros', 'RS');
Insert into Cidades (cidade, estado) values ('Catuípe', 'RS');
Insert into Cidades (cidade, estado) values ('Caxias do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Centenário', 'RS');
Insert into Cidades (cidade, estado) values ('Cerrito', 'RS');
Insert into Cidades (cidade, estado) values ('Cerro Branco', 'RS');
Insert into Cidades (cidade, estado) values ('Cerro Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Cerro Grande do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Cerro Largo', 'RS');
Insert into Cidades (cidade, estado) values ('Chapada', 'RS');
Insert into Cidades (cidade, estado) values ('Charqueadas', 'RS');
Insert into Cidades (cidade, estado) values ('Charrua', 'RS');
Insert into Cidades (cidade, estado) values ('Chiapetta', 'RS');
Insert into Cidades (cidade, estado) values ('Chuí', 'RS');
Insert into Cidades (cidade, estado) values ('Chuvisca', 'RS');
Insert into Cidades (cidade, estado) values ('Cidreira', 'RS');
Insert into Cidades (cidade, estado) values ('Ciríaco', 'RS');
Insert into Cidades (cidade, estado) values ('Colinas', 'RS');
Insert into Cidades (cidade, estado) values ('Colorado', 'RS');
Insert into Cidades (cidade, estado) values ('Condor', 'RS');
Insert into Cidades (cidade, estado) values ('Constantina', 'RS');
Insert into Cidades (cidade, estado) values ('Coqueiro Baixo', 'RS');
Insert into Cidades (cidade, estado) values ('Coqueiros do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Coronel Barros', 'RS');
Insert into Cidades (cidade, estado) values ('Coronel Bicaco', 'RS');
Insert into Cidades (cidade, estado) values ('Coronel Pilar', 'RS');
Insert into Cidades (cidade, estado) values ('Cotiporã', 'RS');
Insert into Cidades (cidade, estado) values ('Coxilha', 'RS');
Insert into Cidades (cidade, estado) values ('Crissiumal', 'RS');
Insert into Cidades (cidade, estado) values ('Cristal', 'RS');
Insert into Cidades (cidade, estado) values ('Cristal do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Cruz Alta', 'RS');
Insert into Cidades (cidade, estado) values ('Cruzaltense', 'RS');
Insert into Cidades (cidade, estado) values ('Cruzeiro do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('David Canabarro', 'RS');
Insert into Cidades (cidade, estado) values ('Derrubadas', 'RS');
Insert into Cidades (cidade, estado) values ('Dezesseis de Novembro', 'RS');
Insert into Cidades (cidade, estado) values ('Dilermando de Aguiar', 'RS');
Insert into Cidades (cidade, estado) values ('Dois Irmãos', 'RS');
Insert into Cidades (cidade, estado) values ('Dois Irmãos das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Dois Lajeados', 'RS');
Insert into Cidades (cidade, estado) values ('Dom Feliciano', 'RS');
Insert into Cidades (cidade, estado) values ('Dom Pedro de Alcântara', 'RS');
Insert into Cidades (cidade, estado) values ('Dom Pedrito', 'RS');
Insert into Cidades (cidade, estado) values ('Dona Francisca', 'RS');
Insert into Cidades (cidade, estado) values ('Doutor Maurício Cardoso', 'RS');
Insert into Cidades (cidade, estado) values ('Doutor Ricardo', 'RS');
Insert into Cidades (cidade, estado) values ('Eldorado do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Encantado', 'RS');
Insert into Cidades (cidade, estado) values ('Encruzilhada do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Engenho Velho', 'RS');
Insert into Cidades (cidade, estado) values ('Entre-Ijuís', 'RS');
Insert into Cidades (cidade, estado) values ('Entre Rios do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Erebango', 'RS');
Insert into Cidades (cidade, estado) values ('Erechim', 'RS');
Insert into Cidades (cidade, estado) values ('Ernestina', 'RS');
Insert into Cidades (cidade, estado) values ('Herval', 'RS');
Insert into Cidades (cidade, estado) values ('Erval Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Erval Seco', 'RS');
Insert into Cidades (cidade, estado) values ('Esmeralda', 'RS');
Insert into Cidades (cidade, estado) values ('Esperança do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Espumoso', 'RS');
Insert into Cidades (cidade, estado) values ('Estação', 'RS');
Insert into Cidades (cidade, estado) values ('Estância Velha', 'RS');
Insert into Cidades (cidade, estado) values ('Esteio', 'RS');
Insert into Cidades (cidade, estado) values ('Estrela', 'RS');
Insert into Cidades (cidade, estado) values ('Estrela Velha', 'RS');
Insert into Cidades (cidade, estado) values ('Eugênio de Castro', 'RS');
Insert into Cidades (cidade, estado) values ('Fagundes Varela', 'RS');
Insert into Cidades (cidade, estado) values ('Farroupilha', 'RS');
Insert into Cidades (cidade, estado) values ('Faxinal do Soturno', 'RS');
Insert into Cidades (cidade, estado) values ('Faxinalzinho', 'RS');
Insert into Cidades (cidade, estado) values ('Fazenda Vilanova', 'RS');
Insert into Cidades (cidade, estado) values ('Feliz', 'RS');
Insert into Cidades (cidade, estado) values ('Flores da Cunha', 'RS');
Insert into Cidades (cidade, estado) values ('Floriano Peixoto', 'RS');
Insert into Cidades (cidade, estado) values ('Fontoura Xavier', 'RS');
Insert into Cidades (cidade, estado) values ('Formigueiro', 'RS');
Insert into Cidades (cidade, estado) values ('Forquetinha', 'RS');
Insert into Cidades (cidade, estado) values ('Fortaleza dos Valos', 'RS');
Insert into Cidades (cidade, estado) values ('Frederico Westphalen', 'RS');
Insert into Cidades (cidade, estado) values ('Garibaldi', 'RS');
Insert into Cidades (cidade, estado) values ('Garruchos', 'RS');
Insert into Cidades (cidade, estado) values ('Gaurama', 'RS');
Insert into Cidades (cidade, estado) values ('General Câmara', 'RS');
Insert into Cidades (cidade, estado) values ('Gentil', 'RS');
Insert into Cidades (cidade, estado) values ('Getúlio Vargas', 'RS');
Insert into Cidades (cidade, estado) values ('Giruá', 'RS');
Insert into Cidades (cidade, estado) values ('Glorinha', 'RS');
Insert into Cidades (cidade, estado) values ('Gramado', 'RS');
Insert into Cidades (cidade, estado) values ('Gramado dos Loureiros', 'RS');
Insert into Cidades (cidade, estado) values ('Gramado Xavier', 'RS');
Insert into Cidades (cidade, estado) values ('Gravataí', 'RS');
Insert into Cidades (cidade, estado) values ('Guabiju', 'RS');
Insert into Cidades (cidade, estado) values ('Guaíba', 'RS');
Insert into Cidades (cidade, estado) values ('Guaporé', 'RS');
Insert into Cidades (cidade, estado) values ('Guarani das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Harmonia', 'RS');
Insert into Cidades (cidade, estado) values ('Herveiras', 'RS');
Insert into Cidades (cidade, estado) values ('Horizontina', 'RS');
Insert into Cidades (cidade, estado) values ('Hulha Negra', 'RS');
Insert into Cidades (cidade, estado) values ('Humaitá', 'RS');
Insert into Cidades (cidade, estado) values ('Ibarama', 'RS');
Insert into Cidades (cidade, estado) values ('Ibiaçá', 'RS');
Insert into Cidades (cidade, estado) values ('Ibiraiaras', 'RS');
Insert into Cidades (cidade, estado) values ('Ibirapuitã', 'RS');
Insert into Cidades (cidade, estado) values ('Ibirubá', 'RS');
Insert into Cidades (cidade, estado) values ('Igrejinha', 'RS');
Insert into Cidades (cidade, estado) values ('Ijuí', 'RS');
Insert into Cidades (cidade, estado) values ('Ilópolis', 'RS');
Insert into Cidades (cidade, estado) values ('Imbé', 'RS');
Insert into Cidades (cidade, estado) values ('Imigrante', 'RS');
Insert into Cidades (cidade, estado) values ('Independência', 'RS');
Insert into Cidades (cidade, estado) values ('Inhacorá', 'RS');
Insert into Cidades (cidade, estado) values ('Ipê', 'RS');
Insert into Cidades (cidade, estado) values ('Ipiranga do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Iraí', 'RS');
Insert into Cidades (cidade, estado) values ('Itaara', 'RS');
Insert into Cidades (cidade, estado) values ('Itacurubi', 'RS');
Insert into Cidades (cidade, estado) values ('Itapuca', 'RS');
Insert into Cidades (cidade, estado) values ('Itaqui', 'RS');
Insert into Cidades (cidade, estado) values ('Itati', 'RS');
Insert into Cidades (cidade, estado) values ('Itatiba do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Ivorá', 'RS');
Insert into Cidades (cidade, estado) values ('Ivoti', 'RS');
Insert into Cidades (cidade, estado) values ('Jaboticaba', 'RS');
Insert into Cidades (cidade, estado) values ('Jacuizinho', 'RS');
Insert into Cidades (cidade, estado) values ('Jacutinga', 'RS');
Insert into Cidades (cidade, estado) values ('Jaguarão', 'RS');
Insert into Cidades (cidade, estado) values ('Jaguari', 'RS');
Insert into Cidades (cidade, estado) values ('Jaquirana', 'RS');
Insert into Cidades (cidade, estado) values ('Jari', 'RS');
Insert into Cidades (cidade, estado) values ('Jóia', 'RS');
Insert into Cidades (cidade, estado) values ('Júlio de Castilhos', 'RS');
Insert into Cidades (cidade, estado) values ('Lagoa Bonita do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Lagoão', 'RS');
Insert into Cidades (cidade, estado) values ('Lagoa dos Três Cantos', 'RS');
Insert into Cidades (cidade, estado) values ('Lagoa Vermelha', 'RS');
Insert into Cidades (cidade, estado) values ('Lajeado', 'RS');
Insert into Cidades (cidade, estado) values ('Lajeado do Bugre', 'RS');
Insert into Cidades (cidade, estado) values ('Lavras do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Liberato Salzano', 'RS');
Insert into Cidades (cidade, estado) values ('Lindolfo Collor', 'RS');
Insert into Cidades (cidade, estado) values ('Linha Nova', 'RS');
Insert into Cidades (cidade, estado) values ('Machadinho', 'RS');
Insert into Cidades (cidade, estado) values ('Maçambará', 'RS');
Insert into Cidades (cidade, estado) values ('Mampituba', 'RS');
Insert into Cidades (cidade, estado) values ('Manoel Viana', 'RS');
Insert into Cidades (cidade, estado) values ('Maquiné', 'RS');
Insert into Cidades (cidade, estado) values ('Maratá', 'RS');
Insert into Cidades (cidade, estado) values ('Marau', 'RS');
Insert into Cidades (cidade, estado) values ('Marcelino Ramos', 'RS');
Insert into Cidades (cidade, estado) values ('Mariana Pimentel', 'RS');
Insert into Cidades (cidade, estado) values ('Mariano Moro', 'RS');
Insert into Cidades (cidade, estado) values ('Marques de Souza', 'RS');
Insert into Cidades (cidade, estado) values ('Mata', 'RS');
Insert into Cidades (cidade, estado) values ('Mato Castelhano', 'RS');
Insert into Cidades (cidade, estado) values ('Mato Leitão', 'RS');
Insert into Cidades (cidade, estado) values ('Mato Queimado', 'RS');
Insert into Cidades (cidade, estado) values ('Maximiliano de Almeida', 'RS');
Insert into Cidades (cidade, estado) values ('Minas do Leão', 'RS');
Insert into Cidades (cidade, estado) values ('Miraguaí', 'RS');
Insert into Cidades (cidade, estado) values ('Montauri', 'RS');
Insert into Cidades (cidade, estado) values ('Monte Alegre dos Campos', 'RS');
Insert into Cidades (cidade, estado) values ('Monte Belo do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Montenegro', 'RS');
Insert into Cidades (cidade, estado) values ('Mormaço', 'RS');
Insert into Cidades (cidade, estado) values ('Morrinhos do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Morro Redondo', 'RS');
Insert into Cidades (cidade, estado) values ('Morro Reuter', 'RS');
Insert into Cidades (cidade, estado) values ('Mostardas', 'RS');
Insert into Cidades (cidade, estado) values ('Muçum', 'RS');
Insert into Cidades (cidade, estado) values ('Muitos Capões', 'RS');
Insert into Cidades (cidade, estado) values ('Muliterno', 'RS');
Insert into Cidades (cidade, estado) values ('Não-Me-Toque', 'RS');
Insert into Cidades (cidade, estado) values ('Nicolau Vergueiro', 'RS');
Insert into Cidades (cidade, estado) values ('Nonoai', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Alvorada', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Araçá', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Bassano', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Boa Vista', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Bréscia', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Candelária', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Esperança do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Hartz', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Pádua', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Palma', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Petrópolis', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Prata', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Ramada', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Roma do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Nova Santa Rita', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Cabrais', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Hamburgo', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Machado', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Tiradentes', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Xingu', 'RS');
Insert into Cidades (cidade, estado) values ('Novo Barreiro', 'RS');
Insert into Cidades (cidade, estado) values ('Osório', 'RS');
Insert into Cidades (cidade, estado) values ('Paim Filho', 'RS');
Insert into Cidades (cidade, estado) values ('Palmares do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Palmeira das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Palmitinho', 'RS');
Insert into Cidades (cidade, estado) values ('Panambi', 'RS');
Insert into Cidades (cidade, estado) values ('Pantano Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Paraí', 'RS');
Insert into Cidades (cidade, estado) values ('Paraíso do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Pareci Novo', 'RS');
Insert into Cidades (cidade, estado) values ('Parobé', 'RS');
Insert into Cidades (cidade, estado) values ('Passa Sete', 'RS');
Insert into Cidades (cidade, estado) values ('Passo do Sobrado', 'RS');
Insert into Cidades (cidade, estado) values ('Passo Fundo', 'RS');
Insert into Cidades (cidade, estado) values ('Paulo Bento', 'RS');
Insert into Cidades (cidade, estado) values ('Paverama', 'RS');
Insert into Cidades (cidade, estado) values ('Pedras Altas', 'RS');
Insert into Cidades (cidade, estado) values ('Pedro Osório', 'RS');
Insert into Cidades (cidade, estado) values ('Pejuçara', 'RS');
Insert into Cidades (cidade, estado) values ('Pelotas', 'RS');
Insert into Cidades (cidade, estado) values ('Picada Café', 'RS');
Insert into Cidades (cidade, estado) values ('Pinhal', 'RS');
Insert into Cidades (cidade, estado) values ('Pinhal da Serra', 'RS');
Insert into Cidades (cidade, estado) values ('Pinhal Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Pinheirinho do Vale', 'RS');
Insert into Cidades (cidade, estado) values ('Pinheiro Machado', 'RS');
Insert into Cidades (cidade, estado) values ('Pinto Bandeira', 'RS');
Insert into Cidades (cidade, estado) values ('Pirapó', 'RS');
Insert into Cidades (cidade, estado) values ('Piratini', 'RS');
Insert into Cidades (cidade, estado) values ('Planalto', 'RS');
Insert into Cidades (cidade, estado) values ('Poço das Antas', 'RS');
Insert into Cidades (cidade, estado) values ('Pontão', 'RS');
Insert into Cidades (cidade, estado) values ('Ponte Preta', 'RS');
Insert into Cidades (cidade, estado) values ('Portão', 'RS');
Insert into Cidades (cidade, estado) values ('Porto Alegre', 'RS');
Insert into Cidades (cidade, estado) values ('Porto Lucena', 'RS');
Insert into Cidades (cidade, estado) values ('Porto Mauá', 'RS');
Insert into Cidades (cidade, estado) values ('Porto Vera Cruz', 'RS');
Insert into Cidades (cidade, estado) values ('Porto Xavier', 'RS');
Insert into Cidades (cidade, estado) values ('Pouso Novo', 'RS');
Insert into Cidades (cidade, estado) values ('Presidente Lucena', 'RS');
Insert into Cidades (cidade, estado) values ('Progresso', 'RS');
Insert into Cidades (cidade, estado) values ('Protásio Alves', 'RS');
Insert into Cidades (cidade, estado) values ('Putinga', 'RS');
Insert into Cidades (cidade, estado) values ('Quaraí', 'RS');
Insert into Cidades (cidade, estado) values ('Quatro Irmãos', 'RS');
Insert into Cidades (cidade, estado) values ('Quevedos', 'RS');
Insert into Cidades (cidade, estado) values ('Quinze de Novembro', 'RS');
Insert into Cidades (cidade, estado) values ('Redentora', 'RS');
Insert into Cidades (cidade, estado) values ('Relvado', 'RS');
Insert into Cidades (cidade, estado) values ('Restinga Seca', 'RS');
Insert into Cidades (cidade, estado) values ('Rio dos Índios', 'RS');
Insert into Cidades (cidade, estado) values ('Rio Grande', 'RS');
Insert into Cidades (cidade, estado) values ('Rio Pardo', 'RS');
Insert into Cidades (cidade, estado) values ('Riozinho', 'RS');
Insert into Cidades (cidade, estado) values ('Roca Sales', 'RS');
Insert into Cidades (cidade, estado) values ('Rodeio Bonito', 'RS');
Insert into Cidades (cidade, estado) values ('Rolador', 'RS');
Insert into Cidades (cidade, estado) values ('Rolante', 'RS');
Insert into Cidades (cidade, estado) values ('Ronda Alta', 'RS');
Insert into Cidades (cidade, estado) values ('Rondinha', 'RS');
Insert into Cidades (cidade, estado) values ('Roque Gonzales', 'RS');
Insert into Cidades (cidade, estado) values ('Rosário do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Sagrada Família', 'RS');
Insert into Cidades (cidade, estado) values ('Saldanha Marinho', 'RS');
Insert into Cidades (cidade, estado) values ('Salto do Jacuí', 'RS');
Insert into Cidades (cidade, estado) values ('Salvador das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Salvador do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Sananduva', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Bárbara do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Cecília do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Clara do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Maria', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Maria do Herval', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Margarida do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Santana da Boa Vista', 'RS');
Insert into Cidades (cidade, estado) values ('Sant''Ana do Livramento', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Rosa', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Tereza', 'RS');
Insert into Cidades (cidade, estado) values ('Santa Vitória do Palmar', 'RS');
Insert into Cidades (cidade, estado) values ('Santiago', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Ângelo', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Palma', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Antônio da Patrulha', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Antônio das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Planalto', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Augusto', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Cristo', 'RS');
Insert into Cidades (cidade, estado) values ('Santo Expedito do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Borja', 'RS');
Insert into Cidades (cidade, estado) values ('São Domingos do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Francisco de Assis', 'RS');
Insert into Cidades (cidade, estado) values ('São Francisco de Paula', 'RS');
Insert into Cidades (cidade, estado) values ('São Gabriel', 'RS');
Insert into Cidades (cidade, estado) values ('São Jerônimo', 'RS');
Insert into Cidades (cidade, estado) values ('São João da Urtiga', 'RS');
Insert into Cidades (cidade, estado) values ('São João do Polêsine', 'RS');
Insert into Cidades (cidade, estado) values ('São Jorge', 'RS');
Insert into Cidades (cidade, estado) values ('São José das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Herval', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Hortêncio', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Inhacorá', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Norte', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Ouro', 'RS');
Insert into Cidades (cidade, estado) values ('São José do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São José dos Ausentes', 'RS');
Insert into Cidades (cidade, estado) values ('São Leopoldo', 'RS');
Insert into Cidades (cidade, estado) values ('São Lourenço do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Luiz Gonzaga', 'RS');
Insert into Cidades (cidade, estado) values ('São Marcos', 'RS');
Insert into Cidades (cidade, estado) values ('São Martinho', 'RS');
Insert into Cidades (cidade, estado) values ('São Martinho da Serra', 'RS');
Insert into Cidades (cidade, estado) values ('São Miguel das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('São Nicolau', 'RS');
Insert into Cidades (cidade, estado) values ('São Paulo das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('São Pedro da Serra', 'RS');
Insert into Cidades (cidade, estado) values ('São Pedro das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('São Pedro do Butiá', 'RS');
Insert into Cidades (cidade, estado) values ('São Pedro do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Sebastião do Caí', 'RS');
Insert into Cidades (cidade, estado) values ('São Sepé', 'RS');
Insert into Cidades (cidade, estado) values ('São Valentim', 'RS');
Insert into Cidades (cidade, estado) values ('São Valentim do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Valério do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('São Vendelino', 'RS');
Insert into Cidades (cidade, estado) values ('São Vicente do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Sapiranga', 'RS');
Insert into Cidades (cidade, estado) values ('Sapucaia do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Sarandi', 'RS');
Insert into Cidades (cidade, estado) values ('Seberi', 'RS');
Insert into Cidades (cidade, estado) values ('Sede Nova', 'RS');
Insert into Cidades (cidade, estado) values ('Segredo', 'RS');
Insert into Cidades (cidade, estado) values ('Selbach', 'RS');
Insert into Cidades (cidade, estado) values ('Senador Salgado Filho', 'RS');
Insert into Cidades (cidade, estado) values ('Sentinela do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Serafina Corrêa', 'RS');
Insert into Cidades (cidade, estado) values ('Sério', 'RS');
Insert into Cidades (cidade, estado) values ('Sertão', 'RS');
Insert into Cidades (cidade, estado) values ('Sertão Santana', 'RS');
Insert into Cidades (cidade, estado) values ('Sete de Setembro', 'RS');
Insert into Cidades (cidade, estado) values ('Severiano de Almeida', 'RS');
Insert into Cidades (cidade, estado) values ('Silveira Martins', 'RS');
Insert into Cidades (cidade, estado) values ('Sinimbu', 'RS');
Insert into Cidades (cidade, estado) values ('Sobradinho', 'RS');
Insert into Cidades (cidade, estado) values ('Soledade', 'RS');
Insert into Cidades (cidade, estado) values ('Tabaí', 'RS');
Insert into Cidades (cidade, estado) values ('Tapejara', 'RS');
Insert into Cidades (cidade, estado) values ('Tapera', 'RS');
Insert into Cidades (cidade, estado) values ('Tapes', 'RS');
Insert into Cidades (cidade, estado) values ('Taquara', 'RS');
Insert into Cidades (cidade, estado) values ('Taquari', 'RS');
Insert into Cidades (cidade, estado) values ('Taquaruçu do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Tavares', 'RS');
Insert into Cidades (cidade, estado) values ('Tenente Portela', 'RS');
Insert into Cidades (cidade, estado) values ('Terra de Areia', 'RS');
Insert into Cidades (cidade, estado) values ('Teutônia', 'RS');
Insert into Cidades (cidade, estado) values ('Tio Hugo', 'RS');
Insert into Cidades (cidade, estado) values ('Tiradentes do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Toropi', 'RS');
Insert into Cidades (cidade, estado) values ('Torres', 'RS');
Insert into Cidades (cidade, estado) values ('Tramandaí', 'RS');
Insert into Cidades (cidade, estado) values ('Travesseiro', 'RS');
Insert into Cidades (cidade, estado) values ('Três Arroios', 'RS');
Insert into Cidades (cidade, estado) values ('Três Cachoeiras', 'RS');
Insert into Cidades (cidade, estado) values ('Três Coroas', 'RS');
Insert into Cidades (cidade, estado) values ('Três de Maio', 'RS');
Insert into Cidades (cidade, estado) values ('Três Forquilhas', 'RS');
Insert into Cidades (cidade, estado) values ('Três Palmeiras', 'RS');
Insert into Cidades (cidade, estado) values ('Três Passos', 'RS');
Insert into Cidades (cidade, estado) values ('Trindade do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Triunfo', 'RS');
Insert into Cidades (cidade, estado) values ('Tucunduva', 'RS');
Insert into Cidades (cidade, estado) values ('Tunas', 'RS');
Insert into Cidades (cidade, estado) values ('Tupanci do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Tupanciretã', 'RS');
Insert into Cidades (cidade, estado) values ('Tupandi', 'RS');
Insert into Cidades (cidade, estado) values ('Tuparendi', 'RS');
Insert into Cidades (cidade, estado) values ('Turuçu', 'RS');
Insert into Cidades (cidade, estado) values ('Ubiretama', 'RS');
Insert into Cidades (cidade, estado) values ('União da Serra', 'RS');
Insert into Cidades (cidade, estado) values ('Unistalda', 'RS');
Insert into Cidades (cidade, estado) values ('Uruguaiana', 'RS');
Insert into Cidades (cidade, estado) values ('Vacaria', 'RS');
Insert into Cidades (cidade, estado) values ('Vale Verde', 'RS');
Insert into Cidades (cidade, estado) values ('Vale do Sol', 'RS');
Insert into Cidades (cidade, estado) values ('Vale Real', 'RS');
Insert into Cidades (cidade, estado) values ('Vanini', 'RS');
Insert into Cidades (cidade, estado) values ('Venâncio Aires', 'RS');
Insert into Cidades (cidade, estado) values ('Vera Cruz', 'RS');
Insert into Cidades (cidade, estado) values ('Veranópolis', 'RS');
Insert into Cidades (cidade, estado) values ('Vespasiano Correa', 'RS');
Insert into Cidades (cidade, estado) values ('Viadutos', 'RS');
Insert into Cidades (cidade, estado) values ('Viamão', 'RS');
Insert into Cidades (cidade, estado) values ('Vicente Dutra', 'RS');
Insert into Cidades (cidade, estado) values ('Victor Graeff', 'RS');
Insert into Cidades (cidade, estado) values ('Vila Flores', 'RS');
Insert into Cidades (cidade, estado) values ('Vila Lângaro', 'RS');
Insert into Cidades (cidade, estado) values ('Vila Maria', 'RS');
Insert into Cidades (cidade, estado) values ('Vila Nova do Sul', 'RS');
Insert into Cidades (cidade, estado) values ('Vista Alegre', 'RS');
Insert into Cidades (cidade, estado) values ('Vista Alegre do Prata', 'RS');
Insert into Cidades (cidade, estado) values ('Vista Gaúcha', 'RS');
Insert into Cidades (cidade, estado) values ('Vitória das Missões', 'RS');
Insert into Cidades (cidade, estado) values ('Westfalia', 'RS');
Insert into Cidades (cidade, estado) values ('Xangri-lá', 'RS');
Insert into Cidades (cidade, estado) values ('Água Clara', 'MS');
Insert into Cidades (cidade, estado) values ('Alcinópolis', 'MS');
Insert into Cidades (cidade, estado) values ('Amambai', 'MS');
Insert into Cidades (cidade, estado) values ('Anastácio', 'MS');
Insert into Cidades (cidade, estado) values ('Anaurilândia', 'MS');
Insert into Cidades (cidade, estado) values ('Angélica', 'MS');
Insert into Cidades (cidade, estado) values ('Antônio João', 'MS');
Insert into Cidades (cidade, estado) values ('Aparecida do Taboado', 'MS');
Insert into Cidades (cidade, estado) values ('Aquidauana', 'MS');
Insert into Cidades (cidade, estado) values ('Aral Moreira', 'MS');
Insert into Cidades (cidade, estado) values ('Bandeirantes', 'MS');
Insert into Cidades (cidade, estado) values ('Bataguassu', 'MS');
Insert into Cidades (cidade, estado) values ('Batayporã', 'MS');
Insert into Cidades (cidade, estado) values ('Bela Vista', 'MS');
Insert into Cidades (cidade, estado) values ('Bodoquena', 'MS');
Insert into Cidades (cidade, estado) values ('Bonito', 'MS');
Insert into Cidades (cidade, estado) values ('Brasilândia', 'MS');
Insert into Cidades (cidade, estado) values ('Caarapó', 'MS');
Insert into Cidades (cidade, estado) values ('Camapuã', 'MS');
Insert into Cidades (cidade, estado) values ('Campo Grande', 'MS');
Insert into Cidades (cidade, estado) values ('Caracol', 'MS');
Insert into Cidades (cidade, estado) values ('Cassilândia', 'MS');
Insert into Cidades (cidade, estado) values ('Chapadão do Sul', 'MS');
Insert into Cidades (cidade, estado) values ('Corguinho', 'MS');
Insert into Cidades (cidade, estado) values ('Coronel Sapucaia', 'MS');
Insert into Cidades (cidade, estado) values ('Corumbá', 'MS');
Insert into Cidades (cidade, estado) values ('Costa Rica', 'MS');
Insert into Cidades (cidade, estado) values ('Coxim', 'MS');
Insert into Cidades (cidade, estado) values ('Deodápolis', 'MS');
Insert into Cidades (cidade, estado) values ('Dois Irmãos do Buriti', 'MS');
Insert into Cidades (cidade, estado) values ('Douradina', 'MS');
Insert into Cidades (cidade, estado) values ('Dourados', 'MS');
Insert into Cidades (cidade, estado) values ('Eldorado', 'MS');
Insert into Cidades (cidade, estado) values ('Fátima do Sul', 'MS');
Insert into Cidades (cidade, estado) values ('Figueirão', 'MS');
Insert into Cidades (cidade, estado) values ('Glória de Dourados', 'MS');
Insert into Cidades (cidade, estado) values ('Guia Lopes da Laguna', 'MS');
Insert into Cidades (cidade, estado) values ('Iguatemi', 'MS');
Insert into Cidades (cidade, estado) values ('Inocência', 'MS');
Insert into Cidades (cidade, estado) values ('Itaporã', 'MS');
Insert into Cidades (cidade, estado) values ('Itaquiraí', 'MS');
Insert into Cidades (cidade, estado) values ('Ivinhema', 'MS');
Insert into Cidades (cidade, estado) values ('Japorã', 'MS');
Insert into Cidades (cidade, estado) values ('Jaraguari', 'MS');
Insert into Cidades (cidade, estado) values ('Jardim', 'MS');
Insert into Cidades (cidade, estado) values ('Jateí', 'MS');
Insert into Cidades (cidade, estado) values ('Juti', 'MS');
Insert into Cidades (cidade, estado) values ('Ladário', 'MS');
Insert into Cidades (cidade, estado) values ('Laguna Carapã', 'MS');
Insert into Cidades (cidade, estado) values ('Maracaju', 'MS');
Insert into Cidades (cidade, estado) values ('Miranda', 'MS');
Insert into Cidades (cidade, estado) values ('Mundo Novo', 'MS');
Insert into Cidades (cidade, estado) values ('Naviraí', 'MS');
Insert into Cidades (cidade, estado) values ('Nioaque', 'MS');
Insert into Cidades (cidade, estado) values ('Nova Alvorada do Sul', 'MS');
Insert into Cidades (cidade, estado) values ('Nova Andradina', 'MS');
Insert into Cidades (cidade, estado) values ('Novo Horizonte do Sul', 'MS');
Insert into Cidades (cidade, estado) values ('Paraíso das Águas', 'MS');
Insert into Cidades (cidade, estado) values ('Paranaíba', 'MS');
Insert into Cidades (cidade, estado) values ('Paranhos', 'MS');
Insert into Cidades (cidade, estado) values ('Pedro Gomes', 'MS');
Insert into Cidades (cidade, estado) values ('Ponta Porã', 'MS');
Insert into Cidades (cidade, estado) values ('Porto Murtinho', 'MS');
Insert into Cidades (cidade, estado) values ('Ribas do Rio Pardo', 'MS');
Insert into Cidades (cidade, estado) values ('Rio Brilhante', 'MS');
Insert into Cidades (cidade, estado) values ('Rio Negro', 'MS');
Insert into Cidades (cidade, estado) values ('Rio Verde de Mato Grosso', 'MS');
Insert into Cidades (cidade, estado) values ('Rochedo', 'MS');
Insert into Cidades (cidade, estado) values ('Santa Rita do Pardo', 'MS');
Insert into Cidades (cidade, estado) values ('São Gabriel do Oeste', 'MS');
Insert into Cidades (cidade, estado) values ('Sete Quedas', 'MS');
Insert into Cidades (cidade, estado) values ('Selvíria', 'MS');
Insert into Cidades (cidade, estado) values ('Sidrolândia', 'MS');
Insert into Cidades (cidade, estado) values ('Sonora', 'MS');
Insert into Cidades (cidade, estado) values ('Tacuru', 'MS');
Insert into Cidades (cidade, estado) values ('Taquarussu', 'MS');
Insert into Cidades (cidade, estado) values ('Terenos', 'MS');
Insert into Cidades (cidade, estado) values ('Três Lagoas', 'MS');
Insert into Cidades (cidade, estado) values ('Vicentina', 'MS');
Insert into Cidades (cidade, estado) values ('Acorizal', 'MT');
Insert into Cidades (cidade, estado) values ('Água Boa', 'MT');
Insert into Cidades (cidade, estado) values ('Alta Floresta', 'MT');
Insert into Cidades (cidade, estado) values ('Alto Araguaia', 'MT');
Insert into Cidades (cidade, estado) values ('Alto Boa Vista', 'MT');
Insert into Cidades (cidade, estado) values ('Alto Garças', 'MT');
Insert into Cidades (cidade, estado) values ('Alto Paraguai', 'MT');
Insert into Cidades (cidade, estado) values ('Alto Taquari', 'MT');
Insert into Cidades (cidade, estado) values ('Apiacás', 'MT');
Insert into Cidades (cidade, estado) values ('Araguaiana', 'MT');
Insert into Cidades (cidade, estado) values ('Araguainha', 'MT');
Insert into Cidades (cidade, estado) values ('Araputanga', 'MT');
Insert into Cidades (cidade, estado) values ('Arenápolis', 'MT');
Insert into Cidades (cidade, estado) values ('Aripuanã', 'MT');
Insert into Cidades (cidade, estado) values ('Barão de Melgaço', 'MT');
Insert into Cidades (cidade, estado) values ('Barra do Bugres', 'MT');
Insert into Cidades (cidade, estado) values ('Barra do Garças', 'MT');
Insert into Cidades (cidade, estado) values ('Bom Jesus do Araguaia', 'MT');
Insert into Cidades (cidade, estado) values ('Brasnorte', 'MT');
Insert into Cidades (cidade, estado) values ('Cáceres', 'MT');
Insert into Cidades (cidade, estado) values ('Campinápolis', 'MT');
Insert into Cidades (cidade, estado) values ('Campo Novo do Parecis', 'MT');
Insert into Cidades (cidade, estado) values ('Campo Verde', 'MT');
Insert into Cidades (cidade, estado) values ('Campos de Júlio', 'MT');
Insert into Cidades (cidade, estado) values ('Canabrava do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Canarana', 'MT');
Insert into Cidades (cidade, estado) values ('Carlinda', 'MT');
Insert into Cidades (cidade, estado) values ('Castanheira', 'MT');
Insert into Cidades (cidade, estado) values ('Chapada dos Guimarães', 'MT');
Insert into Cidades (cidade, estado) values ('Cláudia', 'MT');
Insert into Cidades (cidade, estado) values ('Cocalinho', 'MT');
Insert into Cidades (cidade, estado) values ('Colíder', 'MT');
Insert into Cidades (cidade, estado) values ('Colniza', 'MT');
Insert into Cidades (cidade, estado) values ('Comodoro', 'MT');
Insert into Cidades (cidade, estado) values ('Confresa', 'MT');
Insert into Cidades (cidade, estado) values ('Conquista D''Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Cotriguaçu', 'MT');
Insert into Cidades (cidade, estado) values ('Cuiabá', 'MT');
Insert into Cidades (cidade, estado) values ('Curvelândia', 'MT');
Insert into Cidades (cidade, estado) values ('Denise', 'MT');
Insert into Cidades (cidade, estado) values ('Diamantino', 'MT');
Insert into Cidades (cidade, estado) values ('Dom Aquino', 'MT');
Insert into Cidades (cidade, estado) values ('Feliz Natal', 'MT');
Insert into Cidades (cidade, estado) values ('Figueirópolis D''Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Gaúcha do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('General Carneiro', 'MT');
Insert into Cidades (cidade, estado) values ('Glória D''Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Guarantã do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Guiratinga', 'MT');
Insert into Cidades (cidade, estado) values ('Indiavaí', 'MT');
Insert into Cidades (cidade, estado) values ('Ipiranga do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Itanhangá', 'MT');
Insert into Cidades (cidade, estado) values ('Itaúba', 'MT');
Insert into Cidades (cidade, estado) values ('Itiquira', 'MT');
Insert into Cidades (cidade, estado) values ('Jaciara', 'MT');
Insert into Cidades (cidade, estado) values ('Jangada', 'MT');
Insert into Cidades (cidade, estado) values ('Jauru', 'MT');
Insert into Cidades (cidade, estado) values ('Juara', 'MT');
Insert into Cidades (cidade, estado) values ('Juína', 'MT');
Insert into Cidades (cidade, estado) values ('Juruena', 'MT');
Insert into Cidades (cidade, estado) values ('Juscimeira', 'MT');
Insert into Cidades (cidade, estado) values ('Lambari D''Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Lucas do Rio Verde', 'MT');
Insert into Cidades (cidade, estado) values ('Luciara', 'MT');
Insert into Cidades (cidade, estado) values ('Vila Bela da Santíssima Trindade', 'MT');
Insert into Cidades (cidade, estado) values ('Marcelândia', 'MT');
Insert into Cidades (cidade, estado) values ('Matupá', 'MT');
Insert into Cidades (cidade, estado) values ('Mirassol D''Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Nobres', 'MT');
Insert into Cidades (cidade, estado) values ('Nortelândia', 'MT');
Insert into Cidades (cidade, estado) values ('Nossa Senhora do Livramento', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Bandeirantes', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Nazaré', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Lacerda', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Santa Helena', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Brasilândia', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Canaã do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Mutum', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Olímpia', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Ubiratã', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Xavantina', 'MT');
Insert into Cidades (cidade, estado) values ('Novo Mundo', 'MT');
Insert into Cidades (cidade, estado) values ('Novo Horizonte do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Novo São Joaquim', 'MT');
Insert into Cidades (cidade, estado) values ('Paranaíta', 'MT');
Insert into Cidades (cidade, estado) values ('Paranatinga', 'MT');
Insert into Cidades (cidade, estado) values ('Novo Santo Antônio', 'MT');
Insert into Cidades (cidade, estado) values ('Pedra Preta', 'MT');
Insert into Cidades (cidade, estado) values ('Peixoto de Azevedo', 'MT');
Insert into Cidades (cidade, estado) values ('Planalto da Serra', 'MT');
Insert into Cidades (cidade, estado) values ('Poconé', 'MT');
Insert into Cidades (cidade, estado) values ('Pontal do Araguaia', 'MT');
Insert into Cidades (cidade, estado) values ('Ponte Branca', 'MT');
Insert into Cidades (cidade, estado) values ('Pontes e Lacerda', 'MT');
Insert into Cidades (cidade, estado) values ('Porto Alegre do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Porto dos Gaúchos', 'MT');
Insert into Cidades (cidade, estado) values ('Porto Esperidião', 'MT');
Insert into Cidades (cidade, estado) values ('Porto Estrela', 'MT');
Insert into Cidades (cidade, estado) values ('Poxoréo', 'MT');
Insert into Cidades (cidade, estado) values ('Primavera do Leste', 'MT');
Insert into Cidades (cidade, estado) values ('Querência', 'MT');
Insert into Cidades (cidade, estado) values ('São José dos Quatro Marcos', 'MT');
Insert into Cidades (cidade, estado) values ('Reserva do Cabaçal', 'MT');
Insert into Cidades (cidade, estado) values ('Ribeirão Cascalheira', 'MT');
Insert into Cidades (cidade, estado) values ('Ribeirãozinho', 'MT');
Insert into Cidades (cidade, estado) values ('Rio Branco', 'MT');
Insert into Cidades (cidade, estado) values ('Santa Carmem', 'MT');
Insert into Cidades (cidade, estado) values ('Santo Afonso', 'MT');
Insert into Cidades (cidade, estado) values ('São José do Povo', 'MT');
Insert into Cidades (cidade, estado) values ('São José do Rio Claro', 'MT');
Insert into Cidades (cidade, estado) values ('São José do Xingu', 'MT');
Insert into Cidades (cidade, estado) values ('São Pedro da Cipa', 'MT');
Insert into Cidades (cidade, estado) values ('Rondolândia', 'MT');
Insert into Cidades (cidade, estado) values ('Rondonópolis', 'MT');
Insert into Cidades (cidade, estado) values ('Rosário Oeste', 'MT');
Insert into Cidades (cidade, estado) values ('Santa Cruz do Xingu', 'MT');
Insert into Cidades (cidade, estado) values ('Salto do Céu', 'MT');
Insert into Cidades (cidade, estado) values ('Santa Rita do Trivelato', 'MT');
Insert into Cidades (cidade, estado) values ('Santa Terezinha', 'MT');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Leste', 'MT');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Leverger', 'MT');
Insert into Cidades (cidade, estado) values ('São Félix do Araguaia', 'MT');
Insert into Cidades (cidade, estado) values ('Sapezal', 'MT');
Insert into Cidades (cidade, estado) values ('Serra Nova Dourada', 'MT');
Insert into Cidades (cidade, estado) values ('Sinop', 'MT');
Insert into Cidades (cidade, estado) values ('Sorriso', 'MT');
Insert into Cidades (cidade, estado) values ('Tabaporã', 'MT');
Insert into Cidades (cidade, estado) values ('Tangará da Serra', 'MT');
Insert into Cidades (cidade, estado) values ('Tapurah', 'MT');
Insert into Cidades (cidade, estado) values ('Terra Nova do Norte', 'MT');
Insert into Cidades (cidade, estado) values ('Tesouro', 'MT');
Insert into Cidades (cidade, estado) values ('Torixoréu', 'MT');
Insert into Cidades (cidade, estado) values ('União do Sul', 'MT');
Insert into Cidades (cidade, estado) values ('Vale de São Domingos', 'MT');
Insert into Cidades (cidade, estado) values ('Várzea Grande', 'MT');
Insert into Cidades (cidade, estado) values ('Vera', 'MT');
Insert into Cidades (cidade, estado) values ('Vila Rica', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Guarita', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Marilândia', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Maringá', 'MT');
Insert into Cidades (cidade, estado) values ('Nova Monte Verde', 'MT');
Insert into Cidades (cidade, estado) values ('Abadia de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Abadiânia', 'GO');
Insert into Cidades (cidade, estado) values ('Acreúna', 'GO');
Insert into Cidades (cidade, estado) values ('Adelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Água Fria de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Água Limpa', 'GO');
Insert into Cidades (cidade, estado) values ('Águas Lindas de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Alexânia', 'GO');
Insert into Cidades (cidade, estado) values ('Aloândia', 'GO');
Insert into Cidades (cidade, estado) values ('Alto Horizonte', 'GO');
Insert into Cidades (cidade, estado) values ('Alto Paraíso de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Alvorada do Norte', 'GO');
Insert into Cidades (cidade, estado) values ('Amaralina', 'GO');
Insert into Cidades (cidade, estado) values ('Americano do Brasil', 'GO');
Insert into Cidades (cidade, estado) values ('Amorinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Anápolis', 'GO');
Insert into Cidades (cidade, estado) values ('Anhanguera', 'GO');
Insert into Cidades (cidade, estado) values ('Anicuns', 'GO');
Insert into Cidades (cidade, estado) values ('Aparecida de Goiânia', 'GO');
Insert into Cidades (cidade, estado) values ('Aparecida do Rio Doce', 'GO');
Insert into Cidades (cidade, estado) values ('Aporé', 'GO');
Insert into Cidades (cidade, estado) values ('Araçu', 'GO');
Insert into Cidades (cidade, estado) values ('Aragarças', 'GO');
Insert into Cidades (cidade, estado) values ('Aragoiânia', 'GO');
Insert into Cidades (cidade, estado) values ('Araguapaz', 'GO');
Insert into Cidades (cidade, estado) values ('Arenópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Aruanã', 'GO');
Insert into Cidades (cidade, estado) values ('Aurilândia', 'GO');
Insert into Cidades (cidade, estado) values ('Avelinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Baliza', 'GO');
Insert into Cidades (cidade, estado) values ('Barro Alto', 'GO');
Insert into Cidades (cidade, estado) values ('Bela Vista de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Bom Jardim de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Bom Jesus de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Bonfinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Bonópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Brazabrantes', 'GO');
Insert into Cidades (cidade, estado) values ('Britânia', 'GO');
Insert into Cidades (cidade, estado) values ('Buriti Alegre', 'GO');
Insert into Cidades (cidade, estado) values ('Buriti de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Buritinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Cabeceiras', 'GO');
Insert into Cidades (cidade, estado) values ('Cachoeira Alta', 'GO');
Insert into Cidades (cidade, estado) values ('Cachoeira de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Cachoeira Dourada', 'GO');
Insert into Cidades (cidade, estado) values ('Caçu', 'GO');
Insert into Cidades (cidade, estado) values ('Caiapônia', 'GO');
Insert into Cidades (cidade, estado) values ('Caldas Novas', 'GO');
Insert into Cidades (cidade, estado) values ('Caldazinha', 'GO');
Insert into Cidades (cidade, estado) values ('Campestre de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Campinaçu', 'GO');
Insert into Cidades (cidade, estado) values ('Campinorte', 'GO');
Insert into Cidades (cidade, estado) values ('Campo Alegre de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Campo Limpo de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Campos Belos', 'GO');
Insert into Cidades (cidade, estado) values ('Campos Verdes', 'GO');
Insert into Cidades (cidade, estado) values ('Carmo do Rio Verde', 'GO');
Insert into Cidades (cidade, estado) values ('Castelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Catalão', 'GO');
Insert into Cidades (cidade, estado) values ('Caturaí', 'GO');
Insert into Cidades (cidade, estado) values ('Cavalcante', 'GO');
Insert into Cidades (cidade, estado) values ('Ceres', 'GO');
Insert into Cidades (cidade, estado) values ('Cezarina', 'GO');
Insert into Cidades (cidade, estado) values ('Chapadão do Céu', 'GO');
Insert into Cidades (cidade, estado) values ('Cidade Ocidental', 'GO');
Insert into Cidades (cidade, estado) values ('Cocalzinho de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Colinas do Sul', 'GO');
Insert into Cidades (cidade, estado) values ('Córrego do Ouro', 'GO');
Insert into Cidades (cidade, estado) values ('Corumbá de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Corumbaíba', 'GO');
Insert into Cidades (cidade, estado) values ('Cristalina', 'GO');
Insert into Cidades (cidade, estado) values ('Cristianópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Crixás', 'GO');
Insert into Cidades (cidade, estado) values ('Cromínia', 'GO');
Insert into Cidades (cidade, estado) values ('Cumari', 'GO');
Insert into Cidades (cidade, estado) values ('Damianópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Damolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Davinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Diorama', 'GO');
Insert into Cidades (cidade, estado) values ('Doverlândia', 'GO');
Insert into Cidades (cidade, estado) values ('Edealina', 'GO');
Insert into Cidades (cidade, estado) values ('Edéia', 'GO');
Insert into Cidades (cidade, estado) values ('Estrela do Norte', 'GO');
Insert into Cidades (cidade, estado) values ('Faina', 'GO');
Insert into Cidades (cidade, estado) values ('Fazenda Nova', 'GO');
Insert into Cidades (cidade, estado) values ('Firminópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Flores de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Formosa', 'GO');
Insert into Cidades (cidade, estado) values ('Formoso', 'GO');
Insert into Cidades (cidade, estado) values ('Gameleira de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Divinópolis de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Goianápolis', 'GO');
Insert into Cidades (cidade, estado) values ('Goiandira', 'GO');
Insert into Cidades (cidade, estado) values ('Goianésia', 'GO');
Insert into Cidades (cidade, estado) values ('Goiânia', 'GO');
Insert into Cidades (cidade, estado) values ('Goianira', 'GO');
Insert into Cidades (cidade, estado) values ('Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Goiatuba', 'GO');
Insert into Cidades (cidade, estado) values ('Gouvelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Guapó', 'GO');
Insert into Cidades (cidade, estado) values ('Guaraíta', 'GO');
Insert into Cidades (cidade, estado) values ('Guarani de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Guarinos', 'GO');
Insert into Cidades (cidade, estado) values ('Heitoraí', 'GO');
Insert into Cidades (cidade, estado) values ('Hidrolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Hidrolina', 'GO');
Insert into Cidades (cidade, estado) values ('Iaciara', 'GO');
Insert into Cidades (cidade, estado) values ('Inaciolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Indiara', 'GO');
Insert into Cidades (cidade, estado) values ('Inhumas', 'GO');
Insert into Cidades (cidade, estado) values ('Ipameri', 'GO');
Insert into Cidades (cidade, estado) values ('Ipiranga de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Iporá', 'GO');
Insert into Cidades (cidade, estado) values ('Israelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Itaberaí', 'GO');
Insert into Cidades (cidade, estado) values ('Itaguari', 'GO');
Insert into Cidades (cidade, estado) values ('Itaguaru', 'GO');
Insert into Cidades (cidade, estado) values ('Itajá', 'GO');
Insert into Cidades (cidade, estado) values ('Itapaci', 'GO');
Insert into Cidades (cidade, estado) values ('Itapirapuã', 'GO');
Insert into Cidades (cidade, estado) values ('Itapuranga', 'GO');
Insert into Cidades (cidade, estado) values ('Itarumã', 'GO');
Insert into Cidades (cidade, estado) values ('Itauçu', 'GO');
Insert into Cidades (cidade, estado) values ('Itumbiara', 'GO');
Insert into Cidades (cidade, estado) values ('Ivolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Jandaia', 'GO');
Insert into Cidades (cidade, estado) values ('Jaraguá', 'GO');
Insert into Cidades (cidade, estado) values ('Jataí', 'GO');
Insert into Cidades (cidade, estado) values ('Jaupaci', 'GO');
Insert into Cidades (cidade, estado) values ('Jesúpolis', 'GO');
Insert into Cidades (cidade, estado) values ('Joviânia', 'GO');
Insert into Cidades (cidade, estado) values ('Jussara', 'GO');
Insert into Cidades (cidade, estado) values ('Lagoa Santa', 'GO');
Insert into Cidades (cidade, estado) values ('Leopoldo de Bulhões', 'GO');
Insert into Cidades (cidade, estado) values ('Luziânia', 'GO');
Insert into Cidades (cidade, estado) values ('Mairipotaba', 'GO');
Insert into Cidades (cidade, estado) values ('Mambaí', 'GO');
Insert into Cidades (cidade, estado) values ('Mara Rosa', 'GO');
Insert into Cidades (cidade, estado) values ('Marzagão', 'GO');
Insert into Cidades (cidade, estado) values ('Matrinchã', 'GO');
Insert into Cidades (cidade, estado) values ('Maurilândia', 'GO');
Insert into Cidades (cidade, estado) values ('Mimoso de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Minaçu', 'GO');
Insert into Cidades (cidade, estado) values ('Mineiros', 'GO');
Insert into Cidades (cidade, estado) values ('Moiporá', 'GO');
Insert into Cidades (cidade, estado) values ('Monte Alegre de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Montes Claros de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Montividiu', 'GO');
Insert into Cidades (cidade, estado) values ('Montividiu do Norte', 'GO');
Insert into Cidades (cidade, estado) values ('Morrinhos', 'GO');
Insert into Cidades (cidade, estado) values ('Morro Agudo de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Mossâmedes', 'GO');
Insert into Cidades (cidade, estado) values ('Mozarlândia', 'GO');
Insert into Cidades (cidade, estado) values ('Mundo Novo', 'GO');
Insert into Cidades (cidade, estado) values ('Mutunópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Nazário', 'GO');
Insert into Cidades (cidade, estado) values ('Nerópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Niquelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Nova América', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Aurora', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Crixás', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Glória', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Iguaçu de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Roma', 'GO');
Insert into Cidades (cidade, estado) values ('Nova Veneza', 'GO');
Insert into Cidades (cidade, estado) values ('Novo Brasil', 'GO');
Insert into Cidades (cidade, estado) values ('Novo Gama', 'GO');
Insert into Cidades (cidade, estado) values ('Novo Planalto', 'GO');
Insert into Cidades (cidade, estado) values ('Orizona', 'GO');
Insert into Cidades (cidade, estado) values ('Ouro Verde de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Ouvidor', 'GO');
Insert into Cidades (cidade, estado) values ('Padre Bernardo', 'GO');
Insert into Cidades (cidade, estado) values ('Palestina de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Palmeiras de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Palmelo', 'GO');
Insert into Cidades (cidade, estado) values ('Palminópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Panamá', 'GO');
Insert into Cidades (cidade, estado) values ('Paranaiguara', 'GO');
Insert into Cidades (cidade, estado) values ('Paraúna', 'GO');
Insert into Cidades (cidade, estado) values ('Perolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Petrolina de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Pilar de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Piracanjuba', 'GO');
Insert into Cidades (cidade, estado) values ('Piranhas', 'GO');
Insert into Cidades (cidade, estado) values ('Pirenópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Pires do Rio', 'GO');
Insert into Cidades (cidade, estado) values ('Planaltina', 'GO');
Insert into Cidades (cidade, estado) values ('Pontalina', 'GO');
Insert into Cidades (cidade, estado) values ('Porangatu', 'GO');
Insert into Cidades (cidade, estado) values ('Porteirão', 'GO');
Insert into Cidades (cidade, estado) values ('Portelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Posse', 'GO');
Insert into Cidades (cidade, estado) values ('Professor Jamil', 'GO');
Insert into Cidades (cidade, estado) values ('Quirinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Rialma', 'GO');
Insert into Cidades (cidade, estado) values ('Rianápolis', 'GO');
Insert into Cidades (cidade, estado) values ('Rio Quente', 'GO');
Insert into Cidades (cidade, estado) values ('Rio Verde', 'GO');
Insert into Cidades (cidade, estado) values ('Rubiataba', 'GO');
Insert into Cidades (cidade, estado) values ('Sanclerlândia', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Bárbara de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Cruz de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Fé de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Helena de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Isabel', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Rita do Araguaia', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Rita do Novo Destino', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Rosa de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Tereza de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santa Terezinha de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santo Antônio da Barra', 'GO');
Insert into Cidades (cidade, estado) values ('Santo Antônio de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Santo Antônio do Descoberto', 'GO');
Insert into Cidades (cidade, estado) values ('São Domingos', 'GO');
Insert into Cidades (cidade, estado) values ('São Francisco de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('São João D''Aliança', 'GO');
Insert into Cidades (cidade, estado) values ('São João da Paraúna', 'GO');
Insert into Cidades (cidade, estado) values ('São Luís de Montes Belos', 'GO');
Insert into Cidades (cidade, estado) values ('São Luíz do Norte', 'GO');
Insert into Cidades (cidade, estado) values ('São Miguel do Araguaia', 'GO');
Insert into Cidades (cidade, estado) values ('São Miguel do Passa Quatro', 'GO');
Insert into Cidades (cidade, estado) values ('São Patrício', 'GO');
Insert into Cidades (cidade, estado) values ('São Simão', 'GO');
Insert into Cidades (cidade, estado) values ('Senador Canedo', 'GO');
Insert into Cidades (cidade, estado) values ('Serranópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Silvânia', 'GO');
Insert into Cidades (cidade, estado) values ('Simolândia', 'GO');
Insert into Cidades (cidade, estado) values ('Sítio D''Abadia', 'GO');
Insert into Cidades (cidade, estado) values ('Taquaral de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Teresina de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Terezópolis de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Três Ranchos', 'GO');
Insert into Cidades (cidade, estado) values ('Trindade', 'GO');
Insert into Cidades (cidade, estado) values ('Trombas', 'GO');
Insert into Cidades (cidade, estado) values ('Turvânia', 'GO');
Insert into Cidades (cidade, estado) values ('Turvelândia', 'GO');
Insert into Cidades (cidade, estado) values ('Uirapuru', 'GO');
Insert into Cidades (cidade, estado) values ('Uruaçu', 'GO');
Insert into Cidades (cidade, estado) values ('Uruana', 'GO');
Insert into Cidades (cidade, estado) values ('Urutaí', 'GO');
Insert into Cidades (cidade, estado) values ('Valparaíso de Goiás', 'GO');
Insert into Cidades (cidade, estado) values ('Varjão', 'GO');
Insert into Cidades (cidade, estado) values ('Vianópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Vicentinópolis', 'GO');
Insert into Cidades (cidade, estado) values ('Vila Boa', 'GO');
Insert into Cidades (cidade, estado) values ('Vila Propício', 'GO');
Insert into Cidades (cidade, estado) values ('Brasília', 'DF');