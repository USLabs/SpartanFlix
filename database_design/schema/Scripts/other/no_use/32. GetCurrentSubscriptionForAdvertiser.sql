use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_current_subscription_for_advertiser;
delimiter //
create procedure prc_get_current_subscription_for_advertiser(in advertiser_id int unsigned) 
begin
	select * from AdSubscription where id =  (select subscriptionId from Advertiser where id = advertiser_id);
end //

-- not necessary, subscriptionId is return at login time