/****** Object:  StoredProcedure [dbo].[spClientesPorServicio]    Script Date: 8/11/2021 10:02:29 ******/
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
