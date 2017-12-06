use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_favorites_for_viewer;
delimiter //
create procedure prc_add_favorites_for_viewer(in viewer_id int unsigned, in content_id bigint unsigned) 
begin
	insert into Favorites values (viewer_id, content_id);
end //