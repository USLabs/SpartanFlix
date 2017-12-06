use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_content_provider;
delimiter //
create procedure prc_sign_up_content_provider(in email_id VARCHAR(128), in pass_word VARCHAR(64),in cpname VARCHAR(128))
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(email_id is null or pass_word is null or lname is null or pass_word is null or cpname is null) then
		if not exists (select * from ContentProvider where email = email_id) then
			insert into ContentProvider values (null, email_id, cpname, aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))));
            select id, email, name from ContentProvider where email = email_id;
		end if;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

-- not inserting data into ContentProvider table