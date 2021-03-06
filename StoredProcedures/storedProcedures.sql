USE [ProyectoDBII_Last]
GO
/****** Object:  StoredProcedure [dbo].[spAddCliente]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAddCliente]
--Variables auxiliares
@Nombre varchar(20), @Estado varchar(1), @RTN varchar(20),
@Telefono varchar(10), @Direccion varchar(50) 
as
	--Declaracion de la variable para autonumerica
	declare @Id as int
	--Autoincremento
	select @Id = isnull(max(id),0) + 1 from CLIENTE
	--Antes de la Inserción
	--select * from CLIENTE
	--Inserción
	insert into CLIENTE values(@Id, @Nombre, @Estado, @RTN, @Telefono, @Direccion)
	----Después de la Inserción
	--select * from CLIENTE
GO
/****** Object:  StoredProcedure [dbo].[spAddContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddContrato] @clienteID numeric, @fechaInicio date,@fechafinal date ,@tecnicoID numeric
AS
DECLARE @id NUMERIC
SELECT @id =isnull(MAX(id),0)+1 FROM CONTRATOS
insert into CONTRATOS(id, clienteID,fechaContrato, fechaFinalizacion, tecnicoID) values (@id,@ClienteId,@fechaInicio,@fechafinal,@tecnicoID)
GO
/****** Object:  StoredProcedure [dbo].[spAddDetalleContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDetalleContrato] @contratoID numeric, @servicioID numeric
AS
	DECLARE @id numeric
	SELECT @id=ISNULL(MAX(id),0)+1 FROM DETALLE_CONTRATO
	INSERT INTO DETALLE_CONTRATO(id, contratoID, servicioID) VALUES
	(@id, @contratoID, @servicioID)
GO
/****** Object:  StoredProcedure [dbo].[spAddDetalleFactura]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDetalleFactura] @facturaID numeric, @ordenID numeric
AS
	DECLARE @id numeric
	SELECT @id=ISNULL(MAX(id),0)+1 FROM DETALLE_FACTURA_SERVICIO

	INSERT INTO DETALLE_FACTURA_SERVICIO(id, facturaID, ordenID) VALUES
	(@id, @facturaID, @ordenID)
GO
/****** Object:  StoredProcedure [dbo].[spAddDetalleOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDetalleOrdenTrabajo]
@ordentrabajoid numeric, @tecnicoid numeric, @servicioid numeric  
AS
	DECLARE @ID AS INT
	SELECT @ID = ISNULL(MAX(ID),0) + 1 FROM DETALLE_ORDEN_TRABAJO
	INSERT INTO DETALLE_ORDEN_TRABAJO VALUES(@ID, @ORDENTRABAJOID, @TECNICOID, @SERVICIOID)
GO
/****** Object:  StoredProcedure [dbo].[spAddDetallePaquete]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddDetallePaquete]
@ServicioId int, @PaqueteId int
AS
	BEGIN TRY
		DECLARE @id numeric
		DECLARE @tipo varchar
		SELECT @id=ISNULL(MAX(ID),0)+1 FROM DETALLE_PAQUETE
		SELECT @tipo=tipo FROM SERVICIOS WHERE id=@ServicioId
		IF @tipo='I'
			INSERT INTO DETALLE_PAQUETE(id,paqueteID, servicioID) VALUES
			(@id,@paqueteID, @servicioID)
		ELSE
			THROW 51000, 'El servicio no es individual', 1
	END TRY
	BEGIN CATCH
		THROW
	END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[spAddDisponibilidadTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDisponibilidadTecnico] @tecnicoID numeric, @estado varchar, @desde datetime, @hasta datetime
AS
DECLARE @id numeric
SELECT @id=ISNULL(MAX(id),0)+1 FROM DISPONIBILIDAD_TECNICOS
INSERT INTO DISPONIBILIDAD_TECNICOS(id, tecnicoID, estado,desde, hasta) VALUES
(@id, @tecnicoID, @estado,@desde, @hasta)
GO
/****** Object:  StoredProcedure [dbo].[spAddFacturaServicio]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddFacturaServicio]  @servicioID numeric, @valor float, @fecha datetime, @clienteID numeric
AS
DECLARE @id numeric
SELECT @id=ISNULL(MAX(id),0)+1 FROM FACTURA_SERVICIO
INSERT INTO FACTURA_SERVICIO(id, servicioID, valor, fecha, clienteID) VALUES
(@id, @servicioID, @valor, @fecha, @clienteID)
GO
/****** Object:  StoredProcedure [dbo].[spAddNuevoContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAddNuevoContrato] @ClienteId numeric, @fechaInicio datetime,@fechafinal datetime, @tecnicoID numeric, @servicioID numeric
as

BEGIN TRY
		BEGIN TRANSACTION
			
			DECLARE @contratoID numeric

			SELECT @contratoID=MAX(id) FROM CONTRATOS

			EXEC spAddContrato @ClienteId, @fechaInicio,@fechafinal,@tecnicoID


			EXEC spAddDetalleContrato @contratoID, @servicioID

			if (select tipo from SERVICIOS where id = @servicioID)='I'
			THROW 52000, 'paqueteID no corresponde a un servicio tipo paquete(P)', 1
	
			IF @@TRANCOUNT > 0
				COMMIT
		END TRY
		BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK;
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
			THROW
        END CATCH
	
GO
/****** Object:  StoredProcedure [dbo].[spAddOrdenDeTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spAddOrdenDeTrabajo] @ClienteID numeric, @fechainicio datetime, @fechafinal datetime, @tecnicoId numeric, @servicioId numeric
as

Begin tran

DECLARE @OrdenTrabajoId NUMERIC
SELECT @OrdenTrabajoId=isnull(MAX(id),0)+1 FROM ORDEN_TRABAJO

DECLARE @OrdenTrabajoDetalleId NUMERIC
SELECT @OrdenTrabajoDetalleId=isnull(MAX(id),0)+1 FROM DETALLE_ORDEN_TRABAJO

Declare @error1 int
Declare @error2 int


insert into ORDEN_TRABAJO values (@OrdenTrabajoId,@ClienteID,@fechainicio,@fechafinal,'A')
Select @error1 = @@ERROR

insert into DETALLE_ORDEN_TRABAJO values (@OrdenTrabajoDetalleId,@OrdenTrabajoId,@tecnicoId,@servicioId)
Select @error2 = @@ERROR

if @error1 = 0 and @error2 = 0
commit
else
Rollback

GO
/****** Object:  StoredProcedure [dbo].[spAddOrdenDeTrabajoD]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spAddOrdenDeTrabajoD] @ClienteID numeric, @fechainicio datetime, @fechafinal datetime, @tecnicoId numeric, @servicioId numeric
as

Begin tran

DECLARE @OrdenTrabajoId NUMERIC
SELECT @OrdenTrabajoId=isnull(MAX(id),0)+1 FROM ORDEN_TRABAJO

DECLARE @OrdenTrabajoDetalleId NUMERIC
SELECT @OrdenTrabajoDetalleId=isnull(MAX(id),0)+1 FROM DETALLE_ORDEN_TRABAJO

Declare @error1 int
Declare @error2 int


insert into ORDEN_TRABAJO values (@OrdenTrabajoId,@ClienteID,@fechainicio,@fechafinal,'A')
Select @error1 = @@ERROR

insert into DETALLE_ORDEN_TRABAJO values (@OrdenTrabajoDetalleId,@OrdenTrabajoId,@tecnicoId,@servicioId)
Select @error2 = @@ERROR

if @error1 = 0 and @error2 = 0
commit
else
Rollback

GO
/****** Object:  StoredProcedure [dbo].[spAddOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spAddOrdenTrabajo] @clienteID numeric, @fechainicio datetime, @fechafinal datetime
as
DECLARE @id NUMERIC
DECLARE @tec NUMERIC

SELECT @id=isnull(MAX(id),0)+1 FROM ORDEN_TRABAJO
select @tec = tecnicoID from CONTRATOS where clienteID=@clienteID 
insert into ORDEN_TRABAJO values (@id,@clienteID,@fechainicio,@fechafinal,'A')

GO
/****** Object:  StoredProcedure [dbo].[spAddServicioNuevoAPaquete]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAddServicioNuevoAPaquete] @nombre varchar(100), @precio float,@PaqueteID numeric
as
BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @servicioID numeric
		

		EXEC spAddServicios @nombre,@precio,'I'
		SELECT @servicioID=(MAX(id)) FROM SERVICIOS
		EXEC spAddDetallePaquete @servicioID,@paqueteID

			IF @@TRANCOUNT > 0
				COMMIT
		END TRY
		BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK;
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
			THROW
        END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spAddServicios]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAddServicios] @nombre varchar(50), @precio float, @tipo varchar(1)
as

DECLARE @id NUMERIC
SELECT @id=isnull(MAX(id),0)+1 FROM Servicios
		IF @tipo='I'
			insert into SERVICIOS values (@id,@nombre,@precio,@tipo)
		ELSE
			THROW 51000, 'El servicio no es individual', 1


GO
/****** Object:  StoredProcedure [dbo].[spAddTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddTecnico] @nombre varchar(50), @telefono varchar(10), @area varchar(15)
AS
DECLARE @tecnicoID numeric
SELECT @tecnicoID=isnull(MAX(id),0)+1 FROM TECNICOS
INSERT INTO TECNICOS(id,nombre, telefono, area) VALUES 
(@tecnicoID,@nombre, @telefono, @area)
GO
/****** Object:  StoredProcedure [dbo].[spClientesPorServicio]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spClientesPorServicio] @Servicio numeric
as
	select * into #Servicios from Servicios where id = @Servicio

	select s.id [ServicioID], s.nombre [Nombre del Servicio], cn.id [ContratoID],
	c.id [ClienteID], c.nombre [Nombre del Cliente], c.direccion [Dirección]
	from
	Cliente as C
	inner join Contratos as cn on c.id = cn.clienteID
	inner join DETALLE_CONTRATO as dt on cn.id = dt.contratoID
	inner join SERVICIOS as s on dt.servicioID = s.id
	where s.id= @Servicio
GO
/****** Object:  StoredProcedure [dbo].[spDeleteCliente]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spDeleteCliente]
@Id int
as
	--Antes de la Eliminación
	--select * from CLIENTE
	--Eliminando
	delete from CLIENTE where id = @Id
	--Después de la Eliminación
	--select * from CLIENTE
GO
/****** Object:  StoredProcedure [dbo].[spDeleteContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteContrato] @id numeric
AS
DELETE FROM CONTRATOS WHERE id= @id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDetalleContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDetalleContrato] @id numeric
AS	
	DELETE FROM DETALLE_CONTRATO WHERE contratoID=@id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDetalleFactura]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDetalleFactura] @id numeric
AS
	DELETE FROM DETALLE_FACTURA_SERVICIO WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDetalleOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDetalleOrdenTrabajo] @id numeric
AS
	DELETE FROM DETALLE_ORDEN_TRABAJO WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDetallePaquete]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDetallePaquete] @id numeric
AS
	DELETE FROM DETALLE_PAQUETE WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDisponibilidadTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDisponibilidadTecnico] @registroID numeric
AS
	DELETE FROM DISPONIBILIDAD_TECNICOS WHERE id= @registroID
GO
/****** Object:  StoredProcedure [dbo].[spDeleteFacturaServicio]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteFacturaServicio] @id numeric
AS
DELETE FROM FACTURA_SERVICIO WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spDeleteOrdenTrabajo] @id numeric
as
Delete ORDEN_TRABAJO where id = @id

GO
/****** Object:  StoredProcedure [dbo].[spDeleteServicios]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spDeleteServicios] @id numeric
as
Delete SERVICIOS where id = @id
GO
/****** Object:  StoredProcedure [dbo].[spDeleteTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spDeleteTecnico] @id numeric
as
Delete TECNICOS where id = @id

GO
/****** Object:  StoredProcedure [dbo].[spFacturaMensual]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFacturaMensual] @clienteID NUMERIC, @mes NUMERIC
AS
	DECLARE @paquetesFacturados int, @today datetime


	--Contratos del cliente
	SELECT * INTO #tContratos FROM CONTRATOS WHERE clienteID=@clienteID

	--Servicios contratados por el cliente
	SELECT dC.servicioID, s.tipo, s.precio, s.nombre INTO #tServiciosContratados FROM DETALLE_CONTRATO AS dC 
	JOIN #tContratos AS c on c.id=dC.contratoID
	JOIN (SELECT * FROM SERVICIOS  WHERE tipo='P') AS s ON s.id=dC.servicioID 

		--Verificar si el paquete se facturó en el mes
	SELECT fecha INTO #tFacturaServicio FROM #tServiciosContratados AS fS
	JOIN (SELECT fecha, servicioID FROM FACTURA_SERVICIO WHERE DATEPART(m, fecha)=@mes AND clienteID=@clienteID ) AS sC 
	ON sC.servicioID=fS.servicioID
	

	--Verificar si se facturaron los paquetes en el mes
	SELECT @paquetesFacturados=ISNULL(COUNT(*),0) FROM #tFacturaServicio AS fS 

	
	IF @paquetesFacturados=0
		BEGIN
			SELECT @today=GETDATE()
			DECLARE @servicioID int, @valorServicio float
			WHILE exists(SELECT * FROM #tServiciosContratados)
				BEGIN
					 select top 1 @servicioID= servicioID FROM #tServiciosContratados order by servicioID asc
					 SELECT @valorServicio=precio FROM #tServiciosContratados
					EXEC spAddFacturaServicio @servicioID,@valorServicio,@today, @clienteID
					DELETE FROM #tServiciosContratados WHERE servicioID=@servicioID
				END
		END
GO
/****** Object:  StoredProcedure [dbo].[spFacturaPorCliente]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spFacturaPorCliente] @Cliente int
as
	select * into #Clinte from Cliente where id = @Cliente

	select Fs.id [FacturaID], C.id [ClienteID], C.nombre [Nombre], C.direccion [Dirección], Fs.fecha [Fecha],  
	Fs.servicioID [ServicioID], S.precio [Valor], cast((Fs.valor*0.15) as numeric (11,2)) [ISV], 
	cast((Fs.valor * 0.15) + valor as numeric(11, 2)) [Total] 
	from Cliente as C
	inner join FACTURA_SERVICIO as Fs on Fs.clienteID = c.id
	inner join DETALLE_CONTRATO as Dt on Dt.servicioID = fs.servicioID
	inner join SERVICIOS as S on S.id = Dt.servicioID
	where C.id= @Cliente
GO
/****** Object:  StoredProcedure [dbo].[spFinalizarOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFinalizarOrdenTrabajo] @idOrdenTrabajo numeric
AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @fecha datetime = GETDATE(), @numServicios int
			SELECT * INTO #tOrdenTrabajo FROM ORDEN_TRABAJO WHERE id= @idOrdenTrabajo AND estado='A'
			SELECT @numServicios=ISNULL((COUNT(*)),0) FROM #tOrdenTrabajo
			IF @numServicios=0
				THROW 53000, 'La orden de trabajo no está activa', 1
			ELSE
			BEGIN
				SELECT oT.id[oTID], dOT.id[dOTID], dOT.servicioID, s.precio, oT.clienteID INTO #tServicioOrdenTrabajo FROM #tOrdenTrabajo AS oT
				JOIN (SELECT * FROM DETALLE_ORDEN_TRABAJO WHERE ordenTrabajoID=@idOrdenTrabajo) AS dOT ON dOT.ordenTrabajoID=oT.id
				JOIN SERVICIOS as s ON s.id= dOT.servicioID
				WHERE s.tipo='I'

				exec spUpdateOrdenTrabajo @idOrdenTrabajo,@estado='F', @fechaFinal=@fecha
			
				DECLARE @servicioID numeric, @valor float, @clienteID numeric, @facturaID numeric
				WHILE exists(SELECT * FROM #tServicioOrdenTrabajo)
					BEGIN
						select top 1 @servicioID= servicioID, @valor=precio, @clienteID=clienteID FROM #tServicioOrdenTrabajo order by servicioID asc
						Exec spAddFacturaServicio @servicioID,@valor,@fecha,@clienteID
						SELECT @facturaID=MAX(id) FROM FACTURA_SERVICIO					
						Exec spAddDetalleFactura @facturaID, @idOrdenTrabajo
						DELETE FROM #tServicioOrdenTrabajo WHERE servicioID=@servicioID
					END
				END
			
			IF @@TRANCOUNT > 0
				COMMIT
		END TRY
		BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK
			EXEC spUpdateOrdenTrabajo @idOrdenTrabajo, @estado='F'
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
			THROW
        END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spReadContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReadContrato] @contratoID numeric
AS
	--Variables
	DECLARE @tecnicoID numeric,  @clienteID numeric, @numServicios int, @isPaquete VARCHAR, @paqueteID numeric
	--DECLARE @numServicios int , @tecnicoID numeric , @clienteID numeric, @nombrePaquete VARCHAR(100), @isPaquete VARCHAR, @result1 VARCHAR(max)
	--DECLARE @nombreTecnico VARCHAR(100), @paqueteID numeric, @encabezado VARCHAR(MAX)
	--DECLARE @nombreCliente VARCHAR(100)
	--Cantidad de servicios, si es mayor que 1 entonces hay paquete personalizado
	SELECT @numServicios=(COUNT(*)) FROM DETALLE_CONTRATO WHERE contratoID=@contratoID
	--Extracción de tablas temporales con registros necesarios
	SELECT * INTO #tContratos FROM CONTRATOS WHERE id= @contratoID
	SELECT @tecnicoID=tecnicoID FROM #tContratos								--Extracción de valor  para variable
	SELECT * INTO #tTecnicos FROM TECNICOS WHERE id=@tecnicoID
	SELECT @clienteID=clienteID FROM #tContratos
	SELECT * INTO #tClientes FROM CLIENTE WHERE id=@clienteID
	SELECT * INTO #tDetalleContratos FROM DETALLE_CONTRATO WHERE contratoID=@contratoID
	
	--Producto Cartesiano
	SELECT c.id [ID], cte.nombre [Cliente],t.nombre [Tecnico] FROM #tDetalleContratos AS dC 
	JOIN #tContratos AS c ON dC.contratoID=c.id
	JOIN #tClientes AS cte ON cte.id= c.clienteID
	JOIN #tTecnicos AS t ON t.id=c.tecnicoID
	
	SELECT s.nombre[Paquetes Contratados] FROM SERVICIOS as s
	JOIN #tDetalleContratos as dC ON  s.id=dC.servicioID 
	WHERE s.tipo='P'

	SELECT s.nombre[Servicios Extras] FROM SERVICIOS as s
	JOIN #tDetalleContratos as dC ON  s.id=dC.servicioID 
	WHERE s.tipo='I'

	--SELECT @nombreTecnico=nombre FROM TECNICOS WHERE id=(SELECT tecnicoID FROM #tContratos)
	--SELECT @nombreCliente=nombre From CLIENTE
	--Verificación de servicios contratados
	--SET @encabezado= CONCAT('No.Contrato: ',cast( @contratoID AS varchar(10))+ CHAR(13))
	--SET @encabezado= CONCAT('Cliente: ', @nombreCliente+CHAR(13))
	--SET @encabezado= CONCAT('Tecnico: ', @nombreTecnico+CHAR(13))
	
	--Mostrar paquetes y servicios

	--IF @numServicios=1
	--	BEGIN
	--		--SELECT @paqueteID=id FROM SERVICIOS WHERE id=(SELECT servicioID FROM #tDetalleContratos)
	--		--SELECT @isPaquete=(tipo), @nombrePaquete=nombre FROM SERVICIOS WHERE id=@paqueteID
	--		IF @isPaquete='P'
	--			BEGIN
	--				--SET @result1= ('Paquete: ' + (SELECT nombre FROM SERVICIOS WHERE id=(SELECT servicioID FROM #tDetalleContratos)) + CHAR(13)+
	--				--				'Servicios del Paquete:')
	--				--SELECT @result1
	--				SELECT * INTO #tDetallePaquete FROM DETALLE_PAQUETE WHERE paqueteID=@paqueteID
	--				--Servicios del paquete 
	--				--JOIN servicios y detalle paquete
	--				SELECT * FROM #tDetallePaquete as dP
	--				JOIN SERVICIOS AS s ON dP.servicioID=s.id
	--			END
	--		ELSE
	--			BEGIN
	--				SELECT @encabezado
	--				SELECT ('Solo hay un servicio contratado')
	--			END
	--	END
	--ELSE
	--	BEGIN
	--		SELECT @nombrePaquete='Paquete Personalizado'
	--		SELECT @nombrePaquete
	--	END
GO
/****** Object:  StoredProcedure [dbo].[spServiciosRealizados]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spServiciosRealizados] @clienteID numeric
AS
--Tablas Temporales
	SELECT * INTO #tOrdenTrabajo FROM ORDEN_TRABAJO WHERE clienteID=@clienteID
--Producto Cartesiano
	SELECT dOT.id [dOTID], tOT.id [oTID], dOT.servicioID INTO #tJoinOrdenTrabajo FROM  DETALLE_ORDEN_TRABAJO AS dOT 
	JOIN #tOrdenTrabajo as tOT ON tOT.id=dOT.ordenTrabajoID

	SELECT s.nombre[Nombre], COUNT(*)[Cantidad] FROM #tJoinOrdenTrabajo as jOD
	JOIN SERVICIOS AS s ON s.id=jOD.servicioID
	GROUP BY s.nombre
GO
/****** Object:  StoredProcedure [dbo].[spUpdateCliente]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spUpdateCliente] 
@Id int, @Nombre varchar(20) =null, @Estado varchar(1)=null, 
@RTN varchar(20)=null, @Telefono varchar(10)=null, @Direccion varchar(50)=null
as
	--Antes de la Actualización
	--select * from CLIENTE
	--where id = @Id
	--Actualización
	update CLIENTE set 
	nombre = isnull(@Nombre,nombre),
	estado = isnull(@Estado, estado),
	RTN = isnull(@RTN, rtn),
	telefono = isnull(@Telefono, telefono),
	direccion = isnull(@Direccion, direccion)
	where Id = @Id
	----Después de la Actualización
	--select * from CLIENTE
	--where id = @Id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateContrato] @contratoID numeric, @clienteID numeric=NULL, @tecnicoID numeric=NULL, @fechaFinalizacion date=NULL,  @fechaContrato date=NULL
AS
	BEGIN
		SELECT @fechaContrato=cast( GETDATE() AS DATE)
		--Fecha de hoy
		 BEGIN TRY
            BEGIN TRANSACTION
				IF @clienteID IS NOT NULL
					UPDATE CONTRATOS SET clienteID=@clienteID WHERE id=@contratoID
				IF @tecnicoID IS NOT NULL 
					UPDATE CONTRATOS SET tecnicoID=@tecnicoID WHERE id=@contratoID
				IF @fechaContrato IS NOT NULL
					UPDATE CONTRATOS SET fechaContrato=@fechaContrato WHERE id=@contratoID
				IF @fechaFinalizacion IS NOT NULL
					UPDATE CONTRATOS SET fechaFinalizacion=@fechaFinalizacion WHERE id=@contratoID
				
				
				IF @@TRANCOUNT > 0
                COMMIT
		END TRY
	BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK;
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
        END CATCH;
    END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDetalleContrato]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateDetalleContrato] @id numeric, @contratoID numeric=null, @servicioID numeric=null
AS
	UPDATE DETALLE_CONTRATO SET
	contratoID=ISNULL(@contratoID, contratoID),
	servicioID=ISNULL(@servicioID, servicioID)
	WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDetalleFactura]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateDetalleFactura] @id numeric, @facturaID numeric=NULL, @ordenID numeric = NULL
AS
	UPDATE DETALLE_FACTURA_SERVICIO	SET
	facturaID=ISNULL(@facturaID, facturaID),
	ordenID=ISNULL(@ordenID, ordenID)
	WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDetalleOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateDetalleOrdenTrabajo] 
@id numeric = NULL, @ordentrabajoID numeric =NULL , @tecnicoID numeric =NULL, @servicioID numeric =NULL 
AS
	UPDATE DETALLE_ORDEN_TRABAJO SET
	ordenTrabajoID= ISNULL(@ordenTrabajoID, ordenTrabajoID),
	tecnicoId= ISNULL(@tecnicoID,tecnicoId),
	servicioID= ISNULL(@servicioID, servicioID)
	WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDetallePaquete]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATE
CREATE PROCEDURE [dbo].[spUpdateDetallePaquete]
@id numeric, @ServicioID numeric=NULL, @PaqueteID numeric= NULL, @sc numeric =NULL, @pc numeric= NULL
AS
	BEGIN TRY
		BEGIN TRANSACTION
			IF @PaqueteID IS NOT NULL
				BEGIN
					DECLARE @isPaquete VARCHAR
					SELECT @isPaquete=(tipo) FROM SERVICIOS WHERE id=@PaqueteID
					IF @isPaquete='P'
						UPDATE DETALLE_PAQUETE SET paqueteID=@PaqueteID WHERE id=@id
					ELSE
						THROW 52000, 'paqueteID no corresponde a un servicio tipo paquete(P)', 1
				END
			IF @ServicioID IS NOT NULL
				BEGIN
					DECLARE @isServicio VARCHAR
					SELECT @isServicio=tipo FROM SERVICIOS WHERE id=@ServicioId
					IF @isServicio='I'
						UPDATE DETALLE_PAQUETE SET servicioID=@ServicioID WHERE id=@id
					ELSE
						THROW 51000, 'El servicio no es individual', 1
				END
			IF @@TRANCOUNT > 0
				COMMIT
		END TRY
		BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK;
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
			THROW
        END CATCH
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDisponibilidadTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateDisponibilidadTecnico] @tecnicoID numeric , @estado varchar =NULL, @desde datetime = NULL, @hasta datetime = NULL
AS
UPDATE DISPONIBILIDAD_TECNICOS SET 
estado=ISNULL(@estado, estado),
desde=ISNULL(@desde, desde),
hasta=ISNULL(@hasta, hasta)
WHERE tecnicoID=@tecnicoID
GO
/****** Object:  StoredProcedure [dbo].[spUpdateFacturaServicio]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateFacturaServicio] @id numeric ,@clienteID numeric =NULL, @servicioID NUMERIC = NULL, @valor FLOAT =NULL, @fecha DATETIME = NULL 
AS
UPDATE FACTURA_SERVICIO SET
clienteID= ISNULL(@clienteID,clienteID),
servicioID= ISNULL(@servicioID, servicioID), 
valor= ISNULL(@valor, valor), 
fecha = ISNULL(@fecha, fecha)

WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrdenTrabajo]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spUpdateOrdenTrabajo] @id numeric , @clienteID numeric = null, @fechainicio datetime = null, @fechafinal datetime = null, @estado varchar = null
as 
Update ORDEN_TRABAJO
SET
clienteID = ISNULL(@clienteID,clienteID),
fechaInicio= ISNULL(@fechainicio,fechaInicio),
estado= ISNULL(@estado,estado),
fechaFinal = ISNULL(@fechafinal,fechaFinal)
where id = @id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateServicios]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spUpdateServicios] @id numeric,@nombre varchar(50) = null,  @precio float = null, @tipo varchar(1)=null
as 

Update SERVICIOS
SET
nombre = ISNULL(@nombre,nombre),
precio= ISNULL(@precio,precio),
tipo= ISNULL(@tipo,tipo)
where id = @id
GO
/****** Object:  StoredProcedure [dbo].[spUpdateTecnico]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spUpdateTecnico] @id numeric,@nombre varchar(50) = null, @telefono varchar(10)=null, @area varchar(15)=null
as 

Update TECNICOS
SET

nombre = ISNULL(@nombre,nombre),
telefono= ISNULL(@telefono,telefono),
area= ISNULL(@area,area)
where id = @id
GO
/****** Object:  StoredProcedure [dbo].[spVerificarEstadoOrden]    Script Date: 8/11/2021 21:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVerificarEstadoOrden] @id numeric
AS
	BEGIN TRY
		BEGIN TRANSACTION
			--Transaccion
			exec spUpdateOrdenTrabajo null,null,null,null,'F'
			Declare @Servicio numeric,@valor float,@fecha date
			Select @Servicio = ServicioID from DETALLE_ORDEN_TRABAJO where id = @id
			Select @valor =  Precio from SERVICIOS where id=@Servicio 
			select @fecha = GETDATE()
			Exec spAddFacturaServicio @servicio,@valor,@fecha,@id
			IF @@TRANCOUNT > 0
				COMMIT
		END TRY
		BEGIN CATCH
            IF @@TRANCOUNT > 0
			 ROLLBACK;
            SELECT ERROR_NUMBER() AS ErrorNumber;
            SELECT ERROR_MESSAGE() AS ErrorMessage;
			THROW
        END CATCH
GO
