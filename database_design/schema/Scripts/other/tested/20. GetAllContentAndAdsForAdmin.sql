use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_all_content_and_ads_for_admin;
delimiter //
create procedure prc_get_all_content_and_ads_for_admin(in admin_id int unsigned)
begin
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if exists (select * from Admin where id = admin_id) then
        select id, isApproved, title, description, contentType, contentProviderName as providerName from CONTENT_VIEW
        union all
        select advertisementId as id, isApproved, title, description, 'advertisement' as contentType, CONCAT(fname, ' ', lname) AS providerName from ADVERTISEMENT_VIEW;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //