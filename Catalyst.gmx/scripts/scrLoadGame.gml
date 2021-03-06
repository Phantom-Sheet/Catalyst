//loads the game

with (objPlayer) //destroy player if it exists
    instance_destroy();

var f = file_bin_open(working_directory+"\Data\save"+string(global.savenum),0);

global.md5StrIn = "";   //initialize string for md5 hash

global.death = scrReadBytes(f,3);
global.time = scrReadBytes(f,3);
global.timeMilli = scrReadBytes(f,2);

global.difficulty = scrReadBytes(f,1);
global.saveRoom = scrReadBytes(f,2);
global.savePlayerX = scrReadBytes(f,3);
global.savePlayerY = scrReadBytes(f,3);
global.saveGrav = scrReadBytes(f,1) - 1;    //subtract 1 because 1 was added when saved

for (var i = 1; i <= 8; i++)
{
    global.saveSecretItem[i] = scrReadBytes(f,1);
}

for (var i = 1; i <= 8; i++)
{
    global.saveBossItem[i] = scrReadBytes(f,1);
}

global.saveGameClear = scrReadBytes(f,1);


//load md5 hash

global.md5StrIn += global.md5StrAdd;    //add something to the end of the string to make save harder to mess with
//you can also add some other stuff to the string here if you want to make this harder to predict (just make sure to make it the same in scrSaveGame)

var md5StrOut = md5_string_unicode(global.md5StrIn), tempStr = "";

for (var i = 0; i < 16; i++)    //read the md5 hash from the file
{
    tempStr += scrDecToHex(scrReadBytes(f,1));
}

global.md5StrIn = "";   //clear string since we're no longer using it


file_bin_close(f);

if (md5StrOut != tempStr)   //check if md5 hash is invalid
{
    //hash is invalid, restart the game
    
    show_message("Save invalid!");
    
    surface_free(global.pauseSurf);
    
    game_restart();
    exit;
}

//set game variables

global.gameStarted = 1; //sets game in progress (enables saving, restarting, etc.)
global.noPause = 0;

global.grav = global.saveGrav;

for (var i = 1; i <= 8; i++)
{
    global.secretItem[i] = global.saveSecretItem[i];
    global.bossItem[i] = global.saveBossItem[i];
}

global.gameClear = global.saveGameClear;

global.player_djump = 1;
global.player_xscale = 1;

instance_create(global.savePlayerX,global.savePlayerY,objPlayer);

room_goto(global.saveRoom);