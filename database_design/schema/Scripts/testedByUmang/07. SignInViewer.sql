use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_in_viewer;
delimiter //
create procedure prc_sign_in_viewer(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	declare temp TINYINT UNSIGNED;
    set temp = (select subscriptionId from Viewer where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))));
	
    select coalesce(A.id, 0) as id, A.email, A.fname, A.lname, A.startDate, A.subscriptionId, B.name as type from Viewer A
    join (select * from Includes A join ContentType B where A.contentTypeId = B.id and A.contentSubscriptionId = temp) B
    on A.subscriptionId = B.contentSubscriptionId
    where A.email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //