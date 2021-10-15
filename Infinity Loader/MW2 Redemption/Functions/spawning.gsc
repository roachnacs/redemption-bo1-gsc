SpawnModel(model)
{
    if(IsSubStr(model,"com_plasticcase_"))
        clip  = level.airDropCrateCollision;
    model = SpawnScriptModel(self.origin,model,undefined,undefined,clip);
    
    self SetOrigin(self.origin+(0,0,20));
}

TurretSpawn()
{
    turret        = spawnTurret("misc_turret",self.origin,"sentry_minigun_mp");
    turret.angles = (0,self GetPlayerAngles()[1],0);
    turret SetModel("sentry_minigun");
    turret MakeUsable();
    turret SetDefaultDropPitch(-89);
}

SpawnPlatform()
{
    model = "com_plasticcase_friendly";
    
    crate = [];
    for(a=0;a<7;a++)
        for(b=0;b<11;b++)
            crate[crate.size] = SpawnScriptModel(self.origin+((a*56),(b*30),-50),model,(0,0,0),0,level.airDropCrateCollision);
    wait .05;
    self SetOrigin(crate[0].origin+(0,0,20));
}

SpawnSlide()
{
    AngF  = AnglesToForward(self GetPlayerAngles());
    slide = SpawnScriptModel(self.origin+(0,0,5)+AnglesToForward(self.angles)*25,"com_plasticcase_friendly",(-65,self.angles[1],0),undefined,level.airDropCrateCollision);
    self SetOrigin(self.origin+(0,0,20));
    slide thread MonitorSlide();
    
    self iPrintln("A slide has been ^2Spawned");
}

MonitorSlide()
{
    while(isDefined(self))
    {
        foreach(player in level.players)
            if(Distance(self.origin,player.origin) <= 50 && player MeleeButtonPressed())
            {
                AngF = AnglesToForward(player GetPlayerAngles());
                player SetVelocity((AngF[0]*725,AngF[1]*725,player GetVelocity()[2]+975));
            }
        wait .025;
    }
}

SpawnBounce()
{
    if(!isDefined(level.Bounces))level.Bounces = [];
    
    level.Bounces[level.Bounces.size] = SpawnScriptModel(self.origin,"com_plasticcase_friendly",(0,self.angles[1],0),undefined,level.airDropCrateCollision);
    self SetOrigin(self.origin+(0,0,20));
    if(isDefined(level.BouncesInvisible))
        level.Bounces[level.Bounces.size-1] Hide();
    level.Bounces[level.Bounces.size-1] thread MonitorBounce();
    
    self iPrintln("A bounce has been ^2Spawned");
}

MonitorBounce()
{
    while(isDefined(self))
    {
        foreach(player in level.players)
            if(Distance(self.origin,player.origin) <= 50)
                player SetVelocity(player GetVelocity()+(0,0,800));
        wait .025;
    }
}

BouncesInvisible()
{
    level.BouncesInvisible = (isDefined(level.BouncesInvisible) ? undefined : true);
    
    if(isDefined(level.BouncesInvisible))
    {
        for(a=0;a<level.Bounces.size;a++)
            level.Bounces[a] Hide();
        self iPrintln("Bounces Visible: ^1Off");
    }
    else
    {
        for(a=0;a<level.Bounces.size;a++)
            level.Bounces[a] Show();
        self iPrintln("Bounces Visible: ^2On");
    }
}

ForgeMode()
{
    self.ForgeMode = (isDefined(self.ForgeMode) ? undefined : true);
    
    if(isDefined(self.ForgeMode))
    {
        self thread ForgeModeLoop();
        string          = "Hold [{+frag}] to pickup objects + players\nPress [{+smoke}] while holding an object to delete it\nPress [{+actionslot 3}] to spawn a care package";
        if(!isDefined(self.ForgeHUD))
            self.ForgeHUD = self createText("default",1.5,1,string,"LEFT","LEFT",-45,-75,1,(1,1,1),1,(1,0,0));
        self iPrintln("Forge Mode: ^2On");
    }
    else
    {
        if(isDefined(self.ForgeHUD))
            self.ForgeHUD destroy();
        self EnableOffHandWeapons();
        self iPrintln("Forge Mode: ^1Off");
    }
}

ForgeModeLoop()
{
    self endon("disconnect");
    
    grabEnt = undefined;
    while(isDefined(self.ForgeMode))
    {
        self DisableOffHandWeapons();
        if(isDefined(grabEnt))
        {
            grabEnt["entity"].origin = self GetEye()+vectorScale(AnglesToforward(self GetPlayerAngles()),250);
            grabEnt = undefined;
        }
        if(self FragButtonPressed() && !isDefined(grabEnt))
            grabEnt = BulletTrace(self GetEye(),self GetEye()+vectorScale(AnglesToForward(self GetPlayerAngles()),1000000),0,self);
        if(self SecondaryOffhandButtonPressed())
        {
            if(isDefined(grabEnt["entity"]))
            {
                grabEnt["entity"] delete();
                grabEnt = undefined;
                self iPrintln("Entity ^1Deleted");
            }
        }
        if(self isButtonPressed("+actionslot 3") && !self isInMenu())
        {
            pos   = BulletTrace(self GetEye(),self GetEye()+vectorScale(AnglesToForward(self GetPlayerAngles()),250),0,self)["position"];
            crate = SpawnScriptModel(pos,"com_plasticcase_friendly",(0,(self.angles[1]+90),0),0,level.airDropCrateCollision);
            wait .05;
        }
        
        wait .05;
    }
}