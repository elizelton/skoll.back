CREATE OR REPLACE FUNCTION VALORTOTALCONTRATOPARCELA() RETURNS trigger AS 
$VALORTOTALCONTRATOPARCELA$ 
BEGIN    
    UPDATE Contrato SET valorTotal = (select sum(valorParcela) from ContratoParcela where fk_idContrato = NEW.fk_idContrato) where idContrato = NEW.fk_idContrato;
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
    UPDATE Contrato SET valorTotal =  (select sum(valorParcela) from ContratoParcela where fk_idContrato = NEW.fk_idContrato) where idContrato = OLD.fk_idContrato;
    RETURN OLD;      
END
$VALORTOTALCONTRATOPARCELADELETE$
LANGUAGE plpgsql;

CREATE TRIGGER ajustaTotalContratoDeleteTrigger
AFTER DELETE ON ContratoParcela
FOR EACH ROW
EXECUTE PROCEDURE VALORTOTALCONTRATOPARCELADELETE();