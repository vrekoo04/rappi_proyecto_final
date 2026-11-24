-- VISTA 1: OPERATIVA. Una fila por pedido, sin multiplicar el envio.
CREATE VIEW dbo.vw_PedidosOperativos AS
WITH Montos AS (
SELECT PedidoID,SUM(Cantidad*PrecioUnitario) AS Subtotal,
 SUM(Cantidad) AS Unidades
FROM dbo.DetallePedido GROUP BY PedidoID
)
SELECT p.PedidoID,p.PedidoOrigen,p.ClienteID,p.ComercioID,
p.RepartidorID,p.FechaPedido,p.FechaEntrega,p.Estado,
m.Nombre AS Comercio,
COALESCE(r.Nombre,N'SIN ASIGNAR') AS Repartidor,
x.Unidades,x.Subtotal,p.CostoEnvio,
x.Subtotal+p.CostoEnvio AS TotalPedido,
DATEDIFF(minute,p.FechaPedido,p.FechaEntrega) AS MinutosEntrega
FROM dbo.Pedidos p
INNER JOIN dbo.Comercios m ON p.ComercioID=m.ComercioID
INNER JOIN Montos x ON p.PedidoID=x.PedidoID
LEFT JOIN dbo.Repartidores r ON p.RepartidorID=r.RepartidorID;
GO

-- VISTA 2: CLIENTE 360. Incluye clientes sin pedidos completos.
CREATE VIEW dbo.vw_Clientes360 AS
SELECT c.ClienteID,TRIM(c.Nombre) AS Nombre,
LOWER(TRIM(c.Email)) AS Email,c.Ciudad,
COUNT(p.PedidoID) AS PedidosRegistrados,
SUM(CASE WHEN p.Estado='ENTREGADO' THEN 1 ELSE 0 END)
 AS PedidosEntregados,
COALESCE(SUM(CASE WHEN p.Estado='ENTREGADO'
 THEN p.TotalPedido ELSE 0 END),0) AS GastoEntregado,
MAX(p.FechaPedido) AS UltimoPedido
FROM dbo.Clientes c
LEFT JOIN dbo.vw_PedidosOperativos p ON c.ClienteID=p.ClienteID
GROUP BY c.ClienteID,c.Nombre,c.Email,c.Ciudad;
GO

-- VISTA 3: RESUMEN KPI. Por fecha de pedido y comercio.
CREATE VIEW dbo.vw_KPI_Diario AS
SELECT CAST(FechaPedido AS date) AS Fecha,ComercioID,Comercio,
COUNT(*) AS PedidosTotales,
SUM(CASE WHEN Estado='ENTREGADO' THEN 1 ELSE 0 END)
 AS PedidosEntregados,
SUM(CASE WHEN Estado='CANCELADO' THEN 1 ELSE 0 END)
 AS PedidosCancelados,
SUM(CASE WHEN Estado='ENTREGADO' THEN TotalPedido ELSE 0 END)
 AS ValorEntregado,
AVG(CASE WHEN Estado='ENTREGADO' THEN TotalPedido END)
 AS TicketPromedioEntregado,
AVG(CASE WHEN Estado='ENTREGADO'
 THEN CAST(MinutosEntrega AS decimal(12,2)) END)
 AS MinutosPromedioEntrega,
CAST(100.0*SUM(CASE WHEN Estado='ENTREGADO' THEN 1 ELSE 0 END)
 /COUNT(*) AS decimal(5,2)) AS PorcentajeEntregados
FROM dbo.vw_PedidosOperativos
GROUP BY CAST(FechaPedido AS date),ComercioID,Comercio;
GO