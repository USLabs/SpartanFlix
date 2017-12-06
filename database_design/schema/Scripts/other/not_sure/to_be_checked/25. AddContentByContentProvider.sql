use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_content_by_content_provider;
delimiter //
create procedure prc_add_content_by_content_provider(in _director VARCHAR(128), in content_provider_id int unsigned, content_type_name varchar(128))
begin
	declare content_type_id tinyint unsigned;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	set content_type_id = (select id from ContentType where name = content_type_name);
	insert into Content values (null, 0, _director, content_provider_id, content_type_id);
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

-- record is not inserted into table