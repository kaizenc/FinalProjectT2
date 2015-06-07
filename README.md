# FinalProjectT2
APCS Term 2 Final Project period 7
TEAM NAME: Team Not Flaming Chipmunk Jugglers
Current demo is up on the Master branch, use GameTime.pde under the GameTime folder and press play!

#To Do [Immediate]
- Add ~~monsters and~~ interactions
- Add ~~a menu, maybe~~ a pause menu

6-7-15
-------
- Added a more aesthetic menu
- Added song Darude-Sandstorm
- Different sized monsters that have health proportional to size
- Monsters move at different speeds regardless of size
- Added map boundaries

6-6-15
-------
- Added monster collision interaction. Is kind of buggy, not sure how to fix
- Monster collision prevents a certain monster from touching other monsters by pushing that certain monster back. However, if a lot of monsters surround a single monster, that monster will teleport to the edge of the cluster of monsters. If it is made that the monsters around the certain monster are pushed back instead of that monster, it may work better.
- Took out range restriction of bullets
- Rate of Monster spawn increases with time
- Made a background for game.

6-4-15
-------
- Branches merged
- Added a function spawnMonster() that randomly spawns monsters at random coordinates
- Made main draw() function a lot cleaner by making it call other functions that do its work

6-3-15
-------
- Added a menu with one button
- Added monsters that move

6-1-15
-------
- Bullet sprite added with rotation
- Changed range to use a range "counter" rather than coordiante limits
- Reformatted README.md

5-31-15
-------
- Player now rotates!
- Monsters can track player

5-28-15
-------
- Cleaned up code
- Added bullet removal, can change properties later
- Added a temporary sprite

5-27-15
-------
- Added Mouse class for easier crosshair transforming
- Movement works on a "camera" system; the camera follows the player
	- The player is "static"; it stays in the center while obstacles move around it
- Added bullet creation when clicking mouse
 	- ~~Bug occurs where velocity is different based on how far away from player the mouse is clicked~~
 	- Bug fixed using vectors! Also added an attack speed constraint

5-26-15
-------
- Added move() function that moves the player accordingly to WASD keyboard inputs
- Movement is smooth, can also move diagonally

5-25-15
-------
- Bullets can shoot in direction the mouse is pointing by following a path.
- Added radius (r) to bullets
- Added more "concepts" for how collision between monsters are gonna work
- Added recticle
- Added HitCheck for-loop to draw(). HitCheck checks whether bullets are hitting monsters.
- Added attack speed timer to Player class

5-24-15
-------
- Created a basic shape for the player
- Created a basic window for the game
- set a bulletDamage property for bullets

5-23-15
-------
- Added "camera" reference files 
- Added skeleton files for the player, monster, and bullets. Nothing has been tested and there are still some "skeleton" functions to write
