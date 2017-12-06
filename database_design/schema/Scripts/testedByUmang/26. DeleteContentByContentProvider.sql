use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_delete_content_by_content_provider;
delimiter //
create procedure prc_delete_content_by_content_provider(in content_id bigint unsigned)
begin
	delete from Content where id = content_id;
end //