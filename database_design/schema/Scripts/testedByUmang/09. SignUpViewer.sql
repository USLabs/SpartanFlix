use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_viewer;
delimiter //
create procedure prc_sign_up_viewer
	(in _email_id VARCHAR(128),
	in _fname VARCHAR(64),
	in _lname VARCHAR(64),
	in _pass_word VARCHAR(64),
    in _startDate DATETIME ,
	in _mainSubscriberId INT UNSIGNED,
    in _subscriptionId TINYINT UNSIGNED,
    in _dependent_email_id VARCHAR(128))
begin
	declare _parent_id int unsigned;
	declare temp TINYINT UNSIGNED;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
    if not(_email_id is null or _fname is null or _lname is null or _pass_word is null or _startDate is null or _subscriptionId is null) and not exists (select * from Viewer where email = _email_id) then	    
        insert into Viewer values (null, _email_id, _fname, _lname, aes_encrypt(_pass_word, UNHEX(SHA2('pass_key',512))), _startDate, null, _subscriptionId);
        if _dependent_email_id = 'null' then
			set _dependent_email_id = null;
		end if;
		if _dependent_email_id is not null then
			set _parent_id = (select id from Viewer where email = _email_id);
			insert into Viewer values (null, _dependent_email_id, 'John', 'Doe', aes_encrypt('dependent123', UNHEX(SHA2('pass_key',512))), _startDate, _parent_id, _subscriptionId);
        end if;
        select *, coalesce(_parent_id, 0) as id, 
        _email_id, _fname, _lname, _startDate, _subscriptionId 
        from Includes A join ContentType B
        on A.contentTypeId = B.id
        where contentSubscriptionId = _subscriptionId;
		
        
		#select coalesce(A.id, 0) as id, A.email, A.fname, A.lname, A.startDate, A.subscriptionId, B.name as type from Viewer A
		#join (select * from Includes A join ContentType B where A.contentTypeId = B.id and A.contentSubscriptionId = subscriptionId) B
		#on A.subscriptionId = B.contentSubscriptionId
		#where A.email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
    
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //