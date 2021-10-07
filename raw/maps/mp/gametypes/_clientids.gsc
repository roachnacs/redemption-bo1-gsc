#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level thread onPlayerConnect();
	setDvar("sv_cheats", 1);
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
				self.Menu.System["MenuCurser"] = 0;
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
			wait.2;
		}
		else if (self actionslottwobuttonpressed() && self.MenuOpen == true)
		{
			self.Menu.System["MenuCurser"] += 1;
			if (self.Menu.System["MenuCurser"] >= self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size)
			{
				self.Menu.System["MenuCurser"] = 0;
			}
			self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
			wait.2;
		}
		else if(self usebuttonpressed() && self.MenuOpen == true)
		{
		        wait 0.2;
			    if(self.Menu.System["MenuRoot"]=="Clients Menu") self.Menu.System["ClientIndex"]=self.Menu.System["MenuCurser"];
				self thread [[self.Menu.System["MenuFunction"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]]](self.Menu.System["MenuInput"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
				wait 0.2;
		}
		wait 0.05;
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
	self MenuOption("redemption", 4, "visions menu", ::SubMenu, "visions menu");
	self MenuOption("redemption", 5, "camo menu", ::SubMenu, "camo menu");
	self MenuOption("redemption", 6, "weapons menu", ::SubMenu, "weapons menu");
	self MenuOption("redemption", 7, "aimbot menu", ::SubMenu, "aimbot menu");
	self MenuOption("redemption", 8, "trickshot menu", ::SubMenu, "trickshot menu");
	self MenuOption("redemption", 9, "binds menu", ::SubMenu, "binds menu");
	self MenuOption("redemption", 10, "bots menu", ::SubMenu, "bots menu");
	self MenuOption("redemption", 11, "admin menu", ::SubMenu, "admin menu");
	self MenuOption("redemption", 12, "clients menu", ::SubMenu, "clients menu");
	self MenuOption("redemption", 13, "dev menu", ::SubMenu, "dev menu");
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
	self MenuOption("main menu", 16, "suicide", ::forceLastStand);
	
	self MainMenu("teleport menu", "redemption");
	self MenuOption("teleport menu", 0, "save position", ::savePosition);
	self MenuOption("teleport menu", 1, "load position", ::loadPosition);
	self MenuOption("teleport menu", 2, "load position on spawn", ::LoadLocationOnSpawn);
	self MenuOption("teleport menu", 3, "save and load bind", ::saveandload);
	self MenuOption("teleport menu", 4, "teleport gun", ::TeleportGun);
	self MenuOption("teleport menu", 5, "save look direction", ::saveAngle);
	self MenuOption("teleport menu", 6, "set look direction", ::setAngle);
	self MenuOption("teleport menu", 7, "map teleports", ::SubMenu, "map teleports");
	
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
	self MenuOption("spawning menu", 5, "forge mod", ::forgeon);
	
	self MainMenu("aimbot menu", "redemption");
	self MenuOption("aimbot menu", 0, "unfair aimbot", ::doUnfair);
	self MenuOption("aimbot menu", 1, "activate eb", ::doRadiusAimbot);
	self MenuOption("aimbot menu", 2, "select eb range", ::aimbotRadius);
	self MenuOption("aimbot menu", 3, "select eb delay", ::aimbotDelay);
	self MenuOption("aimbot menu", 4, "select eb weapon", ::aimbotWeapon);
	self MenuOption("aimbot menu", 5, "activate tag eb", ::HmAimbot);
	self MenuOption("aimbot menu", 6, "select tag eb range", ::HMaimbotRadius);
	self MenuOption("aimbot menu", 7, "select tag eb delay", ::HMaimbotDelay);
	self MenuOption("aimbot menu", 8, "select tag eb weapon", ::HMaimbotWeapon);

	self MainMenu("trickshot menu", "redemption");
	self MenuOption("trickshot menu", 0, "change end game settings", ::MW2EndGame);
	self MenuOption("trickshot menu", 1, "give cowboy", ::doCowboy);
	self MenuOption("trickshot menu", 2, "give lowered gun", ::doReverseCowboy);
	self MenuOption("trickshot menu", 3, "upside down screen", ::doUpsideDown); 
	self MenuOption("trickshot menu", 4, "tilt screen right", ::doTiltRight);
	self MenuOption("trickshot menu", 5, "tilt screen left", ::doTiltLeft);
	self MenuOption("trickshot menu", 6, "disable bomb pickup", ::DisableBomb);
	self MenuOption("trickshot menu", 7, "rmala options", ::SubMenu, "rmala options");
	self MenuOption("trickshot menu", 8, "after hit menu", ::SubMenu, "after hit"); 
	
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
	self MenuOption("binds menu", 15, "Page 2 --->", ::SubMenu, "binds page 2 menu");
	
	self MainMenu("binds page 2 menu", "binds menu");
	self MenuOption("binds page 2 menu", 0, "empty clip bind", ::SubMenu, "empty clip bind");
	self MenuOption("binds page 2 menu", 1, "fake scav bind", ::SubMenu, "fake scav bind");
	self MenuOption("binds page 2 menu", 2, "last stand bind", ::SubMenu, "last stand bind");
	
	self MainMenu("tilt screen bind", "binds menu");
    self MenuOption("tilt screen bind", 0, "tilt screen [{+Actionslot 1}]", ::TiltBind1);
    self MenuOption("tilt screen bind", 1, "tilt screen [{+Actionslot 4}]", ::TiltBind4);
    self MenuOption("tilt screen bind", 2, "tilt screen [{+Actionslot 2}]", ::TiltBind2);
    self MenuOption("tilt screen bind", 3, "tilt screen [{+Actionslot 3}]", ::TiltBind3);
	
	self MainMenu("last stand bind", "binds page 2 menu");
    self MenuOption("last stand bind", 0, "last stand [{+Actionslot 1}]", ::LastStandBind1);
    self MenuOption("last stand bind", 1, "last stand [{+Actionslot 4}]", ::LastStandBind4);
    self MenuOption("last stand bind", 2, "last stand [{+Actionslot 2}]", ::LastStandBind2);
    self MenuOption("last stand bind", 3, "last stand [{+Actionslot 3}]", ::LastStandBind3);
	
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
	self MenuOption("OMA bind", 2, "single OMA bind", ::SubMenu, "single OMA");
	self MenuOption("OMA bind", 3, "double OMA bind", ::SubMenu, "double OMA");
	self MenuOption("OMA bind", 4, "triple OMA bind", ::SubMenu, "triple OMA");
	
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
	
	self MainMenu("OMA colors", "OMA bind");
	self MenuOption("OMA colors", 0, "blue", ::ChangeBarColor, "blue");
	self MenuOption("OMA colors", 1, "red", ::ChangeBarColor, "red");
	self MenuOption("OMA colors", 2, "yellow", ::ChangeBarColor, "yellow");
	self MenuOption("OMA colors", 3, "green", ::ChangeBarColor, "green");
	self MenuOption("OMA colors", 4, "cyan", ::ChangeBarColor, "cyan");
	self MenuOption("OMA colors", 5, "pink", ::ChangeBarColor, "pink");
	self MenuOption("OMA colors", 6, "black", ::ChangeBarColor, "black");
	self MenuOption("OMA colors", 7, "lime", ::ChangeBarColor, "lime");
	self MenuOption("OMA colors", 8, "normal", ::ChangeBarColor, "normal");

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
	self MenuOption("bolt movement bind", 3, "save bolt position 4", ::savebolt4);
	self MenuOption("bolt movement bind", 4, "change bolt movement speed", ::SubMenu, "bolt movement speed");
	self MenuOption("bolt movement bind", 5, "single bolt movement", ::SubMenu, "bolt movement");
	self MenuOption("bolt movement bind", 6, "double bolt movement", ::SubMenu, "double bolt movement");
	self MenuOption("bolt movement bind", 7, "triple bolt movement", ::SubMenu, "triple bolt movement");
	self MenuOption("bolt movement bind", 8, "quad bolt movement", ::SubMenu, "quad bolt movement");
	
	self MainMenu("bolt movement speed", "bolt movement bind");
    self MenuOption("bolt movement speed", 0, "changed to 1 seconds", ::changeBoltSpeed, 1);
    self MenuOption("bolt movement speed", 1, "changed to 2 seconds", ::changeBoltSpeed, 2);
    self MenuOption("bolt movement speed", 2, "changed to 3 seconds", ::changeBoltSpeed, 3);
    self MenuOption("bolt movement speed", 3, "changed to 4 seconds", ::changeBoltSpeed, 4);
	self MenuOption("bolt movement speed", 4, "changed to 5 seconds", ::changeBoltSpeed, 5);
	
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
	
	self MainMenu("quad bolt movement", "bolt movement bind");
    self MenuOption("quad bolt movement", 0, "quad bolt movement [{+Actionslot 1}]", ::tripleboltmovement1);
    self MenuOption("quad bolt movement", 1, "quad bolt movement [{+Actionslot 4}]", ::tripleboltmovement4);
    self MenuOption("quad bolt movement", 2, "quad bolt movement [{+Actionslot 2}]", ::tripleboltmovement2);
    self MenuOption("quad bolt movement", 3, "quad bolt movement [{+Actionslot 3}]", ::tripleboltmovement3);
	
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
	
	self MainMenu("rmala options", "binds menu");
	self MenuOption("rmala options", 0, "change rmala equipment", ::CycleRmala);
    self MenuOption("rmala options", 1, "save rmala weapon", ::SaveMalaWeapon);
	self MenuOption("rmala options", 2, "toggle rmala (with shots)", ::doMalaMW2);
	self MenuOption("rmala options", 3, "toggle rmala (with flicker)", ::DoMW2MalaFlick);
	
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
    self MenuOption("weapons menu", 2, "refill ammo", ::maxammoweapon);
    self MenuOption("weapons menu", 3, "refill equipment", ::maxequipment);
    self MenuOption("weapons menu", 4, "drop canswap", ::dropcan);
    self MenuOption("weapons menu", 5, "submachine gun", ::SubMenu, "submachine guns");
    self MenuOption("weapons menu", 6, "assault rifles", ::SubMenu, "assault rifles");
    self MenuOption("weapons menu", 7, "shotguns", ::SubMenu, "shotguns");
    self MenuOption("weapons menu", 8, "light machine guns", ::SubMenu, "light machine guns");
    self MenuOption("weapons menu", 9, "sniper rifles", ::SubMenu, "snipers");
	self MenuOption("weapons menu", 10, "pistols", ::SubMenu, "pistols");
	self MenuOption("weapons menu", 11, "launchers", ::SubMenu, "launchers");
	self MenuOption("weapons menu", 12, "specials", ::SubMenu, "specials");
	self MenuOption("weapons menu", 13, "super specials", ::SubMenu, "super specials");
	
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
    self MenuOption("super specials", 0, "Default Weapon", ::GivePlayerWeapon, "defaultweapon_mp");
    self MenuOption("super specials", 1, "Syrette", ::GivePlayerWeapon, "syrette_mp");
    self MenuOption("super specials", 2, "Carepackage", ::GivePlayerWeapon, "supplydrop_mp");
    self MenuOption("super specials", 3, "Minigun", ::GivePlayerWeapon, "minigun_mp");
    self MenuOption("super specials", 4, "Claymore", ::GivePlayerWeapon, "claymore_mp");
    self MenuOption("super specials", 5, "Scrambler", ::GivePlayerWeapon, "scrambler_mp");
    self MenuOption("super specials", 6, "Jammer", ::GivePlayerWeapon, "scavenger_item_mp");
    self MenuOption("super specials", 7, "Tac", ::GivePlayerWeapon, "tactical_insertion_mp");
    self MenuOption("super specials", 8, "Sensor", ::GivePlayerWeapon, "acoustic_sensor_mp");
    self MenuOption("super specials", 9, "Camera", ::GivePlayerWeapon, "camera_spike_mp");
    self MenuOption("super specials", 10, "Bomb", ::GivePlayerWeapon, "briefcase_bomb_mp");
    self MenuOption("super specials", 11, "Grim Reaper", ::GivePlayerWeapon, "m202_flash_mp");
    self MenuOption("super specials", 12, "Valkyrie Rocket", ::GivePlayerWeapon, "m220_tow_mp");
    self MenuOption("super specials", 13, "RC-XD Remote", ::GivePlayerWeapon, "rcbomb_mp");
    self MenuOption("super specials", 14, "What the fuck is this", ::GivePlayerWeapon, "dog_bite_mp");
	
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
	
	self MainMenu("bots menu", "redemption");
	self MenuOption("bots menu", 0, "spawn enemy bot", ::spawnEnemyBot);
	self MenuOption("bots menu", 1, "spawn friendly bot", ::spawnFriendlyBot);
	self MenuOption("bots menu", 2, "freeze all bots", ::freezeAllBots);
	self MenuOption("bots menu", 3, "kick all bots", ::kickAllBots);
	self MenuOption("bots menu", 4, "teleport bots to crosshair", ::TeleportAllBots);
	self MenuOption("bots menu", 5, "make bots look at you", ::MakeAllBotsLookAtYou);
	self MenuOption("bots menu", 6, "make bots crouch", ::MakeAllBotsCrouch);
	self MenuOption("bots menu", 7, "make bots prone", ::MakeAllBotsProne);

	
	self MainMenu("admin menu", "redemption");
	self MenuOption("admin menu", 0, "change gravity", ::SubMenu, "gravity menu");
	self MenuOption("admin menu", 1, "slow motion", ::SubMenu, "slow mo menu");
	self MenuOption("admin menu", 2, "auto prone", ::autoProne);
	self MenuOption("admin menu", 3, "ground spins", ::prone);
	self MenuOption("admin menu", 4, "ladder mod", ::SubMenu, "ladder menu");
	self MenuOption("admin menu", 5, "ladder spins", ::laddermovement);
	self MenuOption("admin menu", 6, "soft land", ::softLand);
	self MenuOption("admin menu", 7, "pickup radius", ::SubMenu, "pickup radius menu");
	self MenuOption("admin menu", 8, "nade pickup radius", ::SubMenu, "grenade radius menu"); 
	self MenuOption("admin menu", 9, "change melee length", ::meleeRange);
	self MenuOption("admin menu", 10, "change killcam length", ::LongKillcam);
	self MenuOption("admin menu", 11, "toggle playercard", ::Playercard);
	self MenuOption("admin menu", 12, "pause timer", ::toggleTimer);
	self MenuOption("admin menu", 13, "fast restart", ::fastrestart);
	
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
    self MenuOption("pickup radius menu", 0, "pickup radius 100 (default)", ::expickup, 100);
    self MenuOption("pickup radius menu", 1, "pickup radius 250", ::expickup, 250);
    self MenuOption("pickup radius menu", 2, "pickup radius 500", ::expickup, 500);
    self MenuOption("pickup radius menu", 3, "pickup radius 1000", ::expickup, 1000);
    self MenuOption("pickup radius menu", 4, "pickup radius 2000", ::expickup, 2000);
    self MenuOption("pickup radius menu", 5, "pickup radius 3000", ::expickup, 3000);
    self MenuOption("pickup radius menu", 6, "pickup radius 4000", ::expickup, 4000);
    self MenuOption("pickup radius menu", 7, "pickup radius 5000", ::expickup, 5000);
    self MenuOption("pickup radius menu", 8, "pickup radius 6000", ::expickup, 6000);
    self MenuOption("pickup radius menu", 9, "pickup radius 7000", ::expickup, 7000);
    self MenuOption("pickup radius menu", 10, "pickup radius 8000", ::expickup, 8000);
    
    self MainMenu("grenade radius menu", "admin menu");
    self MenuOption("grenade radius menu", 0, "pickup radius 100 (default)", ::grenaderadius, 100);
    self MenuOption("grenade radius menu", 1, "pickup radius 250", ::grenaderadius, 250);
    self MenuOption("grenade radius menu", 2, "pickup radius 500", ::grenaderadius, 500);
    self MenuOption("grenade radius menu", 3, "pickup radius 1000", ::grenaderadius, 1000);
    self MenuOption("grenade radius menu", 4, "pickup radius 2000", ::grenaderadius, 2000);
    self MenuOption("grenade radius menu", 5, "pickup radius 3000", ::grenaderadius, 3000);
    self MenuOption("grenade radius menu", 6, "pickup radius 4000", ::grenaderadius, 4000);
    self MenuOption("grenade radius menu", 7, "pickup radius 5000", ::grenaderadius, 5000);
    self MenuOption("grenade radius menu", 8, "pickup radius 6000", ::grenaderadius, 6000);
    self MenuOption("grenade radius menu", 9, "pickup radius 7000", ::grenaderadius, 7000);
    self MenuOption("grenade radius menu", 10, "pickup radius 8000", ::grenaderadius, 8000);

	self MainMenu("dev menu", "redemption");
	self MenuOption("dev menu", 0, "get map name", ::MapName);
	self MenuOption("dev menu", 1, "get corods", ::Coords);
	
		
	self MainMenu("clients menu", "redemption");
	for (p = 0; p < level.players.size; p++) {
        player = level.players[p];
        self MenuOption("clients menu", p, "[" + player.MyAccess + "^7] " + player.name + "", ::SubMenu, "client options");
    }
	self thread MonitorPlayers();
	
	self MainMenu("client options", "clients menu");
	self MenuOption("client options", 0, "freeze player", ::Test);
	self MenuOption("client options", 1, "unfreeze player", ::Test);
	self MenuOption("client options", 2, "revive player", ::Test);
	self MenuOption("client options", 3, "teleport player", ::Test);
	self MenuOption("client options", 4, "kill player", ::Test);
	self MenuOption("client options", 5, "kick player", ::Test);
}
MonitorPlayers()
{
	self endon("disconnect");
	for(;;)
	{
		for(p = 0;p < level.players.size;p++)
		{
			player = level.players[p];
			self.Menu.System["MenuTexte"]["clients Menu"][p] = "[" + player.MyAccess + "^7] " + player.name;
			self.Menu.System["MenuFunction"]["clients Menu"][p] = ::SubMenu;
			self.Menu.System["MenuInput"]["clients Menu"][p] = "clients menu";
			wait .01;
		}
		wait .5;
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
	if(self.Menu.System["MenuRoot"]=="Client Function")
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
	// SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
	self.Menu.Material["Background"] = self SetMaterial("LEFT", "TOP", 200, 0, 270, 1000, (1,1,1), "black", 0, 0);
	self.Menu.Material["Scrollbar"] = self SetMaterial("LEFT", "TOP", 200, 35, 270, 15, self.menuColor, "white", 2, 0);
	self.Menu.Material["CustShader"] = self SetMaterial("LEFT", "TOP", 200, -5, 270, 65, (1,1,1), "black", 1, 0);
	
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
