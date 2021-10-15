#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level.strings = [];
    level thread defineOnce();
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    self playerSetup();
    
    for(;;)
    {
        self waittill("spawned_player");
        
        self.SavedModel = self.model;
        if(isDefined(self.LoadPositionOnSpawn) && isDefined(self.SavedPosition))
            self SetOrigin(self.SavedPosition);
        if(self getVerification() > 0)
        {
            self FreezeControls(false);
            self welcomeMessage();
        }
    }
}

defineOnce()
{
    level.menuName   = "Redemption";
    level.MenuStatus = StrTok("UnVerified,Verified,Admin,Host",",");
    level.colorNames = StrTok("Red,Green,Blue,Yellow,Cyan,Orange,Purple,Pink",",");
    level.colors     = StrTok("255,0,15,0,255,0,0,0,255,255,255,0,0,255,255,255,130,0,200,0,255,255,0,255",",");
    
    level.airDropCrates         = GetEntArray("care_package","targetname");
    level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    
    BotDvars    = StrTok("testClients_doMove,testClients_doAttack,testClients_doReload,testClients_doCrouch,testClients_watchKillcam",",");
    BotDvarVals = StrTok("0,0,0,0,0",",");
    for(a=0;a<BotDvars.size;a++)
        SetDvar(BotDvars[a],BotDvarVals[a]);
    
    level.modelsProper = StrTok("Green Crate,Red Crate,Default Actor,Neutral Flag,Sentry Gun,Minigun,Harrier,AC130,Test Sphere,Vehicle",",");
    level.MenuModels   = StrTok("com_plasticcase_friendly,com_plasticcase_enemy,defaultactor,prop_flag_neutral,sentry_minigun,weapon_minigun,vehicle_av8b_harrier_jet_mp,vehicle_ac130_low_mp,test_sphere_silver,vehicle_mig29_desert",",");
    for(a=0;a<level.MenuModels.size;a++)
        PreCacheModel(level.MenuModels[a]);
    
    PreCacheTurret("sentry_minigun_mp");
    PreCacheItem("lightstick_mp");
    
    level.DoHeartText = "Redemption by Roach";
}

playerSetup()
{
    if(isDefined(self.menuThreaded))
        return;
    self.menuThreaded = true;
    
    self defineVariables();
    
    if(self isHost() || self isDeveloper())
    {
        if(self isHost())
        {
            self thread FixOverflow();
            level GetMapFog();
        }
        self.playerSetting["verification"] = level.MenuStatus[level.MenuStatus.size-1];
    }
    else
        self.playerSetting["verification"] = level.MenuStatus[0];
    
    self thread MonitorButtons();
    self thread menuMonitor();
}
 
defineVariables()
{
    if(!isDefined(self.playerSetting))
        self.playerSetting = [];
    
    self.menu["currentMenu"] = "";
    self.playerSetting["isInMenu"] = undefined;
    self.menu["Main_Color"] = (0.6468253968253968, 0, 0.880952380952381);
    
    self.TrickshotAimbotStrength = 300;
    
    //This will load the right side theme by default
    self thread ResetDesign(true);
    //If you would like to load the center theme by default, replace ResetDesign(true) with CenterTheme(true)
}

welcomeMessage()
{
    if(!isDefined(self.HideSpawnText))
    {
        self iPrintln("Welcome to ^1Redemption");
        self iPrintln("Press [{+speed_throw}] and [{+actionslot 4}] to Open");
    }
}