use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_favorites_for_viewer;
delimiter //
create procedure prc_add_favorites_for_viewer(in _viewerId int unsigned, in _contentId bigint unsigned) 
begin
	if not exists (select * from Favorites where viewerId = _viewerId and contentId = _contentId) then
		insert into Favorites values (_viewerId , _contentId);
    end if;
end //