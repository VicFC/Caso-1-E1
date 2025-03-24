use paymentAssistant;

DROP TEMPORARY TABLE IF EXISTS tempNames;
CREATE TEMPORARY TABLE tempNames (indivName varchar(30));
INSERT INTO tempNames
VALUES ("Carlos"), ("María"), ("José"), ("Ana"), ("Juan"), ("Gabriela"), ("Luis"), ("Fernanda"), ("Miguel"), ("Valeria"),
("Antonio"), ("Camila"), ("Fernando"), ("Daniela"), ("Javier"), ("Lucía"), ("Ricardo"), ("Sofía"), ("Andrés"), ("Isabela"),
("Manuel"), ("Carla"), ("Hugo"), ("Elena"), ("Emilio"), ("Paula"), ("Raúl"), ("Beatriz"), ("Diego"), ("Patricia"),
("Santiago"), ("Adriana"), ("Ángel"), ("Rocío"), ("Martín"), ("Verónica"), ("Pablo"), ("Cecilia"), ("Héctor"), ("Lorena"),
("Esteban"), ("Clara"), ("Rubén"), ("Alejandra"), ("Sebastián"), ("Mónica"), ("Gustavo"), ("Julieta"), ("Ramón"), ("Ximena");

DROP TEMPORARY TABLE IF EXISTS tempLastNames;
CREATE TEMPORARY TABLE tempLastNames (indivName varchar(35));
INSERT INTO tempLastNames (indivName)
VALUES ("García"), ("Martínez"), ("Rodríguez"), ("López"), ("González"), ("Pérez"), ("Hernández"), ("Sánchez"), ("Ramírez"), ("Torres"),
("Flores"), ("Rivera"), ("Gómez"), ("Díaz"), ("Mendoza"), ("Vargas"), ("Castillo"), ("Ortega"), ("Silva"), ("Guerrero"),
("Rojas"), ("Cruz"), ("Delgado"), ("Morales"), ("Reyes"), ("Fuentes"), ("Jiménez"), ("Navarro"), ("Paredes"), ("Suárez"),
("Villanueva"), ("Mejía"), ("Cabrera"), ("Cárdenas"), ("Salazar"), ("Valenzuela"), ("Ramos"), ("Álvarez"), ("Medina"), ("Aguilar"),
("Pacheco"), ("Bermúdez"), ("Zamora"), ("Esquivel"), ("Campos"), ("Montoya"), ("Peralta"), ("Peña"), ("Ibarra"), ("Miranda");

DROP TEMPORARY TABLE IF EXISTS tempCont;
CREATE TEMPORARY TABLE tempCont (indivName varchar(45));
INSERT INTO tempCont (indivName)
VALUES ("Argentina"), ("Bolivia"), ("Brazil"), ("Chile"), ("Colombia"), ("Costa Rica"), ("Cuba"), ("Dominican Republic"), ("Ecuador"), ("El Salvador"),
("Guatemala"), ("Honduras"), ("Mexico"), ("Nicaragua"), ("Panama"), ("Paraguay"), ("Peru"), ("Puerto Rico"), ("Uruguay"), ("Venezuela"),
("Spain"), ("Portugal"), ("France"), ("Italy"), ("Germany"), ("Canada"), ("United States"), ("United Kingdom"), ("Australia"), ("New Zealand"),
("China"), ("Japan"), ("South Korea"), ("India"), ("Russia"), ("South Africa"), ("Egypt"), ("Morocco"), ("Nigeria"), ("Kenya"),
("Thailand"), ("Vietnam"), ("Philippines"), ("Indonesia"), ("Malaysia"), ("Turkey"), ("Greece"), ("Sweden"), ("Norway"), ("Finland");

DROP PROCEDURE IF EXISTS LlenarDeUsers;
DELIMITER //

CREATE PROCEDURE LlenarDeUsers()
BEGIN
	set @countUsers = 30;
	while @countUsers > 0 do

		set @tempNameHolder = "This_is_temporary_va";
        set @tempLastNameHolder = "This_is_temporary_va";
		set @tempContHolder = "This_is_temporary_va";
        
		select indivName from tempNames
		order by RAND()
		limit 1 into @tempNameHolder;
    
		select indivName from tempLastNames
		order by RAND()
		limit 1 into @tempLastNameHolder;
        
        select indivName from tempCont
		order by RAND()
		limit 1 into @tempContHolder;
    
		insert into paymentAssistant.payment_users (firstName, lastName, email, country)
        values (@tempNameHolder, 
        @tempLastNameHolder, 
        concat(@tempNameHolder, floor(RAND()*999), "@gmail.com"), 
        @tempContHolder);
    
		set @countUsers = @countUsers - 1;
    
    end while;

END //

call LlenarDeUsers;
select * from payment_users;