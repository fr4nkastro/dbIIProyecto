ALTER PROCEDURE spFacturaMensual @clienteID NUMERIC, @mes NUMERIC
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

select * from FACTURA_SERVICIO
SELECT * FROM CONTRATOS
SELECT * FROM DETALLE_CONTRATO
EXEC spFacturaMensual 1, 11

