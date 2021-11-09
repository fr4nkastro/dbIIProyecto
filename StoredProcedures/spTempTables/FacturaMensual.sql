USE ProyectoDBII_Last

--TABLAS
SELECT * FROM FACTURA_SERVICIO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM DETALLE_ORDEN_TRABAJO
SELECT * FROM SERVICIOS
SELECT * FROM DETALLE_CONTRATO
CREATE PROCEDURE spFacturaMensual @clienteID NUMERIC, @mes NUMERIC
AS
	DECLARE @paquetesFacturados int, @today datetime, @paquetesContratados int
	SET @paquetesFacturados=0
--Tablas Temporales
	SELECT * INTO #tOrdenTrabajo FROM ORDEN_TRABAJO WHERE clienteID=@clienteID
	SELECT dOt.id[dOTID], oT.id[oTID] INTO #tJoinOrdenTrabajoDetalle FROM DETALLE_ORDEN_TRABAJO AS dOt
	JOIN #tOrdenTrabajo AS oT ON oT.id=dOt.ordenTrabajoID
	SELECT * INTO #tFacturaServicio FROM FACTURA_SERVICIO WHERE DATEPART(m, fecha)=@mes 
	SELECT * INTO #tContratos FROM CONTRATOS WHERE clienteID=@clienteID
	SELECT fS.id [fSID], dFS.id[dFSID], dFS.ordenID, fS.servicioID, fs.fecha, fS.valor INTO #tJoinFacturaDetalle FROM DETALLE_FACTURA_SERVICIO AS dFS
	JOIN #tFacturaServicio AS fS ON fS.id=dFS.facturaID
	SELECT dC.servicioID, s.tipo, s.precio, s.nombre INTO #tServiciosContratados FROM DETALLE_CONTRATO AS dC 
	JOIN CONTRATOS AS c on c.id=dC.contratoID
	JOIN SERVICIOS AS s ON s.id=dC.servicioID

--Crear factura de los paquetes mensuales
	--Verificar si se efectúo
	SELECT @paquetesFacturados=COUNT(*) FROM #tFacturaServicio AS fS 
	JOIN SERVICIOS AS s ON s.id=fS.servicioID
	JOIN DETALLE_CONTRATO AS dC ON dC.servicioID=s.id
	WHERE s.tipo='P'
	SELECT @today=GETDATE()
	SELECT @paquetesContratados=COUNT(*) FROM #tServiciosContratados WHERE tipo='P'

	IF @paquetesFacturados=0
		BEGIN
			DECLARE @servicioID int, @valorServicio float

			WHILE exists(SELECT * FROM #tServiciosContratados)
				BEGIN
					 select top 1 @servicioID= servicioID FROM #tServiciosContratados order by servicioID asc
					 SELECT @valorServicio=precio FROM #tServiciosContratados
					EXEC spAddFacturaServicio @servicioId,	@today,@valorServicio , @clienteID
				END

		END
--Producto Cartesiano
	SELECT s.nombre [Servicio], jFS.fecha[Fecha], jFS.valor[Monto]  FROM #tJoinFacturaDetalle AS jFS 
	JOIN #tServiciosContratados AS s ON s.servicioID=jFS.servicioID
GO
----------------------------------------------------------------------------------------
--TABLAS
SELECT * FROM FACTURA_SERVICIO
SELECT * FROM DETALLE_FACTURA_SERVICIO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM DETALLE_ORDEN_TRABAJO
SELECT * FROM SERVICIOS
SELECT * FROM DETALLE_CONTRATO	
	--SELECT * INTO #tFacturaServicio FROM FACTURA_SERVICIO WHERE @clienteID= @clienteID AND DATEPART(m, fecha)=@mes


--Anexión de CLIENTE ID
--Creación de tabla detalleFactura con ordenID y FacturaID
ALTER TABLE FACTURA_SERVICIO DROP COLUMN ordenID
ALTER TABLE FACTURA_SERVICIO DROP CONSTRAINT FK__FACTURA_S__orden__3CBF0154
ALTER TABLE FACTURA_SERVICIO ADD  clienteID NUMERIC
ALTER TABLE FACTURA_SERVICIO ADD CONSTRAINT FK_ClienteID FOREIGN KEY (clienteID) REFERENCES CLIENTE(id)
ALTER TABLE FACTURA_SERVICIO ALTER COLUMN clienteID NUMERIC(28,0) NOT NULL

SELECT * FROM FACTURA_SERVICIO

CREATE TABLE DETALLE_FACTURA_SERVICIO(
	id NUMERIC NOT NULL PRIMARY KEY,
	facturaID  NUMERIC FOREIGN KEY REFERENCES FACTURA_SERVICIO(id),
	ordenID NUMERIC FOREIGN KEY REFERENCES ORDEN_TRABAJO(id)
)

SELECT * FROM FACTURA_SERVICIO
SELECT * FROM DETALLE_FACTURA_SERVICIO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM DETALLE_ORDEN_TRABAJO

--Creación de un sp que cambie el estado de una orden y mande a facturar