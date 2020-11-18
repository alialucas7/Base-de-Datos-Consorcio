


--  Serie 3 
--Ejercicio 1
 -- para verificar
SELECT * FROM organizacion.consorcio c where idzona = 6

SELECT c.nombre, c.idzona, p.descripcion, l.descripcion, c.direccion , z.descripcion
FROM organizacion.consorcio as c
inner join organizacion.provincia as p on c.idprovincia = p.idprovincia 
inner join organizacion.localidad as l on c.idlocalidad = l.idlocalidad 
and 									  c.idprovincia = l.idprovincia 
inner join organizacion.zona as z      on c.idzona = z.idzona 
 
WHERE c.idzona in (
SELECT TOP 2 c1.idzona
FROM organizacion.consorcio c1
--INNER JOIN organizacion.zona z ON c1.idzona = z.idzona
GROUP BY c1.idzona
ORDER BY COUNT(*) DESC
)
order by c.idzona DESC;

-- Ejercicio 2
-- para verificar
select p.idprovincia ,p.descripcion ,p.poblacion from organizacion.provincia as p order by p.poblacion desc
select * from organizacion.consorcio c where c.idprovincia = 6


select *  from organizacion.conserje as co
 where datediff (YEAR,co.fechnac,GETDATE()) > 50
 and co.idconserje  not in
(
	select c.idconserje from organizacion.consorcio as c 
	where c.idprovincia in
	(
		SELECT top 1 p.idprovincia from organizacion.provincia as p
		order by p.poblacion DESC 
	)
	
)

--order by co.fechnac ASC 
-----------------------------------------------------------------------
--Otra forma de hacer
--La desventaja de esta forma es que la longitud de registro de cada tabla
--deben ser igualitas al igual que lo tipos de datos deben ocincidir
select co.idconserje ,co.apeynom from organizacion.conserje as co
 where datediff (YEAR,co.fechnac,GETDATE()) > 50

EXCEPT 
(
	select c.idconserje, c.nombre  from organizacion.consorcio as c 
	where c.idprovincia in
	(
		SELECT top 1 p.idprovincia from organizacion.provincia as p
		order by p.poblacion DESC 
	)
	
)


-- Ejercicio 3
-- Para verificar
select * from organizacion.tipogasto as t
select * from organizacion.provincia as p 
select * from organizacion.gasto as g where YEAR(g.fechapago) = 2015 and g.idprovincia = 2

select g.idgasto ,t.idtipogasto , t.descripcion, g.fechapago 
from organizacion.tipogasto as t
inner join organizacion.gasto as g on t.idtipogasto = g.idtipogasto 
where YEAR(g.fechapago) = 2015 and  g.idgasto in (
SELECT g.idgasto from organizacion.gasto as g where g.idprovincia <> 2
);


-- Ejercicio 4
-- Verificacion
SELECT COUNT(*) from organizacion.provincia p 

SELECT p.idprovincia, p.descripcion ,l.idprovincia ,l.descripcion from organizacion.provincia p 
full outer join organizacion.localidad l on p.idprovincia = l.idprovincia 



-- Serie 4
-- Ejercicio 1
-- Para comprobar
SELECT  t.descripcion , sum(g.importe) from organizacion.gasto as g
full outer join organizacion.tipogasto as t  
on g.idtipogasto = t.idtipogasto 
GROUP by t.descripcion 

Insert into consorcioDB.organizacion.tipogasto (idtipogasto, descripcion) values (6,'nuevo')

SELECT t.descripcion from organizacion.tipogasto as t
left outer join organizacion.gasto as g 
on t.idtipogasto = g.idtipogasto 
where g.idtipogasto is NULL 

-- Ejercicio 2
-- Para verificar 
SELECT count(*) from organizacion.consorcio ;
select g.idprovincia ,g.idlocalidad ,g.idconsorcio ,COUNT(*) as 'cantidad de gastos'
from organizacion.gasto as g
group by g.idprovincia ,g.idlocalidad, g.idconsorcio 
order by g.idprovincia asc


SELECT COUNT(c.idconsorcio) from organizacion.consorcio as c
where /*not*/ EXISTS(
				SELECT * from organizacion.gasto as g
				where c.idprovincia = g.idprovincia AND 
					  c.idlocalidad = g.idlocalidad AND 
					  c.idconsorcio = g.idconsorcio 
 )

SELECT SUM(g.importe) from organizacion.gasto g 


-- Ejercicio 3
-- Para verificar
SELECT * from organizacion.administrador; 
select * from organizacion.consorcio 
-- Alternativa 1
select c.idadmin ,a.idadmin , a.apeynom from organizacion.administrador as a
left outer join organizacion.consorcio as c 
on a.idadmin = c.idadmin 
--where c.idadmin is NULL 

-- Alternativa 2
SELECT * from organizacion.administrador as a
where NOT EXISTS (
		SELECT * from organizacion.consorcio as c
		where c.idadmin = a.idadmin 
)

-- Ejercicio 4
-- Para verificar visualizar las edades

SELECT a.idadmin ,a.apeynom ,
DATEDIFF(YEAR,a.fechnac,GETDATE()) as edad, -- Devuelve la edad, nada mas que eso
co.nombre as edificio,
co.idadmin as 'id(consorcio/admin)'
from organizacion.administrador as a 
inner join organizacion.consorcio as co on a.idadmin = co.idadmin 

-- Pone el filtro si la edad del administrador es menor al promedio
where DATEDIFF(YEAR,a.fechnac,GETDATE()) < 
 (
	SELECT AVG(YEAR (GETDATE()) - YEAR (a.fechnac) ) from organizacion.administrador a 
 )
 
 -- Ejercicio 5
select * from organizacion.tipogasto t ;
 
SELECT * from organizacion.administrador as a 
where  a.idadmin = (
				SELECT top 1 c.idadmin from organizacion.gasto g 
				inner join organizacion.consorcio as c on g.idconsorcio = c.idconsorcio 
				inner join organizacion.tipogasto as t on g.idtipogasto = t.idtipogasto 
				where 
				t.descripcion = 'Servicios' AND 
				YEAR (g.fechapago) = 2015 
				order by g.importe ASC 
		
)

-- Ejercicio 6

SELECT * from organizacion.consorcio c ;

select sum(g.importe) from organizacion.gasto g 
inner join organizacion.tipogasto as t on g.idtipogasto = t.idtipogasto 
where YEAR(fechapago) = 2015 and t.descripcion = 'Sueldos' 
group by g.idprovincia , g.idlocalidad , g.idconsorcio, t.descripcion 

HAVING SUM(g.importe) > 
(
SELECT 
AVG(resulta.sumi) as 'total gastos' from(select SUM(g.importe) sumi 
from organizacion.gasto g 
where YEAR(fechapago) = 2015 and g.idtipogasto = 3
group by g.idprovincia , g.idlocalidad , g.idconsorcio 
) as resulta
)


-- Practicas para el parcial
-- Muestra la cantidad de gastos de cada consorcio
SELECT p.descripcion, l.descripcion , c.nombre, COUNT(*) as 'cantidad gastos' 
from organizacion.gasto as g
inner join organizacion.consorcio as c on g.idconsorcio = c.idconsorcio 
inner join organizacion.localidad as l on c.idlocalidad = l.idlocalidad and c.idprovincia = l.idprovincia 
inner join organizacion.provincia as p on l.idprovincia = p.idprovincia 
GROUP by p.descripcion, l.descripcion , c.nombre
order by p.descripcion ASC 

-- Mustra la cantidad de consorcios por provincia y localidad 
SELECT p.descripcion, l.descripcion , COUNT(*) as 'cantidad de consorcios' 
from organizacion.consorcio as c
inner join organizacion.localidad as l on c.idlocalidad = l.idlocalidad and c.idprovincia = l.idprovincia 
inner join organizacion.provincia as p on l.idprovincia = p.idprovincia 
GROUP by p.descripcion, l.descripcion 
order by p.descripcion ASC 
 
-- Muestra los gastos de servicios(1) y sueldos(3) en el año 2013
SELECT * from organizacion.gasto as g
where g.idgasto in (
						SELECT g.idgasto from organizacion.gasto as g
						inner join organizacion.tipogasto as t on g.idtipogasto = t.idtipogasto 
						where YEAR(g.fechapago) = 2013 and (t.descripcion = 'Sueldos' or t.descripcion = 'Servicios')
				)


SELECT c1.apeynom , c1.idconserje ,c.idconserje from organizacion.consorcio c 
right join organizacion.conserje as c1 on c.idconserje = c1.idconserje 
where c.idconserje is NULL 
				
				
				
				
				
				
-- Recuperatorio Parcial 2018

﻿/* ALUMNO: A partir de la tabla “gasto” del modelo de datos “consorcio” se necesita generar una factura por mes y por consorcio, se debe tener 
           en cuenta cada uno de los gastos registrados y el mes en que se realizó. El objetivo de estas facturas es remitirlas a cada consorcio 
		   para poder recuperar los gastos realizados por la administración.
           Para ello se solicita:*/

/* 1. Adaptar el modelo de datos “consorcio” (siguiendo las pautas del diseño relacional y redefiniendo la clave principal de la tabla gasto si 
     lo considera necesario) para que permita registrar las facturas respectivas teniendo en cuenta las siguientes restricciones:
		 El número de la factura debe ser único.
		 Se debe conocer la fecha de emisión de la factura y la fecha de vencimiento. La fecha de vencimiento se deberá calcular automáticamente
		  y tendrá que ser 30 días posteriores a la fecha de emisión. También se necesita registrar en la factura el mes y el año del período de
          facturación.
		 Los ítems de las facturas se deberán obtener de la tabla ‘gasto’. No se podrá facturar ningún ítem que no esté registrado previamente 
		  en dicha tabla, y un ítem no podrá aparecer en más de una factura. */



CREATE TABLE organizacion.factura(
	idFactura INT CONSTRAINT PK_idfactura PRIMARY KEY,
	nroFactura INT UNIQUE,
	fechaEmision DATE DEFAULT GETDATE(),
	fechaVencimiento DATE DEFAULT DATEADD(dd, 30, getdate()),
	mes INT NOT NULL,
	agno INT NOT NULL

);

SELECT * FROM organizacion.gasto g ;


CREATE TABLE organizacion.detallefactura



(
	idFactura INT NOT NULL,
    idDetalleFactura INT NOT NULL,
    idgasto INT NOT NULL ,
    primary key (idFactura,idDetalleFactura),
   -- foreign key (idgasto) references organizacion.gasto(idgasto)
    
);



ALTER TABLE organizacion.detalleFactura
		ADD CONSTRAINT PK_detalleFactura PRIMARY KEY (idFactura, idDetalleFactura);


ALTER TABLE organizacion.detalleFactura
	ADD CONSTRAINT FK_detalleFactura_Factura FOREIGN KEY (idFactura) REFERENCES organizacion.factura(idFactura);


ALTER TABLE consorcioDB.organizacion.detalleFactura
	ADD CONSTRAINT FK_detalleFactura_Gasto FOREIGN KEY (idgasto) REFERENCES organizacion.gasto(idgasto)

SELECT * FROM factura;


SELECT * FROM organizacion.detallefactura;



/* 2. Generar un lote de datos representativo (tomado de la tabla ‘gasto’) que permita corroborar el modelo de datos, y satisfacer las consultas 
      que se solicitan en los puntos siguientes.*/

INSERT INTO factura (idFactura, nroFactura, mes, agno) VALUES (1, 1, 1, 2013);
INSERT INTO factura (idfactura, nroFactura, mes, agno) VALUES (2, 2, 7, 2013);
INSERT INTO factura (idfactura, nroFactura, mes, agno) VALUES (3, 3, 5, 2013);
INSERT INTO factura (idfactura, nroFactura, mes, agno) VALUES (4, 4, 8, 2015);
INSERT INTO factura (idfactura, nroFactura, mes, agno) VALUES (5, 5, 3, 2014);
INSERT INTO factura (idfactura, nroFactura, mes, agno) VALUES (6, 6, 6, 2014);


SELECT * FROM factura;
GO

INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (1,1,6);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (2,1,3);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (2,2,4);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (2,3,7);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (3,1,17);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (3,2,15);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (4,1,54);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (4,2,41);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (5,1,35);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (6,1,33);
INSERT INTO organizacion.detalleFactura (idFactura, idDetalleFactura, idgasto) VALUES (6,2,36);
GO

SELECT * FROM detalleFactura;
GO


/* 3. Mostrar los siguientes datos por cada facturación: Nro. de factura, fecha de emisión, fecha de vencimiento, periodo de facturación 
     (mes y año), nombre del consorcio y monto total de la factura (este dato debe ser calculado en base a los gastos de cada periodo). */

SELECT factura.nroFactura, factura.fechaEmision, factura.fechaVencimiento, consorcio.nombre, SUM(gasto.importe) as ' MONTO FACTURACIÓN'
FROM factura 
INNER JOIN detalleFactura  ON factura.idFactura = detallefactura.idFactura
INNER JOIN gasto  ON detallefactura.idGasto = gasto.idGasto
INNER JOIN consorcio ON consorcio.idprovincia = gasto.idprovincia AND consorcio.idlocalidad = gasto.idlocalidad
AND consorcio.idconsorcio = gasto.idconsorcio
GROUP BY factura.nroFactura, factura.fechaEmision, factura.fechaVencimiento, consorcio.nombre;
GO

/*4. Mostrar un listado de los gastos, junto con el nombre de consorcio al que pertenece, solo de aquellos
gastos que no hayan sido incluido en ninguna factura. */

SELECT consorcio.nombre, gasto.*, detallefactura.idFactura
FROM consorcio 
INNER JOIN gasto ON consorcio.idprovincia = gasto.idprovincia AND consorcio.idlocalidad = gasto.idlocalidad
AND consorcio.idconsorcio = gasto.idconsorcio
LEFT JOIN detalleFactura ON gasto.idGasto = detallefactura.idGasto
WHERE detallefactura.idFactura IS NULL;
GO

/* 5. Mostrar la factura que tuvo el ítem de mayor gasto.*/

SELECT factura.*
FROM gasto 
INNER JOIN detalleFactura ON gasto.idGasto = detallefactura.idGasto
INNER JOIN factura  ON detallefactura.idFactura = factura.idFactura
WHERE gasto.importe = (SELECT max(gasto.importe)
						from gasto 
						INNER JOIN detalleFactura ON gasto.idGasto = detallefactura.idGasto
);













				
				
				

