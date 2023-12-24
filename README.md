# README

* Ruby version 3.2.2
* Rails version 7.0.8

## Running the Application

To run the application, follow these steps:

1. Build the Docker image and start the containers:
   * docker-compose build
   * docker-compose up

2. After a successful launch, the application will be available at:
   * http://0.0.0.0:3000


## Endpoints

### List of Chats

- **URL**: `/api/chats`
- **Method**: `GET`
- **Description**: Get a list of all chats.


  GET http://0.0.0.0:3000/chats

### Create a Message in a Chat

- **URL**: `/api/chats/*your-chat-token*/create_message`
- **Method**: `POST`
- **Description**: Create a new message in a chat.


  POST http://0.0.0.0:3000/api/chats/*your-chat-token*/create_message
  
    {  "message": {  "content": "Hello, world!"  }  }