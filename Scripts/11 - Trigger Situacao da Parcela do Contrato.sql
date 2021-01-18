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
