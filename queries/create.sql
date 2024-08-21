DROP TABLE IF EXISTS track_details CASCADE;

DROP TABLE IF EXISTS tracks CASCADE;

DROP TABLE IF EXISTS artists CASCADE;

DROP TABLE IF EXISTS album CASCADE;

DROP TABLE IF EXISTS genre CASCADE;

DROP TABLE IF EXISTS track_features CASCADE;

DROP TABLE IF EXISTS keys CASCADE;

DROP TABLE IF EXISTS followers CASCADE;

DROP TABLE IF EXISTS users CASCADE;

DROP TABLE IF EXISTS user_playlist CASCADE;

DROP TABLE IF EXISTS track_artist CASCADE;

DROP TABLE IF EXISTS artist_genre CASCADE;


---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------CREATING TABLES------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- CREATE TABLE: track_details
CREATE TABLE track_details (
    track_id VARCHAR(255),
    track_name VARCHAR(10000),
	PRIMARY KEY (track_id)
);

-- CREATE TABLE: tracks
CREATE TABLE tracks (
    track_name VARCHAR(10000),
    track_popularity INTEGER,
	duration INTEGER,
	explicit INTEGER,
	PRIMARY KEY (track_name)
);

-- CREATE TABLE: artists
CREATE TABLE artists (
    artist_id VARCHAR(255),
	artist_name VARCHAR(500),
    artist_popularity INTEGER,
	PRIMARY KEY (artist_id)
);

-- CREATE TABLE: album
CREATE TABLE album (
    track_id VARCHAR(255),
	track_name VARCHAR(10000),
    release_date DATE,
	PRIMARY KEY (track_id),
	FOREIGN KEY (track_id) REFERENCES track_details(track_id)
	ON DELETE CASCADE
);

-- CREATE TABLE: genre
CREATE TABLE genre (
    genre_id VARCHAR(255),
	genre_name VARCHAR(500),
	PRIMARY KEY (genre_id)
);

-- CREATE TABLE: track_features
CREATE TABLE track_features (
    track_id VARCHAR(255),
	danceability REAL,
	energy REAL,
	loudness REAL, 
	mode INTEGER, 
	speechiness REAL,
    acousticness REAL, 
	instrumentalness REAL, 
	liveness REAL, 
	valence REAL, 
	tempo REAL, 
	time_signature INTEGER, 
	key_id INTEGER,
	PRIMARY KEY (track_id),
	FOREIGN KEY (track_id) REFERENCES track_details(track_id)
	ON DELETE CASCADE
);

-- CREATE TABLE: keys
CREATE TABLE keys (
    key_id VARCHAR(255),
	key_name VARCHAR(500),
	PRIMARY KEY (key_id)
);

-- CREATE TABLE: followers
CREATE TABLE followers (
    artist_id VARCHAR(255),
	followers REAL,
	PRIMARY KEY (artist_id),
	FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
	ON DELETE CASCADE
);

-- CREATE TABLE: users
CREATE TABLE users (
    user_id VARCHAR(255),
	user_name VARCHAR(255),
	user_email VARCHAR(255),
	PRIMARY KEY (user_id)
);

-- CREATE TABLE: user_playlist
CREATE TABLE user_playlist (
    user_id VARCHAR(255),
	track_id VARCHAR(255),
	playlist_name VARCHAR(255),
	PRIMARY KEY (user_id, track_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (track_id) REFERENCES track_details(track_id)
);

-- CREATE TABLE: track_artist
CREATE TABLE track_artist (
    track_id VARCHAR(255),
    artist_id VARCHAR(255),
	PRIMARY KEY (track_id, artist_id),
	FOREIGN KEY (track_id) REFERENCES track_details(track_id),
	FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
	ON DELETE CASCADE
);

-- CREATE TABLE: artist_genre
CREATE TABLE artist_genre (
	artist_id VARCHAR(255), 
	genre_id VARCHAR(255),
	PRIMARY KEY (artist_id, genre_id),
	FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
	FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
	ON DELETE CASCADE
);


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------CREATING FUNCTIONS AND TRIGGERS------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION delete_user_playlist()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM user_playlist
    WHERE user_id = OLD.user_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER user_playlist_deletion_trigger
BEFORE DELETE ON 
users
FOR EACH ROW
EXECUTE FUNCTION delete_user_playlist();
