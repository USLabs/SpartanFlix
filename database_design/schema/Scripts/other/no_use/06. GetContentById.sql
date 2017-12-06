use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_content_by_id;
delimiter //
create procedure prc_get_content_by_id(content_id bigint unsigned) 
begin
    select * from Content where id = content_id;
end //

-- no use, information returned at other place