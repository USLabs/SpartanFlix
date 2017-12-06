-- USER.user_id is a 10-digit integer starts with 1 xxx xxx xxx
-- GROUP.group_id is a 10-digit integer starts with 2 xxx xxx xxx


DROP DATABASE IF EXISTS CMPE226_SPARTAN_FLIX;
CREATE DATABASE CMPE226_SPARTAN_FLIX;


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
             ON DELETE CASCADE
);

CREATE TABLE AdSubscription (
	id TINYINT UNSIGNED AUTO_INCREMENT,
	price DECIMAL(8, 2) NOT NULL,
	duration TINYINT UNSIGNED DEFAULT 90, -- in days
    title VARCHAR(64) NOT NULL, -- added
	PRIMARY KEY (id)
);

CREATE TABLE Advertisement (
	id INT UNSIGNED AUTO_INCREMENT,
	isApproved BOOL DEFAULT FALSE,
	advertiserId INT UNSIGNED NOT NULL,

	PRIMARY KEY (id),

	FOREIGN KEY (advertiserId)
		REFERENCES Advertiser (id)
			ON DELETE CASCADE
            ON UPDATE CASCADE
);


-- Viewer and viewer actions --
CREATE TABLE Viewer (
	id INT UNSIGNED AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	fname VARCHAR(64) NOT NULL ,
	lname VARCHAR(64) NOT NULL ,
	password VARCHAR(64) NOT NULL ,
    startDate DATETIME DEFAULT CURRENT_TIMESTAMP,
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

CREATE TABLE ContentProvider (
	id INT UNSIGNED AUTO_INCREMENT,
	email VARCHAR(128) NOT NULL ,
	name VARCHAR(128) NOT NULL ,
	password VARCHAR(64) NOT NULL ,

	PRIMARY KEY (id)
);


-- Content, Includes, ContentSubscription, Actor, Cast --
CREATE TABLE ContentType(
	id TINYINT UNSIGNED AUTO_INCREMENT,
	name VARCHAR(128) NOT NULL ,

	PRIMARY KEY (id)
);

CREATE TABLE ContentSubscription (
	id INT UNSIGNED AUTO_INCREMENT,
	price DECIMAL(6, 2) NOT NULL,
	duration TINYINT UNSIGNED NOT NULL DEFAULT 30, -- in days
    hasAd BOOL NOT NULL DEFAULT TRUE,

	PRIMARY KEY (id)
);

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
-- End: Content, Includes, ContentSubscription, Actor, Cast --




SET FOREIGN_KEY_CHECKS=1;
