import streamlit as st
import psycopg2
import pandas as pd
import uuid
from st_pages import add_page_title

add_page_title()


# def connect_to_database():
#     conn = psycopg2.connect(
#         host="localhost",
#         port = 5432,
#         database="dmql_project",
#         user="dmql",
#         password="dmql"
#     )
#     return conn

def connect_to_database():
    conn = psycopg2.connect(
        database=st.secrets["DB_NAME"],
        user=st.secrets["DB_USERNAME"],
        password=st.secrets["DB_PASSWORD"]
    )
    return conn

def artist_details():
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM artists ORDER BY artist_popularity desc LIMIT 10;")
    records = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(records, columns=columns)

def disp_artist_data(artist_id):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM artists WHERE artist_id = %s;", (artist_id,))
    record = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(record, columns=columns)


def artist_tracks(artist_name):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("""
                   SELECT a.artist_name as Artist_Name, a.artist_popularity as Artist_Popularity, f.followers as Artist_Followers 
                   FROM artists a, followers f WHERE a.artist_id = f.artist_id AND a.artist_name = %s;
                   """, (artist_name,))
    records = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    if records:
        df = pd.DataFrame(records, columns=columns)
        st.write("Artist Details:")
        st.dataframe(df)
    else:
        st.error("Error! Could not find artist record in the database")
    cursor.close()
    conn.close()

def add_artist():
    with st.form("Insert"):
        artist_name = st.text_input("Artist Name")
        artist_pop = st.text_input("Artist Popularity")
        submitted = st.form_submit_button("Submit")
        if submitted:
            conn = connect_to_database()
            cursor = conn.cursor()
            artist_id = str(uuid.uuid4())
            cursor.execute("INSERT INTO artists (artist_id, artist_name, artist_popularity) VALUES (%s, %s, %s)", (artist_id, artist_name, artist_pop))
            conn.commit()
            cursor.close()
            conn.close()
            
            st.success("User data ADDED successfully!")
            st.write("New User data:")
            new_artist = disp_artist_data(artist_id)
            st.dataframe(new_artist)

artists_dets = st.radio("Artist Details", ['Show Popular Artist', 'Add Artist', 'Show Artist\'s Tracks'])

if artists_dets == 'Show Popular Artist':
    artist_details_df = artist_details()
    st.dataframe(artist_details_df)
elif artists_dets == 'Add Artist':
    add_artist()
elif artists_dets == 'Show Artist\'s Tracks':
    artist_name = st.text_input('Please Enter Artist Name:')
    if st.button('Search'):
        artist_tracks(artist_name)
        
