---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------IMPORTING DATA------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- insert data from track_details csv, which is created from the original dataset
COPY track_details (track_id, track_name)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/track_details.csv' DELIMITER ',' CSV HEADER;


-- insert data from track csv, which is created from the original dataset
COPY tracks (track_name, track_popularity, duration, explicit)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/track.csv' DELIMITER ',' CSV HEADER;


-- insert data from artist csv, which is created from the original dataset
COPY artists (artist_id, artist_name, artist_popularity)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/artist.csv' DELIMITER ',' CSV HEADER;


-- insert data from album csv, which is created from the original dataset
COPY album (track_id, track_name, release_date)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/album.csv' DELIMITER ',' CSV HEADER


-- insert data from genre csv, which is created from the original dataset
COPY genre (genre_id, genre_name)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/genre.csv' DELIMITER ',' CSV HEADER


-- insert data from features csv, which is created from the original dataset
COPY track_features (track_id, danceability, energy, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, 
					 time_signature, key_id)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/features.csv' DELIMITER ',' CSV HEADER


-- insert data from key csv, which is created from the original dataset
COPY keys (key_id, key_name)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/key.csv' DELIMITER ',' CSV HEADER


-- insert data from follower csv, which is created from the original dataset
COPY followers (artist_id, followers)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/follower.csv' DELIMITER ',' CSV HEADER


-- insert data from user csv, which is created from the original dataset
COPY users (user_id, user_name, user_email)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/user.csv' DELIMITER ',' CSV HEADER


-- insert data from user_playlist csv, which is created from the original dataset
COPY user_playlist (user_id, playlist_name, track_id)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/user_playlist.csv' DELIMITER ',' CSV HEADER


-- insert data from track_artist csv, which is created from the original dataset
COPY track_artist (track_id, artist_id)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/track_artist.csv' DELIMITER ',' CSV HEADER


-- insert data from artist_genre csv, which is created from the original dataset
COPY artist_genre (artist_id, genre_id)
FROM 'D:/UB/Spring 2024/CSE 560 - Data Models and Query Language/Project/artist_genre.csv' DELIMITER ',' CSV HEADER
