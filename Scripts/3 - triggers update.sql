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
        IF EXISTS (SELECT 1 FROM CONTAPAGARPARCELAPAGAMENTO T1,CONTAPAGARPARCELA T2 WHERE T2.fk_IdContaPagar = NEW.idContaPagar and t1.fk_IdContaPagarParcela = t2.idContaPagarParcela and t1.valorPagamento <> 0) THEN
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