import streamlit as st
import psycopg2
import pandas as pd
from pathlib import Path
from st_pages import Page, Section, add_page_title, show_pages


def main():
    st.title("Spotify Recommendation System")

    "## This project is made as part of CSE 560: Data Model and Query Languages"

    "## By: Shivan Mathur and Debosmit Neogi"

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

