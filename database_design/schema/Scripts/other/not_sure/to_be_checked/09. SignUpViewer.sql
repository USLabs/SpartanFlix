use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_viewer;
delimiter //
create procedure prc_sign_up_viewer
	(in email_id VARCHAR(128),
	in fname VARCHAR(64),
	in lname VARCHAR(64),
	in pass_word VARCHAR(64),
    in startDate DATETIME ,
	in mainSubscriberId INT UNSIGNED,
    in subscriptionId TINYINT UNSIGNED,
    in dependent_email_id VARCHAR(128))
begin
	declare parent_id int unsigned;
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(email is null or fname is null or lname is null or pass_word is null or startDate is null or subscriptionId is null) and not exists (select * from Viewer where email = email_id) then
		insert into Viewer values (null, email_id,fname,lname, aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))), startDate, 0, subscriptionId);
		set parent_id = (select id from Viewer where email = email_id);
		insert into Viewer values (null, dependent_email_id, 'John', 'Doe', aes_encrypt('dependent123', UNHEX(SHA2('pass_key',512))), startDate, parent_id, subscriptionId);
		select id, email, fname, lname, startDate, subscriberId from Viewer where email = email_id;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

select * from Viewer

-- does not insert data into viewer table