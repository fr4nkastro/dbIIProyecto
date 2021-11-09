GO
-------------------------------------------------------------
ALTER PROCEDURE spFinalizarOrdenTrabajo @idOrdenTrabajo numeric
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
			
				DECLARE @servicioID numeric, @valor float, @clienteID numeric
				WHILE exists(SELECT * FROM #tServicioOrdenTrabajo)
					BEGIN
						select top 1 @servicioID= servicioID, @valor=precio, @clienteID=clienteID FROM #tServicioOrdenTrabajo order by servicioID asc
						Exec spAddFacturaServicio @servicioID,@valor,@fecha,@clienteID
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
DELETE FROM FACTURA_SERVICIO
DELETE FROM DETALLE_FACTURA_SERVICIO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM DETALLE_ORDEN_TRABAJO
SELECT * FROM FACTURA_SERVICIO
SELECT * FROM DETALLE_FACTURA_SERVICIO
EXEC spUpdateOrdenTrabajo 1, @estado='A'
EXEC spAddDetalleOrdenTrabajo 2, 1, 3
EXEC spFinalizarOrdenTrabajo 1


--Ademas de verificar el numero de mes verificar el año