create database Rappi_2
/* Proyecto académico Rappi | SQL Server 2019/2022.
 Ejecutar en una BASE VACÍA seleccionada en SSMS. No elimina objetos.
 Modelo propuesto; no representa la base interna de Rappi. */
SET XACT_ABORT ON;
GO
CREATE TABLE dbo.Clientes (
ClienteID int IDENTITY(1,1) PRIMARY KEY,
Nombre nvarchar(120) NOT NULL,
Email varchar(254) NOT NULL UNIQUE,
Telefono varchar(20) NULL,
Ciudad nvarchar(80) NOT NULL
);
CREATE TABLE dbo.Comercios (
ComercioID int IDENTITY(1,1) PRIMARY KEY,
Nombre nvarchar(120) NOT NULL,
Categoria nvarchar(60) NOT NULL,
Ciudad nvarchar(80) NOT NULL
);
CREATE TABLE dbo.Repartidores (
RepartidorID int IDENTITY(1,1) PRIMARY KEY,
Nombre nvarchar(120) NOT NULL,
Telefono varchar(20) NOT NULL UNIQUE
);
CREATE TABLE dbo.Productos (
ProductoID int IDENTITY(1,1) PRIMARY KEY,
ComercioID int NOT NULL REFERENCES dbo.Comercios(ComercioID),
Nombre nvarchar(120) NOT NULL,
Precio decimal(12,2) NOT NULL CHECK (Precio >= 0),
Activo bit NOT NULL DEFAULT 1,
UNIQUE (ProductoID, ComercioID)
);
CREATE TABLE dbo.Pedidos (
PedidoID int IDENTITY(1,1) PRIMARY KEY,
PedidoOrigen varchar(40) NOT NULL UNIQUE,
ClienteID int NOT NULL REFERENCES dbo.Clientes(ClienteID),
ComercioID int NOT NULL REFERENCES dbo.Comercios(ComercioID),
RepartidorID int NULL REFERENCES dbo.Repartidores(RepartidorID),
FechaPedido datetime2(0) NOT NULL,
FechaEntrega datetime2(0) NULL,
Estado varchar(20) NOT NULL,
CostoEnvio decimal(12,2) NOT NULL CHECK (CostoEnvio >= 0),
CHECK (Estado IN ('PENDIENTE','EN_CAMINO','ENTREGADO','CANCELADO')),
CHECK (FechaEntrega IS NULL OR FechaEntrega >= FechaPedido),
CHECK (Estado <> 'ENTREGADO' OR
 (FechaEntrega IS NOT NULL AND RepartidorID IS NOT NULL)),
UNIQUE (PedidoID, ComercioID)
);
CREATE TABLE dbo.DetallePedido (
PedidoID int NOT NULL,
ProductoID int NOT NULL,
ComercioID int NOT NULL,
Cantidad int NOT NULL CHECK (Cantidad > 0),
PrecioUnitario decimal(12,2) NOT NULL CHECK (PrecioUnitario >= 0),
PRIMARY KEY (PedidoID, ProductoID),
FOREIGN KEY (PedidoID, ComercioID)
 REFERENCES dbo.Pedidos(PedidoID, ComercioID),
FOREIGN KEY (ProductoID, ComercioID)
 REFERENCES dbo.Productos(ProductoID, ComercioID)
);
CREATE INDEX IX_Pedidos_Cliente_Fecha
ON dbo.Pedidos(ClienteID, FechaPedido);
CREATE TABLE dbo.StgPedidos (
StagingID bigint IDENTITY(1,1) PRIMARY KEY,
PedidoOrigen varchar(100) NULL,
ClienteIDTexto varchar(40) NULL,
ComercioIDTexto varchar(40) NULL,
RepartidorIDTexto varchar(40) NULL,
FechaPedidoTexto varchar(60) NULL,
FechaEntregaTexto varchar(60) NULL,
EstadoTexto varchar(60) NULL,
CostoEnvioTexto varchar(60) NULL,
FechaIngesta datetime2(0) NOT NULL DEFAULT SYSDATETIME()
);
GO

drop table 
