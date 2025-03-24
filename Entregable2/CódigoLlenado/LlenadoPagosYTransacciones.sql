use paymentAssistant;

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