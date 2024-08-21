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
        Page("application_deployment/dmql_spotify_app.py", "Home", "🏠"),
        Page("application_deployment/users.py", "Users"),
        Page("application_deployment/artists.py", "Artists"),
        Page("application_deployment/album.py", "Album"),
        Page("application_deployment/sql_queries.py", "SQL Queries")
    ]
)

if __name__ == "__main__":
    main()

