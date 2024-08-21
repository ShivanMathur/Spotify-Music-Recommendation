import streamlit as st
import psycopg2
import pandas as pd
from st_pages import add_page_title

add_page_title()


def connect_to_database():
    conn = psycopg2.connect(
        host="localhost",
        port = 5432,
        database="dmql_project",
        user="dmql",
        password="dmql"
    )
    return conn

def execute_query(query):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return columns, results


def run_quries():
    queries = {
    "Find the Top 10 Most Popular Tracks": """SELECT track_name, track_popularity 
                                                FROM tracks 
                                                ORDER BY track_popularity DESC 
                                                LIMIT 10;""",
    
    "Top 10 Artists": """SELECT a.artist_name, COUNT(*) AS track_count FROM track_artist ta
                            JOIN artists a ON ta.artist_id = a.artist_id 
                            GROUP BY a.artist_name
                            ORDER BY 2 DESC, track_count DESC 
                            LIMIT 10;""",
    
    "Find Most Popular Genre by tracks": """SELECT g.genre_name, COUNT(DISTINCT td.track_id) AS total_tracks
                                    FROM genre g
                                    JOIN artist_genre ag ON g.genre_id = ag.genre_id
                                    JOIN track_artist ta ON ag.artist_id = ta.artist_id
                                    JOIN track_details td ON ta.track_id = td.track_id
                                    GROUP BY g.genre_name
                                    ORDER BY total_tracks DESC
                                    LIMIT 10;""",
    
    "Top Genres by Popularity": """SELECT g.genre_name, COUNT(DISTINCT a.artist_id) AS num_artists
                                    FROM genre g
                                    JOIN artist_genre ag ON g.genre_id = ag.genre_id
                                    JOIN artists a ON ag.artist_id = a.artist_id
                                    GROUP BY g.genre_name
                                    ORDER BY num_artists DESC
                                    LIMIT 10;""",
    
    "Long and Energetic Tracks":"""SELECT td.track_name, 
                                    MAX(a.artist_name) AS artist_name, 
                                    MAX(t.duration) AS duration, 
                                    MAX(f.energy) AS energy
                                    FROM track_details td
                                    JOIN tracks t ON t.track_name = td.track_name
                                    JOIN track_artist ta ON td.track_id = ta.track_id
                                    JOIN artists a ON ta.artist_id = a.artist_id
                                    JOIN track_features f ON td.track_id = f.track_id
                                    WHERE t.duration > 250000 AND f.energy > 0.5
                                    GROUP BY td.track_name
                                    ORDER BY MAX(f.energy) DESC;""",
    
    "Frequent Artist Collaborators":"""SELECT a1.artist_name AS artist1, a2.artist_name AS artist2, COUNT(*) AS collaborations
                                FROM track_artist ta1
                                JOIN track_artist ta2 ON ta1.track_id = ta2.track_id
                                JOIN artists a1 ON ta1.artist_id = a1.artist_id
                                JOIN artists a2 ON ta2.artist_id = a2.artist_id
                                WHERE a1.artist_id <> a2.artist_id
                                GROUP BY a1.artist_name, a2.artist_name
                                HAVING COUNT(*) > 3
                                ORDER BY collaborations DESC;""",
    
    "Count of Tracks in each Genre":"""SELECT g.genre_name, COUNT(*) AS track_count
                                        FROM artist_genre ag
                                        JOIN genre g ON ag.genre_id = g.genre_id
                                        GROUP BY g.genre_name
                                        ORDER BY 2 DESC
                                        LIMIT 25;""",
    
    "Average Features of a Track":"""SELECT AVG(tf.loudness) AS average_loudness, AVG(tf.energy) as average_energy, AVG(tf.speechiness) as average_speechiness, AVG(tf.acousticness) as average_acousticness, AVG(instrumentalness) as average_instrumentalness  
                                                FROM track_details td
                                                JOIN track_features tf ON td.track_id = tf.track_id;""",
    
    "Display Track Names and their respective Artists\' names": """SELECT DISTINCT td.track_name, a.artist_name
                                                            FROM track_details td
                                                            JOIN track_artist ta ON td.track_id = ta.track_id
                                                            JOIN artists a ON ta.artist_id = a.artist_id
                                                            LIMIT 10;""",

    "Display the Artist Name and Genres based on the popularity of Artist in a genre":"""
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
                                                            """,                                                      
    }

    # Select query
    query_name = st.selectbox("Select Query", list(queries.keys()))

    # Execute selected query
    columns, query_result = execute_query(queries[query_name])

    # Display query result
    st.write("Query Result:")
    st.dataframe(pd.DataFrame(query_result, columns=columns))

run_quries()