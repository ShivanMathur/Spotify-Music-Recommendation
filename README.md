# Spotify-Music-Recommendation

In the ever growing domain of music recommendation systems, there is a huge necessity to build low latency, fast running and robust and efficient systems, that can handle big data and its concurrent addition, updation as well as deletion. This calls for a move beyond Excel-based data management towards database solutions. This project seeks to make use of the database management systems to build a recommendation system for Spotify songs. We are using the Spotify Tracks and Spotify Artists datasets. For this project we aim to build a recommendation system that captures the underlying patterns of users’ preference of songs and artists and recommend new songs to a user.

## Data Processing:
This step involves collecting publicly available data from Spotify, and evaluate and assess them properly. The datasets mainly consists of: Track metadata, artist information, user listening history, Track tempo, pitch (and other meta-data) and user preferences. Assess the 4 Vs in Data Intensive Computing: Volume, Veracity, Variety, and Velocity of the dataset to determine its suitability for our proposed problem definition: Spotify Music Recommendation System.

# Database Schema:

## Description of Each Attributes: 

- _track_id_ is the unique id assigned to each track (datatype = String). 
- _track_name_ is the name given to each track (datatype = String).
- _track_popularity_ denotes how popular a track is in terms of ranking (datatype = Real).
- _artist_id_ is the unique id given to artist (datatype = String).
- _artist_name_ is the name of the artist (datatype = String).
- _artist_popularity_ denotes how popular an artist is in terms of ranking (datatype = Real).
- _duration_ is the duration of a track in milliseconds (datatype = Real).
- _explicit_ is a binary label provided to a track (datatype = integer).
- _genre_id_ is the unique id given to a genre of a track (datatype = String).
- _genre_ is the theme of a track (datatype = String).
- _key_name_ denote the musical key or note in which the track is sung (datatype = integer).
- _key_id_ is unique identity for key (datatype = integer).
- _user_id_ is the unique id given to a user (datatype = integer).
- _user_name_ is the name of the user (datatype = String).
- _user_email_ is the email of the user (datatype = String).
- _danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo,_ (Datatype = Real), _time signature, mode_ (Datatype = Integer) together signifies the overall characteristics of a song in terms of how users enjoy it and its audio qualities in terms of pitch, acoustics etc.
- _followers_ is the number of followers an artist has (datatype = integer).
- _release_date_ is the date on which a track is released (datatype = Datetime).

NOTE: There is no initialization or default value for any attribute. And none of the attribute value can be set to NULL.

