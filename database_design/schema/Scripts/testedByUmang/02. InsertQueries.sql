USE CMPE226_SPARTAN_FLIX;
insert into ContentSubscription values (null,'29.99', '30', '1');
insert into ContentSubscription values (null,'24.99', '30', '0');
insert into ContentSubscription  values (null,'49.99', '60', '1');
insert into ContentSubscription values (null,'44.99', '60', '0');

insert into ContentType values (null,'movies');
insert into ContentType values (null,'documentry');
insert into ContentType values (null,'series');


insert into ContentProvider values(null,'sony@gmail.com','Sony', aes_encrypt('sony123#', UNHEX(SHA2('pass_key',512))));
insert into ContentProvider values(null,'disney@gmail.com','Disney', aes_encrypt('sony123#', UNHEX(SHA2('pass_key',512))));
insert into ContentProvider values(null,'paramount@gmail.com','Paramount', aes_encrypt('sony123#', UNHEX(SHA2('pass_key',512))));
insert into ContentProvider values(null,'wb@gmail.com','Warner Bors', aes_encrypt('sony123#', UNHEX(SHA2('pass_key',512))));


insert into Content values (null,'1', 'Mel Brooks','1','1','title1','description1');
insert into Content values (null,'1', 'Harold Ramis','1','2','title2','description2');
insert into Content values (null,'1', 'Kevin Smith','1','2','title3','description3');
insert into Content values (null,'1', 'Billy Wilder','1','3','title4','description4');
insert into Content values (null,'0', 'Mel Brooks','1','3','title55','description55');

insert into Content values (null,'1', 'Mel Brooks','2','1','title5','description5');
insert into Content values (null,'1', 'Harold Ramis','2','2','title6','description6');
insert into Content values (null,'1', 'Kevin Smith','2','3','title7','description7');
insert into Content values (null,'1', 'Billy Wilder','2','3','title8','description8');
insert into Content values (null,'0', 'Mel Brooks','2','3','title9','description9');

insert into Content values (null,'1', 'David Crane','3','3','title10','description10');
insert into Content values (null,'1', 'Vince Gilligan','3','2','title11','description11');
insert into Content values (null,'1', 'Paul S','3','3','title12','description12');
insert into Content values (null,'1', 'Billy Wilder','3','3','title13','description13');
insert into Content values (null,'0', 'Mel Brooks','3','3','title14','description14');


insert into Actor values (null,'Robert','Downey');
insert into Actor values (null,'Johnny','Depp');
insert into Actor values (null,'Leonardo','DiCaprio');
insert into Actor values (null,'Mark','Wahlberg');
insert into Actor values (null,'Jennifer','Lawrence');
insert into Actor values (null,'Julia','Roberts');
insert into Actor values (null,'Charlize','Theron');

insert into Cast values('1','1');
insert into Cast values('2','1');
insert into Cast values('3','1');
insert into Cast values('4','1');
insert into Cast values('5','1');
insert into Cast values('6','1');
insert into Cast values('7','1');

insert into Cast values('1','2');
insert into Cast values('2','2');
insert into Cast values('3','2');
insert into Cast values('4','2');

insert into Cast values('1','3');
insert into Cast values('2','3');
insert into Cast values('3','3');
insert into Cast values('4','3');
insert into Cast values('5','3');
insert into Cast values('6','3');
insert into Cast values('7','3');


insert into Includes values ('1','1');
insert into Includes values ('1','2');
insert into Includes values ('1','3');
insert into Includes values ('1','4');

insert into Includes values ('2','1');
insert into Includes values ('2','2');
insert into Includes values ('2','3');
insert into Includes values ('2','4');
insert into Includes values ('3','1');


insert into AdSubscription values (1,'29.99', '30');
insert into AdSubscription values (2,'24.99', '30');
insert into AdSubscription values (3,'49.99', '60');
insert into AdSubscription values (4,'44.99', '60');

insert into Advertiser values (null,'advertiser1@gmail.com','advertiser1','advertiser101',aes_encrypt('advertiser100', UNHEX(SHA2('pass_key',512))),'1');
insert into Advertiser values (null,'advertiser2@gmail.com','advertiser2','advertiser202',aes_encrypt('advertiser200', UNHEX(SHA2('pass_key',512))),'2');
insert into Advertiser values (null,'advertiser3@gmail.com','advertiser3','advertiser303',aes_encrypt('advertiser300', UNHEX(SHA2('pass_key',512))),'3');
insert into Advertiser values (null,'advertiser4@gmail.com','advertiser4','advertiser404',aes_encrypt('advertiser400', UNHEX(SHA2('pass_key',512))),'4');
insert into Advertiser values (null,'advertiser5@gmail.com','advertiser5','advertiser505',aes_encrypt('advertiser500', UNHEX(SHA2('pass_key',512))),'1');
insert into Advertiser values (null,'advertiser6@gmail.com','advertiser6','advertiser606',aes_encrypt('advertiser600', UNHEX(SHA2('pass_key',512))),'2');
insert into Advertiser values (null,'advertiser7@gmail.com','advertiser7','advertiser707',aes_encrypt('advertiser700', UNHEX(SHA2('pass_key',512))),'3');


insert into Advertisement values (null,'1','1','title1','description1');
insert into Advertisement values (null,'1','2','title2','description2');
insert into Advertisement values (null,'1','3','title3','description3');
insert into Advertisement values (null,'1','1','title4','description4');
insert into Advertisement values (null,'1','3','title5','description5');
insert into Advertisement values (null,'1','2','title6','description6');
insert into Advertisement values (null,'1','3','title7','description7');
insert into Advertisement values (null,'0','3','title8','description8');
insert into Advertisement values (null,'0','2','title9','description9');
insert into Advertisement values (null,'0','1','title10','description10');



insert into Viewer values (null,'afreen@gmail.com','Afreen','Patel', aes_encrypt('afreen123#', UNHEX(SHA2('pass_key',512))),'2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'bo@gmail.com','Bo','Liu',aes_encrypt('bo123#', UNHEX(SHA2('pass_key',512))),'2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'umang@gmail.com','Umang','Saxena',aes_encrypt('umang123#', UNHEX(SHA2('pass_key',512))),'2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'rushikesh@gmail.com','Rushikesh','Pawar',aes_encrypt('rushikesh123#', UNHEX(SHA2('pass_key',512))),'2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'shruti@gmail.com','Shruti','Padmanabhan',aes_encrypt('shruti123#', UNHEX(SHA2('pass_key',512))),'2017-01-01 09:10:40','1','1');



insert into Watches values ('1','1','2017-01-01 09:10:40','4');
insert into Watches values ('2','2','2017-01-01 09:10:40','4');
insert into Watches values ('3','3','2017-01-01 09:10:40','5');
insert into Watches values ('4','4','2017-01-01 09:10:40','3');
insert into Watches values ('5','5','2017-01-01 09:10:40','5');

insert into Watches values ('1','6','2017-01-01 09:10:40','5');
insert into Watches values ('2','7','2017-01-01 09:10:40','2');
insert into Watches values ('3','8','2017-01-01 09:10:40','2');
insert into Watches values ('4','8','2017-01-01 09:10:40','1');
insert into Watches values ('5','9','2017-01-01 09:10:40','1');



insert into Feedback values ('1','1','this is feedback of content 1');
insert into Feedback values ('1','2','this is feedback of content 2');
insert into Feedback values ('1','3','this is feedback of content 3');
insert into Feedback values ('1','4','this is feedback of content 4');
insert into Feedback values ('1','5','this is feedback of content 5');


insert into Favorites values ('1','1');
insert into Favorites values ('1','2');
insert into Favorites values ('1','3');
insert into Favorites values ('2','1');
insert into Favorites values ('3','4');
insert into Favorites values ('4','5');

insert into Admin  values (null,'admin@spartanflix.com','admin','admin', aes_encrypt('admin', UNHEX(SHA2('pass_key',512))));