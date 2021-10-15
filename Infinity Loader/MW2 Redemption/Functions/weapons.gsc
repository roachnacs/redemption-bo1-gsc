CamoChanger(camo)
{
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,camo);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

TakeWeapons()
{
    self TakeAllWeapons();
}

TakeCurrentWeapon()
{
    self TakeWeapon(self GetCurrentWeapon());
}

DropWeapon()
{
    self DropItem(self GetCurrentWeapon());
}

RefillWeaponAmmo()
{
    weapons = self GetWeaponsListPrimaries();
    
    for(a=0;a<weapons.size;a++)
        self GiveMaxAmmo(weapons[a]);
}

RefillGrenades()
{
    grenades = self GetWeaponsListOffhands();
    
    for(a=0;a<grenades.size;a++)
        self GiveMaxAmmo(grenades[a]);
}

GivePlayerWeapon(Weapon)
{
    weap = StrTok(Weapon,"_");
    if(weap[weap.size-1] != "mp")
        Weapon += "_mp";
    
    if(self hasWeapon(Weapon))
    {
        self SetSpawnWeapon(Weapon);
        return;
    }
    
    self GiveWeapon(Weapon);
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
}

GiveGlowstick()
{
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveWeapon("lightstick_mp");
}