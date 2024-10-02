from pydantic import BaseModel

class Book(BaseModel):
    book_title: str
    author: str
    genre: str
