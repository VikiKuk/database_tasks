CREATE TABLE musical_genre (
	genre_id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL
);

CREATE TABLE musician (
	musician_id SERIAL PRIMARY KEY,
	name_pseudonym VARCHAR(60) NOT NULL
);

CREATE TABLE musician_genre_link (
	genre_id INTEGER REFERENCES musical_genre (genre_id),
	musician_id INTEGER REFERENCES musician (musician_id),
	CONSTRAINT pk_musician_genre_link 	PRIMARY KEY (genre_id, musician_id)
);

CREATE TABLE album (
	album_id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	year INTEGER NOT NULL
);

CREATE TABLE musician_album_link (
	album_id INTEGER REFERENCES album (album_id),
	musician_id INTEGER REFERENCES musician (musician_id),
	CONSTRAINT pk_musician_album_link 	PRIMARY KEY (album_id, musician_id)
);

CREATE TABLE track (
	track_id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	duration TIMESTAMP NOT NULL,
	album_id INTEGER REFERENCES album(album_id)
);

CREATE TABLE collection (
	collection_id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	year INTEGER NOT NULL
);

CREATE TABLE collection_track_link (
	collection_id INTEGER REFERENCES collection (collection_id),
	track_id INTEGER REFERENCES track (track_id),
	CONSTRAINT pk_collection_track_link 	PRIMARY KEY (collection_id, track_id)
);