use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_to_history_for_viewer;
delimiter //
create procedure prc_add_to_history_for_viewer (in _viewerId int unsigned, in _contentId bigint unsigned, in _rating tinyint) 
begin
	if not exists (select * from Watches where viewerId = _viewerId and contentId = _contentId) then
		insert into Watches (viewerId, contentId, ratings) values (_viewerId , _contentId, _rating);
	else
    update Watches
		set ratings = _rating where viewerId = _viewerId and contentId = _contentId;
    end if;
end //