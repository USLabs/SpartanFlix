use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_remove_ad_for_advertiser;
delimiter //
create procedure prc_remove_ad_for_advertiser(in advertisement_id int unsigned)
begin
	delete from Advertisement where id = advertisement_id;
end //

-- need to verify advertiserId
-- solved