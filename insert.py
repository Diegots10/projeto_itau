import boto3, json

# Criar uma sessão da AWS com credenciais
session = boto3.Session(
    aws_access_key_id='key_id',
    aws_secret_access_key='access_key',
    region_name='us-east-1'
)

# Criar o recurso DynamoDB
dynamodb = session.resource('dynamodb')
table = dynamodb.Table('tb_books')

with open(r'C:\Users\Rafael\3D Objects\ITAU\itau.api.books\insert_livros.txt', 'r', encoding='utf-8') as file:
    conteudo = file.read()
    lista_books = json.loads(conteudo)
    for book in lista_books:
        print(book)
        table.put_item(Item=book)
