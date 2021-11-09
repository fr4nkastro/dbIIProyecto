USE ProyectoDBII_Last

SELECT * FROM FACTURA_SERVICIO

--ADD
GO
ALTER PROCEDURE spAddFacturaServicio  @servicioID numeric, @valor float, @fecha datetime, @clienteID numeric
AS
DECLARE @id numeric
SELECT @id=ISNULL(MAX(id),0)+1 FROM FACTURA_SERVICIO
INSERT INTO FACTURA_SERVICIO(id, servicioID, valor, fecha, clienteID) VALUES
(@id, @servicioID, @valor, @fecha, @clienteID)
GO
--:
SELECT * FROM SERVICIOS
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM FACTURA_SERVICIO
EXEC spAddFacturaServicio 1, 5000, '07-11-2021 11:30', 1
--:

--UPDATE
GO
ALTER PROCEDURE spUpdateFacturaServicio @id numeric ,@clienteID numeric =NULL, @servicioID NUMERIC = NULL, @valor FLOAT =NULL, @fecha DATETIME = NULL 
AS
UPDATE FACTURA_SERVICIO SET
clienteID= ISNULL(@clienteID,clienteID),
servicioID= ISNULL(@servicioID, servicioID), 
valor= ISNULL(@valor, valor), 
fecha = ISNULL(@fecha, fecha)

WHERE id=@id
GO
--:
SELECT * FROM FACTURA_SERVICIO
EXEC spUpdateFacturaServicio 2, @clienteID=1
--:

--DELETE
GO
CREATE PROCEDURE spDeleteFacturaServicio @id numeric
AS
DELETE FROM FACTURA_SERVICIO WHERE id=@id
GO
--:
EXEC spDeleteFacturaServicio 2
SELECT * FROM FACTURA_SERVICIO