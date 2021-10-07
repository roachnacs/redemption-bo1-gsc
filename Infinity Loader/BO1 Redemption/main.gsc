#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\_airsupport;

init()
{
    level thread onPlayerConnect();
    setDvar("sv_cheats", 1);
    level.prematchPeriod = 0;
    precacheShader("hud_scavenger_pickup");
    setDvar("killcam_final", "1");
    precacheShader("specialty_copycat");
    precacheShader("white");
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connecting", player);
        player thread onPlayerSpawned();
        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        player.MyAccess = "";
        player thread monitorPerks();
        player thread changeClass();
    }
}
onPlayerSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self IPrintLn("Welcome To ^1Redemption");
        self IPrintLn("Press [{+speed_throw}] + [{+actionslot 4}] To Open");
        if(self isHost())
        {
            self freezecontrols(false);
            self.Verified = true;
            self.menuColor = (0.6468253968253968, 0, 0.880952380952381);
            self.OMAWeapon = "briefcase_bomb_mp";
            self.BarColor  = (255, 255, 255);
            self.VIP = true;
            self.Admin = true;
            self.CoHost = true;
            self.boltspeed = 2;
            self.ClassType = 1;
            self.MyAccess = "^1Host";
            self thread BuildMenu();
        }
        else
        {
            self.MyAccess = "";
        }
    }
}



