SavePosition()
{
    self.SavedPosition = self.origin;
    self iPrintln("Position: ^2Saved");
}

LoadPosition()
{
    if(!isDefined(self.SavedPosition))
    {
        self iPrintln("Save a position first");
        return;
    }
    
    self SetOrigin(self.SavedPosition);
}

LoadPositionOnSpawn()
{
    self.LoadPositionOnSpawn = (isDefined(self.LoadPositionOnSpawn) ? undefined : true);
    
    if(isDefined(self.LoadPositionOnSpawn))
        self iPrintln("Load Position On Spawn: ^2On");
    else
        self iPrintln("Load Position On Spawn: ^1Off");
}

TeleportToSky()
{
    self SetOrigin(self.origin+(0,0,25000));
}

TeleportToCrosshair()
{
    self SetOrigin(self TraceBullet());
}

CustomTeleport()
{
    self BeginLocationSelection("map_artillery_selector",false);
    self.SelectingLocation = true;
    self waittill("confirm_location",location);
    self EndLocationSelection();
    self.SelectingLocation = undefined;
    newLocation            = BulletTrace(location+(0,0,10000),location+(0,0,-10000),0,self)["position"];
    self SetOrigin(newLocation);
}

SpecNade() 
{
    self.specNading = (isDefined(self.specNading) ? undefined : true);
    
    if(!isDefined(self.specNading))
    {
        self iPrintln("Spec Nade: ^1Off");
        self notify("EndSpecNade");
        self Unlink();
        if(isDefined(linker))
            linker delete();
    }
    else
    {
        self iPrintln("Spec Nade: ^2On");
        
        self endon("disconnect");
        self endon("EndSpecNade");
        
        while(1)
        {
            self waittill("grenade_fire",grenade,name);
            
            linker = SpawnScriptModel(grenade.origin,"tag_origin");
            linker LinkTo(grenade);
            self PlayerLinkTo(linker);
            while(isDefined(grenade) && isAlive(self))
                wait .05;
            self Unlink();
            linker delete();
        }
    }
}

RocketRiding() //If you are in a solo game, it will link you to the rocket. If there are other players, it chooses the closest player.
{
    self.RocketRiding = (isDefined(self.RocketRiding) ? undefined : true);
    
    if(isDefined(self.RocketRiding))
    {
        self iPrintln("Rocket Ride: ^2On");
        self iPrintln("Shoot an missile to rocket ride the closest player to you");
        
        self endon("EndRocketRiding");
        
        while(isDefined(self.RocketRiding))
        {
            self waittill("missile_fire", missile, weaponName);
            if(GetWeaponClass(weaponName) == "weapon_projectile")
            {
                wait .2;
                
                player = GetClosest(self.origin,level.players,self);
                if(!isDefined(player.RidingRocket))
                {
                    player.RidingRocket = true;
                    linker              = SpawnScriptModel(missile.origin,"tag_origin");
                    linker LinkTo(missile);
                    player PlayerLinkTo(linker,"tag_origin");
                    wait .1;
                    player thread WatchRocket(missile,linker);
                }
            }
        }
    }
    else
    {
        self notify("EndRocketRiding");
        self iPrintln("Rocket Ride: ^1Off");
    }
}

WatchRocket(rocket,linker)
{
    while(isDefined(rocket) && isAlive(self))
    {
        if(self MeleeButtonPressed() || self AttackButtonPressed())
            break;
        wait .05;
    }
    
    self Unlink();
    linker delete();
    self.RidingRocket = undefined;
}