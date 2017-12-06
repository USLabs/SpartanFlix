use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_ad_to_show;
delimiter //
create procedure prc_get_ad_to_show(in viewer_id int unsigned)
begin
	declare s_id, has_Ad tinyint unsigned default 0;
    declare random int unsigned default 0;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	set s_id = (select subscriptionId from Viewer where id = viewer_id);
    set has_Ad = (select hasAd from ContentSubscription where id = s_id);
    if (has_Ad = 1) then
        set random = (SELECT ceil(rand() * (select max(id) from Advertisement)));
        select id, advertiserId, title, description, abs(id/-1 + random) as delta
		from Advertisement where isApproved = 1 order by delta limit 1;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //