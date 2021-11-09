--CREATE
SELECT * FROM DETALLE_FACTURA_SERVICIO
GO
CREATE PROCEDURE spAddDetalleFactura @facturaID numeric, @ordenID numeric
AS
	DECLARE @id numeric
	SELECT @id=ISNULL(MAX(id),0)+1 FROM DETALLE_FACTURA_SERVICIO

	INSERT INTO DETALLE_FACTURA_SERVICIO(id, facturaID, ordenID) VALUES
	(@id, @facturaID, @ordenID)
GO
--:
EXEC spAddDetalleFactura 1,1
SELECT * FROM DETALLE_FACTURA_SERVICIO
--:

--UPDATE
CREATE PROCEDURE spUpdateDetalleFactura @id numeric, @facturaID numeric=NULL, @ordenID numeric = NULL
AS
	UPDATE DETALLE_FACTURA_SERVICIO	SET
	facturaID=ISNULL(@facturaID, facturaID),
	ordenID=ISNULL(@ordenID, ordenID)
	WHERE id=@id
GO
--:
EXEC spUpdateDetalleFactura 1, @ordenID=2
SELECT * FROM DETALLE_FACTURA_SERVICIO
--:

--DELETE
CREATE PROCEDURE spDeleteDetalleFactura @id numeric
AS
	DELETE FROM DETALLE_FACTURA_SERVICIO WHERE id=@id
GO
EXEC spDeleteDetalleFactura 1
Select * from DETALLE_FACTURA_SERVICIO