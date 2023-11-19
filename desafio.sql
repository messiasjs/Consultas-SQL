/*Valor total das vendas e dos fretes por produto e ordem de venda;*/
SELECT 
    #fc.CupomID,
    fc.Data,
    fd.ProdutoID,
    SUM(fd.Valor) AS ValorTotalVenda,
    SUM(fc.ValorFrete) AS ValorTotalFrete
FROM FatoDetalhes fd
JOIN FatoCabecalho fc ON fd.CupomID = fc.CupomID
GROUP BY /*fc.CupomID,*/ fc.Data, fd.ProdutoID;


/*Valor de venda por tipo de produto;*/
SELECT 
    fd.ProdutoID,
    SUM(fd.Valor) AS ValorTotalVenda
FROM FatoDetalhes fd
GROUP BY fd.ProdutoID;


/*Quantidade e valor das vendas por dia, mês, ano;*/
SELECT 
	EXTRACT(YEAR FROM STR_TO_DATE(fc.Data, '%d/%m/%Y')) AS Ano,
    EXTRACT(MONTH FROM STR_TO_DATE(fc.Data, '%d/%m/%Y')) AS Mes,
    EXTRACT(DAY FROM STR_TO_DATE(fc.Data, '%d/%m/%Y')) AS Dia,
    COUNT(*) AS QuantidadeVendas,
    SUM(fd.Valor) AS ValorTotalVenda
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
GROUP BY Ano, Mes, Dia
ORDER BY Ano, Mes, Dia;

/*Lucro dos meses;*/
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(fc.Data, '%d/%m/%Y')) AS Ano,
    EXTRACT(MONTH FROM STR_TO_DATE(fc.Data, '%d/%m/%Y')) AS Mes,
    SUM(fd.Valor - fd.Custo) AS Lucro
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
GROUP BY Ano, Mes
ORDER BY Ano, Mes;


/*Venda por produto;*/
SELECT 
    fd.ProdutoID,
    COUNT(*) AS QuantidadeVendas,
    SUM(fd.Valor) AS ValorTotalVenda
FROM FatoDetalhes fd
GROUP BY fd.ProdutoID;

/*Venda por cliente, cidade do cliente e estado;*/
SELECT 
    dm.ClienteID,
    dm.Cliente,
    dm.Cidade,
    dm.Regiao,
    COUNT(*) AS QuantidadeVendas,
    SUM(fd.Valor) AS ValorTotalVenda
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
JOIN Dimensoes dm ON fc.ClienteID = dm.ClienteID
GROUP BY dm.ClienteID, dm.Cliente, dm.Cidade, dm.Regiao;


/*Média de produtos vendidos;*/
SELECT 
    AVG(Quantidade) AS MediaProdutosVendidos
FROM FatoDetalhes;


/*Média de compras que um cliente faz.*/
SELECT 
    fc.ClienteID,
    COUNT(*) AS QuantidadeCompras,
    AVG(fd.Quantidade) AS MediaProdutosComprados
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
GROUP BY fc.ClienteID;

## OUTRAS

/*Cidades com o maior volume de vendas*/
SELECT 
    dm.Cidade,
    SUM(fd.Valor) AS ValorTotalVenda
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
JOIN Dimensoes dm ON fc.ClienteID = dm.ClienteID
GROUP BY dm.Cidade
ORDER BY ValorTotalVenda DESC;


/*Produtos mais lucrativos*/
SELECT 
    fd.ProdutoID,
    SUM(fd.Valor - fd.Custo) AS LucroTotal
FROM FatoDetalhes fd
GROUP BY fd.ProdutoID
ORDER BY LucroTotal DESC;

/*Funcionários com as maiores médias de vendas*/
SELECT 
    fc.FuncionarioID,
    AVG(fd.Valor) AS MediaVendas
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
GROUP BY fc.FuncionarioID
ORDER BY MediaVendas DESC;

/*Principais clientes em termos de valor total de compras*/
SELECT 
    fc.ClienteID,
    dm.Cliente,
    SUM(fd.Valor) AS ValorTotalCompras
FROM FatoCabecalho fc
JOIN FatoDetalhes fd ON fc.CupomID = fd.CupomID
JOIN Dimensoes dm ON fc.ClienteID = dm.ClienteID
GROUP BY fc.ClienteID, dm.Cliente
ORDER BY ValorTotalCompras DESC;