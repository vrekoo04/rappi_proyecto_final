-- PROCEDIMIENTO 1: INSERCION CONTROLADA.
CREATE PROCEDURE dbo.usp_RegistrarCliente
@Nombre nvarchar(120), @Email varchar(254),
@Telefono varchar(20)=NULL, @Ciudad nvarchar(80)=N'LEON'
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET @Nombre=NULLIF(TRIM(@Nombre),N'');
SET @Email=NULLIF(LOWER(TRIM(@Email)),'');
SET @Telefono=NULLIF(TRIM(@Telefono),'');
SET @Ciudad=NULLIF(UPPER(TRIM(@Ciudad)),N'');
IF @Nombre IS NULL OR @Email IS NULL OR @Ciudad IS NULL
 THROW 50001,'Nombre, email y ciudad son obligatorios.',1;
IF @Email NOT LIKE '%_@_%._%' OR @Email LIKE '% %'
 THROW 50002,'Formato de email invalido.',1;
-- Validacion de formato basica, no verifica que el correo exista.
BEGIN TRY
 BEGIN TRANSACTION;
 IF EXISTS (SELECT 1 FROM dbo.Clientes WITH (UPDLOCK,HOLDLOCK)
 WHERE Email=@Email)
 THROW 50003,'El email ya esta registrado.',1;
 INSERT INTO dbo.Clientes(Nombre,Email,Telefono,Ciudad)
 VALUES(@Nombre,@Email,@Telefono,@Ciudad);
 DECLARE @NuevoID int=CONVERT(int,SCOPE_IDENTITY());
 COMMIT;
 SELECT @NuevoID AS ClienteID;
END TRY
BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK;
 THROW;
END CATCH;
END;
GO

-- PROCEDIMIENTO 2: CONSULTA POR ID.
CREATE PROCEDURE dbo.usp_ConsultarCliente @ClienteID int
AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE ClienteID=@ClienteID)
 THROW 50004,'Cliente no encontrado.',1;
SELECT ClienteID,TRIM(Nombre) AS Nombre,
 LOWER(TRIM(Email)) AS Email,
 COALESCE(NULLIF(TRIM(Telefono),''),'SIN TELEFONO') AS Telefono,
 UPPER(TRIM(Ciudad)) AS Ciudad
FROM dbo.Clientes WHERE ClienteID=@ClienteID;
END;
GO

-- PROCEDIMIENTO 3: HISTORIAL POR CLIENTE Y FECHAS.
CREATE PROCEDURE dbo.usp_HistorialCliente
@ClienteID int, @FechaInicio date, @FechaFin date
AS
BEGIN
SET NOCOUNT ON;
IF @FechaInicio IS NULL OR @FechaFin IS NULL
 OR @FechaInicio>@FechaFin OR @FechaFin='99991231'
 THROW 50005,'Rango de fechas invalido.',1;
IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE ClienteID=@ClienteID)
 THROW 50004,'Cliente no encontrado.',1;
SELECT c.ClienteID,TRIM(c.Nombre) AS Cliente,
 p.PedidoID,p.FechaPedido,p.Comercio,p.Estado,
 p.Subtotal,p.CostoEnvio,p.TotalPedido
FROM dbo.Clientes c
INNER JOIN dbo.vw_PedidosOperativos p ON c.ClienteID=p.ClienteID
WHERE c.ClienteID=@ClienteID AND p.FechaPedido>=@FechaInicio
 AND p.FechaPedido<DATEADD(day,1,@FechaFin)
ORDER BY p.FechaPedido,p.PedidoID;
END;
GO