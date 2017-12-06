use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_content_for_viewer;
delimiter //
create procedure prc_get_content_for_viewer(in viewer_id int unsigned, in content_type VARCHAR(128), director VARCHAR(128), search VARCHAR(128))
begin
	declare s_id tinyint unsigned default 0;
    declare content_typeT varchar(128);
    declare directorT varchar(128);
    declare searchT varchar(128);
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	set content_typeT = coalesce(content_type, '');
    set directorT = coalesce(director, '');
    set searchT = coalesce(search, '');
	set s_id = (select subscriptionId from Viewer where id = viewer_id);
    
    select * from CONTENT_VIEW A
    where A.contentTypeId in 
    (select contentTypeId from Includes where contentSubscriptionId = s_id)
	and A.isApproved = 1 and A.contentType like concat('%', content_typeT, '%') and A.director like concat('%', directorT, '%') 
    and (A.description like concat('%', searchT, '%') or A.contentType like concat('%', searchT, '%'));
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //
