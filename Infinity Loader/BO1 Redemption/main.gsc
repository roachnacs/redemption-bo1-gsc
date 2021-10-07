#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level thread onPlayerConnect();
    setDvar("sv_cheats", 1);
    setDvar("killcam_final", "1");
    level.prematchPeriod = 0;
    precacheShader("hud_scavenger_pickup"); 
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
            self.Verified  = true;
            self.OMAWeapon = "briefcase_bomb_mp";
            self.BarColor  = (255, 255, 255);
            self.boltspeed = 2;
            self.ClassType = 1;
            self.MyAccess  = "^1Host";
            self thread BuildMenu();
        }
        else
        {
            self.MyAccess = "";
        }
    }
}

monitorPerks()
{
    self endon("disconnect");
    for(;;)
    {

        
        self waittill_either( "spawned_player", "changed_class" );
        wait .5;

        // Perk Slot 1 //
        if(self hasPerk( "specialty_movefaster" )) // Lightweight
        {
            self setPerk( "specialty_fallheight" );
            self setPerk( "specialty_movefaster" );
        }
        if(self hasPerk( "specialty_scavenger" )) // Scavenger
        {
            self setPerk( "specialty_extraammo" );
            self setPerk( "specialty_scavenger" );
        }
        if(self hasPerk( "specialty_gpsjammer" )) // Ghost
        {
            self setPerk( "specialty_gpsjammer" );
            self setPerk( "specialty_nottargetedbyai" );
            self setPerk( "specialty_noname" );
        }
        if(self hasPerk( "specialty_flakjacket" )) // Flak Jacket
        {
            self setPerk( "specialty_flakjacket" );
            self setPerk( "specialty_flakjacket" );
            self setPerk( "specialty_flakjacket" );
        }
        if(self hasPerk( "specialty_killstreak" )) // Hardline
        {
            self setPerk( "specialty_killstreak" );
            self setPerk( "specialty_gambler" );
        }

        // Perk Slot 2 //
        if(self hasPerk( "specialty_bulletaccuracy" )) // Steady Aim
        {
            self setPerk( "specialty_fallheight" );
            self setPerk( "specialty_sprintrecovery" );
            self setPerk( "specialty_fastmeleerecovery" );
        }
        if(self hasPerk( "specialty_holdbreath" )) // Scout
        {
            self setPerk( "specialty_holdbreath" );
            self setPerk( "specialty_fastweaponswitch" );
        }
        if(self hasPerk( "specialty_fastreload" )) // Sleight of Hand
        {
            self setPerk( "specialty_fastreload" );
            self setPerk( "specialty_fastads" );
        }
        if(self hasPerk( "specialty_twoattach" )) // War Lord
        {
            self setPerk("specialty_twoattach");
            self setPerk("specialty_twogrenades");
        }

        // Perk Slot 3 //
        if(self hasPerk( "specialty_longersprint" )) // Marathon
        {
            self setPerk( "specialty_longersprint" );
            self setPerk( "specialty_unlimitedsprint" );
        }
        if(self hasPerk( "specialty_quieter" )) // Ninja
        {
            self setPerk( "specialty_quieter" );
            self setPerk( "specialty_loudenemies" );
        }
        if(self hasPerk( "specialty_showenemyequipment" )) // Hacker
        {
            self setPerk( "specialty_showenemyequipment" );
            self setPerk( "specialty_detectexplosive" );
            self setPerk( "specialty_disarmexplosive" );
            self setPerk( "specialty_nomotionsensor" );
        }
        if(self hasPerk( "specialty_gas_mask" )) // Tactical Mask
        {
            self setPerk( "specialty_shades" );
            self setPerk( "specialty_stunprotection" );
        }
        if(self hasPerk( "specialty_pistoldeath" )) // last chance
        {
            self setPerk( "specialty_pistoldeath" );
            self setPerk( "specialty_finalstand" );
            
            player = level.players;
            for(i=0;i<level.players.size;i++)
            {
                if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
                {
                    if(player.pers["team"] == self.team)
                        continue;
                    self unsetPerk( "specialty_pistoldeath" );
                    self unsetPerk( "specialty_finalstand" );
                }
            }
        }

    wait .1;
    }
}



