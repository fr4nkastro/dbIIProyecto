USE [ProyectoDBII_Last]
GO
/****** Object:  StoredProcedure [dbo].[spAddDetalleContrato]    Script Date: 7/11/2021 14:52:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
--ADD
GO
ALTER PROCEDURE [dbo].[spAddDetalleContrato] @contratoID numeric, @servicioID numeric
AS
	DECLARE @id numeric
	SELECT @id=ISNULL(MAX(id),0)+1 FROM DETALLE_CONTRATO
	INSERT INTO DETALLE_CONTRATO(id, contratoID, servicioID) VALUES
	(@id, @contratoID, @servicioID)
GO
--:
select * from CONTRATOS
select * From DETALLE_CONTRATO
EXEC spAddDetalleContrato 1, 7
--:

--UPDATE
GO
ALTER PROCEDURE spUpdateDetalleContrato @id numeric, @contratoID numeric=null, @servicioID numeric=null
AS
	UPDATE DETALLE_CONTRATO SET
	contratoID=ISNULL(@contratoID, contratoID),
	servicioID=ISNULL(@servicioID, servicioID)
	WHERE id=@id
GO
--:
EXEC spUpdateDetalleContrato 1, @servicioID=8
SELECT * fROM DETALLE_CONTRATO
--:
	
	
--CREATE COLUMN ID
ALTER TABLE DETALLE_CONTRATO ADD id numeric not null
ALTER TABLE DETALLE_CONTRATO ADD CONSTRAINT UK_idDetalleContrato UNIQUE (id)
select * from DETALLE_CONTRATO

--DELETE
GO
CREATE PROCEDURE spDeleteDetalleContrato @id numeric
AS	
	DELETE FROM DETALLE_CONTRATO WHERE id=@id
GO
--:
SELECT * FROM DETALLE_CONTRATO
EXEC spDeleteDetalleContrato 1