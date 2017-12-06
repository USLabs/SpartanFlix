use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_ad_for_advertiser;
delimiter //
create procedure prc_add_ad_for_advertiser(in _advertiserId int unsigned, in _title varchar(128), in _description varchar(256))
begin
	insert into Advertisement values (null, '0', _advertiserId, _title, _description);
end //