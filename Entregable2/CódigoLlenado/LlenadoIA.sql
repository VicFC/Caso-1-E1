use paymentAssistant;

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