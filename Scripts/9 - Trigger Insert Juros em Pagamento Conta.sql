CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTA() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTA$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContaPagar into idCont from ContaPagarParcela where idContaPagarParcela = NEW.fk_IdContaPagarParcela;

    UPDATE ContaPagar SET juros = COALESCE((select sum(juros) from ContaPagarParcelaPagamento where fk_IdContaPagarParcela in (select idContaPagarParcela from ContaPagarParcela where fk_idContaPagar = idCont)),0) where idContaPagar = idCont;
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

    UPDATE CONTAPAGAR SET juros = COALESCE((select sum(juros) from ContaPagarParcelaPagamento where fk_IdContaPagarParcela in (select idContaPagarParcela from ContaPagarParcela where fk_idContaPagar = idCont)),0) where idContaPagar = idCont;
    RETURN OLD;      
END
$VALORJUROSPAGAMENTOCONTADELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContaDeleteTrigger
AFTER DELETE ON ContaPagarParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTADELETE();
