use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_change_subscription_for_viewer;
delimiter //
create procedure prc_change_subscription_for_viewer(in viewer_id int unsigned, subscriber_id int unsigned) 
begin
	declare parent_id int unsigned;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	select coalesce(mainSubscriberId, 0) from Viewer where id = viewer_id;
	if (parent_id = 0) then
		update Viewer
		set subscriberId = subscription_id where mainSubscriberId = parent_id;
	else
        update Viewer
		set subscriberId = subscription_id and mainSubscriberId = 0 where viewerId = viewer_id;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //