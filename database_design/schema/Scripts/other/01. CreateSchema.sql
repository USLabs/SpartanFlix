-- USER.user_id is a 10-digit integer starts with 1 xxx xxx xxx
-- GROUP.group_id is a 10-digit integer starts with 2 xxx xxx xxx
DROP USER IF EXISTS 'cmpe226'@'localhost';
CREATE USER 'cmpe226'@'localhost' IDENTIFIED BY 'cmpe226';

DROP DATABASE IF EXISTS CMPE226_SPARTAN_FLIX;
CREATE DATABASE CMPE226_SPARTAN_FLIX;

GRANT ALL ON CMPE226_SPARTAN_FLIX.* TO 'cmpe226'@'localhost';

USE CMPE226_SPARTAN_FLIX;

SET FOREIGN_KEY_CHECKS=0;

-- Admin --
CREATE TABLE Admin (
	id INT AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	fname VARCHAR(64) NOT NULL ,
	lname VARCHAR(64) NOT NULL ,
	password VARCHAR(64) NOT NULL ,
	PRIMARY KEY (id),
	UNIQUE (email)
);
-- End Admin --


CREATE TABLE Advertiser (
	id INT UNSIGNED AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	fname VARCHAR(64) NOT NULL ,
	lname VARCHAR(64) NOT NULL ,
	password VARCHAR(64) NOT NULL ,
	subscriptionId TINYINT UNSIGNED NOT NULL,

    UNIQUE (email),

	PRIMARY KEY (id),

	FOREIGN KEY (subscriptionId)
		REFERENCES AdSubscription (id)
			ON UPDATE CASCADE
);

CREATE UNIQUE INDEX by_a_advertiser_id ON Advertiser (id);
CREATE UNIQUE INDEX by_a_email ON Advertiser (email);

CREATE TABLE AdSubscription (
	id TINYINT UNSIGNED AUTO_INCREMENT,
	price DECIMAL(8, 2) NOT NULL,
	duration TINYINT UNSIGNED DEFAULT 90, -- in days

	PRIMARY KEY (id)
);

CREATE TABLE Advertisement (
	id BIGINT UNSIGNED AUTO_INCREMENT,
	isApproved BOOL DEFAULT FALSE,
	advertiserId INT UNSIGNED NOT NULL,
	title VARCHAR(128) NOT NULL,
	description VARCHAR(256) NOT NULL,
	PRIMARY KEY (id),

	FOREIGN KEY (advertiserId)
		REFERENCES Advertiser (id)
			ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE UNIQUE INDEX by_a_id ON Advertisement(id);

-- Viewer and viewer actions --
CREATE TABLE Viewer (
	id INT UNSIGNED AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	fname VARCHAR(64) NOT NULL ,
	lname VARCHAR(64) NOT NULL ,
	password VARCHAR(64) NOT NULL ,
    startDate DATETIME NOT NULL,
	mainSubscriberId INT UNSIGNED,
    subscriptionId TINYINT UNSIGNED NOT NULL,

    UNIQUE (email),

	PRIMARY KEY (id),

	FOREIGN KEY (subscriptionId)
		REFERENCES AdSubscription (id)
			ON UPDATE CASCADE,

	FOREIGN KEY (mainSubscriberId)
		REFERENCES Viewer (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE UNIQUE INDEX by_v_id ON Viewer (id);
CREATE INDEX by_v_mainSubscriberId ON Viewer (mainSubscriberId);
CREATE UNIQUE INDEX by_v_email ON Viewer (email);

CREATE TABLE Watches (
	viewerId INT UNSIGNED,
    contentId BIGINT UNSIGNED,
    timestamp DATETIME NOT NULL,
    ratings TINYINT,

    PRIMARY KEY (viewerId, contentId),

	FOREIGN KEY (viewerId)
		REFERENCES Viewer (id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,

	FOREIGN KEY (contentId)
		REFERENCES Content (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE INDEX by_w_contentId ON Watches (contentId);
CREATE UNIQUE INDEX by_w_viewerId_contentId ON Watches (viewerId, contentId);
CREATE INDEX by_w_viewerId ON Watches (viewerId);

CREATE TABLE Favorites (
	viewerId INT UNSIGNED,
    contentId BIGINT UNSIGNED,

	PRIMARY KEY (viewerId, contentId),

	FOREIGN KEY (viewerId)
		REFERENCES Viewer (id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,

	FOREIGN KEY (contentId)
		REFERENCES Content (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE INDEX by_f_viewerId ON Favorites (viewerId);

CREATE TABLE Feedback (
	viewerId INT UNSIGNED,
    contentId BIGINT UNSIGNED,
    comment TEXT NOT NULL,

	PRIMARY KEY (viewerId, contentId),

	FOREIGN KEY (viewerId)
		REFERENCES Viewer (id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,

	FOREIGN KEY (contentId)
		REFERENCES Content (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE INDEX by_f_content_id ON Feedback (contentId);
CREATE INDEX by_f_viewerId_contentId ON Feedback (viewerId, contentId);

-- End: Viewer and viewer actions --

CREATE TABLE Content (
	id BIGINT UNSIGNED AUTO_INCREMENT,
	isApproved BOOL DEFAULT TRUE,
    director VARCHAR(128),
    contentProviderId INT UNSIGNED NOT NULL,
    contentTypeId TINYINT UNSIGNED NOT NULL,
    title VARCHAR(128) NOT NULL,
    description VARCHAR(256) NOT NULL,

	PRIMARY KEY (id),

	FOREIGN KEY (contentProviderId)
		REFERENCES ContentProvider (id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,

	FOREIGN KEY (contentTypeId)
		REFERENCES ContentType (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE UNIQUE INDEX by_c_id ON Content (id);
CREATE INDEX by_c_contentProviderId ON Content (contentProviderId);
CREATE INDEX by_c_contentTypeId ON Content (contentTypeId);


CREATE TABLE ContentProvider (
	id INT UNSIGNED AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	name VARCHAR(128) NOT NULL ,
	password VARCHAR(64) NOT NULL ,

	PRIMARY KEY (id)
);

CREATE UNIQUE INDEX by_cp_email ON ContentProvider (email);

-- Content, Includes, ContentSubscription, Actor, Cast --
CREATE TABLE ContentType(
	id TINYINT UNSIGNED AUTO_INCREMENT,
	name VARCHAR(128) NOT NULL ,

	PRIMARY KEY (id)
);

CREATE TABLE ContentSubscription (
	id INT UNSIGNED AUTO_INCREMENT,
	price DECIMAL(4, 2) NOT NULL,
	duration TINYINT UNSIGNED NOT NULL DEFAULT 30, -- in days
    hasAd BOOL NOT NULL DEFAULT TRUE,

	PRIMARY KEY (id)
);

# No need
CREATE UNIQUE INDEX by_content_subscription_id ON ContentSubscription (id);

CREATE TABLE Includes(
	contentTypeId TINYINT UNSIGNED,
	contentSubscriptionId INT UNSIGNED,

    PRIMARY KEY (contentTypeId, contentSubscriptionId),

	FOREIGN KEY (contentTypeId)
		REFERENCES ContentType (id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,

	FOREIGN KEY (contentSubscriptionId)
		REFERENCES ContentSubscription (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE INDEX by_i_contentSubscriptionId ON Includes (contentSubscriptionId);

CREATE TABLE Actor (
	id INT UNSIGNED AUTO_INCREMENT,
    fname VARCHAR(64) NOT NULL,
	lname VARCHAR(64) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE Cast (
	actorId INT UNSIGNED,
	contentId BIGINT UNSIGNED,

    PRIMARY KEY (actorId, contentId),

	FOREIGN KEY (contentId)
		REFERENCES Content (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,

	FOREIGN KEY (actorId)
		REFERENCES Actor (id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE VIEW CONTENT_VIEW AS
	SELECT A.id, A.isApproved, A.title, A.description, A.director, B.id as ContentTypeId, B.name as contentType, C.name as contentProviderName
    FROM Content A JOIN ContentType B JOIN ContentProvider C
    ON A.ContentTypeId = B.Id AND A.contentProviderId = C.id;

CREATE VIEW ADVERTISEMENT_VIEW AS
	SELECT A.id as advertisementId, A.title, A.description, A.isApproved, A.advertiserId, B.email, B.fname, B.lname, B.subscriptionId FROM Advertisement A JOIN Advertiser B
    ON A.advertiserId = B.id;    
    
CREATE TABLE Test (
	id INT AUTO_INCREMENT,
	PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE Test;