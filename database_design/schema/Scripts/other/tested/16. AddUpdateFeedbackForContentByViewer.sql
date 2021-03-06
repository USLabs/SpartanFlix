use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_update_feedback_for_content_by_viewer;
delimiter //
create procedure prc_add_update_feedback_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in comments text)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if exists (select comment from Feedback where viewerId = viewer_id and contentId = content_id) then
		update Feedback
		set comment = comments
		where contentId = content_id and viewerId = viewer_id;
	else
		insert into FeedBack  values (viewer_id, content_id, comments);
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //