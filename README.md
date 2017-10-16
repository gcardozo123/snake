# snake
A simple multiplayer Snake game.

Player 1 uses the WASD keys to move.
Player 2 uses the arrows to move.

Some considerations regarding to the code:
* Assuming that the game may be expanded, I've included a StateManager.
* It's possible to change the map dimensions, as well as tile dimensions. You can see it on the method `Gameplay.init`.
* It's possible to change keybindings. You can see it on the method `Gameplay.setupInputHandler`.
* Adding more players would be equivalent to store the array of players and setup their key bindings.
* Adding AI would be equivalent to derive a new class from Snake and create a method that emmits `Snake.changeDirection`calls.
* Adding the replay functionality would be equivalent to store the actions from each turn, which could be easily implemented on the method `Gameplay.newTurn`. Then create a method that runs those actions at each turn.