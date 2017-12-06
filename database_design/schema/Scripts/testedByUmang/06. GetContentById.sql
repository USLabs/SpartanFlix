use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_report_content;
delimiter //
create procedure prc_report_content(in _content_id bigint unsigned) 
begin
	update Content 
    set isApproved = 0 where content_id = _content_id;
end //