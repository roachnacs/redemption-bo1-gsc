#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level thread onPlayerConnect();
    level thread removeSkyBarrier();
    self thread TeamName1("^0Redemption");
    self thread TeamName2("^1By Roach");
    setDvar("sv_cheats", 1);
    level.player_out_of_playable_area_monitor = 0;
    level.prematchPeriod = 0;
    level.rankedMatch = true;
    level.contractsEnabled = false;
    precacheShader("tow_overlay");
    precachemodel( level.spyplanemodel );
    precacheShader("tow_filter_overlay");
    precacheShader("tow_filter_overlay_no_signal");
    precacheItem( "scavenger_item_mp" );
    precacheShader( "hud_scavenger_pickup" );
    PreCacheModel( level.supplyDropHelicopterFriendly );
    PreCacheVehicle( level.suppyDropHelicopterVehicleInfo );
    level.supplyDropHelicopterFriendly = "vehicle_ch46e_mp_light";
    level.supplyDropHelicopterEnemy = "vehicle_ch46e_mp_dark";
    level.suppyDropHelicopterVehicleInfo = "heli_supplydrop_mp";
	setDvar("killcam_final", "1");
    level.c4array = [];
    level.claymorearray = [];
    level.DefaultKillcam = 0;
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
        player thread changeClass();
        player thread monitorPerks();
        player thread HelpfulBind();
		player.pers["aimbotRadius"] = 1000;
        player.pers["aimbotWeapon"] = "";
        player.pers["aimbotToggle"] = 0;
        player.pers["HMaimbotRadius"] = 1000;
        player.pers["HMaimbotWeapon"] = "";
        player.pers["HMaimbotToggle"] = 0;
        player.SpawnText = true;
        player.FirstTimeSpawn = true;
        player.SavedPosition = [];
        player.pers["SelfDamage"] = 50;
        player.pers["SavingandLoading"] = true;
        if(!isDefined(player.pers["poscount"]))
		    player.pers["poscount"] = 0;
        player.menuColor = (0.6468253968253968, 0, 0.880952380952381);
        player.pers["GiveMenu"] = false;
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if(self.SpawnText == true)
        {
            self IPrintLn("Welcome To ^1Redemption");
            self IPrintLn("Press [{+speed_throw}] + [{+actionslot 4}] To Open");
        }
        else
        {
            continue;
        }
        
        if(self isHost())
        {
            self freezecontrols(false);
            setDvar("timescale", 1);
            self.Verified = true;
            self.OMAWeapon = "briefcase_bomb_mp";
            self.BarColor  = (255, 255, 255);
            self.ForgeRadii = 200;
            self.VIP = true;
            setDvar("AntigaSpeed", 0);
            self.Admin = true;
            self.CoHost = true;
            self.boltspeed = 2;
            setDvar("cg_nopredict", 0);
            self.streak = "supply_drop_mp";
            self.Nacstreak = "rcbomb_mp";
            self.ClassType = 1;
            self.isNotShaxWeapon = false;
            self.shineShaxGunCheck = 0;
            self.shaxTakeaway = 0;
            self.RoachSwapWeap = "skorpion_mp";
            self.shaxCycle = 0;
            self.shaxGun = "Undefined";
            self.MyAccess = "^2Host";
            self thread BuildMenu();
            self thread saveandload();
            if(isDefined(self.pers["location"]))
            {
                self setOrigin(self.pers["location"]);
            }
            setDvar("com_maxfps", "57");
            setDvar("com_maxfps", 57);
        }
        else if(self.Verified == true || self.pers["GiveMenu"] == true)
        {
            self.Verified = true;
            self.OMAWeapon = "briefcase_bomb_mp";
            self.BarColor  = (255, 255, 255);
            self.pers["GiveMenu"] = true;
            self.VIP = true;
            self.Admin = true;
            self.CoHost = true;
            self.ForgeRadii = 200;
            self.boltspeed = 2;
            self.streak = "supply_drop_mp";
            self.Nacstreak = "rcbomb_mp";
            setDvar("AntigaSpeed", 0);
            self.ClassType = 1;
            self.isNotShaxWeapon = false;
            self.shineShaxGunCheck = 0;
            self.RoachSwapWeap = "skorpion_mp";
            self.shaxTakeaway = 0;
            self.shaxCycle = 0;
            self.shaxGun = "Undefined";
            self.MyAccess = "^3Verified";
            self freezecontrols(false);
            self thread BuildMenu();
            self thread saveandload();
            if(isDefined(self.pers["location"]))
            {
                self setOrigin(self.pers["location"]);
            }
            setDvar("com_maxfps", "57");
            setDvar("com_maxfps", 57);
        }
        else if ( self.Verified == false)
        {
            players = level.players;
            self.MyAccess = "^1Bot";
            self freezecontrols(false);
            for ( i = 0; i < players.size; i++ )
            {   
                player = players[i];
                if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
                {
                    player freezeControls(true);
                    self.frozenbots = 1;
                    wait 0.05;
                    self clearperks();
                    if(isDefined(self.pers["location"]))
                    {
                        self setOrigin(self.pers["location"]);
                    }
                }
            }
        }
    }
}

TeamName1(inp)
{
    setDvar("g_TeamName_Allies", inp);
    setDvar("g_TeamIcon_Allies","rank_prestige02");
}

TeamName2(inp)
{
    setDvar("g_TeamName_Axis",inp);
    setDvar("g_TeamIcon_Axis","rank_prestige02");
}

removeSkyBarrier()
{
    entArray=getEntArray();
    for(i=0;i < entArray.size;i++)
    {
        if(isSubStr(entArray[i].classname,"trigger_hurt") && entArray[i].origin[2] > 180)entArray[i].origin = (0 , 0, 9999999);
    }   
}

BuildMenu()
{
    self endon("disconnect");
    self endon("death");
    self.MenuOpen = false;
    self.Menu = spawnstruct();
    self InitialisingMenu();
    self MenuStructure();
    self thread MenuDeath();
    while (1)
    {
        if(self adsButtonPressed() && self actionslotfourbuttonpressed() && self.MenuOpen == false)
        {
            self MenuOpening();
            self LoadMenu("redemption");
        }
        else if(self MeleeButtonPressed() && self.MenuOpen == true)
        {
            if(isDefined(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]))
            {
                self SubMenu(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]);
                wait 0.2;
            }
            else
            {
                self MenuClosing();
                wait 1;
            }
        }
        else if (self actionslotonebuttonpressed() && self.MenuOpen == true)
        {
            self.Menu.System["MenuCurser"] -= 1;
            if (self.Menu.System["MenuCurser"] < 0)
            {
                self.Menu.System["MenuCurser"] = self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size - 1;
            }
            self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
            wait .15;
        }
        else if (self actionslottwobuttonpressed() && self.MenuOpen == true)
        {
            self.Menu.System["MenuCurser"] += 1;
            if (self.Menu.System["MenuCurser"] >= self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size)
            {
                self.Menu.System["MenuCurser"] = 0;
            }
            self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
            wait .15;
        }
        else if(self usebuttonpressed() && self.MenuOpen == true)
        {
                wait 0.2;
                if(self.Menu.System["MenuRoot"]=="clients menu") self.Menu.System["ClientIndex"]=self.Menu.System["MenuCurser"];
                self thread [[self.Menu.System["MenuFunction"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]]](self.Menu.System["MenuInput"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
                wait 0.2;
        }
        wait 0.005;
    }
}   

MenuStructure()
{
    if (self.Verified == true)
    {
        self MainMenu("redemption", undefined);
        self MenuOption("redemption", 0, "main menu", ::SubMenu, "main menu");
        self MenuOption("redemption", 1, "teleport menu", ::SubMenu, "teleport menu");
        self MenuOption("redemption", 2, "spawning menu", ::SubMenu, "spawning menu");
        self MenuOption("redemption", 3, "killstreaks menu", ::SubMenu, "killstreaks menu");
        self MenuOption("redemption", 4, "perks menu", ::SubMenu, "perks menu");
        self MenuOption("redemption", 5, "visions menu", ::SubMenu, "visions menu");
        self MenuOption("redemption", 6, "camo menu", ::SubMenu, "camo menu");
        self MenuOption("redemption", 7, "weapons menu", ::SubMenu, "weapons menu");
        self MenuOption("redemption", 8, "aimbot menu", ::SubMenu, "aimbot menu");
        self MenuOption("redemption", 9, "trickshot menu", ::SubMenu, "trickshot menu");
        self MenuOption("redemption", 10, "binds menu", ::SubMenu, "binds menu");
        self MenuOption("redemption", 11, "bots menu", ::SubMenu, "bots menu");
        self MenuOption("redemption", 12, "account menu", ::SubMenu, "account menu");
    }
    if (self isHost())
    {
        self MenuOption("redemption", 13, "clients menu", ::SubMenu, "clients menu");
        self MenuOption("redemption", 14, "admin menu", ::SubMenu, "admin menu");
        self MenuOption("redemption", 15, "dev menu", ::SubMenu, "dev menu");
    }
    
    self MainMenu("main menu", "redemption");
    self MenuOption("main menu", 0, "god mode", ::ToggleGod);
    self MenuOption("main menu", 1, "invisibility", ::toggle_invs);
    self MenuOption("main menu", 2, "ufo mode", ::ToggleNoclip);
    self MenuOption("main menu", 3, "infinite ammo", ::ToggleAmmo);
    self MenuOption("main menu", 4, "infinite equipment", ::ToggleInfEquipment);
    self MenuOption("main menu", 5, "pro mod", ::ToggleFOV);
    self MenuOption("main menu", 6, "third person", ::Third);
    self MenuOption("main menu", 7, "movement speed", ::superSpeed);
    self MenuOption("main menu", 8, "left side gun", ::toggleleft);
    self MenuOption("main menu", 9, "moving gun", ::togglemovinggun);
    self MenuOption("main menu", 10, "center gun", ::togglecenter);
    self MenuOption("main menu", 11, "no recoil", ::ToggleRecoil);
    self MenuOption("main menu", 12, "invisible gun", ::nogunC);
    self MenuOption("main menu", 13, "rapid fire", ::RapidFire);
    self MenuOption("main menu", 14, "auto drop shot", ::autodropshot);
    self MenuOption("main menu", 15, "toggle uav", ::toggleuav);
    self MenuOption("main menu", 16, "suicide", ::KYS);
    
    self MainMenu("teleport menu", "redemption");
    self MenuOption("teleport menu", 0, "save position", ::savePosition);
    self MenuOption("teleport menu", 1, "load position", ::loadPosition);
    self MenuOption("teleport menu", 2, "load position on spawn", ::LoadLocationOnSpawn);
    self MenuOption("teleport menu", 3, "save and load bind", ::saveandload);
    self MenuOption("teleport menu", 4, "teleport gun", ::TeleportGun);
    self MenuOption("teleport menu", 5, "save look direction", ::saveAngle);
    self MenuOption("teleport menu", 6, "set look direction", ::setAngle);
    self MenuOption("teleport menu", 7, "map teleports", ::SubMenu, "map teleports");
    self MenuOption("teleport menu", 8, "load shot location", ::TeleportSpot, (2153.58, -513.593, 455.961));
    
    if( getdvar("mapname") == "mp_array")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (2601.44, 307.3,696.975));
        self MenuOption("map teleports", 1, "satellite dish", ::TeleportSpot, (-1153, 2640, 711));
        self MenuOption("map teleports", 2, "back ladder", ::TeleportSpot, (-2112.11, 2118.26, 661.125));
        self MenuOption("map teleports", 3, "control room", ::TeleportSpot, (356, 792, 536));
        self MenuOption("map teleports", 4, "echo spot", ::TeleportSpot, (3441, 2949, 140));
        self MenuOption("map teleports", 5, "lcsihz spot", ::TeleportSpot, (-2279, 1217, 424));
    }
    else if( getdvar("mapname") == "mp_cracked")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-399.487, -924.336, 103.98));
        self MenuOption("map teleports", 1, "stairs ledge", ::TeleportSpot, (-1350.1, -921.116, 80.1332));
        self MenuOption("map teleports", 2, "sandbag ledge", ::TeleportSpot, (-2068.36, 225.884, -19.875));
        self MenuOption("map teleports", 3, "roach lunge spot", ::TeleportSpot, (-274, -1036, 113));
        self MenuOption("map teleports", 4, "out of map spot", ::TeleportSpot, (-547.151, 2783.21, 1183.20));
    }
    else if( getdvar("mapname") == "mp_crisis")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-2346.45, 42.1061, 338.907));
        self MenuOption("map teleports", 1, "bridge", ::TeleportSpot, (-572.372, 1143.91, 278.005));
        self MenuOption("map teleports", 2, "sandbag ledge", ::TeleportSpot, (416.853, 957.162, 332.128));
        self MenuOption("map teleports", 3, "back ladder", ::TeleportSpot, (1829.18, 1713.3, 262.044));
        self MenuOption("map teleports", 4, "roof in cliff", ::TeleportSpot, (-120.286, 1506.05, 262.186));
        self MenuOption("map teleports", 5, "out of map spot", ::TeleportSpot, (-509.417, -1646.02, 144.125));
    }
    else if( getdvar("mapname") == "mp_firingrange")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (578.162, 1107.8, 228.083));
        self MenuOption("map teleports", 1, "high doors", ::TeleportSpot, (-262.363, 1175.59, 189.971));
        self MenuOption("map teleports", 2, "knife lunge Teleport", ::TeleportSpot, (-1247.12, 1382.38, 80.2608));
        self MenuOption("map teleports", 3, "tower window (crouch before teleporting)", ::TeleportSpot, (377.786, 1073.85, 233.999));
        self MenuOption("map teleports", 4, "back ladder", ::TeleportSpot, (1475.09, 1296.17, 81.125));
        self MenuOption("map teleports", 5, "out of map spot", ::TeleportSpot, (-1600.9, 658.461, 193.017));
        self MenuOption("map teleports", 6, "out of map spot 2", ::TeleportSpot, (-1543.85, -2499.81, 354.749));
    }
    else if( getdvar("mapname") == "mp_duga")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-730.218, -3369.63, 157.522));
        self MenuOption("map teleports", 1, "back ladder", ::TeleportSpot, (-2387.72, -2762.28, 137.016));
        self MenuOption("map teleports", 2, "truck", ::TeleportSpot, (-847.433, -4547.62, 157.125));
    }
    else if( getdvar("mapname") == "mp_hanoi")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "ladder spot", ::TeleportSpot, (465.141, -1896.19, 64.125));
        self MenuOption("map teleports", 1, "roach window", ::TeleportSpot, (12.2965, -1684.91, 97.4029));
        self MenuOption("map teleports", 2, "bus", ::TeleportSpot, (43.8066, 706.697, 87.625));
        self MenuOption("map teleports", 3, "wall", ::TeleportSpot, (515.03, 1009.09, 43.125));
        self MenuOption("map teleports", 4, "back ledge", ::TeleportSpot, (526.965, 1313.22, 116.125));
        self MenuOption("map teleports", 5, "hearts spot", ::TeleportSpot, (-443.106, -2924.56, 364.372));
    }
    else if( getdvar("mapname") == "mp_cairo")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (1117.25, 266.186, 167.372));
        self MenuOption("map teleports", 1, "bounce", ::TeleportSpot, (-1846.41, -438.616, 152.125));
        self MenuOption("map teleports", 2, "geen double delayed lunge", ::TeleportSpot, (404.188, -824.641, 136.125));
        self MenuOption("map teleports", 3, "out of map spot", ::TeleportSpot, (690.937, -1724.94, 277.879));
    }
    else if( getdvar("mapname") == "mp_havoc")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (1521.91, -935.472, 486.834));
        self MenuOption("map teleports", 1, "mid ladder", ::TeleportSpot, (2168.64, 178.6, 268.125));
        self MenuOption("map teleports", 2, "mid ladder 2", ::TeleportSpot, (400.621, -1185.19, 296.125));
        self MenuOption("map teleports", 3, "back ladder", ::TeleportSpot, (2193.31, -2438.18, 277.125));
        self MenuOption("map teleports", 4, "temple", ::TeleportSpot, (1295.12, 1740.56, 286.125));
    }
    else if( getdvar("mapname") == "mp_cosmodrome")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot side a", ::TeleportSpot, (2031.56, -313.56, 25.8942));
        self MenuOption("map teleports", 1, "main trickshot side b", ::TeleportSpot, (2031.55, 1050.2, 25.8942));
        self MenuOption("map teleports", 2, "mid ladder", ::TeleportSpot, (-710.683, -161.641, 47.125));
        self MenuOption("map teleports", 3, "mid ladder 2", ::TeleportSpot, (-787.532, 857.641, 56.125));
    }
    else if( getdvar("mapname") == "mp_nuked")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "glitched bus", ::TeleportSpot, (229.952, 243.159, 88.3563));
        self MenuOption("map teleports", 1, "front yellow", ::TeleportSpot, (513.135, 156.066, 77.9509));
        self MenuOption("map teleports", 2, "front blue", ::TeleportSpot, (-455.444, 348.863, 75.125));
        self MenuOption("map teleports", 3, "back yellow", ::TeleportSpot, (1353.4, 240.404, 114.871));
        self MenuOption("map teleports", 4, "back blue", ::TeleportSpot, (-1191.33, 774.053, 114.893));
    }
    else if( getdvar("mapname") == "mp_radiation")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-919.343, 25.0547, 352.125));
        self MenuOption("map teleports", 1, "mid map 1", ::TeleportSpot, (127.485, -380.02, 295.125));
        self MenuOption("map teleports", 2, "mid map 2", ::TeleportSpot, (-124.577, 391.777, 295.125));
        self MenuOption("map teleports", 3, "conveyor belt", ::TeleportSpot, (2222.52, 1032.88, 309.125));
        self MenuOption("map teleports", 4, "inside ladder", ::TeleportSpot, (2244.36, 166.813, 309.125));
        self MenuOption("map teleports", 5, "back ladder", ::TeleportSpot, (-1238.67, -1866.181, 181.125));
        self MenuOption("map teleports", 6, "roach spot", ::TeleportSpot, (-586.797, -1727.51, 163.965));
    }
    else if( getdvar("mapname") == "mp_mountain")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (2026.96, -377.801, 478.793));
        self MenuOption("map teleports", 1, "spawn sui 1", ::TeleportSpot, (2317.27, 1472.61, 355.698));
        self MenuOption("map teleports", 2, "spawn sui 2", ::TeleportSpot, (2403.97, -2885.94, 387.473));
        self MenuOption("map teleports", 3, "spawn sui 3", ::TeleportSpot, (4028.66, 1451.83, 318.125));
        self MenuOption("map teleports", 4, "spawn sui 4", ::TeleportSpot, (3722.08, -2373.65, 433.625));
        self MenuOption("map teleports", 5, "knife lunge spot", ::TeleportSpot, (1683.15, -1700.73, 252.472));
        self MenuOption("map teleports", 6, "roach lunge spot", ::TeleportSpot, (3892.69, -137.641, 374.125));
    }
    else if( getdvar("mapname") == "mp_villa")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "roach window", ::TeleportSpot, (4370.25, 2532.79, 376.125));
        self MenuOption("map teleports", 1, "lcsihz window", ::TeleportSpot, (2904.93, 105.427, 456.125));
        self MenuOption("map teleports", 2, "main balcony", ::TeleportSpot, (4144.63, 510.959, 456.125));
    }
    else if( getdvar("mapname") == "mp_russainbase")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-1246.2, -93.8406, 487.284));
        self MenuOption("map teleports", 1, "main ladder", ::TeleportSpot, (-1471.34, 388.245, 454.125));
        self MenuOption("map teleports", 2, "silo ladder", ::TeleportSpot, (1891.12, -108.359, 192.125));
        self MenuOption("map teleports", 3, "spawn window", ::TeleportSpot, (1258.16, 1042.34, 160.125));
    }
    else if( getdvar("mapname") == "mp_discovery")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-2092.58, -137.944, 199.984));
        self MenuOption("map teleports", 1, "main ladder", ::TeleportSpot, (-1237.89, -572.892, 56.125));
        self MenuOption("map teleports", 2, "back ladder", ::TeleportSpot, (-275.461, -2656.62, 140.358));
        self MenuOption("map teleports", 3, "middle bridge", ::TeleportSpot, (-641, 215.914, 103.016));
        self MenuOption("map teleports", 4, "out of map back drop", ::TeleportSpot, (-1371.63, 2713.08, 415.799));
    }
    else if( getdvar("mapname") == "mp_kowloon")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main ladder", ::TeleportSpot, (343.154, 220.556, 309.125));
        self MenuOption("map teleports", 1, "zipline 1", ::TeleportSpot, (23.6409, 617.484, 196.125));
        self MenuOption("map teleports", 2, "zipline 2", ::TeleportSpot, (916.805, 938.996, 121.125));
        self MenuOption("map teleports", 3, "back ladder", ::TeleportSpot, (-1638.45, -899.565, -37.875));
        self MenuOption("map teleports", 4, "fortune suicide", ::TeleportSpot, (-1703.46, 992.488, -151.875));
    }
    else if( getdvar("mapname") == "mp_stadium")
    {
        self MainMenu("map teleports", "teleport menu");
       self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-46.0432, 1852.46, 163.955));
        self MenuOption("map teleports", 1, "main ladder", ::TeleportSpot, (-929.907, 128.853, 208.125));
        self MenuOption("map teleports", 2, "catwalk", ::TeleportSpot, (601.813, 1103.55, 189.909));
        self MenuOption("map teleports", 3, "office balcony", ::TeleportSpot, (1334.88, 2056.56, 192.027));
        self MenuOption("map teleports", 4, "hockey rink", ::TeleportSpot, (-1891.53, 1925.9, 237.94));
    }
    else if( getdvar("mapname") == "mp_gridlock")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "left ladder", ::TeleportSpot, (-905.59, -266.462, 245.266));
        self MenuOption("map teleports", 1, "right ladder", ::TeleportSpot, (-970.571, 462.086, 245.125));
        self MenuOption("map teleports", 2, "motel stairs", ::TeleportSpot, (-1600.44, 1519.11, 167.898));
        self MenuOption("map teleports", 3, "off the bridge", ::TeleportSpot, (273.076, 560.482, 130.29));
        self MenuOption("map teleports", 4, "geens clips", ::TeleportSpot, (1157.25, 1075.63, -6.76911));
    }
    else if( getdvar("mapname") == "mp_hotel")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "suicide spot 1", ::TeleportSpot, (-279.562, 755.969, 101.894));
        self MenuOption("map teleports", 1, "suicide spot 2", ::TeleportSpot, (6580.8, 179.498, 101.976));
        self MenuOption("map teleports", 2, "suicide spot 3", ::TeleportSpot, (1400.82, -2214.11, -45.5907));
        self MenuOption("map teleports", 3, "window 1", ::TeleportSpot, (4109.57, -437.493, 184.125));
        self MenuOption("map teleports", 4, "window 2", ::TeleportSpot, (1631.99, -316.669, 160.125));
    }
    else if( getdvar("mapname") == "mp_outskirts")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (1494.41, 674.657, 410.056));
        self MenuOption("map teleports", 1, "ladder 1", ::TeleportSpot, (-363.279, -139.32, 198.12));
        self MenuOption("map teleports", 2, "ladder 2", ::TeleportSpot, (207.641, -976.037, 152.125));
    }
    else if( getdvar("mapname") == "mp_zoo")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (1024.53, 148.779, 142.125));
        self MenuOption("map teleports", 1, "ladder 1", ::TeleportSpot, (1266.04, 627.337, 146.125));
        self MenuOption("map teleports", 2, "ladder 2", ::TeleportSpot, (-1255.38, -849.195, -5.875));
    }
    else if( getdvar("mapname") == "mp_drivein")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-59.2954, 1076.22, 252.125));
        self MenuOption("map teleports", 1, "watching Silver Screen by Max", ::TeleportSpot, (30.0857, -753.733, 200.125));
        self MenuOption("map teleports", 2, "ive lost my mind", ::TeleportSpot, (-1560.89, -814.222, 218.125));
    }
    else if( getdvar("mapname") == "mp_area51")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "window spot 1", ::TeleportSpot, (-1641.6, 1065.83, 184.625));
        self MenuOption("map teleports", 1, "window spot 2", ::TeleportSpot, (-736.604, 441.641, 156.125));
        self MenuOption("map teleports", 2, "window spot 3", ::TeleportSpot, (-368.359, 2016.3, 164.125));
        self MenuOption("map teleports", 3, "window spot 4", ::TeleportSpot, (833.108, 403.641, 196.125));
        self MenuOption("map teleports", 4, "random spot", ::TeleportSpot, (668.576, -1613.22, 265.125));
        self MenuOption("map teleports", 5, "ladder spot 1", ::TeleportSpot, (607.473, -1887.64, 229.125));
        self MenuOption("map teleports", 6, "ladder spot 2", ::TeleportSpot, (-1593.01, -1028.58, 99.125));
    }
    else if( getdvar("mapname") == "mp_golfcourse")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (-1351.6, -1145.11, 20.822));
        self MenuOption("map teleports", 1, "high spot 1", ::TeleportSpot, (898.527, 680.206, 31.7));
        self MenuOption("map teleports", 2, "high spot 2", ::TeleportSpot, (364.068, -152.901, -27.8634));
        self MenuOption("map teleports", 3, "suicide spot", ::TeleportSpot, (-3295.99, 1407.71, -179.875));
        self MenuOption("map teleports", 4, "out of map spot", ::TeleportSpot, (-1616.01, -2658.39, 136.125));
    }
    else if( getdvar("mapname") == "mp_silo")
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::TeleportSpot, (656.123, 2474.75, 373.289));
        self MenuOption("map teleports", 1, "window spot 1", ::TeleportSpot, (-726.367, 596.721, 387.817));
        self MenuOption("map teleports", 2, "window spot 2", ::TeleportSpot, (-725.957, -628.974, 220.803));
    }
    else
    {
        self MainMenu("map teleports", "teleport menu");
        self MenuOption("map teleports", 0, "main trickshot", ::Test);
    }
    
    self MainMenu("spawning menu", "redemption");
    self MenuOption("spawning menu", 0, "spawn crate", ::spawngreencrate);
    self MenuOption("spawning menu", 1, "spawn slide", ::slide); 
    self MenuOption("spawning menu", 2, "spawn bounce", ::normalbounce);
    self MenuOption("spawning menu", 3, "spawn platform", ::platform);
    self MenuOption("spawning menu", 4, "spawn carepackage stall", ::carePackageStall);
    self MenuOption("spawning menu", 5, "spawn midair carepackage stall", ::carePackageStall2);
    self MenuOption("spawning menu", 6, "change cp capture speed", ::SubMenu, "capture speed");
	self MenuOption("spawning menu", 7, "spawn helicopter", ::SpawnHeli); 
    self MenuOption("spawning menu", 8, "forge mod", ::forgeon);
    self MenuOption("spawning menu", 9, "change forge radius", ::SubMenu, "forge radius");
    
    self MainMenu("forge radius", "spawning menu");
    self MenuOption("forge radius", 0, "50", ::ChangeForgeRad, 50);
    self MenuOption("forge radius", 1, "100", ::ChangeForgeRad, 100);
    self MenuOption("forge radius", 2, "150", ::ChangeForgeRad, 150);
    self MenuOption("forge radius", 3, "200", ::ChangeForgeRad, 200);
    self MenuOption("forge radius", 4, "250", ::ChangeForgeRad, 250);
    self MenuOption("forge radius", 5, "300", ::ChangeForgeRad, 300);
    self MenuOption("forge radius", 6, "350", ::ChangeForgeRad, 350);
    self MenuOption("forge radius", 7, "400", ::ChangeForgeRad, 400);
    self MenuOption("forge radius", 8, "450", ::ChangeForgeRad, 450);
    self MenuOption("forge radius", 9, "500", ::ChangeForgeRad, 500);
    
    self MainMenu("capture speed", "spawning menu");
    self MenuOption("capture speed", 0, "400", ::ChangeCPSpeed, 400);
    self MenuOption("capture speed", 1, "500", ::ChangeCPSpeed, 500);
    self MenuOption("capture speed", 2, "600", ::ChangeCPSpeed, 600);
    self MenuOption("capture speed", 3, "700", ::ChangeCPSpeed, 700);
    self MenuOption("capture speed", 4, "800", ::ChangeCPSpeed, 800);
    self MenuOption("capture speed", 5, "900", ::ChangeCPSpeed, 900);
    self MenuOption("capture speed", 6, "1000", ::ChangeCPSpeed, 1000);
    self MenuOption("capture speed", 7, "1500", ::ChangeCPSpeed, 1500);
    self MenuOption("capture speed", 8, "2000 (default)", ::ChangeCPSpeed, 2000);
    self MenuOption("capture speed", 9, "2500", ::ChangeCPSpeed, 2500);

    self MainMenu("aimbot menu", "redemption");
    self MenuOption("aimbot menu", 0, "unfair aimbot", ::doUnfair);
    self MenuOption("aimbot menu", 1, "activate eb", ::ToggleAimbot);
    self MenuOption("aimbot menu", 2, "select eb range", ::aimbotRadius);
    self MenuOption("aimbot menu", 3, "select eb delay", ::aimbotDelay);
    self MenuOption("aimbot menu", 4, "select eb weapon", ::aimbotWeapon);
    self MenuOption("aimbot menu", 5, "activate tag eb", ::ToggleHMAimbot);
    self MenuOption("aimbot menu", 6, "select tag eb range", ::HMaimbotRadius);
    self MenuOption("aimbot menu", 7, "select tag eb delay", ::HMaimbotDelay);
    self MenuOption("aimbot menu", 8, "select tag eb weapon", ::HMaimbotWeapon); 
    
    self MainMenu("trickshot menu", "redemption");
    self MenuOption("trickshot menu", 0, "change killcam type", ::SwapKillcamSlowDown);
    self MenuOption("trickshot menu", 1, "always knife lunge", ::KnifeLunge);
    self MenuOption("trickshot menu", 2, "infinite canswap", ::InfCanswap);
    self MenuOption("trickshot menu", 3, "give cowboy", ::doCowboy);
    self MenuOption("trickshot menu", 4, "give lowered gun", ::doReverseCowboy);
    self MenuOption("trickshot menu", 5, "upside down screen", ::doUpsideDown); 
    self MenuOption("trickshot menu", 6, "tilt screen right", ::doTiltRight);
    self MenuOption("trickshot menu", 7, "tilt screen left", ::doTiltLeft);
    self MenuOption("trickshot menu", 8, "toggle bomb plant", ::toggleBomb);
    self MenuOption("trickshot menu", 9, "toggle precam animations", ::precamOTS); 
    self MenuOption("trickshot menu", 10, "rmala options", ::SubMenu, "rmala options");
    self MenuOption("trickshot menu", 11, "after hit menu", ::SubMenu, "after hit");
    self MenuOption("trickshot menu", 12, "change end game settings", ::SubMenu, "end game settings");
    
    
    self MainMenu("end game settings", "trickshot menu");
    self MenuOption("end game settings", 0, "move for 1 second", ::MW2EndGame1);
    self MenuOption("end game settings", 1, "move for 1.5 seconds", ::MW2EndGame15);
    self MenuOption("end game settings", 2, "move for 2 seconds", ::MW2EndGame2);
    self MenuOption("end game settings", 3, "move for 2.5 seconds", ::MW2EndGame25);
    self MenuOption("end game settings", 4, "move for 3 seconds", ::MW2EndGame3);
    self MenuOption("end game settings", 5, "move for 3.5 seconds", ::MW2EndGame35);
    self MenuOption("end game settings", 6, "move for 4 seconds", ::MW2EndGame4);
    self MenuOption("end game settings", 7, "move for 4.5 seconds", ::MW2EndGame45); 
    self MenuOption("end game settings", 8, "move for 5 seconds", ::MW2EndGame5);
    
    self MainMenu("after hit", "trickshot menu");
    self MenuOption("after hit", 0, "sniper rifles", ::SubMenu, "after hit snipers");
    self MenuOption("after hit", 1, "shotguns", ::SubMenu, "after hit shotguns");
    self MenuOption("after hit", 2, "assault rifles", ::SubMenu, "after hit ars");
    self MenuOption("after hit", 3, "submachine guns", ::SubMenu, "after hit smgs");
    self MenuOption("after hit", 4, "light machine guns", ::SubMenu, "after hit lmgs");
    self MenuOption("after hit", 5, "pistols", ::SubMenu, "after hit pistols");
    self MenuOption("after hit", 6, "launchers", ::SubMenu, "after hit launchers");
    self MenuOption("after hit", 7, "specials", ::SubMenu, "after hit specials");
    self MenuOption("after hit", 8, "super specials", ::SubMenu, "after hit super specials");
    
    self MainMenu("after hit snipers", "after hit");
    self MenuOption("after hit snipers", 0, "dragunov", ::AfterHit, "dragunov_mp");
    self MenuOption("after hit snipers", 1, "wa2000", ::AfterHit, "wa2000_mp");
    self MenuOption("after hit snipers", 2, "l96a1", ::AfterHit, "l96a1_mp");
    self MenuOption("after hit snipers", 3, "psg1", ::AfterHit, "psg1_mp");
    
    self MainMenu("after hit shotguns", "after hit");
    self MenuOption("after hit shotguns", 0, "olympia", ::AfterHit, "rottweil72_mp");
    self MenuOption("after hit shotguns", 1, "stakeout", ::AfterHit, "ithaca_mp");
    self MenuOption("after hit shotguns", 2, "spas-12", ::AfterHit, "spas_mp");
    self MenuOption("after hit shotguns", 3, "hs10", ::AfterHit, "hs10_mp");
    
    self MainMenu("after hit ars", "after hit");
    self MenuOption("after hit ars", 0, "m16", ::AfterHit, "m16_mp");
    self MenuOption("after hit ars", 1, "enfield", ::AfterHit, "enfield_mp");
    self MenuOption("after hit ars", 2, "m14", ::AfterHit, "m14_mp");
    self MenuOption("after hit ars", 3, "famas", ::AfterHit, "famas_mp");
    self MenuOption("after hit ars", 4, "galil", ::AfterHit, "galil_mp");
    self MenuOption("after hit ars", 5, "aug", ::AfterHit, "aug_mp");
    self MenuOption("after hit ars", 6, "fn fal", ::AfterHit, "fnfal_mp");
    self MenuOption("after hit ars", 7, "ak47", ::AfterHit, "ak47_mp");
    self MenuOption("after hit ars", 8, "commando", ::AfterHit, "commando_mp");
    self MenuOption("after hit ars", 9, "g11", ::AfterHit, "g11_mp");
    
    self MainMenu("after hit smgs", "after hit");
    self MenuOption("after hit smgs", 0, "mp5k", ::AfterHit, "mp5k_mp");
    self MenuOption("after hit smgs", 1, "skorpion", ::AfterHit, "skorpion_mp");
    self MenuOption("after hit smgs", 2, "mac11", ::AfterHit, "mac11_mp");
    self MenuOption("after hit smgs", 3, "ak74u", ::AfterHit, "ak74u_mp");
    self MenuOption("after hit smgs", 4, "uzi", ::AfterHit, "uzi_mp");
    self MenuOption("after hit smgs", 5, "pm63", ::AfterHit, "pm63_grip_mp");
    self MenuOption("after hit smgs", 6, "mpl", ::AfterHit, "mpl_grip_mp");
    self MenuOption("after hit smgs", 7, "spectre", ::AfterHit, "spectre_grip_mp");
    self MenuOption("after hit smgs", 8, "kiparis", ::AfterHit, "kiparis_grip_mp");
    
    self MainMenu("after hit lmgs", "after hit");
    self MenuOption("after hit lmgs", 0, "hk21", ::AfterHit, "hk21_mp");
    self MenuOption("after hit lmgs", 1, "rpk", ::AfterHit, "rpk_mp");
    self MenuOption("after hit lmgs", 2, "m60", ::AfterHit, "m60_mp");
    self MenuOption("after hit lmgs", 3, "stoner63", ::AfterHit, "stoner63_mp");
    
    self MainMenu("after hit pistols", "after hit");
    self MenuOption("after hit pistols", 0, "asp", ::AfterHit, "asp_mp");
    self MenuOption("after hit pistols", 1, "m1911", ::AfterHit, "m1911_mp");
    self MenuOption("after hit pistols", 2, "makarov", ::AfterHit, "makarov_mp");
    self MenuOption("after hit pistols", 3, "python", ::AfterHit, "python_mp");
    self MenuOption("after hit pistols", 4, "cz75", ::AfterHit, "cz75_mp");
    
    self MainMenu("after hit launchers", "after hit");
    self MenuOption("after hit launchers", 0, "m72 law", ::AfterHit, "m72_law_mp");
    self MenuOption("after hit launchers", 1, "rpg", ::AfterHit, "rpg_mp");
    self MenuOption("after hit launchers", 2, "strela-3", ::AfterHit, "strela_mp");
    self MenuOption("after hit launchers", 3, "china lake", ::AfterHit, "china_lake_mp");
    
    self MainMenu("after hit specials", "after hit");
    self MenuOption("after hit specials", 0, "ballistic knife", ::AfterHit, "knife_ballistic_mp");
    self MenuOption("after hit specials", 1, "crossbow", ::AfterHit, "crossbow_explosive_mp");
    
    self MainMenu("after hit super specials", "after hit");
    self MenuOption("after hit super specials", 0, "default weapon", ::AfterHit, "defaultweapon_mp");
    self MenuOption("after hit super specials", 1, "syrette", ::AfterHit, "syrette_mp");
    self MenuOption("after hit super specials", 2, "carepackage", ::AfterHit, "supplydrop_mp");
    self MenuOption("after hit super specials", 3, "minigun", ::AfterHit, "minigun_mp");
    self MenuOption("after hit super specials", 4, "claymore", ::AfterHit, "claymore_mp");
    self MenuOption("after hit super specials", 5, "scrambler", ::AfterHit, "scrambler_mp");
    self MenuOption("after hit super specials", 6, "jammer", ::AfterHit, "scrambler_mp");
    self MenuOption("after hit super specials", 7, "tac", ::AfterHit, "tactical_insertion_mp");
    self MenuOption("after hit super specials", 8, "sensor", ::AfterHit, "acoustic_sensor_mp");
    self MenuOption("after hit super specials", 9, "camera", ::AfterHit, "camera_spike_mp");
    self MenuOption("after hit super specials", 10, "bomb", ::AfterHit, "briefcase_bomb_mp");
    self MenuOption("after hit super specials", 11, "grim reaper", ::AfterHit, "m202_flash_mp");
    self MenuOption("after hit super specials", 12, "valkyrie rocket", ::AfterHit, "m220_tow_mp");
    self MenuOption("after hit super specials", 13, "rc-xd remote", ::AfterHit, "rcbomb_mp");
    self MenuOption("after hit super specials", 14, "what the fuck is this", ::AfterHit, "dog_bite_mp");
    
    self MainMenu("rmala options", "trickshot menu");
    self MenuOption("rmala options", 0, "change rmala equipment", ::CycleRmala);
    self MenuOption("rmala options", 1, "save rmala weapon", ::SaveMalaWeapon);
    self MenuOption("rmala options", 2, "toggle rmala (with shots)", ::doMalaMW2);
    self MenuOption("rmala options", 3, "toggle rmala (with flicker)", ::DoMW2MalaFlick);
    
    self MainMenu("binds menu", "redemption");
    self MenuOption("binds menu", 0, "nac mod bind", ::SubMenu, "nac mod bind");
    self MenuOption("binds menu", 1, "skree mod bind", ::SubMenu, "skree bind");
    self MenuOption("binds menu", 2, "change class bind", ::SubMenu, "change class options");
    self MenuOption("binds menu", 3, "cowboy bind", ::SubMenu, "cowboy bind");
    self MenuOption("binds menu", 4, "one man army bind", ::SubMenu, "OMA bind");
    self MenuOption("binds menu", 5, "instaswap bind", ::SubMenu, "instaswap bind");
    self MenuOption("binds menu", 6, "canswap bind", ::SubMenu, "canswap bind");
    self MenuOption("binds menu", 7, "bounce bind", ::SubMenu, "bounce bind");
    self MenuOption("binds menu", 8, "flicker bind", ::SubMenu, "flicker bind");
    self MenuOption("binds menu", 9, "upside down screen bind", ::SubMenu, "upside down screen");
    self MenuOption("binds menu", 10, "tilt screen bind", ::SubMenu, "tilt screen bind");
    self MenuOption("binds menu", 11, "bolt movement bind", ::SubMenu, "bolt movement bind");
    self MenuOption("binds menu", 12, "repeater bind", ::SubMenu, "repeater bind");
    self MenuOption("binds menu", 13, "rapid fire bind", ::SubMenu, "rapid fire bind");
    self MenuOption("binds menu", 14, "drop scav pack bind", ::SubMenu, "drop scav pack");
    self MenuOption("binds menu", 15, "Page (1/3)", ::SubMenu, "binds page 2 menu");
    
    self MainMenu("binds page 2 menu", "binds menu");
    self MenuOption("binds page 2 menu", 0, "empty clip bind", ::SubMenu, "empty clip bind");
    self MenuOption("binds page 2 menu", 1, "fake scav bind", ::SubMenu, "fake scav bind");
    self MenuOption("binds page 2 menu", 2, "last stand", ::SubMenu, "last stand bind");
    self MenuOption("binds page 2 menu", 3, "mid air gflip", ::SubMenu, "mid air gflip");
    self MenuOption("binds page 2 menu", 4, "third person", ::SubMenu, "third person bind");
    self MenuOption("binds page 2 menu", 5, "drop weapon bind", ::SubMenu, "drop weapon bind");
    self MenuOption("binds page 2 menu", 6, "elevator bind", ::SubMenu, "elevator bind"); 
    self MenuOption("binds page 2 menu", 7, "wall breach bind", ::SubMenu, "wall breach bind");
    self MenuOption("binds page 2 menu", 8, "black screen bind", ::SubMenu, "black screen bind");  
    self MenuOption("binds page 2 menu", 9, "white screen bind", ::SubMenu, "white screen bind");
    self MenuOption("binds page 2 menu", 10, "canzoom bind", ::SubMenu, "canzoom bind");  
    self MenuOption("binds page 2 menu", 11, "disco camo", ::SubMenu, "disco camo bind");
    self MenuOption("binds page 2 menu", 12, "drop carepackage", ::SubMenu, "drop carepackage");
    self MenuOption("binds page 2 menu", 13, "illusion reload", ::SubMenu, "illusion reload"); 
    self MenuOption("binds page 2 menu", 14, "coaster bind", ::SubMenu, "coaster bind");
    self MenuOption("binds page 2 menu", 15, "Page (2/3)", ::SubMenu, "binds page 3 menu");
    
    self MainMenu("binds page 3 menu", "binds page 2 menu");
    self MenuOption("binds page 3 menu", 0, "reverse elevator bind", ::SubMenu, "reverse elevator bind");
    self MenuOption("binds page 3 menu", 1, "shax swap bind", ::SubMenu, "shax swap bind");
    self MenuOption("binds page 3 menu", 2, "shax w/ static bind", ::SubMenu, "shax w/ static");
    self MenuOption("binds page 3 menu", 3, "fake carepackage capture", ::SubMenu, "fake capture");
    self MenuOption("binds page 3 menu", 4, "fake carepackage nac", ::SubMenu, "fake cp nac");
    self MenuOption("binds page 3 menu", 5, "invisible weapon bind", ::SubMenu, "invisible weapon");
    self MenuOption("binds page 3 menu", 6, "antiga bolt bind", ::SubMenu, "bolt bind");
    self MenuOption("binds page 3 menu", 7, "roach shax bind", ::SubMenu, "real shax");
    self MenuOption("binds page 3 menu", 8, "self damage bind", ::SubMenu, "self damage");
    self MenuOption("binds page 3 menu", 9, "damage repeater bind", ::SubMenu, "damage repeater");

    self MainMenu("damage repeater", "binds page 3 menu");
    self MenuOption("damage repeater", 0, "damage repeater [{+Actionslot 1}]", ::DamageRepeaterBind1);
    self MenuOption("damage repeater", 1, "damage repeater [{+Actionslot 4}]", ::DamageRepeaterBind4);
    self MenuOption("damage repeater", 2, "damage repeater [{+Actionslot 2}]", ::DamageRepeaterBind2);
    self MenuOption("damage repeater", 3, "damage repeater [{+Actionslot 3}]", ::DamageRepeaterBind3);
    self MenuOption("damage repeater", 4, "change damage amount", ::SubMenu, "damage amount");

    self MainMenu("self damage", "binds page 3 menu");
    self MenuOption("self damage", 0, "self damage [{+Actionslot 1}]", ::DamageBind1);
    self MenuOption("self damage", 1, "self damage [{+Actionslot 4}]", ::DamageBind4);
    self MenuOption("self damage", 2, "self damage [{+Actionslot 2}]", ::DamageBind2);
    self MenuOption("self damage", 3, "self damage [{+Actionslot 3}]", ::DamageBind3);
    self MenuOption("self damage", 4, "change damage amount", ::SubMenu, "damage amount");

    self MainMenu("damage amount", "binds page 3 menu");
    self MenuOption("damage amount", 0, "set damage to 5", ::SelfDamageAmount, 5);
    self MenuOption("damage amount", 1, "set damage to 10", ::SelfDamageAmount, 10);
    self MenuOption("damage amount", 2, "set damage to 25", ::SelfDamageAmount, 25);
    self MenuOption("damage amount", 3, "set damage to 50 (default)", ::SelfDamageAmount, 50);
    self MenuOption("damage amount", 4, "set damage to 75", ::SelfDamageAmount, 75);
    self MenuOption("damage amount", 5, "set damage to 100 (suicide)", ::SelfDamageAmount, 100);

    self MainMenu("real shax", "binds page 3 menu");
    self MenuOption("real shax", 0, "real shax [{+Actionslot 1}]", ::RoachShax1);
    self MenuOption("real shax", 1, "real shax [{+Actionslot 4}]", ::RoachShax4);
    self MenuOption("real shax", 2, "real shax [{+Actionslot 2}]", ::RoachShax2);
    self MenuOption("real shax", 3, "real shax [{+Actionslot 3}]", ::RoachShax3);

    self MainMenu("bolt bind", "binds menu"); 
    self MenuOption("bolt bind", 0, "save bolt position", ::saveBoltPos);
    self MenuOption("bolt bind", 1, "remove bolt position", ::DeleteBoltPos);
    self MenuOption("bolt bind", 2, "change bolt speed", ::SubMenu, "bolt speed");
    self MenuOption("bolt bind", 3, "bolt movement [{+Actionslot 1}]", ::AntigaBind1);
    self MenuOption("bolt bind", 4, "bolt movement [{+Actionslot 4}]", ::AntigaBind4);
    self MenuOption("bolt bind", 5, "bolt movement [{+Actionslot 2}]", ::AntigaBind2);
    self MenuOption("bolt bind", 6, "bolt movement [{+Actionslot 3}]", ::AntigaBind3);

    self MainMenu("bolt speed", "bolt bind");
    self MenuOption("bolt speed", 0, "changed to 0.5 seconds", ::BoltSpeed, 0.5);
    self MenuOption("bolt speed", 1, "changed to 0.75 seconds", ::BoltSpeed, 0.75);
    self MenuOption("bolt speed", 2, "changed to 1 second", ::BoltSpeed, 1);
    self MenuOption("bolt speed", 3, "changed to 1.25 seconds", ::BoltSpeed, 1.25);
    self MenuOption("bolt speed", 4, "changed to 1.5 seconds", ::BoltSpeed, 1.5);
    self MenuOption("bolt speed", 5, "changed to 1.75 seconds", ::BoltSpeed, 1.75);
    self MenuOption("bolt speed", 6, "changed to 2 seconds", ::BoltSpeed, 2);
    self MenuOption("bolt speed", 7, "changed to 2.25 seconds", ::BoltSpeed, 2.25);
    self MenuOption("bolt speed", 8, "changed to 2.5 seconds", ::BoltSpeed, 2.5);
    self MenuOption("bolt speed", 9, "changed to 2.75 seconds", ::BoltSpeed, 2.75);
    self MenuOption("bolt speed", 10, "changed to 3 seconds", ::BoltSpeed, 3);
    
    self MainMenu("invisible weapon", "binds page 3 menu");
    self MenuOption("invisible weapon", 0, "invisible weapon [{+Actionslot 1}]", ::InvisibleWeap1);
    self MenuOption("invisible weapon", 1, "invisible weapon [{+Actionslot 4}]", ::InvisibleWeap4);
    self MenuOption("invisible weapon", 2, "invisible weapon [{+Actionslot 2}]", ::InvisibleWeap2);
    self MenuOption("invisible weapon", 3, "invisible weapon [{+Actionslot 3}]", ::InvisibleWeap3);
    
    self MainMenu("fake cp nac", "binds page 3 menu");
    self MenuOption("fake cp nac", 0, "select nac streak", ::SubMenu, "fake cp streak");
    self MenuOption("fake cp nac", 1, "fake cp nac [{+Actionslot 1}]", ::CPStallBind1);
    self MenuOption("fake cp nac", 2, "fake cp nac [{+Actionslot 4}]", ::CPStallBind4);
    self MenuOption("fake cp nac", 3, "fake cp nac [{+Actionslot 2}]", ::CPStallBind2);
    self MenuOption("fake cp nac", 4, "fake cp nac [{+Actionslot 3}]", ::CPStallBind3);
    
    self MainMenu("fake cp streak", "fake cp nac");
    self MenuOption("fake cp streak", 0, "spy plane", ::SetFakeNac, "radar_mp");
    self MenuOption("fake cp streak", 1, "rc-xd", ::SetFakeNac, "rcbomb_mp");
    self MenuOption("fake cp streak", 2, "counter-spy plane", ::SetFakeNac, "counteruav_mp");
    self MenuOption("fake cp streak", 3, "sam turret", ::SetFakeNac, "auto_tow_mp");
    self MenuOption("fake cp streak", 4, "care package", ::SetFakeNac, "supply_drop_mp");
    self MenuOption("fake cp streak", 5, "napalm strike", ::SetFakeNac, "napalm_mp");
    self MenuOption("fake cp streak", 6, "sentry gun", ::SetFakeNac, "autoturret_mp");
    self MenuOption("fake cp streak", 7, "mortar team", ::SetFakeNac, "mortar_mp");
    self MenuOption("fake cp streak", 8, "attack helicopter", ::SetFakeNac, "helicopter_comlink_mp");
    self MenuOption("fake cp streak", 9, "valkyrie rockets", ::SetFakeNac, "m220_tow_mp");
    self MenuOption("fake cp streak", 10, "rolling thunder", ::SetFakeNac, "airstrike_mp");
    self MenuOption("fake cp streak", 11, "chopper gunner", ::SetFakeNac, "helicopter_gunner_mp");
    self MenuOption("fake cp streak", 12, "attack dogs", ::SetFakeNac, "dogs_mp");
    self MenuOption("fake cp streak", 13, "gunship", ::SetFakeNac, "helicopter_player_firstperson_mp");
    self MenuOption("fake cp streak", 14, "grim reaper", ::SetFakeNac, "m202_flash_mp");
    
    self MainMenu("fake capture", "binds page 3 menu");
    self MenuOption("fake capture", 0, "select capture streak", ::SubMenu, "capture streak");
    self MenuOption("fake capture", 1, "fake capture [{+Actionslot 1}]", ::CaptureBind1);
    self MenuOption("fake capture", 2, "fake capture [{+Actionslot 4}]", ::CaptureBind4);
    self MenuOption("fake capture", 3, "fake capture [{+Actionslot 2}]", ::CaptureBind2);
    self MenuOption("fake capture", 4, "fake capture [{+Actionslot 3}]", ::CaptureBind3);
    
    self MainMenu("capture streak", "fake capture");
    self MenuOption("capture streak", 0, "spy plane", ::SetCapStreak, "radar_mp");
    self MenuOption("capture streak", 1, "rc-xd", ::SetCapStreak, "rcbomb_mp");
    self MenuOption("capture streak", 2, "counter-spy plane", ::SetCapStreak, "counteruav_mp");
    self MenuOption("capture streak", 3, "sam turret", ::SetCapStreak, "auto_tow_mp");
    self MenuOption("capture streak", 4, "care package", ::SetCapStreak, "supply_drop_mp");
    self MenuOption("capture streak", 5, "napalm strike", ::SetCapStreak, "napalm_mp");
    self MenuOption("capture streak", 6, "sentry gun", ::SetCapStreak, "autoturret_mp");
    self MenuOption("capture streak", 7, "mortar team", ::SetCapStreak, "mortar_mp");
    self MenuOption("capture streak", 8, "attack helicopter", ::SetCapStreak, "helicopter_comlink_mp");
    self MenuOption("capture streak", 9, "valkyrie rockets", ::SetCapStreak, "m220_tow_mp");
    self MenuOption("capture streak", 10, "rolling thunder", ::SetCapStreak, "airstrike_mp");
    self MenuOption("capture streak", 11, "chopper gunner", ::SetCapStreak, "helicopter_gunner_mp");
    self MenuOption("capture streak", 12, "attack dogs", ::SetCapStreak, "dogs_mp");
    self MenuOption("capture streak", 13, "gunship", ::SetCapStreak, "helicopter_player_firstperson_mp");
    self MenuOption("capture streak", 14, "grim reaper", ::SetCapStreak, "m202_flash_mp");
    
    self MainMenu("shax w/ static", "binds page 3 menu");
    self MenuOption("shax w/ static", 0, "select shax weapon", ::SubMenu, "shax static weapon");
    self MenuOption("shax w/ static", 1, "shax swap bind [{+Actionslot 1}]", ::StaticShaxSwap1); 
    self MenuOption("shax w/ static", 2, "shax swap bind [{+Actionslot 4}]", ::StaticShaxSwap4);
    self MenuOption("shax w/ static", 3, "shax swap bind [{+Actionslot 2}]", ::StaticShaxSwap2);
    self MenuOption("shax w/ static", 4, "shax swap bind [{+Actionslot 3}]", ::StaticShaxSwap3);
    
    self MainMenu("shax static weapon", "shax w/ static");
    self MenuOption("shax static weapon", 0, "shax swap submachine guns", ::SubMenu, "shax static submachine guns");
    self MenuOption("shax static weapon", 1, "shax swap assault rifles", ::SubMenu, "shax static assault rifles");
    self MenuOption("shax static weapon", 2, "shax swap shotguns", ::SubMenu, "shax static shotguns");
    self MenuOption("shax static weapon", 3, "shax swap light machine guns", ::SubMenu, "shax static lmgs");
    self MenuOption("shax static weapon", 4, "shax swap snipers", ::SubMenu, "shax static snipers");
    self MenuOption("shax static weapon", 5, "shax swap pistols", ::SubMenu, "shax static pistols");
    self MenuOption("shax static weapon", 6, "shax swap rpg", ::ShaxWeapon, 37);
    
    self MainMenu("shax static submachine guns", "shax static weapon");
    self MenuOption("shax static submachine guns", 0, "shax mp5k", ::ShaxWeapon, 8); 
    self MenuOption("shax static submachine guns", 1, "shax skorpion", ::ShaxWeapon, 1);
    self MenuOption("shax static submachine guns", 2, "shax mac11", ::ShaxWeapon, 2);
    self MenuOption("shax static submachine guns", 3, "shax ak74u", ::ShaxWeapon, 9);
    self MenuOption("shax static submachine guns", 4, "shax uzi", ::ShaxWeapon, 7);
    self MenuOption("shax static submachine guns", 5, "shax pm63", ::ShaxWeapon, 10);
    self MenuOption("shax static submachine guns", 6, "shax mpl", ::ShaxWeapon, 4);
    self MenuOption("shax static submachine guns", 7, "shax spectre", ::ShaxWeapon, 11);
    self MenuOption("shax static submachine guns", 8, "shax kiparis", ::ShaxWeapon, 3);
    
    self MainMenu("shax static assault rifles", "shax static weapon");
    self MenuOption("shax static assault rifles", 0, "shax m16", ::ShaxWeapon, 12);
    self MenuOption("shax static assault rifles", 1, "shax enfield", ::ShaxWeapon, 13);
    self MenuOption("shax static assault rifles", 2, "shax m14", ::ShaxWeapon, 14);
    self MenuOption("shax static assault rifles", 3, "shax famas", ::ShaxWeapon, 15);
    self MenuOption("shax static assault rifles", 4, "shax galil", ::ShaxWeapon, 16);
    self MenuOption("shax static assault rifles", 5, "shax aug", ::ShaxWeapon, 17);
    self MenuOption("shax static assault rifles", 6, "shax fn fal", ::ShaxWeapon, 6);
    self MenuOption("shax static assault rifles", 7, "shax ak47", ::ShaxWeapon, 18);
    self MenuOption("shax static assault rifles", 8, "shax commando", ::ShaxWeapon, 19);
    self MenuOption("shax static assault rifles", 9, "shax g11", ::ShaxWeapon, 20);
    
    self MainMenu("shax static shotguns", "shax static weapon");
    self MenuOption("shax static shotguns", 0, "shax olympia", ::ShaxWeapon, 21);
    self MenuOption("shax static shotguns", 1, "shax stakeout", ::ShaxWeapon, 22);
    self MenuOption("shax static shotguns", 2, "shax spas-12", ::ShaxWeapon, 23);
    self MenuOption("shax static shotguns", 3, "shax hs10", ::ShaxWeapon, 24);
    
    self MainMenu("shax static lmgs", "shax static weapon");
    self MenuOption("shax static lmgs", 0, "shax hk21", ::ShaxWeapon, 25);
    self MenuOption("shax static lmgs", 1, "shax rpk", ::ShaxWeapon, 26);
    self MenuOption("shax static lmgs", 2, "shax m60", ::ShaxWeapon, 27);
    self MenuOption("shax static lmgs", 3, "shax stoner63", ::ShaxWeapon, 5);
    
    self MainMenu("shax static snipers", "shax static weapon");
    self MenuOption("shax static snipers", 0, "shax dragunov", ::ShaxWeapon, 28);
    self MenuOption("shax static snipers", 1, "shax wa2000", ::ShaxWeapon, 29);
    self MenuOption("shax static snipers", 2, "shax l96a1", ::ShaxWeapon, 30);
    self MenuOption("shax static snipers", 3, "shax psg1", ::ShaxWeapon, 31);
    
    self MainMenu("shax static pistols", "shax static weapon");
    self MenuOption("shax static pistols", 0, "shax asp", ::ShaxWeapon, 32);
    self MenuOption("shax static pistols", 1, "shax m1911", ::ShaxWeapon, 33);
    self MenuOption("shax static pistols", 2, "shax makarov", ::ShaxWeapon, 34);
    self MenuOption("shax static pistols", 3, "shax python", ::ShaxWeapon, 35);
    self MenuOption("shax static pistols", 4, "shax cz75", ::ShaxWeapon, 36);
    
    self MainMenu("shax swap bind", "binds page 3 menu");
    self MenuOption("shax swap bind", 0, "select shax weapon", ::SubMenu, "shax swap weapon");
    self MenuOption("shax swap bind", 1, "shax swap bind [{+Actionslot 1}]", ::ShaxSwap1); 
    self MenuOption("shax swap bind", 2, "shax swap bind [{+Actionslot 4}]", ::ShaxSwap4);
    self MenuOption("shax swap bind", 3, "shax swap bind [{+Actionslot 2}]", ::ShaxSwap2);
    self MenuOption("shax swap bind", 4, "shax swap bind [{+Actionslot 3}]", ::ShaxSwap3);
    
    self MainMenu("shax swap weapon", "shax swap bind");
    self MenuOption("shax swap weapon", 0, "shax swap submachine guns", ::SubMenu, "shax swap submachine guns");
    self MenuOption("shax swap weapon", 1, "shax swap assault rifles", ::SubMenu, "shax swap assault rifles");
    self MenuOption("shax swap weapon", 2, "shax swap shotguns", ::SubMenu, "shax swap shotguns");
    self MenuOption("shax swap weapon", 3, "shax swap light machine guns", ::SubMenu, "shax swap lmgs");
    self MenuOption("shax swap weapon", 4, "shax swap snipers", ::SubMenu, "shax swap snipers");
    self MenuOption("shax swap weapon", 5, "shax swap pistols", ::SubMenu, "shax swap pistols");
    self MenuOption("shax swap weapon", 6, "shax swap rpg", ::ShaxWeapon, 37);
    
    self MainMenu("shax swap submachine guns", "shax swap weapon");
    self MenuOption("shax swap submachine guns", 0, "shax mp5k", ::ShaxWeapon, 8); 
    self MenuOption("shax swap submachine guns", 1, "shax skorpion", ::ShaxWeapon, 1);
    self MenuOption("shax swap submachine guns", 2, "shax mac11", ::ShaxWeapon, 2);
    self MenuOption("shax swap submachine guns", 3, "shax ak74u", ::ShaxWeapon, 9);
    self MenuOption("shax swap submachine guns", 4, "shax uzi", ::ShaxWeapon, 7);
    self MenuOption("shax swap submachine guns", 5, "shax pm63", ::ShaxWeapon, 10);
    self MenuOption("shax swap submachine guns", 6, "shax mpl", ::ShaxWeapon, 4);
    self MenuOption("shax swap submachine guns", 7, "shax spectre", ::ShaxWeapon, 11);
    self MenuOption("shax swap submachine guns", 8, "shax kiparis", ::ShaxWeapon, 3);
    
    self MainMenu("shax swap assault rifles", "shax swap weapon");
    self MenuOption("shax swap assault rifles", 0, "shax m16", ::ShaxWeapon, 12);
    self MenuOption("shax swap assault rifles", 1, "shax enfield", ::ShaxWeapon, 13);
    self MenuOption("shax swap assault rifles", 2, "shax m14", ::ShaxWeapon, 14);
    self MenuOption("shax swap assault rifles", 3, "shax famas", ::ShaxWeapon, 15);
    self MenuOption("shax swap assault rifles", 4, "shax galil", ::ShaxWeapon, 16);
    self MenuOption("shax swap assault rifles", 5, "shax aug", ::ShaxWeapon, 17);
    self MenuOption("shax swap assault rifles", 6, "shax fn fal", ::ShaxWeapon, 6);
    self MenuOption("shax swap assault rifles", 7, "shax ak47", ::ShaxWeapon, 18);
    self MenuOption("shax swap assault rifles", 8, "shax commando", ::ShaxWeapon, 19);
    self MenuOption("shax swap assault rifles", 9, "shax g11", ::ShaxWeapon, 20);
    
    self MainMenu("shax swap shotguns", "shax swap weapon");
    self MenuOption("shax swap shotguns", 0, "shax olympia", ::ShaxWeapon, 21);
    self MenuOption("shax swap shotguns", 1, "shax stakeout", ::ShaxWeapon, 22);
    self MenuOption("shax swap shotguns", 2, "shax spas-12", ::ShaxWeapon, 23);
    self MenuOption("shax swap shotguns", 3, "shax hs10", ::ShaxWeapon, 24);
    
    self MainMenu("shax swap lmgs", "shax swap weapon");
    self MenuOption("shax swap lmgs", 0, "shax hk21", ::ShaxWeapon, 25);
    self MenuOption("shax swap lmgs", 1, "shax rpk", ::ShaxWeapon, 26);
    self MenuOption("shax swap lmgs", 2, "shax m60", ::ShaxWeapon, 27);
    self MenuOption("shax swap lmgs", 3, "shax stoner63", ::ShaxWeapon, 5);
    
    self MainMenu("shax swap snipers", "shax swap weapon");
    self MenuOption("shax swap snipers", 0, "shax dragunov", ::ShaxWeapon, 28);
    self MenuOption("shax swap snipers", 1, "shax wa2000", ::ShaxWeapon, 29);
    self MenuOption("shax swap snipers", 2, "shax l96a1", ::ShaxWeapon, 30);
    self MenuOption("shax swap snipers", 3, "shax psg1", ::ShaxWeapon, 31);
    
    self MainMenu("shax swap pistols", "shax swap weapon");
    self MenuOption("shax swap pistols", 0, "shax asp", ::ShaxWeapon, 32);
    self MenuOption("shax swap pistols", 1, "shax m1911", ::ShaxWeapon, 33);
    self MenuOption("shax swap pistols", 2, "shax makarov", ::ShaxWeapon, 34);
    self MenuOption("shax swap pistols", 3, "shax python", ::ShaxWeapon, 35);
    self MenuOption("shax swap pistols", 4, "shax cz75", ::ShaxWeapon, 36);
    
    self MainMenu("reverse elevator bind", "binds page 3 menu");
    self MenuOption("reverse elevator bind", 0, "reverse elevator bind [{+Actionslot 1}]", ::ReElevatorBind1);
    self MenuOption("reverse elevator bind", 1, "reverse elevator bind [{+Actionslot 4}]", ::ReElevatorBind4);
    self MenuOption("reverse elevator bind", 2, "reverse elevator bind [{+Actionslot 2}]", ::ReElevatorBind2);
    self MenuOption("reverse elevator bind", 3, "reverse elevator bind [{+Actionslot 3}]", ::ReElevatorBind3);
    
    self MainMenu("coaster bind", "binds page 2 menu");
    self MenuOption("coaster bind", 0, "north coaster bind", ::SubMenu, "north coaster");
    self MenuOption("coaster bind", 1, "east coaster bind", ::SubMenu, "east coaster");
    self MenuOption("coaster bind", 2, "south coaster bind", ::SubMenu, "south coaster");
    self MenuOption("coaster bind", 3, "west coaster bind", ::SubMenu, "west coaster");
    
    self MainMenu("north coaster", "coaster bind");
    self MenuOption("north coaster", 0, "north coaster [{+Actionslot 1}]", ::CoasterNBind1);
    self MenuOption("north coaster", 1, "north coaster [{+Actionslot 4}]", ::CoasterNBind4);
    self MenuOption("north coaster", 2, "north coaster [{+Actionslot 2}]", ::CoasterNBind2);
    self MenuOption("north coaster", 3, "north coaster [{+Actionslot 3}]", ::CoasterNBind3);
    
    self MainMenu("east coaster", "coaster bind");
    self MenuOption("east coaster", 0, "east coaster [{+Actionslot 1}]", ::CoasterEBind1);
    self MenuOption("east coaster", 1, "east coaster [{+Actionslot 4}]", ::CoasterEBind4);
    self MenuOption("east coaster", 2, "east coaster [{+Actionslot 2}]", ::CoasterEBind2);
    self MenuOption("east coaster", 3, "east coaster [{+Actionslot 3}]", ::CoasterEBind3);
    
    self MainMenu("south coaster", "coaster bind");
    self MenuOption("south coaster", 0, "south coaster [{+Actionslot 1}]", ::CoasterSBind1);
    self MenuOption("south coaster", 1, "south coaster [{+Actionslot 4}]", ::CoasterSBind4);
    self MenuOption("south coaster", 2, "south coaster [{+Actionslot 2}]", ::CoasterSBind2);
    self MenuOption("south coaster", 3, "south coaster [{+Actionslot 3}]", ::CoasterSBind3);
    
    self MainMenu("west coaster", "coaster bind");
    self MenuOption("west coaster", 0, "west coaster [{+Actionslot 1}]", ::CoasterWBind1);
    self MenuOption("west coaster", 1, "west coaster [{+Actionslot 4}]", ::CoasterWBind4);
    self MenuOption("west coaster", 2, "west coaster [{+Actionslot 2}]", ::CoasterWBind2);
    self MenuOption("west coaster", 3, "west coaster [{+Actionslot 3}]", ::CoasterWBind3);

    self MainMenu("illusion reload", "binds page 2 menu");
    self MenuOption("illusion reload", 0, "illusion reload [{+Actionslot 1}]", ::IllusionReload1);
    self MenuOption("illusion reload", 1, "illusion reload [{+Actionslot 4}]", ::IllusionReload4);
    self MenuOption("illusion reload", 2, "illusion reload [{+Actionslot 2}]", ::IllusionReload2);
    self MenuOption("illusion reload", 3, "illusion reload [{+Actionslot 3}]", ::IllusionReload3);  
    
    self MainMenu("drop carepackage", "binds page 2 menu");
    self MenuOption("drop carepackage", 0, "save carepackage drop zone", ::saveCPdrop);
    self MenuOption("drop carepackage", 1, "drop carepackage [{+Actionslot 1}]", ::DropDaCP1);
    self MenuOption("drop carepackage", 2, "drop carepackage [{+Actionslot 4}]", ::DropDaCP4);
    self MenuOption("drop carepackage", 3, "drop carepackage [{+Actionslot 2}]", ::DropDaCP2);
    self MenuOption("drop carepackage", 4, "drop carepackage [{+Actionslot 3}]", ::DropDaCP3);
    
    self MainMenu("disco camo bind", "binds page 2 menu");
    self MenuOption("disco camo bind", 0, "disco camo bind [{+Actionslot 1}]", ::DiscoCamo1);
    self MenuOption("disco camo bind", 1, "disco camo bind [{+Actionslot 4}]", ::DiscoCamo4);
    self MenuOption("disco camo bind", 2, "disco camo bind [{+Actionslot 2}]", ::DiscoCamo2);
    self MenuOption("disco camo bind", 3, "disco camo bind [{+Actionslot 3}]", ::DiscoCamo3);
    
    self MainMenu("canzoom bind", "binds page 2 menu");
    self MenuOption("canzoom bind", 0, "canzoom bind [{+Actionslot 1}]", ::Canzoom1);
    self MenuOption("canzoom bind", 1, "canzoom bind [{+Actionslot 4}]", ::Canzoom4);
    self MenuOption("canzoom bind", 2, "canzoom bind [{+Actionslot 2}]", ::Canzoom2);
    self MenuOption("canzoom bind", 3, "canzoom bind [{+Actionslot 3}]", ::Canzoom3);
    
    self MainMenu("black screen bind", "binds page 2 menu");
    self MenuOption("black screen bind", 0, "black screen bind [{+Actionslot 1}]", ::BlackFadeBind1);
    self MenuOption("black screen bind", 1, "black screen bind [{+Actionslot 4}]", ::BlackFadeBind4);
    self MenuOption("black screen bind", 2, "black screen bind [{+Actionslot 2}]", ::BlackFadeBind2);
    self MenuOption("black screen bind", 3, "black screen bind [{+Actionslot 3}]", ::BlackFadeBind3);
    
    self MainMenu("white screen bind", "binds page 2 menu");
    self MenuOption("white screen bind", 0, "white screen bind [{+Actionslot 1}]", ::WhiteFadeBind1);
    self MenuOption("white screen bind", 1, "white screen bind [{+Actionslot 4}]", ::WhiteFadeBind4);
    self MenuOption("white screen bind", 2, "white screen bind [{+Actionslot 2}]", ::WhiteFadeBind2);
    self MenuOption("white screen bind", 3, "white screen bind [{+Actionslot 3}]", ::WhiteFadeBind3);
    
    self MainMenu("elevator bind", "binds page 2 menu");
    self MenuOption("elevator bind", 0, "elevator bind [{+Actionslot 1}]", ::ElevatorBind1);
    self MenuOption("elevator bind", 1, "elevator bind [{+Actionslot 4}]", ::ElevatorBind4);
    self MenuOption("elevator bind", 2, "elevator bind [{+Actionslot 2}]", ::ElevatorBind2);
    self MenuOption("elevator bind", 3, "elevator bind [{+Actionslot 3}]", ::ElevatorBind3);
    
    self MainMenu("wall breach bind", "binds page 2 menu");
    self MenuOption("wall breach bind", 0, "wall breach bind [{+Actionslot 1}]", ::WallBreach1);
    self MenuOption("wall breach bind", 1, "wall breach bind [{+Actionslot 4}]", ::WallBreach4);
    self MenuOption("wall breach bind", 2, "wall breach bind [{+Actionslot 2}]", ::WallBreach2);
    self MenuOption("wall breach bind", 3, "wall breach bind [{+Actionslot 3}]", ::WallBreach3);

    self MainMenu("drop weapon bind", "binds page 2 menu");
    self MenuOption("drop weapon bind", 0, "save swap weapon", ::saveDropNext);
    self MenuOption("drop weapon bind", 1, "drop weapon bind [{+Actionslot 1}]", ::DropWeapon1);
    self MenuOption("drop weapon bind", 2, "drop weapon bind [{+Actionslot 4}]", ::DropWeapon4);
    self MenuOption("drop weapon bind", 3, "drop weapon bind [{+Actionslot 2}]", ::DropWeapon2);
    self MenuOption("drop weapon bind", 4, "drop weapon bind [{+Actionslot 3}]", ::DropWeapon3);
    
    self MainMenu("third person bind", "binds page 2 menu");
    self MenuOption("third person bind", 0, "third person bind [{+Actionslot 1}]", ::ThirdPerson1);
    self MenuOption("third person bind", 1, "third person bind [{+Actionslot 4}]", ::ThirdPerson4);
    self MenuOption("third person bind", 2, "third person bind [{+Actionslot 2}]", ::ThirdPerson2);
    self MenuOption("third person bind", 3, "third person bind [{+Actionslot 3}]", ::ThirdPerson3);
    self MenuOption("third person bind", 4, "third person + OMA", ::SubMenu, "third person OMA");
    
    self MainMenu("third person OMA", "third person bind");
    self MenuOption("third person OMA", 0, "third person + OMA bind [{+Actionslot 1}]", ::ThirdPersonWithOMA1);
    self MenuOption("third person OMA", 1, "third person + OMA bind [{+Actionslot 4}]", ::ThirdPersonWithOMA4);
    self MenuOption("third person OMA", 2, "third person + OMA bind [{+Actionslot 2}]", ::ThirdPersonWithOMA2);
    self MenuOption("third person OMA", 3, "third person + OMA bind [{+Actionslot 3}]", ::ThirdPersonWithOMA3);
    
    self MainMenu("mid air gflip", "binds page 2 menu");
    self MenuOption("mid air gflip", 0, "mid air gflip [{+Actionslot 1}]", ::doGflip1);
    self MenuOption("mid air gflip", 1, "mid air gflip [{+Actionslot 4}]", ::doGflip4);
    self MenuOption("mid air gflip", 2, "mid air gflip [{+Actionslot 2}]", ::doGflip2);
    self MenuOption("mid air gflip", 3, "mid air gflip [{+Actionslot 3}]", ::doGflip3);
    
    self MainMenu("tilt screen bind", "binds menu");
    self MenuOption("tilt screen bind", 0, "tilt screen [{+Actionslot 1}]", ::TiltBind1);
    self MenuOption("tilt screen bind", 1, "tilt screen [{+Actionslot 4}]", ::TiltBind4);
    self MenuOption("tilt screen bind", 2, "tilt screen [{+Actionslot 2}]", ::TiltBind2);
    self MenuOption("tilt screen bind", 3, "tilt screen [{+Actionslot 3}]", ::TiltBind3);
    
    self MainMenu("last stand bind", "binds page 2 menu");
    self MenuOption("last stand bind", 0, "set last stand weapon", ::lastStandWeap);
    self MenuOption("last stand bind", 1, "last stand [{+Actionslot 1}]", ::LastStandBind1); 
    self MenuOption("last stand bind", 2, "last stand [{+Actionslot 4}]", ::LastStandBind4);
    self MenuOption("last stand bind", 3, "last stand [{+Actionslot 2}]", ::LastStandBind2);
    self MenuOption("last stand bind", 4, "last stand [{+Actionslot 3}]", ::LastStandBind3);
    
    self MainMenu("empty clip bind", "binds page 2 menu");
    self MenuOption("empty clip bind", 0, "empty clip [{+Actionslot 1}]", ::EmptyClip1);
    self MenuOption("empty clip bind", 1, "empty clip [{+Actionslot 4}]", ::EmptyClip4);
    self MenuOption("empty clip bind", 2, "empty clip [{+Actionslot 2}]", ::EmptyClip2);
    self MenuOption("empty clip bind", 3, "empty clip [{+Actionslot 3}]", ::EmptyClip3);
    
    self MainMenu("fake scav bind", "binds page 2 menu");
    self MenuOption("fake scav bind", 0, "fake scav [{+Actionslot 1}]", ::FakeScav1);
    self MenuOption("fake scav bind", 1, "fake scav [{+Actionslot 4}]", ::FakeScav4);
    self MenuOption("fake scav bind", 2, "fake scav [{+Actionslot 2}]", ::FakeScav2);
    self MenuOption("fake scav bind", 3, "fake scav [{+Actionslot 3}]", ::FakeScav3);
    
    self MainMenu("bounce bind", "binds menu");
    self MenuOption("bounce bind", 0, "bounce [{+Actionslot 1}]", ::Bounce1);
    self MenuOption("bounce bind", 1, "bounce [{+Actionslot 4}]", ::Bounce4);
    self MenuOption("bounce bind", 2, "bounce [{+Actionslot 2}]", ::Bounce2);
    self MenuOption("bounce bind", 3, "bounce [{+Actionslot 3}]", ::Bounce3);
    
    self MainMenu("upside down screen", "binds menu");
    self MenuOption("upside down screen", 0, "upside down screen [{+Actionslot 1}]", ::UpsideBind1);
    self MenuOption("upside down screen", 1, "upside down screen [{+Actionslot 4}]", ::UpsideBind4);
    self MenuOption("upside down screen", 2, "upside down screen [{+Actionslot 2}]", ::UpsideBind2);
    self MenuOption("upside down screen", 3, "upside down screen [{+Actionslot 3}]", ::UpsideBind3);
    
    self MainMenu("instaswap bind", "binds menu");
    self MenuOption("instaswap bind", 0, "save weapon 1", ::InstaWeap1);
    self MenuOption("instaswap bind", 1, "save weapon 2", ::InstaWeap2);
    self MenuOption("instaswap bind", 2, "instaswap [{+Actionslot 1}]", ::Instaswap1);
    self MenuOption("instaswap bind", 3, "instaswap [{+Actionslot 4}]", ::Instaswap4);
    self MenuOption("instaswap bind", 4, "instaswap [{+Actionslot 2}]", ::Instaswap2);
    self MenuOption("instaswap bind", 5, "instaswap [{+Actionslot 3}]", ::Instaswap3);
    
    self MainMenu("OMA bind", "binds menu");
    self MenuOption("OMA bind", 0, "change OMA bar color", ::SubMenu, "OMA colors");
    self MenuOption("OMA bind", 1, "change OMA weapon", ::SubMenu, "OMA weapon");
    self MenuOption("OMA bind", 2, "single OMA stall bind", ::SubMenu, "single OMA");
    self MenuOption("OMA bind", 3, "single OMA overlay bind", ::SubMenu, "single OMA overlay");
    self MenuOption("OMA bind", 4, "double OMA stall bind", ::SubMenu, "double OMA");
    self MenuOption("OMA bind", 5, "double OMA overlay bind", ::SubMenu, "double OMA overlay");
    self MenuOption("OMA bind", 6, "triple OMA stall bind", ::SubMenu, "triple OMA");
    self MenuOption("OMA bind", 7, "triple OMA overlay bind", ::SubMenu, "triple OMA overlay");
    
    self MainMenu("single OMA", "OMA bind");
    self MenuOption("single OMA", 0, "OMA [{+Actionslot 1}]", ::OneManArmy1);
    self MenuOption("single OMA", 1, "OMA [{+Actionslot 4}]", ::OneManArmy4);
    self MenuOption("single OMA", 2, "OMA [{+Actionslot 2}]", ::OneManArmy2);
    self MenuOption("single OMA", 3, "OMA [{+Actionslot 3}]", ::OneManArmy3);
    
    self MainMenu("double OMA", "OMA bind");
    self MenuOption("double OMA", 0, "OMA [{+Actionslot 1}]", ::OneManArmyDouble1);
    self MenuOption("double OMA", 1, "OMA [{+Actionslot 4}]", ::OneManArmyDouble4);
    self MenuOption("double OMA", 2, "OMA [{+Actionslot 2}]", ::OneManArmyDouble2);
    self MenuOption("double OMA", 3, "OMA [{+Actionslot 3}]", ::OneManArmyDouble3);
    
    self MainMenu("triple OMA", "OMA bind");
    self MenuOption("triple OMA", 0, "OMA [{+Actionslot 1}]", ::OneManArmyTriple1);
    self MenuOption("triple OMA", 1, "OMA [{+Actionslot 4}]", ::OneManArmyTriple4);
    self MenuOption("triple OMA", 2, "OMA [{+Actionslot 2}]", ::OneManArmyTriple2);
    self MenuOption("triple OMA", 3, "OMA [{+Actionslot 3}]", ::OneManArmyTriple3);
    
    self MainMenu("single OMA overlay", "OMA bind");
    self MenuOption("single OMA overlay", 0, "OMA overlay [{+Actionslot 1}]", ::OMAOverlay1);
    self MenuOption("single OMA overlay", 1, "OMA overlay [{+Actionslot 4}]", ::OMAOverlay4);
    self MenuOption("single OMA overlay", 2, "OMA overlay [{+Actionslot 2}]", ::OMAOverlay2);
    self MenuOption("single OMA overlay", 3, "OMA overlay [{+Actionslot 3}]", ::OMAOverlay3);
    
    self MainMenu("double OMA overlay", "OMA bind");
    self MenuOption("double OMA overlay", 0, "OMA overlay [{+Actionslot 1}]", ::OMAOverlayDouble1);
    self MenuOption("double OMA overlay", 1, "OMA overlay [{+Actionslot 4}]", ::OMAOverlayDouble4);
    self MenuOption("double OMA overlay", 2, "OMA overlay [{+Actionslot 2}]", ::OMAOverlayDouble2);
    self MenuOption("double OMA overlay", 3, "OMA overlay [{+Actionslot 3}]", ::OMAOverlayDouble3);
    
    self MainMenu("triple OMA overlay", "OMA bind");
    self MenuOption("triple OMA overlay", 0, "OMA overlay [{+Actionslot 1}]", ::OMAOverlayTriple1);
    self MenuOption("triple OMA overlay", 1, "OMA overlay [{+Actionslot 4}]", ::OMAOverlayTriple4);
    self MenuOption("triple OMA overlay", 2, "OMA overlay [{+Actionslot 2}]", ::OMAOverlayTriple2);
    self MenuOption("triple OMA overlay", 3, "OMA overlay [{+Actionslot 3}]", ::OMAOverlayTriple3);
    
    self MainMenu("OMA colors", "OMA bind");
    self MenuOption("OMA colors", 0, "blue", ::ChangeBarColor, "blue");
    self MenuOption("OMA colors", 1, "red", ::ChangeBarColor, "red");
    self MenuOption("OMA colors", 2, "yellow", ::ChangeBarColor, "yellow");
    self MenuOption("OMA colors", 3, "green", ::ChangeBarColor, "green");
    self MenuOption("OMA colors", 4, "cyan", ::ChangeBarColor, "cyan");
    self MenuOption("OMA colors", 5, "pink", ::ChangeBarColor, "pink");
    self MenuOption("OMA colors", 6, "black", ::ChangeBarColor, "black");
    self MenuOption("OMA colors", 7, "normal", ::ChangeBarColor, "normal");

    self MainMenu("OMA weapon", "OMA bind");
    self MenuOption("OMA weapon", 0, "bomb", ::OMAWeapon, "Bomb");
    self MenuOption("OMA weapon", 1, "default weapon", ::OMAWeapon, "Default");
    self MenuOption("OMA weapon", 2, "syrette", ::OMAWeapon, "Syrette");
    self MenuOption("OMA weapon", 3, "carepackage", ::OMAWeapon, "Carepackage");
    self MenuOption("OMA weapon", 4, "minigun", ::OMAWeapon, "Minigun");
    self MenuOption("OMA weapon", 5, "grim reaper", ::OMAWeapon, "Grim Reaper");
    self MenuOption("OMA weapon", 6, "valkyrie rocket", ::OMAWeapon, "Valkyrie Rocket");
    self MenuOption("OMA weapon", 7, "rc-xd remote", ::OMAWeapon, "RC-XD Remote");
    self MenuOption("OMA weapon", 8, "what the fuck", ::OMAWeapon, "What the fuck");
    
    self MainMenu("cowboy bind", "binds menu");
    self MenuOption("cowboy bind", 0, "cowboy bind [{+Actionslot 1}]", ::Cowboy1);
    self MenuOption("cowboy bind", 1, "cowboy bind [{+Actionslot 4}]", ::Cowboy4);
    self MenuOption("cowboy bind", 2, "cowboy bind [{+Actionslot 2}]", ::Cowboy2);
    self MenuOption("cowboy bind", 3, "cowboy bind [{+Actionslot 3}]", ::Cowboy3);
    
    self MainMenu("change class options", "binds menu");
    self MenuOption("change class options", 0, "change class bind", ::SubMenu, "change class bind");
    self MenuOption("change class options", 1, "change class - 1 bullet", ::SubMenu, "change class - 1 bullet");
    self MenuOption("change class options", 2, "change class 1 bullet left", ::SubMenu, "change class 1 bullet left");
    self MenuOption("change class options", 3, "change class canswap bind", ::SubMenu, "change class canswap");
    self MenuOption("change class options", 4, "change class type", ::ChangeClassType);
    
    self MainMenu("change class bind", "change class options");
    self MenuOption("change class bind", 0, "change class [{+Actionslot 1}]", ::ChangeClass1);
    self MenuOption("change class bind", 1, "change class [{+Actionslot 4}]", ::ChangeClass4);
    self MenuOption("change class bind", 2, "change class [{+Actionslot 2}]", ::ChangeClass2);
    self MenuOption("change class bind", 3, "change class [{+Actionslot 3}]", ::ChangeClass3);
    
    self MainMenu("change class - 1 bullet", "change class options");
    self MenuOption("change class - 1 bullet", 0, "change class [{+Actionslot 1}]", ::ChangeClassTAO1);
    self MenuOption("change class - 1 bullet", 1, "change class [{+Actionslot 4}]", ::ChangeClassTAO4);
    self MenuOption("change class - 1 bullet", 2, "change class [{+Actionslot 2}]", ::ChangeClassTAO2);
    self MenuOption("change class - 1 bullet", 3, "change class [{+Actionslot 3}]", ::ChangeClassTAO3);
    
    self MainMenu("change class 1 bullet left", "change class options");
    self MenuOption("change class 1 bullet left", 0, "change class [{+Actionslot 1}]", ::ChangeClassOB1);
    self MenuOption("change class 1 bullet left", 1, "change class [{+Actionslot 4}]", ::ChangeClassOB4);
    self MenuOption("change class 1 bullet left", 2, "change class [{+Actionslot 2}]", ::ChangeClassOB2);
    self MenuOption("change class 1 bullet left", 3, "change class [{+Actionslot 3}]", ::ChangeClassOB3);
    
    self MainMenu("change class canswap", "change class options");
    self MenuOption("change class canswap", 0, "change class [{+Actionslot 1}]", ::CANChangeClass1);
    self MenuOption("change class canswap", 1, "change class [{+Actionslot 4}]", ::CANChangeClass4);
    self MenuOption("change class canswap", 2, "change class [{+Actionslot 2}]", ::CANChangeClass2);
    self MenuOption("change class canswap", 3, "change class [{+Actionslot 3}]", ::CANChangeClass3);
    
    self MainMenu("drop scav pack", "binds menu");
    self MenuOption("drop scav pack", 0, "drop scav pack [{+Actionslot 1}]", ::Scavdropbind1);
    self MenuOption("drop scav pack", 1, "drop scav pack [{+Actionslot 4}]", ::Scavdropbind4);
    self MenuOption("drop scav pack", 2, "drop scav pack [{+Actionslot 2}]", ::Scavdropbind2);
    self MenuOption("drop scav pack", 3, "drop scav pack [{+Actionslot 3}]", ::Scavdropbind3);
    
    self MainMenu("nac mod bind", "binds menu");
    self MenuOption("nac mod bind", 0, "save weapon 1", ::NacWeap1);
    self MenuOption("nac mod bind", 1, "save weapon 2", ::NacWeap2);
    self MenuOption("nac mod bind", 2, "nac mod [{+Actionslot 1}]", ::nacbind1);
    self MenuOption("nac mod bind", 3, "nac mod [{+Actionslot 4}]", ::nacbind4);
    self MenuOption("nac mod bind", 4, "nac mod [{+Actionslot 2}]", ::nacbind2);
    self MenuOption("nac mod bind", 5, "nac mod [{+Actionslot 3}]", ::nacbind3);
    
    self MainMenu("rapid fire bind", "binds menu");
    self MenuOption("rapid fire bind", 0, "rapid fire [{+Actionslot 1}]", ::rapidFire1);
    self MenuOption("rapid fire bind", 1, "rapid fire [{+Actionslot 4}]", ::rapidFire4);
    self MenuOption("rapid fire bind", 2, "rapid fire [{+Actionslot 2}]", ::rapidFire2);
    self MenuOption("rapid fire bind", 3, "rapid fire [{+Actionslot 3}]", ::rapidFire3);
    
    self MainMenu("skree bind", "binds menu");
    self MenuOption("skree bind", 0, "save weapon 1", ::SnacWeap1);
    self MenuOption("skree bind", 1, "save weapon 2", ::SnacWeap2);
    self MenuOption("skree bind", 2, "skree [{+Actionslot 1}]", ::snacbind1);
    self MenuOption("skree bind", 3, "skree [{+Actionslot 4}]", ::snacbind4);
    self MenuOption("skree bind", 4, "skree [{+Actionslot 2}]", ::snacbind2);
    self MenuOption("skree bind", 5, "skree [{+Actionslot 3}]", ::snacbind3);
    
    self MainMenu("bolt movement bind", "binds menu");
    self MenuOption("bolt movement bind", 0, "save bolt position 1", ::savebolt);
    self MenuOption("bolt movement bind", 1, "save bolt position 2", ::savebolt2);
    self MenuOption("bolt movement bind", 2, "save bolt position 3", ::savebolt3);
    self MenuOption("bolt movement bind", 3, "change bolt movement speed", ::SubMenu, "bolt movement speed");
    self MenuOption("bolt movement bind", 4, "single bolt movement", ::SubMenu, "bolt movement");
    self MenuOption("bolt movement bind", 5, "double bolt movement", ::SubMenu, "double bolt movement");
    self MenuOption("bolt movement bind", 6, "triple bolt movement", ::SubMenu, "triple bolt movement");
    
    self MainMenu("bolt movement speed", "bolt movement bind");
    self MenuOption("bolt movement speed", 0, "changed to 0.5 seconds", ::changeBoltSpeed, 0.5);
    self MenuOption("bolt movement speed", 1, "changed to 0.75 seconds", ::changeBoltSpeed, 0.75);
    self MenuOption("bolt movement speed", 2, "changed to 1 second", ::changeBoltSpeed, 1);
    self MenuOption("bolt movement speed", 3, "changed to 1.25 seconds", ::changeBoltSpeed, 1.25);
    self MenuOption("bolt movement speed", 4, "changed to 1.5 seconds", ::changeBoltSpeed, 1.5);
    self MenuOption("bolt movement speed", 5, "changed to 1.75 seconds", ::changeBoltSpeed, 1.75);
    self MenuOption("bolt movement speed", 6, "changed to 2 seconds", ::changeBoltSpeed, 2);
    self MenuOption("bolt movement speed", 7, "changed to 2.25 seconds", ::changeBoltSpeed, 2.25);
    self MenuOption("bolt movement speed", 8, "changed to 2.5 seconds", ::changeBoltSpeed, 2.5);
    self MenuOption("bolt movement speed", 9, "changed to 2.75 seconds", ::changeBoltSpeed, 2.75);
    self MenuOption("bolt movement speed", 10, "changed to 3 seconds", ::changeBoltSpeed, 3);
    
    self MainMenu("bolt movement", "bolt movement bind");
    self MenuOption("bolt movement", 0, "bolt movement [{+Actionslot 1}]", ::boltmovement1);
    self MenuOption("bolt movement", 1, "bolt movement [{+Actionslot 4}]", ::boltmovement4);
    self MenuOption("bolt movement", 2, "bolt movement [{+Actionslot 2}]", ::boltmovement2);
    self MenuOption("bolt movement", 3, "bolt movement [{+Actionslot 3}]", ::boltmovement3);
    
    self MainMenu("double bolt movement", "bolt movement bind");
    self MenuOption("double bolt movement", 0, "double bolt movement [{+Actionslot 1}]", ::doubleboltmovement1);
    self MenuOption("double bolt movement", 1, "double bolt movement [{+Actionslot 4}]", ::doubleboltmovement4);
    self MenuOption("double bolt movement", 2, "double bolt movement [{+Actionslot 2}]", ::doubleboltmovement2);
    self MenuOption("double bolt movement", 3, "double bolt movement [{+Actionslot 3}]", ::doubleboltmovement3);
    
    self MainMenu("triple bolt movement", "bolt movement bind");
    self MenuOption("triple bolt movement", 0, "triple bolt movement [{+Actionslot 1}]", ::tripleboltmovement1);
    self MenuOption("triple bolt movement", 1, "triple bolt movement [{+Actionslot 4}]", ::tripleboltmovement4);
    self MenuOption("triple bolt movement", 2, "triple bolt movement [{+Actionslot 2}]", ::tripleboltmovement2);
    self MenuOption("triple bolt movement", 3, "triple bolt movement [{+Actionslot 3}]", ::tripleboltmovement3);
 
    
    self MainMenu("repeater bind", "binds menu");
    self MenuOption("repeater bind", 0, "repeater [{+Actionslot 1}]", ::Repeater1);
    self MenuOption("repeater bind", 1, "repeater [{+Actionslot 4}]", ::Repeater4);
    self MenuOption("repeater bind", 2, "repeater [{+Actionslot 2}]", ::Repeater2);
    self MenuOption("repeater bind", 3, "repeater [{+Actionslot 3}]", ::Repeater3);
    
    self MainMenu("canswap bind", "binds menu");
    self MenuOption("canswap bind", 0, "canswap [{+Actionslot 1}]", ::CanswapBind1);
    self MenuOption("canswap bind", 1, "canswap [{+Actionslot 4}]", ::CanswapBind4);
    self MenuOption("canswap bind", 2, "canswap [{+Actionslot 2}]", ::CanswapBind2);
    self MenuOption("canswap bind", 3, "canswap [{+Actionslot 3}]", ::CanswapBind3);
    self MenuOption("canswap bind", 4, "canswap - 1 bullet [{+Actionslot 1}]", ::Canswapwo1Bind1);
    self MenuOption("canswap bind", 5, "canswap - 1 bullet [{+Actionslot 4}]", ::Canswapwo1Bind4);
    self MenuOption("canswap bind", 6, "canswap - 1 bullet [{+Actionslot 2}]", ::Canswapwo1Bind2);
    self MenuOption("canswap bind", 7, "canswap - 1 bullet [{+Actionslot 3}]", ::Canswapwo1Bind3);
    
    self MainMenu("flicker bind", "binds menu");
    self MenuOption("flicker bind", 0, "set flicker weapon", ::SubMenu, "flicker bind weapon");
    self MenuOption("flicker bind", 1, "flicker [{+Actionslot 1}]", ::Flicker1);
    self MenuOption("flicker bind", 2, "flicker [{+Actionslot 4}]", ::Flicker4);
    self MenuOption("flicker bind", 3, "flicker [{+Actionslot 2}]", ::Flicker2);
    self MenuOption("flicker bind", 4, "flicker [{+Actionslot 3}]", ::Flicker3);
    
    self MainMenu("flicker bind weapon", "flicker bind");
    self MenuOption("flicker bind weapon", 0, "sniper rifles", ::SubMenu, "flicker snipers");
    self MenuOption("flicker bind weapon", 1, "shotguns", ::SubMenu, "flicker shotguns");
    self MenuOption("flicker bind weapon", 2, "assault rifles", ::SubMenu, "flicker ars");
    self MenuOption("flicker bind weapon", 3, "submachine guns", ::SubMenu, "flicker smgs");
    self MenuOption("flicker bind weapon", 4, "light machine guns", ::SubMenu, "flicker lmgs");
    self MenuOption("flicker bind weapon", 5, "pistols", ::SubMenu, "flicker pistols");
    self MenuOption("flicker bind weapon", 6, "launchers", ::SubMenu, "flicker launchers");
    self MenuOption("flicker bind weapon", 7, "specials", ::SubMenu, "flicker specials");
    self MenuOption("flicker bind weapon", 8, "super specials", ::SubMenu, "flicker super specials");
    
    self MainMenu("flicker snipers", "flicker bind weapon");
    self MenuOption("flicker snipers", 0, "dragunov", ::setFlickerWeapon, "dragunov_mp");
    self MenuOption("flicker snipers", 1, "wa2000", ::setFlickerWeapon, "wa2000_mp");
    self MenuOption("flicker snipers", 2, "l96a1", ::setFlickerWeapon, "l96a1_mp");
    self MenuOption("flicker snipers", 3, "psg1", ::setFlickerWeapon, "psg1_mp");
    
    self MainMenu("flicker shotguns", "flicker bind weapon");
    self MenuOption("flicker shotguns", 0, "olympia", ::setFlickerWeapon, "rottweil72_mp");
    self MenuOption("flicker shotguns", 1, "stakeout", ::setFlickerWeapon, "ithaca_mp");
    self MenuOption("flicker shotguns", 2, "spas-12", ::setFlickerWeapon, "spas_mp");
    self MenuOption("flicker shotguns", 3, "hs10", ::setFlickerWeapon, "hs10_mp");
    
    self MainMenu("flicker ars", "flicker bind weapon");
    self MenuOption("flicker ars", 0, "m16", ::setFlickerWeapon, "m16_mp");
    self MenuOption("flicker ars", 1, "enfield", ::setFlickerWeapon, "enfield_mp");
    self MenuOption("flicker ars", 2, "m14", ::setFlickerWeapon, "m14_mp");
    self MenuOption("flicker ars", 3, "famas", ::setFlickerWeapon, "famas_mp");
    self MenuOption("flicker ars", 4, "galil", ::setFlickerWeapon, "galil_mp");
    self MenuOption("flicker ars", 5, "aug", ::setFlickerWeapon, "aug_mp");
    self MenuOption("flicker ars", 6, "fn fal", ::setFlickerWeapon, "fnfal_mp");
    self MenuOption("flicker ars", 7, "ak47", ::setFlickerWeapon, "ak47_mp");
    self MenuOption("flicker ars", 8, "commando", ::setFlickerWeapon, "commando_mp");
    self MenuOption("flicker ars", 9, "g11", ::setFlickerWeapon, "g11_mp");
    
    self MainMenu("flicker smgs", "flicker bind weapon");
    self MenuOption("flicker smgs", 0, "mp5k", ::setFlickerWeapon, "mp5k_mp");
    self MenuOption("flicker smgs", 1, "skorpion", ::setFlickerWeapon, "skorpion_mp");
    self MenuOption("flicker smgs", 2, "mac11", ::setFlickerWeapon, "mac11_mp");
    self MenuOption("flicker smgs", 3, "ak74u", ::setFlickerWeapon, "ak74u_mp");
    self MenuOption("flicker smgs", 4, "uzi", ::setFlickerWeapon, "uzi_mp");
    self MenuOption("flicker smgs", 5, "pm63", ::setFlickerWeapon, "pm63_grip_mp");
    self MenuOption("flicker smgs", 6, "mpl", ::setFlickerWeapon, "mpl_grip_mp");
    self MenuOption("flicker smgs", 7, "spectre", ::setFlickerWeapon, "spectre_grip_mp");
    self MenuOption("flicker smgs", 8, "kiparis", ::setFlickerWeapon, "kiparis_grip_mp");
    
    self MainMenu("flicker lmgs", "flicker bind weapon");
    self MenuOption("flicker lmgs", 0, "hk21", ::setFlickerWeapon, "hk21_mp");
    self MenuOption("flicker lmgs", 1, "rpk", ::setFlickerWeapon, "rpk_mp");
    self MenuOption("flicker lmgs", 2, "m60", ::setFlickerWeapon, "m60_mp");
    self MenuOption("flicker lmgs", 3, "stoner63", ::setFlickerWeapon, "stoner63_mp");
    
    self MainMenu("flicker pistols", "flicker bind weapon");
    self MenuOption("flicker pistols", 0, "asp", ::setFlickerWeapon, "asp_mp");
    self MenuOption("flicker pistols", 1, "m1911", ::setFlickerWeapon, "m1911_mp");
    self MenuOption("flicker pistols", 2, "makarov", ::setFlickerWeapon, "makarov_mp");
    self MenuOption("flicker pistols", 3, "python", ::setFlickerWeapon, "python_mp");
    self MenuOption("flicker pistols", 4, "cz75", ::setFlickerWeapon, "cz75_mp");
    
    self MainMenu("flicker launchers", "flicker bind weapon");
    self MenuOption("flicker launchers", 0, "m72 law", ::setFlickerWeapon, "m72_law_mp");
    self MenuOption("flicker launchers", 1, "rpg", ::setFlickerWeapon, "rpg_mp");
    self MenuOption("flicker launchers", 2, "strela-3", ::setFlickerWeapon, "strela_mp");
    self MenuOption("flicker launchers", 3, "china lake", ::setFlickerWeapon, "china_lake_mp");
    
    self MainMenu("flicker specials", "flicker bind weapon");
    self MenuOption("flicker specials", 0, "ballistic knife", ::setFlickerWeapon, "knife_ballistic_mp");
    self MenuOption("flicker specials", 1, "crossbow", ::setFlickerWeapon, "crossbow_explosive_mp");
    
    self MainMenu("flicker super specials", "flicker bind weapon");
    self MenuOption("flicker super specials", 0, "default weapon", ::setFlickerWeapon, "defaultweapon_mp");
    self MenuOption("flicker super specials", 1, "syrette", ::setFlickerWeapon, "syrette_mp");
    self MenuOption("flicker super specials", 2, "carepackage", ::setFlickerWeapon, "supplydrop_mp");
    self MenuOption("flicker super specials", 3, "minigun", ::setFlickerWeapon, "minigun_mp");
    self MenuOption("flicker super specials", 4, "claymore", ::setFlickerWeapon, "claymore_mp");
    self MenuOption("flicker super specials", 5, "scrambler", ::setFlickerWeapon, "scrambler_mp");
    self MenuOption("flicker super specials", 6, "jammer", ::setFlickerWeapon, "scrambler_mp");
    self MenuOption("flicker super specials", 7, "tac", ::setFlickerWeapon, "tactical_insertion_mp");
    self MenuOption("flicker super specials", 8, "sensor", ::setFlickerWeapon, "acoustic_sensor_mp");
    self MenuOption("flicker super specials", 9, "camera", ::setFlickerWeapon, "camera_spike_mp");
    self MenuOption("flicker super specials", 10, "bomb", ::setFlickerWeapon, "briefcase_bomb_mp");
    self MenuOption("flicker super specials", 11, "grim reaper", ::setFlickerWeapon, "m202_flash_mp");
    self MenuOption("flicker super specials", 12, "valkyrie rocket", ::setFlickerWeapon, "m220_tow_mp");
    self MenuOption("flicker super specials", 13, "rc-xd remote", ::setFlickerWeapon, "rcbomb_mp");
    self MenuOption("flicker super specials", 14, "what the fuck is this", ::setFlickerWeapon, "dog_bite_mp");
    
    self MainMenu("visions menu", "redemption");
    self MenuOption("visions menu", 0, "high contrast", ::setVision, "cheat_bw_invert");
    self MenuOption("visions menu", 1, "cartoon vision", ::CartoonVision);
    self MenuOption("visions menu", 2, "flame screen", ::toggle_flame);
    self MenuOption("visions menu", 3, "disco fog", ::disco);
    self MenuOption("visions menu", 4, "change fog colors", ::SubMenu, "change fog colors");
    
    self MainMenu("change fog colors", "visions menu");
    self MenuOption("change fog colors", 0, " set fog red", ::RedF);
    self MenuOption("change fog colors", 1, " set fog blue", ::GreenF);
    self MenuOption("change fog colors", 2, " set fog green", ::BlueF);
    self MenuOption("change fog colors", 3, " set fog yellow", ::YelwF);
    self MenuOption("change fog colors", 4, " set fog purple", ::PurpF);
    self MenuOption("change fog colors", 5, " set fog orange", ::OranF);
    self MenuOption("change fog colors", 6, " set fog cyan", ::CyanF);
    self MenuOption("change fog colors", 7, " set fog Default", ::NoF);
    
    self MainMenu("camo menu", "redemption");
    self MenuOption("camo menu", 0, "take camo", ::changeCamo, 0);
    self MenuOption("camo menu", 1, "give random camo", ::randomCamo);
    self MenuOption("camo menu", 2, "dusty", ::changeCamo, 1);
    self MenuOption("camo menu", 3, "ice", ::changeCamo, 2);
    self MenuOption("camo menu", 4, "red", ::changeCamo, 3);
    self MenuOption("camo menu", 5, "olive", ::changeCamo, 4);
    self MenuOption("camo menu", 6, "nevada", ::changeCamo, 5);
    self MenuOption("camo menu", 7, "sahara", ::changeCamo, 6);
    self MenuOption("camo menu", 8, "ERDL", ::changeCamo, 7);
    self MenuOption("camo menu", 9, "tiger", ::changeCamo, 8);
    self MenuOption("camo menu", 10, "berlin", ::changeCamo, 9);
    self MenuOption("camo menu", 11, "warsaw", ::changeCamo, 10);
    self MenuOption("camo menu", 12, "siberia", ::changeCamo, 11);
    self MenuOption("camo menu", 13, "yukon", ::changeCamo, 12);
    self MenuOption("camo menu", 14, "woodland", ::changeCamo, 13);
    self MenuOption("camo menu", 15, "flora", ::changeCamo, 14);
    self MenuOption("camo menu", 16, "gold", ::changeCamo, 15);

    self MainMenu("weapons menu", "redemption");
    self MenuOption("weapons menu", 0, "take current weapon", ::takecurrentweapon);
    self MenuOption("weapons menu", 1, "drop current weapon", ::dropcurrentweapon);
    self MenuOption("weapons menu", 2, "refill ammo bind", ::SubMenu, "refill ammo");
    self MenuOption("weapons menu", 3, "refill ammo", ::maxammoweapon);
    self MenuOption("weapons menu", 4, "refill equipment", ::maxequipment);
    self MenuOption("weapons menu", 5, "more ammo options", ::SubMenu, "ammo options");
    self MenuOption("weapons menu", 6, "drop canswap", ::dropcan);
    self MenuOption("weapons menu", 7, "submachine gun", ::SubMenu, "submachine guns");
    self MenuOption("weapons menu", 8, "assault rifles", ::SubMenu, "assault rifles");
    self MenuOption("weapons menu", 9, "shotguns", ::SubMenu, "shotguns");
    self MenuOption("weapons menu", 10, "light machine guns", ::SubMenu, "light machine guns");
    self MenuOption("weapons menu", 11, "sniper rifles", ::SubMenu, "snipers");
    self MenuOption("weapons menu", 12, "pistols", ::SubMenu, "pistols");
    self MenuOption("weapons menu", 13, "launchers", ::SubMenu, "launchers");
    self MenuOption("weapons menu", 14, "specials", ::SubMenu, "specials");
    self MenuOption("weapons menu", 15, "super specials", ::SubMenu, "super specials");
    
    self MainMenu("ammo options", "weapons menu");
    self MenuOption("ammo options", 0, "take away 1 bullet", ::AltAmmo1);
    self MenuOption("ammo options", 1, "half the clip", ::AltAmmo2);
    self MenuOption("ammo options", 2, "1 bullet left", ::AltAmmo3);
    
    self MainMenu("refill ammo", "weapons menu");
    self MenuOption("refill ammo", 0, "[{+Actionslot 1}]", ::AmmoBind1);
    self MenuOption("refill ammo", 1, "[{+Actionslot 4}]", ::AmmoBind4);
    self MenuOption("refill ammo", 2, "[{+Actionslot 2}]", ::AmmoBind2);
    self MenuOption("refill ammo", 3, "crouch + [{+Actionslot 1}]", ::AmmoBind1C);
    self MenuOption("refill ammo", 4, "crouch + [{+Actionslot 4}]", ::AmmoBind4C);
    self MenuOption("refill ammo", 5, "crouch + [{+Actionslot 2}]", ::AmmoBind2C);
    self MenuOption("refill ammo", 6, "prone + [{+Actionslot 1}]", ::AmmoBind1P);
    self MenuOption("refill ammo", 7, "prone + [{+Actionslot 4}]", ::AmmoBind4P);
    self MenuOption("refill ammo", 8, "prone + [{+Actionslot 2}]", ::AmmoBind2P);
    
    self MainMenu("snipers", "weapons menu");
    self MenuOption("snipers", 0, "dragunov", ::SubMenu, "dragunov");
    self MenuOption("snipers", 1, "wa2000", ::SubMenu, "wa2000");
    self MenuOption("snipers", 2, "l96a1", ::SubMenu, "l96a1");
    self MenuOption("snipers", 3, "psg1", ::SubMenu, "psg1");
    
    self MainMenu("dragunov", "snipers");
    self MenuOption("dragunov", 0, "extended mags", ::GivePlayerWeapon, "dragunov_extclip_mp");
    self MenuOption("dragunov", 1, "acog sight", ::GivePlayerWeapon, "dragunov_acog_mp");
    self MenuOption("dragunov", 2, "infrared sight", ::GivePlayerWeapon, "dragunov_ir_mp");
    self MenuOption("dragunov", 3, "suppressor", ::GivePlayerWeapon, "dragunov_silencer_mp");
    self MenuOption("dragunov", 4, "variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_mp");
    self MenuOption("dragunov", 5, "default", ::GivePlayerWeapon, "dragunov_mp");
    self MenuOption("dragunov", 6, "2 attachments", ::SubMenu, "dragunov 2 attachments");
    
    self MainMenu("dragunov 2 attachments", "dragunov");
    self MenuOption("dragunov 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "dragunov_acog_extclip_mp");
    self MenuOption("dragunov 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "dragunov_ir_extclip_mp");
    self MenuOption("dragunov 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "dragunov_extclip_silencer_mp");
    self MenuOption("dragunov 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_extclip_mp");
    self MenuOption("dragunov 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "dragunov_acog_silencer_mp");
    self MenuOption("dragunov 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "dragunov_ir_silencer_mp");
    self MenuOption("dragunov 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "dragunov_vzoom_silencer_mp");
    
    self MainMenu("wa2000", "snipers");
    self MenuOption("wa2000", 0, "extended mags", ::GivePlayerWeapon, "wa2000_extclip_mp");
    self MenuOption("wa2000", 1, "acog sight", ::GivePlayerWeapon, "wa2000_acog_mp");
    self MenuOption("wa2000", 2, "infrared sight", ::GivePlayerWeapon, "wa2000_ir_mp");
    self MenuOption("wa2000", 3, "suppressor", ::GivePlayerWeapon, "wa2000_silencer_mp");
    self MenuOption("wa2000", 4, "variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_mp");
    self MenuOption("wa2000", 5, "default", ::GivePlayerWeapon, "wa2000_mp");
    self MenuOption("wa2000", 6, "2 attachments", ::SubMenu, "wa2000 2 attachments");
    
    self MainMenu("wa2000 2 attachments", "wa2000");
    self MenuOption("wa2000 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "wa2000_acog_extclip_mp");
    self MenuOption("wa2000 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "wa2000_ir_extclip_mp");
    self MenuOption("wa2000 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "wa2000_extclip_silencer_mp");
    self MenuOption("wa2000 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_extclip_mp");
    self MenuOption("wa2000 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "wa2000_acog_silencer_mp");
    self MenuOption("wa2000 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "wa2000_ir_silencer_mp");
    self MenuOption("wa2000 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "wa2000_vzoom_silencer_mp");
    
    self MainMenu("l96a1", "snipers");
    self MenuOption("l96a1", 0, "extended mags", ::GivePlayerWeapon, "l96a1_extclip_mp");
    self MenuOption("l96a1", 1, "acog sight", ::GivePlayerWeapon, "l96a1_acog_mp");
    self MenuOption("l96a1", 2, "infrared sight", ::GivePlayerWeapon, "l96a1_ir_mp");
    self MenuOption("l96a1", 3, "suppressor", ::GivePlayerWeapon, "l96a1_silencer_mp");
    self MenuOption("l96a1", 4, "variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_mp");
    self MenuOption("l96a1", 5, "default", ::GivePlayerWeapon, "l96a1_mp");
    self MenuOption("l96a1", 6, "2 attachments", ::SubMenu, "l96a1 2 attachments");
    
    self MainMenu("l96a1 2 attachments", "l96a1");
    self MenuOption("l96a1 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "l96a1_acog_extclip_mp");
    self MenuOption("l96a1 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "l96a1_ir_extclip_mp");
    self MenuOption("l96a1 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "l96a1_extclip_silencer_mp");
    self MenuOption("l96a1 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_extclip_mp");
    self MenuOption("l96a1 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "l96a1_acog_silencer_mp");
    self MenuOption("l96a1 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "l96a1_ir_silencer_mp");
    self MenuOption("l96a1 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "l96a1_vzoom_silencer_mp");
    
    self MainMenu("psg1", "snipers");
    self MenuOption("psg1", 0, "extended mags", ::GivePlayerWeapon, "psg1_extclip_mp");
    self MenuOption("psg1", 1, "acog sight", ::GivePlayerWeapon, "psg1_acog_mp");
    self MenuOption("psg1", 2, "infrared sight", ::GivePlayerWeapon, "psg1_ir_mp");
    self MenuOption("psg1", 3, "suppressor", ::GivePlayerWeapon, "psg1_silencer_mp");
    self MenuOption("psg1", 4, "variable zoom", ::GivePlayerWeapon, "psg1_vzoom_mp");
    self MenuOption("psg1", 5, "default", ::GivePlayerWeapon, "psg1_mp");
    self MenuOption("psg1", 6, "2 attachments", ::SubMenu, "psg1 2 attachments");
    
    self MainMenu("psg1 2 attachments", "psg1");
    self MenuOption("psg1 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "psg1_acog_extclip_mp");
    self MenuOption("psg1 2 attachments", 1, "extended mag x infrared sight", ::GivePlayerWeapon, "psg1_ir_extclip_mp");
    self MenuOption("psg1 2 attachments", 2, "extended mag x suppressor", ::GivePlayerWeapon, "psg1_extclip_silencer_mp");
    self MenuOption("psg1 2 attachments", 3, "extended mag x variable zoom", ::GivePlayerWeapon, "psg1_vzoom_extclip_mp");
    self MenuOption("psg1 2 attachments", 4, "suppressor x acog sight", ::GivePlayerWeapon, "psg1_acog_silencer_mp");
    self MenuOption("psg1 2 attachments", 5, "suppressor x infrared sight", ::GivePlayerWeapon, "psg1_ir_silencer_mp");
    self MenuOption("psg1 2 attachments", 6, "suppressor x variable zoom", ::GivePlayerWeapon, "psg1_vzoom_silencer_mp");
    
    self MainMenu("shotguns", "weapons menu");
    self MenuOption("shotguns", 0, "olympia", ::GivePlayerWeapon, "rottweil72_mp");
    self MenuOption("shotguns", 1, "stakeout", ::SubMenu, "stakeout");
    self MenuOption("shotguns", 2, "spas-12", ::SubMenu, "spas-12");
    self MenuOption("shotguns", 3, "hs10", ::SubMenu, "hs10");
    
    self MainMenu("stakeout", "shotguns");
    self MenuOption("stakeout", 0, "grip", ::GivePlayerWeapon, "ithaca_grip_mp");
    self MenuOption("stakeout", 1, "default", ::GivePlayerWeapon, "ithaca_mp");
    
    self MainMenu("spas-12", "shotguns");
    self MenuOption("spas-12", 0, "suppressor", ::GivePlayerWeapon, "spas_silencer_mp");
    self MenuOption("spas-12", 1, "default", ::GivePlayerWeapon, "spas_mp");
    
    self MainMenu("hs10", "shotguns");
    self MenuOption("hs10", 0, "dual wield", ::GivePlayerWeapon, "hs10dw_mp");
    self MenuOption("hs10", 1, "dual wield glitched", ::GivePlayerWeapon, "hs10lh_mp");
    self MenuOption("hs10", 2, "default", ::GivePlayerWeapon, "hs10_mp");
    
    self MainMenu("assault rifles", "weapons menu");
    self MenuOption("assault rifles", 0, "m16", ::SubMenu, "m16");
    self MenuOption("assault rifles", 1, "enfield", ::SubMenu, "enfield");
    self MenuOption("assault rifles", 2, "m14", ::SubMenu, "m14");
    self MenuOption("assault rifles", 3, "famas", ::SubMenu, "famas");
    self MenuOption("assault rifles", 4, "galil", ::SubMenu, "galil");
    self MenuOption("assault rifles", 5, "aug", ::SubMenu, "aug");
    self MenuOption("assault rifles", 6, "fnfal", ::SubMenu, "fnfal");
    self MenuOption("assault rifles", 7, "ak47", ::SubMenu, "ak47");
    self MenuOption("assault rifles", 8, "commando", ::SubMenu, "commando");
    self MenuOption("assault rifles", 9, "g11", ::SubMenu, "g11");
    
    self MainMenu("m16", "assault rifles");
    self MenuOption("m16", 0, "extended mag", ::GivePlayerWeapon, "m16_extclip_mp");
    self MenuOption("m16", 1, "dual mag", ::GivePlayerWeapon, "m16_dualclip_mp");
    self MenuOption("m16", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_mp");
    self MenuOption("m16", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_mp");
    self MenuOption("m16", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_mp");
    self MenuOption("m16", 5, "masterkey", ::GivePlayerWeapon, "m16_mk_mp");
    self MenuOption("m16", 6, "flamethrower", ::GivePlayerWeapon, "m16_ft_mp");
    self MenuOption("m16", 7, "infrared scope", ::GivePlayerWeapon, "m16_ir_mp");
    self MenuOption("m16", 8, "suppressor", ::GivePlayerWeapon, "m16_silencer_mp");
    self MenuOption("m16", 9, "grenade launcher", ::GivePlayerWeapon, "m16_gl_mp");
    self MenuOption("m16", 10, "default", ::GivePlayerWeapon, "m16_mp");
    self MenuOption("m16", 11, "2 attachments", ::SubMenu, "m16 2 attachments");
    
    self MainMenu("m16 2 attachments", "m16");
    self MenuOption("m16 2 attachments", 0, "extended mag", ::SubMenu, "m16 extended mag");
    self MenuOption("m16 2 attachments", 1, "dual mag", ::SubMenu, "m16 dual mag");
    self MenuOption("m16 2 attachments", 2, "masterkey", ::SubMenu, "m16 masterkey");
    self MenuOption("m16 2 attachments", 3, "flamethrower", ::SubMenu, "m16 flamethrower");
    self MenuOption("m16 2 attachments", 4, "grenade launcher", ::SubMenu, "m16 grenade launcher");
    
    self MainMenu("m16 extended mag", "m16 2 attachments");
    self MenuOption("m16 extended mag", 0, "acog sight", ::GivePlayerWeapon, "m16_acog_extclip_mp");
    self MenuOption("m16 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "m16_elbit_extclip_mp");
    self MenuOption("m16 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "m16_reflex_extclip_mp");
    self MenuOption("m16 extended mag", 3, "masterkey", ::GivePlayerWeapon, "m16_mk_extclip_mp");
    self MenuOption("m16 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "m16_ft_extclip_mp");
    self MenuOption("m16 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_extclip_mp");
    self MenuOption("m16 extended mag", 6, "suppressor", ::GivePlayerWeapon, "m16_extclip_silencer_mp");
    self MenuOption("m16 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "m16_gl_extclip_mp");
    
    self MainMenu("m16 dual mag", "m16 2 attachments");
    self MenuOption("m16 dual mag", 0, "acog sight", ::GivePlayerWeapon, "m16_acog_dualclip_mp");
    self MenuOption("m16 dual mag", 1, "red dot sight", ::GivePlayerWeapon, "m16_elbit_dualclip_mp");
    self MenuOption("m16 dual mag", 2, "reflex sight", ::GivePlayerWeapon, "m16_reflex_dualclip_mp");
    self MenuOption("m16 dual mag", 3, "masterkey", ::GivePlayerWeapon, "m16_mk_dualclip_mp");
    self MenuOption("m16 dual mag", 4, "flamethrower", ::GivePlayerWeapon, "m16_ft_dualclip_mp");
    self MenuOption("m16 dual mag", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_dualclip_mp");
    self MenuOption("m16 dual mag", 6, "suppressor", ::GivePlayerWeapon, "m16_dualclip_silencer_mp");
    self MenuOption("m16 dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "m16_gl_dualclip_mp");
    
    self MainMenu("m16 masterkey", "m16 2 attachments");
    self MenuOption("m16 masterkey", 0, "extended mag", ::GivePlayerWeapon, "m16_mk_extclip_mp");
    self MenuOption("m16 masterkey", 1, "dual mag", ::GivePlayerWeapon, "m16_mk_dualclip_mp");
    self MenuOption("m16 masterkey", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_mk_mp");
    self MenuOption("m16 masterkey", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_mk_mp");
    self MenuOption("m16 masterkey", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_mk_mp");
    self MenuOption("m16 masterkey", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_mk_mp");
    self MenuOption("m16 masterkey", 6, "suppressor", ::GivePlayerWeapon, "m16_mk_silencer_mp");

    self MainMenu("m16 flamethrower", "m16 2 attachments");
    self MenuOption("m16 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "m16_ft_extclip_mp");
    self MenuOption("m16 flamethrower", 1, "dual mag", ::GivePlayerWeapon, "m16_ft_dualclip_mp");
    self MenuOption("m16 flamethrower", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_ft_mp");
    self MenuOption("m16 flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_ft_mp");
    self MenuOption("m16 flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_ft_mp");
    self MenuOption("m16 flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "m16_ir_ft_mp");
    self MenuOption("m16 flamethrower", 6, "suppressor", ::GivePlayerWeapon, "m16_ft_silencer_mp");
    
    self MainMenu("m16 grenade launcher", "m16 2 attachments");
    self MenuOption("m16 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "m16_gl_extclip_mp");
    self MenuOption("m16 grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "m16_gl_dualclip_mp");
    self MenuOption("m16 grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "m16_acog_gl_mp");
    self MenuOption("m16 grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "m16_elbit_gl_mp");
    self MenuOption("m16 grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "m16_reflex_gl_mp");
    self MenuOption("m16 grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "m16_gl_ir_mp");
    self MenuOption("m16 grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "m16_gl_silencer_mp");
    
    self MainMenu("enfield", "assault rifles");
    self MenuOption("enfield", 0, "extended mag", ::GivePlayerWeapon, "enfield_extclip_mp");
    self MenuOption("enfield", 1, "dual mag", ::GivePlayerWeapon, "enfield_dualclip_mp");
    self MenuOption("enfield", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_mp");
    self MenuOption("enfield", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_mp");
    self MenuOption("enfield", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_mp");
    self MenuOption("enfield", 5, "masterkey", ::GivePlayerWeapon, "enfield_mk_mp");
    self MenuOption("enfield", 6, "flamethrower", ::GivePlayerWeapon, "enfield_ft_mp");
    self MenuOption("enfield", 7, "infrared scope", ::GivePlayerWeapon, "enfield_ir_mp");
    self MenuOption("enfield", 8, "suppressor", ::GivePlayerWeapon, "enfield_silencer_mp");
    self MenuOption("enfield", 9, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_mp");
    self MenuOption("enfield", 10, "default", ::GivePlayerWeapon, "enfield_mp");
    self MenuOption("enfield", 11, "2 attachments", ::SubMenu, "enfield 2 attachments");
    
    self MainMenu("enfield 2 attachments", "enfield");
    self MenuOption("enfield 2 attachments", 0, "extended mag", ::SubMenu, "enfield extended mag");
    self MenuOption("enfield 2 attachments", 1, "dual mag", ::SubMenu, "enfield dual mag");
    self MenuOption("enfield 2 attachments", 2, "masterkey", ::SubMenu, "enfield masterkey");
    self MenuOption("enfield 2 attachments", 3, "flamethrower", ::SubMenu, "enfield flamethrower");
    self MenuOption("enfield 2 attachments", 4, "grenade launcher", ::SubMenu, "enfield grenade launcher");
    
    self MainMenu("enfield extended mag", "enfield 2 attachments");
    self MenuOption("enfield extended mag", 0, "acog sight", ::GivePlayerWeapon, "enfield_acog_extclip_mp");
    self MenuOption("enfield extended mag", 1, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_extclip_mp");
    self MenuOption("enfield extended mag", 2, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_extclip_mp");
    self MenuOption("enfield extended mag", 3, "masterkey", ::GivePlayerWeapon, "enfield_mk_extclip_mp");
    self MenuOption("enfield extended mag", 4, "flamethrower", ::GivePlayerWeapon, "enfield_ft_extclip_mp");
    self MenuOption("enfield extended mag", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_extclip_mp");
    self MenuOption("enfield extended mag", 6, "suppressor", ::GivePlayerWeapon, "enfield_extclip_silencer_mp");
    self MenuOption("enfield extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_extclip_mp");
    
    self MainMenu("enfield dual mag", "enfield 2 attachments");
    self MenuOption("enfield dual mag", 0, "acog sight", ::GivePlayerWeapon, "enfield_acog_dualclip_mp");
    self MenuOption("enfield dual mag", 1, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_dualclip_mp");
    self MenuOption("enfield dual mag", 2, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_dualclip_mp");
    self MenuOption("enfield dual mag", 3, "masterkey", ::GivePlayerWeapon, "enfield_mk_dualclip_mp");
    self MenuOption("enfield dual mag", 4, "flamethrower", ::GivePlayerWeapon, "enfield_ft_dualclip_mp");
    self MenuOption("enfield dual mag", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_dualclip_mp");
    self MenuOption("enfield dual mag", 6, "suppressor", ::GivePlayerWeapon, "enfield_dualclip_silencer_mp");
    self MenuOption("enfield dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "enfield_gl_dualclip_mp");
    
    self MainMenu("enfield masterkey", "enfield 2 attachments");
    self MenuOption("enfield masterkey", 0, "extended mag", ::GivePlayerWeapon, "enfield_mk_extclip_mp");
    self MenuOption("enfield masterkey", 1, "dual mag", ::GivePlayerWeapon, "enfield_mk_dualclip_mp");
    self MenuOption("enfield masterkey", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_mk_mp");
    self MenuOption("enfield masterkey", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_mk_mp");
    self MenuOption("enfield masterkey", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_mk_mp");
    self MenuOption("enfield masterkey", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_mk_mp");
    self MenuOption("enfield masterkey", 6, "suppressor", ::GivePlayerWeapon, "enfield_mk_silencer_mp");

    self MainMenu("enfield flamethrower", "enfield 2 attachments");
    self MenuOption("enfield flamethrower", 0, "extended mag", ::GivePlayerWeapon, "enfield_ft_extclip_mp");
    self MenuOption("enfield flamethrower", 1, "dual mag", ::GivePlayerWeapon, "enfield_ft_dualclip_mp");
    self MenuOption("enfield flamethrower", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_ft_mp");
    self MenuOption("enfield flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_ft_mp");
    self MenuOption("enfield flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_ft_mp");
    self MenuOption("enfield flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_ft_mp");
    self MenuOption("enfield flamethrower", 6, "suppressor", ::GivePlayerWeapon, "enfield_ft_silencer_mp");
    
    self MainMenu("enfield grenade launcher", "enfield 2 attachments");
    self MenuOption("enfield grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "enfield_gl_extclip_mp");
    self MenuOption("enfield grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "enfield_gl_dualclip_mp");
    self MenuOption("enfield grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "enfield_acog_gl_mp");
    self MenuOption("enfield grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "enfield_elbit_gl_mp");
    self MenuOption("enfield grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "enfield_reflex_gl_mp");
    self MenuOption("enfield grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "enfield_ir_gl_mp");
    self MenuOption("enfield grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "enfield_gl_silencer_mp");
    
    self MainMenu("m14", "assault rifles");
    self MenuOption("m14", 0, "extended mag", ::GivePlayerWeapon, "m14_extclip_mp");
    self MenuOption("m14", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_mp");
    self MenuOption("m14", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_mp");
    self MenuOption("m14", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_mp");
    self MenuOption("m14", 4, "masterkey", ::GivePlayerWeapon, "m14_mk_mp");
    self MenuOption("m14", 5, "flamethrower", ::GivePlayerWeapon, "m14_ft_mp");
    self MenuOption("m14", 6, "infrared scope", ::GivePlayerWeapon, "m14_ir_mp");
    self MenuOption("m14", 7, "suppressor", ::GivePlayerWeapon, "m14_silencer_mp");
    self MenuOption("m14", 8, "grenade launcher", ::GivePlayerWeapon, "m14_gl_mp");
    self MenuOption("m14", 9, "default", ::GivePlayerWeapon, "m14_mp");
    self MenuOption("m14", 10, "2 attachments", ::SubMenu, "m14 2 attachments");
    
    self MainMenu("m14 2 attachments", "m14");
    self MenuOption("m14 2 attachments", 0, "extended mag", ::SubMenu, "m14 extended mag");
    self MenuOption("m14 2 attachments", 1, "masterkey", ::SubMenu, "m14 masterkey");
    self MenuOption("m14 2 attachments", 2, "flamethrower", ::SubMenu, "m14 flamethrower");
    self MenuOption("m14 2 attachments", 3, "grenade launcher", ::SubMenu, "m14 grenade launcher");
    
    self MainMenu("m14 extended mag", "m14 2 attachments");
    self MenuOption("m14 extended mag", 0, "acog sight", ::GivePlayerWeapon, "m14_acog_extclip_mp");
    self MenuOption("m14 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "m14_elbit_extclip_mp");
    self MenuOption("m14 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "m14_reflex_extclip_mp");
    self MenuOption("m14 extended mag", 3, "masterkey", ::GivePlayerWeapon, "m14_mk_extclip_mp");
    self MenuOption("m14 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "m14_ft_extclip_mp");
    self MenuOption("m14 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "m14_ir_extclip_mp");
    self MenuOption("m14 extended mag", 6, "suppressor", ::GivePlayerWeapon, "m14_extclip_silencer_mp");
    self MenuOption("m14 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "m14_gl_extclip_mp");

    self MainMenu("m14 masterkey", "m14 2 attachments");
    self MenuOption("m14 masterkey", 0, "extended mag", ::GivePlayerWeapon, "m14_mk_extclip_mp");
    self MenuOption("m14 masterkey", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_mk_mp");
    self MenuOption("m14 masterkey", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_mk_mp");
    self MenuOption("m14 masterkey", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_mk_mp");
    self MenuOption("m14 masterkey", 4, "infrared scope", ::GivePlayerWeapon, "m14_ir_mk_mp");
    self MenuOption("m14 masterkey", 5, "suppressor", ::GivePlayerWeapon, "m14_mk_silencer_mp");

    self MainMenu("m14 flamethrower", "m14 2 attachments");
    self MenuOption("m14 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "m14_ft_extclip_mp");
    self MenuOption("m14 flamethrower", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_ft_mp");
    self MenuOption("m14 flamethrower", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_ft_mp");
    self MenuOption("m14 flamethrower", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_ft_mp");
    self MenuOption("m14 flamethrower", 4, "infrared scope", ::GivePlayerWeapon, "m14_ir_ft_mp");
    self MenuOption("m14 flamethrower", 5, "suppressor", ::GivePlayerWeapon, "m14_ft_silencer_mp");
    
    self MainMenu("m14 grenade launcher", "m14 2 attachments");
    self MenuOption("m14 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "m14_gl_extclip_mp");
    self MenuOption("m14 grenade launcher", 1, "acog sight", ::GivePlayerWeapon, "m14_acog_gl_mp");
    self MenuOption("m14 grenade launcher", 2, "red dot sight", ::GivePlayerWeapon, "m14_elbit_gl_mp");
    self MenuOption("m14 grenade launcher", 3, "reflex sight", ::GivePlayerWeapon, "m14_reflex_gl_mp");
    self MenuOption("m14 grenade launcher", 4, "infrared scope", ::GivePlayerWeapon, "m14_gl_ir_mp");
    self MenuOption("m14 grenade launcher", 5, "suppressor", ::GivePlayerWeapon, "m14_gl_silencer_mp");
    
    self MainMenu("famas", "assault rifles");
    self MenuOption("famas", 0, "extended mag", ::GivePlayerWeapon, "famas_extclip_mp");
    self MenuOption("famas", 1, "dual mag", ::GivePlayerWeapon, "famas_dualclip_mp");
    self MenuOption("famas", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_mp");
    self MenuOption("famas", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_mp");
    self MenuOption("famas", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_mp");
    self MenuOption("famas", 5, "masterkey", ::GivePlayerWeapon, "famas_mk_mp");
    self MenuOption("famas", 6, "flamethrower", ::GivePlayerWeapon, "famas_ft_mp");
    self MenuOption("famas", 7, "infrared scope", ::GivePlayerWeapon, "famas_ir_mp");
    self MenuOption("famas", 8, "suppressor", ::GivePlayerWeapon, "famas_silencer_mp");
    self MenuOption("famas", 9, "grenade launcher", ::GivePlayerWeapon, "famas_gl_mp");
    self MenuOption("famas", 10, "default", ::GivePlayerWeapon, "famas_mp");
    self MenuOption("famas", 11, "2 attachments", ::SubMenu, "famas 2 attachments");
    
    self MainMenu("famas 2 attachments", "famas");
    self MenuOption("famas 2 attachments", 0, "extended mag", ::SubMenu, "famas extended mag");
    self MenuOption("famas 2 attachments", 1, "dual mag", ::SubMenu, "famas dual mag");
    self MenuOption("famas 2 attachments", 2, "masterkey", ::SubMenu, "famas masterkey");
    self MenuOption("famas 2 attachments", 3, "flamethrower", ::SubMenu, "famas flamethrower");
    self MenuOption("famas 2 attachments", 4, "grenade launcher", ::SubMenu, "famas grenade launcher");
    
    self MainMenu("famas extended mag", "famas 2 attachments");
    self MenuOption("famas extended mag", 0, "acog sight", ::GivePlayerWeapon, "famas_acog_extclip_mp");
    self MenuOption("famas extended mag", 1, "red dot sight", ::GivePlayerWeapon, "famas_elbit_extclip_mp");
    self MenuOption("famas extended mag", 2, "reflex sight", ::GivePlayerWeapon, "famas_reflex_extclip_mp");
    self MenuOption("famas extended mag", 3, "masterkey", ::GivePlayerWeapon, "famas_mk_extclip_mp");
    self MenuOption("famas extended mag", 4, "flamethrower", ::GivePlayerWeapon, "famas_ft_extclip_mp");
    self MenuOption("famas extended mag", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_extclip_mp");
    self MenuOption("famas extended mag", 6, "suppressor", ::GivePlayerWeapon, "famas_extclip_silencer_mp");
    self MenuOption("famas extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "famas_gl_extclip_mp");
    
    self MainMenu("famas dual mag", "famas 2 attachments");
    self MenuOption("famas dual mag", 0, "acog sight", ::GivePlayerWeapon, "famas_acog_dualclip_mp");
    self MenuOption("famas dual mag", 1, "red dot sight", ::GivePlayerWeapon, "famas_elbit_dualclip_mp");
    self MenuOption("famas dual mag", 2, "reflex sight", ::GivePlayerWeapon, "famas_reflex_dualclip_mp");
    self MenuOption("famas dual mag", 3, "masterkey", ::GivePlayerWeapon, "famas_mk_dualclip_mp");
    self MenuOption("famas dual mag", 4, "flamethrower", ::GivePlayerWeapon, "famas_ft_dualclip_mp");
    self MenuOption("famas dual mag", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_dualclip_mp");
    self MenuOption("famas dual mag", 6, "suppressor", ::GivePlayerWeapon, "famas_dualclip_silencer_mp");
    self MenuOption("famas dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "famas_gl_dualclip_mp");
    
    self MainMenu("famas masterkey", "famas 2 attachments");
    self MenuOption("famas masterkey", 0, "extended mag", ::GivePlayerWeapon, "famas_mk_extclip_mp");
    self MenuOption("famas masterkey", 1, "dual mag", ::GivePlayerWeapon, "famas_mk_dualclip_mp");
    self MenuOption("famas masterkey", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_mk_mp");
    self MenuOption("famas masterkey", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_mk_mp");
    self MenuOption("famas masterkey", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_mk_mp");
    self MenuOption("famas masterkey", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_mk_mp");
    self MenuOption("famas masterkey", 6, "suppressor", ::GivePlayerWeapon, "famas_mk_silencer_mp");

    self MainMenu("famas flamethrower", "famas 2 attachments");
    self MenuOption("famas flamethrower", 0, "extended mag", ::GivePlayerWeapon, "famas_ft_extclip_mp");
    self MenuOption("famas flamethrower", 1, "dual mag", ::GivePlayerWeapon, "famas_ft_dualclip_mp");
    self MenuOption("famas flamethrower", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_ft_mp");
    self MenuOption("famas flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_ft_mp");
    self MenuOption("famas flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_ft_mp");
    self MenuOption("famas flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_ft_mp");
    self MenuOption("famas flamethrower", 6, "suppressor", ::GivePlayerWeapon, "famas_ft_silencer_mp");
    
    self MainMenu("famas grenade launcher", "famas 2 attachments");
    self MenuOption("famas grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "famas_gl_extclip_mp");
    self MenuOption("famas grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "famas_gl_dualclip_mp");
    self MenuOption("famas grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "famas_acog_gl_mp");
    self MenuOption("famas grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "famas_elbit_gl_mp");
    self MenuOption("famas grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "famas_reflex_gl_mp");
    self MenuOption("famas grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "famas_ir_gl_mp");
    self MenuOption("famas grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "famas_gl_silencer_mp");
    
    self MainMenu("galil", "assault rifles");
    self MenuOption("galil", 0, "extended mag", ::GivePlayerWeapon, "galil_extclip_mp");
    self MenuOption("galil", 1, "dual mag", ::GivePlayerWeapon, "galil_dualclip_mp");
    self MenuOption("galil", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_mp");
    self MenuOption("galil", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_mp");
    self MenuOption("galil", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_mp");
    self MenuOption("galil", 5, "masterkey", ::GivePlayerWeapon, "galil_mk_mp");
    self MenuOption("galil", 6, "flamethrower", ::GivePlayerWeapon, "galil_ft_mp");
    self MenuOption("galil", 7, "infrared scope", ::GivePlayerWeapon, "galil_ir_mp");
    self MenuOption("galil", 8, "suppressor", ::GivePlayerWeapon, "galil_silencer_mp");
    self MenuOption("galil", 9, "grenade launcher", ::GivePlayerWeapon, "galil_gl_mp");
    self MenuOption("galil", 10, "default", ::GivePlayerWeapon, "galil_mp");
    self MenuOption("galil", 11, "2 attachments", ::SubMenu, "galil 2 attachments");
    
    self MainMenu("galil 2 attachments", "galil");
    self MenuOption("galil 2 attachments", 0, "extended mag", ::SubMenu, "galil extended mag");
    self MenuOption("galil 2 attachments", 1, "dual mag", ::SubMenu, "galil dual mag");
    self MenuOption("galil 2 attachments", 2, "masterkey", ::SubMenu, "galil masterkey");
    self MenuOption("galil 2 attachments", 3, "flamethrower", ::SubMenu, "galil flamethrower");
    self MenuOption("galil 2 attachments", 4, "grenade launcher", ::SubMenu, "galil grenade launcher");
    
    self MainMenu("galil extended mag", "galil 2 attachments");
    self MenuOption("galil extended mag", 0, "acog sight", ::GivePlayerWeapon, "galil_acog_extclip_mp");
    self MenuOption("galil extended mag", 1, "red dot sight", ::GivePlayerWeapon, "galil_elbit_extclip_mp");
    self MenuOption("galil extended mag", 2, "reflex sight", ::GivePlayerWeapon, "galil_reflex_extclip_mp");
    self MenuOption("galil extended mag", 3, "masterkey", ::GivePlayerWeapon, "galil_mk_extclip_mp");
    self MenuOption("galil extended mag", 4, "flamethrower", ::GivePlayerWeapon, "galil_ft_extclip_mp");
    self MenuOption("galil extended mag", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_extclip_mp");
    self MenuOption("galil extended mag", 6, "suppressor", ::GivePlayerWeapon, "galil_extclip_silencer_mp");
    self MenuOption("galil extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "galil_gl_extclip_mp");
    
    self MainMenu("galil dual mag", "galil 2 attachments");
    self MenuOption("galil dual mag", 0, "acog sight", ::GivePlayerWeapon, "galil_acog_dualclip_mp");
    self MenuOption("galil dual mag", 1, "red dot sight", ::GivePlayerWeapon, "galil_elbit_dualclip_mp");
    self MenuOption("galil dual mag", 2, "reflex sight", ::GivePlayerWeapon, "galil_reflex_dualclip_mp");
    self MenuOption("galil dual mag", 3, "masterkey", ::GivePlayerWeapon, "galil_mk_dualclip_mp");
    self MenuOption("galil dual mag", 4, "flamethrower", ::GivePlayerWeapon, "galil_ft_dualclip_mp");
    self MenuOption("galil dual mag", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_dualclip_mp");
    self MenuOption("galil dual mag", 6, "suppressor", ::GivePlayerWeapon, "galil_dualclip_silencer_mp");
    self MenuOption("galil dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "galil_gl_dualclip_mp");
    
    self MainMenu("galil masterkey", "galil 2 attachments");
    self MenuOption("galil masterkey", 0, "extended mag", ::GivePlayerWeapon, "galil_mk_extclip_mp");
    self MenuOption("galil masterkey", 1, "dual mag", ::GivePlayerWeapon, "galil_mk_dualclip_mp");
    self MenuOption("galil masterkey", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_mk_mp");
    self MenuOption("galil masterkey", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_mk_mp");
    self MenuOption("galil masterkey", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_mk_mp");
    self MenuOption("galil masterkey", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_mk_mp");
    self MenuOption("galil masterkey", 6, "suppressor", ::GivePlayerWeapon, "galil_mk_silencer_mp");

    self MainMenu("galil flamethrower", "galil 2 attachments");
    self MenuOption("galil flamethrower", 0, "extended mag", ::GivePlayerWeapon, "galil_ft_extclip_mp");
    self MenuOption("galil flamethrower", 1, "dual mag", ::GivePlayerWeapon, "galil_ft_dualclip_mp");
    self MenuOption("galil flamethrower", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_ft_mp");
    self MenuOption("galil flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_ft_mp");
    self MenuOption("galil flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_ft_mp");
    self MenuOption("galil flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_ft_mp");
    self MenuOption("galil flamethrower", 6, "suppressor", ::GivePlayerWeapon, "galil_ft_silencer_mp");
    
    self MainMenu("galil grenade launcher", "galil 2 attachments");
    self MenuOption("galil grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "galil_gl_extclip_mp");
    self MenuOption("galil grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "galil_gl_dualclip_mp");
    self MenuOption("galil grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "galil_acog_gl_mp");
    self MenuOption("galil grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "galil_elbit_gl_mp");
    self MenuOption("galil grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "galil_reflex_gl_mp");
    self MenuOption("galil grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "galil_ir_gl_mp");
    self MenuOption("galil grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "galil_gl_silencer_mp");
    
    self MainMenu("aug", "assault rifles");
    self MenuOption("aug", 0, "extended mag", ::GivePlayerWeapon, "aug_extclip_mp");
    self MenuOption("aug", 1, "dual mag", ::GivePlayerWeapon, "aug_dualclip_mp");
    self MenuOption("aug", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_mp");
    self MenuOption("aug", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_mp");
    self MenuOption("aug", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_mp");
    self MenuOption("aug", 5, "masterkey", ::GivePlayerWeapon, "aug_mk_mp");
    self MenuOption("aug", 6, "flamethrower", ::GivePlayerWeapon, "aug_ft_mp");
    self MenuOption("aug", 7, "infrared scope", ::GivePlayerWeapon, "aug_ir_mp");
    self MenuOption("aug", 8, "suppressor", ::GivePlayerWeapon, "aug_silencer_mp");
    self MenuOption("aug", 9, "grenade launcher", ::GivePlayerWeapon, "aug_gl_mp");
    self MenuOption("aug", 10, "default", ::GivePlayerWeapon, "aug_mp");
    self MenuOption("aug", 11, "2 attachments", ::SubMenu, "aug 2 attachments");
    
    self MainMenu("aug 2 attachments", "aug");
    self MenuOption("aug 2 attachments", 0, "extended mag", ::SubMenu, "aug extended mag");
    self MenuOption("aug 2 attachments", 1, "dual mag", ::SubMenu, "aug dual mag");
    self MenuOption("aug 2 attachments", 2, "masterkey", ::SubMenu, "aug masterkey");
    self MenuOption("aug 2 attachments", 3, "flamethrower", ::SubMenu, "aug flamethrower");
    self MenuOption("aug 2 attachments", 4, "grenade launcher", ::SubMenu, "aug grenade launcher");
    
    self MainMenu("aug extended mag", "aug 2 attachments");
    self MenuOption("aug extended mag", 0, "acog sight", ::GivePlayerWeapon, "aug_acog_extclip_mp");
    self MenuOption("aug extended mag", 1, "red dot sight", ::GivePlayerWeapon, "aug_elbit_extclip_mp");
    self MenuOption("aug extended mag", 2, "reflex sight", ::GivePlayerWeapon, "aug_reflex_extclip_mp");
    self MenuOption("aug extended mag", 3, "masterkey", ::GivePlayerWeapon, "aug_mk_extclip_mp");
    self MenuOption("aug extended mag", 4, "flamethrower", ::GivePlayerWeapon, "aug_ft_extclip_mp");
    self MenuOption("aug extended mag", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_extclip_mp");
    self MenuOption("aug extended mag", 6, "suppressor", ::GivePlayerWeapon, "aug_extclip_silencer_mp");
    self MenuOption("aug extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "aug_gl_extclip_mp");
    
    self MainMenu("aug dual mag", "aug 2 attachments");
    self MenuOption("aug dual mag", 0, "acog sight", ::GivePlayerWeapon, "aug_acog_dualclip_mp");
    self MenuOption("aug dual mag", 1, "red dot sight", ::GivePlayerWeapon, "aug_elbit_dualclip_mp");
    self MenuOption("aug dual mag", 2, "reflex sight", ::GivePlayerWeapon, "aug_reflex_dualclip_mp");
    self MenuOption("aug dual mag", 3, "masterkey", ::GivePlayerWeapon, "aug_mk_dualclip_mp");
    self MenuOption("aug dual mag", 4, "flamethrower", ::GivePlayerWeapon, "aug_ft_dualclip_mp");
    self MenuOption("aug dual mag", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_dualclip_mp");
    self MenuOption("aug dual mag", 6, "suppressor", ::GivePlayerWeapon, "aug_dualclip_silencer_mp");
    self MenuOption("aug dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "aug_gl_dualclip_mp");
    
    self MainMenu("aug masterkey", "aug 2 attachments");
    self MenuOption("aug masterkey", 0, "extended mag", ::GivePlayerWeapon, "aug_mk_extclip_mp");
    self MenuOption("aug masterkey", 1, "dual mag", ::GivePlayerWeapon, "aug_mk_dualclip_mp");
    self MenuOption("aug masterkey", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_mk_mp");
    self MenuOption("aug masterkey", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_mk_mp");
    self MenuOption("aug masterkey", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_mk_mp");
    self MenuOption("aug masterkey", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_mk_mp");
    self MenuOption("aug masterkey", 6, "suppressor", ::GivePlayerWeapon, "aug_mk_silencer_mp");

    self MainMenu("aug flamethrower", "aug 2 attachments");
    self MenuOption("aug flamethrower", 0, "extended mag", ::GivePlayerWeapon, "aug_ft_extclip_mp");
    self MenuOption("aug flamethrower", 1, "dual mag", ::GivePlayerWeapon, "aug_ft_dualclip_mp");
    self MenuOption("aug flamethrower", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_ft_mp");
    self MenuOption("aug flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_ft_mp");
    self MenuOption("aug flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_ft_mp");
    self MenuOption("aug flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_ft_mp");
    self MenuOption("aug flamethrower", 6, "suppressor", ::GivePlayerWeapon, "aug_ft_silencer_mp");
    
    self MainMenu("aug grenade launcher", "aug 2 attachments");
    self MenuOption("aug grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "aug_gl_extclip_mp");
    self MenuOption("aug grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "aug_gl_dualclip_mp");
    self MenuOption("aug grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "aug_acog_gl_mp");
    self MenuOption("aug grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "aug_elbit_gl_mp");
    self MenuOption("aug grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "aug_reflex_gl_mp");
    self MenuOption("aug grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "aug_ir_gl_mp");
    self MenuOption("aug grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "aug_gl_silencer_mp");
    
    self MainMenu("fnfal", "assault rifles");
    self MenuOption("fnfal", 0, "extended mag", ::GivePlayerWeapon, "fnfal_extclip_mp");
    self MenuOption("fnfal", 1, "dual mag", ::GivePlayerWeapon, "fnfal_dualclip_mp");
    self MenuOption("fnfal", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_mp");
    self MenuOption("fnfal", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_mp");
    self MenuOption("fnfal", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_mp");
    self MenuOption("fnfal", 5, "masterkey", ::GivePlayerWeapon, "fnfal_mk_mp");
    self MenuOption("fnfal", 6, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_mp");
    self MenuOption("fnfal", 7, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_mp");
    self MenuOption("fnfal", 8, "suppressor", ::GivePlayerWeapon, "fnfal_silencer_mp");
    self MenuOption("fnfal", 9, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_mp");
    self MenuOption("fnfal", 10, "default", ::GivePlayerWeapon, "fnfal_mp");
    self MenuOption("fnfal", 11, "2 attachments", ::SubMenu, "fnfal 2 attachments");
    
    self MainMenu("fnfal 2 attachments", "fnfal");
    self MenuOption("fnfal 2 attachments", 0, "extended mag", ::SubMenu, "fnfal extended mag");
    self MenuOption("fnfal 2 attachments", 1, "dual mag", ::SubMenu, "fnfal dual mag");
    self MenuOption("fnfal 2 attachments", 2, "masterkey", ::SubMenu, "fnfal masterkey");
    self MenuOption("fnfal 2 attachments", 3, "flamethrower", ::SubMenu, "fnfal flamethrower");
    self MenuOption("fnfal 2 attachments", 4, "grenade launcher", ::SubMenu, "fnfal grenade launcher");
    
    self MainMenu("fnfal extended mag", "fnfal 2 attachments");
    self MenuOption("fnfal extended mag", 0, "acog sight", ::GivePlayerWeapon, "fnfal_acog_extclip_mp");
    self MenuOption("fnfal extended mag", 1, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_extclip_mp");
    self MenuOption("fnfal extended mag", 2, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_extclip_mp");
    self MenuOption("fnfal extended mag", 3, "masterkey", ::GivePlayerWeapon, "fnfal_mk_extclip_mp");
    self MenuOption("fnfal extended mag", 4, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_extclip_mp");
    self MenuOption("fnfal extended mag", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_extclip_mp");
    self MenuOption("fnfal extended mag", 6, "suppressor", ::GivePlayerWeapon, "fnfal_extclip_silencer_mp");
    self MenuOption("fnfal extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_extclip_mp");
    
    self MainMenu("fnfal dual mag", "fnfal 2 attachments");
    self MenuOption("fnfal dual mag", 0, "acog sight", ::GivePlayerWeapon, "fnfal_acog_dualclip_mp");
    self MenuOption("fnfal dual mag", 1, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_dualclip_mp");
    self MenuOption("fnfal dual mag", 2, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_dualclip_mp");
    self MenuOption("fnfal dual mag", 3, "masterkey", ::GivePlayerWeapon, "fnfal_mk_dualclip_mp");
    self MenuOption("fnfal dual mag", 4, "flamethrower", ::GivePlayerWeapon, "fnfal_ft_dualclip_mp");
    self MenuOption("fnfal dual mag", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_dualclip_mp");
    self MenuOption("fnfal dual mag", 6, "suppressor", ::GivePlayerWeapon, "fnfal_dualclip_silencer_mp");
    self MenuOption("fnfal dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "fnfal_gl_dualclip_mp");
    
    self MainMenu("fnfal masterkey", "fnfal 2 attachments");
    self MenuOption("fnfal masterkey", 0, "extended mag", ::GivePlayerWeapon, "fnfal_mk_extclip_mp");
    self MenuOption("fnfal masterkey", 1, "dual mag", ::GivePlayerWeapon, "fnfal_mk_dualclip_mp");
    self MenuOption("fnfal masterkey", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_mk_mp");
    self MenuOption("fnfal masterkey", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_mk_mp");
    self MenuOption("fnfal masterkey", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_mk_mp");
    self MenuOption("fnfal masterkey", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_mk_mp");
    self MenuOption("fnfal masterkey", 6, "suppressor", ::GivePlayerWeapon, "fnfal_mk_silencer_mp");

    self MainMenu("fnfal flamethrower", "fnfal 2 attachments");
    self MenuOption("fnfal flamethrower", 0, "extended mag", ::GivePlayerWeapon, "fnfal_ft_extclip_mp");
    self MenuOption("fnfal flamethrower", 1, "dual mag", ::GivePlayerWeapon, "fnfal_ft_dualclip_mp");
    self MenuOption("fnfal flamethrower", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_ft_mp");
    self MenuOption("fnfal flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_ft_mp");
    self MenuOption("fnfal flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_ft_mp");
    self MenuOption("fnfal flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_ft_mp");
    self MenuOption("fnfal flamethrower", 6, "suppressor", ::GivePlayerWeapon, "fnfal_ft_silencer_mp");
    
    self MainMenu("fnfal grenade launcher", "fnfal 2 attachments");
    self MenuOption("fnfal grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "fnfal_gl_extclip_mp");
    self MenuOption("fnfal grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "fnfal_gl_dualclip_mp");
    self MenuOption("fnfal grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "fnfal_acog_gl_mp");
    self MenuOption("fnfal grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "fnfal_elbit_gl_mp");
    self MenuOption("fnfal grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "fnfal_reflex_gl_mp");
    self MenuOption("fnfal grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "fnfal_ir_gl_mp");
    self MenuOption("fnfal grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "fnfal_gl_silencer_mp");
    
    self MainMenu("ak47", "assault rifles");
    self MenuOption("ak47", 0, "extended mag", ::GivePlayerWeapon, "ak47_extclip_mp");
    self MenuOption("ak47", 1, "dual mag", ::GivePlayerWeapon, "ak47_dualclip_mp");
    self MenuOption("ak47", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_mp");
    self MenuOption("ak47", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_mp");
    self MenuOption("ak47", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_mp");
    self MenuOption("ak47", 5, "masterkey", ::GivePlayerWeapon, "ak47_mk_mp");
    self MenuOption("ak47", 6, "flamethrower", ::GivePlayerWeapon, "ak47_ft_mp");
    self MenuOption("ak47", 7, "infrared scope", ::GivePlayerWeapon, "ak47_ir_mp");
    self MenuOption("ak47", 8, "suppressor", ::GivePlayerWeapon, "ak47_silencer_mp");
    self MenuOption("ak47", 9, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_mp");
    self MenuOption("ak47", 10, "default", ::GivePlayerWeapon, "ak47_mp");
    self MenuOption("ak47", 11, "2 attachments", ::SubMenu, "ak47 2 attachments");
    
    self MainMenu("ak47 2 attachments", "ak47");
    self MenuOption("ak47 2 attachments", 0, "extended mag", ::SubMenu, "ak47 extended mag");
    self MenuOption("ak47 2 attachments", 1, "dual mag", ::SubMenu, "ak47 dual mag");
    self MenuOption("ak47 2 attachments", 2, "masterkey", ::SubMenu, "ak47 masterkey");
    self MenuOption("ak47 2 attachments", 3, "flamethrower", ::SubMenu, "ak47 flamethrower");
    self MenuOption("ak47 2 attachments", 4, "grenade launcher", ::SubMenu, "ak47 grenade launcher");
    
    self MainMenu("ak47 extended mag", "ak47 2 attachments");
    self MenuOption("ak47 extended mag", 0, "acog sight", ::GivePlayerWeapon, "ak47_acog_extclip_mp");
    self MenuOption("ak47 extended mag", 1, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_extclip_mp");
    self MenuOption("ak47 extended mag", 2, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_extclip_mp");
    self MenuOption("ak47 extended mag", 3, "masterkey", ::GivePlayerWeapon, "ak47_mk_extclip_mp");
    self MenuOption("ak47 extended mag", 4, "flamethrower", ::GivePlayerWeapon, "ak47_ft_extclip_mp");
    self MenuOption("ak47 extended mag", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_extclip_mp");
    self MenuOption("ak47 extended mag", 6, "suppressor", ::GivePlayerWeapon, "ak47_extclip_silencer_mp");
    self MenuOption("ak47 extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_extclip_mp");
    
    self MainMenu("ak47 dual mag", "ak47 2 attachments");
    self MenuOption("ak47 dual mag", 0, "acog sight", ::GivePlayerWeapon, "ak47_acog_dualclip_mp");
    self MenuOption("ak47 dual mag", 1, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_dualclip_mp");
    self MenuOption("ak47 dual mag", 2, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_dualclip_mp");
    self MenuOption("ak47 dual mag", 3, "masterkey", ::GivePlayerWeapon, "ak47_mk_dualclip_mp");
    self MenuOption("ak47 dual mag", 4, "flamethrower", ::GivePlayerWeapon, "ak47_ft_dualclip_mp");
    self MenuOption("ak47 dual mag", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_dualclip_mp");
    self MenuOption("ak47 dual mag", 6, "suppressor", ::GivePlayerWeapon, "ak47_dualclip_silencer_mp");
    self MenuOption("ak47 dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "ak47_gl_dualclip_mp");
    
    self MainMenu("ak47 masterkey", "ak47 2 attachments");
    self MenuOption("ak47 masterkey", 0, "extended mag", ::GivePlayerWeapon, "ak47_mk_extclip_mp");
    self MenuOption("ak47 masterkey", 1, "dual mag", ::GivePlayerWeapon, "ak47_mk_dualclip_mp");
    self MenuOption("ak47 masterkey", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_mk_mp");
    self MenuOption("ak47 masterkey", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_mk_mp");
    self MenuOption("ak47 masterkey", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_mk_mp");
    self MenuOption("ak47 masterkey", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_mk_mp");
    self MenuOption("ak47 masterkey", 6, "suppressor", ::GivePlayerWeapon, "ak47_mk_silencer_mp");

    self MainMenu("ak47 flamethrower", "ak47 2 attachments");
    self MenuOption("ak47 flamethrower", 0, "extended mag", ::GivePlayerWeapon, "ak47_ft_extclip_mp");
    self MenuOption("ak47 flamethrower", 1, "dual mag", ::GivePlayerWeapon, "ak47_ft_dualclip_mp");
    self MenuOption("ak47 flamethrower", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_ft_mp");
    self MenuOption("ak47 flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_ft_mp");
    self MenuOption("ak47 flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_ft_mp");
    self MenuOption("ak47 flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_ft_mp");
    self MenuOption("ak47 flamethrower", 6, "suppressor", ::GivePlayerWeapon, "ak47_ft_silencer_mp");
    
    self MainMenu("ak47 grenade launcher", "ak47 2 attachments");
    self MenuOption("ak47 grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "ak47_gl_extclip_mp");
    self MenuOption("ak47 grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "ak47_gl_dualclip_mp");
    self MenuOption("ak47 grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "ak47_acog_gl_mp");
    self MenuOption("ak47 grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "ak47_elbit_gl_mp");
    self MenuOption("ak47 grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "ak47_reflex_gl_mp");
    self MenuOption("ak47 grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "ak47_ir_gl_mp");
    self MenuOption("ak47 grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "ak47_gl_silencer_mp");
    
    self MainMenu("commando", "assault rifles");
    self MenuOption("commando", 0, "extended mag", ::GivePlayerWeapon, "commando_extclip_mp");
    self MenuOption("commando", 1, "dual mag", ::GivePlayerWeapon, "commando_dualclip_mp");
    self MenuOption("commando", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_mp");
    self MenuOption("commando", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_mp");
    self MenuOption("commando", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_mp");
    self MenuOption("commando", 5, "masterkey", ::GivePlayerWeapon, "commando_mk_mp");
    self MenuOption("commando", 6, "flamethrower", ::GivePlayerWeapon, "commando_ft_mp");
    self MenuOption("commando", 7, "infrared scope", ::GivePlayerWeapon, "commando_ir_mp");
    self MenuOption("commando", 8, "suppressor", ::GivePlayerWeapon, "commando_silencer_mp");
    self MenuOption("commando", 9, "grenade launcher", ::GivePlayerWeapon, "commando_gl_mp");
    self MenuOption("commando", 10, "default", ::GivePlayerWeapon, "commando_mp");
    self MenuOption("commando", 11, "2 attachments", ::SubMenu, "commando 2 attachments");
    
    self MainMenu("commando 2 attachments", "commando");
    self MenuOption("commando 2 attachments", 0, "extended mag", ::SubMenu, "commando extended mag");
    self MenuOption("commando 2 attachments", 1, "dual mag", ::SubMenu, "commando dual mag");
    self MenuOption("commando 2 attachments", 2, "masterkey", ::SubMenu, "commando masterkey");
    self MenuOption("commando 2 attachments", 3, "flamethrower", ::SubMenu, "commando flamethrower");
    self MenuOption("commando 2 attachments", 4, "grenade launcher", ::SubMenu, "commando grenade launcher");
    
    self MainMenu("commando extended mag", "commando 2 attachments");
    self MenuOption("commando extended mag", 0, "acog sight", ::GivePlayerWeapon, "commando_acog_extclip_mp");
    self MenuOption("commando extended mag", 1, "red dot sight", ::GivePlayerWeapon, "commando_elbit_extclip_mp");
    self MenuOption("commando extended mag", 2, "reflex sight", ::GivePlayerWeapon, "commando_reflex_extclip_mp");
    self MenuOption("commando extended mag", 3, "masterkey", ::GivePlayerWeapon, "commando_mk_extclip_mp");
    self MenuOption("commando extended mag", 4, "flamethrower", ::GivePlayerWeapon, "commando_ft_extclip_mp");
    self MenuOption("commando extended mag", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_extclip_mp");
    self MenuOption("commando extended mag", 6, "suppressor", ::GivePlayerWeapon, "commando_extclip_silencer_mp");
    self MenuOption("commando extended mag", 7, "grenade launcher", ::GivePlayerWeapon, "commando_gl_extclip_mp");
    
    self MainMenu("commando dual mag", "commando 2 attachments");
    self MenuOption("commando dual mag", 0, "acog sight", ::GivePlayerWeapon, "commando_acog_dualclip_mp");
    self MenuOption("commando dual mag", 1, "red dot sight", ::GivePlayerWeapon, "commando_elbit_dualclip_mp");
    self MenuOption("commando dual mag", 2, "reflex sight", ::GivePlayerWeapon, "commando_reflex_dualclip_mp");
    self MenuOption("commando dual mag", 3, "masterkey", ::GivePlayerWeapon, "commando_mk_dualclip_mp");
    self MenuOption("commando dual mag", 4, "flamethrower", ::GivePlayerWeapon, "commando_ft_dualclip_mp");
    self MenuOption("commando dual mag", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_dualclip_mp");
    self MenuOption("commando dual mag", 6, "suppressor", ::GivePlayerWeapon, "commando_dualclip_silencer_mp");
    self MenuOption("commando dual mag", 7, "grenade launcher", ::GivePlayerWeapon, "commando_gl_dualclip_mp");
    
    self MainMenu("commando masterkey", "commando 2 attachments");
    self MenuOption("commando masterkey", 0, "extended mag", ::GivePlayerWeapon, "commando_mk_extclip_mp");
    self MenuOption("commando masterkey", 1, "dual mag", ::GivePlayerWeapon, "commando_mk_dualclip_mp");
    self MenuOption("commando masterkey", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_mk_mp");
    self MenuOption("commando masterkey", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_mk_mp");
    self MenuOption("commando masterkey", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_mk_mp");
    self MenuOption("commando masterkey", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_mk_mp");
    self MenuOption("commando masterkey", 6, "suppressor", ::GivePlayerWeapon, "commando_mk_silencer_mp");

    self MainMenu("commando flamethrower", "commando 2 attachments");
    self MenuOption("commando flamethrower", 0, "extended mag", ::GivePlayerWeapon, "commando_ft_extclip_mp");
    self MenuOption("commando flamethrower", 1, "dual mag", ::GivePlayerWeapon, "commando_ft_dualclip_mp");
    self MenuOption("commando flamethrower", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_ft_mp");
    self MenuOption("commando flamethrower", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_ft_mp");
    self MenuOption("commando flamethrower", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_ft_mp");
    self MenuOption("commando flamethrower", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_ft_mp");
    self MenuOption("commando flamethrower", 6, "suppressor", ::GivePlayerWeapon, "commando_ft_silencer_mp");
    
    self MainMenu("commando grenade launcher", "commando 2 attachments");
    self MenuOption("commando grenade launcher", 0, "extended mag", ::GivePlayerWeapon, "commando_gl_extclip_mp");
    self MenuOption("commando grenade launcher", 1, "dual mag", ::GivePlayerWeapon, "commando_gl_dualclip_mp");
    self MenuOption("commando grenade launcher", 2, "acog sight", ::GivePlayerWeapon, "commando_acog_gl_mp");
    self MenuOption("commando grenade launcher", 3, "red dot sight", ::GivePlayerWeapon, "commando_elbit_gl_mp");
    self MenuOption("commando grenade launcher", 4, "reflex sight", ::GivePlayerWeapon, "commando_reflex_gl_mp");
    self MenuOption("commando grenade launcher", 5, "infrared scope", ::GivePlayerWeapon, "commando_ir_gl_mp");
    self MenuOption("commando grenade launcher", 6, "suppressor", ::GivePlayerWeapon, "commando_gl_silencer_mp");
    
    self MainMenu("g11", "assault rifles");
    self MenuOption("g11", 0, "low power scoper", ::GivePlayerWeapon, "g11_lps_mp");
    self MenuOption("g11", 1, "variable zoom", ::GivePlayerWeapon, "g11_vzoom_mp");
    self MenuOption("g11", 2, "default", ::GivePlayerWeapon, "g11_mp");
    
    self MainMenu("submachine guns", "weapons menu");
    self MenuOption("submachine guns", 0, "mp5k", ::SubMenu, "mp5k");
    self MenuOption("submachine guns", 1, "skorpion", ::SubMenu, "skorpion");
    self MenuOption("submachine guns", 2, "mac11", ::SubMenu, "mac11");
    self MenuOption("submachine guns", 3, "ak74u", ::SubMenu, "ak74u");
    self MenuOption("submachine guns", 4, "uzi", ::SubMenu, "uzi");
    self MenuOption("submachine guns", 5, "pm63", ::SubMenu, "pm63");
    self MenuOption("submachine guns", 6, "mpl", ::SubMenu, "mpl");
    self MenuOption("submachine guns", 7, "spectre", ::SubMenu, "spectre");
    self MenuOption("submachine guns", 8, "kiparis", ::SubMenu, "kiparis");
    
    self MainMenu("mp5k", "submachine guns");
    self MenuOption("mp5k", 0, "extended mag", ::GivePlayerWeapon, "mp5k_extclip_mp");
    self MenuOption("mp5k", 1, "acog sight", ::GivePlayerWeapon, "mp5k_acog_mp");
    self MenuOption("mp5k", 2, "red dot sight", ::GivePlayerWeapon, "mp5k_elbit_mp");
    self MenuOption("mp5k", 3, "reflex sight", ::GivePlayerWeapon, "mp5k_reflex_mp");
    self MenuOption("mp5k", 4, "suppressor", ::GivePlayerWeapon, "mp5k_silencer_mp");
    self MenuOption("mp5k", 5, "rapid fire", ::GivePlayerWeapon, "mp5k_rf_mp");
    self MenuOption("mp5k", 6, "default", ::GivePlayerWeapon, "mp5k_mp");
    self MenuOption("mp5k", 7, "2 attachments", ::SubMenu, "mp5k 2 attachments");
    
    self MainMenu("mp5k 2 attachments", "mp5k");
    self MenuOption("mp5k 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "mp5k_acog_extclip_mp");
    self MenuOption("mp5k 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "mp5k_elbit_extclip_mp");
    self MenuOption("mp5k 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "mp5k_reflex_extclip_mp");
    self MenuOption("mp5k 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "mp5k_extclip_silencer_mp");
    self MenuOption("mp5k 2 attachments", 4, "rapid fire x acog sight", ::GivePlayerWeapon, "mp5k_acog_rf_mp");
    self MenuOption("mp5k 2 attachments", 5, "rapid fire x red dot sight", ::GivePlayerWeapon, "mp5k_elbit_rf_mp");
    self MenuOption("mp5k 2 attachments", 6, "rapid fire x reflex sight", ::GivePlayerWeapon, "mp5k_reflex_rf_mp");
    self MenuOption("mp5k 2 attachments", 7, "rapid fire x suppressor", ::GivePlayerWeapon, "mp5k_rf_silencer_mp");
    
    self MainMenu("skorpion", "submachine guns");
    self MenuOption("skorpion", 0, "extended mag", ::GivePlayerWeapon, "skorpion_extclip_mp");
    self MenuOption("skorpion", 1, "grip", ::GivePlayerWeapon, "skorpion_grip_mp");
    self MenuOption("skorpion", 2, "dual wield", ::GivePlayerWeapon, "skorpiondw_mp");
    self MenuOption("skorpion", 3, "suppressor", ::GivePlayerWeapon, "skorpion_silencer_mp");
    self MenuOption("skorpion", 4, "rapid fire", ::GivePlayerWeapon, "skorpion_rf_mp");
    self MenuOption("skorpion", 5, "default", ::GivePlayerWeapon, "skorpion_mp");
    self MenuOption("skorpion", 6, "2 attachments", ::SubMenu, "skorpion 2 attachments");
    
    self MainMenu("skorpion 2 attachments", "skorpion");
    self MenuOption("skorpion 2 attachments", 0, "extended mag x grip", ::GivePlayerWeapon, "skorpion_grip_extclip_mp");
    self MenuOption("skorpion 2 attachments", 1, "extended mag x suppressor", ::GivePlayerWeapon, "skorpion_extclip_silencer_mp");
    self MenuOption("skorpion 2 attachments", 2, "suppressor x grip", ::GivePlayerWeapon, "skorpion_grip_silencer_mp");
    self MenuOption("skorpion 2 attachments", 3, "rapid fire x grip", ::GivePlayerWeapon, "skorpion_grip_rf_mp");
    
    self MainMenu("mac11", "submachine guns");
    self MenuOption("mac11", 0, "extended mag", ::GivePlayerWeapon, "mac11_extclip_mp");
    self MenuOption("mac11", 1, "red dot sight", ::GivePlayerWeapon, "mac11_elbit_mp");
    self MenuOption("mac11", 2, "reflex sight", ::GivePlayerWeapon, "mac11_reflex_mp");
    self MenuOption("mac11", 3, "grip", ::GivePlayerWeapon, "mac11_grip_mp");
    self MenuOption("mac11", 4, "dual wield", ::GivePlayerWeapon, "mac11dw_mp");
    self MenuOption("mac11", 5, "dual wield glitched", ::GivePlayerWeapon, "mac11lh_mp");
    self MenuOption("mac11", 6, "suppressor", ::GivePlayerWeapon, "mac11_silencer_mp");
    self MenuOption("mac11", 7, "rapid fire", ::GivePlayerWeapon, "mac11_rf_mp");
    self MenuOption("mac11", 8, "default", ::GivePlayerWeapon, "mac11_mp");
    self MenuOption("mac11", 9, "2 attachments", ::SubMenu, "mac11 2 attachments");
    
    self MainMenu("mac11 2 attachments", "mac11");
    self MenuOption("mac11 2 attachments", 0, "extended mag x red dot sight", ::GivePlayerWeapon, "mac11_elbit_extclip_mp");
    self MenuOption("mac11 2 attachments", 1, "extended mag x reflex sight", ::GivePlayerWeapon, "mac11_reflex_extclip_mp");
    self MenuOption("mac11 2 attachments", 2, "extended mag x grip", ::GivePlayerWeapon, "mac11_grip_extclip_mp");
    self MenuOption("mac11 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "mac11_extclip_silencer_mp");
    self MenuOption("mac11 2 attachments", 4, "suppressor x red dot sight", ::GivePlayerWeapon, "mac11_elbit_silencer_mp");
    self MenuOption("mac11 2 attachments", 5, "suppressor x reflex sight", ::GivePlayerWeapon, "mac11_reflex_silencer_mp");
    self MenuOption("mac11 2 attachments", 6, "suppressor x grip", ::GivePlayerWeapon, "mac11_grip_silencer_mp");
    self MenuOption("mac11 2 attachments", 7, "suppressor x rapid fire", ::GivePlayerWeapon, "mac11_rf_silencer_mp");
    self MenuOption("mac11 2 attachments", 8, "rapid fire x red dot sight", ::GivePlayerWeapon, "mac11_elbit_rf_mp");
    self MenuOption("mac11 2 attachments", 9, "rapid fire x reflex sight", ::GivePlayerWeapon, "mac11_reflex_rf_mp");
    
    self MainMenu("ak74u", "submachine guns");
    self MenuOption("ak74u", 0, "extended mag", ::GivePlayerWeapon, "ak74u_extclip_mp");
    self MenuOption("ak74u", 1, "dual mag", ::GivePlayerWeapon, "ak74u_dualclip_mp");
    self MenuOption("ak74u", 2, "acog sight", ::GivePlayerWeapon, "ak74u_acog_mp");
    self MenuOption("ak74u", 3, "red dot sight", ::GivePlayerWeapon, "ak74u_elbit_mp");
    self MenuOption("ak74u", 4, "reflex sight", ::GivePlayerWeapon, "ak74u_reflex_mp");
    self MenuOption("ak74u", 5, "grip", ::GivePlayerWeapon, "ak74u_grip_mp");
    self MenuOption("ak74u", 6, "suppressor", ::GivePlayerWeapon, "ak74u_silencer_mp");
    self MenuOption("ak74u", 7, "grenade launcher", ::GivePlayerWeapon, "ak74u_gl_mp");
    self MenuOption("ak74u", 8, "rapid fire", ::GivePlayerWeapon, "ak74u_rf_mp");
    self MenuOption("ak74u", 9, "default", ::GivePlayerWeapon, "ak74u_mp");
    self MenuOption("ak74u", 10, "2 attachments", ::SubMenu, "ak74u 2 attachments");
    
    self MainMenu("ak74u 2 attachments", "ak74u");
    self MenuOption("ak74u 2 attachments", 0, "extended mag", ::SubMenu, "ak74u extended mag");
    self MenuOption("ak74u 2 attachments", 1, "dual mag", ::SubMenu, "ak74u dual mag");
    
    self MainMenu("ak74u extended mag", "ak74u 2 attachments");
    self MenuOption("ak74u extended mag", 0, "extended mag x acog sight", ::GivePlayerWeapon, "ak74u_acog_extclip_mp");
    self MenuOption("ak74u extended mag", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "ak74u_elbit_extclip_mp");
    self MenuOption("ak74u extended mag", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "ak74u_reflex_extclip_mp");
    self MenuOption("ak74u extended mag", 3, "extended mag x grip", ::GivePlayerWeapon, "ak74u_grip_extclip_mp");
    self MenuOption("ak74u extended mag", 4, "extended mag x suppressor", ::GivePlayerWeapon, "ak74u_extclip_silencer_mp");
    self MenuOption("ak74u extended mag", 5, "extended mag x grenade launcher", ::GivePlayerWeapon, "ak74u_gl_extclip_mp");
    
    self MainMenu("ak74u dual mag", "ak74u 2 attachments");
    self MenuOption("ak74u dual mag", 0, "dual mag x acog sight", ::GivePlayerWeapon, "ak74u_acog_dualclip_mp");
    self MenuOption("ak74u dual mag", 1, "dual mag x red dot sight", ::GivePlayerWeapon, "ak74u_elbit_dualclip_mp");
    self MenuOption("ak74u dual mag", 2, "dual mag x reflex sight", ::GivePlayerWeapon, "ak74u_reflex_dualclip_mp");
    self MenuOption("ak74u dual mag", 3, "dual mag x grip", ::GivePlayerWeapon, "ak74u_grip_dualclip_mp");
    self MenuOption("ak74u dual mag", 4, "dual mag x suppressor", ::GivePlayerWeapon, "ak74u_dualclip_silencer_mp");
    self MenuOption("ak74u dual mag", 5, "dual mag x grenade launcher", ::GivePlayerWeapon, "ak74u_gl_dualclip_mp");
    
    self MainMenu("uzi", "submachine guns");
    self MenuOption("uzi", 0, "extended mag", ::GivePlayerWeapon, "uzi_extclip_mp");
    self MenuOption("uzi", 1, "acog sight", ::GivePlayerWeapon, "uzi_acog_mp");
    self MenuOption("uzi", 2, "red dot sight", ::GivePlayerWeapon, "uzi_elbit_mp");
    self MenuOption("uzi", 3, "reflex sight", ::GivePlayerWeapon, "uzi_reflex_mp");
    self MenuOption("uzi", 4, "grip", ::GivePlayerWeapon, "uzi_grip_mp");
    self MenuOption("uzi", 5, "suppressor", ::GivePlayerWeapon, "uzi_silencer_mp");
    self MenuOption("uzi", 6, "rapid fire", ::GivePlayerWeapon, "uzi_rf_mp");
    self MenuOption("uzi", 7, "default", ::GivePlayerWeapon, "uzi_mp");
    self MenuOption("uzi", 8, "2 attachments", ::SubMenu, "uzi 2 attachments");
    
    self MainMenu("uzi 2 attachments", "uzi");
    self MenuOption("uzi 2 attachments", 0, "extended mag x red dot sight", ::GivePlayerWeapon, "uzi_elbit_extclip_mp");
    self MenuOption("uzi 2 attachments", 1, "extended mag x reflex sight", ::GivePlayerWeapon, "uzi_reflex_extclip_mp");
    self MenuOption("uzi 2 attachments", 2, "extended mag x grip", ::GivePlayerWeapon, "uzi_grip_extclip_mp");
    self MenuOption("uzi 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "uzi_extclip_silencer_mp");
    self MenuOption("uzi 2 attachments", 4, "suppressor x red dot sight", ::GivePlayerWeapon, "uzi_elbit_silencer_mp");
    self MenuOption("uzi 2 attachments", 5, "suppressor x reflex sight", ::GivePlayerWeapon, "uzi_reflex_silencer_mp");
    self MenuOption("uzi 2 attachments", 6, "suppressor x grip", ::GivePlayerWeapon, "uzi_grip_silencer_mp");
    self MenuOption("uzi 2 attachments", 7, "suppressor x rapid fire", ::GivePlayerWeapon, "uzi_rf_silencer_mp");
    self MenuOption("uzi 2 attachments", 8, "rapid fire x red dot sight", ::GivePlayerWeapon, "uzi_elbit_rf_mp");
    self MenuOption("uzi 2 attachments", 9, "rapid fire x reflex sight", ::GivePlayerWeapon, "uzi_reflex_rf_mp");
    
    self MainMenu("pm63", "submachine guns");
    self MenuOption("pm63", 0, "extended mag", ::GivePlayerWeapon, "pm63_extclip_mp");
    self MenuOption("pm63", 1, "grip", ::GivePlayerWeapon, "pm63_grip_mp");
    self MenuOption("pm63", 2, "dual wield", ::GivePlayerWeapon, "pm63dw_mp");
    self MenuOption("pm63", 3, "dual wield glitched", ::GivePlayerWeapon, "pm63lh_mp");
    self MenuOption("pm63", 4, "rapid fire", ::GivePlayerWeapon, "pm63_rf_mp");
    self MenuOption("pm63", 5, "default", ::GivePlayerWeapon, "pm63_mp");
    self MenuOption("pm63", 6, "2 attachments", ::SubMenu, "pm63 2 attachments");
    
    self MainMenu("pm63 2 attachments", "pm63");
    self MenuOption("pm63 2 attachments", 0, "grip x extended mag", ::GivePlayerWeapon, "pm63_grip_extclip_mp");
    self MenuOption("pm63 2 attachments", 1, "grip x rapid fire", ::GivePlayerWeapon, "pm63_grip_rf_mp");
    
    self MainMenu("mpl", "submachine guns");
    self MenuOption("mpl", 0, "dual mag", ::GivePlayerWeapon, "mpl_dualclip_mp");
    self MenuOption("mpl", 1, "acog sight", ::GivePlayerWeapon, "mpl_acog_mp");
    self MenuOption("mpl", 2, "red dot sight", ::GivePlayerWeapon, "mpl_elbit_mp");
    self MenuOption("mpl", 3, "reflex sight", ::GivePlayerWeapon, "mpl_reflex_mp");
    self MenuOption("mpl", 4, "grip", ::GivePlayerWeapon, "mpl_grip_mp");
    self MenuOption("mpl", 5, "suppressor", ::GivePlayerWeapon, "mpl_silencer_mp");
    self MenuOption("mpl", 6, "rapid fire", ::GivePlayerWeapon, "mpl_rf_mp");
    self MenuOption("mpl", 7, "default", ::GivePlayerWeapon, "mpl_mp");
    self MenuOption("mpl", 8, "2 attachments", ::SubMenu, "mpl 2 attachments");
    
    self MainMenu("mpl 2 attachments", "mpl");
    self MenuOption("mpl 2 attachments", 0, "dual mag x acog sight", ::GivePlayerWeapon, "mpl_acog_dualclip_mp");
    self MenuOption("mpl 2 attachments", 1, "dual mag x red dot sight", ::GivePlayerWeapon, "mpl_elbit_dualclip_mp");
    self MenuOption("mpl 2 attachments", 2, "dual mag x reflex sight", ::GivePlayerWeapon, "mpl_reflex_dualclip_mp");
    self MenuOption("mpl 2 attachments", 3, "dual mag x grip", ::GivePlayerWeapon, "mpl_grip_dualclip_mp");
    self MenuOption("mpl 2 attachments", 4, "dual mag x suppressor", ::GivePlayerWeapon, "mpl_dualclip_silencer_mp");
    self MenuOption("mpl 2 attachments", 5, "grip x acog sight", ::GivePlayerWeapon, "mpl_acog_grip_mp");
    self MenuOption("mpl 2 attachments", 6, "grip x red dot sight", ::GivePlayerWeapon, "mpl_elbit_grip_mp");
    self MenuOption("mpl 2 attachments", 7, "grip x reflex sight", ::GivePlayerWeapon, "mpl_reflex_grip_mp");
    self MenuOption("mpl 2 attachments", 8, "grip x suppressor", ::GivePlayerWeapon, "mpl_grip_silencer_mp");
    self MenuOption("mpl 2 attachments", 9, "grip x rapid fire", ::GivePlayerWeapon, "mpl_grip_rf_mp");
    
    self MainMenu("spectre", "submachine guns");
    self MenuOption("spectre", 0, "extended mag", ::GivePlayerWeapon, "spectre_extclip_mp");
    self MenuOption("spectre", 1, "acog sight", ::GivePlayerWeapon, "spectre_acog_mp");
    self MenuOption("spectre", 2, "red dot sight", ::GivePlayerWeapon, "spectre_elbit_mp");
    self MenuOption("spectre", 3, "reflex sight", ::GivePlayerWeapon, "spectre_reflex_mp");
    self MenuOption("spectre", 4, "grip", ::GivePlayerWeapon, "spectre_grip_mp");
    self MenuOption("spectre", 5, "suppressor", ::GivePlayerWeapon, "spectre_silencer_mp");
    self MenuOption("spectre", 6, "rapid fire", ::GivePlayerWeapon, "spectre_rf_mp");
    self MenuOption("spectre", 7, "default", ::GivePlayerWeapon, "spectre_mp");
    self MenuOption("spectre", 8, "2 attachments", ::SubMenu, "spectre 2 attachments");
    
    self MainMenu("spectre 2 attachments", "spectre");
    self MenuOption("spectre 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "spectre_acog_extclip_mp");
    self MenuOption("spectre 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "spectre_elbit_extclip_mp");
    self MenuOption("spectre 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "spectre_reflex_extclip_mp");
    self MenuOption("spectre 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "spectre_extclip_silencer_mp");
    self MenuOption("spectre 2 attachments", 4, "extended mag x grip", ::GivePlayerWeapon, "spectre_grip_extclip_mp");
    self MenuOption("spectre 2 attachments", 5, "suppressor x acog sight", ::GivePlayerWeapon, "spectre_acog_silencer_mp");
    self MenuOption("spectre 2 attachments", 6, "suppressor x red dot sight", ::GivePlayerWeapon, "spectre_elbit_silencer_mp");
    self MenuOption("spectre 2 attachments", 7, "suppressor x reflex sight", ::GivePlayerWeapon, "spectre_reflex_silencer_mp");
    self MenuOption("spectre 2 attachments", 8, "rapid fire x suppressor", ::GivePlayerWeapon, "spectre_rf_silencer_mp");
    self MenuOption("spectre 2 attachments", 9, "suppressor x grip", ::GivePlayerWeapon, "spectre_grip_silencer_mp");
    
    self MainMenu("kiparis", "submachine guns");
    self MenuOption("kiparis", 0, "extended mag", ::GivePlayerWeapon, "kiparis_extclip_mp");
    self MenuOption("kiparis", 1, "acog sight", ::GivePlayerWeapon, "kiparis_acog_mp");
    self MenuOption("kiparis", 2, "red dot sight", ::GivePlayerWeapon, "kiparis_elbit_mp");
    self MenuOption("kiparis", 3, "reflex sight", ::GivePlayerWeapon, "kiparis_reflex_mp");
    self MenuOption("kiparis", 4, "grip", ::GivePlayerWeapon, "kiparis_grip_mp");
    self MenuOption("kiparis", 5, "Dual Wield", ::GivePlayerWeapon, "kiparisdw_mp");
    self MenuOption("kiparis", 6, "Dual Wield Glitched", ::GivePlayerWeapon, "kiparislh_mp");
    self MenuOption("kiparis", 7, "suppressor", ::GivePlayerWeapon, "kiparis_silencer_mp");
    self MenuOption("kiparis", 8, "rapid fire", ::GivePlayerWeapon, "kiparis_rf_mp");
    self MenuOption("kiparis", 9, "default", ::GivePlayerWeapon, "kiparis_mp");
    self MenuOption("kiparis", 10, "2 attachments", ::SubMenu, "kiparis 2 attachments");
    
    self MainMenu("kiparis 2 attachments", "kiparis");
    self MenuOption("kiparis 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "kiparis_acog_extclip_mp");
    self MenuOption("kiparis 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "kiparis_elbit_extclip_mp");
    self MenuOption("kiparis 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "kiparis_reflex_extclip_mp");
    self MenuOption("kiparis 2 attachments", 3, "extended mag x suppressor", ::GivePlayerWeapon, "kiparis_extclip_silencer_mp");
    self MenuOption("kiparis 2 attachments", 4, "extended mag x grip", ::GivePlayerWeapon, "kiparis_grip_extclip_mp");
    self MenuOption("kiparis 2 attachments", 5, "suppressor x acog sight", ::GivePlayerWeapon, "kiparis_acog_silencer_mp");
    self MenuOption("kiparis 2 attachments", 6, "suppressor x red dot sight", ::GivePlayerWeapon, "kiparis_elbit_silencer_mp");
    self MenuOption("kiparis 2 attachments", 7, "suppressor x reflex sight", ::GivePlayerWeapon, "kiparis_reflex_silencer_mp");
    self MenuOption("kiparis 2 attachments", 8, "rapid fire x suppressor", ::GivePlayerWeapon, "kiparis_rf_silencer_mp");
    self MenuOption("kiparis 2 attachments", 9, "suppressor x grip", ::GivePlayerWeapon, "kiparis_grip_silencer_mp");
    
    self MainMenu("light machine guns", "weapons menu");
    self MenuOption("light machine guns", 0, "hk21", ::SubMenu, "hk21");
    self MenuOption("light machine guns", 1, "rpk", ::SubMenu, "rpk");
    self MenuOption("light machine guns", 2, "m60", ::SubMenu, "m60");
    self MenuOption("light machine guns", 3, "stoner63", ::SubMenu, "stoner63");
    
    self MainMenu("hk21", "light machine guns");
    self MenuOption("hk21", 0, "extended mag", ::GivePlayerWeapon, "hk21_extclip_mp");
    self MenuOption("hk21", 1, "acog sight", ::GivePlayerWeapon, "hk21_acog_mp");
    self MenuOption("hk21", 2, "red dot sight", ::GivePlayerWeapon, "hk21_elbit_mp");
    self MenuOption("hk21", 3, "reflex sight", ::GivePlayerWeapon, "hk21_reflex_mp");
    self MenuOption("hk21", 4, "infrared scope", ::GivePlayerWeapon, "hk21_ir_mp");
    self MenuOption("hk21", 5, "default", ::GivePlayerWeapon, "hk21_mp");
    self MenuOption("hk21", 6, "2 attachments", ::SubMenu, "hk21 2 attachments");
    
    self MainMenu("hk21 2 attachments", "hk21");
    self MenuOption("hk21 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "hk21_acog_extclip_mp");
    self MenuOption("hk21 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "hk21_elbit_extclip_mp");
    self MenuOption("hk21 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "hk21_reflex_extclip_mp");
    self MenuOption("hk21 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "hk21_ir_extclip_mp");
    
    self MainMenu("rpk", "light machine guns");
    self MenuOption("rpk", 0, "extended mag", ::GivePlayerWeapon, "rpk_extclip_mp");
    self MenuOption("rpk", 1, "dual mag", ::GivePlayerWeapon, "rpk_dualclip_mp");
    self MenuOption("rpk", 2, "acog sight", ::GivePlayerWeapon, "rpk_acog_mp");
    self MenuOption("rpk", 3, "red dot sight", ::GivePlayerWeapon, "rpk_elbit_mp");
    self MenuOption("rpk", 4, "reflex sight", ::GivePlayerWeapon, "rpk_reflex_mp");
    self MenuOption("rpk", 5, "infrared scope", ::GivePlayerWeapon, "rpk_ir_mp");
    self MenuOption("rpk", 6, "default", ::GivePlayerWeapon, "rpk_mp");
    self MenuOption("rpk", 7, "2 attachments", ::SubMenu, "rpk 2 attachments");
    
    self MainMenu("rpk 2 attachments", "rpk");
    self MenuOption("rpk 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "rpk_acog_extclip_mp");
    self MenuOption("rpk 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "rpk_elbit_extclip_mp");
    self MenuOption("rpk 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "rpk_reflex_extclip_mp");
    self MenuOption("rpk 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "rpk_ir_extclip_mp");
    self MenuOption("rpk 2 attachments", 4, "dual mag x acog sight", ::GivePlayerWeapon, "rpk_acog_dualclip_mp");
    self MenuOption("rpk 2 attachments", 5, "dual mag x red dot sight", ::GivePlayerWeapon, "rpk_elbit_dualclip_mp");
    self MenuOption("rpk 2 attachments", 6, "dual mag x reflex sight", ::GivePlayerWeapon, "rpk_reflex_dualclip_mp");
    self MenuOption("rpk 2 attachments", 7, "dual mag x infrared scope", ::GivePlayerWeapon, "rpk_ir_dualclip_mp");
    
    self MainMenu("m60", "light machine guns");
    self MenuOption("m60", 0, "extended mag", ::GivePlayerWeapon, "m60_extclip_mp");
    self MenuOption("m60", 1, "acog sight", ::GivePlayerWeapon, "m60_acog_mp");
    self MenuOption("m60", 2, "red dot sight", ::GivePlayerWeapon, "m60_elbit_mp");
    self MenuOption("m60", 3, "reflex sight", ::GivePlayerWeapon, "m60_reflex_mp");
    self MenuOption("m60", 4, "grip", ::GivePlayerWeapon, "m60_grip_mp");
    self MenuOption("m60", 5, "infrared scope", ::GivePlayerWeapon, "m60_ir_mp");
    self MenuOption("m60", 6, "default", ::GivePlayerWeapon, "m60_mp");
    self MenuOption("m60", 7, "2 attachments", ::SubMenu, "m60 2 attachments");
    
    self MainMenu("m60 2 attachments", "m60");
    self MenuOption("m60 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "m60_acog_extclip_mp");
    self MenuOption("m60 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "m60_elbit_extclip_mp");
    self MenuOption("m60 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "m60_reflex_extclip_mp");
    self MenuOption("m60 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "m60_ir_extclip_mp");
    self MenuOption("m60 2 attachments", 4, "grip x acog sight", ::GivePlayerWeapon, "m60_acog_grip_mp");
    self MenuOption("m60 2 attachments", 5, "grip x red dot sight", ::GivePlayerWeapon, "m60_elbit_grip_mp");
    self MenuOption("m60 2 attachments", 6, "grip x reflex sight", ::GivePlayerWeapon, "m60_reflex_grip_mp");
    self MenuOption("m60 2 attachments", 7, "grip x infrared scope", ::GivePlayerWeapon, "m60_ir_grip_mp");
    
    self MainMenu("stoner63", "light machine guns");
    self MenuOption("stoner63", 0, "extended mag", ::GivePlayerWeapon, "stoner63_extclip_mp");
    self MenuOption("stoner63", 1, "acog sight", ::GivePlayerWeapon, "stoner63_acog_mp");
    self MenuOption("stoner63", 2, "red dot sight", ::GivePlayerWeapon, "stoner63_elbit_mp");
    self MenuOption("stoner63", 3, "reflex sight", ::GivePlayerWeapon, "stoner63_reflex_mp");
    self MenuOption("stoner63", 4, "infrared scope", ::GivePlayerWeapon, "stoner63_ir_mp");
    self MenuOption("stoner63", 5, "default", ::GivePlayerWeapon, "stoner63_mp");
    self MenuOption("stoner63", 6, "2 attachments", ::SubMenu, "stoner63 2 attachments");
    
    self MainMenu("stoner63 2 attachments", "stoner63");
    self MenuOption("stoner63 2 attachments", 0, "extended mag x acog sight", ::GivePlayerWeapon, "stoner63_acog_extclip_mp");
    self MenuOption("stoner63 2 attachments", 1, "extended mag x red dot sight", ::GivePlayerWeapon, "stoner63_elbit_extclip_mp");
    self MenuOption("stoner63 2 attachments", 2, "extended mag x reflex sight", ::GivePlayerWeapon, "stoner63_reflex_extclip_mp");
    self MenuOption("stoner63 2 attachments", 3, "extended mag x infrared scope", ::GivePlayerWeapon, "stoner63_ir_extclip_mp");

    
    self MainMenu("pistols", "weapons menu");
    self MenuOption("pistols", 0, "asp", ::SubMenu, "asp");
    self MenuOption("pistols", 1, "m1911", ::SubMenu, "m1911");
    self MenuOption("pistols", 2, "makarov", ::SubMenu, "makarov");
    self MenuOption("pistols", 3, "python", ::SubMenu, "python");
    self MenuOption("pistols", 4, "cz75", ::SubMenu, "cz75");
    
    self MainMenu("asp", "pistols");
    self MenuOption("asp", 0, "dual wield", ::GivePlayerWeapon, "aspdw_mp");
    self MenuOption("asp", 1, "dual wield glitched", ::GivePlayerWeapon, "asplh_mp");
    self MenuOption("asp", 2, "default", ::GivePlayerWeapon, "asp_mp");

    self MainMenu("m1911", "pistols");
    self MenuOption("m1911", 0, "upgraded iron sight", ::GivePlayerWeapon, "m1911_upgradesight_mp");
    self MenuOption("m1911", 1, "extended mag", ::GivePlayerWeapon, "m1911_extclip_mp");
    self MenuOption("m1911", 2, "dual wield", ::GivePlayerWeapon, "m1911dw_mp");
    self MenuOption("m1911", 3, "dual wield glitched", ::GivePlayerWeapon, "m1911lh_mp");
    self MenuOption("m1911", 4, "suppressor", ::GivePlayerWeapon, "m1911_silencer_mp");
    self MenuOption("m1911", 5, "default", ::GivePlayerWeapon, "m1911_mp");
    
    self MainMenu("makarov", "pistols");
    self MenuOption("makarov", 0, "upgraded iron sight", ::GivePlayerWeapon, "makarov_upgradesight_mp");
    self MenuOption("makarov", 1, "extended mag", ::GivePlayerWeapon, "makarov_extclip_mp");
    self MenuOption("makarov", 2, "dual wield", ::GivePlayerWeapon, "makarovdw_mp");
    self MenuOption("makarov", 3, "dual wield glitched", ::GivePlayerWeapon, "makarovlh_mp");
    self MenuOption("makarov", 4, "suppressor", ::GivePlayerWeapon, "makarov_silencer_mp");
    self MenuOption("makarov", 5, "default", ::GivePlayerWeapon, "makarov_mp");
    
    self MainMenu("python", "pistols");
    self MenuOption("python", 0, "acog sight", ::GivePlayerWeapon, "python_acog_mp");
    self MenuOption("python", 1, "snub nose", ::GivePlayerWeapon, "python_snub_mp");
    self MenuOption("python", 2, "speed reloader", ::GivePlayerWeapon, "python_speed_mp");
    self MenuOption("python", 3, "dual wield", ::GivePlayerWeapon, "pythondw_mp");
    self MenuOption("python", 4, "dual wield glitched", ::GivePlayerWeapon, "pythonlh_mp");
    self MenuOption("python", 5, "default", ::GivePlayerWeapon, "python_mp");
    
    self MainMenu("cz75", "pistols");
    self MenuOption("cz75", 0, "upgraded iron sight", ::GivePlayerWeapon, "cz75_upgradesight_mp");
    self MenuOption("cz75", 1, "extended mag", ::GivePlayerWeapon, "cz75_extclip_mp");
    self MenuOption("cz75", 2, "dual wield", ::GivePlayerWeapon, "cz75dw_mp");
    self MenuOption("cz75", 3, "dual wield glitched", ::GivePlayerWeapon, "cz75lh_mp");
    self MenuOption("cz75", 4, "suppressor", ::GivePlayerWeapon, "cz75_silencer_mp");
    self MenuOption("cz75", 5, "full auto upgraded", ::GivePlayerWeapon, "cz75_auto_mp");
    self MenuOption("cz75", 6, "default", ::GivePlayerWeapon, "cz75_mp");
    
    self MainMenu("launchers", "weapons menu");
    self MenuOption("launchers", 0, "m72 law", ::GivePlayerWeapon, "m72_law_mp");
    self MenuOption("launchers", 1, "rpg", ::GivePlayerWeapon, "rpg_mp");
    self MenuOption("launchers", 2, "strela-3", ::GivePlayerWeapon, "strela_mp");
    self MenuOption("launchers", 3, "china lake", ::GivePlayerWeapon, "china_lake_mp");
    
    self MainMenu("specials", "weapons menu");
    self MenuOption("specials", 0, "ballistic knife", ::GivePlayerWeapon, "knife_ballistic_mp");
    self MenuOption("specials", 1, "crossbow", ::GivePlayerWeapon, "crossbow_explosive_mp");
    
    self MainMenu("super specials", "weapons menu");
    self MenuOption("super specials", 0, "default weapon", ::GivePlayerWeapon, "defaultweapon_mp");
    self MenuOption("super specials", 1, "syrette", ::GivePlayerWeapon, "syrette_mp");
    self MenuOption("super specials", 2, "carepackage", ::GivePlayerWeapon, "supplydrop_mp");
    self MenuOption("super specials", 3, "minigun", ::GivePlayerWeapon, "minigun_mp");
    self MenuOption("super specials", 4, "claymore", ::GivePlayerWeapon, "claymore_mp");
    self MenuOption("super specials", 5, "scrambler", ::GivePlayerWeapon, "scrambler_mp");
    self MenuOption("super specials", 6, "jammer", ::GivePlayerWeapon, "scavenger_item_mp");
    self MenuOption("super specials", 7, "tac", ::GivePlayerWeapon, "tactical_insertion_mp");
    self MenuOption("super specials", 8, "sensor", ::GivePlayerWeapon, "acoustic_sensor_mp");
    self MenuOption("super specials", 9, "camera", ::GivePlayerWeapon, "camera_spike_mp");
    self MenuOption("super specials", 10, "bomb", ::GivePlayerWeapon, "briefcase_bomb_mp");
    self MenuOption("super specials", 11, "grim reaper", ::GivePlayerWeapon, "m202_flash_mp");
    self MenuOption("super specials", 12, "valkyrie rocket", ::GivePlayerWeapon, "m220_tow_mp");
    self MenuOption("super specials", 13, "rc-xd remote", ::GivePlayerWeapon, "rcbomb_mp");
    self MenuOption("super specials", 14, "what the fuck is this", ::GivePlayerWeapon, "dog_bite_mp");
    
    self MainMenu("killstreaks menu", "redemption");
    self MenuOption("killstreaks menu", 0, "spy plane", ::doKillstreak, "radar_mp");
    self MenuOption("killstreaks menu", 1, "rc-xd", ::doKillstreak, "rcbomb_mp");
    self MenuOption("killstreaks menu", 2, "counter-spy plane", ::doKillstreak, "counteruav_mp");
    self MenuOption("killstreaks menu", 3, "sam turret", ::doKillstreak, "auto_tow_mp");
    self MenuOption("killstreaks menu", 4, "care package", ::doKillstreak, "supply_drop_mp");
    self MenuOption("killstreaks menu", 5, "napalm strike", ::doKillstreak, "napalm_mp");
    self MenuOption("killstreaks menu", 6, "sentry gun", ::doKillstreak, "autoturret_mp");
    self MenuOption("killstreaks menu", 7, "mortar team", ::doKillstreak, "mortar_mp");
    self MenuOption("killstreaks menu", 8, "attack helicopter", ::doKillstreak, "helicopter_comlink_mp");
    self MenuOption("killstreaks menu", 9, "valkyrie rockets", ::doKillstreak, "m220_tow_mp");
    self MenuOption("killstreaks menu", 10, "rolling thunder", ::doKillstreak, "airstrike_mp");
    self MenuOption("killstreaks menu", 11, "chopper gunner", ::doKillstreak, "helicopter_gunner_mp");
    self MenuOption("killstreaks menu", 12, "attack dogs", ::doKillstreak, "dogs_mp");
    self MenuOption("killstreaks menu", 13, "gunship", ::doKillstreak, "helicopter_player_firstperson_mp");
    self MenuOption("killstreaks menu", 14, "grim reaper", ::doKillstreak, "m202_flash_mp");
    
    self MainMenu("perks menu", "redemption");
    self MenuOption("perks menu", 0, "unset all perks", ::noMorePerk);
	self MenuOption("perks menu", 1, "set all perks", ::SetAllPerks); 
    self MenuOption("perks menu", 2, "lightweight", ::GivePerk, 1);
    self MenuOption("perks menu", 3, "scavenger", ::GivePerk, 2);
    self MenuOption("perks menu", 4, "ghost", ::GivePerk, 3);
    self MenuOption("perks menu", 5, "flak jacket", ::GivePerk, 4);
    self MenuOption("perks menu", 6, "hardline", ::GivePerk, 5);
    self MenuOption("perks menu", 7, "steady aim", ::GivePerk, 6);
    self MenuOption("perks menu", 8, "scout", ::GivePerk, 7);
    self MenuOption("perks menu", 9, "sleight of hand", ::GivePerk, 8);
    self MenuOption("perks menu", 10, "war lord", ::GivePerk, 9);
    self MenuOption("perks menu", 11, "marathon", ::GivePerk, 10);
    self MenuOption("perks menu", 12, "ninja", ::GivePerk, 11);
    self MenuOption("perks menu", 13, "hacker", ::GivePerk, 12);
    self MenuOption("perks menu", 14, "tactical mask", ::GivePerk, 13);
    self MenuOption("perks menu", 15, "last chance", ::GivePerk, 14);
    
    self MainMenu("bots menu", "redemption");
    self MenuOption("bots menu", 0, "spawn enemy bot", ::spawnEnemyBot);
    self MenuOption("bots menu", 1, "spawn friendly bot", ::spawnFriendlyBot); 
    self MenuOption("bots menu", 2, "freeze all bots", ::freezeAllBots);
    self MenuOption("bots menu", 3, "kick all bots", ::kickAllBots);
    self MenuOption("bots menu", 4, "teleport bots to crosshair", ::TeleportAllBots);
    self MenuOption("bots menu", 5, "save bot location", ::BotSpawns);
    self MenuOption("bots menu", 6, "make bot look at you", ::MakeAllBotsLookAtYou);
    self MenuOption("bots menu", 7, "make bot crouch", ::MakeAllBotsCrouch);
    self MenuOption("bots menu", 8, "make bot prone", ::MakeAllBotsProne);
    self MenuOption("bots menu", 9, "move pixel north", ::MoveNorthpixel);
    self MenuOption("bots menu", 10, "move pixel south", ::MoveSouthpixel); 
    self MenuOption("bots menu", 11, "move pixel east", ::MoveEastpixel); 
    self MenuOption("bots menu", 12, "move pixel west", ::MoveWestpixel);
    self MenuOption("bots menu", 13, "custom bot spawns", ::SubMenu, "custom bot spawns");
    
    if( getdvar("mapname") == "mp_array")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (1186.37, 853.411, 342.755));
        self MenuOption("custom bot spawns", 1, "echo setup spot", ::tpBotHere, (2770.56, 411.727, 364.125));
        self MenuOption("custom bot spawns", 2, "lcsihz setup spot", ::tpBotHere, (-1059.27, 125.155, 497.808));
    }
    else if( getdvar("mapname") == "mp_cracked")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (-538.514, -146.074, -139.678));
        self MenuOption("custom bot spawns", 1, "roach lunge setup spot", ::tpBotHere, (692.768, -1309.57, -120.572));
    }
    else if( getdvar("mapname") == "mp_crisis")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (-1560.2, 935.719, 194.047));
        self MenuOption("custom bot spawns", 1, "random setup spot", ::tpBotHere, (-549.218, 2656.4, 118.206));
    }
    else if( getdvar("mapname") == "mp_firingrange")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (50.9996, 1858.63, -47.5919));
        self MenuOption("custom bot spawns", 1, "main stairs setup spot", ::tpBotHere, (945.049, 1580.52, 8.74408));
        self MenuOption("custom bot spawns", 2, "b sandbags setup spot", ::tpBotHere, (-69.7541, 339.593, -28.875));
        self MenuOption("custom bot spawns", 3, "stairs setup spot", ::tpBotHere, (-106.567, 1474.81, 30.125));
        self MenuOption("custom bot spawns", 4, "knife lunge setup spot", ::tpBotHere, (-1335.97, 805.414, -57.875));
    }
    else if( getdvar("mapname") == "mp_duga")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "roach lunge setup spot", ::tpBotHere, (-772.487, -4373.51, 0.123261));
    }
    else if( getdvar("mapname") == "mp_cairo")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "bounce setup spot", ::tpBotHere, (-619.145, -141.839, 6.96646));
        self MenuOption("custom bot spawns", 1, "mid map setup spot", ::tpBotHere, (-91.7517, -171.16, 46.7741));
        self MenuOption("custom bot spawns", 2, "geen double lunge spot", ::tpBotHere, (343.868, 295.851, 60.4786));
    }
    else if( getdvar("mapname") == "mp_havoc")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (462.427, -1234.03, 296.125));
        self MenuOption("custom bot spawns", 1, "under bridge spot", ::tpBotHere, (1846.34, 129.858, 82.4645));
        self MenuOption("custom bot spawns", 2, " roach lunge spot", ::tpBotHere, (2695, -463.16, 284.125));
        self MenuOption("custom bot spawns", 3, " spawn setup spot", ::tpBotHere, (1419.3, -2676.98, 119.731));
        self MenuOption("custom bot spawns", 4, " temple setup spot", ::tpBotHere, (1278.54, 1688.5, 286.125));
    }
    else if( getdvar("mapname") == "mp_cosmodrome")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "og sui setup spot", ::tpBotHere, (1008.86, 1456.87, -123.853));
        self MenuOption("custom bot spawns", 1, "sui to bomb spot", ::tpBotHere, (1639.62, 374.21, -343.875));
        self MenuOption("custom bot spawns", 2, "sui setup spot", ::tpBotHere, (1951.11, 639.854, -183.875));
        self MenuOption("custom bot spawns", 3, "ladder setup spot", ::tpBotHere, (-880.869, 1780.26, -168.584));
    }
    else if( getdvar("mapname") == "mp_nuked")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "a bomb setup spot", ::tpBotHere, (784.679, 510.059, -56.875));
        self MenuOption("custom bot spawns", 1, "b bomb lunge spot", ::tpBotHere, (258.297, -515.447, -60.6755));
        self MenuOption("custom bot spawns", 2, "mid car setup spot", ::tpBotHere, (-60.8739, 814.493, -9.66869));
        self MenuOption("custom bot spawns", 3, "yellow spawn spot", ::tpBotHere, (1890.66, 108.606, -63.875));
        self MenuOption("custom bot spawns", 4, "blue spawn spot", ::tpBotHere, (-1863.26, 139.126, -63.875));
        self MenuOption("custom bot spawns", 5, "blue ladder spot", ::tpBotHere, (-492.626, 208.107, -10.875));
    }
    else if( getdvar("mapname") == "mp_radiation")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (749.971, 78.6141, 290.805));
        self MenuOption("custom bot spawns", 1, "b bomb ladder spot", ::tpBotHere, (1264.96, 214.128, 128.125));
        self MenuOption("custom bot spawns", 2, "b bomb setup spot", ::tpBotHere, (1484.31, -473.093, 249.125));
        self MenuOption("custom bot spawns", 3, "roach setup spot", ::tpBotHere, (443.938, -1770.66, -15.875));
        self MenuOption("custom bot spawns", 4, "underground setup spot", ::tpBotHere, (51.8617, -797.425, -47.875));
    }
    else if( getdvar("mapname") == "mp_mountain")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "main setup spot", ::tpBotHere, (2159.29, 1085.59, 323.96));
        self MenuOption("custom bot spawns", 1, "ski lift spot", ::tpBotHere, (1658.83, 345.034, 165.848));
        self MenuOption("custom bot spawns", 2, "lunge/ low sui setup", ::tpBotHere, (2405.75, -2599.79, 887.238));
        self MenuOption("custom bot spawns", 3, "spawn sui spot", ::tpBotHere, (3728.43, -2360.01, 433.625));
        self MenuOption("custom bot spawns", 4, "roach lunge setup spot", ::tpBotHere, (4096.55, -705.586, 401.601));
    }
    else if( getdvar("mapname") == "mp_villa")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "window setup spot", ::tpBotHere, (2764.76, 2531.23, 309.237));
        self MenuOption("custom bot spawns", 1, "mid fountain spot", ::tpBotHere, (4337.44, 1336.87, 356.125));
        self MenuOption("custom bot spawns", 2, "lcsihz window setup spot", ::tpBotHere, (1984.99, 62.1553, 244.125));
    }
    else if( getdvar("mapname") == "mp_russianbase")
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "default setup spot", ::tpBotHere, (-1108.77, 751.853, 101.555));
        self MenuOption("custom bot spawns", 1, "OG default setup spot", ::tpBotHere, (-787.641, 432.359, 44.8161));
        self MenuOption("custom bot spawns", 2, "nova delayed lunge spot", ::tpBotHere, (748.298, -583.402, 203.125));
        self MenuOption("custom bot spawns", 3, "silo setup spot", ::tpBotHere, (1647.95, -269.705, 237.125));
        self MenuOption("custom bot spawns", 4, "back drop setup spot", ::tpBotHere, (-538.929, 187.855, -11.3481));
        self MenuOption("custom bot spawns", 5, "nova ladder setup spot", ::tpBotHere, (-1359.54, 1548.38, 124.769));
    }
    else
    {
        self MainMenu("custom bot spawns", "bots menu");
        self MenuOption("custom bot spawns", 0, "IM LAZY AS FUCK", ::Test);
    }
    
    self MainMenu("account menu", "redemption");
    self MenuOption("account menu", 0, "level 50", ::doLevel50);
    self MenuOption("account menu", 1, "prestige 15", ::doPrestige15);
    self MenuOption("account menu", 2, "pro perks", ::doUnlockProPerks);
    self MenuOption("account menu", 3, "unlock all", ::giveUnlockAll);

    self MainMenu("admin menu", "redemption"); 
    self MenuOption("admin menu", 0, "change gravity", ::SubMenu, "gravity menu");
    self MenuOption("admin menu", 1, "slow motion", ::SubMenu, "slow mo menu");
    self MenuOption("admin menu", 2, "auto prone", ::autoProne);
    self MenuOption("admin menu", 3, "ground spins", ::prone);
    self MenuOption("admin menu", 4, "mantle spins", ::mantleSpin);
    self MenuOption("admin menu", 5, "ladder mod", ::SubMenu, "ladder menu");
    self MenuOption("admin menu", 6, "ladder spins", ::laddermovement);
    self MenuOption("admin menu", 7, "soft land", ::softLand);
    self MenuOption("admin menu", 8, "jump fatigue", ::jumpfatigue);
    self MenuOption("admin menu", 9, "remove death barrier", ::deathb);
    self MenuOption("admin menu", 10, "pickup radius", ::SubMenu, "pickup radius menu");
    self MenuOption("admin menu", 11, "nade pickup radius", ::SubMenu, "grenade radius menu"); 
    self MenuOption("admin menu", 12, "change melee length", ::meleeRange);
    self MenuOption("admin menu", 13, "change killcam length", ::SubMenu, "killcam menu");
    self MenuOption("admin menu", 14, "toggle playercard", ::Playercard);
    self MenuOption("admin menu", 15, "pause timer", ::toggleTimer);
    self MenuOption("admin menu", 16, "fast restart", ::fastrestart);
    
    
    self MainMenu("killcam menu", "admin menu");
    self MenuOption("killcam menu", 0, "default killcam", ::RoachLongKillcams, 5.5);
    self MenuOption("killcam menu", 1, "6 second killcam", ::RoachLongKillcams, 6);
    self MenuOption("killcam menu", 2, "7 second killcam", ::RoachLongKillcams, 7);
    self MenuOption("killcam menu", 3, "8 second killcam", ::RoachLongKillcams, 8);
    self MenuOption("killcam menu", 4, "9 second killcam", ::RoachLongKillcams, 9);
    self MenuOption("killcam menu", 5, "10 second killcam", ::RoachLongKillcams, 10);
    self MenuOption("killcam menu", 6, "11 second killcam", ::RoachLongKillcams, 11);
    self MenuOption("killcam menu", 7, "12 second killcam", ::RoachLongKillcams, 12);
    self MenuOption("killcam menu", 8, "13 second killcam", ::RoachLongKillcams, 13);
    self MenuOption("killcam menu", 9, "14 second killcam", ::RoachLongKillcams, 14);
    self MenuOption("killcam menu", 10, "15 second killcam", ::RoachLongKillcams, 15);
    
    self MainMenu("gravity menu", "admin menu");
    self MenuOption("gravity menu", 0, "gravity 800", ::setGravity, 800);
    self MenuOption("gravity menu", 1, "gravity 750", ::setGravity, 750);
    self MenuOption("gravity menu", 2, "gravity 700", ::setGravity, 700);
    self MenuOption("gravity menu", 3, "gravity 650", ::setGravity, 650);
    self MenuOption("gravity menu", 4, "gravity 600", ::setGravity, 600);
    self MenuOption("gravity menu", 5, "gravity 550", ::setGravity, 550);
    self MenuOption("gravity menu", 6, "gravity 500", ::setGravity, 500);
    self MenuOption("gravity menu", 7, "gravity 450", ::setGravity, 450);
    self MenuOption("gravity menu", 8, "gravity 400", ::setGravity, 400);
    self MenuOption("gravity menu", 9, "gravity 350", ::setGravity, 350);
    self MenuOption("gravity menu", 10, "gravity 300", ::setGravity, 300);
    self MenuOption("gravity menu", 11, "gravity 250", ::setGravity, 250);
    self MenuOption("gravity menu", 12, "gravity 200", ::setGravity, 200);
    self MenuOption("gravity menu", 13, "gravity 150", ::setGravity, 150);
    self MenuOption("gravity menu", 14, "gravity 100", ::setGravity, 100);
    
    self MainMenu("slow mo menu", "admin menu");
    self MenuOption("slow mo menu", 0, "slow mo 1.00", ::setSlowMoKC, 1);
    self MenuOption("slow mo menu", 1, "slow mo 0.75", ::setSlowMo, 0.75);
    self MenuOption("slow mo menu", 2, "slow mo 0.50", ::setSlowMo, 0.50);
    self MenuOption("slow mo menu", 3, "slow mo 0.25", ::setSlowMo, 0.25);
    self MenuOption("slow mo menu", 4, "slow mo 0.10", ::setSlowMo, 0.10);
    self MenuOption("slow mo menu", 5, "slow mo 0.75 (in killcam)", ::setSlowMoKC, 0.75);
    self MenuOption("slow mo menu", 6, "slow mo 0.50 (in killcam)", ::setSlowMoKC, 0.50);
    self MenuOption("slow mo menu", 7, "slow mo 0.25 (in killcam)", ::setSlowMoKC, 0.25);
    self MenuOption("slow mo menu", 8, "slow mo 0.10 (in killcam)", ::setSlowMoKC, 0.10);
    
    self MainMenu("ladder menu", "admin menu");
    self MenuOption("ladder menu", 0, "ladder knockback 128 (default)", ::LadderYeet, 128);
    self MenuOption("ladder menu", 1, "ladder knockback 10", ::LadderYeet, 10);
    self MenuOption("ladder menu", 2, "ladder knockback 20", ::LadderYeet, 20);
    self MenuOption("ladder menu", 3, "ladder knockback 40", ::LadderYeet, 40);
    self MenuOption("ladder menu", 4, "ladder knockback 80", ::LadderYeet, 80);
    self MenuOption("ladder menu", 5, "ladder knockback 100", ::LadderYeet, 100);
    self MenuOption("ladder menu", 6, "ladder knockback 200", ::LadderYeet, 200);
    self MenuOption("ladder menu", 7, "ladder knockback 400", ::LadderYeet, 400);
    self MenuOption("ladder menu", 8, "ladder knockback 800", ::LadderYeet, 800);
    self MenuOption("ladder menu", 9, "ladder knockback 999", ::LadderYeet, 999);
    
    self MainMenu("pickup radius menu", "admin menu");
    self MenuOption("pickup radius menu", 0, "pickup radius 0", ::expickup, 0);
    self MenuOption("pickup radius menu", 1, "pickup radius 100 (default)", ::expickup, 100);
    self MenuOption("pickup radius menu", 2, "pickup radius 250", ::expickup, 250);
    self MenuOption("pickup radius menu", 3, "pickup radius 500", ::expickup, 500);
    self MenuOption("pickup radius menu", 4, "pickup radius 1000", ::expickup, 1000);
    self MenuOption("pickup radius menu", 5, "pickup radius 2000", ::expickup, 2000);
    self MenuOption("pickup radius menu", 6, "pickup radius 3000", ::expickup, 3000);
    self MenuOption("pickup radius menu", 7, "pickup radius 4000", ::expickup, 4000);
    self MenuOption("pickup radius menu", 8, "pickup radius 5000", ::expickup, 5000);
    self MenuOption("pickup radius menu", 9, "pickup radius 6000", ::expickup, 6000);
    self MenuOption("pickup radius menu", 10, "pickup radius 7000", ::expickup, 7000);
    self MenuOption("pickup radius menu", 11, "pickup radius 8000", ::expickup, 8000);
    
    self MainMenu("grenade radius menu", "admin menu");
    self MenuOption("grenade radius menu", 0, "pickup radius 0", ::grenaderadius, 0);
    self MenuOption("grenade radius menu", 1, "pickup radius 100 (default)", ::grenaderadius, 100);
    self MenuOption("grenade radius menu", 2, "pickup radius 250", ::grenaderadius, 250);
    self MenuOption("grenade radius menu", 3, "pickup radius 500", ::grenaderadius, 500);
    self MenuOption("grenade radius menu", 4, "pickup radius 1000", ::grenaderadius, 1000);
    self MenuOption("grenade radius menu", 5, "pickup radius 2000", ::grenaderadius, 2000);
    self MenuOption("grenade radius menu", 6, "pickup radius 3000", ::grenaderadius, 3000);
    self MenuOption("grenade radius menu", 7, "pickup radius 4000", ::grenaderadius, 4000);
    self MenuOption("grenade radius menu", 8, "pickup radius 5000", ::grenaderadius, 5000);
    self MenuOption("grenade radius menu", 9, "pickup radius 6000", ::grenaderadius, 6000);
    self MenuOption("grenade radius menu", 10, "pickup radius 7000", ::grenaderadius, 7000);
    self MenuOption("grenade radius menu", 11, "pickup radius 8000", ::grenaderadius, 8000);

    self MainMenu("dev menu", "redemption");
    self MenuOption("dev menu", 0, "get map name", ::MapName);
    self MenuOption("dev menu", 1, "get corods", ::Coords); 
    self MenuOption("dev menu", 2, "toggle spawn text", ::ToggleSpawnText); 
    self MenuOption("dev menu", 3, "give weapon name", ::WhatGun);
    
    self MainMenu("menu colors", "dev menu");
    self MenuOption("menu colors", 0, "red menu", ::changeMenuColors, (1,0,0));

    self MainMenu("clients menu", "redemption");
    for (p = 0; p < level.players.size; p++) {
        player = level.players[p];
        self MenuOption("clients menu", p, "[" + player.MyAccess + "^7] " + player.name + "", ::SubMenu, "client function");
    }
    self thread MonitorPlayers();
    
    self MainMenu("client function", "clients menu");
    self MenuOption("client function", 0, "verify player", ::Verify);
    self MenuOption("client function", 1, "unverified player", ::doUnverif);
    self MenuOption("client function", 2, "freeze player", ::freezeClient);
    self MenuOption("client function", 3, "teleport player to crosshair", ::teleportClient);
    self MenuOption("client function", 4, "save location", ::ClientSpawn);
    self MenuOption("client function", 5, "player pixel north", ::clientNorthpixel);
    self MenuOption("client function", 6, "player pixel south", ::clientSouthpixel); 
    self MenuOption("client function", 7, "player pixel east", ::clientEastpixel); 
    self MenuOption("client function", 8, "player pixel west", ::clientWestpixel);
    self MenuOption("client function", 9, "crouch player", ::crouchClient);
    self MenuOption("client function", 10, "prone player", ::proneClient);
    self MenuOption("client function", 11, "stand player", ::standClient);
    self MenuOption("client function", 12, "revive player", ::reviveClient);
    self MenuOption("client function", 13, "kill player", ::killClient);
    self MenuOption("client function", 14, "kick player", ::kickClient);
}

MonitorPlayers()
{
    self endon("disconnect");
    for(;;)
    {
        for(p = 0;p < level.players.size;p++)
        {
            player = level.players[p];
            self.Menu.System["MenuTexte"]["clients options"][p] = "[" + player.MyAccess + "^7] " + player.name;
            self.Menu.System["MenuFunction"]["clients options"][p] = ::SubMenu;
            self.Menu.System["MenuInput"]["clients options"][p] = "client function";
            wait .01;
        }
        wait .005;
    }
}

MainMenu(Menu, Return)
{
    self.Menu.System["GetMenu"] = Menu;
    self.Menu.System["MenuCount"] = 0;
    self.Menu.System["MenuPrevious"][Menu] = Return;
}

MenuOption(Menu, Index, Texte, Function, Input)
{
    self.Menu.System["MenuTexte"][Menu][Index] = Texte;
    self.Menu.System["MenuFunction"][Menu][Index] = Function;
    self.Menu.System["MenuInput"][Menu][Index] = Input;
}
SubMenu(input)
{
    self.Menu.System["MenuCurser"] = 0;
    self.Menu.System["Texte"] fadeovertime(0.05);
    self.Menu.System["Texte"].alpha = 0;
    self.Menu.System["Texte"] destroy();
    self.Menu.System["Credits"] destroy();
    self.Menu.System["Title"] destroy();
    self thread LoadMenu(input);
    if(self.Menu.System["MenuRoot"]=="client function")
    {
    self.Menu.System["Title"] destroy();
    player = level.players[self.Menu.System["ClientIndex"]];
    self.Menu.System["Title"] = self createFontString("default", 2.0);
    self.Menu.System["Title"] setPoint("LEFT", "TOP", 205, 10);
    self.Menu.System["Title"] setText("[" + player.MyAccess + "^7] " + player.name);
    self.Menu.System["Title"].sort = 3;
    self.Menu.System["Title"].alpha = 1;
    }
}
LoadMenu(menu)
{
    self.Menu.System["Credits"] = self createFontString("objective", 1.1);
    self.Menu.System["Credits"] setPoint("LEFT", "TOP", 205, 435);
    self.Menu.System["Credits"] setText("made by roach");
    self.Menu.System["Credits"].sort = 4;
    self.Menu.System["Credits"].alpha = 1;
    self.Menu.System["MenuCurser"] = 0;
    self.Menu.System["MenuRoot"] = menu;
    self.Menu.System["Title"] = self createFontString("default", 2.0);
    self.Menu.System["Title"] setPoint("LEFT", "TOP", 205, 10);
    self.Menu.System["Title"] setText(menu);
    self.Menu.System["Title"].sort = 3;
    self.Menu.System["Title"].alpha = 1;
    string = "";
    for(i=0;i<self.Menu.System["MenuTexte"][Menu].size;i++) string += self.Menu.System["MenuTexte"][Menu][i] + "\n";
    self.Menu.System["Texte"] = self createFontString("objective", 1.3);
    self.Menu.System["Texte"] setPoint("LEFT", "TOP", 205, 35);
    self.Menu.System["Texte"] setText(string);
    self.Menu.System["Texte"].sort = 3;
    self.Menu.System["Texte"].alpha = 1;
    self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
    
}
SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = colour;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud setPoint(align, relative, x, y);
    return hud;
}

MenuDeath()
{
    self waittill("death");
    self.Menu.Material["CustShader"] destroy();
    self.Menu.Material["Background"] destroy();
    self.Menu.Material["Scrollbar"] destroy();
    self MenuClosing();
}
InitialisingMenu()
{
    if(!isDefined(self.jimbosMode))
    {
            // SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
        self.Menu.Material["Background"] = self SetMaterial("LEFT", "TOP", 200, 0, 270, 1000, (1,1,1), "black", 0, 0);
        self.Menu.Material["Scrollbar"] = self SetMaterial("LEFT", "TOP", 200, 35, 270, 15, self.menuColor, "white", 2, 0);
        self.Menu.Material["CustShader"] = self SetMaterial("LEFT", "TOP", 200, -5, 270, 65, (1,1,1), "black", 1, 0);
    }
    
    
    
}

MenuOpening()
{
    self.MenuOpen = true;
    self.Menu.Material["CustShader"] elemFade(.5, 1);
    self.Menu.Material["Background"] elemFade(.5, 0.76);
    self.Menu.Material["Scrollbar"] elemFade(.5, 1);
}

MenuClosing()
{    
    self.Menu.Material["CustShader"] elemFade(.5, 0);
    self.Menu.Material["Background"] elemFade(.5, 0);
    self.Menu.Material["Scrollbar"] elemFade(.5, 0);
    self.Menu.System["Title"] destroy();
    self.Menu.System["Texte"] destroy();
    self.Menu.System["Credits"] destroy();
    wait 0.05;
    self.MenuOpen = false;
}   

elemMoveY(time, input)
{
    self moveOverTime(time);
    self.y = input;
}

elemMoveX(time, input)
{
    self moveOverTime(time);
    self.x = input;
}

elemFade(time, alpha)
{
    self fadeOverTime(time);
    self.alpha = alpha;
}

// client

UnverifMe()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't un-verify the host!");
    }
    else
    {
        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        self iPrintln( player.name + " is ^1Unverfied" );
        
    }    
}

doUnverif()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't un-verify the host!");
    }
    else
    {
        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        self iPrintln( player.name + " is ^1Unverfied" );
        player thread KYS();
    }  
}


Verify()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't verify the host!");
    }
    else
    {
        player thread BuildMenu();
        player.Verified = true;
        player.VIP = true;
        player.Admin = true;
        player.CoHost = true;
        player.pers["GiveMenu"] = true;
        self iPrintln( player.name + " is ^1Verified" );
    }   
}

freezeClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(!isDefined(self.ClientFrozen))
    {
        if(player isHost())
        {
            self iPrintln("You can't freeze the host!");
        }
        else
        {
            player freezeControls(true);
            self iprintln(player.name + " ^1Frozen");
            self.ClientFrozen = true;
        }
    }
    else if(self.ClientFrozen == true)
    {
        if(player isHost())
        {
            self iPrintln("You can't freeze the host!");
        }
        else
        {
            player freezeControls(false);
            self iprintln(player.name + " ^2Unfrozen");
            self.ClientFrozen = undefined;
        }
    }
    
}

unfreezeClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't freeze the host!");
    }
    else
    {
        player freezeControls(false);
        self iprintln(player.name + " ^1Unfrozen");
    }
}

teleportClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't teleport the host!");
    }
    else
    {
        player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);
        self iprintln(player.name + " ^2Has been teleported");
    }
}

ClientSpawn()
{
    self endon ("disconnect");
    player = level.players[self.Menu.System["ClientIndex"]];
    player.pers["location"] = player.origin;
    player.pers["savedLocation"] = player.origin;
    self iprintln(player.name + " ^2spawn location has been saved to ^3" + player.pers["location"]);
}

clientNorthpixel()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't teleport the host!");
    }
    else
    {
        NewOrigin = player.origin + (0,1,0);
        player setorigin(NewOrigin);
        self iprintln(player.name + " ^2Has been teleported to ^3" + NewOrigin);
    }
}

clientSouthpixel()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't teleport the host!");
    }
    else
    {
        NewOrigin = player.origin + (0,-1,0);
        player setorigin(NewOrigin);
        self iprintln(player.name + " ^2Has been teleported to ^3" + NewOrigin);
    }
}

clientEastpixel()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't teleport the host!");
    }
    else
    {
        NewOrigin = player.origin + (1,0,0);
        player setorigin(NewOrigin);
        self iprintln(player.name + " ^2Has been teleported to ^3" + NewOrigin);
    }
}

clientWestpixel()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't teleport the host!");
    }
    else
    {
        NewOrigin = player.origin + (-1,0,0);
        player setorigin(NewOrigin);
        self iprintln(player.name + " ^2Has been teleported to ^3" + NewOrigin);
    }
}

crouchClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't crouch the host!");
    }
    else
    {
        player setstance("crouch");
        self iprintln(player.name + " ^2Has been crouched");
    }
}

proneClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't prone the host!");
    }
    else
    {
        player setstance("prone");
        self iprintln(player.name + " ^2Has been proned");
    }
}

standClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't stand the host!");
    }
    else
    {
        player setstance("stand");
        self iprintln(player.name + " ^2Has been made to stand");
    }
}

reviveClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if (!isAlive(player))
    {
        player revivePlayer(player, true);
    }
    self iprintln(player.name + " ^2Has been revived");
}

killClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't kill the host!");
    }
    else
    {
        player suicide();
        self iprintln(player.name + " ^2Has been killed");
    }
}

kickClient()
{
    player = level.players[self.Menu.System["ClientIndex"]];
    if(player isHost())
    {
        self iPrintln("You can't kick the host!");
    }
    else
    {
        kick( player getEntityNumber());
        self iprintln(player.name + " ^2Has been kicked");
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

ToggleSpawnText()
{
    if(!IsDefined(self.SpawnTextOn))
    {
        self.SpawnText = false;
        self iprintln("Spawn text is ^1disabled");
        self.SpawnTextOn = true;
    }
    else if(self.SpawnTextOn == true)
    {
        self.SpawnText = true;
        self iprintln("Spawn text is ^2enabled");
        self.SpawnTextOn = undefined;
    }
}

ToggleJimbos()
{
}

changeMenuColors(newColor, colorName)
{
    self.menuColor = newColor;
    self iprintln("menu color changed to ^1" + colorName);
    
}

// main Functions

ToggleGod()
{   
    self endon("death");
    if( self.god == false )
    {
        self enableInvulnerability();
        self.god = true;
        self iprintln("God mode ^2On");
    }
    else if( self.god == true )
    {  
        self disableInvulnerability();
        self.god = false;
        self iprintln("God mode ^1Off");
    }
}

ToggleFOV()
{
    self endon("death");
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
    self endon("death");
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
        self iprintln("Press [{+speed_throw}] to go upwards");
        self iprintln("Press [{+attack}] to go down");
        self iprintln("Press [{+smoke}] to go where you're looking");
        self iprintln("Press [{+melee}] to get out of ufo");
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
        if(self secondaryoffhandbuttonpressed() && self.ufomode == 1) 
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
        if(self adsButtonPressed() && self.ufomode == 1)
        {
            self.UpUFO = self.noclipobj.origin;
            self.noclipobj.origin = self.UpUFO + (0,0,20);
        }
        if(self attackbuttonpressed() && self.ufomode == 1)
        {
            self.UpUFO = self.noclipobj.origin;
            self.noclipobj.origin = self.UpUFO + (0,0,-20);
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
    while(self.pers["SavingandLoading"] == true)
    {
        if( self.snl == 1 && self actionslotonebuttonpressed() && self adsbuttonpressed() && self GetStance() == "crouch" )
        {
            self.o = self.origin;
			self.a = self.angles;
            self.pers["location"] = self.origin;
            self.pers["savedLocation"] = self.origin;
            load = 1;
            self iprintln( "Position ^2Saved" );
            wait 2;
        }
        if( self.snl == 1 && self.load == 1 && self actionslotfourbuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
			self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
}

savePosition()
{
    self endon( "disconnect" );
    self.a = self.angles;
    self.pers["savedLocation"] = self.origin;
    load = 1;

    self iprintln("Position ^2Saved");
    self iprintln("Position is " + self.pers["savedLocation"]);
    wait 2;
}

loadPosition()
{
    self endon( "disconnect" );
    self setplayerangles(self.a);
    self setOrigin(self.pers["savedLocation"]);
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
        self.pers["location"] = self.origin;
        load   = 1;
        self iprintln("Spawn Location ^2Saved");
        self thread monitorLocationForSpawn();
        self.SpawningHere = true;
    }
    else
    {
        self notify("stop_locationForSpawn");
        self.pers["location"] = "";
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

ChangeForgeRad(num)
{
    self.ForgeRadii = num;
    self iPrintLn("Forge mod radius changed to ^7" + num);
}

forgemodeon()
{
    self endon( "death" );
    self endon( "stop_forge" );
    for(;;)
    {
    while( self adsbuttonpressed() )
    {
        trace=bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,true,self);
        while( self adsbuttonpressed() )
        {
            trace[ "entity"] setorigin( self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * self.ForgeRadii );
            trace["entity"].origin=self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* self.ForgeRadii;
            wait 0.05;
        }
    }
    wait 0.05;
    }

}

ChangeCPSpeed(num)
{
    level.crateOwnerUseTime = num;
    level.crateNonOwnerUseTime = num;
    self iPrintLn("Carepackage capture speed changed to ^7" + num);
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
}

carePackageStall2()
{
    origin=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+ anglesToForward(self getplayerangles())* 200,0,self)["position"];
    level.carePackStall2=spawn("script_model" ,origin + (0 ,0 , 35));  
    self thread maps\mp\gametypes\_supplydrop::dropcrate(origin + (0 ,0 , 35) ,self.angles ,"supplydrop_mp" ,self ,self.team ,level.carePackStall2);
    level.underCarePack=spawn("script_model",origin);  
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

spawnSM(origin, model) 
{ 
    ent = spawn("script_model", origin); 
    ent setModel(model); 
    return ent; 
}  

platform()
{
    self iprintln( "Spawned A ^2Platform" );
    level.platform = spawnSM(self.origin + (0, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (40, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (80, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (120, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (160, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-40, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-80, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-120, 0, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-160, 0, 0), "mp_supplydrop_ally");

    level.platform = spawnSM(self.origin + (0, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (40, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (80, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (120, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (160, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-40, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-80, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-120, 70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-160, 70, 0), "mp_supplydrop_ally");

    level.platform = spawnSM(self.origin + (0, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (40, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (80, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (120, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (160, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-40, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-80, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-120, 140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-160, 140, 0), "mp_supplydrop_ally");

    level.platform = spawnSM(self.origin + (0, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (40, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (80, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (120, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (160, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-40, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-80, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-120, -70, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-160, -70, 0), "mp_supplydrop_ally");

    level.platform = spawnSM(self.origin + (0, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (40, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (80, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (120, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (160, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-40, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-80, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-120, -140, 0), "mp_supplydrop_ally");
    level.platform = spawnSM(self.origin + (-160, -140, 0), "mp_supplydrop_ally");
}

SpawnHeli()
{
	self.DropZone2 = self.origin + (0,0,1150);
    self.DropZoneAngle2 = self.angle;
    self thread maps\mp\gametypes\_supplydrop::NewHeli( self.DropZone2, "bruh", self, self.team);
    self iprintln("Helicopter Spawned");
}

// streaks

doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln(killstreak + " ^1Given");
}

// perks
noMorePerk()
{
	self unsetPerk("specialty_fallheight");
	self unsetPerk("specialty_movefaster");
	self unsetPerk( "specialty_extraammo" );
	self unsetPerk( "specialty_scavenger" );
	self unsetPerk( "specialty_gpsjammer" );
	self unsetPerk( "specialty_nottargetedbyai" );
	self unsetPerk( "specialty_noname" );
	self unsetPerk( "specialty_flakjacket" );
	self unsetPerk( "specialty_killstreak" );
	self unsetPerk( "specialty_gambler" );
	self unsetPerk( "specialty_fallheight" );
	self unsetPerk( "specialty_sprintrecovery" );
	self unsetPerk( "specialty_fastmeleerecovery" );
	self unsetPerk( "specialty_holdbreath" );
	self unsetPerk( "specialty_fastweaponswitch" );
	self unsetPerk( "specialty_fastreload" );
	self unsetPerk( "specialty_fastads" );
	self unsetPerk("specialty_twoattach");
	self unsetPerk("specialty_twogrenades");
	self unsetPerk( "specialty_longersprint" );
	self unsetPerk( "specialty_unlimitedsprint" );
	self unsetPerk( "specialty_quieter" );
	self unsetPerk( "specialty_loudenemies" );
	self unsetPerk( "specialty_showenemyequipment" );
	self unsetPerk( "specialty_detectexplosive" );
	self unsetPerk( "specialty_disarmexplosive" );
	self unsetPerk( "specialty_nomotionsensor" );
	self unsetPerk( "specialty_shades" );
	self unsetPerk( "specialty_stunprotection" );
	self unsetPerk( "specialty_pistoldeath" );
	self unsetPerk( "specialty_finalstand" );
	self iprintln("All perks have been ^1unset");
}

SetAllPerks()
{
	self setPerk("specialty_fallheight");
	self setPerk("specialty_movefaster");
	self setPerk( "specialty_extraammo" );
	self setPerk( "specialty_scavenger" );
	self setPerk( "specialty_gpsjammer" );
	self setPerk( "specialty_nottargetedbyai" );
	self setPerk( "specialty_noname" );
	self setPerk( "specialty_flakjacket" );
	self setPerk( "specialty_killstreak" );
	self setPerk( "specialty_gambler" );
	self setPerk( "specialty_fallheight" );
	self setPerk( "specialty_sprintrecovery" );
	self setPerk( "specialty_fastmeleerecovery" );
	self setPerk( "specialty_holdbreath" );
	self setPerk( "specialty_fastweaponswitch" );
	self setPerk( "specialty_fastreload" );
	self setPerk( "specialty_fastads" );
	self setPerk("specialty_twoattach");
	self setPerk("specialty_twogrenades");
	self setPerk( "specialty_longersprint" );
	self setPerk( "specialty_unlimitedsprint" );
	self setPerk( "specialty_quieter" );
	self setPerk( "specialty_loudenemies" );
	self setPerk( "specialty_showenemyequipment" );
	self setPerk( "specialty_detectexplosive" );
	self setPerk( "specialty_disarmexplosive" );
	self setPerk( "specialty_nomotionsensor" );
	self setPerk( "specialty_shades" );
	self setPerk( "specialty_stunprotection" );
	self setPerk( "specialty_pistoldeath" );
	self setPerk( "specialty_finalstand" );
	self iprintln("All perks have been ^2set");
}

GivePerk(num)
{
    if(num == 1)
    {
        self setPerk("specialty_fallheight");
        self setPerk("specialty_movefaster");
        self iprintln("Perk ^1Lightweight ^7Given");
    }
    else if(num == 2)
    {
        self setPerk( "specialty_extraammo" );
        self setPerk( "specialty_scavenger" );
        self iprintln("Perk ^1Scavenger ^7Given");
    }
    else if(num == 3)
    {
        self setPerk( "specialty_gpsjammer" );
        self setPerk( "specialty_nottargetedbyai" );
        self setPerk( "specialty_noname" );
        self iprintln("Perk ^1Ghost ^7Given");
    }
    else if(num == 4)
    {
        self setPerk( "specialty_flakjacket" );
        self iprintln("Perk ^1Flak Jacket ^7Given");
    }
    else if(num == 5)
    {
        self setPerk( "specialty_killstreak" );
        self setPerk( "specialty_gambler" );
        self iprintln("Perk ^1Hardline ^7Given");
    }
    else if(num == 6)
    {
        self setPerk( "specialty_fallheight" );
        self setPerk( "specialty_sprintrecovery" );
        self setPerk( "specialty_fastmeleerecovery" );
        self iprintln("Perk ^1Steady Aim ^7Given");
    }
    else if(num == 7)
    {
        self setPerk( "specialty_holdbreath" );
        self setPerk( "specialty_fastweaponswitch" );
        self iprintln("Perk ^1Scout ^7Given");
    }
    else if(num == 8)
    {
        self setPerk( "specialty_fastreload" );
        self setPerk( "specialty_fastads" );
        self iprintln("Perk ^1Sleight of Hand ^7Given");
    }
    else if(num == 9)
    {
        self setPerk("specialty_twoattach");
        self setPerk("specialty_twogrenades");
        self iprintln("Perk ^1War Lord ^7Given");
    }
    else if(num == 10)
    {
        self setPerk( "specialty_longersprint" );
        self setPerk( "specialty_unlimitedsprint" );
        self iprintln("Perk ^1Marathon ^7Given");
    }
    else if(num == 11)
    {
        self setPerk( "specialty_quieter" );
        self setPerk( "specialty_loudenemies" );
        self iprintln("Perk ^1Ninja ^7Given");
    }
    else if(num == 12)
    {
        self setPerk( "specialty_showenemyequipment" );
        self setPerk( "specialty_detectexplosive" );
        self setPerk( "specialty_disarmexplosive" );
        self setPerk( "specialty_nomotionsensor" );
        self iprintln("Perk ^1Hacker ^7Given");
    }
    else if(num == 13)
    {
        self setPerk( "specialty_shades" );
        self setPerk( "specialty_stunprotection" );
        self iprintln("Perk ^1Tactical Mask ^7Given");
    }
    else if(num == 14)
    {
        self setPerk( "specialty_pistoldeath" );
        self setPerk( "specialty_finalstand" );
        self iprintln("Perk ^1Last Chance ^7Given");
    }
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

tpBotHere(coords)
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            player setorigin(coords);
            self iprintln("Bot teleported to ^1" + coords);
        }
    }
}

BotSpawns()
{
    self endon ("disconnect");
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            player.pers["location"] = player.origin;
            player.pers["savedLocation"] = player.origin;
            self iprintln("Bot location Saved ^1" + player.pers["location"]);
        }
    }
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
    self iprintln("All Bots are ^2Standing");
}

MoveNorthpixel()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            NewOrigin = player.origin + (0,1,0);
            player setorigin(NewOrigin);
            self iprintln("Bot teleported to " + NewOrigin);
        }
    }
}

MoveSouthpixel()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            NewOrigin = player.origin + (0,-1,0);
            player setorigin(NewOrigin);
            self iprintln("Bot teleported to " + NewOrigin);
        }
    }
}

MoveEastpixel()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            NewOrigin = player.origin + (1,0,0);
            player setorigin(NewOrigin);
            self iprintln("Bot teleported to " + NewOrigin);
        }
    }
}

MoveWestpixel()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            NewOrigin = player.origin + (-1,0,0);
            player setorigin(NewOrigin);
            self iprintln("Bot teleported to " + NewOrigin);
        }
    }
}

GetBotLocation()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            self iPrintLn("^1" + player getOrigin());
        }
    }
}

firstTimeBots()
{
    if(self.FirstTimeSpawn == true)
    {
        self thread spawnEnemyBot();
        self.FirstTimeSpawn = false;
    }
    else if(self.FirstTimeSpawn == false)
    {
        self iprintln("gay");
    }
}

ChangeMapFixed(mapR)
{
    SetDvar("ls_mapname", mapR);
    SetDvar("mapname", mapR);
    SetDvar("party_mapname", mapR);
    SetDvar("ui_mapname", mapR);
    SetDvar("ui_currentMap", mapR);
    SetDvar("ui_mapname", mapR);
    SetDvar("ui_preview_map", mapR);
    SetDvar("ui_showmap", mapR);
    Map(mapR);
}


precamOTS()
{
    if(self.precam == 0)
    {
        setDvar("cg_nopredict", "1");
        self.precam = 1;
        self iprintln("Precam ^2On");
        
    }
    else 
    {
        setDvar("cg_nopredict", "0");
        self.precam = 0;
        self iprintln("Precam ^1Off");
    }
}

toggleBomb()
{
    if(self.bombEnabled == 0)
    {
        setDvar("bombEnabled", "1");
        self.bombEnabled = true;
        self iprintln("Bomb ^2On");
    }
    else 
    {
        setDvar("bombEnabled", "0");
        self.bombEnabled = false;
        self iprintln("Bomb ^1Off");
    }
}

revivePlayer(player)
{
    if (!isAlive(player))
    {
        if (!isDefined(player.pers["class"]))
        {
            player.pers["class"] = "CLASS_CUSTOM1";
            player.class = player.pers["class"];
            player maps\mp\gametypes\_class::setClass(player.pers["class"]);
        }
        
        if (player.hasSpawned)
        {
            player.pers["lives"]++;
        }
        else 
        {
            player.hasSpawned = true;
        }

        if (player.sessionstate != "playing")
        {
            player.sessionstate = "playing";
        }
        
        player thread [[level.spawnClient]]();
        self iprintln(player.name + " ^2revived");
    }
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
    self endon( "disconnect" );           
    if(!isDefined(self.pers["aimbotweapon"]))
    {
		self.pers["aimbotweapon"] = self getcurrentweapon();
        self.EBWeapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon defined to: ^1" + self.pers["aimbotweapon"]);
        
    }
    else if(isDefined(self.pers["aimbotweapon"]))
    {
        self.pers["aimbotweapon"] = undefined;
        self iprintln("Aimbots will work with ^2All Weapons");
    }
    
}

aimbotRadius()
{
    self endon( "disconnect" );
    if(self.pers["aimbotRadius"] == 100)
    {
        self.pers["aimbotRadius"] = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 500)
    {
        self.pers["aimbotRadius"] = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 1000)
    {
        self.pers["aimbotRadius"] = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 1500)
    {
        self.pers["aimbotRadius"] = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 2000)
    {
        self.pers["aimbotRadius"] = 2500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 2500)
    {
        self.pers["aimbotRadius"] = 3000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 3000)
    {
        self.pers["aimbotRadius"] = 3500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 3500)
    {
        self.pers["aimbotRadius"] = 4000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 4000)
    {
        self.pers["aimbotRadius"] = 4500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 4500)
    {
        self.pers["aimbotRadius"] = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotRadius"]);
    }
    else if(self.pers["aimbotRadius"] == 5000)
    {
        self.pers["aimbotRadius"] = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

aimbotDelay()
{
    self endon( "disconnect" );
    if(self.pers["aimbotDelay"] == 0)
    {
        self.pers["aimbotDelay"] = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .1)
    {
        self.pers["aimbotDelay"] = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .2)
    {
        self.pers["aimbotDelay"] = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .3)
    {
        self.pers["aimbotDelay"] = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .4)
    {
        self.pers["aimbotDelay"] = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .5)
    {
        self.pers["aimbotDelay"] = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .6)
    {
        self.pers["aimbotDelay"] = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .7)
    {
        self.pers["aimbotDelay"] = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .8)
    {
        self.pers["aimbotDelay"] = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["aimbotDelay"]);
    }
    else if(self.pers["aimbotDelay"] == .9)
    {
        self.pers["aimbotDelay"] = 0;
        self iprintln("Aimbot Radius set to: ^1No Delay");
    }
}

ToggleAimbot()
{
    self endon( "disconnect" );
    if(self.pers["aimbotToggle"] == 0)
    {
        self.pers["aimbotToggle"] = 1;
        self.pers["aimbotSpawnToggle"] = true;
        self iprintln("Aimbot ^2Activated");
        self thread doRadiusAimbot();
    }
    else
    {
        self.pers["aimbotToggle"] = 0;
        self.pers["aimbotSpawnToggle"] = false;
        self iprintln("Aimbot ^1deactivated");
        self notify("Stop_trickshot");
    }
}

doRadiusAimbot()
{
    self endon("disconnect");
    self endon("Stop_trickshot");
    while(self.pers["aimbotSpawnToggle"] == true)
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
            if(isDefined(self.pers["aimbotweapon"]) && self getcurrentweapon() == self.pers["aimbotweapon"])
            {
                player = level.players[i];
                playerorigin = player getorigin();
                if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                    continue;

                if(distance(bulletImpact, playerorigin) < self.pers["aimbotRadius"] && isAlive(level.players[i]))
                {
                    if(isDefined(self.pers["aimbotDelay"]))
                        wait (self.pers["aimbotDelay"]);
                    level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                }
            }
            if(!isDefined(self.pers["aimbotweapon"]))
            {
                player = level.players[i];
                playerorigin = player getorigin();
                if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                    continue;

                if(distance(bulletImpact, playerorigin) < self.pers["aimbotRadius"] && isAlive(level.players[i]))
                {
                    if(isDefined(self.pers["aimbotDelay"]))
                        wait (self.pers["aimbotDelay"]);
                    level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                }
            }
        }
    wait .1;    
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
                self waittill( "weapon_fired" );
                if(isDefined(self.pers["aimbotweapon"]) && self getcurrentweapon() == self.pers["aimbotweapon"])
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                else if(!isDefined(self.pers["aimbotweapon"]) && self getcurrentweapon() == self.pers["aimbotweapon"])
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
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

ToggleHMAimbot()
{
    self endon( "disconnect" );
    if(self.pers["HMaimbotToggle"] == 0)
    {
        self.pers["HMaimbotToggle"] = 1;
        self.pers["HMaimbotSpawnToggle"] = true;
        self iprintln("Hit Marker Aimbot ^2activated");
        self thread HmAimbot();
    }
    else
    {
        self.pers["HMaimbotToggle"] = 0;
        self.pers["HMaimbotSpawnToggle"] = false;
        self iprintln("Hit Marker Aimbot ^1deactivated");
        self notify("Stop_trickshot");
    }
}

HmAimbot()
{
    self endon("disconnect");
    self endon("Stop_trickshot");
    while(self.pers["HMaimbotSpawnToggle"] == true)
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
            if(isDefined(self.pers["HMaimbotweapon"]) && self getcurrentweapon() == self.pers["HMaimbotweapon"])
            {
                player = level.players[i];
                playerorigin = player getorigin();
                if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                    continue;

                if(distance(bulletImpact, playerorigin) < self.pers["HMaimbotRadius"] && isAlive(level.players[i]))
                {
                    if(isDefined(self.HMaimbotDelay))
                        wait (self.HMaimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                }
            }
            if(!isDefined(self.pers["aimbotweapon"]))
            {
                player = level.players[i];
                playerorigin = player getorigin();
                if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                    continue;

                if(distance(bulletImpact, playerorigin) < self.pers["HMaimbotRadius"] && isAlive(level.players[i]))
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

HMaimbotWeapon()
{                     
    self endon( "disconnect" );           
    if(!isDefined(self.pers["HMaimbotweapon"]))
    {
		self.pers["HMaimbotweapon"] = self getcurrentweapon();
        self.EBWeapon = self getcurrentweapon();
        self iprintln("HM Aimbot Weapon defined to: ^1" + self.pers["HMaimbotweapon"]);
        
    }
    else if(isDefined(self.pers["HMaimbotweapon"]))
    {
        self.pers["HMaimbotweapon"] = undefined;
        self iprintln("HM Aimbot will work with ^2All Weapons");
    }
}

HMaimbotRadius()
{
    self endon( "disconnect" );
    if(self.pers["HMaimbotRadius"] == 100)
    {
        self.pers["HMaimbotRadius"] = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 500)
    {
        self.pers["HMaimbotRadius"] = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 1000)
    {
        self.pers["HMaimbotRadius"] = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 1500)
    {
        self.pers["HMaimbotRadius"] = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 2000)
    {
        self.pers["HMaimbotRadius"] = 2500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 2500)
    {
        self.pers["HMaimbotRadius"] = 3000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 3000)
    {
        self.pers["HMaimbotRadius"] = 3500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 3500)
    {
        self.pers["HMaimbotRadius"] = 4000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 4000)
    {
        self.pers["HMaimbotRadius"] = 4500;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 4500)
    {
        self.pers["HMaimbotRadius"] = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotRadius"]);
    }
    else if(self.pers["HMaimbotRadius"] == 5000)
    {
        self.pers["HMaimbotRadius"] = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

HMaimbotDelay()
{
    self endon( "disconnect" );
    if(self.pers["HMaimbotDelay"] == 0)
    {
        self.pers["HMaimbotDelay"] = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .1)
    {
        self.pers["HMaimbotDelay"] = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .2)
    {
        self.pers["HMaimbotDelay"] = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .3)
    {
        self.pers["HMaimbotDelay"] = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .4)
    {
        self.pers["HMaimbotDelay"] = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .5)
    {
        self.pers["HMaimbotDelay"] = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .6)
    {
        self.pers["HMaimbotDelay"] = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .7)
    {
        self.pers["HMaimbotDelay"] = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .8)
    {
        self.pers["HMaimbotDelay"] = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.pers["HMaimbotDelay"]);
    }
    else if(self.pers["HMaimbotDelay"] == .9)
    {
        self.pers["HMaimbotDelay"] = 0;
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

MW2EndGame1()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^11 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 1;
        self freezecontrols(true);
        
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame15()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^11.5 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 1.5;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame2()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^12 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 2;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame25()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^12.5 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 2.5;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame3()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^13 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 3;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame35()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^13.5 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 3.5;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame4()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^14 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 4;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame45()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^14.5 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 4.5;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
    }
}

MW2EndGame5()
{
    if(self.mw2endgame == 0)
    {
        self iprintln("you can move for ^15 ^7seconds after you hit");
        self.mw2endgame = 1;
        level waittill("game_ended");
        self freezecontrols(false);
        wait 5;
        self freezecontrols(true);
    }
    else if(self.mw2endgame == 1)
    {
        self iprintln("^1your game will end normally");
        self.mw2endgame = 0;
        self waittill("game_ended");
        self freezecontrols(true);
        
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

AltAmmo1()
{
    curWeap = self getcurrentweapon();
    ammoW = self getWeaponAmmoStock(curWeap);
    ammoCW = self getWeaponAmmoClip(curWeap);
    self setweaponammostock( curWeap, ammoW );
    self setweaponammoclip( curWeap, ammoCW - 1 );
}

AltAmmo2()
{
    curWeap = self getCurrentWeapon();
    ammoW = self getWeaponAmmoStock(curWeap);
    ammoCW = self getWeaponAmmoClip(curWeap);
    self setweaponammostock( curWeap, ammoW );
    self setweaponammoclip( curWeap, ammoCW / 2 );
}

AltAmmo3()
{
    curWeap = self getCurrentWeapon();
    ammoW = self getWeaponAmmoStock(curWeap);
    self setweaponammostock( curWeap, ammoW );
    self setweaponammoclip( curWeap, 1);
}

AmmoBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 1}] to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false)
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 2}] to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 3}] to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 4}] to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind1C()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 1}] and crouch to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false && self GetStance() == "crouch")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind2C()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 2}] and crouch to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false && self GetStance() == "crouch")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind3C()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 3}] and crouch to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false && self GetStance() == "crouch")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind4C()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 4}] and crouch to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false && self GetStance() == "crouch")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}


AmmoBind1P()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 1}] and prone to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self ActionSlotOneButtonPressed() && self.MenuOpen == false && self GetStance() == "prone")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind2P()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 2}] and prone to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false && self GetStance() == "prone")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind3P()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 3}] and prone to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false && self GetStance() == "prone")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

AmmoBind4P()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.AmmoBind))
    {
        self iPrintLn("Refill ammo activated, press [{+Actionslot 4}] and prone to refill ammo");
        self.AmmoBind = true;
        while(isDefined(self.AmmoBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false && self GetStance() == "prone")
            {
                primary = self getcurrentweapon();
                lethal = self getcurrentoffhand();
                self givemaxammo( primary );
                self givemaxammo( lethal );
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.AmmoBind)) 
    { 
        self iPrintLn("Refill ammo bind ^1deactivated");
        self.AmmoBind = undefined; 
    }
}

GivePlayerWeapon(weapon)
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
    self iPrintln("You have been given: ^2" + weapon);
}

// account shoutout century

doLevel50()
{
    level.rankedMatch = true;
    level.contractsEnabled = true;
    setDvar("onlinegame", 1);
    setDvar("xblive_rankedmatch", 1);
    setDvar("xblive_privatematch", 0);
    self maps\mp\gametypes\_persistence::statSet("rankxp", 1262500, false);
    self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "rankxp", 1262500);
    self.pers["rank"] = 49;
    self setRank(49);
    self iprintln("Rank 50 ^2given");
}

doPrestige15()
{
    level.rankedMatch = true;
    level.contractsEnabled = true;
    setDvar("onlinegame", 1);
    setDvar("xblive_rankedmatch", 1);
    setDvar("xblive_privatematch", 0);
    prestigeLevel = 15;
    self.pers["plevel"] = prestigeLevel;
    self.pers["prestige"] = prestigeLevel;
    self setdstat("playerstatslist", "plevel", "StatValue", prestigeLevel);
    self maps\mp\gametypes\_persistence::statSet("plevel", prestigeLevel, true);
    self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "plevel", prestigeLevel);
    self setRank(self.pers["rank"], prestigeLevel);
    self iprintln("Prestige 15 ^2given");
}

doUnlockProPerks()
{   
    level.rankedMatch = true;
    level.contractsEnabled = true;
    setDvar("onlinegame", 1);
    setDvar("xblive_rankedmatch", 1);
    setDvar("xblive_privatematch", 0);
    perks = [];
    perks[1] = "PERKS_SLEIGHT_OF_HAND";
    perks[2] = "PERKS_GHOST";
    perks[3] = "PERKS_NINJA";
    perks[4] = "PERKS_HACKER";
    perks[5] = "PERKS_LIGHTWEIGHT";
    perks[6] = "PERKS_SCOUT";
    perks[7] = "PERKS_STEADY_AIM";
    perks[8] = "PERKS_DEEP_IMPACT";
    perks[9] = "PERKS_MARATHON";
    perks[10] = "PERKS_SECOND_CHANCE";
    perks[11] = "PERKS_TACTICAL_MASK";
    perks[12] = "PERKS_PROFESSIONAL";
    perks[13] = "PERKS_SCAVENGER";
    perks[14] = "PERKS_FLAK_JACKET";
    perks[15] = "PERKS_HARDLINE";
    for (i = 1; i < 16; i++)
    {
        perk = perks[i];
        for (j = 0; j < 3; j++)
        {
            self maps\mp\gametypes\_persistence::unlockItemFromChallenge("perkpro " + perk + " " + j);
        }
    }
    self iprintln("Pro perks ^2given");
}

giveUnlockAll()
{
    level.rankedMatch = true;
    level.contractsEnabled = true;
    setDvar("onlinegame", 1);
    setDvar("xblive_rankedmatch", 1);
    setDvar("xblive_privatematch", 0);
    if (level.players.size > 1)
    {
        self iprintln("^1Too many ^7players in your game!");
        return;
    }

    //RANKED GAME
    level.rankedMatch = true;
    level.contractsEnabled = true;
    setDvar("onlinegame", 1);
    setDvar("xblive_rankedmatch", 1);
    setDvar("xblive_privatematch", 0);
    //LEVEL 50
    self maps\mp\gametypes\_persistence::statSet("rankxp", 1262500, false);
    self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "rankxp", 1262500);
    self.pers["rank"] = 49;
    self setRank(49);
    //PRESTIGE
    prestigeLevel = 15;
    self.pers["plevel"] = prestigeLevel;
    self.pers["prestige"] = prestigeLevel;
    self setdstat("playerstatslist", "plevel", "StatValue", prestigeLevel);
    self maps\mp\gametypes\_persistence::statSet("plevel", prestigeLevel, true);
    self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "plevel", prestigeLevel);
    self setRank(self.pers["rank"], prestigeLevel);
    //PERKS
    perks = [];
    perks[1] = "PERKS_SLEIGHT_OF_HAND";
    perks[2] = "PERKS_GHOST";
    perks[3] = "PERKS_NINJA";
    perks[4] = "PERKS_HACKER";
    perks[5] = "PERKS_LIGHTWEIGHT";
    perks[6] = "PERKS_SCOUT";
    perks[7] = "PERKS_STEADY_AIM";
    perks[8] = "PERKS_DEEP_IMPACT";
    perks[9] = "PERKS_MARATHON";
    perks[10] = "PERKS_SECOND_CHANCE";
    perks[11] = "PERKS_TACTICAL_MASK";
    perks[12] = "PERKS_PROFESSIONAL";
    perks[13] = "PERKS_SCAVENGER";
    perks[14] = "PERKS_FLAK_JACKET";
    perks[15] = "PERKS_HARDLINE";
    for (i = 1; i < 16; i++)
    {
        perk = perks[i];
        for (j = 0; j < 3; j++)
        {
            self maps\mp\gametypes\_persistence::unlockItemFromChallenge("perkpro " + perk + " " + j);
        }
    }

    //COD POINTS
    points = 1000000000;
    self maps\mp\gametypes\_persistence::statSet("codpoints", points, false);
    self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "codpoints", points);
    self maps\mp\gametypes\_persistence::setPlayerStat("PlayerStatsList", "CODPOINTS", points);
    self.pers["codpoints"] = points;
    //ITEMS
    self setClientDvar("allItemsPurchased", "1");
    self setClientDvar("allItemsUnlocked", "1");
    //EMBLEMS
    self setClientDvar("allEmblemsPurchased", "1");
    self setClientDvar("allEmblemsUnlocked", "1");
    self setClientDvar("ui_items_no_cost", "1");
    self setClientDvar("lb_prestige", "1");
    self maps\mp\gametypes\_rank::updateRankAnnounceHUD();
    self iprintln("Full unlock all ^2given");
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
    setDvar("com_maxfps", 144);
    setDvar("timescale", 1 );
}

setSlowMoKC(num)
{
    self endon("disconnect");
    setDvar("timescale", num);
    self iprintln("Slow Motion ^2" + num);
    level waittill("game_ended");
    setDvar("com_maxfps", 144);
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

mantleSpin()
{
    if(self.mantleSpin == 0)
    {
        self iPrintln("Mantle Spins: ^2On");
        setdvar( "mantle_view_yawcap", "360" );
        self.mantleSpin = 1;
    }
    else
    {
        self iPrintln("Mantle Spins: ^1Off");
        setdvar( "mantle_view_yawcap", "60" );
        self.mantleSpin = 0;
    }
}

autoProne()
{
    if(self.AutoProne == 0)
    {
        self iPrintln("Auto Prone: ^2On");
        self endon("disconnect");
        level waittill("game_ended");
        self thread LayDownNigger();
        self.AutoProne = 1;
    }
    else
    {
        self iPrintln("Auto Prone: ^1Off");
        self notify("notprone");
        self.AutoProne = 0;
    }
}

LayDownNigger()
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
    self endon( "disconnect" );
    if( self.camera == 1 )
    {
        self iprintln( "Soft Landing ^2On" );
        self.camera = 0;
        level waittill("game_ended");
        self.CurVelo = self getVelocity();
        waittillframeend;
        self setVelocity(self.CurVelo / 1.5);
        
    }
    else
    {
        self iprintln( "Soft Landing ^1Off" );
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
        self iprintln("Killcam length changed to ^110 seconds");
        self.LongKC = 1;
    }
    else if(self.LongKC == 1)
    {
        SetDvar("scr_killcam_time", "15");
        self iprintln("Killcam length changed to ^115 seconds");
         self.LongKC = 2;
    }
    else if(self.LongKC == 2)
    {
        SetDvar("scr_killcam_time", "30");
        self iprintln("Killcam length changed to ^130 seconds");
         self.LongKC = 3;
    }
    else if(self.LongKC == 3)
    {
        SetDvar("scr_killcam_time", "5.5");
        self iprintln("Killcam length reset");
         self.LongKC = 0;
    }
}

RoachLongKillcams(num)
{
    self endon( "disconnect" );
    SetDvar("scr_killcam_time", num);
    self iprintln("Killcam length changed to ^1" + num);
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


jumpfatigue()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(!self.jumperfatigue)
    {
        self.jumperfatigue = true;
        setDvar ("jump_slowdownEnable", 0);
        self iPrintln("Jump Fatigue ^2enabled");
    }
    else
    {
        self.jumperfatigue = false;
        setDvar ("jump_slowdownEnable", 1);
        self iPrintln("Jump Fatigue ^1disabled");
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
                self thread repeaterBind();
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
                self thread repeaterBind();
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
                self thread repeaterBind();
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
                self thread repeaterBind();
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

repeaterBind()
{
    current = self getCurrentWeapon();
    self setSpawnWeapon(current);
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

boltmovementsingle()
{
    scriptRide = spawn("script_model", self.origin);
    scriptRide EnableLinkTo();
    self PlayerLinkToDelta(scriptRide);
    scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
    wait self.boltspeed;
    self Unlink();
    waittillframeend;
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
                self thread boltmovementsingle();
            }
            wait .00001;
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
                self thread boltmovementsingle();
            }
            wait .00001; 
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
                self thread boltmovementsingle();
            }
            wait .00001; 
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
                self thread boltmovementsingle();
            }
            wait .00001; 
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
    waittillframeend;
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

OMAOverlay1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 1}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlay2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 2}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlay3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 3}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlay4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 4}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayDouble1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 1}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit2();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayDouble2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 2}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit2();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayDouble3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 3}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit2();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayDouble4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 4}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit2();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayTriple1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 1}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit3();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayTriple2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 2}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit3();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayTriple3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 3}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit3();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMAOverlayTriple4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.OMAoverlay))
    {
        self iPrintLn("OMA overlay bind activated, press [{+Actionslot 4}]");
        self.OMAoverlay = true;
        while(isDefined(self.OMAoverlay))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread ChangingKit3();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.OMAoverlay)) 
    { 
        self iPrintLn("One man army bind ^1deactivated");
        self.OMAoverlay = undefined; 
    } 
}

OMA()
{
    currentWeapon = self getcurrentweapon();
    self giveWeapon(self.OMAWeapon);
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkToDelta(shaxMODEL);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit();
    wait 1.92;
    self takeweapon(self.OMAWeapon);
    self unlink();
    self switchToWeapon(currentWeapon);
}

ChangingKit()
{
    self endon("death");
    self.ChangingKit = createSecondaryProgressBar();
    self.KitText = createSecondaryProgressBarText();
    for(i=0;i<36;i++)
    {
        self.ChangingKit updateBar(i / 35);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.61;
        wait .001;
    }
    self.ChangingKit destroyElem();
    self.KitText destroyElem();
}

OMADouble()
{
    currentWeapon = self getcurrentweapon();
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkToDelta(shaxMODEL);
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit2();
    wait 1.92;
    self takeweapon(self.OMAWeapon);
    self unlink();
    self switchToWeapon(currentWeapon);
}

ChangingKit2()
{
    self endon("death");
    self.ChangingKit  = createSecondaryProgressBar();
    self.KitText      = createSecondaryProgressBarText();
    self.ChangingKit2 = createSecondaryProgressBar();
    self.KitText2     = createSecondaryProgressBarText();
    for(i=0;i<36;i++)
    {
        self.ChangingKit updateBar(i / 35);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.61;
        // 2nd one
        self.ChangingKit2 updateBar(i / 35);
        self.KitText2 setText("Planting...");
        self.ChangingKit2 setPoint("CENTER", "CENTER", 0, -50);
        self.KitText2 setPoint("CENTER", "CENTER", 0, -65);
        self.ChangingKit2.color     = (0, 0, 0);
        self.ChangingKit2.bar.color = self.BarColor;
        self.ChangingKit2.alpha     = 0.61;
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
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkToDelta(shaxMODEL);
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit3();
    wait 1.92;
    self takeweapon(self.OMAWeapon);
    self unlink();
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
    for(i=0;i<36;i++)
    {
        self.ChangingKit updateBar(i / 35);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.61;
        // 2nd one
        self.ChangingKit2 updateBar(i / 35);
        self.KitText2 setText("Planting...");
        self.ChangingKit2 setPoint("CENTER", "CENTER", 0, -50);
        self.KitText2 setPoint("CENTER", "CENTER", 0, -65);
        self.ChangingKit2.color     = (0, 0, 0);
        self.ChangingKit2.bar.color = self.BarColor;
        self.ChangingKit2.alpha     = 0.61;
        // 3rd one
        self.ChangingKit3 updateBar(i / 35);
        self.KitText3 setText("Booby Trapping Crate");
        self.ChangingKit3 setPoint("CENTER", "CENTER", 0, -15);
        self.KitText3 setPoint("CENTER", "CENTER", 0, -30);
        self.ChangingKit3.color     = (0, 0, 0);
        self.ChangingKit3.bar.color = self.BarColor;
        self.ChangingKit3.alpha     = 0.61;
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
    self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip    = self getWeaponAmmoClip(self.EmptyWeap);
    WeapEmpStock     = self getWeaponAmmoStock(self.EmptyWeap);
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
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
    wait 0.5;
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    wait 1.8;
    self.scavenger_icon destroy();
}

LastStandBind1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStandBind))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 1}]");
        self.LastStandBind = true;
        while(isDefined(self.LastStandBind))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread forceLastStand();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStandBind)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStandBind = undefined; 
    } 
}

LastStandBind2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStandBind))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 2}]");
        self.LastStandBind = true;
        while(isDefined(self.LastStandBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread forceLastStand();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStandBind)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStandBind = undefined; 
    } 
}

LastStandBind3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStandBind))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 3}]");
        self.LastStandBind = true;
        while(isDefined(self.LastStandBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread forceLastStand();
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStandBind)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStandBind = undefined; 
    } 
}

LastStandBind4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.LastStandBind))
    {
        self iPrintLn("Last stand bind activated, press [{+Actionslot 4}]");
        self.LastStandBind = true;
        while(isDefined(self.LastStandBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread forceLastStand();
                
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.LastStandBind)) 
    { 
        self iPrintLn("Last stand bind ^1deactivated");
        self.LastStandBind = undefined; 
    } 
}

forceLastStand()
{
    self endon("disconnect");
    self setPerk( "specialty_pistoldeath" );
    self setPerk( "specialty_finalstand" );
    wait .1;
    self thread [[level.callbackPlayerDamage]]( self, self, self.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
    if(!self isOnGround())
    {
        self freezecontrolsallowlook( true );
        wait .3;
        self freezecontrolsallowlook( false );
    }
    wait .5;
}

lastStandWeap()
{
    laststandweap = self getCurrentWeapon();
    level.laststandpistol = laststandweap;
    self iprintln("Final stand weapon set ^1" + laststandweap);
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



ThirdPerson1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 1}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPerson();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPerson2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 2}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPerson();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPerson3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 3}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPerson();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPerson4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 4}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPerson();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

doThirdPerson()
{
    self endon("stopThird");
    if(!isDefined(self.DoingThirdPerson))
    {
        self setClientDvar( "cg_thirdPerson", "1" );
        self setClientDvar( "cg_thirdPersonRange", "110" );
        self.DoingThirdPerson = true;
    }
    else
    {
        self setClientDvar( "cg_thirdPerson", "0" );
        self.DoingThirdPerson = undefined;
    }
}

doThirdPersonOMA()
{
    currentWeapon = self getcurrentweapon();
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkToDelta(shaxMODEL);
    self setClientDvar( "cg_thirdPerson", "1" );
    self setClientDvar( "cg_thirdPersonRange", "110" );
    self giveWeapon(self.OMAWeapon);
    self switchToWeapon(self.OMAWeapon);
    wait 0.1;
    self thread ChangingKit3();
    wait 3;
    self takeweapon(self.OMAWeapon);
    self unlink();
    self switchToWeapon(currentWeapon);
    self setClientDvar( "cg_thirdPerson", "0" );
}

ThirdPersonWithOMA1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 1}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPersonOMA();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPersonWithOMA2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 2}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPersonOMA();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPersonWithOMA3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 3}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPersonOMA();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

ThirdPersonWithOMA4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ThirdPerson))
    {
        self iPrintLn("Third person bind activated, press [{+Actionslot 4}]");
        self.ThirdPerson = true;
        while(isDefined(self.ThirdPerson))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread doThirdPersonOMA();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.ThirdPerson)) 
    { 
        self iPrintLn("Third person bind ^1deactivated");
        self notify("stopThird");
        self.ThirdPerson = undefined; 
    }
}

saveDropNext()
{
    self.NextDropped = self getCurrentWeapon();
    self iPrintln("Selected: ^2"+self.NextDropped);
}

DropWeapon1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.DropWeap))
    {
        self iPrintLn("Drop weapon bind activated, press [{+Actionslot 1}]");
        self.DropWeap = true;
        while(isDefined(self.DropWeap))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NextDropped))
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                }
                else
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                    self setSpawnWeapon(self.NextDropped);
                }
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.DropWeap)) 
    { 
        self iPrintLn("Drop weapon bind ^1deactivated");
        self.DropWeap = undefined; 
    }
}

DropWeapon2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.DropWeap))
    {
        self iPrintLn("Drop weapon bind activated, press [{+Actionslot 2}]");
        self.DropWeap = true;
        while(isDefined(self.DropWeap))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NextDropped))
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                }
                else
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                    self setSpawnWeapon(self.NextDropped);
                }
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.DropWeap)) 
    { 
        self iPrintLn("Drop weapon bind ^1deactivated");
        self.DropWeap = undefined; 
    }
}

DropWeapon3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.DropWeap))
    {
        self iPrintLn("Drop weapon bind activated, press [{+Actionslot 3}]");
        self.DropWeap = true;
        while(isDefined(self.DropWeap))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NextDropped))
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                }
                else
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                    self setSpawnWeapon(self.NextDropped);
                }
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.DropWeap)) 
    { 
        self iPrintLn("Drop weapon bind ^1deactivated");
        self.DropWeap = undefined; 
    }
}

DropWeapon4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.DropWeap))
    {
        self iPrintLn("Drop weapon bind activated, press [{+Actionslot 4}]");
        self.DropWeap = true;
        while(isDefined(self.DropWeap))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NextDropped))
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                }
                else
                {
                    weap = self getCurrentWeapon();
                    self dropitem(weap);
                    self setSpawnWeapon(self.NextDropped);
                }
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.DropWeap)) 
    { 
        self iPrintLn("Drop weapon bind ^1deactivated");
        self.DropWeap = undefined; 
    }
}

KnifeLunge()
{
    if(!isDefined(self.KnifeLunge))
    {
        self.KnifeLunge = true;
        self iPrintLn("Knife Lunge ^2On");
        self setClientDvar("player_bayonetLaunchDebugging", "999" );
        self setClientDvar("player_meleeRange", "1" );
    }
    else 
    {
        self.KnifeLunge = undefined;
        self iPrintLn("Knife Lunge ^1Off");
        self setClientDvar("player_bayonetLaunchDebugging", "0" );
        self setClientDvar("player_meleeRange", "64" );
    }
}

WallBreach1()
{
    self endon("game_ended");
    self endon( "disconnect" );
        if(!isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach activated, press [{+Actionslot 1}] to Breach");
            self.WallBreach = true;
            while(isDefined(self.WallBreach))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread WallBreach();
                }
            wait .001;
            }
        }
        else if(isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach Bind ^5OFF");
            self.WallBreach = undefined;
            self setClientDvar("r_singleCell", "0");
        }
}
 
WallBreach2()
{
    self endon("game_ended");
    self endon( "disconnect" );
        if(!isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach activated, press [{+Actionslot 2}] to Breach");
            self.WallBreach = true;
            while(isDefined(self.WallBreach))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread WallBreach();
                }
            wait .001;
            }
        }
        else if(isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach Bind ^5OFF");
            self.WallBreach = undefined;
            self setClientDvar("r_singleCell", "0");
        }
}
 
WallBreach3()
{
    self endon("game_ended");
    self endon( "disconnect" );
        if(!isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach activated, press [{+Actionslot 3}] to Breach");
            self.WallBreach = true;
            while(isDefined(self.WallBreach))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread WallBreach();
                }
            wait .001;
            }
        }
        else if(isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach Bind ^5OFF");
            self.WallBreach = undefined;
            self setClientDvar("r_singleCell", "0");
        }
}
 
 
 
WallBreach4()
{
    self endon("game_ended");
    self endon( "disconnect" );
        if(!isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach activated, press [{+Actionslot 4}] to Breach");
            self.WallBreach = true;
            while(isDefined(self.WallBreach))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread WallBreach();
                }
            wait .001;
            }
        }
        else if(isDefined(self.WallBreach))
        {
            self iprintln("Wall Breach Bind ^5OFF");
            self.WallBreach = undefined;
            self setClientDvar("r_singleCell", "0");
        }
}
 
 
WallBreach()
{
    if(!isDefined(self.WallBreachX))
    {
        self.WallBreachX = true;
        self setClientDvar("r_singleCell", "1");
        wait .001;
    }
    else if(isDefined(self.WallBreachX))
    {
        self.WallBreachX = undefined;
        self setClientDvar("r_singleCell", "0");
    }
    wait .001;
}

ReEleBind()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.DownEle = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.DownEle + (0,0,-3);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}
 
 
ReElevatorBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Reverse Elevator activated, press [{+Actionslot 1}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread ReEleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ReElevatorBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator activated, press [{+Actionslot 2}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread ReEleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ReElevatorBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator activated, press [{+Actionslot 3}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread ReEleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ReElevatorBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator activated, press [{+Actionslot 4}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread ReEleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Reverse elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}

EleBind()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.UpEle = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.UpEle + (0,0,4);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}
 
 
ElevatorBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Elevator activated, press [{+Actionslot 1}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread EleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ElevatorBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Elevator activated, press [{+Actionslot 2}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread EleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ElevatorBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Elevator activated, press [{+Actionslot 3}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread EleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}
 
ElevatorBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Elevator))
        {
            self iprintln("Elevator activated, press [{+Actionslot 4}] to elevator");
            self.Elevator = true;
            while(isDefined(self.Elevator))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread EleBind();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Elevator))
        {
            self iprintln("Elevator Bind ^1Off");
            self.Elevator = undefined;
        }
    }
}

BlackFadeBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black activated, press [{+Actionslot 1}]");
            self.BlackBind = true;
            while(isDefined(self.BlackBind))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread fadeToBlack( 0.01, 0.3, 0.01, 0.3 );
                }
            wait .001;
            }
        }
        else if(isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black ^1Off");
            self.BlackBind = undefined;
        }
    }
}
 
BlackFadeBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black activated, press [{+Actionslot 2}]");
            self.BlackBind = true;
            while(isDefined(self.BlackBind))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread fadeToBlack( 0.01, 0.3, 0.01, 0.3 );
                }
            wait .001;
            }
        }
        else if(isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black ^1Off");
            self.BlackBind = undefined;
        }
    }
}
 
BlackFadeBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black activated, press [{+Actionslot 3}]");
            self.BlackBind = true;
            while(isDefined(self.BlackBind))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread fadeToBlack( 0.01, 0.3, 0.01, 0.3 );
                }
            wait .001;
            }
        }
        else if(isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black ^1Off");
            self.BlackBind = undefined;
        }
    }
}
 
BlackFadeBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black activated, press [{+Actionslot 4}]");
            self.BlackBind = true;
            while(isDefined(self.BlackBind))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread fadeToBlack( 0.01, 0.3, 0.01, 0.3 );
                }
            wait .001;
            }
        }
        else if(isDefined(self.BlackBind))
        {
            self iprintln("Fade to Black ^1Off");
            self.BlackBind = undefined;
        }
    }
}
 
 
WhiteFadeBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
    if(!isDefined(self.WhiteBind))
    {
        self iprintln("Fade to White activated, press [{+Actionslot 1}]");
        self.WhiteBind = true;
        while(isDefined(self.WhiteBind))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread fadeToWhite( 0.01, 0.3, 0.01, 0.3  );
            }
        wait .001;
        }
    }
        else if(isDefined(self.WhiteBind))
        {
            self iprintln("Fade to White ^1Off");
            self.WhiteBind = undefined;
        }
    }
}
 
WhiteFadeBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
    if(!isDefined(self.WhiteBind))
    {
        self iprintln("Fade to White activated, press [{+Actionslot 2}]");
        self.WhiteBind = true;
        while(isDefined(self.WhiteBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread fadeToWhite(  0.01, 0.3, 0.01, 0.3 );
            }
        wait .001;
        }
    }
        else if(isDefined(self.WhiteBind))
        {
            self iprintln("Fade to White ^1Off");
            self.WhiteBind = undefined;
        }
    }
}
 
WhiteFadeBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
    if(!isDefined(self.WhiteBind))
    {
        self iprintln("Fade to White activated, press [{+Actionslot 3}]");
        self.WhiteBind = true;
        while(isDefined(self.WhiteBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread fadeToWhite( 0.01, 0.3, 0.01, 0.3 );
            }
        wait .001;
        }
    }
        else if(isDefined(self.WhiteBind))
        {
            self iprintln("Fade to White ^1Off");
            self.WhiteBind = undefined;
        }
    }
}
 
WhiteFadeBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
    if(!isDefined(self.WhiteBind))
    {
        self iprintln("Fade to White activated, press [{+Actionslot 4}]");
        self.WhiteBind = true;
        while(isDefined(self.WhiteBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread fadeToWhite( 0.01, 0.3, 0.01, 0.3 );
            }
        wait .001;
        }
    }
        else if(isDefined(self.WhiteBind))
        {
            self iprintln("Fade to White ^1Off");
            self.WhiteBind = undefined;
        }
    }
}

fadeToBlack( startwait, blackscreenwait, fadeintime, fadeouttime )
{
    wait( startwait );
    if( !isdefined(self.blackscreen) )
    self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0; 
    self.blackscreen.horzAlign = "fullscreen";
    self.blackscreen.vertAlign = "fullscreen";
    self.blackscreen.foreground = false;
    self.blackscreen.hidewhendead = false;
    self.blackscreen.hidewheninmenu = true;

    self.blackscreen.sort = 50; 
    self.blackscreen SetShader( "black", 640, 480 ); 
    self.blackscreen.alpha = 0; 
    if( fadeintime>0 )
    self.blackscreen FadeOverTime( fadeintime ); 
    self.blackscreen.alpha = 1;
    wait( fadeintime );
    if( !isdefined(self.blackscreen) )
        return;

    wait( blackscreenwait );
    if( !isdefined(self.blackscreen) )
        return;

    if( fadeouttime>0 )
    self.blackscreen FadeOverTime( fadeouttime ); 
    self.blackscreen.alpha = 0; 
    wait( fadeouttime );

    if( isdefined(self.blackscreen) )           
    {
        self.blackscreen destroy();
        self.blackscreen = undefined;
    }
}

fadeToWhite( startwait, whitescreenwait, fadeintime, fadeouttime )
{
    wait( startwait );
    if( !isdefined(self.whitescreen) )
    self.whitescreen = newclienthudelem( self );
    self.whitescreen.x = 0;
    self.whitescreen.y = 0; 
    self.whitescreen.horzAlign = "fullscreen";
    self.whitescreen.vertAlign = "fullscreen";
    self.whitescreen.foreground = false;
    self.whitescreen.hidewhendead = false;
    self.whitescreen.hidewheninmenu = true;
    self.whitescreen.sort = 50; 
    self.whitescreen SetShader( "tow_filter_overlay_no_signal", 640, 480 ); 
    self.whitescreen.alpha = 0; 

    if( fadeintime > 0 )
    self.whitescreen FadeOverTime( fadeintime ); 
    self.whitescreen.alpha = 1; 
    wait( fadeintime );
    if( !isdefined(self.whitescreen) )
        return; 

    wait( whitescreenwait );
    if( !isdefined(self.whitescreen) )
        return;

    if( fadeouttime>0 )
    self.whitescreen FadeOverTime( fadeouttime ); 
    self.whitescreen.alpha = 0; 
    wait( fadeouttime );

    if( isdefined(self.whitescreen) )           
    {
        self.whitescreen destroy();
        self.whitescreen = undefined;
    }
}

Canzoom1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        self iPrintLn("Canzoom bind activated, press [{+Actionslot 1}]");
        self.Canzoom = true;
        while(isDefined(self.Canzoom))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread CanzoomFunction();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind ^1deactivated");
        self.Canzoom = undefined; 
    }
}

Canzoom2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        self iPrintLn("Canzoom bind activated, press [{+Actionslot 2}]");
        self.Canzoom = true;
        while(isDefined(self.Canzoom))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread CanzoomFunction();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind ^1deactivated");
        self.Canzoom = undefined; 
    }
}

Canzoom3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        self iPrintLn("Canzoom bind activated, press [{+Actionslot 3}]");
        self.Canzoom = true;
        while(isDefined(self.Canzoom))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread CanzoomFunction();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind ^1deactivated");
        self.Canzoom = undefined; 
    }
}

Canzoom4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        self iPrintLn("Canzoom bind activated, press [{+Actionslot 4}]");
        self.Canzoom = true;
        while(isDefined(self.Canzoom))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread CanzoomFunction();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind ^1deactivated");
        self.Canzoom = undefined; 
    }
}

CanzoomFunction()
{
    self.canswapWeap = self getCurrentWeapon();
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
}

DiscoCamo1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.discoCamo))
    {
        self iPrintLn("Disco camo bind activated, press [{+Actionslot 1}]");
        self.discoCamo = true;
        while(isDefined(self.discoCamo))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread DoCamoLoop();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.discoCamo)) 
    { 
        self iPrintLn("Disco camo bind ^1deactivated");
        self notify("Stop_CamoLoop");
        self.discoCamo = undefined; 
    }
}

DiscoCamo2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.discoCamo))
    {
        self iPrintLn("Disco camo bind activated, press [{+Actionslot 2}]");
        self.discoCamo = true;
        while(isDefined(self.discoCamo))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread DoCamoLoop();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.discoCamo)) 
    { 
        self iPrintLn("Disco camo bind ^1deactivated");
        self notify("Stop_CamoLoop");
        self.discoCamo = undefined; 
    }
}

DiscoCamo3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.discoCamo))
    {
        self iPrintLn("Disco camo bind activated, press [{+Actionslot 3}]");
        self.discoCamo = true;
        while(isDefined(self.discoCamo))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread DoCamoLoop();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.discoCamo)) 
    { 
        self iPrintLn("Disco camo bind ^1deactivated");
        self notify("Stop_CamoLoop");
        self.discoCamo = undefined; 
    }
}

DiscoCamo4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.discoCamo))
    {
        self iPrintLn("Disco camo bind activated, press [{+Actionslot 4}]");
        self.discoCamo = true;
        while(isDefined(self.discoCamo))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread DoCamoLoop();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.discoCamo)) 
    { 
        self iPrintLn("Disco camo bind ^1deactivated");
        self notify("Stop_CamoLoop");
        self.discoCamo = undefined; 
    }
}


DoCamoLoop()
{
    level endon("game_ended");
    self endon("death" );   
    if(!isDefined(self.DoingCamo))
    {
        self endon("Stop_CamoLoop");
        self.DoingCamo = true;
        for(;;)
        {
            rand = randomintrange(0, 16);
            weap = self getcurrentweapon();
            self takeweapon(weap);
            self giveweapon(weap, 0, rand, 0, 0, 0, 0);
            self setspawnweapon(weap);
            wait 0.001;
        }
        wait 0.001;
        
    }
    else
    {
        wait 0.01;
        self.DoingCamo = undefined;
        self notify("Stop_CamoLoop");
    }
}

saveCPdrop()
{
    self.DropZone = self.origin + (0,0,1150);
    self.DropZoneAngle = self.angle;
    self thread maps\mp\gametypes\_supplydrop::NewHeli( self.DropZone, "bruh", self, self.team);
    self iprintln("Carepackage drop zone ^2Saved");
}

DropDaCP1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CPDrop))
    {
        self iPrintLn("Drop carepackage bind activated, press [{+Actionslot 1}]");
        self.CPDrop = true;
        while(isDefined(self.CPDrop))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                level.DroppingCP = spawn("script_model" ,self.DropZone);  
                self thread maps\mp\gametypes\_supplydrop::dropcrate(self.DropZone ,self.DropZoneAngle , "supplydrop_mp" ,self ,self.team ,level.DroppingCP);
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.CPDrop)) 
    { 
        self iPrintLn("Drop carepackage bind ^1deactivated");
        self.CPDrop = undefined; 
    }
}

DropDaCP2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CPDrop))
    {
        self iPrintLn("Drop carepackage bind activated, press [{+Actionslot 2}]");
        self.CPDrop = true;
        while(isDefined(self.CPDrop))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                level.DroppingCP = spawn("script_model" ,self.DropZone);  
                self thread maps\mp\gametypes\_supplydrop::dropcrate(self.DropZone ,self.DropZoneAngle , "supplydrop_mp" ,self ,self.team ,level.DroppingCP);
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.CPDrop)) 
    { 
        self iPrintLn("Drop carepackage bind ^1deactivated");
        self.CPDrop = undefined; 
    }
}

DropDaCP3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CPDrop))
    {
        self iPrintLn("Drop carepackage bind activated, press [{+Actionslot 3}]");
        self.CPDrop = true;
        while(isDefined(self.CPDrop))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                level.DroppingCP = spawn("script_model" ,self.DropZone);  
                self thread maps\mp\gametypes\_supplydrop::dropcrate(self.DropZone ,self.DropZoneAngle , "supplydrop_mp" ,self ,self.team ,level.DroppingCP);
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.CPDrop)) 
    { 
        self iPrintLn("Drop carepackage bind ^1deactivated");
        self.CPDrop = undefined; 
    }
}

DropDaCP4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CPDrop))
    {
        self iPrintLn("Drop carepackage bind activated, press [{+Actionslot 4}]");
        self.CPDrop = true;
        while(isDefined(self.CPDrop))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                level.DroppingCP = spawn("script_model" ,self.DropZone);  
                self thread maps\mp\gametypes\_supplydrop::dropcrate(self.DropZone ,self.DropZoneAngle , "supplydrop_mp" ,self ,self.team ,level.DroppingCP);
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.CPDrop)) 
    { 
        self iPrintLn("Drop carepackage bind ^1deactivated");
        self.CPDrop = undefined; 
    }
}

IllusionReload1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.IllusionRe))
    {
        self iPrintLn("Illusion reload bind activated, press [{+Actionslot 1}]");
        self.IllusionRe = true;
        while(isDefined(self.IllusionRe))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            { 
                self thread doIllReload();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.IllusionRe)) 
    { 
        self iPrintLn("Illusion reload bind ^1deactivated");
        self.IllusionRe = undefined; 
    }
}

IllusionReload2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.IllusionRe))
    {
        self iPrintLn("Illusion reload bind activated, press [{+Actionslot 2}]");
        self.IllusionRe = true;
        while(isDefined(self.IllusionRe))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            { 
                self thread doIllReload();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.IllusionRe)) 
    { 
        self iPrintLn("Illusion reload bind ^1deactivated");
        self.IllusionRe = undefined; 
    }
}

IllusionReload3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.IllusionRe))
    {
        self iPrintLn("Illusion reload bind activated, press [{+Actionslot 3}]");
        self.IllusionRe = true;
        while(isDefined(self.IllusionRe))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            { 
                self thread doIllReload();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.IllusionRe)) 
    { 
        self iPrintLn("Illusion reload bind ^1deactivated");
        self.IllusionRe = undefined; 
    }
}

IllusionReload4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.IllusionRe))
    {
        self iPrintLn("Illusion reload bind activated, press [{+Actionslot 4}]");
        self.IllusionRe = true;
        while(isDefined(self.IllusionRe))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            { 
                self thread doIllReload();
            }
            wait .001;
        } 
    } 
    else if(isDefined(self.IllusionRe)) 
    { 
        self iPrintLn("Illusion reload bind ^1deactivated");
        self.IllusionRe = undefined; 
    }
}

doIllReload()
{
    self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip    = self getWeaponAmmoClip(self.EmptyWeap);
    WeapEmpStock     = self getWeaponAmmoStock(self.EmptyWeap);
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
    wait 0.05;
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip);
    self setspawnweapon(self.EmptyWeap);
}

InfCanswap()
{
    if(self.InfiniteCan == 0)
    {
      self.InfiniteCan = 1;
      self iprintln("Infinite Canswap ^2On");
      self thread doInfCan();
    }
    else
    {
      self.InfiniteCan = 0;
      self iprintln("Infinite Canswap ^1Off");
      self notify("stop_infCanswap");
    }
}

doInfCan()
{
    self endon("disconnect");
    self endon("stop_infCanswap");
    for(;;)
    {
        self waittill( "weapon_change", currentWeapon );
        currentWeapon = self getCurrentWeapon();
        self.WeapClip    = self getWeaponAmmoClip(currentWeapon);
        self.WeapStock     = self getWeaponAmmoStock(currentWeapon);
        self takeWeapon(currentWeapon);
        waittillframeend;
        self giveweapon(currentWeapon);
        self setweaponammostock(currentWeapon, self.WeapStock);
        self setweaponammoclip(currentWeapon, self.WeapClip);
    }
}

CoasterNBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 1}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterNorth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterNBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 2}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterNorth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterNBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 3}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterNorth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterNBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 4}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterNorth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterNorth()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.o = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.o + (0,6,0);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}

CoasterEBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 1}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterEast();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterEBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 2}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterEast();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterEBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 3}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterEast();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterEBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 4}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterEast();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterEast()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.o = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.o + (6,0,0);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}

CoasterSBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 1}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterSouth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterSBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 2}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterSouth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterSBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 3}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterSouth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterSBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 4}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterSouth();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterSouth()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.o = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.o + (0,-6,0);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}


CoasterWBind1()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 1}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterWest();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterWBind2()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 2}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterWest();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterWBind3()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 3}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterWest();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterWBind4()
{
    self endon("game_ended");
    self endon( "disconnect" );
    {
        if(!isDefined(self.Coaster))
        {
            self iprintln("Coaster activated, press [{+Actionslot 4}] to coaster");
            self.Coaster = true;
            while(isDefined(self.Coaster))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread CoasterWest();
                }
            wait .001;
            }
        }
        else if(isDefined(self.Coaster))
        {
            self iprintln("Coaster Bind ^1Off");
            self.Coaster = undefined;
        }
    }
}

CoasterWest()
{
    if(!isDefined(self.changle))
    {
        self endon("ebola");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            self.o = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.o + (-6,0,0);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("ebola");
    }
}

// shax swap 


ShaxWeapon(weap)
{
    if(weap == 1)
    {
        self iprintln("Shax Weapon Set to skorpion_mp");
        self.shaxGun = "skorpion_mp";
    }
    else if(weap == 2)
    {
        self iprintln("Shax Weapon Set to mac11_mp");
        self.shaxGun = "mac11_mp";
    }
    else if(weap == 3)
    {
        self iprintln("Shax Weapon Set to kiparis_mp");
        self.shaxGun = "kiparis_mp";
    }
    else if(weap == 4)
    {
        self iprintln("Shax Weapon Set to mpl_mp");
        self.shaxGun = "mpl_mp";
    }
    else if(weap == 5)
    {
        self iprintln("Shax Weapon Set to stoner63_mp");
        self.shaxGun = "stoner63_mp";
    }
    else if(weap == 6)
    {
        self iprintln("Shax Weapon Set to fnfal_mp");
        self.shaxGun = "fnfal_mp";
    }
    else if(weap == 7)
    {
        self iprintln("Shax Weapon Set to uzi_mp");
        self.shaxGun = "uzi_mp";
    }
    else if(weap == 8)
    {
        self iprintln("Shax Weapon Set to mp5k_mp");
        self.shaxGun = "mp5k_mp";
    }
    else if(weap == 9)
    {
        self iprintln("Shax Weapon Set to ak74u_mp");
        self.shaxGun = "ak74u_mp";
    }
    else if(weap == 10)
    {
        self iprintln("Shax Weapon Set to pm63_mp");
        self.shaxGun = "pm63_mp";
    }
    else if(weap == 11)
    {
        self iprintln("Shax Weapon Set to spectre_mp");
        self.shaxGun = "spectre_mp";
    }
    else if(weap == 12)
    {
        self iprintln("Shax Weapon Set to m16_mp");
        self.shaxGun = "m16_mp";
    }
    else if(weap == 13)
    {
        self iprintln("Shax Weapon Set to enfield_mp");
        self.shaxGun = "enfield_mp";
    }
    else if(weap == 14)
    {
        self iprintln("Shax Weapon Set to m14_mp");
        self.shaxGun = "m14_mp";
    }
    else if(weap == 15)
    {
        self iprintln("Shax Weapon Set to famas_mp");
        self.shaxGun = "famas_mp";
    }
    else if(weap == 16)
    {
        self iprintln("Shax Weapon Set to galil_mp");
        self.shaxGun = "galil_mp";
    }
    else if(weap == 17)
    {
        self iprintln("Shax Weapon Set to aug_mp");
        self.shaxGun = "aug_mp";
    }
    else if(weap == 18)
    {
        self iprintln("Shax Weapon Set to ak47_mp");
        self.shaxGun = "ak47_mp";
    }
    else if(weap == 19)
    {
        self iprintln("Shax Weapon Set to commando_mp");
        self.shaxGun = "commando_mp";
    }
    else if(weap == 20)
    {
        self iprintln("Shax Weapon Set to g11_mp");
        self.shaxGun = "g11_mp";
    }
    else if(weap == 21)
    {
        self iprintln("Shax Weapon Set to rottweil72_mp");
        self.shaxGun = "rottweil72_mp";
    }
    else if(weap == 22)
    {
        self iprintln("Shax Weapon Set to ithaca_grip_mp");
        self.shaxGun = "ithaca_grip_mp";
    }
    else if(weap == 23)
    {
        self iprintln("Shax Weapon Set to spas_mp");
        self.shaxGun = "spas_mp";
    }
    else if(weap == 24)
    {
        self iprintln("Shax Weapon Set to hs10_mp");
        self.shaxGun = "hs10_mp";
    }
    else if(weap == 25)
    {
        self iprintln("Shax Weapon Set to hk21_mp");
        self.shaxGun = "hk21_mp";
    }
    else if(weap == 26)
    {
        self iprintln("Shax Weapon Set to rpk_mp");
        self.shaxGun = "rpk_mp";
    }
    else if(weap == 27)
    {
        self iprintln("Shax Weapon Set to m60_mp");
        self.shaxGun = "m60_mp";
    }
    else if(weap == 28)
    {
        self iprintln("Shax Weapon Set to dragunov_mp");
        self.shaxGun = "dragunov_mp";
    }
    else if(weap == 29)
    {
        self iprintln("Shax Weapon Set to wa2000_mp");
        self.shaxGun = "wa2000_mp";
    }
    else if(weap == 30)
    {
        self iprintln("Shax Weapon Set to l96a1_mp");
        self.shaxGun = "l96a1_mp";
    }
    else if(weap == 31)
    {
        self iprintln("Shax Weapon Set to psg1_mp");
        self.shaxGun = "psg1_mp";
    }
    else if(weap == 32)
    {
        self iprintln("Shax Weapon Set to asp_mp");
        self.shaxGun = "asp_mp";
    }
    else if(weap == 33)
    {
        self iprintln("Shax Weapon Set to m1911_mp");
        self.shaxGun = "m1911_mp";
    }
    else if(weap == 34)
    {
        self iprintln("Shax Weapon Set to makarov_mp");
        self.shaxGun = "makarov_mp";
    }
    else if(weap == 35)
    {
        self iprintln("Shax Weapon Set to python_mp");
        self.shaxGun = "python_mp";
    }
    else if(weap == 36)
    {
        self iprintln("Shax Weapon Set to cz75_mp");
        self.shaxGun = "cz75_mp";
    }
    else if(weap == 37)
    {
        self iprintln("Shax Weapon Set to rpg_mp");
        self.shaxGun = "rpg_mp";
    }
    
}

shaxKCCheck()
{
    self.isNotShaxWeapon = false;
    if(isSubStr(self.shaxGun, "skorpion"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.4;
    }
    else if(isSubStr(self.shaxGun, "mp5k"))
    {
        self.shineShaxGunCheck = 0.9;
        self.shaxTakeaway = 0.46; 
    }
    else if(isSubStr(self.shaxGun, "ak74u"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.37;
    }
    else if(isSubStr(self.shaxGun, "pm63"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.26;
    }
    else if(isSubStr(self.shaxGun, "spectre"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.34;
    }
    else if(isSubStr(self.shaxGun, "mac11"))
    {
        self.shineShaxGunCheck = 0.9;
        self.shaxTakeaway = 0.41;
    }
    else if(isSubStr(self.shaxGun, "kiparis"))
    {
        self.shineShaxGunCheck = 0.78;
        self.shaxTakeaway = 0.4;
    }
    else if(isSubStr(self.shaxGun, "mpl"))
    {
        self.shineShaxGunCheck = 0.9;
        self.shaxTakeaway = 0.4;
    }
    else if(isSubStr(self.shaxGun, "uzi"))
    {
        self.shineShaxGunCheck = 0.85;
        self.shaxTakeaway = 0.58;
    }
    else if(isSubStr(self.shaxGun, "fnfal"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.45;
    }
    else if(isSubStr(self.shaxGun, "m16"))
    {
        self.shineShaxGunCheck = 0.8;
        self.shaxTakeaway = 0.32;
    }
    else if(isSubStr(self.shaxGun, "enfield"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.45;
    }
    else if(isSubStr(self.shaxGun, "m14"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.523;
    }
    else if(isSubStr(self.shaxGun, "famas"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.395;
    }
    else if(isSubStr(self.shaxGun, "galil"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.59;
    }
    else if(isSubStr(self.shaxGun, "aug"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.364;
    }
    else if(isSubStr(self.shaxGun, "ak47"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.43;
    }
    else if(isSubStr(self.shaxGun, "commando"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.22;
    }
    else if(isSubStr(self.shaxGun, "g11"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.43;
    }
    else if(isSubStr(self.shaxGun, "rottweil72"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.8;
    }
    else if(isSubStr(self.shaxGun, "ithaca"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.71;
    }
    else if(isSubStr(self.shaxGun, "spas"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 2.13;
    }
    else if(isSubStr(self.shaxGun, "hs10"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 1.04;
    }
    else if(isSubStr(self.shaxGun, "hk21"))
    {
        self.shineShaxGunCheck = 1.2;
        self.shaxTakeaway = 0.71;
    }
    else if(isSubStr(self.shaxGun, "rpk"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 1.5;
    }
    else if(isSubStr(self.shaxGun, "m60"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 3.2;
    }
    else if(isSubStr(self.shaxGun, "stoner63"))
    {
        self.shineShaxGunCheck = 1.2;
        self.shaxTakeaway = 0.55;
    }
    else if(isSubStr(self.shaxGun, "dragunov"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.53;
    }
    else if(isSubStr(self.shaxGun, "wa2000"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.57;
    }
    else if(isSubStr(self.shaxGun, "l96a1"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.55;
    }
    else if(isSubStr(self.shaxGun, "psg1"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 0.53;
    }
    else if(isSubStr(self.shaxGun, "asp"))
    {
        self.shineShaxGunCheck = 0.2;
        self.shaxTakeaway = 0.4;
    }
    else if(isSubStr(self.shaxGun, "m1911"))
    {
        self.shineShaxGunCheck = 0.2;
        self.shaxTakeaway = 0.7;
    }
    else if(isSubStr(self.shaxGun, "makarov"))
    {
        self.shineShaxGunCheck = 0.2;
        self.shaxTakeaway = 0.7;
    }
    else if(isSubStr(self.shaxGun, "python"))
    {
        self.shineShaxGunCheck = 1;
        self.shaxTakeaway = 1.83;
    }
    else if(isSubStr(self.shaxGun, "cz75"))
    {
        self.shineShaxGunCheck = 0.2;
        self.shaxTakeaway = 0.7;
    }
    else
    {
        self.isNotShaxWeapon = true;
        self.shineShaxGunCheck = 0;
        self.shaxTakeaway = 0;
    }
}


shaxKillcam()
{
    currentWeapon = self getcurrentWeapon();
    self thread shaxKCCheck();
    self giveweapon(self.shaxGun);
    self switchToWeapon(self.shaxGun);
    self setWeaponAmmoClip(self.shaxGun, 0);
    doIt = self getWeaponAmmoStock(self.shaxGun);
    wait 0.05;
    self setSpawnWeapon(self.shaxGun);
    wait self.shineShaxGunCheck;
    self setWeaponAmmoStock(self.shaxGun, doIt);
    wait self.shaxTakeaway;
    self takeweapon(self.shaxGun);
    wait 0.05;
    self switchToWeapon(currentWeapon);
}

doStaticScreen()
{
    self.staticScreeen = newclienthudelem( self );
    self.staticScreeen.x = 0;
    self.staticScreeen.y = 0; 
    self.staticScreeen.horzAlign = "fullscreen";
    self.staticScreeen.vertAlign = "fullscreen";
    self.staticScreeen.foreground = false;
    self.staticScreeen.hidewhendead = false;
    self.staticScreeen.hidewheninmenu = false;
    self.staticScreeen.sort = 0; 
    self.staticScreeen SetShader( "tow_filter_overlay_no_signal", 640, 480 ); 
    self.staticScreeen.alpha = 1;
    wait self.shineShaxGunCheck;
    self.staticScreeen destroy();
}

shaxStatic()
{
    currentWeapon = self getcurrentWeapon();
    self thread shaxKCCheck();
    self thread doStaticScreen();
    self giveweapon(self.shaxGun);
    self switchToWeapon(self.shaxGun);
    self setWeaponAmmoClip(self.shaxGun, 0);
    doIt = self getWeaponAmmoStock(self.shaxGun);
    wait 0.05;
    self setSpawnWeapon(self.shaxGun);
    wait self.shineShaxGunCheck;
    self setWeaponAmmoStock(self.shaxGun, doIt);
    wait self.shaxTakeaway;
    self takeweapon(self.shaxGun);
    wait 0.05;
    self switchToWeapon(currentWeapon);
}

ShaxSwap1()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 1}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxKillcam();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

ShaxSwap2()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 2}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxKillcam();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

ShaxSwap3()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 3}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxKillcam();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

ShaxSwap4()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 4}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxKillcam();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

StaticShaxSwap1()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 1}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotonebuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxStatic();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

StaticShaxSwap2()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 2}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslottwobuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxStatic();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

StaticShaxSwap3()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 3}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxStatic();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}

StaticShaxSwap4()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Shax))
        {
            self iprintln("Shax swap activated, press [{+Actionslot 4}] to shax");
            self.Shax = true;
            while(isDefined(self.Shax))
            {
                if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
                {
                    self thread shaxStatic();
                }
            wait .005;
            }
        }
        else if(isDefined(self.Shax))
        {
            self iprintln("Shax swap Bind ^1Off");
            self.Shax = undefined;
        }
    }
}


HelpfulBind()
{
    self endon( "disconnect" );
    {
        if(!isDefined(self.Help))
        {
            self.Help = true;
            while(isDefined(self.Help))
            {
                if(self adsbuttonpressed() && self meleebuttonpressed() && self GetStance() == "prone")
                {
                    self giveweapon("m60_ir_grip_mp");
                    waittillframeend;
                    self dropitem("m60_ir_grip_mp");
                    waittillframeend;
                    self thread maxequipment();
                    waittillframeend;
                    self maps\mp\gametypes\_hardpoints::giveKillstreak("rcbomb_mp");
                    waittillframeend;
                    self iprintln("Dropped ^1m60_ir_grip_mp");
                    self iprintln("Max Ammo ^1Given");
                    self iprintln("Carepackage ^1Given");
                    wait 1;
                }
                wait .005;
            }
        }
        else if(isDefined(self.Help))
        {
            self.Help = undefined;
        }
    }
    
}

SetCapStreak(CapStreak)
{
    self.streak = CapStreak;
    self iprintln("^1" + CapStreak + " ^7was set as your capture streak");
}

CaptureBind1()
{
    if(!isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture bind press [{+Actionslot 1}] to capture");
        self.Capture = true;
        while(isDefined(self.Capture))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread FakeCPCapture();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture Bind ^1Off");
        self.Capture = undefined;
    }
}

CaptureBind2()
{
    if(!isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture bind press [{+Actionslot 2}] to capture");
        self.Capture = true;
        while(isDefined(self.Capture))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread FakeCPCapture();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture Bind ^1Off");
        self.Capture = undefined;
    }
}

CaptureBind3()
{
    if(!isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture bind press [{+Actionslot 3}] to capture");
        self.Capture = true;
        while(isDefined(self.Capture))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread FakeCPCapture();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture Bind ^1Off");
        self.Capture = undefined;
    }
}

CaptureBind4()
{
    if(!isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture bind press [{+Actionslot 4}] to capture");
        self.Capture = true;
        while(isDefined(self.Capture))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread FakeCPCapture();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Capture))
    {
        self iprintln("Fake carepack capture Bind ^1Off");
        self.Capture = undefined;
    }
}

FakeCPCapture()
{
    self endon("death");
    self.ChangingKit = createSecondaryProgressBar();
    self.KitText = createSecondaryProgressBarText();
    for(i=0;i<36;i++)
    {
        self.ChangingKit updateBar(i / 35);
        self.KitText setText("Capturing Crate");
        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
        self.KitText setPoint("CENTER", "CENTER", 0, -100);
        self.ChangingKit.color     = (0, 0, 0);
        self.ChangingKit.bar.color = self.BarColor;
        self.ChangingKit.alpha     = 0.61;
        wait .001;
    }
    self.ChangingKit destroyElem();
    self.KitText destroyElem();
    self maps\mp\gametypes\_hardpoints::giveKillstreak(self.streak);
}

SetFakeNac(CapStreak)
{
    self.Nacstreak = CapStreak;
    self iprintln("^1" + CapStreak + " ^7was set as your capture streak");
}

CPStallBind1()
{
    if(!isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall bind press [{+Actionslot 1}] to stall");
        self.CPStall = true;
        while(isDefined(self.CPStall))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.Stalling))
                {
                    self.Stalling = true;
                    Stalled = spawn( "script_model", self.origin );
                    self PlayerLinkToDelta(Stalled);
                    self setClientDvar( "cg_drawgun", 0 );
                    self disableweapons();
                    self.ChangingKit = createSecondaryProgressBar();
                    self.KitText = createSecondaryProgressBarText();
                    for(i=0;i<37;i++)
                    {
                        self.ChangingKit updateBar(i / 36);
                        self.KitText setText("Capturing Crate");
                        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
                        self.KitText setPoint("CENTER", "CENTER", 0, -100);
                        self.ChangingKit.color     = (0, 0, 0);
                        self.ChangingKit.bar.color = self.BarColor;
                        self.ChangingKit.alpha     = 0.61;
                        wait 0.0000001;
                    }
                    self setClientDvar( "cg_drawgun", 1 );
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self maps\mp\gametypes\_hardpoints::giveKillstreak(self.Nacstreak);
                    self enableweapons();
                    self unlink();
                    self.Stalling = undefined;
                    wait 0.01;
                }
                else if(isDefined(self.Stalling))
                {
                    
                    self iprintln("disabled");
                    self unlink();
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self enableweapons();
                    self.Stalling = undefined;
                    wait 0.005;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall Bind ^1Off");
        self.CPStall = undefined;
    }
}

CPStallBind2()
{
    if(!isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall bind press [{+Actionslot 2}] to stall");
        self.CPStall = true;
        while(isDefined(self.CPStall))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.Stalling))
                {
                    self.Stalling = true;
                    Stalled = spawn( "script_model", self.origin );
                    self PlayerLinkToDelta(Stalled);
                    self setClientDvar( "cg_drawgun", 0 );
                    self disableweapons();
                    self.ChangingKit = createSecondaryProgressBar();
                    self.KitText = createSecondaryProgressBarText();
                    for(i=0;i<37;i++)
                    {
                        self.ChangingKit updateBar(i / 36);
                        self.KitText setText("Capturing Crate");
                        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
                        self.KitText setPoint("CENTER", "CENTER", 0, -100);
                        self.ChangingKit.color     = (0, 0, 0);
                        self.ChangingKit.bar.color = self.BarColor;
                        self.ChangingKit.alpha     = 0.61;
                        wait 0.0000001;
                    }
                    self setClientDvar( "cg_drawgun", 1 );
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self maps\mp\gametypes\_hardpoints::giveKillstreak(self.Nacstreak);
                    self enableweapons();
                    self unlink();
                    self.Stalling = undefined;
                    wait 0.01;
                }
                else if(isDefined(self.Stalling))
                {
                    
                    self iprintln("disabled");
                    self unlink();
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self enableweapons();
                    self.Stalling = undefined;
                    wait 0.005;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall Bind ^1Off");
        self.CPStall = undefined;
    }
}

CPStallBind3()
{
    if(!isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall bind press [{+Actionslot 3}] to stall");
        self.CPStall = true;
        while(isDefined(self.CPStall))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.Stalling))
                {
                    self.Stalling = true;
                    Stalled = spawn( "script_model", self.origin );
                    self PlayerLinkToDelta(Stalled);
                    self setClientDvar( "cg_drawgun", 0 );
                    self disableweapons();
                    self.ChangingKit = createSecondaryProgressBar();
                    self.KitText = createSecondaryProgressBarText();
                    for(i=0;i<37;i++)
                    {
                        self.ChangingKit updateBar(i / 36);
                        self.KitText setText("Capturing Crate");
                        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
                        self.KitText setPoint("CENTER", "CENTER", 0, -100);
                        self.ChangingKit.color     = (0, 0, 0);
                        self.ChangingKit.bar.color = self.BarColor;
                        self.ChangingKit.alpha     = 0.61;
                        wait 0.0000001;
                    }
                    self setClientDvar( "cg_drawgun", 1 );
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self maps\mp\gametypes\_hardpoints::giveKillstreak(self.Nacstreak);
                    self enableweapons();
                    self unlink();
                    self.Stalling = undefined;
                    wait 0.01;
                }
                else if(isDefined(self.Stalling))
                {
                    
                    self iprintln("disabled");
                    self unlink();
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self enableweapons();
                    self.Stalling = undefined;
                    wait 0.005;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall Bind ^1Off");
        self.CPStall = undefined;
    }
}

CPStallBind4()
{
    if(!isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall bind press [{+Actionslot 4}] to stall");
        self.CPStall = true;
        while(isDefined(self.CPStall))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.Stalling))
                {
                    self.Stalling = true;
                    Stalled = spawn( "script_model", self.origin );
                    self PlayerLinkToDelta(Stalled);
                    self setClientDvar( "cg_drawgun", 0 );
                    self disableweapons();
                    self.ChangingKit = createSecondaryProgressBar();
                    self.KitText = createSecondaryProgressBarText();
                    for(i=0;i<37;i++)
                    {
                        self.ChangingKit updateBar(i / 36);
                        self.KitText setText("Capturing Crate");
                        self.ChangingKit setPoint("CENTER", "CENTER", 0, -85);
                        self.KitText setPoint("CENTER", "CENTER", 0, -100);
                        self.ChangingKit.color     = (0, 0, 0);
                        self.ChangingKit.bar.color = self.BarColor;
                        self.ChangingKit.alpha     = 0.61;
                        wait 0.0000001;
                    }
                    self setClientDvar( "cg_drawgun", 1 );
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self maps\mp\gametypes\_hardpoints::giveKillstreak(self.Nacstreak);
                    self enableweapons();
                    self unlink();
                    self.Stalling = undefined;
                    wait 0.01;
                }
                else if(isDefined(self.Stalling))
                {
                    
                    self iprintln("disabled");
                    self unlink();
                    self.ChangingKit destroyElem();
                    self.KitText destroyElem();
                    self enableweapons();
                    self.Stalling = undefined;
                    wait 0.005;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.CPStall))
    {
        self iprintln("Fake carepack stall Bind ^1Off");
        self.CPStall = undefined;
    }
}


InvisibleWeap1()
{
    if(!isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind press [{+Actionslot 1}]");
        self.InvisWeap = true;
        while(isDefined(self.InvisWeap))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NotSeen))
                {
                    self setClientDvar( "cg_drawgun", 0 );
                    self.NotSeen = true;
                    wait 0.01;
                }
                else if(isDefined(self.NotSeen))
                {
                    
                    self setClientDvar( "cg_drawgun", 1 );
                    self.NotSeen = undefined;
                    wait 0.01;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind ^1Off");
        self.InvisWeap = undefined;
    }
}

InvisibleWeap2()
{
    if(!isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind press [{+Actionslot 2}]");
        self.InvisWeap = true;
        while(isDefined(self.InvisWeap))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NotSeen))
                {
                    self setClientDvar( "cg_drawgun", 0 );
                    self.NotSeen = true;
                    wait 0.01;
                }
                else if(isDefined(self.NotSeen))
                {
                    
                    self setClientDvar( "cg_drawgun", 1 );
                    self.NotSeen = undefined;
                    wait 0.01;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind ^1Off");
        self.InvisWeap = undefined;
    }
}

InvisibleWeap3()
{
    if(!isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind press [{+Actionslot 3}]");
        self.InvisWeap = true;
        while(isDefined(self.InvisWeap))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NotSeen))
                {
                    self setClientDvar( "cg_drawgun", 0 );
                    self.NotSeen = true;
                    wait 0.01;
                }
                else if(isDefined(self.NotSeen))
                {
                    
                    self setClientDvar( "cg_drawgun", 1 );
                    self.NotSeen = undefined;
                    wait 0.01;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind ^1Off");
        self.InvisWeap = undefined;
    }
}

InvisibleWeap4()
{
    if(!isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind press [{+Actionslot 4}]");
        self.InvisWeap = true;
        while(isDefined(self.InvisWeap))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                if(!isDefined(self.NotSeen))
                {
                    self setClientDvar( "cg_drawgun", 0 );
                    self.NotSeen = true;
                    wait 0.01;
                }
                else if(isDefined(self.NotSeen))
                {
                    
                    self setClientDvar( "cg_drawgun", 1 );
                    self.NotSeen = undefined;
                    wait 0.01;
                }
                
            }
            wait .005;
        }
    }
    else if(isDefined(self.InvisWeap))
    {
        self iprintln("Invisible weapon bind ^1Off");
        self.InvisWeap = undefined;
    }
}

deathb()
{
    array=getEntArray("trigger_hurt","classname");
    if(!isDefined(level.disableDeathBarriers))
    {
        for(m=0;m < array.size;m++)array[m].origin+=(0,100000,0);
        level.disableDeathBarriers=true;
    }
    self iprintln("Death barriers removed");
}

saveBoltPos()
{
    self.pers["poscount"] += 1;
    self.pers["boltorigin"][self.pers["poscount"]] = self GetOrigin();
    self iPrintLn("Position ^2#" + self.pers["poscount"] + " ^7saved: " + self.origin);
}

DeleteBoltPos()
{
    if(self.pers["poscount"] == 0)
    {
        self iPrintLn("^1There are no points to delete");
    }
    else
    {
        self.pers["boltorigin"][self.pers["poscount"]] = undefined;
        self iPrintLn("Position ^2#" + self.pers["poscount"] + " ^7deleted");
        self.pers["poscount"] -= 1;
    }
}

BoltStart()
{
    self endon("detachBolt");
    self endon("disconnect");
    if(!self.MenuOpen && !self.isBolting)
    {
        if(self.pers["poscount"] == 0)
        {
            self iPrintLn("^1There aren't any points to move to...");
        }
        boltModel = spawn("script_model", self.origin);
        boltModel setModel("tag_origin");
        self.isBolting = true;
        setDvar("cg_nopredict", 1);
        wait 0.05;
        self linkTo(boltModel);
        self thread WatchJumping(boltModel);
        for(i=1; i < self.pers["poscount"] + 1 ; i++)
        {
            boltModel moveTo(self.pers["boltorigin"][i],getDvarInt("AntigaSpeed")/self.pers["poscount"], 0, 0);
            wait(getDvarInt("AntigaSpeed") / self.pers["poscount"]);
        }
        self unlink();
        boltModel delete();
        self.isBolting = false;
        setDvar("cg_nopredict", 0);
    }
}

WatchJumping(model)
{
	self endon("disconnect");
    if(self jumpbuttonpressed() || self changeseatbuttonpressed())
    {
        self Unlink();
        model delete();
        self.isBolting = false;
        self notify("detachBolt");
        setDvar("cg_nopredict", 0);
    }
}

BoltSpeed(amount)
{
    setDvar("AntigaSpeed", amount);
	self iPrintLn("Bolt Speed Changed To: ^2" + amount);
}


AntigaBind1()
{
    if(!isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind press [{+Actionslot 1}]");
        self.Antiga = true;
        while(isDefined(self.Antiga))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread BoltStart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind ^1Off");
        self.Antiga = undefined;
    }
}

AntigaBind2()
{
    if(!isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind press [{+Actionslot 2}]");
        self.Antiga = true;
        while(isDefined(self.Antiga))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread BoltStart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind ^1Off");
        self.Antiga = undefined;
    }
}

AntigaBind3()
{
    if(!isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind press [{+Actionslot 3}]");
        self.Antiga = true;
        while(isDefined(self.Antiga))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread BoltStart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind ^1Off");
        self.Antiga = undefined;
    }
}

AntigaBind4()
{
    if(!isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind press [{+Actionslot 4}]");
        self.Antiga = true;
        while(isDefined(self.Antiga))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread BoltStart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.Antiga))
    {
        self iprintln("Bolt Movement Bind ^1Off");
        self.Antiga = undefined;
    }
}

RoachShax1()
{
    if(!isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind press [{+Actionslot 1}]");
        self.RoachShax = true;
        while(isDefined(self.RoachShax))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread shaxstart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind ^1Off");
        self.RoachShax = undefined;
    }
}

RoachShax2()
{
    if(!isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind press [{+Actionslot 2}]");
        self.RoachShax = true;
        while(isDefined(self.RoachShax))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread shaxstart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind ^1Off");
        self.RoachShax = undefined;
    }
}

RoachShax3()
{
    if(!isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind press [{+Actionslot 3}]");
        self.RoachShax = true;
        while(isDefined(self.RoachShax))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread shaxstart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind ^1Off");
        self.RoachShax = undefined;
    }
}

RoachShax4()
{
    if(!isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind press [{+Actionslot 4}]");
        self.RoachShax = true;
        while(isDefined(self.RoachShax))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread shaxstart();
            }
        wait .005;
        }
    }
    else if(isDefined(self.RoachShax))
    {
        self iprintln("Real Shax Bind ^1Off");
        self.RoachShax = undefined;
    }
}

shaxstart()
{
    SetTimeScale( 20, getTime() + 1);
    self.prevelocity = self getVelocity();
    setDvar ("cg_drawGun", 0);
    self thread shaxmodel();
    self thread shaxammo();
    self disableWeapons();
    wait .005;
    self enableWeapons();
    self thread shaxtiming();
}

shaxmodel()
{
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkToDelta(shaxMODEL);
    self waittill ("finishedshax");
    waittillframeend;
    self unlink();
    shaxMODEL Destroy();
    shaxMODEL Delete(); 
    wait .005;
    self SetVelocity(((self.prevelocity[0] / 2), (self.prevelocity[1] / 2), (self.prevelocity[2] / 4)));
}

shaxammo()
{
    self endon ("finishedshax");
    self.shaxwep = self getCurrentweapon();
    ammoW1 = self getWeaponAmmoClip( self.shaxwep );
    ammoW2 = self getWeaponAmmostock( self.shaxwep );
    self setweaponammoclip( self.shaxwep, 0 );
    self setweaponammostock( self.shaxwep, ammoW2 + ammoW1);
    wait .005;
}

shaxtiming(shaxWait)
{
    if(isSubStr(self.shaxwep, "skorpion"))   
    {
        self.shaxWait = 0.524;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "mac11"))   
    {
        self.shaxWait = 0.425;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "uzi"))   
    {
        self.shaxWait = 0.46;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "pm63"))   
    {
        self.shaxWait = 0.435;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "mpl"))   
    {
        self.shaxWait = 0.435;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "spectre"))   
    {
        self.shaxWait = 0.51;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "kiparis"))   
    {
        self.shaxWait = 0.5;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m16"))   
    {
        self.shaxWait = 0.47;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "enfield"))   
    {
        self.shaxWait = 0.5;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m14"))   
    {
        self.shaxWait = 0.58;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "famas"))   
    {
        self.shaxWait = 0.555;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "galil"))   
    {
        self.shaxWait = 0.595;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "aug"))   
    {
        self.shaxWait = 0.524;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "fnfal"))   
    {
        self.shaxWait = 0.5425;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "ak47"))   
    {
        self.shaxWait = 0.5425;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "commando"))   
    {
        self.shaxWait = 0.5;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "g11"))   
    {
        self.shaxWait = 0.555;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "hk21"))   
    {
        self.shaxWait = 0.865;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "rpk"))   
    {
        self.shaxWait = 1.0425;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m60"))   
    {
        self.shaxWait = 1.935;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "stoner63"))   
    {
        self.shaxWait = 0.7675;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "dragunov"))   
    {
        self.shaxWait = 0.65525;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "wa2000"))   
    {
        self.shaxWait = 0.7055;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "l96a1"))   
    {
        self.shaxWait = 0.67255;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "psg1"))   
    {
        self.shaxWait = 0.69725;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "asp"))   
    {
        self.shaxWait = 0.23;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m1911"))   
    {
        self.shaxWait = 0.3;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "makarov"))   
    {
        self.shaxWait = 0.3;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "python"))   
    {
        self.shaxWait = 1.26;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "cz75"))   
    {
        self.shaxWait = 0.26;
        self thread shaxenddvars();
    }
    else
    {
        self thread shaxenddvars();
    }

}

shaxenddvars()
{
    wait (self.shaxWait - 0.05);
    SetTimeScale( 1, getTime() + 1 );
    waittillframeend;
    setDvar ("cg_drawGun", 1);
    self notify ("finishedshax");
}


WhatGun()
{
    primary = self getcurrentweapon();
    self iprintln("this gun is ^4 " + primary);
}

SelfDamageAmount(num)
{
    self.pers["SelfDamage"] = num;
    self iPrintLn("Damage set to " + num);
}

DamageBind1()
{
    if(!isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind press [{+Actionslot 1}]");
        self.DamageBind = true;
        while(isDefined(self.DamageBind))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread [[level.callbackPlayerDamage]]( self, self, self.pers["SelfDamage"], 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind ^1Off");
        self.DamageBind = undefined;
    }
}

DamageBind2()
{
    if(!isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind press [{+Actionslot 2}]");
        self.DamageBind = true;
        while(isDefined(self.DamageBind))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread [[level.callbackPlayerDamage]]( self, self, self.pers["SelfDamage"], 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind ^1Off");
        self.DamageBind = undefined;
    }
}

DamageBind3()
{
    if(!isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind press [{+Actionslot 3}]");
        self.DamageBind = true;
        while(isDefined(self.DamageBind))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread [[level.callbackPlayerDamage]]( self, self, self.pers["SelfDamage"], 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind ^1Off");
        self.DamageBind = undefined;
    }
}

DamageBind4()
{
    if(!isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind press [{+Actionslot 4}]");
        self.DamageBind = true;
        while(isDefined(self.DamageBind))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread [[level.callbackPlayerDamage]]( self, self, self.pers["SelfDamage"], 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageBind))
    {
        self iprintln("Damage Bind ^1Off");
        self.DamageBind = undefined;
    }
}

DamageRepeater()
{
    self.canswapWeap = self getCurrentWeapon();
    self.WeapClip    = self getWeaponAmmoClip(self.canswapWeap);
    self.WeapStock     = self getWeaponAmmoStock(self.canswapWeap);
    self thread [[level.callbackPlayerDamage]]( self, self, self.pers["SelfDamage"], 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
    wait 0.05;
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    self setweaponammostock(self.canswapWeap, self.WeapStock);
    self setweaponammoclip(self.canswapWeap, self.WeapClip);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
    
}

DamageRepeaterBind1()
{
    if(!isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind press [{+Actionslot 1}]");
        self.DamageRepeater = true;
        while(isDefined(self.DamageRepeater))
        {
            if(self actionslotonebuttonpressed() && self.MenuOpen == false)
            {
                self thread DamageRepeater();
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind ^1Off");
        self.DamageRepeater = undefined;
    }
}

DamageRepeaterBind2()
{
    if(!isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind press [{+Actionslot 2}]");
        self.DamageRepeater = true;
        while(isDefined(self.DamageRepeater))
        {
            if(self actionslottwobuttonpressed() && self.MenuOpen == false)
            {
                self thread DamageRepeater();
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind ^1Off");
        self.DamageRepeater = undefined;
    }
}

DamageRepeaterBind3()
{
    if(!isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind press [{+Actionslot 3}]");
        self.DamageRepeater = true;
        while(isDefined(self.DamageRepeater))
        {
            if(self actionslotthreebuttonpressed() && self.MenuOpen == false)
            {
                self thread DamageRepeater();
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind ^1Off");
        self.DamageRepeater = undefined;
    }
}

DamageRepeaterBind4()
{
    if(!isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind press [{+Actionslot 4}]");
        self.DamageRepeater = true;
        while(isDefined(self.DamageRepeater))
        {
            if(self actionslotfourbuttonpressed() && self.MenuOpen == false)
            {
                self thread DamageRepeater();
            }
        wait .005;
        }
    }
    else if(isDefined(self.DamageRepeater))
    {
        self iprintln("Damage Repeater Bind ^1Off");
        self.DamageRepeater = undefined;
    }
}

SwapKillcamSlowDown()
{
    if(level.DefaultKillcam == 0)
    {
        self iprintln("^1Killcam Slowmo Is Slow On and After Death");
        level.DefaultKillcam = 1;
    }
    else if(level.DefaultKillcam == 1)
    {
        self iprintln("^1Killcam Slowmo Is Slower Overall");
        level.DefaultKillcam = 2;
    }
    else if(level.DefaultKillcam == 2)
    {
        self iprintln("^2Killcam Slowmo Is Now Default");
        level.DefaultKillcam = 0;
    }
}