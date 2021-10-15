Level70(player)
{
    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
    
    player giveRankXP1(2516500);
    player PlaySound("mp_level_up");
    
    SetDvar("xblive_privatematch",type);
    type = true;
    if(type == 1)
        type = false;
    level.onlineGame  = type;
    level.rankedMatch = type;
    
    player iPrintln("Level 70 ^2Set");
}

giveRankXP1(value)
{
    if(self GetPlayerData("restXPGoal") > self maps\mp\gametypes\_rank::getRankXP())
        self SetPlayerData("restXPGoal",self GetPlayerData("restXPGoal") + value);
    oldxp = self maps\mp\gametypes\_rank::getRankXP();
    self maps\mp\gametypes\_rank::incRankXP(value);
    if(maps\mp\gametypes\_rank::updateRank(oldxp))
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
    self maps\mp\gametypes\_rank::syncXPStat();
    
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
}

AllChallenges(player)
{
    if(isDefined(player.AllChallengesProgress))return;
    player.AllChallengesProgress = true;
    
    player endon("disconnect");
    
    player iPrintlnBold("Unlock All ^2Started");
    player SetPlayerData("iconUnlocked","cardicon_prestige10_02",1);
    foreach(challengeRef,challengeData in level.challengeInfo)
    {
        finalTarget = 0;
        finalTier   = 0;
        
        for(tierId=1;isDefined(challengeData["targetval"][tierId]);tierId++)
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier   = tierId + 1;
        }
        
        player SetPlayerData("challengeProgress",challengeRef,finalTarget);
        player SetPlayerData("challengeState",challengeRef,finalTier);
        
        wait .01;
    }
    player iPrintlnBold("Unlock All ^2Complete");
    player.AllChallengesProgress = undefined;
}

SetPrestige(value,player)
{
    if(value == 10)
        Prestige = "0A000";
    else if(value >= 11)
        Prestige = "0B000";
    else Prestige = "0"+value+"000";
    
    SV_GameSendServerCommand("J 2064 "+Prestige+";",player);
}