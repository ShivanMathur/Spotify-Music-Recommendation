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

def tracks_released_each_year():
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("""SELECT EXTRACT(YEAR FROM release_date) AS release_year, COUNT(*) AS track_count 
                        FROM album 
                        GROUP BY release_year 
                        ORDER BY release_year;""")
    record = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(record, columns=columns)

def track_details(track_name):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("""
                   SELECT al.track_name as track_name, al.release_date as release_date, ar.artist_name as artist_name, t.track_popularity as track_popularity, t.duration as track_duration, 
                    t.explicit as explicit, tf.energy as track_energy, tf.loudness as track_loudness, tf.instrumentalness as track_instrumentalness, tf.liveness as track_liveness, tf.valence as track_valence, 
                    tf.tempo as track_tempo, tf.time_signature as track_time_signature, tf.mode as track_mode
                    FROM album al
                    JOIN tracks t ON al.track_name = t.track_name
                    JOIN track_features tf ON al.track_id = tf.track_id
                    JOIN track_artist ta ON al.track_id = ta.track_id
                    JOIN artists ar ON ta.artist_id = ar.artist_id
                    WHERE al.track_name = %s;
                   """, (track_name,))
    records = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    if records:
        df = pd.DataFrame(records, columns=columns)
        st.write("Track Details:")
        st.dataframe(df)
    else:
        st.error("Error! Could not find the track in the database")
    cursor.close()
    conn.close()


album_dets = st.radio("Album Details", ['Tracks Released Each Year', 'Album Track Details'])

if album_dets == 'Tracks Released Each Year':
    tracks_df = tracks_released_each_year()
    st.dataframe(tracks_df)
elif album_dets == 'Album Track Details':
    track_name = st.text_input('Please Enter Track Name:')
    if st.button('Search'):
        track_details(track_name)
