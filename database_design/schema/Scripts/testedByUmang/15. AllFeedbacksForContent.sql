use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_all_feedbacks_for_content;
delimiter //
create procedure prc_all_feedbacks_for_content(in content_id bigint unsigned)
begin
	select * from Feedback where contentId = content_id;
end //