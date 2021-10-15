SuperJump()
{
    level.SuperJump = (isDefined(level.SuperJump) ? undefined : true);
    
    if(!isDefined(level.SuperJump))
    {
        self iPrintln("Super Jump: ^1Off");
        level notify("ServerSuperJump_End");
    }
    else
    {
        self iPrintln("Super Jump: ^2On");
        level endon("disconnect");
        level endon("ServerSuperJump_End");
        
        while(isDefined(level.SuperJump))
        {
            foreach(player in level.players)
            {
                player notify("newJump");
                player thread WatchSuperJump();
            }
            wait .025;
        }
    }
}

WatchSuperJump()
{
    self endon("disconnect");
    self endon("newJump");
    level endon("ServerSuperJump_End");
    
    self NotifyOnPlayerCommand("player_jump","+gostand");
    if(self IsOnGround())
    {
        self waittill("player_jump");
        self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        self SetVelocity(self GetVelocity()+(0,0,1000));
    }
}

SuperSpeed()
{
    level.SuperSpeed = (isDefined(level.SuperSpeed) ? undefined : true);
    
    if(!isDefined(level.SuperSpeed))
    {
        self iPrintln("Super Speed: ^1Off");
        foreach(player in level.players)
            player SetMoveSpeedScale(1);
    }
    else
    {
        self iPrintln("Super Speed: ^2On");
        
        while(isDefined(level.SuperSpeed))
        {
            foreach(player in level.players)
                player SetMoveSpeedScale(2);
            wait .1;
        }
    }
}

SlowMotion()
{
    level.SlowMotion = (isDefined(level.SlowMotion) ? undefined : true);
    
    if(!isDefined(level.SlowMotion))
        SetDvar("timescale",1);
    else
        SetDvar("timescale",.5);
}

AntiJoin()
{
    level.AntiJoin = (isDefined(level.AntiJoin) ? undefined : true);
    
    if(!isDefined(level.AntiJoin))
    {
        self iPrintln("Anti Join: ^1Off");
        SetDvar("g_password","");
    }
    else
    {
        self iPrintln("Anti Join ^2On");
        SetDvar("g_password","@CF4");
    }
}

AntiQuit()
{
    level.AntiQuit = (isDefined(level.AntiQuit) ? undefined : true);
    
    if(!isDefined(level.AntiQuit))
        self iPrintln("Anti Quit: ^1Off");
    else
    {
        self iPrintln("Anti Quit: ^2On");
        
        while(isDefined(level.AntiQuit))
        {
            foreach(player in level.players)
                player closeInGameMenu();
            wait .05;
        }
    }
}

ServerSetLobbyTimer(input)
{
    timeLeft       = GetDvar("scr_"+level.gametype+"_timelimit");
    timeLeftProper = int(timeLeft);
    if(input == "add")
        setTime = timeLeftProper + 1;
    if(input == "sub")
        setTime = timeLeftProper - 1;
    SetDvar("scr_"+level.gametype+"_timelimit",setTime);
    time = setTime - getMinutesPassed();
    wait .05;
    
    if(input == "add")
        self iPrintln("^2Added 1 minute");
    else
        self iPrintln("^1Removed 1 minute");
}

InfiniteGame()
{
    level.InfiniteGame = (isDefined(level.InfiniteGame) ? undefined : true);
    
    if(!isDefined(level.InfiniteGame))
    {
        level thread maps\mp\gametypes\_gamelogic::resumeTimer();
        SetDvar("scr_"+level.gametype+"_scorelimit",level.SavedScoreLimit);
        self iPrintln("Infinite Game: ^1Off");
    }
    else
    {
        level.SavedScoreLimit = GetDvar("scr_"+level.gametype+"_scorelimit");
        
        level thread maps\mp\gametypes\_gamelogic::pauseTimer();
        SetDvar("scr_"+level.gametype+"_scorelimit",0);
        self iPrintln("Infinite Game: ^2On");
    }
}

ToggleFloaters()
{
    level.Floaters = (isDefined(level.Floaters) ? undefined : true);
    
    if(!isDefined(level.Floaters))
    {
        level notify("EndFloaters");
        self iPrintln("Floaters: ^1Off");
    }
    else
    {
        self iPrintln("Floaters: ^2On");
        
        level endon("EndFloaters");
        level waittill("game_ended");
        foreach(player in level.players)
            player thread InitFloat();
    }
}

InitFloat()
{
    if(self IsOnGround())return;
    
    self endon("disconnect");
    level endon("EndFloaters");
    
    linker = Spawn("script_model",self.origin);
    self PlayerLinkTo(linker);
    wait .1;
    self FreezeControls(true);
    
    while(1)
    {
        if(!self IsOnGround())
            linker MoveTo(linker.origin-(0,0,5),.15);
        wait .15;
    }
}

MaxTeamCount()
{
    level.teamLimit = 18;
    SetDvar("sv_maxclients",18);
    SetDvar("scr_teambalance",0);
    self iPrintln("Teams can now have 18 players");
}

GetMapFog()
{
    level.MapFogHalfPlane  = GetDvarFloat("g_fogHalfDistReadOnly");
    level.MapFogNearPlane  = GetDvarFloat("g_fogStartDistReadOnly");
    level.MapFogMaxOpacity = GetDvarFloat("g_fogMaxOpacityReadOnly");
    scrFogColor = GetDvarVector("g_fogColorReadOnly");
    level.MapFogColor = (scrFogColor[0],scrFogColor[1],scrFogColor[2]);
}

DiscoFog()
{
    level.DiscoFog = (isDefined(level.DiscoFog) ? undefined : true);
    
    if(!isDefined(level.DiscoFog))
    {
        SetExpFog(level.MapFogNearPlane,level.MapFogHalfPlane,level.MapFogColor[0],level.MapFogColor[1],level.MapFogColor[2],level.MapFogMaxOpacity,.1);
        self iPrintln("Disco Fog: ^1Off");
    }
    else
    {
        self iPrintln("Disco Fog: ^2On");
        
        while(isDefined(level.DiscoFog))
        {
            SetExpFog(300,1000,(RandomInt(255)/255),(RandomInt(255)/255),(RandomInt(255)/255),1,0);
            wait .15;
        }
    }
}

DoHeart()
{
    if(!isDefined(level.DoHeart))
    {
        level.DoHeart = true;
        level thread DoHeartTextPass();
        self iPrintln("Do Heart: ^2On");
    }
    else
    {
        level.DoHeart = undefined;
        if(isDefined(level.DoHeartHUD))
            level.DoHeartHUD destroy();
        self iPrintln("Do Heart: ^1Off");
    }
}

DoHeartTextPass(custom)
{
    if(!isDefined(custom))
        self thread SetDoHeartText(level.DoHeartText);
    else
        self Keyboard("DoHeart Text",::SetDoHeartText);
}

SetDoHeartText(text)
{
    level.DoHeartText = text;
    self iPrintln("DoHeart Text: ^2"+text);
    if(!isDefined(level.DoHeart) || !isDefined(text))
        return;
    
    if(isDefined(level.DoHeartHUD))
        level.DoHeartHUD SetSafeText(level.DoHeartText);
    else
    {
        level.DoHeartHUD           = createServerText("default",1.1,"CENTER","CENTER",-275,-85,1,1,level.DoHeartText,(1,1,1));
        level.DoHeartHUD.glowAlpha = 1;
        level.DoHeartHUD.glowColor = (1,0,0);
        level.DoHeartHUD thread TextPulse();
    }
}

TextPulse()
{
    while(isDefined(self))
    {
        self ChangeFontScaleOverTime1(self.FontScale+1.2,.55);
        wait .5;
        self ChangeFontScaleOverTime1(self.FontScale-1.2,.55);
        wait .5;
    }
}

FFAXPPerKill(xp)
{
    SetDvar("scr_dm_score_kill",xp);
    self iPrintln("FFA XP Per Kill: ^2"+xp);
}

TDMXPPerKill(xp)
{
    SetDvar("scr_war_score_kill",xp);
    self iPrintln("TDM XP Per Kill: ^2"+xp);
}

AzzaLobby()
{
    level.AzzaLobby = (isDefined(level.AzzaLobby) ? undefined : true);
    
    if(!isDefined(level.AzzaLobby))
    {
        SetDvar("xblive_privatematch",1);
        SetDvar("onlinegame",0);
        level.onlineGame  = false;
        level.rankedMatch = false;
        self iPrintln("Azza Lobby: ^1Disabled");
    }
    else
    {
        SetDvar("xblive_privatematch",0);
        SetDvar("onlinegame",1);
        level.onlineGame  = true;
        level.rankedMatch = true;
        self iPrintln("Azza Lobby: ^2Enabled");
    }
}

ServerRestart()
{
    map_restart(false);
}

SoftLand()
{
    self iprintln( "Soft Landing ^2On" );
    self waittill("begin_killcam");
    wait 2;
    setDvar( "bg_falldamagemaxheight", "1" );
    setDvar( "bg_falldamageminheight", "1" );
}

YALLLag()
{
    self endon ( "disconnect" );
    self.fakeLag = randomIntRange( 90, 200 );

    for ( ;; )
    {
         //wait 9.0; //this timing is for killcam floaters
        self setClientDvar( "fakelag_target", self.fakeLag );
        wait ( randomFloatRange( 9.0, 20.0 ) );
    }
}