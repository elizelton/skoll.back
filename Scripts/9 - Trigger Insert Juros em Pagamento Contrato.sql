CREATE OR REPLACE FUNCTION VALORJUROSPAGAMENTOCONTRATO() RETURNS trigger AS 
$VALORJUROSPAGAMENTOCONTRATO$ 
    DECLARE idCont INTEGER;
BEGIN    
    select fk_idContrato into idCont from ContratoParcela where idContratoParcela = NEW.fk_IdContratoParcela;

    UPDATE CONTRATO SET juros = COALESCE((select sum(juros) from contratoParcelaPagamento where fk_IdContratoParcela in (select idContratoParcela from ContratoParcela where fk_idContrato = idCont)),0) where idContrato = idCont;
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

    UPDATE CONTRATO SET juros = COALESCE((select sum(juros) from contratoParcelaPagamento where fk_IdContratoParcela in (select idContratoParcela from ContratoParcela where fk_idContrato = idCont)),0) where idContrato = idCont;
    RETURN OLD;       
END
$VALORJUROSPAGAMENTOCONTRATODELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaJurosContratoDeleteTrigger
AFTER DELETE ON ContratoParcelaPagamento
FOR EACH ROW
EXECUTE PROCEDURE VALORJUROSPAGAMENTOCONTRATODELETE();

