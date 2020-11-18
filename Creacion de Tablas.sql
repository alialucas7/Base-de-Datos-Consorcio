CREATE database consorcioDB;
use consorcioDB;

CREATE schema organizacion;

DROP table consorcioDB.organizacion.administrador;
CREATE table consorcioDB.organizacion.administrador(
	idadmin int identity primary key,
	apeynom varchar(150) not null,
	viveahi varchar(1) default 'N',
	tel varchar(20),
	sexo varchar(1) not null,
	fechnac date
);
													
--Modificaciones
alter table consorcioDB.organizacion.administrador alter column fechnac varchar(50);
--Restricciones
alter table consorcioDB.organizacion.administrador add constraint CK_admi_fecha check (fechnac < 19980101);
alter table consorcioDB.organizacion.administrador add constraint CK_vive check (viveahi in ('S','N'));
alter table consorcioDB.organizacion.administrador add constraint CK_sex check (sexo in ('M','F'));

DELETE FROM consorcioDB.organizacion.conserje;
DROP table consorcioDB.organizacion.conserje;
CREATE table consorcioDB.organizacion.conserje(
	idconserje int identity (1,1)primary key,
	apeynom varchar(50) not null,
	tel varchar(20),
	fechnac date,
	estciv varchar(1) default 'S'
);

--Restricciones
alter table consorcioDB.organizacion.conserje add constraint CK_conserje_fecha check ((convert (varchar(8),fechnac,112))<19980101);
alter table consorcioDB.organizacion.conserje add constraint CK_estciv check (estciv in ('C','S','D','V','O'));


DROP table consorcioDB.organizacion.localidad;
CREATE table consorcioDB.organizacion.localidad(
	idprovincia int, idlocalidad int  not null,
	--idlocalidad int not null primary key,
	descripcion varchar(50) not null
	primary key(idprovincia,idlocalidad)
);

SELECT * from consorcioDB.organizacion.provincia p ;
CREATE table consorcioDB.organizacion.provincia(
	idprovincia int primary key not null,
	descripcion varchar(50) not null,
	km2 int,
	cantdptos int ,
	nomcabe varchar(50)
);
--Restricciones
--alter table consorcioDB.organizacion.provincia drop column problacion;
alter table consorcioDB.organizacion.provincia add poblacion int;


CREATE table consorcioDB.organizacion.zona(
	idzona int identity  primary key,
	descripcion varchar(50)
);

DROP table consorcioDB.organizacion.consorcio;
CREATE table consorcioDB.organizacion.consorcio(
	idprovincia int  not null,
	idlocalidad int not null,
	idconsorcio int not null,
	nombre varchar(50) not null,
	direccion varchar(250),
	idzona int not null,
	idconserje int  null,
	idadmin int  null
	primary key(idprovincia,idlocalidad,idconsorcio)
);
DROP table consorcioDB.organizacion.gasto;
CREATE table consorcioDB.organizacion.gasto(
	idgasto int identity (1,1),
	idprovincia int not null,
	idlocalidad int not null,
	idconsorcio int not null,
	periodo int not null,
	fechapago date not null,
	idtipogasto int not null,
	importe float not null
	primary key (idprovincia,idlocalidad,idconsorcio,idgasto)
);
--Restricciones
alter table consorcioDB.organizacion.gasto add constraint CK_fechapago check
(convert (varchar(8),fechapago,112) < convert (varchar(8),getdate(),112));
--select (MONTH (GETDATE())); 
alter table consorcioDB.organizacion.gasto add constraint CK_periodo check
(periodo <= (month (getdate())));

alter table consorcioDB.organizacion.gasto  add constraint FK_consorcio_gasto foreign key (idprovincia,idlocalidad,idconsorcio) 
references consorcioDB.organizacion.consorcio(idprovincia,idlocalidad,idconsorcio) 

alter table consorcioDB.organizacion.gasto add constraint FK_tipogasto
foreign key (idtipogasto) references consorcioDB.organizacion.tipogasto
(idtipogasto)
create table consorcioDB.organizacion.tipogasto(
	idtipogasto int not null primary key,
	descripcion varchar(50) not null
);

--Claves Foraneas para consorcio
alter table consorcioDB.organizacion.consorcio 
		--ADD constraint FK_administrador_consorcio FOREIGN KEY(idadmin)  references consorcioDB.organizacion.administrador(idadmin);
		--add constraint FK_conserje_consorcio foreign key(idconserje) references consorcioDB.organizacion.conserje(idconserje);
		--add constraint FK_localidad_consorcio FOREIGN KEY(idprovincia,idlocalidad)  references consorcioDB.organizacion.localidad(idprovincia,idlocalidad);
		add constraint FK_zona_consorcio foreign key (idzona) references consorcioDB.organizacion.zona(idzona);
	ALTER table consorcioDB.organizacion.consorcio drop constraint FK_administrador_consorcio;
	ALTER table consorcioDB.organizacion.consorcio drop constraint FK_conserje_consorcio;
	ALTER table consorcioDB.organizacion.consorcio drop constraint FK_localidad_consorcio;
	ALTER table consorcioDB.organizacion.consorcio drop constraint FK_zona_consorcio;

--Claves Foraneas para Localidad
alter table consorcioDB.organizacion.localidad 
	add constraint FK_provinvia_localidad foreign key (idprovincia) references consorcioDB.organizacion.provincia(idprovincia);

--Claves Foraneas para la tabla gasto
ALTER table consorcioDB.organizacion.gasto 
	--add constraint FK_tipoGasto_gasto foreign key (idtipogasto) references consorcioDB.organizacion.tipogasto (idtipogasto);
	add constraint FK_consorcio_gasto foreign key (idprovincia,idlocalidad,idconsorcio) references consorcioDB.organizacion.consorcio (idprovincia,idlocalidad,idconsorcio);

