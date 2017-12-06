use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_update_rating_for_content_by_viewer;
delimiter //
create procedure prc_add_update_rating_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in my_rating tinyint)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if exists (select ratings from Watches where viewerId = viewer_id and contentId = content_id) then
		update Watches 
		set ratings = my_rating
		where viewerId = viewer_id and contentId = content_id;
	else
		insert into Watches values (viewer_id, content_id, now(), ratings);
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

-- not updating rating