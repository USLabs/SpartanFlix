use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_in_viewer;
delimiter //
create procedure prc_sign_in_viewer(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	select coalesce(id, 0) as id, email, fname, lname, startDate, subscriptionId from Viewer where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //