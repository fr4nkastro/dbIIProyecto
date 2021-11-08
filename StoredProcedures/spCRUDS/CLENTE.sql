USE ProyectoDBII_Last
alter procedure spAddCliente
--Variables auxiliares
@Nombre varchar(20), @Estado varchar(1), @RTN varchar(20),
@Telefono varchar(10), @Direccion varchar(50) 
as
	--Declaracion de la variable para autonumerica
	declare @Id as int
	--Autoincremento
	select @Id = isnull(max(id),0) + 1 from CLIENTE
	--Antes de la Inserci�n
	--select * from CLIENTE
	--Inserci�n
	insert into CLIENTE values(@Id, @Nombre, @Estado, @RTN, @Telefono, @Direccion)
	----Despu�s de la Inserci�n
	--select * from CLIENTE
go

execute spAddCliente 'BP', 'A', '12345678912345', '2222-6666', 'LIMA'

alter procedure spUpdateCliente 
@Id int, @Nombre varchar(20) =null, @Estado varchar(1)=null, 
@RTN varchar(20)=null, @Telefono varchar(10)=null, @Direccion varchar(50)=null
as
	--Antes de la Actualizaci�n
	--select * from CLIENTE
	--where id = @Id
	--Actualizaci�n
	update CLIENTE set 
	nombre = isnull(@Nombre,nombre),
	estado = isnull(@Estado, estado),
	RTN = isnull(@RTN, rtn),
	telefono = isnull(@Telefono, telefono),
	direccion = isnull(@Direccion, direccion)
	where Id = @Id
	----Despu�s de la Actualizaci�n
	--select * from CLIENTE
	--where id = @Id
go

execute spUpdateCliente 4, @rtn='1234567891200'

create procedure spDeleteCliente
@Id int
as
	--Antes de la Eliminaci�n
	--select * from CLIENTE
	--Eliminando
	delete from CLIENTE where id = @Id
	--Despu�s de la Eliminaci�n
	--select * from CLIENTE
go

execute spDeleteCLIENTE 4
SELECT * FROM CLIENTE