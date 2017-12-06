use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_content_for_content_provider;
delimiter //
create procedure prc_get_content_for_content_provider(in content_provider_id int unsigned, in _search VARCHAR(128), in _title VARCHAR(128))
begin
	declare titleT VARCHAR(128);
    declare searchT VARCHAR(128);
    set searchT = coalesce(_search, '');
    set titleT = coalesce(_title, '');
    select * from Content where contentProviderId = content_provider_id and 
    title like concat('%', titleT, '%') and description like concat('%', searchT, '%');
end //