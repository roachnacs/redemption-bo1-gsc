GodMode()
{
    self.godMode = (isDefined(self.godmode) ? undefined : true);
    
    if(isDefined(self.godMode))
    {
        SavedMaxHealth = self.maxhealth;
        self iPrintln("God Mode: ^2On");
    }
    else self iPrintln("God Mode: ^1Off");
    
    while(isDefined(self.godmode) && isAlive(self))
    {
        self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        self.maxhealth = 2147483647;
        self.health    = self.maxhealth;
        wait .05;
    }
    
    self.maxhealth = SavedMaxHealth;
    self.health    = self.maxhealth;
    if(isDefined(self.godMode))self thread GodMode();
}

Invisibility()
{
    if(!isDefined(self.invisibility))
    {
        self.invisibility = true;
        self HideAllParts();
        self iPrintln("Invisibility: ^2On");
    }
    else
    {
        self.invisibility = undefined;
        self ShowAllParts();
        self iPrintln("Invisibility: ^1Off");
    }
}

UFOMode() 
{
    self.UFOMode = (isDefined(self.UFOMode) ? undefined : true);
    
    if(isConsole())
        address = 0x830CF3A3 + (self GetEntityNumber() * 0x3700);
    else
        address = 0x1B11554 + (self GetEntityNumber() * 0x366C);
    
    if(isDefined(self.UFOMode))
    {
        WriteByte(address,0x02);
        self iPrintln("UFO Mode: ^2On");
    }
    else
    {
        WriteByte(address,0x00);
        self iPrintln("UFO Mode: ^1Off");
    }
}

InfiniteAmmo()
{
    self.InfiniteAmmo = (isDefined(self.InfiniteAmmo) ? undefined : true);
    
    if(isDefined(self.InfiniteAmmo))
        self iPrintln("Infinite Ammo: ^2On");
    else
        self iPrintln("Infinite Ammo: ^1Off");
    
    self endon("disconnect");
    
    while(isDefined(self.InfiniteAmmo))
    {
        weapons = self GetWeaponsListAll();
        foreach(weapon in weapons)
        {
            self GiveMaxAmmo(weapon);
            self SetWeaponAmmoClip(weapon,999);
        }
        wait .05;
    }
}

BleedMoney1()
{
    self endon ( "disconnect" );
    self endon ( "death" );
    while(1)
    {
        playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
        wait 0.5;
    }
    self iprintln("Bleed Money ^2On");
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
    
NoRecoil()
{
    if(!isDefined(self.NoRecoil))
    {
        self.NoRecoil = true;
        self iPrintln("No Recoil: ^2On");
        
        while(isDefined(self.NoRecoil))
        {
            self Player_RecoilScaleOn(0);
            wait .05;
        }
    }
    else
    {
        self.NoRecoil = undefined;
        self Player_RecoilScaleOn(100);
        self iPrintln("No Recoil: ^1Off");
    }
}

NoSpread()
{
    if(!isDefined(self.NoSpread))
    {
        self.NoSpread = true;
        self iPrintln("No Spread: ^2On");
        
        while(isDefined(self.NoSpread))
        {
            self SetSpreadOverride(1);
            wait .05;
        }
    }
    else
    {
        self.NoSpread = undefined;
        self ResetSpreadOverride();
        self iPrintln("No Spread: ^1Off");
    }
}

UAV()
{
    self.ConstantUAV = (isDefined(self.ConstantUAV) ? undefined : true);
    
    if(isConsole())
        address = 0x830CF264 + (self GetEntityNumber() * 0x3700);
    else
        address = 0x1B11418 + (self GetEntityNumber() * 0x366C);
    
    if(isDefined(self.ConstantUAV))
    {
        WriteByte(address,0x01);
        self iPrintln("UAV: ^2On");
    }
    else
    {
        WriteByte(address,0x00);
        self iPrintln("UAV: ^1Off");
    }
}

RedBox()
{
    if(!isDefined(self.RedBox))
    {
        self.RedBox = true;
        self ThermalVisionFOFOverlayOn();
        self iPrintln("Red Boxes: ^2On");
    }
    else
    {
        self.RedBox = undefined;
        self ThermalVisionFOFOverlayOff();
        self iPrintln("Red Boxes: ^1Off");
    }
}

ThirdPerson()
{
    if(!isDefined(self.ThirdPerson))
    {
        self.ThirdPerson = true;
        self SetClientDvar("cg_thirdPerson","1");
        self iPrintln("Third Person: ^2On");
    }
    else
    {
        self.ThirdPerson = undefined;
        self SetClientDvar("cg_thirdPerson","0");
        self iPrintln("Third Person: ^1Off");
    }
}

ProMod()
{
    if(!isDefined(self.ProMod))
    {
        self.ProMod = true;
        self SetClientDvar("cg_fov",80);
        self iPrintln("Pro Mod: ^2On");
    }
    else
    {
        self.ProMod = undefined;
        self SetClientDvar("cg_fov",65);
        self iPrintln("Pro Mod: ^1Off");
    }
}

SpawnText()
{
    self.HideSpawnText = (isDefined(self.HideSpawnText) ? undefined : true);
    
    if(isDefined(self.HideSpawnText))
        self iPrintln("Disable Spawn Text: ^2On");
    else
        self iPrintln("Disable Spawn Text: ^1Off");
}

RenamePlayer(string,player)
{
    if(player isDeveloper() && self != player)
        return;
    
    if(!isConsole())
        client = 0x1B113DC + (player GetEntityNumber() * 0x366C);
    else
    {
        client = 0x830CF210 + (player GetEntityNumber() * 0x3700);
        
        name = ReadString(client);
        for(a=0;a<name.size;a++)WriteByte(client+a,0x00);
    }
    
    WriteString(client,string);
    player iPrintln("Your new name is ^2"+string);
}

ChatWithLobby(string)
{
    iPrintln("[^2"+self getName()+"^7]: "+string);
}

MortarStrike()
{
    self BeginLocationSelection("map_artillery_selector",false);
    self.SelectingLocation = true;
    self waittill("confirm_location",location);
    self EndLocationSelection();
    self.SelectingLocation = undefined;
    origin                 = BulletTrace(location+(0,0,10000),location+(0,0,-10000),0,self)["position"];
    startpos               = origin + (0,0,1000);
    
    for(a=0;a<3;a++)
    {
        MagicBullet("ac130_40mm_mp",startpos,origin,self);
        wait .25;
    }
}

Earthquake1()
{
    Earthquake(.8,8,self.origin,1000);
}

SelfSuicide()
{
    self Suicide();
}