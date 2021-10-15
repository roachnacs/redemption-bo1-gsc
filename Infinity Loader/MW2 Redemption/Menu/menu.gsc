runMenuIndex(menu)
{
    if(menu == "main")
    {
        self addmenu("main","Main Menu");
        if(self getVerification() > 0)
        {
            self addOpt("Main Mods",::newMenu,"Main Mods");
            self addOpt("Teleport Menu",::newMenu,"Teleport Menu");
            self addOpt("Visions Menu",::newMenu,"Visions Menu");
            self addOpt("Camos Menu",::newMenu,"Camos Menu");
            self addOpt("Weapons Menu",::newMenu,"Weapons Menu");
            self addOpt("Spawning Menu",::newMenu,"Spawning Menu");
            self addOpt("Account Menu",::newMenu,"Account Menu");
            self addOpt("Infections Menu",::newMenu,"Infection Menu");
            self addOpt("Trickshot Menu",::newMenu,"Trickshot Menu");
            self addOpt("Binds Menu",::newMenu,"Binds Menu");
            if(self getVerification() > 1)
            {
                self addOpt("Animations Menu",::newMenu,"Animations Menu");
                self addOpt("Aimbot Menu",::newMenu,"Aimbot Menu");
                self addOpt("Admin Menu",::newMenu,"Admin Menu");
                self addOpt("Bots Menu",::newMenu,"Bots Menu");
                self addOpt("Players Menu",::newMenu,"Players Menu");
                self addOpt("All Players Menu",::newMenu,"All Players Menu");
            }
        }
    }
    if(menu == "Main Mods")
    {
        self addMenu("Main Mods","Main Mods");
            self addOpt("God Mode",::GodMode);
            self addOpt("Invisibility",::Invisibility);
            self addOpt("UFO Mode",::UFOMode);
            self addOpt("Infinite Ammo",::InfiniteAmmo);
            self addOpt("Infinite Equipment",::ToggleInfEquipment);
            self addOpt("Bleed Money",::BleedMoney1);
            self addOpt("No Recoil",::NoRecoil);
            self addOpt("No Spread",::NoSpread);
            self addOpt(@"UAV",::UAV);
            self addOpt("Red Box",::RedBox);
            self addOpt("Third Person",::ThirdPerson);
            self addOpt("Pro Mod",::ProMod);
            self addOpt("Rename Yourself",::Keyboard,"Rename Yourself",::RenamePlayer,self);
            self addOpt(@"Suicide",::SelfSuicide);
    }
    if(menu == "Teleport Menu")
    {
        self addMenu("Teleport Menu","Teleport Menu");
            self addOpt("Save Position",::SavePosition);
            self addOpt("Load Position",::LoadPosition);
            self addOpt("Load Position on Spawn",::LoadPositionOnSpawn);
            self addOpt("Saved and Load Bind",::SaveLoadBinds);
            self addOpt("Teleport to Sky",::TeleportToSky);
            self addOpt("Teleport to Crosshair",::TeleportToCrosshair);
            self addOpt("Teleport to Custom Location",::CustomTeleport);
            self addOpt("Spec Nade",::SpecNade);
            self addOpt("Rocket Riding",::RocketRiding);
    }
    if(menu == "Visions Menu")
    {
        visionsProper = StrTok("AC130,AC130 Inverted,Black BW,Chaplin Night,ICBM,MP Intro,Cobra Sunset,Grayscale,Default Night,Nuke Aftermath,Invert Contrast,Sepia",",");
        visions       = StrTok("ac130,ac130_inverted,black_bw,cheat_chaplinnight,icbm,mpintro,cobra_sunset1,grayscale,default_night_mp,mpnuke_aftermath,cheat_invert_contrast",",");
        
        self addMenu("Visions Menu","Visions Menu");
            self addOpt(@"Default",::SetVision,GetDvar("mapname"));
            for(a=0;a<visions.size;a++)
                self addOpt(visionsProper[a],::SetVision,visions[a]);
    }
    if(menu == "Camos Menu")
    {
        self addMenu("Camos Menu","Camos Menu");
            for(a=0;a<9;a++)
                self addOpt(TableLookupIString("mp/camoTable.csv",0,a,2),::CamoChanger,a);
    }
    if(menu == "Weapons Menu")
    {
        classes = StrTok("Assault Rifles,Submachine Guns,Lightmachine Guns,Sniper Rifles,Shotguns,Handguns,Machine Pistols,Launchers",",");
        
        self addMenu("Weapons Menu","Weapons Menu");
            self addOpt("Take All Weapons",::TakeWeapons);
            self addOpt("Take Current Weapon",::TakeCurrentWeapon);
            self addOpt("Drop Current Weapon",::DropWeapon);
            self addOpt("Refill Weapon Ammo",::RefillWeaponAmmo);
            self addOpt("Refill Grenades",::RefillGrenades);
            for(a=0;a<classes.size;a++)
                self addOpt(classes[a],::newMenu,classes[a]);
            self addOpt(@"Riotshield",::GivePlayerWeapon,"riotshield");
            self addOpt("Glowstick",::GiveGlowstick);
            self addOpt("Gold Desert Eagle",::GivePlayerWeapon,"deserteaglegold");
            self addOpt("Default Weapon",::GivePlayerWeapon,"defaultweapon");
    }
    if(menu == "Assault Rifles")
    {
        self addMenu("Assault Rifles","Assault Rifles");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_assault")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Submachine Guns")
    {
        self addMenu("Submachine Guns","Submachine Guns");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_smg")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Lightmachine Guns")
    {
        self addMenu("Lightmachine Guns","Lightmachine Guns");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_lmg")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Sniper Rifles")
    {
        self addMenu("Sniper Rifles","Sniper Rifles");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_sniper")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Shotguns")
    {
        self addMenu("Shotguns","Shotguns");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_shotgun")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Handguns")
    {
        self addMenu("Handguns","Handguns");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_pistol")
                    if(TableLookup("mp/statsTable.csv",0,a,4) != "deserteaglegold")
                        self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Machine Pistols")
    {
        self addMenu("Machine Pistols","Machine Pistols");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_machine_pistol")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Launchers")
    {
        self addMenu("Launchers","Launchers");
            for(a=0;a<52;a++)
                if(TableLookup("mp/statsTable.csv",0,a,2) == "weapon_projectile" && TableLookup("mp/statsTable.csv",0,a,4) != "gl")
                    self addOpt(TableLookupIString("mp/statsTable.csv",0,a,3),::GivePlayerWeapon,TableLookup("mp/statsTable.csv",0,a,4));
    }
    if(menu == "Spawning Menu")
    {
        modelsProper = StrTok("Green Crate,Red Crate,Flag",",");
        models       = StrTok("com_plasticcase_friendly,com_plasticcase_enemy,prop_flag_neutral",",");
        
        self addMenu("Spawning Menu","Spawning Menu");
            for(a=0;a<modelsProper.size;a++)
                self addOpt("Spawn "+modelsProper[a],::SpawnModel,models[a]);
            self addOpt("Spawn Turret",::TurretSpawn);
            self addOpt("Spawn Platform",::SpawnPlatform);
            self addOpt("Spawn Slide",::SpawnSlide);
            self addOpt("Spawn Bounce",::SpawnBounce);
            self addOpt("Bounces Invisible",::BouncesInvisible);
            self addOpt("Forge Mode",::ForgeMode);
    }
    if(menu == "Account Menu")
    {
        self addMenu("Account Menu","Account Menu");
            self addOpt("Level 70",::Level70,self);
            self addOpt("Unlock Everything",::AllChallenges,self);
            self addOpt("Select Prestige",::NumberPad,"Change Prestige",::SetPrestige,self);
    }
    if(menu == "Infection Menu")
    {
        self addMenu("Infection Menu","Infection Menu");
            self addOpt("Force Host",::ForceHostInfection);
            self addOpt("Super Stopping Power",::SuperStoppingPowerInfection);
            self addOpt("Knockback",::KnockbackInfection);
            self addOpt("Chrome Vision",::ChromeInfection);
            self addOpt("Cartoon Vision",::CartoonInfection);
            self addOpt("Rainbow Vision",::RainbowInfection);
            self addOpt("Backspeed",::BackspeedInfection);
            self addOpt("Pro Mod",::ProMod);
            self addOpt("Raised Gun",::RaisedGunInfection);
            self addOpt("Left Side Gun",::LeftSideGunInfection);
    }
    if(menu == "Trickshot Menu")
    {
        self addMenu("Trickshot Menu","Trickshot Menu");
            self addOpt("FFA Fast Last",::FastLast,@"FFA");
            self addOpt("TDM Fast Last",::FastLast,@"TDM");
            self addOpt("SND Fast Last",::FastLast,@"SND");
            self addOpt("Give Cowboy",::doCowboy);
            self addOpt("Give Lowered Gun",::doReverseCowboy);
            self addOpt("Upside Down Screen",::doUpsideDown);
            self addOpt("Tilt Screen Right",::doTiltRight);
            self addOpt("Tilt Screen Left",::doTiltLeft);
            self addOpt("After Hit Menu",::newMenu,"After Hit Menu");
            self addOpt("0.1 Killcam Timer",::SetKillcamTime,1);
            self addOpt("0.2 Killcam Timer",::SetKillcamTime,2);
            self addOpt("0.3 Killcam Timer",::SetKillcamTime,3);
    }
    if(menu == "After Hit Menu")
    {
        self addMenu("After Hit Menu","After Hit Menu");
        self addOpt("Assault Rifles",::newMenu,"After Hit Assault Rifles");
        self addOpt("Submachine Gun",::newMenu,"After Hit SMGs");
        self addOpt("Lightmachine Gun",::newMenu,"After Hit LMGs");
        self addOpt("Sniper Rifles",::newMenu,"After Hit Sniper Rifles");
        self addOpt("Shotguns",::newMenu,"After Hit Shotguns");
        self addOpt("Handguns",::newMenu,"After Hit Handguns");
        self addOpt("Machine Pistols",::newMenu,"After Hit MPistols");
        self addOpt("Launchers",::newMenu,"After Hit Launchers");
        self addOpt("Riotshield",::AfterHit, "riotshield_mp");
    }
    if(menu == "After Hit Assault Rifles")
    {
        self addMenu("After Hit Assault Rifles","After Hit Assault Rifles");
        self addOpt("M4A1",::AfterHit,"m4_mp");
        self addOpt("FAMAS",::AfterHit,"famas_mp");
        self addOpt("SCAR-H",::AfterHit,"scar_mp");
        self addOpt("TAR-21",::AfterHit,"tavor_mp");
        self addOpt("FAL",::AfterHit,"fal_mp");
        self addOpt("M16A4",::AfterHit,"m16_mp");
        self addOpt("ACR",::AfterHit,"masada_mp");
        self addOpt("F2000",::AfterHit,"fn2000_mp");
        self addOpt("AK-47",::AfterHit,"ak47_mp");
    }
    if(menu == "After Hit SMGs")
    {
        self addMenu("After Hit SMGs","After Hit SMGs");
        self addOpt("MP5K",::AfterHit,"mp5k_mp");
        self addOpt("UMP45",::AfterHit,"ump45_mp");
        self addOpt("Vector",::AfterHit,"kriss_mp");
        self addOpt("P90",::AfterHit,"p90_mp");
        self addOpt("Mini-Uzi",::AfterHit,"uzi_mp");
    }
    if(menu == "After Hit LMGs")
    {
        self addMenu("After Hit LMGs","After Hit LMGs");
        self addOpt("L86 LSW",::AfterHit,"sa80_mp");
        self addOpt("RPD",::AfterHit,"rpd_mp");
        self addOpt("MG4",::AfterHit,"mg4_mp");
        self addOpt("AUG HBAR",::AfterHit,"aug_mp");
        self addOpt("M240",::AfterHit,"m240_mp");
    }
    if(menu == "After Hit Sniper Rifles")
    {
        self addMenu("After Hit Sniper Rifles","After Hit Sniper Rifles");
        self addOpt("Intervention",::AfterHit,"cheytac_mp");
        self addOpt("Barrett .50cal",::AfterHit,"barrett_mp");
        self addOpt("WA2000",::AfterHit,"wa2000_mp");
        self addOpt("M21 EBR",::AfterHit,"m21_mp");
    }
    if(menu == "After Hit MPistols")
    {
        self addMenu("After Hit MPistols","After Hit MPistols");
        self addOpt("PP2000",::AfterHit,"pp2000_mp");
        self addOpt("G18",::AfterHit,"glock_mp");
        self addOpt("M93 Raffica",::AfterHit,"beretta393_mp");
        self addOpt("TMP",::AfterHit,"tmp_mp");
    }
    if(menu == "After Hit Shotguns")
    {
        self addMenu("After Hit Shotguns","After Hit Shotguns");
        self addOpt("SPAS-12",::AfterHit,"spas12_mp");
        self addOpt("AA-12",::AfterHit,"aa12_mp");
        self addOpt("Striker",::AfterHit,"striker_mp");
        self addOpt("Ranger",::AfterHit,"ranger_mp");
        self addOpt("M1014",::AfterHit,"m1014_mp");
        self addOpt("Model 1887",::AfterHit,"model1887_mp");
    }
    if(menu == "After Hit Handguns")
    {
        self addMenu("After Hit Handguns","After Hit Handguns");
        self addOpt("USP .45",::AfterHit,"usp_mp");
        self addOpt("USP .45 + Tac Knife",::AfterHit,"usp_tactical_mp");
        self addOpt(".44 Magnum",::AfterHit,"coltanaconda_mp");
        self addOpt(".44 Magnum + Tac Knife",::AfterHit,"coltanaconda_tactical_mp");
        self addOpt("M9",::AfterHit,"beretta_mp");
        self addOpt("M9 + Tac Knife",::AfterHit,"beretta_tactical_mp");
        self addOpt("Desert Eagle",::AfterHit,"deserteagle_mp");
        self addOpt("Desert Eagle + Tac Knife",::AfterHit,"deserteagle_tactical_mp");
    }
    if(menu == "After Hit Launchers")
    {
        self addMenu("After Hit Launchers","After Hit Launchers");
        self addOpt("AT4-HS",::AfterHit,"at4_mp");
        self addOpt("Thumper x 2",::AfterHit,"m79_mp");
        self addOpt("Stinger",::AfterHit,"stinger_mp");
        self addOpt("Javelin",::AfterHit,"javelin_mp");
        self addOpt("RPG-7",::AfterHit,"rpg_mp");
    }
    if(menu == "Binds Menu")
    {
        self addMenu("Binds Menu","Binds Menu");
        self addOpt("Class Change Bind",::newMenu,"Class Change Bind");
        self addOpt("Shax Swap Bind",::shaxswitchstart);
    }
    if(menu == "Class Change Bind")
    {
        self addMenu("Class Change Bind","Class Change Bind");
        self addOpt("Class Change [{+Actionslot 1}]",::glitchclassbind1);
        self addOpt("Class Change [{+Actionslot 4}]",::glitchclassbind4);
        self addOpt("Class Change [{+Actionslot 2}]",::glitchclassbind2);
        self addOpt("Class Change [{+Actionslot 3}]",::glitchclassbind3);
        self addOpt("Class Change Canswap [{+Actionslot 1}]",::CanClassbind1);
        self addOpt("Class Change Canswap [{+Actionslot 4}]",::CanClassbind4);
        self addOpt("Class Change Canswap [{+Actionslot 2}]",::CanClassbind2);
        self addOpt("Class Change Canswap [{+Actionslot 3}]",::CanClassbind3);
    }
    if(menu == "Animations Menu")
    {
        self addMenu("Animations Menu","Animations Menu");
            self addOpt(@"Default",::EndProjectile);
            self addOpt(@"RPG",::Projectile,"rpg");
            self addOpt(@"Thumper",::Projectile,"m79");
            self addOpt(@"Stinger",::Projectile,"stinger");
            self addOpt(@"Javelin",::Projectile,"javelin");
            self addOpt(@"AT4-HS",::Projectile,"at4");
            self addOpt("AC130 25mm",::Projectile,"ac130_25mm");
            self addOpt("AC130 40mm",::Projectile,"ac130_40mm");
            self addOpt("AC130 105mm",::Projectile,"ac130_105mm");
    }
    if(menu == "Aimbot Menu")
    {
        self addMenu("Aimbot Menu","Aimbot Menu");
            self addOpt("Unfair Aimbot",::AimbotUnfair);
            self addOpt("Trickshot Aimbot",::AimbotTrickshot);
            self addOpt("Headshots",::AimbotHeadshots);
            self addOpt("Hitmarkers",::AimbotHitmarkers);
            self addOpt("Require ADS",::AimbotRequireADS);
            self addOpt("Select Aimbot Weapon",::AimbotWeapon);
            self addOpt("Trickshot Strength: 300",::TrickshotAimbotStrength,300);
            self addOpt("Trickshot Strength: 600",::TrickshotAimbotStrength,600);
            self addOpt("Trickshot Strength: 900",::TrickshotAimbotStrength,900);
            self addOpt("Trickshot Strength: Custom",::NumberPad,"Trickshot Aimbot Range",::TrickshotAimbotStrength);
    }
    if(menu == "Admin Menu")
    {
        self addMenu("Admin Menu","Admin Menu");
            self addOpt("Super Jump",::SuperJump);
            self addOpt("Super Speed",::SuperSpeed);
            self addOpt("Slow Motion",::SlowMotion);
            self addOpt("Soft Land",::SoftLand);
            self addOpt("Fake Lag",::YALLLag);
            self addOpt("Add 1 Minute",::ServerSetLobbyTimer,"add");
            self addOpt("Remove 1 Minute",::ServerSetLobbyTimer,"sub");
            self addOpt("Infinite Game",::InfiniteGame);
            self addOpt("Floaters",::ToggleFloaters);
            self addOpt("18 Man Teams",::MaxTeamCount);
            self addOpt("Disco Fog",::DiscoFog);
            self addOpt("DoHeart",::DoHeart);
            self addOpt("DoHeart Text",::DoHeartTextPass,true);
            self addOpt("FFA Xp Per Kill",::NumberPad,"FFA XP Per Kill",::FFAXPPerKill);
            self addOpt("TDM Xp Per Kill",::NumberPad,"TDM XP Per Kill",::TDMXPPerKill);
            self addOpt("Azza Lobby",::AzzaLobby);
            self addOpt("Fast Restart",::ServerRestart);
    }
    if(menu == "Bots Menu")
    {
        self addMenu("Bots Menu","Bots Menu");
            self addOpt("Spawn Enemy Bot",::AddBot,1,"enemy");
            self addOpt("Spawn Friendly Bot",::AddBot,1,"friendly");
            self addOpt("Kill Bots",::BotOptions,1);
            self addOpt("Kick Bots",::BotOptions,2);
            self addOpt("Freeze Bots",::BotOptions,3,"Bots are ^2Frozen");
            self addOpt("UnFreeze Bots",::BotOptions,4,"Bots are ^1UnFrozen");
            self addOpt("Move Bots to Crosshair",::BotOptions,5);
            self addOpt("Set Bots Spawn Location",::BotOptions,6,"Bots will now spawn on this location");
            self addOpt("Reset Bots Spawn Location",::BotOptions,7,"Bots will now spawn like normal");
            self addOpt("Bots Look at Me",::BotOptions,8);
    }
    if(menu == "All Players Menu")
    {
        self addMenu("All Players Menu","All Players Menu");
            self addOpt("Verify All Players",::SetVerificationAllPlayers,1,"^2Verified");
            self addOpt("Admin All Players",::SetVerificationAllPlayers,2,"^3Admin");
            self addOpt("UnVerify All Players",::SetVerificationAllPlayers,0,"^2UnVerified");
            self addOpt("Kill All Players",::AllPlayersThread,0);
            self addOpt("Kick All Players",::AllPlayersThread,1);
            self addOpt("Freeze All Players",::AllPlayersThread,2,"All players have been ^2Frozen");
            self addOpt("UnFreeze All Players",::AllPlayersThread,3,"All players have been ^1UnFrozen");
            self addOpt("Teleport All to Crosshair",::AllPlayersThread,4);
            self addOpt("Give Everyone Unlock All",::AllPlayersThread,5,"All players have been given ^2Unlock All");
            self addOpt("Give Everyone Prestige 10",::AllPlayersThread,6,"All players have been given ^2Prestige 10");
    }
    
    self playerOptions(menu);
}

playerOptions(menu)
{
    players = GetPlayerArray();
    
    if(menu == "Players Menu")
    {
        self addMenu("Players Menu","Players Menu");
            foreach(player in players)
                self addOpt(player getName(),::newMenu,player getName()+" options");
    }
    foreach(player in players)
    {
        if(menu == player getName()+" options")
        {
            self addMenu(player getName()+" options","Edit Player");
                self addOpt("Verify Player",::setVerification,1,"^2Verified",player);
                self addOpt("Admin Player",::setVerification,2,"^3Admin",player);
                self addOpt("UnVerify Player",::setVerification,0,"^2UnVerified",player);
                self addOpt("Kill Player",::KillPlayer,player);
                self addOpt("Kick Player",::KickPlayer,player);
                self addOpt("Freeze Player",::FreezePlayer,player);
                self addOpt("UnFreeze Player",::UnFreezePlayer,player);
                self addOpt("Auto Suicide",::AutoSuicide,player);
                self addOpt("Send to Sky",::SendToSky,player);
                self addOpt("Send to Crosshairs",::SendToCrosshairs,player);
                self addOpt("Revive Player",::RevivePlayer,player);
                self addOpt("Rename Player",::Keyboard,"Rename Selected Player",::RenamePlayer,player);
                self addOpt("Fix Frozen Class",::FixFrozenClasses,player);
                self addOpt("Give Unlock All",::GiveUnlockAll,player);
                self addOpt("Give Prestige",::NumberPad,"Change Player's Prestige",::SetPrestige,player);
                self addOpt("Give Derank",::GiveDerank,player);
                self addOpt("Give FFA Fast Last",::GiveFFAFastLast,player);
                self addOpt("Give Trickshot Aimbot",::GiveTrickshotAimbot,player);
        }
    }
}

menuMonitor()
{
    while(true)
    {
        if(self getVerification() > 0)
        {
            if(!self isInMenu())
            {
                if(self AdsButtonPressed() && self isButtonPressed("+actionslot 4"))
                {
                    self openMenu1("main");
                    wait .25;
                }
            }
            else
            {
                if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
                {
                    curs = self getCursor();
                    menu = self getCurrent();
                    
                    self.menu["curs"][menu] += self isButtonPressed("+actionslot 2");
                    self.menu["curs"][menu] -= self isButtonPressed("+actionslot 1");
                    
                    if(curs != self.menu["curs"][menu])
                        scrollMenu((self isButtonPressed("+actionslot 2") ? 1 : -1), curs);
                    wait .1;
                }
                else if(self UseButtonPressed())
                {
                    menu = self getCurrent();
                    curs = self getCursor();
                    
                    if(isDefined(self.menu["items"][menu].func[curs]))
                    {
                        if(self.menu["items"][menu].func[curs] == ::newMenu)
                        {
                            self MenuArrays(menu);
                            self thread runMenuIndex(self.menu["items"][menu].input1[curs]);
                        }
                        self thread [[self.menu["items"][menu].func[curs]]] (self.menu["items"][menu].input1[curs],self.menu["items"][menu].input2[curs],self.menu["items"][menu].input3[curs]);
                    }
                    wait .2;
                }
                else if(self MeleeButtonPressed())
                {
                    if(self getCurrent() == "main")
                        self closeMenu1();
                    else
                        self newMenu();
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

drawText()
{
    destroyAll(self.menu["ui"]["text"]);
    if(!isDefined(self.menu["curs"][self getCurrent()]))
        self.menu["curs"][self getCurrent()] = 0;
    
    text    = self.menu["items"][self getCurrent()].name;
    numOpts = text.size;
    for(a=0;a<numOpts;a++)
        self.menu["ui"]["text"][a] = self createText(self.menu["Option_Font"],self.menu["Option_Fontscale"],5,text[a],self.menu["Option_Align"],"CENTER",self.menu["OptionX"],self.menu["OptionsY"]+(a*self.menu["OptionsSeparation"]),.1,self.menu["Option_Color"]);
    
    self.menu["ui"]["scroller"] thread hudMoveY(self.menu["ui"]["text"][self getCursor()].y+1,.2);
    for(a=0;a<numOpts;a++)
        self.menu["ui"]["text"][a] thread hudFade(self.menu["Option_Alpha"],(.1*a));
    self.menu["ui"]["text"][self getCursor()] ChangeFontScaleOverTime1(self.menu["Option_Fontscale"]+.1,.2);
    self.menu["ui"]["text"][self getCursor()] hudFadeColor(self.menu["Curs_Color"],.2);
}

scrollMenu(dir,OldCurs)
{
    arry = self.menu["items"][self getCurrent()].name;
    curs = self getCursor();
    
    if(curs < 0 || curs > (arry.size-1))
    {
        self setCursor((curs < 0) ? (arry.size-1) : 0);
        curs = getCursor();
    }
    
    self.menu["ui"]["scroller"] thread hudMoveY(self.menu["ui"]["text"][curs].y+1,.2);
    for(a=0;a<arry.size;a++)
        if(a != curs)
        {
            self.menu["ui"]["text"][a] ChangeFontScaleOverTime1(self.menu["Option_Fontscale"],.2);
            self.menu["ui"]["text"][a] hudFadeColor(self.menu["Option_Color"],.2);
        }
    
    self.menu["ui"]["text"][curs] ChangeFontScaleOverTime1(self.menu["Option_Fontscale"]+.1,.2);
    self.menu["ui"]["text"][curs] hudFadeColor(self.menu["Curs_Color"],.2);
}

SetMenuTitle(title)
{
    if(!isDefined(self.menu["ui"]["title"]))
        return;
    if(!isDefined(title))
        title = self.menu["items"][self getCurrent()].title;
    self.menu["ui"]["title"] SetSafeText(title);
}

openMenu1(menu)
{
    self.menu["ui"]["background"] = self createRectangle("CENTER", "CENTER", self.menu["X"], self.menu["Y"], self.menu["Background_Width"], self.menu["Background_Height"], self.menu["Background_Color"], 2, 0, self.menu["Background_Shader"]);
    self.menu["ui"]["background"] thread hudFade(self.menu["Background_Alpha"],.3);
    self.menu["ui"]["scroller"] = self createRectangle("CENTER", "CENTER", self.menu["X"], self.menu["Y"]-40, self.menu["Scroller_Width"], self.menu["Scroller_Height"], self.menu["Main_Color"], 3, 0, self.menu["Scroller_Shader"]);
    self.menu["ui"]["scroller"] thread hudFade(self.menu["Scroller_Alpha"],.3);
    self.menu["ui"]["barTop"] = self createRectangle("CENTER", "CENTER", self.menu["BannerX"], self.menu["BannerY"], self.menu["Banner_Width"], self.menu["Banner_Height"], self.menu["Main_Color"], 4, 0, self.menu["Banner_Shader"]);
    self.menu["ui"]["barTop"] thread hudFade(self.menu["Banner_Alpha"],.3);
    self.menu["ui"]["barBottom"] = self createRectangle("CENTER", "CENTER", self.menu["BannerBottomX"], self.menu["BannerBottomY"], self.menu["BannerBottom_Width"], self.menu["BannerBottom_Height"], self.menu["Main_Color"], 4, 0, self.menu["Banner_Shader"]); 
    self.menu["ui"]["barBottom"] thread hudFade(self.menu["Banner_Alpha"],.3);
    
    if(!self.menu["curs"][getCurrent()])
        self.menu["curs"][getCurrent()] = 0;
    self runMenuIndex(menu);
    self.menu["currentMenu"] = menu;
    
    self.menu["ui"]["title"] = self createText(self.menu["Title_Font"],self.menu["Title_Fontscale"], 5, "", self.menu["Title_Align"], "CENTER", self.menu["TitleX"], self.menu["TitleY"], 0, self.menu["Title_Color"], 1, self.menu["Main_Color"]);
    self.menu["ui"]["title"] thread hudFade(self.menu["Title_Alpha"],.3);
    self.menu["ui"]["MenuName"] = self createText(self.menu["Title_Font"],self.menu["MenuName_Fontscale"], 5, getMenuName(), self.menu["MenuName_Align"], "CENTER", self.menu["MenuNameX"], self.menu["MenuNameY"], 0, self.menu["Title_Color"], 1, self.menu["Main_Color"]);
    self.menu["ui"]["MenuName"] thread hudFade(self.menu["Title_Alpha"],.3);
    self.menu["ui"]["Dev"] = self createText(self.menu["Dev_Font"],self.menu["Dev_Fontscale"], 5, "by: Roach", self.menu["Dev_Align"], "CENTER", self.menu["TitleX"], self.menu["MenuNameY"]+15, 0, self.menu["Main_Color"]);
    self.menu["ui"]["Dev"] thread hudFade(self.menu["Title_Alpha"],.3);
    
    self SetMenuTitle();
    self drawText();
    
    self.playerSetting["isInMenu"] = true;
    self thread WatchForDeath();
}

WatchForDeath()
{
    self endon("disconnect");
    self endon("menuClosed");
    
    while(self isInMenu())
    {
        self waittill("death");
        self closeMenu1();
    }
}

closeMenu1()
{
    self.menu["ui"]["background"] thread hudFadenDestroy(0,.3);
    self.menu["ui"]["scroller"] thread hudFadenDestroy(0,.3);
    self.menu["ui"]["barTop"] thread hudFadenDestroy(0,.3);
    self.menu["ui"]["barBottom"] thread hudFadenDestroy(0,.3);
  
    self.menu["ui"]["title"] thread hudFadenDestroy(0,.3);
    self.menu["ui"]["MenuName"] thread hudFadenDestroy(0,.3);
    self.menu["ui"]["Dev"] thread hudFadenDestroy(0,.3);
    for(a=0;a<self.menu["ui"]["text"].size;a++)
        if(isDefined(self.menu["ui"]["text"][a]))
            self.menu["ui"]["text"][a] thread hudFadenDestroy(0,.3);
    wait .3;
    self.playerSetting["isInMenu"] = undefined;
    self notify("menuClosed");
}

RefreshMenu()
{
    if(self isInMenu())
    {
        destroyAll(self.menu["ui"]["text"]);
        self SetMenuTitle();
        self drawText();
    }
}