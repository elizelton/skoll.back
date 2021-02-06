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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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
		RETURN OLD;
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