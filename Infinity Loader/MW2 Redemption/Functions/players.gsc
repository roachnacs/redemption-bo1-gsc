KillPlayer(player)
{
    player Suicide();
}

KickPlayer(player)
{
    Kick(player GetEntityNumber());
}

FreezePlayer(player)
{
    player FreezeControls(true);
    self iPrintln("The player has been ^2Frozen");
}

UnFreezePlayer(player)
{
    player FreezeControls(false);
    self iPrintln("The player has been ^1UnFrozen");
}

AutoSuicide(player)
{
    player.AutoSuicide = (isDefined(player.AutoSuicide) ? undefined : true);
    
    if(isDefined(player.AutoSuicide))
        self iPrintln("Player Auto Suicide: ^2On");
    else
        self iPrintln("Player Auto Suicide: ^1Off");
    
    while(isDefined(player.AutoSuicide))
    {
        if(isAlive(player))
            player suicide();
        wait .1;
    }
}

SendToSky(player)
{
    player SetOrigin(player.origin+(0,0,10000));
    self iPrintln("The player has been sent to the sky");
}

SendToCrosshairs(player)
{
    player SetOrigin(self TraceBullet());
}

RevivePlayer(player) //Still untested, but should work.
{
    player.lastStand  = undefined;
    player.finalStand = undefined;
    player clearLowerMessage("last_stand");
    
    if(player _hasPerk("specialty_lightweight"))
        player.moveSpeedScaler = 1.07;
    else
        player.moveSpeedScaler = 1;
    
    player.maxHealth = 100;
    player maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");
    player maps\mp\gametypes\_playerlogic::lastStandRespawnPlayer();
    player setPerk("specialty_pistoldeath",true);
    player.beingRevived = false;
    
    self iPrintln("The player has been ^2Revived");
}

FixFrozenClasses(player)
{
    player SetPlayerData("customClasses",0,"name","^1Class One");
    player SetPlayerData("customClasses",1,"name","^2Class Two");
    player SetPlayerData("customClasses",2,"name","^3Class Three");
    player SetPlayerData("customClasses",3,"name","^4Class Four");
    player SetPlayerData("customClasses",4,"name","^5Class Five");
    player SetPlayerData("customClasses",5,"name","^6Class Six");
    player SetPlayerData("customClasses",6,"name","^2Class Seven");
    player SetPlayerData("customClasses",7,"name","^1Class Eight");
    player SetPlayerData("customClasses",8,"name","^5Class Nine");
    player SetPlayerData("customClasses",9,"name","^4Class Ten");
    
    self iPrintln("You have fixed the player's classes");
    player iPrintlnBold("Your classes have been ^1UnFrozen");
}

GiveUnlockAll(player)
{
    self thread AllChallenges(player);
    self iPrintln("The player has been given ^2Unlock All");
}

GiveDerank(player)
{
    player SetClientDvar("com_errorTitle","Notice");
    player SetClientDvar("com_errorMessage","you got deranked");
    player OpenMenu("error_popmenu_lobby");
    
    self thread SetPrestige(0,player);
    SV_GameSendServerCommand("J 2056 000000;",player);
    
    self iPrintln("The player has been ^1Deranked");
}

GiveFFAFastLast(player)
{
    player thread FastLast("FFA");
    self iPrintln("The player has been given ^2Fast Last");
}

GiveTrickshotAimbot(player)
{
    player.AimbotTrickshot = (isDefined(player.AimbotTrickshot) ? undefined : true);
    
    if(isDefined(player.AimbotTrickshot))
    {
        player.AimbotUnfair = undefined;
        player thread Aimbot();
        self iPrintln("Player's Trickshot Aimbot: ^2On");
    }
    else
    {
        player.Aimbot = undefined;
        player notify("EndAimbot");
        self iPrintln("Player's Trickshot Aimbot: ^1Off");
    }
}