import streamlit as st
import psycopg2
import pandas as pd
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

def user_details():
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("SELECT user_id, user_name, user_email FROM USERS LIMIT 10;")
    records = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(records, columns=columns)



def disp_user_data(user_name):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("SELECT user_id, user_name, user_email FROM USERS WHERE user_name = %s;", (user_name,))
    record = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(record, columns=columns)


def add_user():
    with st.form("Insert"):
        user_name = st.text_input("User Name")
        user_email = st.text_input("User Email")
        submitted = st.form_submit_button("Submit")
        if submitted:
            conn = connect_to_database()
            cursor = conn.cursor()
            query = "INSERT INTO users (user_id, user_name, user_email) VALUES ((SELECT COALESCE(MAX(CAST(user_id AS INTEGER)), 0)+1 FROM USERS), %s, %s)"
            cursor.execute(query, (user_name, user_email))
            conn.commit()
            cursor.close()
            conn.close()
            
            st.success("User data ADDED successfully!")
            st.write("New User data:")
            new_user = disp_user_data(user_name)
            st.dataframe(new_user)


def update_user_details():
    with st.form("Update"):
        user_id = st.text_input("User ID")
        user_name = st.text_input("User Name")
        submitted = st.form_submit_button("Submit")
        if submitted:
            conn = connect_to_database()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
            record = cursor.fetchone()
            if record:
                cursor.execute("UPDATE users SET user_name = %s WHERE user_id = %s;", (user_name, user_id,))
                conn.commit()
                cursor.close()
                conn.close()
                st.success("User data UPDATED successfully!")
                updated_user_record = disp_user_data(user_name)
                st.write("Update User Details:")
                st.dataframe(updated_user_record)
            else:
                cursor.close()
                conn.close()
                st.error("Error! Could not find user record in the database")

def delete_user():
    with st.form("Delete"):
        user_id = st.text_input("User ID")
        user_name = st.text_input("User Name")
        submitted = st.form_submit_button("Submit")
        if submitted:
            conn = connect_to_database()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM users WHERE user_id = %s;", (user_id,))
            record = cursor.fetchone()
            if record:
                cursor.execute("DELETE FROM users WHERE user_id = %s;", (user_id,))
                conn.commit()
                cursor.close()
                conn.close()
                st.success("User data DELETED successfully!")
            else:
                cursor.close()
                conn.close()
                st.error("Error! Could not find user record in the database")

def user_playlist(user_id):
    conn = connect_to_database()
    cursor = conn.cursor()
    cursor.execute("""SELECT DISTINCT up.user_id, u.user_name, al.track_name, ar.artist_name, al.release_date 
                        FROM user_playlist up
                        JOIN users u ON up.user_id = u.user_id
                        JOIN album al ON up.track_id = al.track_id
                        JOIN track_artist ta ON up.track_id = ta.track_id
                        JOIN artists ar ON ar.artist_id = ta.artist_id
                        WHERE up.user_id = %s;""", (user_id,))
    records = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(records, columns=columns)

user_dets = st.radio("User Details", ['Show User details', 'Add Users', 'Update User Details', 'Delete User', 'User Playlist'])

if user_dets == 'Show User details':
    user_details_df = user_details()
    st.dataframe(user_details_df)
elif user_dets == 'Add Users':
    add_user()
elif user_dets == 'Update User Details':
    update_user_details()
elif user_dets == 'Delete User':
    delete_user()
elif user_dets == 'User Playlist':
    user_id = st.text_input('Please Enter User ID:')
    if st.button('Search'):
        user_playlist_df = user_playlist(user_id)
        st.dataframe(user_playlist_df)
