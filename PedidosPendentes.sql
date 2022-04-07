#/* TABELA loja*/
SELECT 
	empr.storeno AS LJ 
FROM 
	sqldados.emp AS empr 
WHERE 
	empr.no = "[$senha]"
#/*FIM TABELA loja*/
#
SELECT 
	eordcr.storeno    AS storeno,
	eordcr.ordno      AS ordno,
	eordcr.seqno	  AS seqno,
	eordcr.amt	  AS amt,
	eordcr.paymno	  AS paymno

FROM
	[tabela] AS loja,
	sqldados.eord
	LEFT JOIN sqldados.eordcr ON (eord.storeno = eordcr.storeno AND eord.ordno = eordcr.ordno) 
	LEFT JOIN sqldados.nfr ON (nfr.storeno = eord.storeno AND nfr.auxLong1 = eord.ordno)

WHERE
	eord.storeno = loja.LJ AND
        eord.date BETWEEN DATE_FORMAT(DATE_SUB(curdate(), INTERVAL 2 DAY), "%Y%m%d") AND DATE_FORMAT(curdate(), "%Y%m%d")
	AND eordcr.seqno = 0 
	AND NOT eord.bits&POW(2,1)
	AND nfr.xano IS NULL

ORDER BY
	eordcr.ordno
#	
#
SELECT 
	eordcr.storeno    AS storeno,
	eordcr.ordno      AS ordno,
	IF(eordcr.status IN (3,6),COUNT(*)-1,COUNT(*))
			  AS Parc,
	IF(eordcr.seqno = 1 AND eordcr.status IN (3,6),eordcr.amt,0)
			  AS Entrada

FROM
	[tabela] AS loja,	
	sqldados.eord
	LEFT JOIN sqldados.eordcr ON (eord.storeno = eordcr.storeno AND eord.ordno = eordcr.ordno) 
	LEFT JOIN sqldados.nfr ON (nfr.storeno = eord.storeno AND nfr.auxLong1 = eord.ordno)

WHERE
	eord.storeno = loja.LJ AND
        eord.date BETWEEN DATE_FORMAT(DATE_SUB(curdate(), INTERVAL 2 DAY), "%Y%m%d") AND DATE_FORMAT(curdate(), "%Y%m%d")
	AND eordcr.seqno != 0 
	AND NOT eord.bits&POW(2,1)
	AND nfr.xano IS NULL


GROUP BY
	eordcr.storeno,eordcr.ordno
ORDER BY
 	eordcr.ordno
#
#
SELECT 
	eordcr.storeno    AS storeno,
	eordcr.ordno      AS ordno,
        SUM(eordcr.amt)   AS Total

FROM
	[tabela] AS loja,	
	sqldados.eordcr
	LEFT JOIN sqldados.eord ON (eord.storeno = eordcr.storeno AND eord.ordno = eordcr.ordno) 
	LEFT JOIN sqldados.nfr ON (nfr.storeno = eord.storeno AND nfr.auxLong1 = eord.ordno)

WHERE
	eord.storeno = loja.LJ AND
        eord.date BETWEEN DATE_FORMAT(DATE_SUB(curdate(), INTERVAL 2 DAY), "%Y%m%d") AND DATE_FORMAT(curdate(), "%Y%m%d")
	AND NOT eord.bits&POW(2,1)
	AND nfr.xano IS NULL

GROUP BY
	eordcr.storeno,eordcr.ordno
ORDER BY
 	eordcr.ordno

#
SELECT
        ifnull(eord.custno,0)       
   			  AS  Codigo,
        mid(ifnull(custp.name,"SEM CLIENTE"),1,30)
		          AS  Cliente,
	custp.cpf_cgc	  AS  CPF,
        eord.ordno        AS  Pedido,
        DATE_FORMAT(eord.date, "%d/%m/%Y")
                          AS  Data,
        eord.amount       AS  Valor_____,
        tb3.Total         AS  Total_Pedido,
	ifnull(CASE custp.rating
	WHEN 0 THEN "A"
	WHEN 1 THEN "B"
	WHEN 2 THEN "C"
	WHEN 3 THEN "D"
	END,0)		  AS "A/C",
	paym.sname	  AS Metodo____,
	ifnull(tb2.Parc,0)
	 		  AS Parcelas,
	ifnull(tb2.Entrada,0)+ifnull(tb1.amt,0)
			  AS Entrada,
        CASE eord.status
	WHEN 2  THEN "Reserva A"
	WHEN 6  THEN "RESERVA B"
	WHEN 8 THEN "Entrega F"
	END               AS  Situacao



FROM
	[tabela] AS loja,
        sqldados.eord
        LEFT JOIN sqldados.custp ON (eord.custno = custp.no)
	LEFT JOIN [tabela2] AS tb1 ON (eord.storeno = tb1.storeno AND eord.ordno = tb1.ordno)
	LEFT JOIN sqldados.paym ON (eord.paymno = paym.no)
	LEFT JOIN [tabela3] AS tb2 ON (eord.storeno = tb2.storeno AND eord.ordno = tb2.ordno)
	LEFT JOIN [tabela4] AS tb3 ON (eord.storeno = tb3.storeno AND eord.ordno = tb3.ordno)
	LEFT JOIN sqldados.nfr ON (nfr.storeno = eord.storeno AND nfr.auxLong1 = eord.ordno)

WHERE
	eord.storeno = loja.LJ AND
        eord.date BETWEEN DATE_FORMAT(DATE_SUB(curdate(), INTERVAL 2 DAY), "%Y%m%d") AND DATE_FORMAT(curdate(), "%Y%m%d")
        AND eord.status IN (2,6,8)
	AND NOT eord.bits&POW(2,1)
	AND nfr.xano IS NULL

ORDER BY
        eord.storeno, eord.ordno
		
/* 
26/11/2013 Andre Lima
*/
