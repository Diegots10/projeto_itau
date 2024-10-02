from app.models.book import Book

async def generate_recommendations(preferences):
    # Lógica simplificada de recomendação baseada nas preferências recebidas
    books_db = [
        Book(book_title="Foundation", author="Isaac Asimov", genre="sci-fi"),
        Book(book_title="Dune", author="Frank Herbert", genre="sci-fi"),
        Book(book_title="1984", author="George Orwell", genre="dystopian"),
        Book(book_title="A Vida do Desenvolvedor", author="Diego Teixeira", genre="Fiction"),
    ]
    
    recommended_books = [book for book in books_db if book.genre == preferences.genre]
    
    return [book.dict() for book in recommended_books]
