---------------------------------------------------------------------------------------------------------------------------
--------------------------------------BASIC SELECT QUERIES ON ALL THE TABLES-----------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

SELECT * FROM track_details;
SELECT * FROM tracks;
SELECT * FROM artists;
SELECT * FROM album;
SELECT * FROM genre;
SELECT * FROM track_features;
SELECT * FROM keys ORDER BY key_id;
SELECT * FROM followers;
SELECT * FROM users;
SELECT * FROM user_playlist;
SELECT * FROM track_artist;
SELECT * FROM artist_genre;

---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------INSERT DATA INTO TABLES------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- 1. Inserting two new user records in the database
INSERT INTO users (user_id, user_name, user_email) VALUES ('10001', 'ShivanMathur', 'shivanma@buffalo.edu');
INSERT INTO users (user_id, user_name, user_email) VALUES ('10002', 'DebosmitNeogi', 'debosmit@buffalo.edu');

-- 2. Inserting new artist record into all the relevant tables
INSERT INTO artists (artist_id, artist_name, artist_popularity) VALUES ('01HWY4F4SMKCEEDF1GDQB0BQCY', 'Utkarsh Mathur', '10');
INSERT INTO artist_genre (artist_id, genre_id) VALUES ('01HWY4F4SMKCEEDF1GDQB0BQCY', '1400');
INSERT INTO artist_genre (artist_id, genre_id) VALUES ('01HWY4F4SMKCEEDF1GDQB0BQCY', '2331');
INSERT INTO followers (artist_id, followers) VALUES ('01HWY4F4SMKCEEDF1GDQB0BQCY', 50);
INSERT INTO track_artist (track_id, artist_id) VALUES ('1h0qIqWO2n9vV4QTyszRhm', '01HWY4F4SMKCEEDF1GDQB0BQCY');


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- UPDATE QUERIES -----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- 1. Update specific artist's genre in the table:
UPDATE artist_genre SET genre_id = '76'
WHERE artist_id = '01HWY4F4SMKCEEDF1GDQB0BQCY'
AND genre_id = '1400';

-- 2. Update the track's feature in the track_features table:
UPDATE track_features 
SET instrumentalness = 0.022, loudness = -7, energy = 0.8, tempo = 96
WHERE track_id = '000CSYu4rvd8cQ7JilfxhZ';

---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DELETE QUERIES --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- 1. Delete user's data 
DELETE FROM users
WHERE user_id = '10002';

-- 2. Delete artist's data from the track_artist table:
DELETE FROM track_artist
WHERE artist_id = '01HWY4F4SMKCEEDF1GDQB0BQCY';

COMMIT;


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- TASK 5 --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

SELECT * FROM album WHERE track_name = 'Love Yourself';

CREATE INDEX idx_album ON album(track_id, track_name);


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- 10 SQL QUERIES --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- 1. Find the Top 10 Most Popular Tracks:
SELECT track_name, track_popularity 
FROM tracks 
ORDER BY track_popularity DESC 
LIMIT 10;


-- 2. Top 10 Artists: 
SELECT a.artist_name, COUNT(*) AS track_count 
FROM track_artist ta
JOIN artists a ON ta.artist_id = a.artist_id 
GROUP BY a.artist_name
ORDER BY track_count DESC 
LIMIT 10;


-- 3. Find Most Popular Genre
SELECT g.genre_name, COUNT(DISTINCT td.track_id) AS total_tracks
FROM genre g
JOIN artist_genre ag ON g.genre_id = ag.genre_id
JOIN track_artist ta ON ag.artist_id = ta.artist_id
JOIN track_details td ON ta.track_id = td.track_id
GROUP BY g.genre_name
ORDER BY total_tracks DESC
LIMIT 10;


-- 4. Top Genres by Popularity:
SELECT g.genre_name, COUNT(DISTINCT a.artist_id) AS num_artists
FROM genre g
JOIN artist_genre ag ON g.genre_id = ag.genre_id
JOIN artists a ON ag.artist_id = a.artist_id
GROUP BY g.genre_name
ORDER BY num_artists DESC
LIMIT 10;


-- 5. Long and Energetic Tracks:
SELECT td.track_name, MAX(a.artist_name) AS artist_name, MAX(t.duration) AS duration, MAX(f.energy) AS energy
FROM track_details td
JOIN tracks t ON t.track_name = td.track_name
JOIN track_artist ta ON td.track_id = ta.track_id
JOIN artists a ON ta.artist_id = a.artist_id
JOIN track_features f ON td.track_id = f.track_id
WHERE t.duration > 250000 AND f.energy > 0.5
GROUP BY td.track_name
ORDER BY MAX(f.energy) DESC;



-- 6. Frequent Artist Collaborators:
SELECT a1.artist_name AS artist1, a2.artist_name AS artist2, COUNT(*) AS collaborations
FROM track_artist ta1
JOIN track_artist ta2 ON ta1.track_id = ta2.track_id
JOIN artists a1 ON ta1.artist_id = a1.artist_id
JOIN artists a2 ON ta2.artist_id = a2.artist_id
WHERE a1.artist_id <> a2.artist_id
GROUP BY a1.artist_name, a2.artist_name
HAVING COUNT(*) > 3
ORDER BY collaborations DESC;


-- 7. Count of Tracks in each Genre
SELECT g.genre_name, COUNT(*) AS track_count
FROM artist_genre ag
JOIN genre g ON ag.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY 2 DESC
LIMIT 25;


-- 8. Average Features of a Track
SELECT AVG(tf.loudness) AS average_loudness, AVG(tf.energy) as average_energy, AVG(tf.speechiness) as average_speechiness, 
AVG(tf.acousticness) as average_acousticness, AVG(instrumentalness) as average_instrumentalness  
FROM track_details td
JOIN track_features tf ON td.track_id = tf.track_id;


-- 9. Display Track Names and their respective Artists' names
SELECT DISTINCT td.track_name, a.artist_name
FROM track_details td
JOIN track_artist ta ON td.track_id = ta.track_id
JOIN artists a ON ta.artist_id = a.artist_id
LIMIT 10;


-- 10. Display the Artist name and Genre Name based on the Popularity of Artist in a Genre
WITH artist_high_popularity_based_on_genre AS (
    SELECT g.genre_name, MAX(a.artist_popularity) AS max_popularity
    FROM artists a
    JOIN artist_genre ag ON a.artist_id = ag.artist_id
    JOIN genre g ON ag.genre_id = g.genre_id
    GROUP BY g.genre_name
)
SELECT a.artist_name, g.genre_name
FROM artists a
JOIN artist_genre ag ON a.artist_id = ag.artist_id
JOIN genre g ON ag.genre_id = g.genre_id
JOIN artist_high_popularity_based_on_genre ahpg ON g.genre_name = ahpg.genre_name AND a.artist_popularity = ahpg.max_popularity;


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- TESTING TRIGGERS ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

SELECT * FROM users WHERE user_id = '36730';
SELECT * FROM user_playlist WHERE user_id = '36730';

DELETE FROM users WHERE user_id = '36730';


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- INDEXING ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


CREATE INDEX idx_genre ON genre(genre_id);
CREATE INDEX idx_artist_genre ON artist_genre(artist_id, genre_id);


SELECT g.genre_name, COUNT(*) AS track_count
FROM artist_genre ag
JOIN genre g ON ag.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY 2 DESC
LIMIT 25;


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- Problematic Query 3 ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


CREATE INDEX idx_track_details ON track_details(track_id);
CREATE INDEX idx_track_artist ON track_artist(track_id, artist_id);
CREATE INDEX idx_track_features ON track_features(track_id);
CREATE INDEX idx_artists ON artists(artist_id);


-- Optimized Query
WITH artist_high_popularity_based_on_genre AS (
    SELECT ag.genre_id, MAX(a.artist_popularity) AS max_popularity
    FROM artists a
    JOIN artist_genre ag ON a.artist_id = ag.artist_id
    GROUP BY ag.genre_id
)
SELECT a.artist_name, g.genre_name
FROM artists a
JOIN artist_genre ag ON a.artist_id = ag.artist_id
JOIN genre g ON ag.genre_id = g.genre_id
JOIN artist_high_popularity_based_on_genre ahpg ON ag.genre_id = ahpg.genre_id AND a.artist_popularity = ahpg.max_popularity;


---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- Problematic Query 4 ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


EXPLAIN SELECT g.genre_name, COUNT(DISTINCT a.artist_id) AS num_artists
FROM genre g
JOIN artist_genre ag ON g.genre_id = ag.genre_id
JOIN artists a ON ag.artist_id = a.artist_id
GROUP BY g.genre_name
ORDER BY num_artists DESC
LIMIT 10;
