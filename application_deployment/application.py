import streamlit as st
import psycopg2
import pandas as pd
from pathlib import Path
from st_pages import Page, Section, add_page_title, show_pages


def main():
    st.title("Spotify Music Recommendation System")

    "## By: Shivan Mathur"

    show_pages(
    [
        Page("dmql_spotify_app.py", "Home", "🏠"),
        Page("users.py", "Users"),
        Page("artists.py", "Artists"),
        Page("album.py", "Album"),
        Page("sql_queries.py", "SQL Queries")
    ]
)

if __name__ == "__main__":
    main()

