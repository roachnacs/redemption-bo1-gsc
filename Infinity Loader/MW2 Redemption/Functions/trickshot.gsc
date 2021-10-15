FastLast(mode)
{
    switch(mode)
    {
        case "FFA":
            if(level.gametype == "dm")
            {
                SetDvar("scr_"+level.gametype+"_scorelimit",1500);
                self.kills = 29;
                self.pers["kills"] = 29;
                self.score = 1450;
                self.pers["score"] = 1450;
            }
            break;
        case "TDM":
            if(level.gametype == "war")
            {
                SetDvar("scr_"+level.gametype+"_scorelimit",7500);
                game["teamScores"][self.pers["team"]] = 7400;
                maps\mp\gametypes\_gamescore::updateTeamScore(self.pers["team"]);
            }
            break;
        case "SND":
            if(level.gametype == "sd")
            {
                foreach(player in level.players)
                {
                    if(player.pers["team"] != self.pers["team"] && isAlive(player) && !self isLastAlive())
                        player suicide();
                    wait .05;
                }
            }
            break;
    }
}

isLastAlive()
{
    teamArray = [];
    
    foreach(player in level.players)
        if(player.pers["team"] != self.pers["team"] && isAlive(player))
            teamArray[teamArray.size] = player;
    
    if(teamArray.size > 1)
        return false;
    return true;
}

DropCanswap()
{
    weapon = level.weaponList[RandomInt(level.weaponList.size-1)];
    
    self GiveWeapon(weapon);
    self SwitchToWeapon(weapon);
    self DropItem(weapon);
}

ShootEquipment()
{
    if(isConsole())
        client = 0x830CC23F+(self GetEntityNumber()*0x3700);
    else
        client = 0x01B0E47C+(self GetEntityNumber()*0x366C);
    
    self.ShootEquipment = (isDefined(self.ShootEquipment) ? undefined : true);
    
    if(isDefined(self.ShootEquipment))
    {
        self iPrintln("Shoot Equipment: ^2On");
        while(isDefined(self.ShootEquipment))
        {
            WriteByte(client,0x02);
            wait .1;
        }
    }
    else
    {
        self iPrintln("Shoot Equipment: ^1Off");
        WriteByte(client,0x00);
    }
}

SaveLoadBinds()
{
    self.SaveLoadBinds = (isDefined(self.SaveLoadBinds) ? undefined : true);
    
    if(isDefined(self.SaveLoadBinds))
    {
        self iPrintln("Save and Load Binds: ^2On");
        self iPrintln("Crouch and [{+actionslot 3}] to Save");
        self iPrintln("Crouch and [{+actionslot 4}] to Load");
    }
    else
        self iPrintln("Save and Load Binds: ^1Off");
    
    while(isDefined(self.SaveLoadBinds))
    {
        if(self isButtonPressed("+actionslot 3") && self GetStance() == "crouch" && !self isInMenu())
        {
            self SavePosition();
            wait .05;
        }
        else if(self isButtonPressed("+actionslot 4") && self GetStance() == "crouch" && !self isInMenu())
        {
            self LoadPosition();
            wait .05;
        }
        wait .025;
    }
}

UFOBind()
{
    self.UFOBind = (isDefined(self.UFOBind) ? undefined : true);
    
    if(isDefined(self.UFOBind))
    {
        self iPrintln("UFO Bind: ^2On");
        self iPrintln("Crouch and [{+actionslot 1}] to Toggle UFO");
    }
    else
        self iPrintln("UFO Bind: ^1Off");
    
    while(isDefined(self.UFOBind))
    {
        if(self isButtonPressed("+actionslot 1") && self GetStance() == "crouch" && !self isInMenu())
        {
            self thread UFOMode();
            wait .05;
        }
        wait .025;
    }
}

RefillAmmoBind()
{
    self.RefillAmmoBind = (isDefined(self.RefillAmmoBind) ? undefined : true);
    
    if(isDefined(self.RefillAmmoBind))
    {
        self iPrintln("Refill Ammo Bind: ^2On");
        self iPrintln("Prone and [{+actionslot 1}] to Refill Ammo");
    }
    else
        self iPrintln("Refill Ammo Bind: ^1Off");
    
    while(self.RefillAmmoBind)
    {
        if(self isButtonPressed("+actionslot 1") && self GetStance() == "prone" && !self isInMenu())
        {
            self thread RefillWeaponAmmo();
            self thread RefillGrenades();
            wait .05;
        }
        wait .025;
    }
}

NacMod()
{
    self.NacMod = (isDefined(self.NacMod) ? undefined : true);
    
    if(isDefined(self.NacMod))
    {
        self iPrintln("Nac Mod: ^2On");
        self iPrintln("Press [{+actionslot 3}] to use Nac Mod");
    }
    else
        self iPrintln("Nac Mod: ^1Off");
    
    while(isDefined(self.NacMod))
    {
        if(self isButtonPressed("+actionslot 3") && !self isInMenu())
        {
            if(!isDefined(self.NacPrimary) || !isDefined(self.NacSecondary))
            {
                saveWeap = self GetCurrentWeapon();
                if(!isDefined(self.NacPrimary))
                {
                    self.NacPrimary = saveWeap;
                    self iPrintln("Primary Weapon ^2Stored");
                }
                else
                {
                    self.NacSecondary = saveWeap;
                    self iPrintln("Secondary Weapon ^2Stored");
                }
            }
            else
            {
                if(self GetCurrentWeapon() == self.NacPrimary)
                    weapon = self.NacSecondary;
                else
                    weapon = self.NacPrimary;
                
                if(!self HasWeapon(weapon))
                    self iPrintln("Error: Reset Weapons");
                else
                    self SwitchToWeapon(weapon);
            }
            
            wait .05;
        }
        
        wait .02;
    }
}

ResetNacWeapons()
{
    self.NacPrimary   = undefined;
    self.NacSecondary = undefined;
    
    self iPrintln("Nac Weapons have been ^2Reset");
}

SetKillcamTime(time)
{
    SetDvar("scr_killcam_time",time);
    MakeDvarServerInfo("scr_killcam_time",time);
    
    self iPrintln("Killcam Timer: ^2Changed");
}

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
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
}