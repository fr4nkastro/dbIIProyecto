USE [ProyectoDBII_Last]
GO
/****** Object:  Table [dbo].[CLIENTE]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLIENTE](
	[id] [numeric](28, 0) NOT NULL,
	[nombre] [varchar](75) NOT NULL,
	[estado] [varchar](1) NULL,
	[RTN] [varchar](20) NULL,
	[telefono] [varchar](10) NULL,
	[direccion] [varchar](100) NULL,
 CONSTRAINT [CLIENTE_PK] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONTRATOS]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONTRATOS](
	[id] [numeric](18, 0) NOT NULL,
	[clienteID] [numeric](28, 0) NULL,
	[fechaContrato] [date] NULL,
	[fechaFinalizacion] [date] NULL,
	[tecnicoID] [numeric](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_CONTRATO]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_CONTRATO](
	[contratoID] [numeric](18, 0) NULL,
	[servicioID] [numeric](18, 0) NULL,
	[id] [numeric](18, 0) NOT NULL,
 CONSTRAINT [UK_idDetalleContrato] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_FACTURA_SERVICIO]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_FACTURA_SERVICIO](
	[id] [numeric](18, 0) NOT NULL,
	[facturaID] [numeric](18, 0) NULL,
	[ordenID] [numeric](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_ORDEN_TRABAJO]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_ORDEN_TRABAJO](
	[id] [numeric](18, 0) NOT NULL,
	[ordenTrabajoID] [numeric](18, 0) NULL,
	[tecnicoId] [numeric](18, 0) NULL,
	[servicioID] [numeric](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_PAQUETE]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_PAQUETE](
	[servicioID] [numeric](18, 0) NOT NULL,
	[paqueteID] [numeric](18, 0) NOT NULL,
	[id] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_detallePaquete] PRIMARY KEY CLUSTERED 
(
	[servicioID] ASC,
	[paqueteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_IdDetallePaquete] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DISPONIBILIDAD_TECNICOS]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DISPONIBILIDAD_TECNICOS](
	[desde] [datetime] NULL,
	[hasta] [datetime] NULL,
	[estado] [varchar](1) NULL,
	[tecnicoID] [numeric](18, 0) NULL,
	[id] [numeric](18, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FACTURA_SERVICIO]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACTURA_SERVICIO](
	[id] [numeric](18, 0) NOT NULL,
	[fecha] [datetime] NULL,
	[servicioID] [numeric](18, 0) NOT NULL,
	[valor] [numeric](28, 2) NULL,
	[clienteID] [numeric](28, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ORDEN_TRABAJO]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDEN_TRABAJO](
	[id] [numeric](18, 0) NOT NULL,
	[clienteID] [numeric](28, 0) NULL,
	[fechaInicio] [datetime] NULL,
	[fechaFinal] [datetime] NULL,
	[estado] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SERVICIOS]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SERVICIOS](
	[id] [numeric](18, 0) NOT NULL,
	[nombre] [varchar](100) NULL,
	[precio] [float] NULL,
	[tipo] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TECNICOS]    Script Date: 9/11/2021 11:37:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TECNICOS](
	[id] [numeric](18, 0) NOT NULL,
	[nombre] [varchar](50) NULL,
	[telefono] [varchar](10) NULL,
	[area] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORDEN_TRABAJO] ADD  DEFAULT ('P') FOR [estado]
GO
ALTER TABLE [dbo].[CONTRATOS]  WITH CHECK ADD FOREIGN KEY([clienteID])
REFERENCES [dbo].[CLIENTE] ([id])
GO
ALTER TABLE [dbo].[CONTRATOS]  WITH CHECK ADD  CONSTRAINT [FK_Tecnico] FOREIGN KEY([tecnicoID])
REFERENCES [dbo].[TECNICOS] ([id])
GO
ALTER TABLE [dbo].[CONTRATOS] CHECK CONSTRAINT [FK_Tecnico]
GO
ALTER TABLE [dbo].[DETALLE_CONTRATO]  WITH CHECK ADD FOREIGN KEY([contratoID])
REFERENCES [dbo].[CONTRATOS] ([id])
GO
ALTER TABLE [dbo].[DETALLE_CONTRATO]  WITH CHECK ADD FOREIGN KEY([servicioID])
REFERENCES [dbo].[SERVICIOS] ([id])
GO
ALTER TABLE [dbo].[DETALLE_FACTURA_SERVICIO]  WITH CHECK ADD FOREIGN KEY([facturaID])
REFERENCES [dbo].[FACTURA_SERVICIO] ([id])
GO
ALTER TABLE [dbo].[DETALLE_FACTURA_SERVICIO]  WITH CHECK ADD FOREIGN KEY([ordenID])
REFERENCES [dbo].[ORDEN_TRABAJO] ([id])
GO
ALTER TABLE [dbo].[DETALLE_ORDEN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([ordenTrabajoID])
REFERENCES [dbo].[ORDEN_TRABAJO] ([id])
GO
ALTER TABLE [dbo].[DETALLE_ORDEN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([servicioID])
REFERENCES [dbo].[SERVICIOS] ([id])
GO
ALTER TABLE [dbo].[DETALLE_ORDEN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([tecnicoId])
REFERENCES [dbo].[TECNICOS] ([id])
GO
ALTER TABLE [dbo].[DETALLE_PAQUETE]  WITH CHECK ADD FOREIGN KEY([paqueteID])
REFERENCES [dbo].[SERVICIOS] ([id])
GO
ALTER TABLE [dbo].[DETALLE_PAQUETE]  WITH CHECK ADD FOREIGN KEY([servicioID])
REFERENCES [dbo].[SERVICIOS] ([id])
GO
ALTER TABLE [dbo].[DISPONIBILIDAD_TECNICOS]  WITH CHECK ADD FOREIGN KEY([tecnicoID])
REFERENCES [dbo].[TECNICOS] ([id])
GO
ALTER TABLE [dbo].[FACTURA_SERVICIO]  WITH CHECK ADD FOREIGN KEY([servicioID])
REFERENCES [dbo].[SERVICIOS] ([id])
GO
ALTER TABLE [dbo].[FACTURA_SERVICIO]  WITH CHECK ADD  CONSTRAINT [FK_ClienteID] FOREIGN KEY([clienteID])
REFERENCES [dbo].[CLIENTE] ([id])
GO
ALTER TABLE [dbo].[FACTURA_SERVICIO] CHECK CONSTRAINT [FK_ClienteID]
GO
ALTER TABLE [dbo].[ORDEN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([clienteID])
REFERENCES [dbo].[CLIENTE] ([id])
GO
ALTER TABLE [dbo].[CLIENTE]  WITH CHECK ADD  CONSTRAINT [chknombreCliente] CHECK  (([estado]='A' OR [estado]='I'))
GO
ALTER TABLE [dbo].[CLIENTE] CHECK CONSTRAINT [chknombreCliente]
GO
ALTER TABLE [dbo].[CLIENTE]  WITH CHECK ADD  CONSTRAINT [chkRTNCliente] CHECK  ((len([RTN])=(14) AND isnumeric(CONVERT([numeric],[RTN]))=(1)))
GO
ALTER TABLE [dbo].[CLIENTE] CHECK CONSTRAINT [chkRTNCliente]
GO
ALTER TABLE [dbo].[CLIENTE]  WITH CHECK ADD  CONSTRAINT [chkTelefonoCliente] CHECK  (([telefono] like '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' AND len([telefono])=(9)))
GO
ALTER TABLE [dbo].[CLIENTE] CHECK CONSTRAINT [chkTelefonoCliente]
GO
ALTER TABLE [dbo].[DISPONIBILIDAD_TECNICOS]  WITH CHECK ADD  CONSTRAINT [chkEstadoDisponibilidadTecnicos] CHECK  (([estado]='O' OR [estado]='D'))
GO
ALTER TABLE [dbo].[DISPONIBILIDAD_TECNICOS] CHECK CONSTRAINT [chkEstadoDisponibilidadTecnicos]
GO
ALTER TABLE [dbo].[FACTURA_SERVICIO]  WITH CHECK ADD  CONSTRAINT [chkValorFacturaServicio] CHECK  (([valor]>(0)))
GO
ALTER TABLE [dbo].[FACTURA_SERVICIO] CHECK CONSTRAINT [chkValorFacturaServicio]
GO
ALTER TABLE [dbo].[ORDEN_TRABAJO]  WITH CHECK ADD  CONSTRAINT [chkEstadoOrdenTrabajo] CHECK  (([estado]='A' OR [estado]='F' OR [estado]='C'))
GO
ALTER TABLE [dbo].[ORDEN_TRABAJO] CHECK CONSTRAINT [chkEstadoOrdenTrabajo]
GO
ALTER TABLE [dbo].[SERVICIOS]  WITH CHECK ADD  CONSTRAINT [chkPrecioServicios] CHECK  (([Precio]>(0)))
GO
ALTER TABLE [dbo].[SERVICIOS] CHECK CONSTRAINT [chkPrecioServicios]
GO
ALTER TABLE [dbo].[SERVICIOS]  WITH CHECK ADD  CONSTRAINT [chktipoServicios] CHECK  (([tipo]='P' OR [tipo]='I'))
GO
ALTER TABLE [dbo].[SERVICIOS] CHECK CONSTRAINT [chktipoServicios]
GO
ALTER TABLE [dbo].[TECNICOS]  WITH CHECK ADD  CONSTRAINT [chkTelefonoTecnicos] CHECK  (([telefono] like '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' AND len([telefono])=(9)))
GO
ALTER TABLE [dbo].[TECNICOS] CHECK CONSTRAINT [chkTelefonoTecnicos]
GO
