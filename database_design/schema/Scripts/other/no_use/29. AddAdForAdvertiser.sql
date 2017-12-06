use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_ad_for_advertiser;
delimiter //
create procedure prc_add_ad_for_advertiser(in advertiser_id int unsigned)
begin
	insert into Advertisement values (null, '0', advertiser_id);
end //