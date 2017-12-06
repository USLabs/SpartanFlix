use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_advertiser;
delimiter //
create procedure prc_sign_up_advertiser
	(in _email VARCHAR(128),
	in _fname VARCHAR(64),
	in _lname VARCHAR(64),
	in _pass_word VARCHAR(64),
    in _startDate DATETIME ,
	in _subscriptionId TINYINT UNSIGNED)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_email is null or _fname is null or _lname is null or _pass_word is null or _startDate is null or _subscriptionId is null) then
		insert into Advertiser values (null, _email, _fname, _lname, aes_encrypt(_pass_word, UNHEX(SHA2('pass_key',512))), _subscriptionId);
        select id, _email, _fname, _lname, _subscriptionId from Advertiser where email = _email;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //