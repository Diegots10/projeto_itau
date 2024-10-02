from fastapi import FastAPI
from app.api.endpoints import recommendations
from mangum import Mangum

app = FastAPI(title="Book Recommendation Service")

app.include_router(recommendations.router)

@app.get("/")
async def root():
    return {"message": "Book Recommendation Service is running"}

lambda_handler = Mangum(app)
