use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_approve_disapprove_items_by_admin;
delimiter //
create procedure prc_approve_disapprove_items_by_admin(in item_id int unsigned, in is_approved bool, in _type varchar(128))
begin
	if(_type = 'advertisement') then
		update Advertisement
		set isApproved = is_approved 
		where id = item_id;
	else
		update Content
        set isApproved = is_approved 
        where id = item_id;
	end if;
end //
