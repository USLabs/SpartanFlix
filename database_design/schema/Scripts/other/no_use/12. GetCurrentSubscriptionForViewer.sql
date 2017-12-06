use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_current_subscription_for_viewer;
delimiter //
create procedure prc_get_current_subscription_for_viewer(in viewer_id int unsigned) 
begin
	select A.* from ContentSubscription A 
    where A.id = (select subscriptionId from Viewer where id = viewer_id);
end //

-- no use, will get it at login time