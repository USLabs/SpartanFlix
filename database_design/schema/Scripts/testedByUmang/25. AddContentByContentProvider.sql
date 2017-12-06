use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_content_by_content_provider;
delimiter //
create procedure prc_add_content_by_content_provider(in _director VARCHAR(128), in content_provider_id int unsigned, in content_type_name varchar(128), in _title varchar(128), in _description varchar(256), in _actor1fname varchar(128), in _actor1lname varchar(128), in _actor2fname varchar(128), in _actor2lname varchar(128))
begin
	declare content_type_id tinyint unsigned;
    declare _contentId bigint unsigned; 
    declare _actorId1, _actorId2 varchar(128);
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
    if not exists (select * from Actor where fname = _actor1fname and lname = _actor1lname) then
		insert into Actor values (null, _actor1fname, _actor1lname);
	end if;
    if not exists (select * from Actor where fname = _actor2fname and lname = _actor2lname) then
		insert into Actor values (null, _actor2fname, _actor2lname);
	end if;
	set content_type_id = (select id from ContentType where name = content_type_name);
	insert into Content values (null, 0, _director, content_provider_id, content_type_id, _title, _description);
    set _contentId  = LAST_INSERT_ID();
    set _actorId1 = (select id from Actor where fname = _actor1fname and lname = _actor1lname);
    set _actorId2 = (select id from Actor where fname = _actor2fname and lname = _actor2lname);
    
    insert into Cast values (_actorId1, _contentId);
    insert into Cast values (_actorId2, _contentId);
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //