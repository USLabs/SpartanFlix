use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_history_for_viewer;
delimiter //
create procedure prc_get_history_for_viewer (in viewer_id int unsigned) 
begin
	select * from Content where id in (select contentId from Watches where viewerId = viewer_id);
end //