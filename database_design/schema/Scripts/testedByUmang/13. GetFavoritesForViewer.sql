use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_favorites_for_viewer();
delimiter //
create procedure prc_add_favorites_for_viewer(in viewer_id int unsigned, in _contentId bigint unsigned) 
begin
	select * from Favorites where viewerId in (select contentId from Favorites where viewerId = viewer_id);
end //