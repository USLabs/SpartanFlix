use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_current_subscription_for_viewer;
delimiter //
create procedure prc_get_current_subscription_for_viewer(in viewer_id int unsigned) 
begin
	select * from ContentSubscription;
end //