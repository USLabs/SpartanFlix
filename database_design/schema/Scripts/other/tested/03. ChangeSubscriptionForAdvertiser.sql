use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_change_subscription_for_advertiser;
delimiter //
create procedure prc_change_subscription_for_advertiser(in advertiser_id int unsigned, subscription_id tinyint unsigned) 
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	update Advertiser
		set subscriptionId = subscription_id where id = advertiser_id;
	if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

