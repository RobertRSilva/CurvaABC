-- CENARIO BRASIL VALOR LIQUIDO

-- DECLARA OS ULTIMOS 3 MESES FECHADOS

DECLARE @DataInicial date
		, @DataFinal date;

SET @DataFinal= (select cast(max(EOMONTH ( DT_REFERENCIA,-1)) as date) from FT_COMPRA) 
SET @DataInicial = dateadd(day,+1,dateadd(month, -4, @DataFinal)); 

PRINT @DataInicial 
PRINT @DataFinal


SELECT 
d2.ean
,d2.produto
,d2.Valor_liquido_item
,d2.PERC
,d2.Agrupamento_Percentual
,case	
	WHEN d2.Agrupamento_Percentual <= 80 then 'A'
	WHEN d2.Agrupamento_Percentual <= 95 then 'B'
	ELSE 'C' END AS CURVA 

FROM(

SELECT 
d1.ean
,d1.produto
,d1.Valor_liquido_item
,d1.PERC
,SUM(d1.PERC) OVER (ORDER BY d1.PERC desc) AS Agrupamento_Percentual

FROM (

SELECT 
d.ean
,d.produto
,d.Valor_liquido_item
,CAST(d.Valor_liquido_item AS numeric (15,3)) / CAST(sum(d.Valor_liquido_item) over() AS  numeric (15,3)) * 100 AS PERC 

FROM(
	SELECT
		C.ean
		,C.PRODUTO
		,SUM(a.valor_liquido) as Valor_liquido_item
		FROM FT_COMPRA A

		LEFT JOIN DM_LOJA B
		ON A.loja_cnpj=B.cnpj
		LEFT JOIN DM_PRODUTO C
		ON A.produto_ean=C.ean

		WHERE  
		CAST(dt_referencia as date) between @DataInicial and @DataFinal
		group by
		C.ean
		,C.PRODUTO) d) 
						d1) d2
