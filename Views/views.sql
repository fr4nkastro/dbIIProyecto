USE [ProyectoDBII_Last]
GO
/****** Object:  View [dbo].[viewContratacionxPaquete]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewContratacionxPaquete]
as
SELECT s.id [ID], nombre [Nombre], COUNT(s.nombre) [Cantidad] FROM CONTRATOS as c
JOIN DETALLE_CONTRATO as dC ON dC.contratoID=c.id
JOIN SERVICIOS AS s ON dC.servicioID=s.id
GROUP BY s.nombre, s.id
GO
/****** Object:  View [dbo].[viewContratoMasContratado]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewContratoMasContratado]
as
select TOP 1 * from viewContratacionxPaquete
GO
/****** Object:  View [dbo].[viewGananciasxPaquetes]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewGananciasxPaquetes]
as
--Extraer el total de 
SELECT s.id[ID], s.nombre [Nombre], SUM(s.precio) [Precio] FROM SERVICIOS s
JOIN viewContratacionxPaquete AS cP ON cP.ID=s.id
GROUP BY s.nombre, s.id
GO
/****** Object:  View [dbo].[viewClientesActivos]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewClientesActivos]
as
select * from CLIENTE as c
where c.estado='A'
GO
/****** Object:  View [dbo].[viewClientesInactivos]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewClientesInactivos]
as
select * from CLIENTE as c
where c.estado='I'
GO
/****** Object:  View [dbo].[viewClientesxTecnico]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewClientesxTecnico]
as
select t.id [ID],t.nombre [Nombre],COUNT(t.id) [Cliente] from TECNICOS as t
join
contratos as c on c.tecnicoID=t.id
group by t.id ,t.nombre
GO
/****** Object:  View [dbo].[viewServiciosFueraDePaquetes]    Script Date: 9/11/2021 11:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[viewServiciosFueraDePaquetes]
as

Select id, nombre from SERVICIOS as s where s.tipo = 'I' and

s.id NOT IN (

select DISTINCT servicioID from DETALLE_PAQUETE 

)
GO
