/*
-- EVALUACION 2 --
Ejercicio 1: (20pts)
Crear procedimiento sp_empleado, el cual se entrega por parametro el nombre y apellido 
del empleado, mostrando el nombre de la editorial en los cual participo en la 
publicacion y la cantidad de libros publicados.
formato: el empleado xx publico xx libros en la editorial xx.

Ejercicio 2: (20pts)
Crear un procedimiento que obtenga la siguiente informacion:
Entregando por parametro van a entregar el min_lvl y el max_lvl del empleado
que se necesita mostrar el nombre y apellido y van a obtener la ciudad de la editorial en la que
trabaja. Reemplazar en la ciudad las letras "o" por 0, las letras "a" por 4
y las letras "e" por un 3. 

Ejercicio 3: (60pts)
Realizar un copia de la tabla stores y se trabaja en esa tabla
Crear una tabla para hacer un historial de las tiendas llamada STORE_HISTORIAL.
Parametros de la tabla: id de la tienda, nombre de la tienda, fecha del sistema,
y descripcion de la ejecucion.
-Deben crear un trigger para cada accion:
- Si se inserta en la tabla store, se insertara en la 
tabla historial por ej: 1 - DUOC STORE - 12121-121-12 - 'Se inserto en la tabla store'
- Si se actualiza en la tabla store, se insertara en la tabla historial por ej:
 2 - DUOC STORE - 12121-121-12 - 'Se actualizo en la tabla store'.
- Si se elimina en la tabla store, se insertara en la tabla historial por ej:
 2 - DUOC STORE - 12121-121-12 - 'Se elimino en la tabla store'.
 */

--1	

SELECT e.fname+' '+e.lname,t.title,p.pub_name FROM employee e
		JOIN publishers p ON e.pub_id = p.pub_id
		JOIN titles t ON e.emp_id = e.emp_id
		ORDER BY e.fname ASC
GO

CREATE PROCEDURE sp_empleado @nombre Varchar(255),@apellido Varchar(255)
AS
BEGIN
	DECLARE @empleado VARCHAR(255),@cantidad INT, @editorial VARCHAR(255)
	DECLARE CursorEmpleado CURSOR SCROLL
	 FOR SELECT e.fname+' '+e.lname,COUNT(t.title),p.pub_name FROM employee e
		JOIN publishers p ON e.pub_id = p.pub_id
		JOIN titles t ON e.emp_id = e.emp_id
		WHERE e.fname = @nombre AND e.lname = @apellido
		GROUP BY e.fname,e.lname,p.pub_name
		ORDER BY e.fname ASC
	OPEN CursorEmpleado
		FETCH FIRST FROM CursorEmpleado INTO @empleado,@cantidad,@editorial
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			PRINT 'EL EMPLEADO:'+@empleado+', PUBLICO:'+CAST(@cantidad AS VARCHAR(100))+' LIBROS EN LA EDITORIAL:'+@editorial
			FETCH NEXT FROM CursorEmpleado INTO @empleado,@cantidad,@editorial
		END
	CLOSE CursorEmpleado
	DEALLOCATE CursorEmpleado
END

EXEC sp_empleado 'Anabela','Domingues'

DROP PROCEDURE sp_empleado

--2
SELECT * FROM employee e
JOIN jobs j ON e.job_id = j.job_id
JOIN publishers p ON p.pub_id = e.pub_id 
WHERE j.max_lvl = 100 AND j.min_lvl = 25

GO 

CREATE PROCEDURE sp_ciudad @max_lvl INT, @min_lvl INT
AS
BEGIN
	DECLARE @emp VARCHAR(255),@nombre VARCHAR(255),@editorial Varchar(255),@ciu1 VARCHAR(255),@ciu2 VARCHAR(255),@ciu3 VARCHAR(255)
	DECLARE cursor_emp CURSOR SCROLL
		FOR SELECT e.pub_id,e.fname+' '+e.lname,p.pub_name FROM employee e
			JOIN jobs j ON e.job_id = j.job_id
			JOIN publishers p ON p.pub_id = e.pub_id
			WHERE j.max_lvl = @max_lvl AND j.min_lvl = @min_lvl
		OPEN cursor_emp
			FETCH FIRST FROM cursor_emp INTO @emp,@nombre,@editorial
			WHILE (@@FETCH_STATUS=0)
			BEGIN
				SELECT @ciu1=REPLACE(LOWER(city),'o',0) FROM publishers WHERE pub_id=@emp
				SET @ciu2 = REPLACE(LOWER(@ciu1),'a','4')
				SET @ciu3 = REPLACE(LOWER(@ciu2),'e','3')
				PRINT 'El empleado '+@nombre+', su editorial es:'+@editorial+' y trabaja en '+@ciu3--+' Y la ciudad de la editorial es '+@ciu3
				FETCH NEXT FROM cursor_emp INTO @emp,@nombre,@editorial
			END
		CLOSE cursor_emp
		DEALLOCATE cursor_emp
END

EXEC sp_ciudad 100,25

DROP PROCEDURE sp_ciudad
GO
--3
SELECT * into stores_copia from stores

SELECT * FROM stores_copia
GO

CREATE TABLE stores_historial
(stor_id varchar(50),
stor_name char(255),
fecha datetime,
descripcion varchar(100));

GO 
--ACTUALIZAR
CREATE TRIGGER tr_historial_actualizar
ON stores_copia
FOR UPDATE AS
BEGIN
	INSERT INTO stores_historial SELECT stor_id,stor_name,GETDATE(),'SE ACTUALIZO EN LA TABLA STORES' FROM inserted
END

GO 

UPDATE stores_copia SET city = 'Seattlee' WHERE stor_id = 6380

GO

--INSERTAR
CREATE TRIGGER tr_historial_inserto
ON stores_copia
FOR INSERT AS
BEGIN
	INSERT INTO stores_historial SELECT stor_id,stor_name,GETDATE(),'SE INSERTO EN LA TABLA STORES' FROM inserted
END

INSERT INTO stores_copia VALUES('8888','nuevo','21421 asdas','Puente Alto','WA','21421')

GO
--ELIMINAR
CREATE TRIGGER tr_historial_elimino
ON stores_copia
FOR DELETE AS
BEGIN
	INSERT INTO stores_historial SELECT stor_id,stor_name,GETDATE(),'SE ELIMINO EN LA TABLA STORES' FROM deleted
END

DELETE FROM stores_copia WHERE stor_id = '8888'


SELECT * FROM stores_historial
SELECT * FROM stores_copia




