import os
from typing import Optional
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import psycopg2
import logging

app = FastAPI()

# Set up logging
log_level = os.getenv("LOG_LEVEL", "info").upper()
logging.basicConfig(level=log_level)
logger = logging.getLogger(__name__)

# Check the LOG_LEVEL environment variable
if log_level == "DEBUG":
    mode = os.getenv("MODE")
    logger.debug(f"MODE: {mode}")  # Log MODE only if LOG_LEVEL is DEBUG

# Database connection parameters
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

# Pydantic model for input validation
class Store(BaseModel):
    name: str

# Route to add a store name to the database
@app.post("/add_store/")
def add_store(store: Store):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = conn.cursor()

        # Insert the store name into the store table
        cursor.execute("INSERT INTO store (name) VALUES (%s)", (store.name,))
        conn.commit()

        # Close the database connection
        cursor.close()
        conn.close()

        return {"message": f"Store '{store.name}' added successfully!"}
    
    except Exception as e:
        logger.error(f"Error adding store: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def read_root():
    return {"Hello": "World"}