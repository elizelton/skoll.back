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
