# Minesweeper API

A Ruby on Rails API REST application to implement the endpoints of the classic game Minesweeper.

_____________________
### Setting up environment

* Clone this project
* Bundle install `ruby version: 2.6.6 | rails version: 6.1.7.2`
* Start server `rails s`

Now you can perform requests to endpoints on base url [`localhost:3000`](http://localhost:3000).

```sh
This project is available to be tested on the following URL: https://minesweeper-dannie.herokuapp.com/
```
_______________________

## Feature Overview

| STATUS | FEATURE                                                                               |
|--------|---------------------------------------------------------------------------------------|
| yes    | Design and implement a documented RESTful API for the game                            |
| yes    | When a cell with no adjacent mines is revealed, all adjacent squares will be revealed |
| yes    | Ability to 'flag' a cell with a question mark or red flag                             |
| yes    | Detect when game is over                                                              |
| yes    | Persistence                                                                           |
| yes    | Time tracking                                                                         |
| yes    | Ability to start a new game and preserve/resume the old ones                          |
| yes    | Ability to select the game parameters: number of rows, columns, and mines             |
| yes    | Ability to support multiple users/accounts                                            |
| yes    | URL where the game can be accessed and played                                         |
| no     | Implement an API client library for the API designed above.                           |

---

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
  "user": 
    {
      "email": "dannie@mag.com",
      "password": "lorem@Ipsum"
    }
}
```

##### Response:

![](https://s3.sa-east-1.amazonaws.com/daniellemagalhaes.com.br/minesweeper-img/1.png)

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
7

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
  "user":
    {
      "email": "dannie@mag.com",
      "password": "lorem@Ipsum"
    }
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
## POST /api/v1/games/
- Creates a brand new game for the user but does not start it.

##### Required body parameters:
```json
{
  "game[matrix]": <matrix>,
  "game[level]": <level>
}
```
##### Required header parameters (sample):
```json
{
  Authorization: Bearer dmJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjc2ODI5MTA1LCJleH
}
```
Where:
- `matrix`: [Integer] Value corresponding to the matrix of the board to be generated.
Example: A table of matrix 5 will have 25 tiles (5 * 5 tiles).

- `level`: [Integer] Value corresponding to the amount of bombs in the board, according to the following ratio:

  0 = 'easy' - 30%
  
  1 = 'medium' - 50%

  2 = 'hard' - 70%

##### Response:

8

```json
{
  "success": true,
  "message": "Game created!",
  "data": {
    "id": 1,
    "matrix": 15,
    "level": "easy",
    "starting_time": "0.0",
    "elapsed_time": "0.0",
    "status": "stopped",
    "user_id": 1,
    "created_at": "2023-02-20T01:51:53.087Z",
    "updated_at": "2023-02-20T01:51:53.087Z"
  }
}
```

```sh
INFO: 
- Any game created belongs to an user.
- A game can be paused and resumed as long as its status is different of 'won' or 'lost' 
```
___

## POST /api/v1/games/:id/play
- Plays a move in the selected game (equivalent to tile clicking)

##### Required body parameters:
```json
{
  "key_name": "X,Y"
}
```
##### Required header parameters (sample):
```json
{
  Authorization: Bearer dmJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjc2ODI5MTA1LCJleH
}
```
Where:
- `id`: [Integer] The ID of the game being played.

- `key_name`: [String] A value corresponding to the coordinates of the tile to be open (clicked).
  Example: `"0,0"` corresponds to line 1, column, 1

##### Possible Responses:
- Clicked on a bomb

9

```json
{
  "success": true,
  "message": "BOOM! Game over",
  "data": {
    "game_id": 2,
    "played": true,
    "bomb": true,
    "id": 446,
    "key_name": "14,10",
    "near_bombs": 0,
    "flagged": "nope",
    "created_at": "2023-02-20T03:39:41.453Z",
    "updated_at": "2023-02-20T03:46:15.554Z"
  }
}
```

- CLicking on a zeroed tile.

  (It may cause other zeroed tiles around to be closed.)

10

```json
{
  "success": true,
  "message": "Tile zeroed. Total tiles open: 2",
  "data": {
    "game_id": 12,
    "played": true,
    "id": 756,
    "key_name": "2,2",
    "near_bombs": 0,
    "flagged": "nope",
    "bomb": false,
    "created_at": "2023-02-20T04:20:55.463Z",
    "updated_at": "2023-02-20T04:27:23.806Z"
  }
}
```

- CLicking on a tile near to a bomb

11

```json
{
  "success": true,
  "message": "Near bombs: 2",
  "data": {
    "game_id": 12,
    "played": true,
    "id": 755,
    "key_name": "2,1",
    "near_bombs": 2,
    "flagged": "nope",
    "bomb": false,
    "created_at": "2023-02-20T04:20:55.462Z",
    "updated_at": "2023-02-20T04:30:44.181Z"
  }
}
```

- Reaching victory by clicking on the last possible tile

12

```json
{
  "success": true,
  "message": "You WON the game",
  "data": {
    "game_id": 1,
    "played": true,
    "id": 1,
    "key_name": "0,0",
    "near_bombs": 0,
    "flagged": "nope",
    "bomb": false,
    "created_at": "2023-02-20T04:20:55.462Z",
    "updated_at": "2023-02-20T04:30:44.181Z"
  }
}
```
##### Edge Cases:
- User informs a nonexisting tile

13

```json
{
  "success": false,
  "message": "No existing tile",
  "data": []
}
```

- User tries to play a finished game (won/lost status)

14

```json
{
  "success": false,
  "message": "Cannot restart a finished game",
  "data": {
    "id": 1,
    "matrix": 15,
    "level": "easy",
    "starting_time": "0.0",
    "elapsed_time": "0.0",
    "status": "lost",
    "user_id": 1,
    "created_at": "2023-02-20T01:51:53.087Z",
    "updated_at": "2023-02-20T01:51:53.087Z"
  }
}
```
## POST /api/v1/games/:id/pause
- Pauses the selected game

##### Required body parameters:
```json
{

}
```
##### Required header parameters (sample):
```json
{
  Authorization: Bearer dmJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjc2ODI5MTA1LCJleH
}
```

##### Response:

15

```json
{
  "success": true,
  "message": "Game paused",
  "data": {
    "user_id": 1,
    "status": "paused",
    "id": 12,
    "matrix": 3,
    "level": "easy",
    "starting_time": "82098.868641",
    "elapsed_time": "918.586462",
    "created_at": "2023-02-20T04:20:55.436Z",
    "updated_at": "2023-02-20T04:42:42.372Z"
  }
}
```

## POST /api/v1/games/:id/flag
- Flags/Unflags a tile in the selected game

##### Required body parameters:
```json
{
  "key_name": "X,Y",
  "flag": <flag>
}
```
##### Required header parameters (sample):
```json
{
  Authorization: Bearer dmJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjc2ODI5MTA1LCJleH
}
```
Where:
- `id`: [Integer] The ID of the game being played.

- `key_name`: [String] A value corresponding to the coordinates of the tile to be open (clicked).
  Example: `"0,0"` corresponds to line 1, column, 1

- `flag`: [String] A value corresponding to the flag user wishes to add/remove.
  Flag values can be: `nope` (default, no flags) | `question` | `red`

```sh
INFO: 
- Calling the same endpoint on a tile flags and unflags it depending on the parameter
```

##### Response:

16

```json
{
  "success": true,
  "message": "Flag: nope",
  "data": {
    "game_id": 4,
    "flagged": "nope",
    "id": 900,
    "key_name": "14,14",
    "near_bombs": 0,
    "played": false,
    "bomb": false,
    "created_at": "2023-02-19T21:45:19.385Z",
    "updated_at": "2023-02-19T21:54:45.530Z"
  }
}
```

##### Edge Cases:
- User informs an invalid flag

17

```json
{
  "success": false,
  "message": "No existing tile",
  "data": []
}
```

- User informs no flags

18

```json
{
  "success": false,
  "message": "Missing flag",
  "data": []
}
```
