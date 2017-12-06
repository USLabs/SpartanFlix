use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_change_subscription_for_advertiser;
drop procedure if exists prc_get_content_for_viewer;
drop procedure if exists prc_get_all_content_subscriptions;
drop procedure if exists prc_get_content_by_id;
drop procedure if exists prc_sign_in_viewer;
drop procedure if exists prc_sign_in_advertiser;
drop procedure if exists prc_sign_up_viewer;
drop procedure if exists prc_sign_up_advertiser;
drop procedure if exists prc_get_current_subscription_for_viewer;
drop procedure if exists prc_get_favorites_for_viewer;
drop procedure if exists prc_get_history_for_viewer;
drop procedure if exists prc_all_feedbacks_for_content;
drop procedure if exists prc_add_update_feedback_for_content_by_viewer;
drop procedure if exists prc_get_rating_for_content;
drop procedure if exists prc_add_update_rating_for_content_by_viewer;
drop procedure if exists prc_get_ad_to_show;
drop procedure if exists prc_get_all_content_and_ads_for_admin;
drop procedure if exists prc_approve_disapprove_items_by_admin;
drop procedure if exists prc_get_content_for_content_provider;
drop procedure if exists prc_delete_content_by_content_provider;
drop procedure if exists prc_get_ads_for_advertiser;
drop procedure if exists prc_add_ad_for_advertiser;
drop procedure if exists prc_remove_ad_for_advertiser;
drop procedure if exists prc_get_all_ads_subscriptions;
drop procedure if exists prc_get_current_subscription_for_advertiser;
drop procedure if exists prc_add_favorites_for_viewer;
drop procedure if exists prc_sign_in_content_provider;
drop procedure if exists prc_sign_in_admin;
drop procedure if exists prc_sign_up_content_provider;
drop procedure if exists prc_change_subscription_for_viewer;

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

use CMPE226_SPARTAN_FLIX;
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
    
    select A.id, 
    A.isApproved, 
    A.title, 
    A.description, 
    A.director, 
    A.ContentTypeId, 
    A.contentType, 
    A.contentProviderName,
    B.actors from CONTENT_VIEW A
    join ACTORS_VIEW B
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

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_all_content_subscriptions() 
begin
	select * from ContentSubscription;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_content_by_id(content_id bigint unsigned) 
begin
    select * from Content where id = content_id;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_in_viewer(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	declare temp TINYINT UNSIGNED;
    set temp = (select subscriptionId from Viewer where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512))));
	
    select coalesce(A.id, 0) as id, A.email, A.fname, A.lname, A.startDate, A.subscriptionId, B.name as type from Viewer A
    join (select * from Includes A join ContentType B where A.contentTypeId = B.id and A.contentSubscriptionId = temp) B
    on A.subscriptionId = B.contentSubscriptionId
    where A.email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_in_advertiser(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	select coalesce(id, 0) as id, email, fname, lname, subscriptionId from Advertiser where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_up_viewer
	(in _email_id VARCHAR(128),
	in _fname VARCHAR(64),
	in _lname VARCHAR(64),
	in _pass_word VARCHAR(64),
    in _startDate DATETIME ,
	in _mainSubscriberId INT UNSIGNED,
    in _subscriptionId TINYINT UNSIGNED,
    in _dependent_email_id VARCHAR(128))
begin
	declare _parent_id int unsigned;
	declare temp TINYINT UNSIGNED;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_email_id is null or _fname is null or _lname is null or _pass_word is null or _startDate is null or _subscriptionId is null) and not exists (select * from Viewer where email = _email_id) then	    
        SELECT * FROM Viewer;
        
        insert into Viewer values (null, _email_id, _fname, _lname, aes_encrypt(_pass_word, UNHEX(SHA2('pass_key',512))), _startDate, 0, _subscriptionId);
        
        set _parent_id = (select id from Viewer where email = _email_id);
		insert into Viewer values (null, _dependent_email_id, 'John', 'Doe', aes_encrypt('dependent123', UNHEX(SHA2('pass_key',512))), _startDate, _parent_id, _subscriptionId);
		
        SELECT * FROM Viewer;
        
        select *, coalesce(_parent_id, 0) as id, 
        _email_id, _fname, _lname, _startDate, _subscriptionId 
        from Includes A join ContentType B
        on A.contentTypeId = B.id
        where contentSubscriptionId = _subscriptionId;
		
        
		#select coalesce(A.id, 0) as id, A.email, A.fname, A.lname, A.startDate, A.subscriptionId, B.name as type from Viewer A
		#join (select * from Includes A join ContentType B where A.contentTypeId = B.id and A.contentSubscriptionId = subscriptionId) B
		#on A.subscriptionId = B.contentSubscriptionId
		#where A.email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
    
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_up_advertiser
	(in _id INT UNSIGNED,
	in _email VARCHAR(128),
	in _fname VARCHAR(64),
	in _lname VARCHAR(64),
	in _pass_word VARCHAR(64),
    in _startDate DATETIME ,
	in _subscriptionId TINYINT UNSIGNED)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_email is null or _fname is null or _lname is null or _pass_word is null or _startDate is null or _subscriptionId is null) then
		insert into Advertiser values (null, _email, _fname, _lname, aes_encrypt(_pass_word, UNHEX(SHA2('pass_key',512))), _subscriptionId);
        select _id, _email, _fname, _lname, _subscriptionId from Advertiser where email = _email;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_current_subscription_for_viewer(in viewer_id int unsigned) 
begin
	select * from ContentSubscription;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_favorites_for_viewer(in viewer_id int unsigned) 
begin
	select * from Content where id in (select contentId from Favorites where viewerId = viewer_id);
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_history_for_viewer (in viewer_id int unsigned) 
begin
	select * from Content where id in (select contentId from Watches where viewerId = viewer_id);
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_all_feedbacks_for_content(in content_id bigint unsigned)
begin
	select * from Feedback where contentId = content_id;
end //

use CMPE226_SPARTAN_FLIX;
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

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_rating_for_content(in content_id bigint unsigned)
begin
	select avg(ratings) from Watches where contentId = content_id;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_add_update_rating_for_content_by_viewer(in content_id bigint unsigned, in viewer_id int unsigned, in my_rating tinyint)
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if exists (select ratings from Watches where viewerId = viewer_id and contentId = content_id) then
		update Watches 
		set ratings = my_rating
		where viewerId = viewer_id and contentId = content_id;
	else
		insert into Watches values (viewer_id, content_id, now(), ratings);
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

use CMPE226_SPARTAN_FLIX;
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

use CMPE226_SPARTAN_FLIX;
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

use CMPE226_SPARTAN_FLIX;
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

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_content_for_content_provider(in content_provider_id int unsigned, in _search VARCHAR(128), in _title VARCHAR(128))
begin
	declare titleT VARCHAR(128);
    declare searchT VARCHAR(128);
    set searchT = coalesce(_search, '');
    set titleT = coalesce(_title, '');
    select A.id, A.isApproved, A.director, A.title, A.description, A.contentTypeId, B.name  from Content A join ContentType B 
    on A.contentProviderId = B.id where contentProviderId = content_provider_id and 
    title like concat('%', titleT, '%') and description like concat('%', searchT, '%');
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_delete_content_by_content_provider(in content_id bigint unsigned)
begin
	delete from Content where id = content_id;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_ads_for_advertiser(in advertiser_id int unsigned, in _search VARCHAR(128), in _title VARCHAR(128))
begin
	declare searchT varchar(128);
    declare titleT varchar(128);
    set searchT = coalesce(_search, '');
    set titleT = coalesce(_title, '');
	select advertisementId, title, description, concat(fname, ' ', lname) as advertiser from ADVERTISEMENT_VIEW 
    where advertiserId = advertiser_id and description like concat('%', searchT, '%') and title like concat('%', titleT, '%');
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_add_ad_for_advertiser(in _advertiserId int unsigned, in _title varchar(128), in _description varchar(256))
begin
	insert into Advertisement values (null, '0', _advertiserId, _title, _description);
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_remove_ad_for_advertiser(in advertisement_id int unsigned)
begin
	delete from Advertisement where id = advertisement_id;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_all_ads_subscriptions() 
begin
	select * from AdSubscription;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_get_current_subscription_for_advertiser(in advertiser_id int unsigned) 
begin
	select * from AdSubscription where id =  (select subscriptionId from Advertiser where id = advertiser_id);
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_add_favorites_for_viewer(in viewer_id int unsigned, in content_id bigint unsigned) 
begin
	insert into Favorites values (viewer_id, content_id);
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_in_content_provider(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	select coalesce(id, 0) as id, email, name from ContentProvider where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_sign_in_admin(in email_id VARCHAR(128), in pass_word VARCHAR(64)) 
begin
	select coalesce(id, 0) as id, email, fname, lname from Admin where email = email_id and password = aes_encrypt(pass_word, UNHEX(SHA2('pass_key',512)));
end //

use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_sign_up_content_provider;
delimiter //
create procedure prc_sign_up_content_provider(in _emailId VARCHAR(128), in _password VARCHAR(64),in _cpname VARCHAR(128))
begin
	declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	if not(_emailId is null or _password is null or _password is null or _cpname is null) then
		if not exists (select * from ContentProvider where email = _emailId) then
			insert into ContentProvider values (null, _emailId, _cpname, aes_encrypt(_password, UNHEX(SHA2('pass_key',512))));
            select id, email, name from ContentProvider where email = _emailId;
		end if;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //

use CMPE226_SPARTAN_FLIX;
delimiter //
create procedure prc_change_subscription_for_viewer(in viewer_id int unsigned, subscription_id int unsigned) 
begin
	declare parent_id int unsigned;
    declare `_rollback` bool default 0;
    declare continue handler for sqlexception set `_rollback` = 1;
    start transaction;
	set parent_id = (select coalesce(mainSubscriberId, 0) from Viewer where id = viewer_id);
	if (parent_id = 0 or parent_id = viewer_id) then
		update Viewer
		set subscriptionId = subscription_id where id = viewer_id;
        
		update Viewer
		set subscriptionId = subscription_id where mainSubscriberId = parent_id;
	else
        update Viewer
		set subscriptionId = subscription_id, mainSubscriberId = 0 where id = viewer_id;
	end if;
    if `_rollback` then
        rollback;
    else
        commit;
    end if;
end //