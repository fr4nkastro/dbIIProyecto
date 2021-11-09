USE ProyectoDBII_Last

--Tablas
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM DETALLE_ORDEN_TRABAJO
SELECT * FROM CLIENTE
SELECT * FROM SERVICIOS

ALTER PROCEDURE spServiciosRealizados @clienteID numeric
AS
--Tablas Temporales
	SELECT * INTO #tOrdenTrabajo FROM ORDEN_TRABAJO WHERE clienteID=@clienteID
--Producto Cartesiano
	SELECT dOT.id [dOTID], tOT.id [oTID], dOT.servicioID INTO #tJoinOrdenTrabajo FROM  DETALLE_ORDEN_TRABAJO AS dOT 
	JOIN #tOrdenTrabajo as tOT ON tOT.id=dOT.ordenTrabajoID

	SELECT s.nombre[Nombre], COUNT(*)[Cantidad] FROM #tJoinOrdenTrabajo as jOD
	JOIN SERVICIOS AS s ON s.id=jOD.servicioID
	GROUP BY s.nombre

EXEC spServiciosRealizados 1