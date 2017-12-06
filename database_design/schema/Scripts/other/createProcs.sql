
use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_change_subscription_for_advertiser; -- 03
drop procedure if exists prc_get_content_for_viewer; --
drop procedure if exists prc_get_all_content_subscriptions;
drop procedure if exists prc_sign_in_viewer;
drop procedure if exists prc_get_favorites_for_viewer;
drop procedure if exists prc_get_history_for_viewer;
drop procedure if exists prc_all_feedbacks_for_content;
drop procedure if exists prc_add_update_feedback_for_content_by_viewer;
drop procedure if exists prc_get_rating_for_content;
drop procedure if exists prc_get_all_content_and_ads_for_admin;
drop procedure if exists prc_approve_disapprove_items_by_admin;
drop procedure if exists prc_add_ad_for_advertiser;
drop procedure if exists prc_get_all_ads_subscriptions;
drop procedure if exists prc_add_favorites_for_viewer;
drop procedure if exists prc_sign_in_content_provider;
drop procedure if exists prc_sign_in_admin;
drop procedure if exists prc_sign_in_advertiser;
drop procedure if exists prc_remove_ad_for_advertiser;
drop procedure if exists prc_delete_content_by_content_provider;

-- 03
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


-- 04
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

-- 05
delimiter //
create procedure prc_get_all_content_subscriptions()
begin
	select * from ContentSubscription;
end //

-- 07
delimiter //
create procedure prc_sign_in_viewer(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) as id, email, fname, lname, startDate, subscriptionId from Viewer where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 08
delimiter //
create procedure prc_sign_in_advertiser(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) as id, email, fname, lname, subscriptionId from Advertiser where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 13
delimiter //
create procedure prc_get_favorites_for_viewer(in viewer_id int unsigned)
begin
	select * from Content where id in (select contentId from Favorites where viewerId = viewer_id);
end //

-- 14
delimiter //
create procedure prc_get_history_for_viewer (in viewer_id int unsigned)
begin
	select * from Content where id in (select contentId from Watches where viewerId = viewer_id);
end //

-- 15
delimiter //
create procedure prc_all_feedbacks_for_content(in content_id bigint unsigned)
begin
	select * from Feedback where contentId = content_id;
end //

-- 16
delimiter //
create procedure prc_add_update_feedback_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in comments text)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if exists (select comment from Feedback where viewerId = viewer_id and contentId = content_id) then
		update Feedback
		set comment = comments
		where contentId = content_id and viewerId = viewer_id;
	else
		insert into FeedBack  values (viewer_id, content_id, comments);
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

-- 17
delimiter //
create procedure prc_get_rating_for_content(in content_id bigint unsigned)
begin
	select avg(ratings) as avgRating from Watches where contentId = content_id;
end //

-- added as avgRating

-- 20
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

-- 22
delimiter //
create procedure prc_approve_disapprove_items_by_admin(in item_id int unsigned, in is_approved bool, in _type varchar(128))
begin
	if(_type = 'advertisement') then
		update Advertisement
		set isApproved = is_approved
		where id = item_id;
	else
		update Content
        set isApproved = is_approved
        where id = item_id;
	end if;
end //

-- 29
delimiter //
create procedure prc_add_ad_for_advertiser(in _advertiserId int unsigned, in _title varchar(128), in _description varchar(256))
begin
	insert into Advertisement values (null, '0', _advertiserId, _title, _description);
end //

-- 31
delimiter //
create procedure prc_get_all_ads_subscriptions()
begin
	select * from AdSubscription;
end //

-- 33
delimiter //
create procedure prc_add_favorites_for_viewer(in viewer_id int unsigned, in content_id bigint unsigned)
begin
	insert into Favorites values (viewer_id, content_id);
end //

-- 34
delimiter //
create procedure prc_sign_in_content_provider(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) as id, email, name from ContentProvider where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 35
delimiter //
create procedure prc_sign_in_admin(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) as id, email, fname, lname from Admin where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 30
delimiter //
create procedure prc_remove_ad_for_advertiser(in advertisement_id int unsigned)
begin
	delete from Advertisement where id = advertisement_id;
end //

-- 26
delimiter //
create procedure prc_delete_content_by_content_provider(in content_id bigint unsigned)
begin
	delete from Content where id = content_id;
end //

-- need to verify contentProviderId to make sure only contents belonged to this provider can be deleted
