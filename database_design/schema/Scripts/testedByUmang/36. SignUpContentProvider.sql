use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_content_provider;
delimiter //
create procedure prc_sign_up_content_provider(in _emailId VARCHAR(128), in _password VARCHAR(64),in _cpname VARCHAR(128))
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_emailId is null or _password is null or _password is null or _cpname is null) then
		if not exists (select * from ContentProvider where email = _emailId) then
			insert into ContentProvider values (null, _emailId, _cpname, aes_encrypt(_password, UNHEX(SHA2('pass_key',512))));
            select id, email, name from ContentProvider where email = _emailId;
		end if;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //