use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_ads_for_advertiser;
delimiter //
create procedure prc_get_ads_for_advertiser(in advertiser_id int unsigned, in _search VARCHAR(128), in _title VARCHAR(128))
begin
	declare searchT varchar(128);
    declare titleT varchar(128);
    set searchT = coalesce(_search, '');
    set titleT = coalesce(_title, '');
    
    if searchT = 'null' then
		set searchT = '';
    end if;
    if titleT= 'null' then
		set titleT = '';
    end if;
    
	select advertisementId, isApproved, title, description, concat(fname, ' ', lname) as advertiser from ADVERTISEMENT_VIEW 
    where advertiserId = advertiser_id and description like concat('%', searchT, '%') and title like concat('%', titleT, '%');
end //