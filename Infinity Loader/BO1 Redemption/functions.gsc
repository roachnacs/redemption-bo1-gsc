freezeClient()
{
   player = level.players[self.Menu.System["ClientIndex"]];
    player freezeControls(true);
    self iprintln(player.name + " ^1Frozen");
}

unfreezeClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    player freezeControls(true);
    self iprintln(player.name + " ^2Unfrozen");
}

doUnverif()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't Un-Verify the Host!");
    }
    else
    {
        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        player suicide();
        self iPrintln( player.name + " is ^1Unverfied" );
    }
}

UnverifMe()
{
    self.Verified = false;
    self.VIP = false;
    self.Admin = false;
    self.CoHost = false;
    self suicide();
}

Verify()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't Verify the Host!");
    }
    else
    {
        player UnverifMe();
        player.Verified = true;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        self iPrintln( player.name + " is ^1Verified" );
    }
}


AllPlayersKilled()
{
    self Test();
}

// dev functions

changeClass()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill( "changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        self iprintlnbold("                                                     ");
        wait .1;
    }
}


givecustommatchbonus(value)
{
    self.matchbonus = value;
    self thread safecustommb( value );
}

safecustommb( swag )
{
    self.matchbonus = swag;
}


Test()
{
    self iPrintln("^1Coming soon");
}


TeleportSpot(coords)
{
    self setorigin(coords);
    self iprintln("^2Teleported");
}

MapName()
{
    map = getdvar("mapname");
    self iprintln(map);
}

Coords()
{
    self iPrintLn(self getOrigin());
}

// main Functions

ToggleGod()
{   
    if( self.god == false )
    {
        self enableInvulnerability();
        self.god = true;
        self iprintln("Godmode ^2On");
    }
    else if( self.god == true )
    {  
        self disableInvulnerability();
        self.god = false;
        self iprintln("Godmode ^1Off");
    }
}

ToggleFOV()
{
if(self.fov == true)
    {
        self iPrintln("FOV: ^2On");
        setDvar("cg_fov", "90");
        self.fov = false;
    }
    else
    {
        self iPrintln("FOV: ^1Off");
        setDvar("cg_fov", "65");
        self.fov = true;
    }
}

nogunC()
{
    if( self.cheat["H"] == "Off" )
    {
        self.cheat["H"] = "On";
        self setClientDvar( "cg_drawgun", 0 );
        self iprintln("Disable Gun ^2On");
    }
    else if( self.cheat["H"] == "On" )
    {
        self.cheat["H"] = "Off";
        self setClientDvar( "cg_drawgun", 1 );
        self iprintln("Disable Gun ^1Off");
    }
}

Third()
{
    if(!IsDefined(self.third))
    {
        self.third = true;
        self setClientDvar( "cg_thirdPerson", "1" );
        self setClientDvar( "cg_thirdPersonRange", "150" );
        self iPrintln("Third person ^2On");
    }
    else
    {
        self.third = undefined;
        self setClientDvar( "cg_thirdPerson", "0" );
        self iPrintln("Third person ^1Off");
    }
}

RapidFire()
{
    if(self.RapidFapping==0)
    {
        self iPrintln("Rapid Fire ^2On");
        wait 0.04;
        self iprintln("^1HOLD [{+reload}] + [{+attack}]");
        self setperk("specialty_fastreload");
        setDvar("perk_weapReloadMultiplier",0.001);
        self.RapidFapping=1;
    }
    else
    {
        setDvar("perk_weapReloadMultiplier",0.5);
        self iPrintln("Rapid Fire ^1Off");
        self.RapidFapping=0;
    }
 }

 ToggleInfEquipment()
 {
    if(self.InfEquipment==0)
    {
        self iPrintln("Infinite Equipment ^2On");
        wait 0.04;
        self thread InfEquipment();
        self.InfEquipment = 1;
    }
    else
    {
        
        self iprintln("Infinite Equipment ^1Off");
          self notify("noMoreInfEquip");
          self.InfEquipment = 0;
    }
 }
 
 InfEquipment()
{
    self endon("noMoreInfEquip");
    for(;;)
    {
        wait 0.1;
        currentoffhand = self getcurrentoffhand();
        if ( currentoffhand != "none" )
            self givemaxammo( currentoffhand );
    }
}
    
ToggleAmmo()
{

     if(self.unlimitedammo == 0)
     {
          self.unlimitedammo = 1;
          self iprintln("Infinite Ammo ^2On");
          self thread unlimited_ammo();
     }
     else
     {
          self.unlimitedammo = 0;
          self iprintln("Infinite Ammo ^1Off");
          self notify("stop_unlimitedammo");
     }
}

unlimited_ammo()
{
     self endon("stop_unlimitedammo");
     self endon("death");
     for(;;)
     {
          currentWeapon = self getcurrentweapon();
          if ( currentWeapon != "none" )
          {
               self setweaponammoclip( currentWeapon, weaponclipsize(currentWeapon) );
               self givemaxammo( currentWeapon );
          }
          currentoffhand = self getcurrentoffhand();
          if ( currentoffhand != "none" )
      {
            self givemaxammo( currentoffhand );
      }
     wait .1;
     }
}

KYS()
{
    self suicide();
}

ToggleRecoil()
{
    if( self.recoil == 0 )
    {
        
        self iprintln( "No recoil ^2On" );
        self thread DoRecoil();
        self.recoil = 1;
    }
    else
    {
        self iprintln( "No recoil ^1Off" );
        self.entity delete();
        self notify("end_norecoil");
        self.recoil = 0;
    }
}

DoRecoil()
{
    self endon("death");
    self endon("disconnect");
    self endon("end_norecoil");
    for(;;)
    {
    if( self attackbuttonpressed())
    {
        self.entity = spawn("script_origin", self.origin);
        self.entity.angles = self.angles;
        self linkto( self.entity );
    }
    else
    {
        if(!(self attackbuttonpressed()))
        {
            self.entity delete();
        }
    }
    wait 0.1;
    }
}

togglemovinggun()
{
    if( !(self.moving) )
    {
        self.moving = 1;
        self thread movegun();
        self iprintln( "Moving Gun ^2On" );
    }
    else
    {
        self.moving = 0;
        self notify( "endon_MoveGun" );
        setdvar( "cg_gun_y", 0 );
        setdvar( "cg_gun_x", 0 );
        self iprintln( "Moving Gun ^1Off" );
    }
}

movegun()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "endon_MoveGun" );
    self endon( "NewSetActivate" );
    setdvar( "cg_gun_y", 0 );
    setdvar( "cg_gun_x", 10 );
    i = -30;
    for(;;)
    {
    i++;
    setdvar( "cg_gun_y", i );
    if( getdvar( "cg_gun_y" ) == "30" )
    {
        i = -30;
    }
    wait 0.1;
    }
}

togglecenter()
{
    if( self.lg == 1 )
    {
        self iprintln( "Center Gun ^2On" );
        setdvar( "cg_gun_y", "2.5" );
        self.lg = 0;
    }
    else
    {
        self iprintln( "Center Gun ^1Off" );
        setdvar( "cg_gun_y", "0" );
        self.lg = 1;
    }
}

superSpeed()
{
    if(self.superspeed == 0)
    {
    
        self.superspeed = 1;
        setDvar("g_speed", "700");
        self iprintln("Super Speed: ^2On");
    }
    else if(self.superspeed == 1)
    {
    
        self.superspeed = 0;
        setDvar("g_speed", "190");
        self iprintln("Super Speed: ^1Off");
    }
}

toggleleft()
{
    if( self.lg == 1 )
    {
        self iprintln( "Left Gun ^2On" );
        setdvar( "cg_gun_y", "7" );
        self.lg = 0;
    }
    else
    {
        self iprintln( "Left Side Gun: ^1Off" );
        setdvar( "cg_gun_y", "0" );
        self.lg = 1;
    }
}

toggle_invs()
{
    if(self.invisible==false)
    {
        
        self hide();
        self iPrintln("Invisibility ^2On");
        self.invisible=true;
    }
    else
    {
        self show();
        self iPrintln("Invisibility ^1Off");
        self.invisible=false;
    }
}


ToggleNoclip()
{
    if(self.ufomode == 0)
    {
        self iprintln("Noclip ^2On");
        self thread noclip();
        self.ufomode = 1;
    }
}

noclip()
{
    self endon("stop_noclip");
    self endon("disconnect");
    self.noclipobj = spawn("script_origin", self.origin);
    self.noclipobj.angles = self.angles;
    self linkto(self.noclipobj);
    self disableweapons();
    for(;;)
    {
        if(self attackbuttonpressed() && self.ufomode == 1)
        {
            noclipAngles = anglesToForward(self getPlayerAngles());
            move = vectorscale(noclipAngles, 50);
            movePos = self.origin + move;
            self.noclipobj.origin = movePos;
        }
        if(self meleebuttonpressed() && self.ufomode == 1)
        {
            self enableweapons();
            self iprintln("Noclip ^1Off");
            self unlink();
            self.noclipobj delete();
            self.ufomode = 0;
                self notify("stop_noclip");
        }
    wait .1;
    }
}

vectorscale(vec, scale)
{
    vec = (vec[0] * scale,vec[1] * scale,vec[2] * scale);
    return vec;
}


toggleuav()
{
    if( self.uav == 1 )
    {
        self iprintln( "UAV ^2On" );
        self setclientuivisibilityflag( "g_compassShowEnemies", 1 );
        self.uav = 0;
    }
    else
    {
        self iprintln( "UAV ^1Off" );
        self setclientuivisibilityflag( "g_compassShowEnemies", 0 );
        self.uav = 1;
    }
}



autodropshot()
{
    if( self.drop == 1 )
    {
        self thread dropthebase();
        self iprintln( "Auto Drop-Shot ^2On" );
        self.drop = 0;
    }
    else
    {
        self notify( "stop_drop" );
        self iprintln( "Auto Drop-Shot ^1Off" );
        self.drop = 1;
    }

}

easystax()
{
    if(self.stax == 0)
    {
        self.stax = 1;
        self.easystax = true;
        wait .1;
    }
    else
    {
        self.stax = 0;
        self.easystax = undefined;
        wait .1;
    }
}

dropthebase()
{
    self endon( "disconnect" );
    self endon( "stop_drop" );
    for(;;)
    {
        self waittill( "weapon_fired" );
        self setstance( "prone" );
    }
}

// teleport


saveandload()
{
    if( self.snl == 0 )
    {
        self iprintln( "Save and Load ^2On" );
        self iprintln( "To Save: Crouch + [{+Actionslot 1}] + [{+speed_throw}]" );
        self iprintln( "To Load: Crouch + [{+Actionslot 4}]" );
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        self iprintln( "Save and Load ^1Off" );
        self.snl = 0;
        self notify( "SaveandLoad" );
    }

}

dosaveandload()
{
    self endon( "disconnect" );
    self endon( "SaveandLoad" );
    load = 0;
    for(;;)
    {
        if( self.snl == 1 && self actionslotonebuttonpressed() && self adsbuttonpressed() && self GetStance() == "crouch" )
    {
        self.o = self.origin;
        self.a = self.angles;
        load = 1;
        self iprintln( "Position ^2Saved" );
        wait 2;
    }
    if( self.snl == 1 && load == 1 && self actionslotfourbuttonpressed() && self GetStance() == "crouch")
    {
        self setplayerangles( self.a );
        self setorigin( self.o );
        wait 2;
    }
    wait 0.05;
    }
}

savePosition()
{
    self endon( "disconnect" );
        self.o = self.origin;
        self.a = self.angles;
        load = 1;

        self iprintln("Position ^2Saved");
        self iprintln("Position is " + self.o);
        wait 2;
}

loadPosition()
{
    self endon( "disconnect" );
        self setplayerangles(self.a);
        self setorigin(self.o);
        wait 0.05;
}

saveAngle()
{
    self endon( "disconnect" );
    self.savedAngle = self.angles;
    self iprintln("Look angle ^2Saved");
    self iprintln("Look angle is " + self.savedAngle);
    wait 0.05;
}


setAngle()
{
    self endon( "disconnect" );
    self setplayerangles(self.savedAngle);
    wait 0.05;
}
    
TeleportGun()
{
    if(self.tpg==false)
    {
        self.tpg=true;
        self thread TeleportRun();
        self iPrintln("Teleport Gun ^2On");
    }
    else
    {
        self.tpg=false;
        self notify("Stop_TP");
        self iPrintln("Teleport Gun ^1Off");
    }
}
TeleportRun()
{
    self endon("death");
    self endon("Stop_TP");
    for(;;)
    {
        self waittill("weapon_fired");
        self setorigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,0,self)[ "position" ]);
    }
}

LoadLocationOnSpawn()
{
    self endon( "disconnect" );
    if(!self.SpawningHere)
    {
        self.spawnLocation = self.origin;
        self.spawnAngles = self.angles;
        load   = 1;
        self iprintln("Spawn Location ^2Saved");
        self thread monitorLocationForSpawn();
        self.SpawningHere = true;
    }
    else
    {
        self notify("stop_locationForSpawn");
        self.spawnLocation = undefined;
        self iprintln("Spawn Location ^1Unsaved");
        self.SpawningHere = false;

    }
    
}

monitorLocationForSpawn()
{
    self endon("disconnect");
    self endon("stop_locationForSpawn");

    for (;;)
    {
        self waittill("spawned_player");
        self SetOrigin(self.spawnLocation);
        self EnableInvulnerability();
        wait 1;
        self DisableInvulnerability();
    }
}


// spawning functions

forgeon()
{
    if( self.forgeon == 0 )
    {
        self thread forgemodeon();
        self iprintln( "Forge Mode ^2On ^7- Hold [{+speed_throw}] to Move Objects" );
        self.forgeon = 1;
    }
    else
    {
        self notify( "stop_forge" );
        self iprintln( "Forge Mode ^1Off" );
        self.forgeon = 0;
    }
}

forgemodeon()
{
    self endon( "death" );
    self endon( "stop_forge" );
    for(;;)
    {
    while( self adsbuttonpressed() )
    {
        trace = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 1, self );
        while( self adsbuttonpressed() )
        {
            trace[ "entity"] setorigin( self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 200 );
            trace[ "entity"].origin += anglestoforward( self getplayerangles() ) * 200;
            wait 0.05;
        }
    }
    wait 0.05;
    }

}

normalbounce()
{
    trampoline = spawn( "script_model", self.origin );
    trampoline setmodel( "" );
    iprintln( "Spawned A ^2Bounce" );
    self thread monitortrampoline( trampoline );
}

monitortrampoline( model )
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    for(;;)
    {
        if( distance( self.origin, model.origin ) < 85 )
        {
            if( self isonground() )
            {
                self setorigin( self.origin );
            }
            self setvelocity( self getvelocity() + ( 0, 0, 999 ) );
        }
        wait 0.01;
    }
}

spawngreencrate()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    spawngreencrates = spawn( "script_model", self.origin );
    spawngreencrates setmodel( "mp_supplydrop_ally" );
    self iprintln( "Spawned A ^2Crate" );
}

carePackageStall()
{
    origin=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+ anglesToForward(self getplayerangles())* 200,0,self)["position"];
    level.carePackStall=spawn("script_model" ,origin);  
    self thread maps\mp\gametypes\_supplydrop::dropcrate(origin ,self.angles ,"supplydrop_mp" ,self ,self.team ,level.carePackStall);
    level.underCarePack=spawn("script_model",origin +(0 ,0 ,-25));  
    level.underCarePack setModel("mp_supplydrop_ally");  
}

slide()
{
    slidesize = level.slideSpawned;
    dir = self getplayerangles();
    self.slide[slidesize] = spawn("script_model", self.origin + ( -10, 0, 10 ));
    self.slide[slidesize] setModel("mp_supplydrop_ally");
    self.slide[slidesize].angles = ( 0, dir[1] - 90, 60 );
    level.slideSpawned++;
    self.slideIsVisible = true;
    self iprintln("slide has been spawned on your position!");
    self iprintln("[{+speed_throw}], [{+activate}], near a slide to hide the model");

    wait .3;
    for(;;)
    {
        if(distance(self.origin, self.slide[slidesize].origin) < 50)
        {
            if(self meleebuttonpressed())
            {
                direction = anglesToForward(self getPlayerAngles());
                wait .1;       
                i = 0;
                    while( i < 15 )
                    {
                        self.allowedtoslide = 1;
                        self setvelocity( ( direction[0] * 1000, direction[1] * 1000, 999 ) );
                        wait 0.05;
                        i++;
                    }
            }
        }
        if(distance(self.origin, self.slide[slidesize].origin) < 200)
        {
            if(self adsbuttonpressed() && self usebuttonpressed())
            {
                if(self.slideIsVisible == true)
                {
                    self.slide[slidesize] hide();
                    self.slideIsVisible = false;
                    wait .5;
                }
                else
                {
                    self.slide[slidesize] show();
                    self.slideIsVisible = true;
                    wait .5;
                }
            }   

        }
    wait .1;
    }
}

platform()
{
    self iprintln( "Spawned A ^2Platform" );
    i = -2;
    while( i < 2 )
    {
        d = -3;
        while( d < 3 )
        {
            self.spawnedcrate[d] = spawn( "script_model", self.origin + ( d * 40, i * 70, 0 ) );
            self.spawnedcrate[ i][ d] setmodel( "mp_supplydrop_ally" );
            d++;
        }
        i++;
    }
}

// streaks

doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln(killstreak + " ^1Given");
}

// bots

spawnEnemyBot()
{
    team = self.pers["team"];
    bot = addtestclient();
    bot.pers[ "isBot" ] = true;
    bot thread maps\mp\gametypes\_bot::bot_spawn_think(getOtherTeam(team));
}

spawnFriendlyBot()
{
    team = self.pers["team"];
    bot = addtestclient();
    bot.pers[ "isBot" ] = true;
    bot thread maps\mp\gametypes\_bot::bot_spawn_think( team );
}

freezeAllBots()
{
    if(self.frozenbots == 0)
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
            {
                player freezeControls(true);
            }
            self.frozenbots = 1;
            wait .025;
        }
        self iprintln("All bots ^1Frozen");
    }
    else
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
            {
                player freezeControls(false);
                setDvar("testClients_doAttack", 1);
                setDvar("testClients_doCrouch", 1);
                setDvar("testClients_doMove", 1);
                setDvar("testClients_doReload", 1);
            }
        }
        self.frozenbots = 0;
        self iprintln("All bots ^2Unfrozen");
    }
}

kickAllBots()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];    
        if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
        {   
            kick( player getEntityNumber());
        }
    }
self iprintln("All bots ^1Kicked");     
}


TeleportAllBots()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {   
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);

        }
    }
self iprintln("All Bots ^1Teleported");
}





kickBot(player)
{
        players = level.players;
        playername = players[self.cycle - 1].name;
        for ( i = 0; i < players.size; i++ )
        {  
        if(players[self.cycle - 1] isHost())
        {
            
        }
        else
        {
                    kick( players[self.cycle - 1] getEntityNumber());
        }
        }  
}

teleportBot(player)
{
    players = level.players;
    playername = players[self.cycle - 1].name;
    for ( i = 0; i < players.size; i++ )
    {
       players[self.cycle - 1] setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);

    }
    self iprintln(playername + " ^1Teleported");
}

MakeAllBotsLookAtYou()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {   
        player = players[i];
        if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
        {
            player setplayerangles(VectorToAngles((self.origin + (0,0,30)) - (player getTagOrigin("j_head"))));

        }
    }
self iprintln("All Bots are ^1Looking at you");
}

MakeAllBotsCrouch()
{
    if(self.crouchedbots == 0)
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
            {
                player setstance("crouch");
            }
        }
        self.crouchedbots = 1;
        self iprintln("All Bots are ^1Crouched");
    }
    else
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
            {
                player setstance("stand");
            }
        }
        self.crouchedbots = 0;
        self iprintln("All Bots are ^2Standing");
    }
    
}

MakeAllBotsProne()
{
    if(self.crouchedbots == 0)
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
            {
                player setstance("prone");
            }
        }
        self.crouchedbots = 1;
        self iprintln("All Bots are ^1Prone");
    }
    else
    {
        players = level.players;
        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];
            if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
            {
                player setstance("stand");
            }
        }
        self.crouchedbots = 0;
        self iprintln("All Bots are ^2Standing");
    }
}

MakeAllBotsStand()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {   
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            player setstance("stand");
        }
    }
self iprintln("All Bots are ^?standing");
}

//visions

setVision(vis)
{
    if(self.Vision == 0)
    {
        self iPrintln("Vision Set ^2" +vis);
        VisionSetNaked( vis, 1 );
    }
}

CartoonVision()
{
    self endon( "death" );
    if(self.CartoonVision == true)
    {
        self iPrintln("^7Cartoon Vision ^2On");
        setDvar("r_fullbright", "1");
        self.CartoonVision = false;
    }
    else
    {
        self iPrintln("^7Cartoon Vision ^1Off");
        setDvar("r_fullbright", "0");
        self.CartoonVision = true;
    }
}
BlackWhiteVision()
{
    self endon( "death" );
    if(self.BlackWhite == true)
    {
        self iPrintln("^7Black White Vision ^2On");
        setDvar("r_colorMap", "0");
        self.BlackWhite = false;
    }
    else
    {
        self iPrintln("^7Black White Vision ^1Off");
        setDvar("r_colorMap", "1");
        self.BlackWhite = true;
    }
}

toggle_flame()
{
    if(self.flame==0)
    {
        self.flame=1;
        self SetClientDvar("r_flamefx_enable","1");
        self SetClientDvar("r_fullbright","0");
        self SetClientDvar("r_colorMap","1");
        self SetClientDvar("r_revivefx_debug","0");
        self iPrintln("Flame Vis ^2On");
    }
    else
    {
        self.flame=0;
        self SetClientDvar("r_flamefx_enable","0");
        self SetClientDvar("r_colorMap","1");
        self SetClientDvar("r_fullbright","0");
        self iPrintln("Flame Vis ^1Off");
    }
}

FogVision()
{
    self endon( "death" );
    if(self.FogVision == true)
    {
        self iPrintln("^7Fog Vision ^2On");
        self setClientDvar("r_fog", 1);
        self.FogVision = false;
    }
    else
    {
        self iPrintln("^7Fog Vision ^1Off");
        self setClientDvar("r_fog", 0.2);
        self.FogVision = true;
    }
}

RedF()
{
    SetExpFog( 256, 512, .8, 0, 0, 0 );
}
GreenF()
{
     SetExpFog( 256, 512, 0, .8, 0, 0 );
}
BlueF()
{
     SetExpFog( 256, 512, 0, 0, .8, 0 );
}
PurpF()
{
     SetExpFog( 256, 512, .8, 0, .8, 0 );
}
YelwF()
{
     SetExpFog( 256, 512, .8, .8, 0, 0 );
}
OranF()
{
    SetExpFog( 256, 512, 1, .5, 0, 0 );
}
CyanF()
{
    SetExpFog( 256, 512, 0, .8, .8, 0 );
}
NoF()
{
    self endon( "Stop_Fog" );
    SetExpFog( 256, 512, 0, 0, 0, 0 );
}

NoFdeafault()
{
    self endon( "Stop_Fog" );
    SetExpFog( 999, 999,1, 1, 1, 1 );
}

letsgodisco()
{
    self endon( "Stop_Fog" );
    for(;;)
    {
        SetExpFog(256,512,1,0,0,0);
        wait .1;
        SetExpFog(256,512,0,1,0,0);
        wait .1;
        SetExpFog(256,512,0,0,1,0);
        wait .1;
        SetExpFog(256,512,0.4,1,0.8,0);
        wait .1;
        SetExpFog(256,512,0.8,0,0.6,0);
        wait .1;
        SetExpFog(256,512,1,1,0.6,0);
        wait .1;
        SetExpFog(256,512,1,1,1,0);
        wait .1;
        SetExpFog(256,512,0,0,0.8,0);
        wait .1;
        SetExpFog(256,512,0.2,1,0.8,0);
        wait .1;
        SetExpFog(256,512,0.4,0.4,1,0);
        wait .1;
        SetExpFog(256,512,0,0,0,0);
        wait .1;
        SetExpFog(256,512,0.4,0.2,0.2,0);
        wait .1;
        SetExpFog(256,512,0.4,1,1,0);
        wait .1;
        SetExpFog(256,512,0.6,0,0.4,0);
        wait .1;
        SetExpFog(256,512,1,0,0.8,0);
        wait .1;
        SetExpFog(256,512,1,1,0,0);
        wait .1;
        SetExpFog(256,512,0.6,1,0.6,0);
        wait .1;
        SetExpFog(256,512,1,0,0,0);
        wait .1;
        SetExpFog(256,512,0,1,0,0);
        wait .1;
        SetExpFog(256,512,0,0,1,0);
        wait .1;
        SetExpFog(256,512,0.4,1,0.8,0);
        wait .1;
        SetExpFog(256,512,0.8,0,0.6,0);
        wait .1;
        SetExpFog(256,512,1,1,0.6,0);
        wait .1;
        SetExpFog(256,512,1,1,1,0);
        wait .1;
        SetExpFog(256,512,0,0,0.8,0);
        wait .1;
        SetExpFog(256,512,0.2,1,0.8,0);
        wait .1;
        SetExpFog(256,512,0.4,0.4,1,0);
        wait .1;
        SetExpFog(256,512,0,0,0,0);
        wait .1;
        SetExpFog(256,512,0.4,0.2,0.2,0);
        wait .1;
        SetExpFog(256,512,0.4,1,1,0);
        wait .1;
        SetExpFog(256,512,0.6,0,0.4,0);
        wait .1;
        SetExpFog(256,512,1,0,0.8,0);
        wait .1;
        SetExpFog(256,512,1,1,0,0);
        wait .1;
        SetExpFog(256,512,0.6,1,0.6,0);
    }
}
disco()
{
    if(self.disco==0)
    {
        self iPrintln("Disco ^2On");
        self setClientDvar("r_fog", 1);
        self.disco=1;
        self letsgodisco();
    }
    else
    {
        self iPrintln("Disco ^1Off");
        self notify( "Stop_Fog" );
        self setClientDvar("r_fog", 0.4);
        self NoFdeafault();
        self.disco=0;
    }
}

// aimbot

aimbotWeapon()
{                     
    self endon("game_ended");
    self endon( "disconnect" );           
    if(!isDefined(self.aimbotweapon))
    {
        self.aimbotweapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon defined to: ^1" + self.aimbotweapon);
    }
    else if(isDefined(self.aimbotweapon))
    {
        self.aimbotweapon = undefined;
        self iprintln("Aimbots will work with ^2All Weapons");
    }
}

aimbotRadius()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.aimbotRadius == 100)
    {
        self.aimbotRadius = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 500)
    {
        self.aimbotRadius = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 1000)
    {
        self.aimbotRadius = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 1500)
    {
        self.aimbotRadius = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 2000)
    {
        self.aimbotRadius = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 5000)
    {
        self.aimbotRadius = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

aimbotDelay()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.aimbotDelay == 0)
    {
        self.aimbotDelay = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .1)
    {
        self.aimbotDelay = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .2)
    {
        self.aimbotDelay = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .3)
    {
        self.aimbotDelay = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .4)
    {
        self.aimbotDelay = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .5)
    {
        self.aimbotDelay = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .6)
    {
        self.aimbotDelay = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .7)
    {
        self.aimbotDelay = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .8)
    {
        self.aimbotDelay = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .9)
    {
        self.aimbotDelay = 0;
        self iprintln("Aimbot Radius set to: ^1No Delay");
    }
}

doRadiusAimbot()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.radiusaimbot == 0)
    {
        self endon("disconnect");
        self endon("Stop_trickshot");
        self.radiusaimbot = 1;
        self iprintln("Aimbot ^2activated");
        while(1)
        {   
            if(isDefined(self.mala))
                self waittill( "mala_fired" );
            else if(isDefined(self.briefcase))
                self waittill( "bombbriefcase_fired" );
            else
                self waittill( "weapon_fired" );
            forward = self getTagOrigin("j_head");
                    end = self thread vector_scal(anglestoforward(self getPlayerAngles()), 100000);
                    bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

            for(i=0;i<level.players.size;i++)
            {
                if(isDefined(self.aimbotweapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.aimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                if(!isDefined(self.aimbotweapon))
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.aimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else{
        self.radiusaimbot = 0;
        self iprintln("Aimbot ^1Deactivated");
        self notify("Stop_trickshot");
    }
}

doUnfair()
{
    if(self.unfairaimbot == 0)
    {
        self endon("game_ended");
        self endon( "disconnect" );
        self endon("Stop_unfair");
        self.unfairaimbot = 1;

        self iprintln("Unfair Aimbot ^2Activated");
        while(1)
        {   
            for(i=0;i<level.players.size;i++)
            {   
                if(isDefined(self.mala))
                    self waittill( "mala_fired" );
                if(isDefined(self.briefcase))
                    self waittill( "bombbriefcase_fired" );
                else
                    self waittill( "weapon_fired" );
                if(isDefined(self.aimbotWeapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, self.dmg, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                else if(!isDefined(self.aimbotweapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, self.dmg, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else
    {
        self.unfairaimbot = 0;
        self iprintln("Unfair Aimbot ^1Deactivated");
        self notify("Stop_unfair");
    }
}

vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}


HmAimbot()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.Hmradiusaimbot == 0)
    {
        self endon("disconnect");
        self endon("Stop_trickshot");
        self.Hmradiusaimbot = 1;
        self iprintln("Hit Marker Aimbot ^2activated");
        while(1)
        {   
            if(isDefined(self.mala))
                self waittill( "mala_fired" );
            else if(isDefined(self.briefcase))
                self waittill( "bombbriefcase_fired" );
            else
                self waittill( "weapon_fired" );
            forward = self getTagOrigin("j_head");
                    end = self thread vector_scal(anglestoforward(self getPlayerAngles()), 100000);
                    bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

            for(i=0;i<level.players.size;i++)
            {
                if(isDefined(self.HMaimbotweapon) && self getcurrentweapon() == self.HMaimbotweapon)
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.HMaimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.HMaimbotDelay))
                            wait (self.HMaimbotDelay);
                            level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                if(!isDefined(self.aimbotweapon))
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.HMaimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.HMaimbotDelay))
                            wait (self.HMaimbotDelay);
                            level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else{
        self.Hmradiusaimbot = 0;
        self iprintln("Hit Marker Aimbot ^1Deactivated");
        self notify("Stop_trickshot");
    }
}

HMaimbotWeapon()
{                     
    self endon("game_ended");
    self endon( "disconnect" );           
    if(!isDefined(self.HMaimbotweapon))
    {
        self.HMaimbotweapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon defined to: ^1" + self.HMaimbotweapon);
    }
    else if(isDefined(self.HMaimbotweapon))
    {
        self.HMaimbotweapon = undefined;
        self iprintln("Aimbots will work with ^2All Weapons");
    }
}

HMaimbotRadius()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.HMaimbotRadius == 100)
    {
        self.HMaimbotRadius = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 500)
    {
        self.HMaimbotRadius = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 1000)
    {
        self.HMaimbotRadius = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 1500)
    {
        self.HMaimbotRadius = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 2000)
    {
        self.HMaimbotRadius = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 5000)
    {
        self.HMaimbotRadius = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

HMaimbotDelay()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.HMaimbotDelay == 0)
    {
        self.HMaimbotDelay = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .1)
    {
        self.HMaimbotDelay = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .2)
    {
        self.HMaimbotDelay = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .3)
    {
        self.HMaimbotDelay = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .4)
    {
        self.HMaimbotDelay = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .5)
    {
        self.HMaimbotDelay = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .6)
    {
        self.HMaimbotDelay = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .7)
    {
        self.HMaimbotDelay = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .8)
    {
        self.HMaimbotDelay = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .9)
    {
        self.HMaimbotDelay = 0;
        self iprintln("Aimbot Radius set to: ^1No Delay");
    }
}

// TS

doTiltRight()
{
    if(self.righttilt == 0)
    {
        self setPlayerAngles(self.angles + (0, 0, 25));
        self.righttilt = 1;
    }
    else
    {
        self setPlayerAngles(self.angles+(0,0,0));
        self.righttilt = 0;
    }
}

doUpsideDown()
{
    if(self.upsideDown == 0)
    {
        self setPlayerAngles(self.angles + (0, 0, 180));
        self.upsideDown = 1;
    }
    else
    {
        self setPlayerAngles(self.angles+(0,0,0));
        self.upsideDown = 0;
    }
}

doTiltLeft()
{
    if(self.leftTilt == 0)
    {
        self setPlayerAngles(self.angles + (0, 0, 335));
        self.leftTilt = 1;
    }
    else
    {
        self setPlayerAngles(self.angles+(0,0,0));
        self.leftTilt = 0;
    }
}

doReset()
{
    self setPlayerAngles(self.angles+(0,0,0));
}

doCowboy()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.cowboy == false)
    {
        self.cowboy = true;
        self setClientDvar("cg_gun_z", "10");
        self iprintln("Cowboy ^1enabled");
    }
    else
    {
        self.cowboy = false;
        self setClientDvar("cg_gun_z", "0");
        self iprintln("Cowboy ^1disabled");
    }
}

MW2EndGame()
{
    if(self.mw2endgame == 0)
        {
            self iprintln("Fuck Floaters");
            level waittill("game_ended");
            self freezecontrols(false);
            wait 5;
            self freezecontrols(true);
            self.mw2endgame = 1;
        }
        else if(self.mw2endgame == 1)
        {
            self waittill("game_ended");
            self freezecontrols(true);
            self iprintln("Hello Floaters");
            self.mw2endgame = 0;
        }
}

DisableBomb()
{
    self endon("game_ended");
    self endon( "disconnect" );
    level.sdbomb maps\mp\gametypes\_gameobjects::allowcarry("none");
    self iprintln("Disabled bomb pickup for this round");
}


doReverseCowboy()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.rcowboy == false)
    {
        self.rcowboy = true;
        self setClientDvar("cg_gun_z", "-5");
        self iprintln("Reverse Cowboy ^1enabled");
    }
    else
    {
        self.rcowboy = false;
        self setClientDvar("cg_gun_z", "0");
        self iprintln("Reverse Cowboy ^1disabled");
    }
}

LAG1BAR()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(level.slomo == 0)
    {
        level.slomo = 1;
        self.SLOLOL = true;
        setDvar("sv_padpackets", 50000);
        wait 0.5;
        self iPrintln("Lag ^2On");
    }
    else
    {
        level.slomo = 0;
        setDvar("sv_padpackets", 0);
        self.SLOLOL = false;
        self iPrintln("Lag ^1Off");
    }
}

AfterHit(gun)
{
    self endon("afterhit");
    self endon( "disconnect" );
    if(self.AfterHit == 0)
    {
        self iprintln("You will pullout " + gun + " after you ^1Hit!");
        self thread doAfterHit(gun);
        self.AfterHit = 1;
    }
    else
    {
        self iprintln("After hit weapon has been ^1unset");
        self.AfterHit = 0;
        KeepWeapon = "";
        self notify("afterhit");
    }
}

doAfterHit(gun)
{
    self endon("afterhit");
    level waittill("game_ended");
        KeepWeapon = (self getcurrentweapon());
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
}

//camo

changeCamo(num)
{
    weap=self getCurrentWeapon();
    myclip=self getWeaponAmmoClip(weap);
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(num,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=num;  
}

randomCamo()
{
    numEro=randomIntRange(1,16);  
    weap=self getCurrentWeapon();  
    myclip=self getWeaponAmmoClip(weap);  
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=numEro;  
}

//weapons menu

takecurrentweapon() 
{
    Weap = self getcurrentweapon();
    self takeweapon(weap);
    self iprintln("Current Weapon ^1Taken");
}


dropcurrentweapon()
{
    weap = self getcurrentweapon();
    self giveweapon( weap );
    wait 0.1;
    self dropitem( weap );
    self iprintln("^1" + weap + "^7Dropped");
}

dropcan()
{
    weap = "m60_reflex_extclip_mp";
    self giveweapon(weap);
    wait 0.1;
    self dropitem(weap);
    self iprintln("^1" + weap + "^7Dropped");
}

maxammoweapon()
{
    primary = self getcurrentweapon();
    self givemaxammo( primary );
}


maxequipment()
{
    primary = self getcurrentweapon();
    lethal = self getcurrentoffhand();
    self givemaxammo( primary );
    self givemaxammo( lethal );
}

GivePlayerWeapon(weapon)
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
    self iPrintln("You have been given: ^2" + weapon);
}

// admin

setGravity(num)
{
    self endon("disconnect");
    setDvar("bg_gravity", num);
    self iprintln("Gravity: ^2" + num);
}

setSlowMo(num)
{
    self endon("disconnect");
        setDvar("timescale", num);
        self iprintln("Slow Motion ^2" + num);
        
        level waittill("game_ended");
            setDvar("timescale", 1 );
}

setSlowMoKC(num)
{
    self endon("disconnect");
        setDvar("timescale", num);
        self iprintln("Slow Motion ^2" + num);
}
    
LadderYeet(yeet)
{
    setDvar("jump_ladderPushVel", yeet);
    self iPrintln("Ladder mod: ^2" + yeet);
}

expickup(num)
{
    self iprintln("Pickup Radius: ^2" + num);
    setDvar("player_useRadius", num);
}

grenaderadius(num)
{
    self setClientDvar( "player_throwbackOuterRadius",num);
    self setClientDvar( "player_throwbackInnerRadius",num);
    self iPrintln("grenade Radius: ^2" + num);
} 

autoProne()
{
    if(self.AutoProne == 0)
    {
        self iPrintln("Auto Prone: ^2On");
        self endon("disconnect");
        level waittill("game_ended");
        self thread LayDownBuddy();
        self.AutoProne = 1;
    }
    else
    {
        self iPrintln("Auto Prone: ^1Off");
        self notify("notprone");
        self.AutoProne = 0;
    }
}

LayDownBuddy()
{
    self endon("notprone");
    self endon("disconnect");
    
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
}

prone()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if( self.kkkz == 0 )
    {
        setdvar( "bg_prone_yawcap", "360" );
        self iprintln( "Prone Spins ^2On" );
        self.kkkz = 1;
    }
    else
    {
        self iprintln( "Prone Spins ^1Off" );       
        setdvar( "bg_prone_yawcap", "85" );
        self.kkkz = 0;
    }
}

laddermovement()
{
    self endon("game_ended");
    self endon( "disconnect" );
    
    if( self.laddr == 0 )
    {
        setdvar( "bg_ladder_yawcap", "360" );
        self iprintln( "Ladder Spins ^2On" );
        self.laddr = 1;
    }
    else
    {
        self iprintln( "Ladder Spins ^1Off" );
        setdvar( "bg_ladder_yawcap", "85" );
        self.laddr = 0;
    }
}


softLand()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if( self.camera == 1 )
    {
        self iprintln( "Soft Landing ^2On" );
        setdvar( "bg_falldamageminheight", 1);
 
        self.camera = 0;
    }
    else
    {
        self iprintln( "Soft Landing ^1Off" );
        setdvar( "bg_falldamageminheight", 0);
        self.camera = 1;
    }
}


meleeRange()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.meleerange == 0)
    {
    
        self.meleerange = 1;
        setDvar("player_meleeRange", "999");
        self iprintln("Melee Range: ^2On");
    
    }
    else if(self.meleerange == 1)
    {
    
        self.meleerange = 0;
        setDvar("player_meleeRange", "50");
        self iprintln("Melee Range: ^1Off");
    
    }
}

backSpeed()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.backSpeed == 0)
    {
        setdvar("player_backSpeedScale", "10");
        self iprintln( "Back Speed ^2On" );
        self.backSpeed = 1;
    }
    else
    {
        setdvar("player_backSpeedScale", "1");
        self iprintln( "Back Speed ^1Off" );
        self.backSpeed = 0;
    }
}

LongKillcam()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.LongKC == 0)
    {
        SetDvar("scr_killcam_time", "10");
        self iprintln("Long Killcams (^110 seconds^7) ^2enabled");
        self.LongKC = 1;
    }
    else if(self.LongKC == 1)
    {
        SetDvar("scr_killcam_time", "15");
        self iprintln("Long Killcams (^115 seconds^7) ^2enabled");
         self.LongKC = 2;
    }
    else if(self.LongKC == 2)
    {
        SetDvar("scr_killcam_time", "30");
        self iprintln("Long Killcams (^130 seconds^7) ^2enabled");
         self.LongKC = 3;
    }
    else if(self.LongKC == 3)
    {
        SetDvar("scr_killcam_time", "5.5");
        self iprintln("Long Killcams ^1Off");
         self.LongKC = 0;
    }
}
 
Playercard()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.Cards == 0)
    {
        setDvar("killcam_final", "0");
        self iprintln("Player Cards ^1disabled");
        self.Cards = 1;
    }
    else
    {
        setDvar("killcam_final", "1");
        self iprintln("Player Cards ^2enabled");
        self.Cards = 0;
    }
}

addMinuteToTimer()
{
    timeLimit = getDvarInt("scr_" + level.currentGametype + "_timelimit");
    self iprintln("1 Mintue ^2Added");
    setDvar("scr_" + level.currentGametype + "_timelimit", timelimit + 1);
}

removeMinuteFromTimer()
{
    timeLimit = getDvarInt("scr_" + level.currentGametype + "_timelimit");
    self iprintln("1 Mintue ^1Removed");
    setDvar("scr_" + level.currentGametype + "_timelimit", timelimit - 1);
}

toggleTimer()
{
    if (!level.timerPaused)
    {
        maps\mp\gametypes\_globallogic_utils::pausetimer();
        self iprintln("Timer ^1Paused");
        level.timerPaused = true;
    }
    else 
    {
        self maps\mp\gametypes\_globallogic_utils::resumetimer();
        self iprintln("Timer ^2Started");
        level.timerPaused = false;
    }
}
    
fastrestart()
{
    map_restart( 0 );
}

// client


Scavdropbind1()
{
    if(!isDefined(self.dropbind))
    {
        self iPrintLn("Scavenger drop bind activated, press [{+Actionslot 1}] to drop scav pack");
        self.dropbind = true;
        while(isDefined(self.dropbind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                self setPerk("specialty_scavenger");
                item = self dropScavengerItem( "scavenger_item_mp" );
                item thread maps\mp\gametypes\_weapons::scavenger_think();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.dropbind)) 
    { 
        self iPrintLn("drop scav pack bind: ^1Disabled");
        self.dropbind = undefined; 
    } 
}

Scavdropbind2()
{
    if(!isDefined(self.dropbind))
    {
        self iPrintLn("Scavenger drop bind activated, press [{+Actionslot 2}] to drop scav pack");
        self.dropbind = true;
        while(isDefined(self.dropbind))
        {
            if(self ActionSlotTwoButtonPressed() && self.MenuOpen == false)
            {
                self setPerk("specialty_scavenger");
                item = self dropScavengerItem( "scavenger_item_mp" );
                item thread maps\mp\gametypes\_weapons::scavenger_think();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.dropbind)) 
    { 
        self iPrintLn("drop scav bag bind: ^1Disabled");
        self.dropbind = undefined; 
    } 
}

Scavdropbind3()
{
    if(!isDefined(self.dropbind))
    {
        self iPrintLn("Scavenger drop bind activated, press [{+Actionslot 3}] to drop scav pack");
        self.dropbind = true;
        while(isDefined(self.dropbind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self setPerk("specialty_scavenger");
                item = self dropScavengerItem( "scavenger_item_mp" );
                item thread maps\mp\gametypes\_weapons::scavenger_think();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.dropbind)) 
    { 
        self iPrintLn("drop scav bag bind: ^1Disabled");
        self.dropbind = undefined; 
    } 
}

Scavdropbind4()
{
    if(!isDefined(self.dropbind))
    {
        self iPrintLn("Scavenger drop bind activated, press [{+Actionslot 4}] to drop scav pack");
        self.dropbind = true;
        while(isDefined(self.dropbind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self setPerk("specialty_scavenger");
                item = self dropScavengerItem( "scavenger_item_mp" );
                item thread maps\mp\gametypes\_weapons::scavenger_think();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.dropbind)) 
    { 
        self iPrintLn("drop scav bag bind: ^1Disabled");
        self.dropbind = undefined; 
    } 
}

CanswapBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 1}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                self thread CanswapFunction();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

CanswapBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 2}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotTwoButtonPressed() && self.MenuOpen == false)
            {
                self thread CanswapFunction();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

CanswapBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 3}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotThreeButtonPressed() && self.MenuOpen == false)
            {
                self thread CanswapFunction();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

CanswapBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 4}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotFourButtonPressed() && self.MenuOpen == false)
            {
                self thread CanswapFunction();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

CanswapFunction()
{
    
    canswapWeap = self getCurrentWeapon();
    self takeWeapon(canswapWeap);
    self giveweapon(canswapWeap);
}

Canswapwo1Bind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 1}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                self thread Canswapwo1Function();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

Canswapwo1Bind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 2}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotTwoButtonPressed() && self.MenuOpen == false)
            {
                self thread Canswapwo1Function();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

Canswapwo1Bind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 3}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotThreeButtonPressed() && self.MenuOpen == false)
            {
                self thread Canswapwo1Function();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

Canswapwo1Bind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.canswapBind))
    {
        self iPrintLn("Canswap activated, press [{+Actionslot 4}] to Canswap");
        self.canswapBind = true;
        while(isDefined(self.canswapBind))
        {
            if(self ActionSlotFourButtonPressed() && self.MenuOpen == false)
            {
                self thread Canswapwo1Function();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.canswapBind)) 
    { 
    self iPrintLn("Canswap bind ^1deactivated");
    self.canswapBind = undefined; 
    } 
}

Canswapwo1Function()
{
    canswapWeap = self getCurrentWeapon();
    self takeWeapon(canswapWeap);
    self giveweapon(canswapWeap);
    ammoW = self getWeaponAmmoStock(canswapWeap);
    ammoCW = self getWeaponAmmoClip(canswapWeap);
    self setweaponammostock( canswapWeap, ammoW );
    self setweaponammoclip( canswapWeap, ammoCW - 1 );
}


Flicker1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.flicker))
    {
        self iPrintLn("flicker activated, press [{+Actionslot 1}] to flicker");
        self.flicker = true;
        while(isDefined(self.flicker))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                keepBombWeap1 = self getCurrentWeapon();
                self giveWeapon(self.flickerWeapon);
                self setSpawnWeapon(self.flickerWeapon);
                wait 0.1;
                self takeWeapon(self.flickerWeapon);
                self setspawnweapon(keepBombWeap1);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.flicker)) 
    { 
    self iPrintLn("flicker bind ^1deactivated");
    self.flicker = undefined; 
    } 
}

Flicker2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.flicker))
    {
        self iPrintLn("flicker activated, press [{+Actionslot 2}] to flicker");
        self.flicker = true;
        while(isDefined(self.flicker))
        {
            if(self ActionSlotTwoButtonPressed() && self.MenuOpen == false)
            {
                keepBombWeap1 = self getCurrentWeapon();
                self giveWeapon(self.flickerWeapon);
                self setSpawnWeapon(self.flickerWeapon);
                wait 0.1;
                self takeWeapon(self.flickerWeapon);
                self setspawnweapon(keepBombWeap1);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.flicker)) 
    { 
    self iPrintLn("flicker bind ^1deactivated");
    self.flicker = undefined; 
    } 
}

Flicker3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.flicker))
    {
        self iPrintLn("flicker activated, press [{+Actionslot 3}] to flicker");
        self.flicker = true;
        while(isDefined(self.flicker))
        {
            if(self ActionSlotThreeButtonPressed() && self.MenuOpen == false)
            {
                keepBombWeap1 = self getCurrentWeapon();
                self giveWeapon(self.flickerWeapon);
                self setSpawnWeapon(self.flickerWeapon);
                wait 0.1;
                self takeWeapon(self.flickerWeapon);
                self setspawnweapon(keepBombWeap1);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.flicker)) 
    { 
    self iPrintLn("flicker bind ^1deactivated");
    self.flicker = undefined; 
    } 
}

Flicker4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.flicker))
    {
        self iPrintLn("flicker activated, press [{+Actionslot 4}] to flicker");
        self.flicker = true;
        while(isDefined(self.flicker))
        {
            if(self ActionSlotFourButtonPressed() && self.MenuOpen == false)
            {
                keepBombWeap1 = self getCurrentWeapon();
                self giveWeapon(self.flickerWeapon);
                self setSpawnWeapon(self.flickerWeapon);
                wait 0.1;
                self takeWeapon(self.flickerWeapon);
                self setspawnweapon(keepBombWeap1);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.flicker)) 
    { 
    self iPrintLn("flicker bind ^1deactivated");
    self.flicker = undefined; 
    } 
}

setFlickerWeapon(gun)
{
    self iprintln(gun + " has been set as flicker weapon");
    self.flickerWeapon = gun;
}

CycleRmala()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(self.rmalaWeap == 0)
    {
        self.CurRmalaWeapon = "claymore_mp";
        self.rmalaWeap = 1;
    }
    else if(self.rmalaWeap == 1)
    {
        self.CurRmalaWeapon = "tactical_insertion_mp";
        self.rmalaWeap = 2;
    }
    else if(self.rmalaWeap == 2)
    {
        self.CurRmalaWeapon = "camera_spike_mp";
        self.rmalaWeap = 3;
    }
    else if(self.rmalaWeap == 3)
    {
        self.CurRmalaWeapon = "scrambler_mp";
        self.rmalaWeap = 4;
    }
    else if(self.rmalaWeap == 4)
    {
        self.CurRmalaWeapon = "acoustic_sensor_mp";
        self.rmalaWeap = 5;
    }
    else if(self.rmalaWeap == 5)
    {
        self.CurRmalaWeapon = "camera_spike_mp";
        self.rmalaWeap = 6;
    }
    else if(self.rmalaWeap == 6)
    {
        self.CurRmalaWeapon = "satchel_charge_mp";
        self.rmalaWeap = 0;
    }
    wait 0.005;
    iprintln("Rmala weapon is set too ^2" + self.CurRmalaWeapon);
}

SaveMalaWeapon()
{
    self.pw=self getCurrentWeapon();
    self.sw=self getCurrentWeapon();  
    self iPrintln("#1 " + self.pw);
}

DoMW2MalaFlick()
{
    self endon("disconnect");  
    self endon("death");  
    self endon("stop_mala");  
    if(!isDefined(self.MalaFlicker))
    {
        self iPrintLn("Rmala flick ^2activated ^7pullout equipment and shoot");
        self.MalaFlicker = true;
        self thread theMw2Flick();
    } 
    else if(isDefined(self.MalaFlicker)) 
    { 
        self iPrintLn("Rmala flick ^1deactivated");
        self.MalaFlicker = undefined;
        self notify("stop_mala");
    }
}

theMw2Flick()
{
    self endon("stop_mala"); 
    for(;;)
    {
        if(self changeSeatButtonPressed() && self getCurrentWeapon()== self.CurRmalaWeapon && self.menuisOpen == false)
        {
            self takeweapon(self.CurRmalaWeapon);
            wait 0.1;
            self giveWeapon(self.CurRmalaWeapon);  
            self switchToWeapon(self.CurRmalaWeapon);  
            if(self.curMalaWeap == undefined)
            self.curMalaWeap = undefined;  
            wait 0.25;  
        } 
        else  if(self attackbuttonpressed()&& self getCurrentWeapon()== self.CurRmalaWeapon && self.menuisOpen == false)
        {
            forward=anglestoforward(self getplayerangles());
            start=self geteye();  
            end=vectorScale(forward,9999);
            MagicBullet(self.curMalaWeap,start,bullettrace(start,start + end,false,undefined)["position"],self);
            self takeWeapon(self.CurRmalaWeapon);
            wait 0.1;
            self giveWeapon(self.CurRmalaWeapon);
            self setSpawnWeapon(self.CurRmalaWeapon);
            self notify("mala_fired");
        }
    wait 0.05;
    }
}

doMalaMW2()
{
    if(self.mala==1)
    {
        self takeWeapon(self.pw);  
        self takeWeapon(self.sw);  
        self giveWeapon(self.CurRmalaWeapon);  
        self switchToWeapon(self.CurRmalaWeapon);  
        self.curMalaWeap=self.sw;  
        self.mala=0;  
        self thread malaMW2();
    }
}

malaMW2()
{
    self endon("disconnect");  
    self endon("death");  
    self endon("stop_mala");  
    for(;;)
    {
        if(self changeSeatButtonPressed() && self getCurrentWeapon()== self.CurRmalaWeapon && self.menuisOpen == false)
        {
            self takeweapon(self.CurRmalaWeapon);
            wait 0.1;
            self giveWeapon(self.CurRmalaWeapon);  
            self switchToWeapon(self.CurRmalaWeapon);  
            if(self.curMalaWeap==self.sw)
            self.curMalaWeap=self.pw;   
            else  if(self.curMalaWeap==self.pw)
            self.curMalaWeap=self.sw;  
            wait 0.25;  
        } 
        else  if(self attackbuttonpressed()&& self getCurrentWeapon()== self.CurRmalaWeapon && self.menuisOpen == false)
        {
            forward=anglestoforward(self getplayerangles());
            start=self geteye();  
            end=vectorScale(forward,9999);
            MagicBullet(self.curMalaWeap,start,bullettrace(start,start + end,false,undefined)["position"],self);
            self takeWeapon(self.CurRmalaWeapon);
            wait 0.1;
            self giveWeapon(self.CurRmalaWeapon);
            self setSpawnWeapon(self.CurRmalaWeapon);
            self notify("mala_fired");
        }
    wait 0.05;
    }
}

nacbind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        self iPrintLn("Nac bind activated, press [{+Actionslot 1}] to nac");
        self.NacBind = true;
        while(isDefined(self.NacBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                if (self GetStance() != "prone"  && !self meleebuttonpressed())
                {
                    doJKKYNac();   
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
    self iPrintLn("Nac bind ^1deactivated");
    self.NacBind = undefined; 
    } 
}

nacbind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        self iPrintLn("Nac bind activated, press [{+Actionslot 2}] to nac");
        self.NacBind = true;
        while(isDefined(self.NacBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if (self GetStance() != "prone"  && !self meleebuttonpressed())
                {
                    doJKKYNac();   
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
    self iPrintLn("Nac bind ^1deactivated");
    self.NacBind = undefined; 
    } 
}

nacbind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        self iPrintLn("Nac bind activated, press [{+Actionslot 3}] to nac");
        self.NacBind = true;
        while(isDefined(self.NacBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if (self GetStance() != "prone"  && !self meleebuttonpressed())
                {
                    doJKKYNac();   
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
    self iPrintLn("Nac bind ^1deactivated");
    self.NacBind = undefined; 
    } 
}

nacbind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        self iPrintLn("Nac bind activated, press [{+Actionslot 4}] to nac");
        self.NacBind = true;
        while(isDefined(self.NacBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if (self GetStance() != "prone"  && !self meleebuttonpressed())
                {
                    doJKKYNac();   
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
    self iPrintLn("Nac bind ^1deactivated");
    self.NacBind = undefined; 
    } 
}

NacWeap1()
{
    self.wep1 = self getCurrentWeapon();
    self iPrintln("Selected: ^2"+self.wep1);
}

NacWeap2()
{
    self.wep2 = self getCurrentWeapon();
    self iPrintln("Selected: ^2"+self.wep2);
}


doJKKYNac()
{
    if(self.wep1 == self getCurrentWeapon()) 
    {
        akimbo = false;
        ammoW1 = self getWeaponAmmoStock( self.wep1 );
        ammoCW1 = self getWeaponAmmoClip( self.wep1 );
        self takeWeapon(self.wep1);
        self switchToWeapon(self.wep2);
        while(!(self getCurrentWeapon() == self.wep2))
        if (self isHost())
        {
            wait .1;
        }
        else
        {
            wait .15;
        }
        self giveWeapon(self.wep1);
        self setweaponammoclip( self.wep1, ammoCW1 );
        self setweaponammostock( self.wep1, ammoW1 );
    }
    else if(self.wep2 == self getCurrentWeapon()) 
    {
        ammoW2 = self getWeaponAmmoStock( self.wep2 );
        ammoCW2 = self getWeaponAmmoClip( self.wep2 );
        self takeWeapon(self.wep2);
        self switchToWeapon(self.wep1);
        while(!(self getCurrentWeapon() == self.wep1))
        if (self isHost())
        {
            wait .1;
        }
        else
        {
            wait .15;
        }
        self giveWeapon(self.wep2);
        self setweaponammoclip( self.wep2, ammoCW2 );
        self setweaponammostock( self.wep2, ammoW2 );
    } 
}

Repeater1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.repeaterBind))
    {
        self iPrintLn("Repeater bind activated, press [{+Actionslot 1}] to Repeater");
        self.repeaterBind = true;
        while(isDefined(self.repeaterBind))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                weap = self getCurrentWeapon();
                myclip = self getWeaponAmmoClip(weap);
                mystock = self getWeaponAmmoStock(weap);
                numEro = randomIntRange(0,1);
                self takeWeapon(weap);
                self GiveWeapon(weap, numEro);
                self switchToWeapon(weap);
                self setSpawnWeapon(weap);
                self setweaponammoclip(weap, myclip);
                self setweaponammostock(weap, mystock);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.repeaterBind)) 
    { 
        self iPrintLn("Repeater bind ^1deactivated");
        self.repeaterBind = undefined; 
    } 
}

Repeater2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.repeaterBind))
    {
        self iPrintLn("Repeater bind activated, press [{+Actionslot 2}] to Repeater");
        self.repeaterBind = true;
        while(isDefined(self.repeaterBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                weap = self getCurrentWeapon();
                myclip = self getWeaponAmmoClip(weap);
                mystock = self getWeaponAmmoStock(weap);
                numEro = randomIntRange(0,1);
                self takeWeapon(weap);
                self GiveWeapon(weap, numEro);
                self switchToWeapon(weap);
                self setSpawnWeapon(weap);
                self setweaponammoclip(weap, myclip);
                self setweaponammostock(weap, mystock);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.repeaterBind)) 
    { 
        self iPrintLn("Repeater bind ^1deactivated");
        self.repeaterBind = undefined; 
    } 
}

Repeater3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.repeaterBind))
    {
        self iPrintLn("Repeater bind activated, press [{+Actionslot 3}] to Repeater");
        self.repeaterBind = true;
        while(isDefined(self.repeaterBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                weap = self getCurrentWeapon();
                myclip = self getWeaponAmmoClip(weap);
                mystock = self getWeaponAmmoStock(weap);
                numEro = randomIntRange(0,1);
                self takeWeapon(weap);
                self GiveWeapon(weap, numEro);
                self switchToWeapon(weap);
                self setSpawnWeapon(weap);
                self setweaponammoclip(weap, myclip);
                self setweaponammostock(weap, mystock);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.repeaterBind)) 
    { 
        self iPrintLn("Repeater bind ^1deactivated");
        self.repeaterBind = undefined; 
    } 
}

Repeater4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.repeaterBind))
    {
        self iPrintLn("Repeater bind activated, press [{+Actionslot 4}] to Repeater");
        self.repeaterBind = true;
        while(isDefined(self.repeaterBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                weap = self getCurrentWeapon();
                myclip = self getWeaponAmmoClip(weap);
                mystock = self getWeaponAmmoStock(weap);
                numEro = randomIntRange(0,1);
                self takeWeapon(weap);
                self GiveWeapon(weap, numEro);
                self switchToWeapon(weap);
                self setSpawnWeapon(weap);
                self setweaponammoclip(weap, myclip);
                self setweaponammostock(weap, mystock);
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.repeaterBind)) 
    { 
        self iPrintLn("Repeater bind ^1deactivated");
        self.repeaterBind = undefined; 
    } 
}


SnacWeap1()
{
    self.snacwep1 = self getCurrentWeapon();
    self iPrintln("Selected: ^2"+self.snacwep1);
}

SnacWeap2()
{
    self.snacwep2 = self getCurrentWeapon();
    self iPrintln("Selected: ^2"+self.snacwep2);
}

snacbind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        self iPrintLn("Skree bind activated, press [{+Actionslot 1}] to skree");
        self.SnacBind = true;
        while(isDefined(self.SnacBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                if(self getCurrentWeapon() == self.snacwep1)
                {
                    self SetSpawnWeapon( self.snacwep2 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep1 );
                }
                else if(self getCurrentWeapon() == self.snacwep2)
                {
                    self SetSpawnWeapon( self.snacwep1 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep2 );
                } 
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree bind ^1deactivated");
        self.SnacBind = undefined; 
    } 
}

snacbind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        self iPrintLn("Skree bind activated, press [{+Actionslot 2}] to skree");
        self.SnacBind = true;
        while(isDefined(self.SnacBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if(self getCurrentWeapon() == self.snacwep1)
                {
                    self SetSpawnWeapon( self.snacwep2 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep1 );
                }
                else if(self getCurrentWeapon() == self.snacwep2)
                {
                    self SetSpawnWeapon( self.snacwep1 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep2 );
                } 
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree bind ^1deactivated");
        self.SnacBind = undefined; 
    } 
}

snacbind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        self iPrintLn("Skree bind activated, press [{+Actionslot 3}] to skree");
        self.SnacBind = true;
        while(isDefined(self.SnacBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if(self getCurrentWeapon() == self.snacwep1)
                {
                    self SetSpawnWeapon( self.snacwep2 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep1 );
                }
                else if(self getCurrentWeapon() == self.snacwep2)
                {
                    self SetSpawnWeapon( self.snacwep1 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep2 );
                } 
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree bind ^1deactivated");
        self.SnacBind = undefined; 
    } 
}

snacbind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        self iPrintLn("Skree bind activated, press [{+Actionslot 4}] to skree");
        self.SnacBind = true;
        while(isDefined(self.SnacBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if(self getCurrentWeapon() == self.snacwep1)
                {
                    self SetSpawnWeapon( self.snacwep2 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep1 );
                }
                else if(self getCurrentWeapon() == self.snacwep2)
                {
                    self SetSpawnWeapon( self.snacwep1 );
                    wait .12;
                    self SetSpawnWeapon( self.snacwep2 );
                } 
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree bind ^1deactivated");
        self.SnacBind = undefined; 
    } 
}

savebolt()
{
    self endon("disconnect");
    self iPrintLn("^2Bolt Movement Position 1 Saved");
    self.pers["loc"] = true;
    self.pers["saveposbolt"] = self.origin;
}

savebolt2()
{
    self iPrintLn("^2Bolt Movement Position 2 Saved");
    self.pers["loc"] = true;
    self.pers["saveposbolt2"] = self.origin;
}

savebolt3()
{
    self iPrintLn("^2Bolt Movement Position 3 Saved");
    self.pers["loc"] = true;
    self.pers["saveposbolt3"] = self.origin;
}

savebolt4()
{
    self iPrintLn("^2Bolt Movement Position 4 Saved");
    self.pers["loc"] = true;
    self.pers["saveposbolt4"] = self.origin;
}
    
boltmovement1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 1}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

boltmovement2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 2}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

boltmovement3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 3}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

boltmovement4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 4}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

doubleboltmovement1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 1}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

doubleboltmovement2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 2}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

doubleboltmovement3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 3}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

doubleboltmovement4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 4}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

tripleboltmovement1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 1}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

tripleboltmovement2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 2}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

tripleboltmovement3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 3}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

tripleboltmovement4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 4}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

quadboltmovement1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 1}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

quadboltmovement2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 2}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

quadboltmovement3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 3}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

quadboltmovement4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bolt))
    {
        self iPrintLn("Bolt movement bind activated, press [{+Actionslot 4}] to start");
        self.Bolt = true;
        while(isDefined(self.Bolt))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                scriptRide = spawn("script_model", self.origin);
                scriptRide EnableLinkTo();
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
                wait self.boltspeed;
                self PlayerLinkToDelta(scriptRide);
                scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
                wait self.boltspeed;
                self Unlink();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bolt)) 
    { 
        self iPrintLn("Bolt movement bind ^1deactivated");
        self.Bolt = undefined; 
    } 
}

changeBoltSpeed(time)
{
    self.boltspeed = time;
    self iprintln("Bolt movement speed is set to " + time);
}

rapidFire1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.RapidFapped))
    {
        self iPrintLn("Rapid fire bind activated, press [{+Actionslot 1}] to shoot fast");
        self.RapidFapped = true;
        while(isDefined(self.RapidFapped))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread rapidFireFunc();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.RapidFapped)) 
    { 
        self iPrintLn("Rapid fire bind ^1deactivated");
        self.RapidFapped = undefined; 
    } 
}

rapidFire2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.RapidFapped))
    {
        self iPrintLn("Rapid fire bind activated, press [{+Actionslot 2}] to shoot fast");
        self.RapidFapped = true;
        while(isDefined(self.RapidFapped))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread rapidFireFunc();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.RapidFapped)) 
    { 
        self iPrintLn("Rapid fire bind ^1deactivated");
        self.RapidFapped = undefined; 
    } 
}

rapidFire3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.RapidFapped))
    {
        self iPrintLn("Rapid fire bind activated, press [{+Actionslot 3}] to shoot fast");
        self.RapidFapped = true;
        while(isDefined(self.RapidFapped))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread rapidFireFunc();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.RapidFapped)) 
    { 
        self iPrintLn("Rapid fire bind ^1deactivated");
        self.RapidFapped = undefined; 
    } 
}

rapidFire4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.RapidFapped))
    {
        self iPrintLn("Rapid fire bind activated, press [{+Actionslot 4}] to shoot fast");
        self.RapidFapped = true;
        while(isDefined(self.RapidFapped))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread rapidFireFunc();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.RapidFapped)) 
    { 
        self iPrintLn("Rapid fire bind ^1deactivated");
        self.RapidFapped = undefined; 
    } 
}

rapidFireFunc()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.RapidToggle))
    {
        self.RapidToggle = true;
        self setperk("specialty_fastreload");
        self thread unlimited_ammo();
        setDvar("perk_weapReloadMultiplier",0.001);
    } 
    else if(isDefined(self.RapidToggle)) 
    { 
        self.RapidToggle = undefined; 
        setDvar("perk_weapReloadMultiplier",0.5);
        self notify("stop_unlimitedammo");
    } 
}

ChangeClassTAO1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 1}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("-one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassTAO2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 2}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("-one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassTAO3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 3}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("-one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassTAO4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 4}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("-one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 1}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("none");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 2}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("none");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 3}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("none");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 4}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("none");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassOB1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 1}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassOB2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 2}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassOB3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 3}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassOB4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 4}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclassbind("one");
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClassType()
{
    if(self.ClassType == 0)
    {
        self.ClassType = 1;
        self iPrintLn("Class type changed to system link");
    }
    else if(self.ClassType == 1)
    {
        self.ClassType = 0;
        self iPrintLn("Class type changed to online");
    }
}

doChangeClass()
{
    if(self.cClass == 0)
    {
        self.cClass = 1;
        self notify( "menuresponse", "changeclass", "custom1" );
    }
    else if(self.cClass == 1)
    {
        self.cClass = 2;
        self notify( "menuresponse", "changeclass", "custom2" );
    }
    else if(self.cClass == 2)
    {
        self.cClass = 3;
        self notify( "menuresponse", "changeclass", "custom3" );
    }
    else if(self.cClass == 3)
    {
        self.cClass = 4;
        self notify( "menuresponse", "changeclass", "custom4" );
    }
    else if(self.cClass == 4)
    {
        self.cClass = 5;
        self notify( "menuresponse", "changeclass", "custom5" );
    }
    else if(self.cClass == 5)
    {
        if(self.ClassType == 0)
        {
            self.cClass = 6;
            self notify( "menuresponse", "changeclass", "prestige1" );
        }
        else if(self.ClassType == 1)
        {
            self.cClass = 1;
            self notify( "menuresponse", "changeclass", "custom1" );
        }
    }
    else if(self.cClass == 6)
    {
        self.cClass = 7;
        self notify( "menuresponse", "changeclass", "prestige2" );
    }
    else if(self.cClass == 7)
    {
        self.cClass = 8;
        self notify( "menuresponse", "changeclass", "prestige3" );
    }
    else if(self.cClass == 8)
    {
        self.cClass = 9;
        self notify( "menuresponse", "changeclass", "prestige4" );
    }
    else if(self.cClass == 9)
    {
        self.cClass = 0;
        self notify( "menuresponse", "changeclass", "prestige5" );
    }
}

changeclassbind(bulletType)
{
    self thread doChangeClass();
    wait .05;
    self.nova = self getCurrentweapon();
    ammoW = self getWeaponAmmoStock( self.nova );
    ammoCW = self getWeaponAmmoClip( self.nova );
    if(bulletType == "none")
    {
        self setweaponammostock( self.nova, ammoW );
        self setweaponammoclip( self.nova, ammoCW );
    }
    else if(bulletType == "-one")
    {
        self setweaponammostock( self.nova, ammoW );
        self setweaponammoclip( self.nova, ammoCW - 1);
    }
    else if(bulletType == "one")
    {
        self setweaponammostock( self.nova, ammoW );
        self setweaponammoclip( self.nova, 1);  
    }
}

changeclasscanbind()
{
    self thread doChangeClass();
    wait 0.01;
    self.nova = self getCurrentweapon();
    ammoW     = self getWeaponAmmoStock( self.nova );
    ammoCW    = self getWeaponAmmoClip( self.nova );
    self TakeWeapon(self.nova);
    self GiveWeapon( self.nova);
    self setweaponammostock( self.nova, ammoW );
    self setweaponammoclip( self.nova, ammoCW);
}

CANChangeClass1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 1}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclasscanbind();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

CANChangeClass2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 2}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclasscanbind();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

CANChangeClass3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 3}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclasscanbind();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

CANChangeClass4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 4}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread changeclasscanbind();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}



Cowboy1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CowboyBind))
    {
        self iPrintLn("Cowboy bind activated, press [{+Actionslot 1}] to cowboy");
        self.CowboyBind = true;
        while(isDefined(self.CowboyBind))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                if(self.DoingCowboy == false)
                {
                    self.DoingCowboy = true;
                    self setClientDvar("cg_gun_z", "8");
                }
                else
                {
                    self.DoingCowboy = false;
                    self setClientDvar("cg_gun_z", "0");
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.CowboyBind)) 
    { 
        self iPrintLn("Cowboy bind ^1deactivated");
        self.CowboyBind = undefined; 
    } 
}

Cowboy2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CowboyBind))
    {
        self iPrintLn("Cowboy bind activated, press [{+Actionslot 2}] to cowboy");
        self.CowboyBind = true;
        while(isDefined(self.CowboyBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if(self.DoingCowboy == false)
                {
                    self.DoingCowboy = true;
                    self setClientDvar("cg_gun_z", "8");
                }
                else
                {
                    self.DoingCowboy = false;
                    self setClientDvar("cg_gun_z", "0");
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.CowboyBind)) 
    { 
        self iPrintLn("Cowboy bind ^1deactivated");
        self.CowboyBind = undefined; 
    } 
}   

Cowboy3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CowboyBind))
    {
        self iPrintLn("Cowboy bind activated, press [{+Actionslot 3}] to cowboy");
        self.CowboyBind = true;
        while(isDefined(self.CowboyBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if(self.DoingCowboy == false)
                {
                    self.DoingCowboy = true;
                    self setClientDvar("cg_gun_z", "8");
                }
                else
                {
                    self.DoingCowboy = false;
                    self setClientDvar("cg_gun_z", "0");
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.CowboyBind)) 
    { 
        self iPrintLn("Cowboy bind ^1deactivated");
        self.CowboyBind = undefined; 
    } 
}   

Cowboy4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CowboyBind))
    {
        self iPrintLn("Cowboy bind activated, press [{+Actionslot 4}] to cowboy");
        self.CowboyBind = true;
        while(isDefined(self.CowboyBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if(self.DoingCowboy == false)
                {
                    self.DoingCowboy = true;
                    self setClientDvar("cg_gun_z", "8");
                }
                else
                {
                    self.DoingCowboy = false;
                    self setClientDvar("cg_gun_z", "0");
                }
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.CowboyBind)) 
    { 
        self iPrintLn("Cowboy bind ^1deactivated");
        self.CowboyBind = undefined; 
    } 
}

InstaWeap1()
{
    if(!isDefined(self.instaWeap1) )
    {
        self.instaWeap1 = self getcurrentweapon();
        self iPrintLn("Instaswap Weapon #1: " + self.instaWeap1);
    }   
}

InstaWeap2()
{
    if(!isDefined(self.instaWeap2) )
    {
        self.instaWeap2 = self getcurrentweapon();
        self iPrintLn("Instaswap Weapon #2: " + self.instaWeap2);
    }
}

Instaswap1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Instant))
    {
        self iPrintLn("Instaswap bind activated, press [{+Actionslot 1}] to Instaswap");
        self.Instant = true;
        while(isDefined(self.Instant))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doInsta();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Instant)) 
    { 
        self iPrintLn("Instaswap bind ^1deactivated");
        self.Instant = undefined; 
    } 
}

Instaswap2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Instant))
    {
        self iPrintLn("Instaswap bind activated, press [{+Actionslot 2}] to Instaswap");
        self.Instant = true;
        while(isDefined(self.Instant))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doInsta();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Instant)) 
    { 
        self iPrintLn("Instaswap bind ^1deactivated");
        self.Instant = undefined; 
    } 
}

Instaswap3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Instant))
    {
        self iPrintLn("Instaswap bind activated, press [{+Actionslot 3}] to Instaswap");
        self.Instant = true;
        while(isDefined(self.Instant))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doInsta();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Instant)) 
    { 
        self iPrintLn("Instaswap bind ^1deactivated");
        self.Instant = undefined; 
    } 
}

Instaswap4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Instant))
    {
        self iPrintLn("Instaswap bind activated, press [{+Actionslot 4}] to Instaswap");
        self.Instant = true;
        while(isDefined(self.Instant))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doInsta();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Instant)) 
    { 
        self iPrintLn("Instaswap bind ^1deactivated");
        self.Instant = undefined; 
    } 
}

doInsta() 
{
    self endon("disconnect");       
    if(self getcurrentweapon() == self.instaWeap1) 
    {
        self giveWeapon(self.instaWeap2);
        self setSpawnWeapon(self.instaWeap2);

    }
    else if(self getcurrentweapon() == self.instaWeap2) 
    {
        self giveWeapon(self.instaWeap1);
        self setSpawnWeapon(self.instaWeap1);
    }
}

OneManArmy1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 1}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMA();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmy2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 2}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread OMA();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmy3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 3}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMA();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmy4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 4}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread OMA();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyDouble1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 1}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMADouble();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyDouble2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 2}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread OMADouble();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyDouble3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 3}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMADouble();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyDouble4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 4}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread OMADouble();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyTriple1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 1}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMATriple();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyTriple2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 2}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread OMATriple();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyTriple3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 3}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread OMATriple();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OneManArmyTriple4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMA))
    {
        self iPrintLn("One man army bind activated, press [{+Actionslot 4}]");
        self.OMA = true;
        while(isDefined(self.OMA))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread OMATriple();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMA)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMA = undefined; 
    } 
}

OMA()
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit();
    wait 3;
    self takeweapon(self.OMAWeapon);
    self switchToWeapon(currentWeapon);
    
}

ChangingKit()
{
    self endon("death");
    self.ChangingKit = createSecondaryProgressBar();
    self.KitText = createSecondaryProgressBarText();
    for(i=0;i<61;i++)
    {
        self.ChangingKit updateBar(i / 60);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.63;
        wait .001;
    }
    self.ChangingKit destroyElem();
    self.KitText destroyElem();
}

OMADouble()
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);    
    wait 0.1;
    self thread ChangingKit2();
    wait 3;
    self takeweapon(self.OMAWeapon);
    self switchToWeapon(currentWeapon);
}

ChangingKit2()
{
    self endon("death");
    self.ChangingKit  = createSecondaryProgressBar();
    self.KitText      = createSecondaryProgressBarText();
    self.ChangingKit2 = createSecondaryProgressBar();
    self.KitText2     = createSecondaryProgressBarText();
    for(i=0;i<61;i++)
    {
        self.ChangingKit updateBar(i / 60);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.63;
        // 2nd one
        self.ChangingKit2 updateBar(i / 60);
        self.KitText2 setText("Planting...");
        self.ChangingKit2 setPoint("CENTER", "CENTER", 0, -50);
        self.KitText2 setPoint("CENTER", "CENTER", 0, -65);
        self.ChangingKit2.color     = (0, 0, 0);
        self.ChangingKit2.bar.color = self.BarColor;
        self.ChangingKit2.alpha     = 0.63;
        wait .001;
    }
    self.ChangingKit destroyElem();
    self.KitText destroyElem();
    self.ChangingKit2 destroyElem();
    self.KitText2 destroyElem();
}

OMATriple()
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit3();
    wait 3;
    self takeweapon(self.OMAWeapon);
    self switchToWeapon(currentWeapon);
}

ChangingKit3()
{
    self endon("death");
    self.ChangingKit  = createSecondaryProgressBar();
    self.KitText      = createSecondaryProgressBarText();
    self.ChangingKit2 = createSecondaryProgressBar();
    self.KitText2     = createSecondaryProgressBarText();
    self.ChangingKit3 = createSecondaryProgressBar();
    self.KitText3     = createSecondaryProgressBarText();
    for(i=0;i<61;i++)
    {
        self.ChangingKit updateBar(i / 60);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.63;
        // 2nd one
        self.ChangingKit2 updateBar(i / 60);
        self.KitText2 setText("Planting...");
        self.ChangingKit2 setPoint("CENTER", "CENTER", 0, -50);
        self.KitText2 setPoint("CENTER", "CENTER", 0, -65);
        self.ChangingKit2.color     = (0, 0, 0);
        self.ChangingKit2.bar.color = self.BarColor;
        self.ChangingKit2.alpha     = 0.63;
        // 3rd one
        self.ChangingKit3 updateBar(i / 60);
        self.KitText3 setText("Booby Trapping Crate");
        self.ChangingKit3 setPoint("CENTER", "CENTER", 0, -15);
        self.KitText3 setPoint("CENTER", "CENTER", 0, -30);
        self.ChangingKit3.color     = (0, 0, 0);
        self.ChangingKit3.bar.color = self.BarColor;
        self.ChangingKit3.alpha     = 0.63;
        wait .001;
    }
    self.ChangingKit destroyElem();
    self.KitText destroyElem();
    self.ChangingKit2 destroyElem();
    self.KitText2 destroyElem();
    self.ChangingKit3 destroyElem();
    self.KitText3 destroyElem();
}

OMAWeapon(Weap)
{
    if(Weap == "Bomb")
    {
        self.OMAWeapon = "briefcase_bomb_mp";
    }
    else if(Weap == "Default")
    {
        self.OMAWeapon = "defaultweapon_mp";
    }
    else if(Weap == "Syrette")
    {
        self.OMAWeapon = "syrette_mp";
    }
    else if(Weap == "Carepackage")
    {
        self.OMAWeapon = "supplydrop_mp";
    }
    else if(Weap == "Minigun")
    {
        self.OMAWeapon = "minigun_mp";
    }
    else if(Weap == "Grim Reaper")
    {
        self.OMAWeapon = "m202_flash_mp";
    }
    else if(Weap == "Valkyrie Rocket")
    {
        self.OMAWeapon = "m220_tow_mp";
    }
    else if(Weap == "RC-XD Remote")
    {
        self.OMAWeapon = "rcbomb_mp";
    }
    else if(Weap == "What the fuck")
    {
        self.OMAWeapon = "dog_bite_mp";
    }
    else
    {
        self iprintln("retard");
    }
    wait 0.1;
    self iprintln("OMA weapon changed to " + self.OMAWeapon);
}

ChangeBarColor(color)
{
    if(color == "blue")
    {
        self.BarColor = (0, 0, 255);
    }
    else if(color == "red")
    {
        self.BarColor = (255, 0, 0);
    }
    else if(color == "yellow")
    {
        self.BarColor = (255, 255, 0);
    }
    else if(color == "green")
    {
        self.BarColor = (0, 255, 0);
    }
    else if(color == "cyan")
    {
        self.BarColor = (0, 255, 255);
    }
    else if(color == "pink")
    {
        self.BarColor = (255, 0, 255);
    }
    else if(color == "black")
    {
        self.BarColor = (0, 0, 0);
    }
    else if(color == "lime")
    {
        self.BarColor = (174, 255, 0);
    }
    else if(color == "grey")
    {
        self.BarColor = (120, 120, 120);
    }
    else if(color == "normal")
    {
        self.BarColor = (255, 255, 255);
    }
    else
    {
        self iprintln("retard");
    }
    wait 0.1;
    self iprintln("OMA bar color set to ^2" + color);
}

TiltBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Tilted))
    {
        self iPrintLn("Tilt screen bind activated, press [{+Actionslot 1}] to tilt screen");
        self.Tilted = true;
        while(isDefined(self.Tilted))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doTilted();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Tilted)) 
    { 
        self iPrintLn("Tilt screen bind ^1deactivated");
        self.Tilted = undefined; 
    } 
}

TiltBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Tilted))
    {
        self iPrintLn("Tilt screen bind activated, press [{+Actionslot 2}] to tilt screen");
        self.Tilted = true;
        while(isDefined(self.Tilted))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doTilted();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Tilted)) 
    { 
        self iPrintLn("Tilt screen bind ^1deactivated");
        self.Tilted = undefined; 
    } 
}

TiltBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Tilted))
    {
        self iPrintLn("Tilt screen bind activated, press [{+Actionslot 3}] to tilt screen");
        self.Tilted = true;
        while(isDefined(self.Tilted))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doTilted();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Tilted)) 
    { 
        self iPrintLn("Tilt screen bind ^1deactivated");
        self.Tilted = undefined; 
    } 
}

TiltBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Tilted))
    {
        self iPrintLn("Tilt screen bind activated, press [{+Actionslot 4}] to tilt screen");
        self.Tilted = true;
        while(isDefined(self.Tilted))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doTilted();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Tilted)) 
    { 
        self iPrintLn("Tilt screen bind ^1deactivated");
        self.Tilted = undefined; 
    } 
}

doTilted()
{
    if(self.TiltedBind == 0)
    {
        self setPlayerAngles(self.angles + (0, 0, 35));
        self.TiltedBind = 1;
    }
    else
    {
        self setPlayerAngles(self.angles+(0,0,0));
        self.TiltedBind = 0;
    }
}

UpsideBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Upside))
    {
        self iPrintLn("Upside down screen bind activated, press [{+Actionslot 1}] to upside down screen");
        self.Upside = true;
        while(isDefined(self.Upside))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doUpsidedownScreen();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Upside)) 
    { 
        self iPrintLn("Upside down screen bind ^1deactivated");
        self.Upside = undefined; 
    } 
}

UpsideBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Upside))
    {
        self iPrintLn("Upside down screen bind activated, press [{+Actionslot 2}] to upside down screen");
        self.Upside = true;
        while(isDefined(self.Upside))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doUpsidedownScreen();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Upside)) 
    { 
        self iPrintLn("Upside down screen bind ^1deactivated");
        self.Upside = undefined; 
    } 
}

UpsideBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Upside))
    {
        self iPrintLn("Upside down screen bind activated, press [{+Actionslot 3}] to upside down screen");
        self.Upside = true;
        while(isDefined(self.Upside))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doUpsidedownScreen();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Upside)) 
    { 
        self iPrintLn("Upside down screen bind ^1deactivated");
        self.Upside = undefined; 
    } 
}

UpsideBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Upside))
    {
        self iPrintLn("Upside down screen bind activated, press [{+Actionslot 4}] to upside down screen");
        self.Upside = true;
        while(isDefined(self.Upside))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doUpsidedownScreen();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Upside)) 
    { 
        self iPrintLn("Upside down screen bind ^1deactivated");
        self.Upside = undefined; 
    } 
}

doUpsidedownScreen()
{
    if(self.doneUpside == 0)
    {
        self setPlayerAngles(self.angles + (0, 0, 180));
        self.doneUpside = 1;
    }
    else
    {
        self setPlayerAngles(self.angles+(0,0,0));
        self.doneUpside = 0;
    }
}


Bounce1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bouncing))
    {
        self iPrintLn("Bounce bind activated, press [{+Actionslot 1}] to bounce");
        self.Bouncing = true;
        while(isDefined(self.Bouncing))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doBounce();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bouncing)) 
    { 
        self iPrintLn("bounce bind ^1deactivated");
        self.Bouncing = undefined; 
    } 
}

Bounce2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bouncing))
    {
        self iPrintLn("Bounce bind activated, press [{+Actionslot 2}] to bounce");
        self.Bouncing = true;
        while(isDefined(self.Bouncing))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doBounce();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bouncing)) 
    { 
        self iPrintLn("bounce bind ^1deactivated");
        self.Bouncing = undefined; 
    } 
}

Bounce3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bouncing))
    {
        self iPrintLn("Bounce bind activated, press [{+Actionslot 3}] to bounce");
        self.Bouncing = true;
        while(isDefined(self.Bouncing))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doBounce();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bouncing)) 
    { 
        self iPrintLn("bounce bind ^1deactivated");
        self.Bouncing = undefined; 
    } 
}

Bounce4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Bouncing))
    {
        self iPrintLn("Bounce bind activated, press [{+Actionslot 4}] to bounce");
        self.Bouncing = true;
        while(isDefined(self.Bouncing))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doBounce();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.Bouncing)) 
    { 
        self iPrintLn("bounce bind ^1deactivated");
        self.Bouncing = undefined; 
    } 
}

doBounce()
{
    self setvelocity(self getvelocity() + (0,0,999));
}

EmptyClip1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip bind activated, press [{+Actionslot 1}] to empty clip");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip bind ^1deactivated");
        self.emptyClip = undefined; 
    } 
}

EmptyClip2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip bind activated, press [{+Actionslot 2}] to empty clip");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip bind ^1deactivated");
        self.emptyClip = undefined; 
    } 
}

EmptyClip3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip bind activated, press [{+Actionslot 3}] to empty clip");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip bind ^1deactivated");
        self.emptyClip = undefined; 
    } 
}

EmptyClip4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip bind activated, press [{+Actionslot 4}] to empty clip");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip bind ^1deactivated");
        self.emptyClip = undefined; 
    } 
}

doEmptyClip()
{
    self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip    = self getWeaponAmmoClip(self.EmptyWeap);
    WeapEmpStock     = self getWeaponAmmoStock(self.EmptyWeap);
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
}

FakeScav1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.fakeScav))
    {
        self iPrintLn("Fake scav bind activated, press [{+Actionslot 1}]");
        self.fakeScav = true;
        while(isDefined(self.fakeScav))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doFakeScav();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.fakeScav)) 
    { 
        self iPrintLn("Fake scav bind ^1deactivated");
        self.fakeScav = undefined; 
    } 
}

FakeScav2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.fakeScav))
    {
        self iPrintLn("Fake scav bind activated, press [{+Actionslot 2}]");
        self.fakeScav = true;
        while(isDefined(self.fakeScav))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doFakeScav();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.fakeScav)) 
    { 
        self iPrintLn("Fake scav bind ^1deactivated");
        self.fakeScav = undefined; 
    } 
}

FakeScav3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.fakeScav))
    {
        self iPrintLn("Fake scav bind activated, press [{+Actionslot 3}]");
        self.fakeScav = true;
        while(isDefined(self.fakeScav))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doFakeScav();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.fakeScav)) 
    { 
        self iPrintLn("Fake scav bind ^1deactivated");
        self.fakeScav = undefined; 
    } 
}

FakeScav4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.fakeScav))
    {
        self iPrintLn("Fake scav bind activated, press [{+Actionslot 4}]");
        self.fakeScav = true;
        while(isDefined(self.fakeScav))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doFakeScav();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.fakeScav)) 
    { 
        self iPrintLn("Fake scav bind ^1deactivated");
        self.fakeScav = undefined; 
    } 
}

doFakeScav()
{

    self.scavenger_icon = NewClientHudElem( self );
    self.scavenger_icon.horzAlign = "center";
    self.scavenger_icon.vertAlign = "middle";
    self.scavenger_icon.x = -36;
    self.scavenger_icon.y = 32;
    width = 64;
    height = 32;
    self.scavenger_icon setShader( "hud_scavenger_pickup", width, height );
    self.scavenger_icon.alpha = 1;
    self.scavenger_icon fadeOverTime( 2.5 );
    self.scavenger_icon.alpha = 0;
    self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip    = self getWeaponAmmoClip(self.EmptyWeap);
    WeapEmpStock     = self getWeaponAmmoStock(self.EmptyWeap);
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
}

LastStandBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStand))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 1}]");
        self iPrintLn("Only works when holding a secondary weapon (idek why)");
        self.LastStand = true;
        while(isDefined(self.LastStand))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self setPerk( "specialty_pistoldeath" );
                self setPerk( "specialty_finalstand" );
                wait .1;
                self thread [[level.callbackPlayerDamage]]( self , self , self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                if(!self isOnGround())
                {
                    self freezecontrolsallowlook(true);
                    wait .3;
                    self freezecontrolsallowlook(false);
                }
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStand)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStand = undefined; 
    } 
}

LastStandBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStand))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 2}]");
        self iPrintLn("Only works when holding a secondary weapon (idek why)");
        self.LastStand = true;
        while(isDefined(self.LastStand))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self setPerk( "specialty_pistoldeath" );
                self setPerk( "specialty_finalstand" );
                wait .1;
                self thread [[level.callbackPlayerDamage]]( self , self , self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                if(!self isOnGround())
                {
                    self freezecontrolsallowlook(true);
                    wait .3;
                    self freezecontrolsallowlook(false);
                }
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStand)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStand = undefined; 
    } 
}

LastStandBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStand))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 3}]");
        self iPrintLn("Only works when holding a secondary weapon (idek why)");
        self.LastStand = true;
        while(isDefined(self.LastStand))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self setPerk( "specialty_pistoldeath" );
                self setPerk( "specialty_finalstand" );
                wait .1;
                self thread [[level.callbackPlayerDamage]]( self , self , self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                if(!self isOnGround())
                {
                    self freezecontrolsallowlook(true);
                    wait .3;
                    self freezecontrolsallowlook(false);
                }
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStand)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStand = undefined; 
    } 
}

LastStandBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStand))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 4}]");
        self iPrintLn("Only works when holding a secondary weapon (idek why)");
        self.LastStand = true;
        while(isDefined(self.LastStand))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self setPerk( "specialty_pistoldeath" );
                self setPerk( "specialty_finalstand" );
                wait .1;
                self thread [[level.callbackPlayerDamage]]( self , self , self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                if(!self isOnGround())
                {
                    self freezecontrolsallowlook(true);
                    wait .3;
                    self freezecontrolsallowlook(false);
                }
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStand)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStand = undefined; 
    } 
}

forceLastStand()
{
    self endon("disconnect");

    self setPerk( "specialty_pistoldeath" );
    self setPerk( "specialty_finalstand" );
    wait .1;
    self thread [[level.callbackPlayerDamage]]( self , self , self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
    if(!self isOnGround())
    {
        self freezecontrolsallowlook( true );
        wait .3;
        self freezecontrolsallowlook( false );
    }
    wait .5;
}

doGflip1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        self iPrintLn("Mid air gflip bind activated, press [{+Actionslot 1}]");
        self.Gflip = true;
        while(isDefined(self.Gflip))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread MidAirGflip();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("Mid air gflip bind ^1deactivated");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}

doGflip2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        self iPrintLn("Mid air gflip bind activated, press [{+Actionslot 2}]");
        self.Gflip = true;
        while(isDefined(self.Gflip))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread MidAirGflip();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("Mid air gflip bind ^1deactivated");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}

doGflip3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        self iPrintLn("Mid air gflip bind activated, press [{+Actionslot 3}]");
        self.Gflip = true;
        while(isDefined(self.Gflip))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread MidAirGflip();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("Mid air gflip bind ^1deactivated");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}

doGflip4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        self iPrintLn("Mid air gflip bind activated, press [{+Actionslot 4}]");
        self.Gflip = true;
        while(isDefined(self.Gflip))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread MidAirGflip();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("Mid air gflip bind ^1deactivated");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}


MidAirGflip()
{
    self endon("stopProne1");
    self setStance("prone");
    wait 0.01;
    self setStance("prone");
}



