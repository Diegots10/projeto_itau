import requests

url = "https://fdru1y6hb7.execute-api.us-east-1.amazonaws.com/HML/recommendations"
# url = "https://fdru1y6hb7.execute-api.us-east-1.amazonaws.com/HML"

payload = {
    "genre": "Fiction",
    "favorite_author": "Diego Teixeira"
}

headers = {
    "Content-Type": "application/json"
}

response = requests.post(url, json=payload, headers=headers)
# response = requests.get(url)

print(response.status_code)
print(response.json())
