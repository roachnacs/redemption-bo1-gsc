ForceHostInfection()
{
    self SetClientDvar("party_connectToOthers","0");
    self SetClientDvar("partyMigrate_disabled","1");
    self SetClientDvar("party_mergingEnabled","0");
    self SetClientDvar("party_hostmigration","1");
    self SetClientDvar("party_connectTimeout","0");
    self SetClientDvar("requireOpenNat",false);
    
    self iPrintln("Force Host Infection ^2Set");
}

SuperStoppingPowerInfection()
{
    self SetClientDvar("perk_bulletDamage",1000);
    self iPrintln("Super Stopping Power Infection ^2Set");
}

KnockbackInfection()
{
    SetDvar("g_knockback",99999);
    self iPrintln("Knockback Infection ^2Set");
}

ChromeInfection()
{
    if(GetDvar("r_specularMap") != "White")
    {
        self SetClientDvar("r_specularMap","White");
        SetDvar("r_specularMap","White");
        self iPrintln("Chrome Mode: ^2On");
    }
    else
    {
        self SetClientDvar("r_specularMap","Unchanged");
        SetDvar("r_specularMap","Unchanged");
        self iPrintln("Chrome Mode: ^1Off");
    }
}

CartoonInfection()
{
    if(int(GetDvar("r_fullbright")) != 1)
    {
        self SetClientDvar("r_fullbright",1);
        SetDvar("r_fullbright",1);
        self iPrintln("Cartoon Mode: ^2On");
    }
    else
    {
        self SetClientDvar("r_fullbright",0);
        SetDvar("r_fullbright",0);
        self iPrintln("Cartoon Mode: ^1Off");
    }
}

RainbowInfection()
{
    if(GetDvar("r_debugShader") != "normal")
    {
        self SetClientDvar("r_debugShader","normal");
        SetDvar("r_debugShader","normal");
        self iPrintln("Rainbow Mode: ^2On");
    }
    else
    {
        self SetClientDvar("r_debugShader","Unchanged");
        SetDvar("r_debugShader","Unchanged");
        self iPrintln("Rainbow Mode: ^1Off");
    }
}

BackspeedInfection()
{
    if(int(GetDvar("player_backspeedscale")) != 5)
    {
        SetDvar("player_backspeedscale",5);
        self iPrintln("Fast Backspeed: ^2On");
    }
    else
    {
        SetDvar("player_backspeedscale",1);
        self iPrintln("Fast Backspeed: ^1Off");
    }
}

RaisedGunInfection()
{
    if(int(GetDvar("cg_gun_z")) != 5)
    {
        self SetClientDvar("cg_gun_z",5);
        SetDvar("cg_gun_z",5);
        self iPrintln("Raised Gun: ^2On");
    }
    else
    {
        self SetClientDvar("cg_gun_z",0);
        SetDvar("cg_gun_z",0);
        self iPrintln("Raised Gun: ^1Off");
    }
}

LeftSideGunInfection()
{
    if(int(GetDvar("cg_gun_y")) != 10)
    {
        self SetClientDvar("cg_gun_y",10);
        SetDvar("cg_gun_y",10);
        self iPrintln("Left Side Gun: ^2On");
    }
    else
    {
        self SetClientDvar("cg_gun_y",0);
        SetDvar("cg_gun_y",0);
        self iPrintln("Left Side Gun: ^1Off");
    }
}