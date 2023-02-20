# Minesweeper API

A Ruby on Rails API REST application to implement the endpoints of the classic game Minesweeper.

_____________________
### Setting up environment

* Clone this project
* Bundle install `ruby version: 2.6.6 | rails version: 6.1.7.2`
* Start server `rails s`

Now you can perform requests to endpoints on base url [`localhost:3000`](http://localhost:3000).

```sh
This project is available to be tested on the following URL: +++++++++
```
____________________________

### Endpoint Overview

| HTTP METHOD | PATH                    | USAGE                                                           |
|-------------|-------------------------|-----------------------------------------------------------------|
| POST        | /users                  | Signs up new users                                              |
| POST        | /users/sign_in          | Signs in users who already have an account                      |
| POST        | /api/v1/games/          | Creates a brand new game for the user but does not start it     |
| POST        | /api/v1/games/:id/play  | Plays a move in the selected game (equivalent to tile clicking) |
| POST        | /api/v1/games/:id/pause | Pauses the selected game                                        |
| POST        | /api/v1/games/:id/flag  | Flags/Unflags a tile in the selected game                       |

### HTTP Statuses
- 200 OK: The request has succeeded
- 400 Bad Request: The request could not be understood by the server
- 400 Unauthorized: User's credentials are missing
- 403 Forbidden: The request was received yet the action was not authorized
- 404 Not Found: The resource is missing
- 422 Unprocessable Entity: The request could not be processed by the server
_________________

# Endpoints

## POST /users
- Signs up new users.

##### Required body parameters:
```json
{
  "user": [ 
    {
      "email": "dannie@mag.com",
      "password": "lorem@Ipsum"
    }
  ]
}
```

##### Response:

1

```json
{
  "success": true,
  "message": "Signed up successfully",
  "email": "seliksy@mag.com"
}
```

```sh
When success true, response returns, in the header,
a token which must be used in every request in order to authorize them.

This token must be inserted in the header section of every request,
under the key 'Authorization'.

It expires in 7 days.
```


##### Edge Cases:
- User already exists
  2

```json
{
  "success": false,
  "message": "Cannot create user",
  "email": null
}
```
- Missing parameters
  3
```json
{
  "success": false,
  "message": "Cannot create user",
  "email": null
}
```
___

## POST /users/sign_in
- Signs in users who already have an account

##### Required body parameters:
```json
{
  "user": [ 
    {
      "email": "dannie@mag.com",
      "password": "lorem@Ipsum"
    }
  ]
}
```

##### Response:

4

```json
{
  "success": true,
  "message": "Logged",
  "email": "dannie@mag.com"
}
```

##### Edge Cases:
- User tries to log in with an nonexistent credential

5

```json
{
  "success": false,
  "message": "Invalid user",
  "email": null
}
```
- User tries to make a request unlogged

6
```json
{
  "success": false,
  "message": "Invalid user",
  "email": null
}
```

