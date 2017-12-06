use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_advertiser;
delimiter //
create procedure prc_sign_up_advertiser
	(in id INT UNSIGNED,
	in _email VARCHAR(128),
	in fname VARCHAR(64),
	in lname VARCHAR(64),
	in pass_word VARCHAR(64),
	in subscriptionId TINYINT UNSIGNED)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_email is null or fname is null or lname is null or pass_word is null or startDate is null or subscriptionId is null) then
		insert into Advertiser values (null,_email,fname,lname, aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))),subscriptionId);
        select id, email, fname, lname, subscriptionId from Advertiser where email = _email;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

-- not working