<h1 align="center">:file_cabinet: Exemplo de README.md</h1>

## :memo: Descrição
O projeto tem como foco a analise de compra de SKU's utilizando a metodologai curva ABC.

## :wrench: Tecnologias utilizadas

* Integration Services como ferramenta de ETL para realizar a manipulação dos Dados. Simulando a captura desses arquivos em formato .csv de uma pasta na rede para envio a um banco SQL;
* Banco SQL Server para simular um Datawarehouse
* Linguagem T-SQL para tratamento dos dados e analise do cenario.

## :rocket: Rodando o projeto
1. Os arquivos foram salvos em uma pasta na rede :

Para Rodar o Cenario Brasil VALOR LIQUIDO:
```
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

```
Para Rodar o Cenario Brasil Quantidade:
```
-- CENARIO BRASIL QUANTIDADE

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
,d2.Quantidade
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
,d1.Quantidade
,d1.PERC
,SUM(d1.PERC) OVER (ORDER BY d1.PERC desc) AS Agrupamento_Percentual

FROM (

SELECT 
d.ean
,d.produto
,d.Quantidade
,CAST(d.Quantidade AS numeric (15,3)) / CAST(sum(d.Quantidade) over() AS  numeric (15,3)) * 100 AS PERC 

FROM(
	SELECT
		C.ean
		,C.PRODUTO
		,cast(SUM(a.quantidade_trib) as int) as Quantidade
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
```
## :soon: Implementação futura
* O que será implementado na próxima sprint?

## :handshake: Colaboradores
<table>
  <tr>
    <td align="center">
      <a href="http://github.com/tatialveso">
        <img src="https://avatars.githubusercontent.com/u/56259137?v=4" width="100px;" alt="Foto de Tati Alves no GitHub"/><br>
        <sub>
          <b>tatialveso</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

## :dart: Status do projeto
