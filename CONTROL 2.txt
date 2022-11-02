--CONTROL 2
--EJERCICIO 1:
--CREAR EL PROCEDIMIENTO sp_aumento EL CUAL VA AUMENTAR EN 10
--LA CANTIDAD DE VENTA DE UN LIBRO EN ESPECIFICO ENTREGANDO EL TITLE_ID,
--SI LA CANTIDAD VENDIDA FUE MENOR A 10 SE AUMENTA EN 1
--SI LA CANTIDAD VENDIDA FUE MAYOR A 10 Y MENOR A 20 AUMENTA EN 5
--SI LA CANTIDAD VENDIDA FUE MAYOR A 20 Y MENOR A 70 AUMENTA EN 10

--EJERCICIO 2:
/*
	CREAR UN PROCEDIMIENTO sp_informativo, EL CUAL OBTENGA LA SIGUIENTE INFORMACION:
	NOMBRE Y APELLIDO DEL AUTOR, NOMBRE Y APELLIDO DEL EMPLEADO, NOMBRE DE 
	LA EDITORIAL Y EL NOMBRE DEL LIBRO:
	EJ:NOMBRE AUTOR ESCRIBIO EL LIBRO "NO HAGO BANDEJAS" Y LO PUBLICO EN LA EDITORIAL
	DUOC PUENTE ALTO Y FUE ATENDIDO POR NOMBRE EMPLEADO
*/

--EJERCICIO 3
/*
	CREAR UN PROCEDIMIENTO sp_chavez, EL CUAL SE ENTREGA POR PARAMETRO EL NOMBRE Y EL APELLIDO 
	DEL AUTOR, MOSTRANDO LAS VENTAS DEL AUTOR Y LA CIUDAD EN DONDE SE VENDIO EL LIBRO.
	EJ: EL AUTOR  aaaa VENDIO 45 LIBROS EN LA CIUDAD DE SANTIAGO
*/


SELECT t.title_id,s.qty FROM SALES s
JOIN titles t ON s.title_id = t.title_id 

GO

CREATE PROCEDURE sp_aumento
AS
BEGIN
	DECLARE @title_id VARCHAR(255),@venta INT
	DECLARE CursorVentas CURSOR SCROLL
		FOR SELECT t.title_id,s.qty FROM SALES s
			JOIN titles t ON s.title_id = t.title_id 
		OPEN CursorVentas
		FETCH FIRST FROM CursorVentas INTO @title_id,@venta
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			IF @venta < 10
				UPDATE sales SET qty = @venta+1 WHERE title_id = @title_id AND qty=@venta
			IF @venta >= 10 AND @venta<20
				UPDATE sales SET qty = @venta+5 WHERE title_id = @title_id AND qty=@venta
			IF @venta >= 20 AND @venta<70
				UPDATE sales SET qty = @venta+10 WHERE title_id = @title_id AND qty=@venta
			PRINT @title_id
			FETCH NEXT FROM CursorVentas INTO @title_id,@venta
		END
	CLOSE CusorVentas
	DEALLOCATE CursorVentas
END

GO

EXEC sp_aumento

GO

SELECT t.title_id,s.qty FROM SALES s
JOIN titles t ON s.title_id = t.title_id 

GO

CREATE PROCEDURE sp_informativo
AS
BEGIN
	DECLARE @autor VARCHAR(255),@titulo VARCHAR(255), @editorial VARCHAR(255), @empleado VARCHAR(255)
	DECLARE CursorInformativo CURSOR SCROLL
	 FOR SELECT a.au_fname+' '+a.au_lname,t.title,p.pub_name,e.fname+' '+e.lname FROM authors a
			JOIN titleauthor ta ON ta.au_id = a.au_id
			JOIN titles t ON ta.title_id = t.title_id
			JOIN publishers p ON t.pub_id = p.pub_id
			JOIN employee e ON p.pub_id = e.pub_id
			ORDER BY a.au_fname asc
	OPEN CursorInformativo
		FETCH FIRST FROM CursorInformativo INTO @autor,@titulo,@editorial,@empleado
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			PRINT 'EL AUTOR:'+@autor+', ESCRIBIO EL LIBRO:'+@titulo+', LO PUBLICO EN LA EDITORIAL:'+@editorial+', Y FUE ATENDIDO POR:'+@empleado
			FETCH NEXT FROM CursorInformativo INTO @autor,@titulo,@editorial,@empleado
		END
	CLOSE CursorInformativo
	DEALLOCATE CursorInformativo
END

EXEC sp_informativo

GO

CREATE PROCEDURE sp_chavez @nombre VARCHAR(255),@apellido VARCHAR(255)
AS
BEGIN
	DECLARE @autor VARCHAR(255),@ventas INT, @ciudad VARCHAR(255)
	DECLARE CursorAutor CURSOR SCROLL
	FOR SELECT a.au_fname+' '+a.au_lname,s.qty,st.city FROM authors a
		JOIN titleauthor ta ON ta.au_id = a.au_id
		JOIN titles t ON t.title_id = ta.title_id
		JOIN sales s ON t.title_id = s.title_id
		JOIN stores st ON s.stor_id = st.stor_id 
		WHERE a.au_fname = @nombre AND a.au_lname = @apellido 
	OPEN CursorAutor
		FETCH FIRST FROM CursorAutor INTO @autor,@ventas,@ciudad
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			PRINT 'El AUTOR '+@autor+' VENDIO '+CAST(@ventas AS VARCHAR(50))+' EN LA CIUDAD DE '+@ciudad
			FETCH NEXT FROM CursorAutor INTO @autor,@ventas,@ciudad
		END
	CLOSE CursorAutor
	DEALLOCATE CursorAutor
END

EXEC sp_chavez 'Marjorie','Green'