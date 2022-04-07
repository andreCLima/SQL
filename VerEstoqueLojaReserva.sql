# /****TABELA 1****/
SELECT
        dep.storeno,
		cent.sname,
        dep.prdno,
        pro.name,
        dep.grade,
        dep.qtty_varejo
FROM
        sqldados.prd pro,
        sqldados.cl cent,
        sqldados.stk dep
WHERE
        NOT pro.dereg&POW(2,2) AND
        (if([$CL]=0,[$CL]=0,
                if(mid([$CL],5,2)>0,pro.clno=[$CL],
                if(mid([$CL],3,2)>0,mid(lpad(pro.clno,6,0),1,4)=mid(lpad([$CL],6,0),1,4),mid(lpad(pro.clno,6,0),1,2)=mid(lpad([$CL],6,0),1,2)))))
        AND (pro.clno != 999999) AND
        dep.storeno = 1 AND
        dep.prdno = pro.no AND
        cent.no = pro.clno
#
# /***TABELA 2****/
select 
	eopf.storeno as loja,
	eopf.ordno as pedido, 
	eop2.storenoStk as estoque, 
	eopf.prdno as produto, 
	eopf.grade as grade, 
	sum(eopf.qtty_rcv-eopf.qtty_deliv) as reserva
from sqldados.eoprdf as eopf
left join sqldados.eoprd2 as eop2 on
	eop2.storeno = eopf.storeno and
	eop2.ordno = eopf.ordno and
	eop2.prdno = eopf.prdno and
	eop2.grade = eopf.grade
where eopf.qtty_rcv > 0 
	and eopf.auxLong2 = 0 
	and eopf.qtty_rcv != eopf.qtty_deliv
group by eopf.storeno, eopf.prdno, eopf.grade
union
select 
	eop.storeno as loja,
	eop.ordno as pedido,
	if(isnull(eop2.storenoStk), eop.storeno, eop2.storenoStk) as estoque, 
	eop.prdno as produto, 
	eop.grade as grade, 
	sum(eop.qtty) as reserva 
from sqldados.eoprd as eop
left join sqldados.eoprd2 as eop2 on
	eop2.storeno = eop.storeno and
	eop2.ordno = eop.ordno and
	eop2.prdno = eop.prdno and
	eop2.grade = eop.grade 
where (eop.status = 2 or eop.status = 6 or eop.status = 7)
group by eop.storeno, eop.prdno, eop.grade
#
# /***TABELA 3*****/
SELECT
	tab1.*,
	tab2.reserva
FROM
	[TABELA] as tab1,
	[TABELA2] as tab2
where
	tab2.estoque = tab1.storeno and
	tab2.produto = tab1.prdno and
	tab2.grade = tab1.grade
#

		
SELECT
	IF(loja.storeno IS NULL,'N',loja.storeno)  AS "Loja",
	tab1.sname AS "Cent_Luc",
	TRIM(tab1.prdno) AS "Cod. Pro.",
	tab1.name AS "Descricao",
	tab1.grade AS "Grade PRO.",
	IF(loja.qtty_varejo IS NULL,'NAO',loja.qtty_varejo DIV 1000) AS "Varejo",
	tab1.qtty_varejo DIV 1000 AS "Deposito",
	tab1.reserva DIV 1000 as "Reserva"
FROM
	[tabela3] AS tab1
LEFT JOIN
	sqldados.stk loja
ON
	(loja.storeno = IF([$lj]=1,0,[$lj]) OR [$lj] = 0 OR [$lj] = 1) AND
	loja.prdno = tab1.prdno AND
	loja.grade = tab1.grade
ORDER BY
	loja.storeno DESC,
	tab1.prdno

/*
09/09/2013 - André
26/09/2013 - centro de lucro
11/10/2013 - Relação Deposito - Loja
as chaves da tabela stk são: Loja + Grade + Produto
obs: produtos ativos: pro.dereg&POW(2,2)
*/
