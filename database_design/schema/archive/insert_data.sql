USE CMPE226_SPARTAN_FLIX;


insert into ContentSubscription values (null,'29.99', '30', '1');
insert into ContentSubscription values (null,'24.99', '30', '0');
insert into ContentSubscription  values (null,'49.99', '60', '1');
insert into ContentSubscription values (null,'44.99', '60', '0');

insert into ContentType values (null,'movies');
insert into ContentType values (null,'documentry');
insert into ContentType values (null,'series');


insert into ContentProvider values(null,'sony@gmail.com','Sony','sony123#');
insert into ContentProvider values(null,'disney@gmail.com','Disney','sony123#');
insert into ContentProvider values(null,'paramount@gmail.com','Paramount','sony123#');
insert into ContentProvider values(null,'wb@gmail.com','Warner Bors','sony123#');


insert into Content values (null,'1', 'Mel Brooks','1','1');
insert into Content values (null,'1', 'Harold Ramis','1','2');
insert into Content values (null,'1', 'Kevin Smith','1','2');
insert into Content values (null,'1', 'Billy Wilder','1','3');
insert into Content values (null,'0', 'Mel Brooks','1','3');

insert into Content values (null,'1', 'Mel Brooks','2','1');
insert into Content values (null,'1', 'Harold Ramis','2','2');
insert into Content values (null,'1', 'Kevin Smith','2','3');
insert into Content values (null,'1', 'Billy Wilder','2','3');
insert into Content values (null,'0', 'Mel Brooks','2','3');

insert into Content values (null,'1', 'David Crane','3','3');
insert into Content values (null,'1', 'Vince Gilligan','3','2');
insert into Content values (null,'1', 'Paul S','3','3');
insert into Content values (null,'1', 'Billy Wilder','3','3');
insert into Content values (null,'0', 'Mel Brooks','3','3');


insert into Actor values (null,'Robert','Downey');
insert into Actor values (null,'Johnny','Depp');
insert into Actor values (null,'Leonardo','DiCaprio');
insert into Actor values (null,'Mark','Wahlberg');
insert into Actor values (null,'Jennifer','Lawrence');
insert into Actor values (null,'Julia','Roberts');
insert into Actor values (null,'Charlize','Theron');

insert into Cast values('1','1');
insert into Cast  values('2','1');
insert into Cast values('3','1');
insert into Cast  values('4','1');
insert into Cast values('5','1');
insert into Cast values('6','1');
insert into Cast values('7','1');

insert into Cast values('1','2');
insert into Cast  values('2','2');
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
insert into Includes values ('3','2');
insert into Includes values ('3','3');
insert into Includes values ('3','4');

insert into AdSubscription values (null,'29.99', '30');
insert into AdSubscription values (null,'24.99', '30');
insert into AdSubscription values (null,'49.99', '60');
insert into AdSubscription values (null,'44.99', '60');


insert into Advertiser values (null,'advertiser1@gmail.com','advertiserOne','advertiserOne','advertiser100','1');
insert into Advertiser values (null,'advertiser2@gmail.com','advertiserTwo','advertiser202','advertiser200','2');
insert into Advertiser values (null,'advertiser3@gmail.com','advertiser3','advertiser303','advertiser300','3');
insert into Advertiser values (null,'advertiser4@gmail.com','advertiser4','advertiser404','advertiser400','4');
insert into Advertiser values (null,'advertiser5@gmail.com','advertiser5','advertiser505','advertiser500','1');
insert into Advertiser values (null,'advertiser6@gmail.com','advertiser6','advertiser606','advertiser600','2');
insert into Advertiser values (null,'advertiser7@gmail.com','advertiser7','advertiser707','advertiser700','3');


insert into Advertisement values (null,'1','1');
insert into Advertisement values (null,'1','2');
insert into Advertisement values (null,'1','3');
insert into Advertisement values (null,'1','1');
insert into Advertisement values (null,'1','3');
insert into Advertisement values (null,'1','2');
insert into Advertisement values (null,'1','3');
insert into Advertisement values (null,'0','3');
insert into Advertisement values (null,'0','2');
insert into Advertisement values (null,'0','1');



insert into Viewer values (null,'afreen@gmail.com','Afreen','Patel','afreen123#','2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'bo@gmail.com','Bo','Liu','bo123#','2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'umang@gmail.com','Umang','Saxena','umang123#','2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'rushikesh@gmail.com','Rushikesh','Pawar','rushikesh123#','2017-01-01 09:10:40','1','1');
insert into Viewer values (null,'shruti@gmail.com','Shruti','Padmanabhan','shruti123#','2017-01-01 09:10:40','1','1');



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


insert into Admin  values (null,'admin@spartanflix.com','admin','admin','admin');
