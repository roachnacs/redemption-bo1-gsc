Aimbot()
{
    if(isDefined(self.Aimbot))
        return;
    self.Aimbot = true;
    
    self endon("disconnect");
    self endon("EndAimbot");
    
    while(isDefined(self.Aimbot))
    {
        enemy = self GetClosestTarget();
        if(isDefined(self.AimingRequired) && !self AdsButtonPressed() || isDefined(self.AimbotLockedWeapon) && self GetCurrentWeapon() != self.AimbotLockedWeapon || isDefined(self.AimbotTrickshot) && !isDefined(self.AimbotLockedWeapon) && GetWeaponClass(self GetCurrentWeapon()) != "weapon_sniper")
            enemy = undefined;
        
        if(isDefined(enemy) && self isFiring1())
        {
            bonetag = "MOD_RIFLE_BULLET";
            if(isDefined(self.AimbotHeadshots))
                bonetag = "MOD_HEAD_SHOT";
            
            if(!isDefined(self.AimbotHitmarkers))
                enemy thread [[level.callbackPlayerDamage]](self,self,(enemy.health+999),0,bonetag,self GetCurrentWeapon(),(0,0,0),(0,0,0),"none",0);
            else
                RadiusDamage(enemy GetTagOrigin("j_mainroot"),1,1,1,self);
        }
        
        wait .15;
    }
    
    self.Aimbot = undefined;
}

GetClosestTarget()
{
    foreach(player in level.players)
    {
        if(player == self || player IsHost() || !isAlive(player) || level.teamBased && self.pers["team"] == player.pers["team"] || isDefined(self.AimbotTrickshot) && Distance(player.origin,self.origin) > self.TrickshotAimbotStrength)
            continue;
        
        if(!isDefined(enemy))
            enemy = player;
        if(closer(self.origin,player.origin,enemy.origin))
            enemy = player;
    }
    return enemy;
}

AimbotRequireADS()
{
    self.AimingRequired = (isDefined(self.AimingRequired) ? undefined : true);
    
    if(isDefined(self.AimingRequired))
        self iPrintln("Require ADS: ^2On");
    else
        self iPrintln("Require ADS: ^1Off");
}

AimbotHitmarkers()
{
    self.AimbotHitmarkers = (isDefined(self.AimbotHitmarkers) ? undefined : true);
    
    if(isDefined(self.AimbotHitmarkers))
        self iPrintln("Hitmarkers: ^2On");
    else
        self iPrintln("Hitmarkers: ^1Off");
}

AimbotHeadshots()
{
    self.AimbotHeadshots = (isDefined(self.AimbotHeadshots) ? undefined : true);
    
    if(isDefined(self.AimbotHeadshots))
        self iPrintln("Headshots: ^2On");
    else
        self iPrintln("Headshots: ^1Off");
}

AimbotUnfair()
{
    self.AimbotUnfair = (isDefined(self.AimbotUnfair) ? undefined : true);
    
    if(isDefined(self.AimbotUnfair))
    {
        self.AimbotTrickshot = undefined;
        self thread Aimbot();
        self iPrintln("Unfair Aimbot: ^2On");
    }
    else
    {
        self.Aimbot = undefined;
        self notify("EndAimbot");
        self iPrintln("Unfair Aimbot: ^1Off");
    }
}

AimbotTrickshot()
{
    self.AimbotTrickshot = (isDefined(self.AimbotTrickshot) ? undefined : true);
    
    if(isDefined(self.AimbotTrickshot))
    {
        self.AimbotUnfair = undefined;
        self thread Aimbot();
        self iPrintln("Trickshot Aimbot: ^2On");
    }
    else
    {
        self.Aimbot = undefined;
        self notify("EndAimbot");
        self iPrintln("Trickshot Aimbot: ^1Off");
    }
}

TrickshotAimbotStrength(strength)
{
    self.TrickshotAimbotStrength = strength;
    self iPrintln("Trickshot Aimbot Range: "+strength);
}

AimbotWeapon()
{
    if(!isDefined(self.AimbotLockedWeapon))
    {
        weapon                  = self GetCurrentWeapon();
        self.AimbotLockedWeapon = weapon;
        self iPrintln("Aimbots will only work with "+weapon);
    }
    else
    {
        self.AimbotLockedWeapon = undefined;
        self iPrintln("Unfair Aimbot will work with all weapons");
        self iPrintln("Trickshot Aimbot will work with snipers");
    }
}