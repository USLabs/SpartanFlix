use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_all_content_subscriptions;
delimiter //
create procedure prc_get_all_content_subscriptions() 
begin
	select * from ContentSubscription;
end //