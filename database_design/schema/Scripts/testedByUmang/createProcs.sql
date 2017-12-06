use CMPE226_SPARTAN_FLIX;
delimiter //
-- 03
drop procedure if exists prc_get_all_ad_subscriptions;

create procedure prc_get_all_ad_subscriptions()
begin
	select * from AdSubscription;
end //

-- 04
drop procedure if exists prc_get_content_for_viewer;
create procedure prc_get_content_for_viewer(in viewer_id int unsigned, in content_type VARCHAR(128), director VARCHAR(128), search VARCHAR(128))
begin
	declare s_id tinyint unsigned default 0;
    declare content_typeT varchar(128);
    declare directorT varchar(128);
    declare searchT varchar(128);
    set content_typeT= coalesce(content_type, '%%');
    set directorT = coalesce(director, '%%');
    set searchT = coalesce(search, '');
	set s_id = (select subscriptionId from Viewer where id = viewer_id);
	select A.id, A.director, B.name as type from Content A
	join
	ContentType B
	on A.contentTypeId = B.id
	where A.ContentTypeId in
	(select contentTypeId from Includes where contentSubscriptionId = 3)
	and A.isApproved = 1 and B.name like content_typeT and A.director like directorT
    and (A.director like concat('%', searchT, '%') or B.name like concat('%', searchT, '%'));
end //

-- 05
drop procedure if exists prc_get_all_content_subscriptions;

create procedure prc_get_all_content_subscriptions()
begin
	select * from ContentSubscription;
end //

-- 06
drop procedure if exists prc_get_content_by_id;

create procedure prc_get_content_by_id(content_id bigint unsigned)
begin
    select * from Content where id = content_id;
end //

-- 07
drop procedure if exists prc_sign_in_viewer;

create procedure prc_sign_in_viewer(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) from Viewer where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 08
use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_in_advertiser;
create procedure prc_sign_in_advertiser(in email_id VARCHAR(128), in pass_word VARCHAR(64))
begin
	select coalesce(id, 0) as id from Advertiser where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

-- 09
drop procedure if exists prc_sign_up_viewer;
create procedure prc_sign_up_viewer
	(in id INT UNSIGNED,
	in email VARCHAR(128),
	in fname VARCHAR(64),
	in lname VARCHAR(64),
	in pass_word VARCHAR(64),
    in startDate DATETIME ,
	in mainSubscriberId INT UNSIGNED,
    in subscriptionId TINYINT UNSIGNED)
begin
	if not(email is null or fname is null or lname is null or pass_word is null or startDate is null or subscriptionId is null) then
		insert into Viewer values (null,email,fname,lname, aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))),startDate,mainSubscriberId,subscriptionId);
	end if;
end //

-- 10
drop procedure if exists prc_sign_up_advertiser;
create procedure prc_sign_up_advertiser
	(in id INT UNSIGNED,
	in email VARCHAR(128),
	in fname VARCHAR(64),
	in lname VARCHAR(64),
	in pass_word VARCHAR(64),
	in subscriptionId TINYINT UNSIGNED)
begin
	if not(email is null or fname is null or lname is null or pass_word is null or subscriptionId is null) then
		insert into Advertiser values (null,email,fname,lname, aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))),subscriptionId);
	end if;
end //

-- 11
drop procedure if exists prc_get_current_subscription_for_viewer;

create procedure prc_get_current_subscription_for_viewer(in viewer_id int unsigned)
begin
	select A.* from ContentSubscription A
    where A.id = (select subscriptionId from Viewer where id = viewer_id);
end //

-- 12
drop procedure if exists prc_get_current_subscription_for_viewer;

create procedure prc_get_current_subscription_for_viewer(in viewer_id int unsigned)
begin
	select A.* from ContentSubscription A
    where A.id = (select subscriptionId from Viewer where id = viewer_id);
end //

-- 13
drop procedure if exists prc_get_favorites_for_viewer;

create procedure prc_get_favorites_for_viewer (in viewer_id int unsigned)
begin
	select * from Content where id in (select contentId from Favorites where viewerId = viewer_id);
end //

-- 14
drop procedure if exists prc_get_history_for_viewer;

create procedure prc_get_history_for_viewer (in viewer_id int unsigned)
begin
	select * from Content where id in (select contentId from Watches where viewerId = viewer_id);
end //

-- 15
drop procedure if exists prc_all_feedbacks_for_content;

create procedure prc_all_feedbacks_for_content(in content_id bigint unsigned)
begin
	select * from Feedback where contentId = content_id;
end //

-- 16
drop procedure if exists prc_add_update_feedback_for_content_by_viewer;

create procedure prc_add_update_feedback_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in comments text)
begin
	if exists (select comment from Feedback where contentId = content_id and viewerId = viewer_id) then
		update Feedback
		set comment = comments
		where contentId = content_id and viewerId = viewer_id;
	else
		insert into FeedBack  values (viewer_id, content_id, comments);
	end if;
end //

-- 17
drop procedure if exists prc_get_rating_for_content;

create procedure prc_get_rating_for_content(in content_id bigint unsigned)
begin
	select avg(ratings) from Watches where contentId = 1;
end //

-- 18
drop procedure if exists prc_add_update_rating_for_content_by_viewer;

create procedure prc_add_update_rating_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in my_rating tinyint)
begin
	if exists (select ratings from Watches where contentId = content_id and viewerId = viewer_id) then
		update Watches
		set ratings = my_rating
		where contentId = content_id and viewerId = viewer_id;
	else
		insert into Watches values (viewer_id, content_id, now(), ratings);
	end if;
end //

-- 19
drop procedure if exists prc_get_ad_to_show;

create procedure prc_get_ad_to_show(in viewer_id int unsigned)
begin
	declare s_id, has_Ad tinyint unsigned default 0;
    declare random int unsigned default 0;
    set s_id = (select subscriptionId from Viewer where id = viewer_id);
    set has_Ad = (select hasAd from ContentSubscription where id = s_id);
    if (has_Ad = 1) then
        set random = (SELECT ceil(rand() * (select max(id) from Advertisement)));
		select top(1) from Advertisement order by abs(id - random);
	end if;
end //

-- 20
drop procedure if exists prc_get_all_content_for_admin;

create procedure prc_get_all_content_for_admin(in admin_id int unsigned)
begin
    if exists (select * from Admin where id = admin_id) then
        select * from Content;
	end if;
end //

-- 21
drop procedure if exists prc_get_all_advertisements_for_admin;

create procedure prc_get_all_advertisements_for_admin(in admin_id int unsigned)
begin
    if exists (select * from Admin where id = admin_id) then
        select * from Advertisement;
	end if;
end //

-- 22
drop procedure if exists prc_approve_disapprove_advertisement_by_admin;

create procedure prc_approve_disapprove_advertisement_by_admin(in advertisement_id int unsigned, is_approved bool)
begin
	update Advertisement
    set isApproved = is_approved
    where id = advertisement_id;
end //

-- 23
drop procedure if exists prc_approve_disapprove_content_by_admin;

create procedure prc_approve_disapprove_content_by_admin(in admin_id int unsigned, in content_id BIGINT UNSIGNED, is_approved BOOL)
begin
    if exists (select * from Admin where id = admin_id) then
        update Content
        set isApproved = is_approved
        where id = content_id;
	end if;
end //

-- 24
drop procedure if exists prc_get_content_for_content_provider;

create procedure prc_get_content_for_content_provider(in content_provider_id int unsigned)
begin
	select * from Content where contentProviderId = content_provider_id;
end //

-- 25
drop procedure if exists prc_get_add_content_by_content_provider;
create procedure prc_get_add_content_by_content_provider(
    in _director VARCHAR(128),
    in content_provider_id int unsigned,
    in content_type_name varchar(128),
    in content_title VARCHAR(128),
    in content_description VARCHAR(256)
    )
begin
	declare content_type_id tinyint unsigned;
    set content_type_id = (select id from ContentType where name = content_type_name);
	insert into Content values (null, 0, _director, content_provider_id, content_type_id, content_title, content_description);
end //

-- 26
drop procedure if exists prc_get_delete_content_by_content_provider;
create procedure prc_get_delete_content_by_content_provider(in content_id bigint unsigned)
begin
	delete from Content where id = content_id;
end //

-- 27
drop procedure if exists prc_update_subscription_for_viewer;

create procedure prc_update_subscription_for_viewer(in viewer_id int unsigned, in subscription_id tinyint unsigned)
begin
	update Viewer
    set subscriptionId = subscription_id,
		startDate = now()
    where id = viewer_id;
end //

-- 28
drop procedure if exists prc_get_ads_for_advertiser;

create procedure prc_get_ads_for_advertiser(advertiser_id int unsigned)
begin
	select * from Advertisement where advertiserId = advertiser_id;
end //

-- 29
use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_add_ad_for_advertiser;
create procedure prc_add_ad_for_advertiser(
    in advertiser_id int unsigned,
    in title varchar(128),
    in description varchar(256)
    )
begin
	insert into Advertisement values (null, '0', advertiser_id, title, description);
end //

-- 30
drop procedure if exists prc_remove_ad_for_advertiser;

create procedure prc_remove_ad_for_advertiser(in advertisement_id int unsigned)
begin
	delete from Advertisement where id = advertisement_id;
end //

-- 31
drop procedure if exists prc_get_all_ads_subscriptions;

create procedure prc_get_all_ads_subscriptions()
begin
	select * from AdSubscription;
end //

-- 32
drop procedure if exists prc_get_current_subscription_for_advertiser;

create procedure prc_get_current_subscription_for_advertiser(in advertiser_id int unsigned)
begin
	select * from AdSubscription where id =  (select AsubscriptionId from Advertiser where id = advertiser_id);
end //


