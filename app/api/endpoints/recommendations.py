from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.services.recommendation_service import generate_recommendations

router = APIRouter()

# Definir o schema para entrada
class PreferenceRequest(BaseModel):
    genre: str
    favorite_author: str

# Definir o schema para saída
class RecommendationResponse(BaseModel):
    book_title: str
    author: str

@router.post("/recommendations", response_model=list[RecommendationResponse])
async def get_recommendations(preferences: PreferenceRequest):
    """
    Recebe as preferências do usuário e retorna uma lista de recomendações de livros.
    """
    try:
        # Gerar recomendações com base nas preferências fornecidas
        recommendations = await generate_recommendations(preferences)
        
        # Se não houver recomendações, retornar uma exceção
        if not recommendations:
            raise HTTPException(status_code=404, detail="Nenhuma recomendação encontrada para essas preferências.")
        
        return recommendations
    except Exception as e:
        # Tratamento genérico de erros
        raise HTTPException(status_code=500, detail=f"Erro ao gerar recomendações: {str(e)}")
