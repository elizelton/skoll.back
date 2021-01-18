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

--select PARCELAAJUSTECONTRATO(10, 5, cast('2020-01-01' as date))
