use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_all_content_subscriptions;
delimiter //
create procedure prc_get_all_content_subscriptions() 
begin
	select A.id, A.price, A.duration, A.hasAd, group_concat(C.name separator ',') type
	from ContentSubscription A 
	join Includes B 
	join ContentType C
	on A.id = B.contentSubscriptionId 
	and B.contentTypeId = C.id
	group by A.id, A.price, A.duration, A.hasAd;
end //