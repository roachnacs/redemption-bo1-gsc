glitchclassbind1()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread classglitchin("1");
        self iPrintln("Press [{+actionslot 1}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

glitchclassbind2()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread classglitchin("2");
        self iPrintln("Press [{+actionslot 2}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

glitchclassbind3()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread classglitchin("3");
        self iPrintln("Press [{+actionslot 3}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

glitchclassbind4()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread classglitchin("4");
        self iPrintln("Press [{+actionslot 4}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

classglitchin(actionslot)
{
    self endon("disconnect");
    self endon("death");
    self endon("stopgcb");
    for(;;)
    {
    
        self notifyOnPlayerCommand("chc", "+actionslot " + actionslot);
        self waittill("chc");
    if(self.pers["Class"] == "custom1")
    {
        self maps\mp\gametypes\_class::setClass("custom2");
        self.pers["Class"] = "custom2";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom2");
    }
    else if(self.pers["Class"] == "custom2")
    {
        self maps\mp\gametypes\_class::setClass("custom3");
        self.pers["Class"] = "custom3";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom3");
    }
    else if(self.pers["Class"] == "custom3")
    {
        self maps\mp\gametypes\_class::setClass("custom4");
        self.pers["Class"] = "custom4";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom4");
    }
    else if(self.pers["Class"] == "custom4")
    {
        self maps\mp\gametypes\_class::setClass("custom5");
        self.pers["Class"] = "custom5";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom5");
    }
    else if(self.pers["Class"] == "custom5")
    {
        self maps\mp\gametypes\_class::setClass("custom6");
        self.pers["Class"] = "custom6";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom6");
    }
    else if(self.pers["Class"] == "custom6")
    {
        self maps\mp\gametypes\_class::setClass("custom7");
        self.pers["Class"] = "custom7";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom7");
    }
    else if(self.pers["Class"] == "custom7")
    {
        self maps\mp\gametypes\_class::setClass("custom8");
        self.pers["Class"] = "custom8";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom8");
    }
    else if(self.pers["Class"] == "custom8")
    {
        self maps\mp\gametypes\_class::setClass("custom9");
        self.pers["Class"] = "custom9";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom9");
    }
    else if(self.pers["Class"] == "custom9")
    {
        self maps\mp\gametypes\_class::setClass("custom10");
        self.pers["Class"] = "custom10";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom10");
    }
    else if(self.pers["Class"] == "custom10")
    {
        self maps\mp\gametypes\_class::setClass("class0");
        self.pers["Class"] = "class0";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class0");
    }
    else if(self.pers["Class"] == "class0")
    {
        self maps\mp\gametypes\_class::setClass("class1");
        self.pers["Class"] = "class1";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class1");
    }
    else if(self.pers["Class"] == "class1")
    {
        self maps\mp\gametypes\_class::setClass("class2");
        self.pers["Class"] = "class2";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class2");
    }
    else if(self.pers["Class"] == "class2")
    {
        self maps\mp\gametypes\_class::setClass("class3");
        self.pers["Class"] = "class3";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class3");
    }
    else if(self.pers["Class"] == "class3")
    {
        self maps\mp\gametypes\_class::setClass("class4");
        self.pers["Class"] = "class4";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class4");
    }
    else if(self.pers["Class"] == "class4")
    {
        self maps\mp\gametypes\_class::setClass("custom1");
        self.pers["Class"] = "custom1";
        self.tag_stowed_back=undefined;
        self.tag_stowed_hip=undefined;
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom1");
    }
    self.nova = self getCurrentweapon();
    ammoW = self getWeaponAmmoStock( self.nova );
    ammoCW = self getWeaponAmmoClip( self.nova );
    self setweaponammostock( self.nova, ammoW );
    self setweaponammoclip( self.nova, ammoCW - 1 );
    }
}

CanClassbind1()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread CanswapChangeClass("1");
        self iPrintln("Press [{+actionslot 1}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

CanClassbind2()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread CanswapChangeClass("2");
        self iPrintln("Press [{+actionslot 2}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

CanClassbind3()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread CanswapChangeClass("3");
        self iPrintln("Press [{+actionslot 3}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

CanClassbind4()
{
    if(!self.gcb)
    {
        self.gcb = true;
        self thread CanswapChangeClass("4");
        self iPrintln("Press [{+actionslot 4}] to Change Class");
    }
    else
    {
        self.gcb = false;
        self notify("stopgcb");
        self iPrintln("Class Change Bind: ^1Off");
    }
}

CanswapChangeClass(actionslot)
{
    self endon("disconnect");
    self endon("death");
    self endon("stopgcb");
    for(;;)
    {
        self notifyOnPlayerCommand("chc", "+actionslot " + actionslot);
        self waittill("chc");
        if(self.pers["Class"] == "custom1")
        {
            self maps\mp\gametypes\_class::setClass("custom2");
            self.pers["Class"] = "custom2";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom2");
        }
        else if(self.pers["Class"] == "custom2")
        {
            self maps\mp\gametypes\_class::setClass("custom3");
            self.pers["Class"] = "custom3";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom3");
        }
        else if(self.pers["Class"] == "custom3")
        {
            self maps\mp\gametypes\_class::setClass("custom4");
            self.pers["Class"] = "custom4";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom4");
        }
        else if(self.pers["Class"] == "custom4")
        {
            self maps\mp\gametypes\_class::setClass("custom5");
            self.pers["Class"] = "custom5";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom5");
        }
        else if(self.pers["Class"] == "custom5")
        {
            self maps\mp\gametypes\_class::setClass("custom6");
            self.pers["Class"] = "custom6";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom6");
        }
        else if(self.pers["Class"] == "custom6")
        {
            self maps\mp\gametypes\_class::setClass("custom7");
            self.pers["Class"] = "custom7";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom7");
        }
        else if(self.pers["Class"] == "custom7")
        {
            self maps\mp\gametypes\_class::setClass("custom8");
            self.pers["Class"] = "custom8";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom8");
        }
        else if(self.pers["Class"] == "custom8")
        {
            self maps\mp\gametypes\_class::setClass("custom9");
            self.pers["Class"] = "custom9";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom9");
        }
        else if(self.pers["Class"] == "custom9")
        {
            self maps\mp\gametypes\_class::setClass("custom10");
            self.pers["Class"] = "custom10";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom10");
        }
        else if(self.pers["Class"] == "custom10")
        {
            self maps\mp\gametypes\_class::setClass("class0");
            self.pers["Class"] = "class0";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class0");
        }
        else if(self.pers["Class"] == "class0")
        {
            self maps\mp\gametypes\_class::setClass("class1");
            self.pers["Class"] = "class1";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class1");
        }
        else if(self.pers["Class"] == "class1")
        {
            self maps\mp\gametypes\_class::setClass("class2");
            self.pers["Class"] = "class2";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class2");
        }
        else if(self.pers["Class"] == "class2")
        {
            self maps\mp\gametypes\_class::setClass("class3");
            self.pers["Class"] = "class3";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class3");
        }
        else if(self.pers["Class"] == "class3")
        {
            self maps\mp\gametypes\_class::setClass("class4");
            self.pers["Class"] = "class4";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"class4");
        }
        else if(self.pers["Class"] == "class4")
        {
            self maps\mp\gametypes\_class::setClass("custom1");
            self.pers["Class"] = "custom1";
            self.tag_stowed_back=undefined;
            self.tag_stowed_hip=undefined;
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom1");
        }
        wait 0.01;
        self.nova = self getCurrentweapon();
        ammoW     = self getWeaponAmmoStock( self.nova );
        ammoCW    = self getWeaponAmmoClip( self.nova );
        self TakeWeapon(self.nova);
        self GiveWeapon( self.nova);
        self setweaponammostock( self.nova, ammoW );
        self setweaponammoclip( self.nova, ammoCW);
    }
}

shaxammo()
{
    self endon ("finishedshax");
    self.nova = self getCurrentweapon();
    ammoW1 = self getWeaponAmmoClip( self.nova );
    ammoW2 = self getWeaponAmmostock( self.nova );
    self setweaponammoclip( self.nova, 0 );
    self setweaponammostock( self.nova, ammoW2 + ammoW1);
    waitframe();
}

shaxswitchstart()
{
    self waittill( "weapon_change");
    self iprintln("Working");
    self thread sohchecker(); //slow shax
    waitframe();
    setSlowMotion( 1, 20, 2 ); //speed up reload
    self.didshax = true; //failsafe
    self.prevelocity = self getVelocity(); //get pre-velocity
    setDvar ("cg_drawGun", 0); //shake
    self thread shaxmodel(); //stay in air
    self thread shaxammo(); //reload
    self disableWeapons(); //YY
    waitframe();
    self enableWeapons(); // YY
    self thread shaxtiming(); //Wait times
}

shaxholdstart()
{
    self thread sohchecker(); //slow shax
    waitframe();
    setSlowMotion( 1, 20, 2 ); //speed up reload
    self.didshax = true; //failsafe
    self.prevelocity = self getVelocity(); //get pre-velocity
    setDvar ("cg_drawGun", 0); //shake
    self thread shaxmodel(); //stay in air
    self thread shaxammo(); //reload
    self disableWeapons(); //YY
    waitframe();
    self enableWeapons(); // YY
    self thread shaxtiming(); //Wait times
}

shaxmodel()
{
    shaxMODEL = spawn( "script_model", self.origin );
    self PlayerLinkTo(shaxMODEL);
    self waittill ("finishedshax");
    wait 0.50;
    self unlink();
    shaxMODEL Destroy();
    shaxMODEL Delete(); 
    waitframe();
    self SetVelocity(((self.prevelocity[0] / 2), (self.prevelocity[1] / 2), (self.prevelocity[2] / 4)));

}

shaxenddvars()
{
    wait (self.shaxWait - 0.05);
    setDvar ("cg_drawGun", 1);
    setSlowMotion( 20, 1, 2 );
    self notify ("finishedshax");
    self.didshax = false;
    if(self.hassoh123 == true)
    {
         self maps\mp\perks\_perks::givePerk("specialty_fastreload");
         self.hassoh123 = undefined;
    }
}


sohchecker()
{
    if ( self hasperk( "specialty_fastreload" ) )
    {
         self.hassoh123 = true;
        self unsetPerk( "specialty_fastreload" );
    }
    else
    {
    
    }
}

stopshax()
{
    self notify ("stopshax");
    self iPrintLn ("^1Shax Swaps are now disabled");
}



//
//shax timings
//

shaxtiming(shaxWait)
{
    self.shaxwep = self getCurrentWeapon();
    if(isSubStr(self.shaxwep, "uzi")) // DONE v2
    {
        self.shaxWait = 2.05;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "kriss")) //Done v2
    {
        self.shaxWait = 1.1;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "ump")) //Done v2
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "p90")) //Done v2
    {
        self.shaxWait = 1.9;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "mp5k"))  //DONE v2
    {
        self.shaxWait = 1.4;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m4")) //Done
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "famas")) //DONE v2
    {
        self.shaxWait = 2.05;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "scar")) //Done
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "tavor")) //Done v2
    {
        self.shaxWait = 1.4;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "fal")) //Done v2
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m16")) //Done v2
    {
        self.shaxWait = 1.1;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "masada")) //Done v2
    {
        self.shaxWait = .8;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "fn2000")) //Done v2
    {
        self.shaxWait = 1.5;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "ak47")) //Done v2
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "sa80")) 
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "mg4")) 
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "aug"))
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m240"))
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "rpd"))
    {
        self.shaxWait = 1.6;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "cheytac")) //Done v2
    {
        self.shaxWait = 2.45;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "barrett"))//Done v2
    {
        self.shaxWait = 2.55;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "wa2000"))//Done v2
    {
        self.shaxWait = 2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "m21")) //Done v2
    {
        self.shaxWait = 2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "usp")) //Done v2
    {
        self.shaxWait = .7;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "coltanaconda")) //Done v2
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "beretta")) //Done v2
    {
        self.shaxWait = .7;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "deserteagle")) //Done v2
    {
        self.shaxWait = .75;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "beretta393")) //Done v2
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "pp2000")) //Done v2
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "glock")) //Done v2
    {
        self.shaxWait = 1.4;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "tmp")) //Done v2
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "aa12")) 
    {
        self.shaxWait = 1.7;
        self thread shaxenddvars();
    }
    else if(isSubStr(self.shaxwep, "ranger")) //Done v2
    {
        self.shaxWait = 1.2;
        self thread shaxenddvars();
    }
        else if(isSubStr(self.shaxwep, "rpg"))
    {
        self.shaxWait = 1;
        self thread shaxenddvars();
    }
}
