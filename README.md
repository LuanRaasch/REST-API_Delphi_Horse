#API REST em Delphi usando o Framework Horse
Este repositório contém uma API REST desenvolvida em Delphi utilizando o framework Horse. 
A API é uma implementação de um serviço RESTful que demonstra a criação e manipulação de recursos por meio de verbos HTTP.

##Sobre o Framework Horse
O Horse é um framework web minimalista para Delphi que visa simplificar a criação de aplicações web e APIs REST. 
Ele oferece uma abordagem simples e eficiente para lidar com rotas, middlewares e manipulação de requisições e respostas HTTP.

##Recursos da API
A API implementa os seguintes recursos:

1 .GET /cliente: Retorna a lista de produtos disponíveis.
2. GET /cliente/{id}: Retorna os detalhes de um produto específico com base no ID.
3. POST /cliente: Cria um novo produto com base nos dados fornecidos no corpo da solicitação.
4. PUT /cliente: Atualiza os detalhes de um produto existente com base nos dados fornecidos no corpo da solicitação.
5. DELETE /cliente/{id}: Remove um produto específico com base no ID.

##Exemplos de Requisições

GET /cliente
GET http://localhost:9000/cliente
<----------------------------------------->
GET /cliente/{id}
GET http://localhost:9000/cliente/1
<----------------------------------------->
POST /cliente
POST http://localhost:9000/cliente

Body:
 {
    "nome": "Luan Carlos",
    "email": "luan@teste.com.br",
    "fone": "(11) 9999-9999"
  }
<----------------------------------------->  
PUT /cliente
PUT http://localhost:9000/cliente

Body:
{
    "idCliente": 1,
    "nome": "Luan Carlos Alterado",
    "email": "luan@teste.com.br",
    "fone": "(11) 9999-9999"
}
<----------------------------------------->
DELETE /cliente/{id}
DELETE http://localhost:9000/cliente/1
