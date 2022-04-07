WITH Recursive Seq
AS(SELECT 1 AS ID from rdb$database
    Union ALL
   SELECT ID + 1 FROM Seq
    WHERE ID < :NM)
select left(trim(pro.fornecedor),3) as FORN, pro.DESCRIPTION as DESCR, pro.PARTNO,
pro.LISTPRICE as PRCO, pro.COR as TAM,
substring(trim(pro.codigo_texto) from (char_length(trim(pro.cor))+char_length(trim(pro.secao))+3) for 3) as COR
from TBPRODUTO pro
inner join Seq on (Seq.ID between 0 and pro.onhand)
where pro.ONHAND > 0 and pro.DATACOMPRA = :DT and pro.SECAO like :SC and pro.FORNECEDOR like :FN 
order by pro.partno
