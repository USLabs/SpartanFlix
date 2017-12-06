use CMPE226_SPARTAN_FLIX;
drop procedure if exists prc_get_rating_for_content;
delimiter //
create procedure prc_get_rating_for_content(in content_id bigint unsigned)
begin
	select avg(ratings) as avgRating from Watches where contentId = content_id;
end //

-- added as avgRating