#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
init()
{
	precacheString(&"PLATFORM_PRESS_TO_SKIP");
	precacheString(&"PLATFORM_PRESS_TO_RESPAWN");
	precacheString(&"PLATFORM_PRESS_TO_COPYCAT");
	setDvar("killcam_final", "1");
	precacheShader("specialty_copycat");
	precacheShader("white");
	level.killcam = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "allowkillcam" );
	level.finalkillcam = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "allowfinalkillcam" );
	if( level.killcam )
	setArchive(true);
}
finalKillcamWaiter()
{
	if ( !level.inFinalKillcam )
	return;
	while (level.inFinalKillcam)
	wait(0.05);
}

postRoundFinalKillcam()
{
	if ( isDefined( level.sidebet ) && level.sidebet )
	{
		return;
	}
	level notify( "play_final_killcam" );
	maps\mp\gametypes\_globallogic::resetOutcomeForAllPlayers();
	finalKillcamWaiter();
}

startFinalKillcam(attackerNum, targetNum, killcamentity, killcamentityindex, killcamentitystarttime, sWeapon, deathTime, deathTimeOffset, offsetTime, perks, killstreaks, attacker )
{
	if ( !level.finalkillcam )
		return;
	if(attackerNum < 0)
		return;
	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, killcamentityindex, killcamentitystarttime, perks, killstreaks, attacker );
	startLastKillcam();
}

startLastKillcam()
{
	if ( !level.finalkillcam )
		return;
	if ( level.inFinalKillcam )
		return;
	if ( !IsDefined(level.lastKillCam) )
		return;
	level.inFinalKillcam = true;
	level waittill ( "play_final_killcam" );
	if ( isdefined ( level.lastKillCam.attacker ) )
		level.lastKillCam.attacker notify( "finalKillCamKiller" );
	visionSetNaked( GetDvar( #"mapname" ), 0.0 );
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player closeMenu();
		player closeInGameMenu();
		player thread finalKillcam();
	}
	wait( 0.1 );
	while ( areAnyPlayersWatchingTheKillcam() )
	wait( 0.05 );
	level.inFinalKillcam = false;
}

areAnyPlayersWatchingTheKillcam()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		if ( isDefined( player.killcam ) )
		return true;
	}
	return false;
}

killcam(attackerNum, targetNum, killcamentity, killcamentityindex, killcamentitystarttime, sWeapon, deathTime, deathTimeOffset, offsetTime, respawn, maxtime, perks, killstreaks, attacker )
{
	self endon("disconnect");
	self endon("spawned");
	level endon("game_ended");
	if(attackerNum < 0)
		return;
	postDeathDelay = (getTime() - deathTime) / 1000;
	predelay = postDeathDelay + deathTimeOffset;
	camtime = calcKillcamTime( sWeapon, killcamentitystarttime, predelay, respawn, maxtime );
	postdelay = calcPostDelay();
	killcamlength = camtime + postdelay;
	if (isdefined(maxtime) && killcamlength > maxtime)
	{
		if (maxtime < 2)
			return;
		if (maxtime - camtime >= 1) 
		{
			postdelay = maxtime - camtime;
		}
		else 
		{
			postdelay = 1;
			camtime = maxtime - 1;
		}
		killcamlength = camtime + postdelay;
	}
	killcamoffset = camtime + predelay;
	self notify ( "begin_killcam", getTime() );
	killcamstarttime = (gettime() - killcamoffset * 1000);
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = -1;
	if ( killcamentityindex >= 0 )
		self thread setKillCamEntity( killcamentityindex, killcamentitystarttime - killcamstarttime - 100 );
	self.killcamtargetentity = targetNum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;
	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, killcamentityindex, killcamentitystarttime, perks, killstreaks, attacker );
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	self thread endedKillcamCleanup();
	wait 0.05;
	if ( self.archivetime <= predelay )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self notify ( "end_killcam" );
		return;
	}
	self thread checkForAbruptKillcamEnd();
	self.killcam = true;
	self addKillcamSkipText(respawn);
	if ( !( self IsSplitscreen() ) && GetDvarInt( #"scr_game_perks" ) == 1 )
	{
		self maps\mp\gametypes\_hud_util::showPerk( 0, perks[0], 0 );
		self maps\mp\gametypes\_hud_util::showPerk( 1, perks[1], 0 );
		self maps\mp\gametypes\_hud_util::showPerk( 2, perks[2], 0 );
		self maps\mp\gametypes\_hud_util::showPerk( 3, perks[3], 0 );
	}
	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitTeamChangeEndKillcam();
	self thread waitKillcamTime();
	self thread maps\mp\gametypes\_copycat::copycat_button_think();
	self thread maps\mp\_tacticalinsertion::cancel_button_think();
	self waittill("end_killcam");
	self endKillcam(false);
	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

setKillCamEntity( killcamentityindex, delayms )
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("spawned");
	if ( delayms > 0 )
	wait delayms / 1000;
	self.killcamentity = killcamentityindex;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");
	wait(self.killcamlength - 0.05);
	self notify("end_killcam");
}
waitFinalKillcamSlowdown( startTime )
{
	self endon("disconnect");
	self endon("end_killcam");
	secondsUntilDeath = ( ( level.lastKillCam.deathTime - startTime ) / 1000 );
	deathTime = getTime() + secondsUntilDeath * 1000;
	waitBeforeDeath = 2;
	self clientNotify("fkcb");
	wait( max(0, (secondsUntilDeath - waitBeforeDeath) ) );
	SetTimeScale( 0.15, int( deathTime - 500 ) );
	wait( waitBeforeDeath + 1 );
	SetTimeScale( 1.0, getTime() + 500 );
	wait(.5);
	self clientNotify("fkce");
}

waitSkipKillcamButton()
{
	self endon("disconnect");
	self endon("end_killcam");
	while(self useButtonPressed())
	wait .05;
	while(!(self useButtonPressed()))
	wait .05;
	self notify("end_killcam");
	self clientNotify("fkce");
}

waitTeamChangeEndKillcam()
{
	self endon("disconnect");
	self endon("end_killcam");
	self waittill("changed_class");
	endKillcam( false );
}

waitSkipKillcamSafeSpawnButton()
{
	self endon("disconnect");
	self endon("end_killcam");
	while(self fragButtonPressed())
	wait .05;
	while(!(self fragButtonPressed()))
	wait .05;
	self.wantSafeSpawn = true;
	self notify("end_killcam");
}

endKillcam( final )
{
	if(isDefined(self.kc_skiptext))
	self.kc_skiptext.alpha = 0;
	self.killcam = undefined;
	if ( !( self IsSplitscreen() ) )
	{
		self hidePerk( 0 );
		self hidePerk( 1 );
		self hidePerk( 2 );
		self hidePerk( 3 );
	}
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

checkForAbruptKillcamEnd()
{
	self endon("disconnect");
	self endon("end_killcam");
	while(1)
	{
		if ( self.archivetime <= 0 )
		break;
		wait .05;
	}
	self notify("end_killcam");
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");
	self waittill("spawned");
	self endKillcam(false);
}

spectatorKillcamCleanup( attacker )
{
	self endon("end_killcam");
	self endon("disconnect");
	attacker endon ( "disconnect" );
	attacker waittill ( "begin_killcam", attackerKcStartTime );
	waitTime = max( 0, (attackerKcStartTime - self.deathTime) - 50 );
	wait (waitTime);
	self endKillcam(false);
}

endedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");
	level waittill("game_ended");
	self endKillcam(false);
}

endedFinalKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");
	level waittill("game_ended");
	self endKillcam(true);
}

cancelKillCamUseButton()
{
	return self useButtonPressed();
}

cancelKillCamSafeSpawnButton()
{
	return self fragButtonPressed();
}

cancelKillCamCallback()
{
	self.cancelKillcam = true;
}

cancelKillCamSafeSpawnCallback()
{
	self.cancelKillcam = true;
	self.wantSafeSpawn = true;
}

cancelKillCamOnUse()
{
	self thread cancelKillCamOnUse_specificButton( ::cancelKillCamUseButton, ::cancelKillCamCallback );
}

cancelKillCamOnUse_specificButton( pressingButtonFunc, finishedFunc )
{
	self endon ( "death_delay_finished" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	for ( ;; )
	{
		if ( !self [[pressingButtonFunc]]() )
		{
			wait ( 0.05 );
			continue;
		}
		buttonTime = 0;
		while( self [[pressingButtonFunc]]() )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		if ( buttonTime >= 0.5 )
		continue;
		buttonTime = 0;
		while ( !self [[pressingButtonFunc]]() && buttonTime < 0.5 )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		if ( buttonTime >= 0.5 )
		continue;
		self [[finishedFunc]]();
		return;
	}
}

recordKillcamSettings( spectatorclient, targetentityindex, sWeapon, deathTime, deathTimeOffset, offsettime, entityindex, entitystarttime, perks, killstreaks, attacker )
{
	if ( !IsDefined(level.lastKillCam) )
	{
		level.lastKillCam = SpawnStruct();
	}
	level.lastKillCam.spectatorclient = spectatorclient;
	level.lastKillCam.weapon = sWeapon;
	level.lastKillCam.deathTime = deathTime;
	level.lastKillCam.deathTimeOffset = deathTimeOffset;
	level.lastKillCam.offsettime = offsettime;
	level.lastKillCam.entityindex = entityindex;
	level.lastKillCam.targetentityindex = targetentityindex;
	level.lastKillCam.entitystarttime = entitystarttime;
	level.lastKillCam.perks = perks;
	level.lastKillCam.killstreaks = killstreaks;
	level.lastKillCam.attacker = attacker;
}

finalKillcam()
{
	self endon("disconnect");
	level endon("game_ended");
	if ( wasLastRound() )
	{
		setMatchFlag( "final_killcam", 1 );
		setMatchFlag( "round_end_killcam", 0 );
	}
	else
	{
		setMatchFlag( "final_killcam", 0 );
		setMatchFlag( "round_end_killcam", 1 );
	}
	if( level.console )
		self maps\mp\gametypes\_globallogic_spawn::setThirdPerson( false );
	postDeathDelay = (getTime() - level.lastKillCam.deathTime) / 1000;
	predelay = postDeathDelay + level.lastKillCam.deathTimeOffset;
	camtime = calcKillcamTime( level.lastKillCam.weapon, level.lastKillCam.entitystarttime, predelay, false, undefined );
	postdelay = calcPostDelay();
	killcamoffset = camtime + predelay;
	killcamlength = camtime + postdelay - 0.05;
	killcamstarttime = (gettime() - killcamoffset * 1000);
	self notify ( "begin_killcam", getTime() );
	self.sessionstate = "spectator";
	self.spectatorclient = level.lastKillCam.spectatorclient;
	self.killcamentity = -1;
	if ( level.lastKillCam.entityindex >= 0 )
		self thread setKillCamEntity( level.lastKillCam.entityindex, level.lastKillCam.entitystarttime - killcamstarttime - 100 );
	self.killcamtargetentity = level.lastKillCam.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = level.lastKillCam.offsettime;
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	self thread endedFinalKillcamCleanup();
	wait 0.05;
	if ( self.archivetime <= predelay )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self notify ( "end_killcam" );
		return;
	}
	self thread checkForAbruptKillcamEnd();
	self.killcam = true;
	self thread waitKillcamTime();
	self thread waitFinalKillcamSlowdown( killcamstarttime );
	self waittill("end_killcam");
	self endKillcam(true);
	setMatchFlag( "final_killcam", 0 );
	setMatchFlag( "round_end_killcam", 0 );
	self spawnEndOfFinalKillCam();
}

spawnEndOfFinalKillCam()
{
	self FreezeControls( true );
	[[level.spawnSpectator]]();
}

isKillcamEntityWeapon( sWeapon )
{
	if (sWeapon == "airstrike_mp")
	{
		return true;
	}
	else if (sWeapon == "napalm_mp" )
	{
		return true;
	}
	return false;
}

isKillcamGrenadeWeapon( sWeapon )
{
	if (sWeapon == "frag_grenade_mp")
	{
		return true;
	}
	else if (sWeapon == "frag_grenade_short_mp" )
	{
		return true;
	}
	else if ( sWeapon == "sticky_grenade_mp" )
	{
		return true;
	}
	else if ( sWeapon == "tabun_gas_mp" )
	{
		return true;
	}
	return false;
}

calcKillcamTime( sWeapon, entitystarttime, predelay, respawn, maxtime )
{
	camtime = 0.0;
	if (GetDvar( #"scr_killcam_time") == "")
	{
		if (sWeapon == "artillery_mp")
		{
			camtime = 2.5;
		}
		else if ( isKillcamEntityWeapon( sWeapon ) )
		{
			camtime = (gettime() - entitystarttime) / 1000 - predelay - .1;
		}
		else if ( !respawn )
		{
			camtime = 5.0;
		}
		else if ( isKillcamGrenadeWeapon( sWeapon ) )
		{
			camtime = 4.25;
		}
		else
			camtime = 2.5;
	}
	else
		camtime = GetDvarFloat( #"scr_killcam_time");
	if (isdefined(maxtime)) 
	{
		if (camtime > maxtime)
		camtime = maxtime;
		if (camtime < .05)
		camtime = .05;
	}
	return camtime;
}

calcPostDelay()
{
	postdelay = 0;
	if (GetDvar( #"scr_killcam_posttime") == "")
	{
		postdelay = 2;
	}
	else
	{
		postdelay = GetDvarFloat( #"scr_killcam_posttime");
		if (postdelay < 0.05)
		postdelay = 0.05;
	}
	return postdelay;
}

addKillcamSkipText(respawn)
{
	if ( !isdefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.horzAlign = "center";
		self.kc_skiptext.vertAlign = "bottom";
		self.kc_skiptext.sort = 1;
		self.kc_skiptext.font = "objective";
		self.kc_skiptext.foreground = true;
		if ( self IsSplitscreen() )
		{
			self.kc_skiptext.y = -100;
			self.kc_skiptext.fontscale = 1.4;
		}
		else
		{
			self.kc_skiptext.y = -120;
			self.kc_skiptext.fontscale = 2;
		}
	}
	if ( respawn )
	self.kc_skiptext setText(&"PLATFORM_PRESS_TO_RESPAWN");
	else
	self.kc_skiptext setText(&"PLATFORM_PRESS_TO_SKIP");
	self.kc_skiptext.alpha = 1;
}

initKCElements()
{
	if ( !isDefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "top";
		self.kc_skiptext.horzAlign = "center_adjustable";
		self.kc_skiptext.vertAlign = "top_adjustable";
		self.kc_skiptext.sort = 1;
		self.kc_skiptext.font = "default";
		self.kc_skiptext.foreground = true;
		self.kc_skiptext.hideWhenInMenu = true;
		if ( self IsSplitscreen() )
		{
			self.kc_skiptext.y = 20;
			self.kc_skiptext.fontscale = 1.2;
		}
		else
		{
			self.kc_skiptext.y = 32;
			self.kc_skiptext.fontscale = 1.8;
		}
	}
	if ( !isDefined( self.kc_othertext ) )
	{
		self.kc_othertext = newClientHudElem(self);
		self.kc_othertext.archived = false;
		self.kc_othertext.y = 48;
		self.kc_othertext.alignX = "left";
		self.kc_othertext.alignY = "top";
		self.kc_othertext.horzAlign = "center";
		self.kc_othertext.vertAlign = "middle";
		self.kc_othertext.sort = 10;
		self.kc_othertext.font = "small";
		self.kc_othertext.foreground = true;
		self.kc_othertext.hideWhenInMenu = true;
		if ( self IsSplitscreen() )
		{
			self.kc_othertext.x = 16;
			self.kc_othertext.fontscale = 1.2;
		}
		else
		{
			self.kc_othertext.x = 32;
			self.kc_othertext.fontscale = 1.6;
		}
	}
	if ( !isDefined( self.kc_icon ) )
	{
		self.kc_icon = newClientHudElem(self);
		self.kc_icon.archived = false;
		self.kc_icon.x = 16;
		self.kc_icon.y = 16;
		self.kc_icon.alignX = "left";
		self.kc_icon.alignY = "top";
		self.kc_icon.horzAlign = "center";
		self.kc_icon.vertAlign = "middle";
		self.kc_icon.sort = 1;
		self.kc_icon.foreground = true;
		self.kc_icon.hideWhenInMenu = true;
	}
}