use paymentAssistant;
SET SQL_SAFE_UPDATES = 0;

-- Usuarios ------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	set @countUsers = 45;
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




-- Transacciones y Pagos ----------------------------------------------------------------------------------------------------------------------------------------------------

insert into moneda (name, acronym)
values ("Costa Rican Colón", "CRC"), ("US Dollar", "USD"), ("Euro", "EUR"), ("British Pound", "GBP"), ("Japanese Yen", "JPY"),
("Mexican Peso", "MXN"), ("Brazilian Real", "BRL"), ("Argentine Peso", "ARS"), ("Canadian Dollar", "CAD"), ("Swiss Franc", "CHF");
select * from moneda;

insert into exchange (monedaid, startDate, endDate, exchangeRate, enabled, currentExchangeRate)
values (1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 1, 1, 1),
(2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.002, 1, 1),
(3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0018, 1, 1),
(4, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0015, 1, 1),
(5, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.3, 1, 1),
(6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.04, 1, 1),
(7, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0114, 1, 1),
(8, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 2.14, 1, 1),
(9, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.00287, 1, 1),
(10, CURDATE(), DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), 0.0018, 1, 1);

select * from exchange;


insert into metodoDePago (name, ApiURL, secretKey, metodoDePago.key, logoIconVal, enabled)
values ('Stripe', 'https://api.stripe.com/v1/charges/', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Authorize.net', 'https://www.sandbox.paypal.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('PayPal', 'https://api-m.sandbox.paypal.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Adyen', 'https://checkout-test.adyen.com/', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1),
('Braintree', 'https://payments.braintree-api.com', SHA2(RAND(), 224), SHA2(RAND(), 224), null, 1);

select * from metodoDePago;



DROP PROCEDURE IF EXISTS LlenarDeMediosDisponibles;
DELIMITER //

CREATE PROCEDURE LlenarDeMediosDisponibles()
BEGIN

	set @countUsers = NULL;
    set @countMedios = NULL; 
    
	select count(*) from payment_users into @countUsers;
    select count(*) from metodoDePago into @countMedios;
    
	while @countUsers > 0 do
    
		set @methodNumber = FLOOR(RAND()*2) + 1;
        
        set @username = NULL;
		select firstName from payment_users where userid = @countUsers into @username;
        
        while @methodNumber > 0 do
            
            set @tempToken = NULL;
            select SHA2(RAND(), 224) into @tempToken;
            
            insert into mediosDisponibles (MetodoDePagoid, userid, name, token, expTokenDate, maskAccount)
			values (FLOOR(RAND() * @countMedios)+1, 
            @countUsers, 
            concat(@username, FLOOR(RAND()*99)), 
            @tempToken, 
            DATE_ADD(CURDATE(), 
            INTERVAL FLOOR(RAND()*31)+1 DAY), 
            lpad(right(@tempToken, 5), char_length(@tempToken) - 5, '*'));
            
			set @methodNumber = @methodNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
    end while;

END //

call LlenarDeMediosDisponibles;
select * from mediosDisponibles


insert into transTypes (name)
values ("Credit"), ("Debit"), ("BitCoin"), ("Bank Transfer"), ("Digital Wallet"), ("SIMPE");
select * from transTypes;



DROP PROCEDURE IF EXISTS LlenarDePagos;
DELIMITER //

CREATE PROCEDURE LlenarDePagos()
BEGIN

	set @countUsers = NULL;
    
	select count(*) from payment_users into @countUsers;
    
	while @countUsers > 0 do
    
		set @payNumber = FLOOR(RAND()*3);
        
        while @payNumber > 0 do
            
            set @metodoTemp = NULL;
            set @medioTemp = NULL;
            set @montoTemp = FLOOR(RAND()*1000000) + 1;
			select metodoDePagoid, mediosDisponiblesid from mediosDisponibles where mediosDisponibles.userid = @countUsers order by RAND() limit 1 into @metodoTemp, @medioTemp;
        
            insert into pagos (metodoDePagoid, mediosDisponiblesid, userid, monedaid, monto, actualMonto, payDateTime,
			auth, pagos.reference, chargeToken, pagos.description, error, pagos.checkSum)
            values (@metodoTemp, @medioTemp, @countUsers, 1, @montoTemp, @montoTemp, 
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND()*720) HOUR),
            SHA2(RAND(), 224), FLOOR(RAND()*9999999999) + 1, LEFT(UUID(), 6), null, null, FLOOR(RAND()*99999999));
            
			set @payNumber = @payNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
        
    end while;

END //

call LlenarDePagos;
select * from pagos



DROP PROCEDURE IF EXISTS LlenarDeTrans;
DELIMITER //

CREATE PROCEDURE LlenarDeTrans()
BEGIN

	set @countPagos = NULL;
    set @transTypesTemp = NULL;
    
	select count(*) from pagos into @countPagos;
    select count(*) from transTypes into @transTypesTemp;
    
	while @countPagos > 0 do
    
		set @payNumber = FLOOR(RAND()*2);
        
        while @payNumber > 0 do
            
            set @pagosidtemp = NULL;
            set @useridtemp = NULL;
            set @montotemp = NULL;
            set @dateTimeTemp = NULL;
            
            select DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 360) + 1 HOUR) into @dateTimeTemp;
			select pagosid, userid, monto from pagos where pagos.pagosid = @countPagos 
            limit 1 into @pagosidtemp, @useridtemp, @montotemp;
        
            insert into transacciones (pagosid, transTypesid, monedaid, exchangeid, userid, amount, 
            transacciones.description, transDateTime, postTime, refNumber, transacciones.checkSum)
            values (@pagosidtemp, FLOOR(RAND() * @transTypesTemp) + 1, 1, 1, @useridtemp, @montotemp, 
            'pago', @dateTimeTemp, @dateTimeTemp, 
            FLOOR(RAND()*99999999), FLOOR(RAND()*99999999));
            
			set @payNumber = @payNumber - 1;
			end while;
            
		set @countPagos = @countPagos - 1;
        
    end while;

END //

call LlenarDeTrans;
select * from transacciones



-- AI --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TEMPORARY TABLE IF EXISTS tempRequests;
CREATE TEMPORARY TABLE tempRequests (indivName varchar(30));
INSERT INTO tempRequests
VALUES ("Create new payment method"), ("Create new monthly payment"), ("Change personal information"), 
("Check current contact info"), ("Upgrade my plan");

DROP PROCEDURE IF EXISTS LlenarDeConv;
DELIMITER //

CREATE PROCEDURE LlenarDeConv()
BEGIN

	set @countUsers = NULL;
    
	select count(*) from payment_users into @countUsers;
    
	while @countUsers > 0 do
    
		set @convNumber = FLOOR(RAND()*2) + 1;
        
        while @convNumber > 0 do
        
			set @convTypeTemp = NULL;
            set @score = FLOOR(RAND() * 6);
            select indivName from tempRequests
			order by RAND()
			limit 1 into @convTypeTemp;
            
            insert into conversation (userid, conversation.type, conversation.status, prompttime, starrating, review)
            values (@countUsers, @convTypeTemp, 'Finished', DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 360) HOUR), 
            @score, IF(@score >= 4, 'The assistant was very helpful', 'I found the help lacking'));
            
			set @convNumber = @convNumber - 1;
			end while;
            
		set @countUsers = @countUsers - 1;
        
    end while;

END //

call LlenarDeConv;
select * from conversation


insert into statusType (statusType.name)
values ("New Entry"), ("Changed Entry"), ("Deleted Entry");

insert into interactionDataTypes (interactionDataTypes.name)
values ("Phone Number"), ("Email"), ("Account Name"), ("Transaction"), ("User alias"), ("Date & Time")



DROP PROCEDURE IF EXISTS LlenarDeInter;
DELIMITER //

CREATE PROCEDURE LlenarDeInter()
BEGIN

	set @countConv = NULL;
    
	select count(*) from payment_users into @countConv;
    
	while @countConv > 0 do
    
		set @convNumber = FLOOR(RAND()*3) + 1;
        
        while @convNumber > 0 do
            
            insert into interaction (conversationid, audioURL, transcript, specificresponse, requestTime, responseTime,
            interaction.key, interaction.version, maxToken, returnContent, interaction.error)
            values (@countConv, concat('https://www.', LEFT(UUID(), 20), '.com'), 'User Input', 
            'Hello, how may I help today?', FLOOR(RAND()*5) + 1, FLOOR(RAND()*5) + 1, LEFT(UUID(), 20), 
            '2025-03-11', 1024, 'Full AI Response', null);
            
			set @convNumber = @convNumber - 1;
			end while;
            
		set @countConv = @countConv - 1;
        
    end while;

END //

call LlenarDeInter;
select * from interaction



DROP PROCEDURE IF EXISTS LlenarDeDPInter;
DELIMITER //

CREATE PROCEDURE LlenarDeDPInter()
BEGIN

	set @countInter = NULL;
    set @datypeMaxTemp = NULL;
    set @interTemp = NULL;
            
	select count(*) from interaction into @countInter;
    select count(*) from interactionDataTypes into @datypeMaxTemp;
    select count(*) from statusType into @interTemp;
    
	while @countInter > 0 do
    
		
		set @interNumber = FLOOR(RAND()*3);
        
        while @interNumber > 0 do
            
			set @datypeTemp = FLOOR(RAND() * @datypeMaxTemp) + 1;
            
            set @contentTemp = NULL;
            
            select case
				when @datypeTemp = 1 then FLOOR(RAND()*99999999)
                when @datypeTemp = 2 then concat(left(SHA2(RAND(), 224), 15), "@gmail.com")
                when @datypeTemp = 3 then left(SHA2(RAND(), 224), 20)
                when @datypeTemp = 4 then FLOOR(RAND()*99999999)
                when @datypeTemp = 5 then 'Honey'
                else DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) HOUR)
			end
            into @contentTemp;
            
            insert into dataPerInteraction (interactiondatatypeid, interactionid, statustypeid, 
            content, certainty, dataPerInteraction.checksum, generalresponse)
            values (@datypeTemp, @countInter, FLOOR(RAND() * @interTemp) + 1, 
            @contentTemp, ROUND(RAND(), 2), FLOOR(RAND()*99999999), 'Here is what I think about this information');
            
			set @interNumber = @interNumber - 1;
			end while;
        
		set @countInter = @countInter - 1;
        
    end while;

END //

call LlenarDeDPInter;
select * from dataPerInteraction

-- Introducción de errores
update interaction
join dataPerInteraction ON interaction.interactionid = dataPerInteraction.interactionid
join conversation ON interaction.conversationid = conversation.queryid
SET interaction.error = case
                           when interaction.responseTime > 3 then 'Error: High response time'
                           when dataPerInteraction.certainty < 0.5 then 'Error: Low certainty'
                           when conversation.starrating < 3 then 'Error: Low star rating'
                           else NULL
                        end
where interaction.responseTime > 3
   OR dataPerInteraction.certainty < 0.5
   OR conversation.starrating < 3;

select * from interaction



-- Planes y Precios ----------------------------------------------------------------------------------------------------------------------------------------------------------------------


insert into subscriptions (description, logoURL)
values ("Standard", "https://iconlogo.com/standard"), 
("Premium", "https://iconlogo.com/premium"), 
("Deluxe", "https://iconlogo.com/deluxe");
select * from subscriptions

insert into planfeatures (description, enabled, dataType)
values ("15 pagos al mes", "Activo", "Varchar"),
("25 pagos al mes", "Activo", "Varchar"),
("35 pagos al mes", "Activo", "Varchar");
select * from planfeatures

insert into featuresPerPlans (planFeaturesid, subscriptionsid, value, enabled)
values (1,1, "Varchar",1),
(2,2, "Varchar",1),
(3,3, "Varchar",1);
select * from featuresPerPlans

insert into planPrices (subscriptionsid, monedaid, amount, recurrencyType, postTime, endDate, current)
values (1,1,80000.00,1,"00:00:00","2025-12-12",1),
	   (2,1,70000.00,1,"00:00:00","2025-12-12",1),
       (3,1,90000.00,1,"00:00:00","2025-12-12",1);
select * from planPrices

insert into schedules (name, recoveryType, endType, repetitions, endDate)
values ("Mensualidad",1,1,99,NULL);
select * from schedules


DROP PROCEDURE IF EXISTS LlenarPlanes;
DELIMITER //

CREATE PROCEDURE LlenarPlanes()
BEGIN
	set @countUsers = 45;
	while @countUsers > 0 do

		set @price = FLOOR(1 + (RAND() * 3));
		set @date = DATE_ADD('2024-01-01', interval FLOOR(RAND() * 365) day);
		
        insert into planPerPerson (planPricesid, userid, schedulesid, aquiredDate, enabled)
        values (@price, @countUsers, 1, @date, 1);
        
		set @countUsers = @countUsers - 1;
    
    end while;
END //

call LlenarPlanes();
select * from planPerPerson



-- Consultas: ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Consulta 1
select 
	payment_users.userid,
    CONCAT(payment_users.firstName, ' ', payment_users.lastName) AS NombreCompleto, 
    payment_users.email AS Correo, 
    payment_users.country AS País,
    (TIMESTAMPDIFF(MONTH, planPerPerson.aquiredDate, CURDATE()) + 1) * planPrices.amount AS TotalPagado
from payment_users
join planPerPerson ON payment_users.userid = planPerPerson.userid
join planPrices ON planPerPerson.planPricesid = planPrices.planPricesid
where planPerPerson.enabled = 1 

-- Consulta 2
select 
    planPerPerson.userid,
    CONCAT(payment_users.firstName, ' ', payment_users.lastName) AS NombreCompleto,
    payment_users.email AS Correo
from planPerPerson
join payment_users ON planPerPerson.userid = payment_users.userid
where DATEDIFF(
        LAST_DAY(CURDATE()), 
        DATE_FORMAT(CONCAT(YEAR(CURDATE()), '-', MONTH(CURDATE()), '-', DAY(planPerPerson.aquiredDate)), '%Y-%m-%d')) < 15;
        
-- Consulta 3: Mayor a menor
select 
    payment_users.userid, 
    CONCAT(payment_users.firstName, ' ', payment_users.lastName) AS Nombre, 
    COUNT(transacciones.idTransaciones) AS TransaccionesTotales
from payment_users
join transacciones ON payment_users.userid = transacciones.userid
group by payment_users.userid order by TransaccionesTotales DESC
limit 15;


-- Consulta 3: Menor a mayor
select 
    payment_users.userid, 
    CONCAT(payment_users.firstName, ' ', payment_users.lastName) AS Nombre, 
    COUNT(transacciones.idTransaciones) AS TransaccionesTotales
from payment_users
join transacciones ON payment_users.userid = transacciones.userid
group by payment_users.userid order by TransaccionesTotales ASC
limit 15;

  
-- Consulta 4
select interaction.error AS TipoError, COUNT(*) AS Frecuencia
from interaction
join dataPerInteraction
    ON interaction.interactionid = dataPerInteraction.interactionid
join conversation
    ON interaction.conversationid = conversation.queryid
where conversation.prompttime between '2025-03-13 00:00:00' AND '2025-03-30 00:00:00'
group by interaction.error order by Frecuencia DESC;
        
        