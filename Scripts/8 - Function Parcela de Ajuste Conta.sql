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

--select PARCELAAJUSTECONTA(10, 5, cast('2020-01-01' as date))
