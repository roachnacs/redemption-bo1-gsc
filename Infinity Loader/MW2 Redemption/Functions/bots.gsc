AddBot(num,team)
{
    if(team == "enemy")
        team = self GetEnemyTeam();
    else
        team = self.pers["team"];
    
    bot = [];
    for(a=0;a<num;a++)
    {
        bot[a] = AddTestClient();
        if(!isDefined(bot[a]))
        {
            wait 1;
            continue;
        }
        bot[a].pers["isBot"] = true;
        bot[a] thread SpawnBot(team);
        wait .1;
    }
}

GetEnemyTeam()
{
    if(self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    
    return team;
}

SpawnBot(team)
{
    self endon("disconnect");
    
    while(!isDefined(self.pers["team"]))
        wait .025;
    self notify("menuresponse",game["menu_team"],team);
    wait .1;
    self notify("menuresponse","changeclass","class"+randomInt(5));
    self waittill("spawned_player");
}

BotOptions(a,print)
{
     switch(a)
     {
        case 1:
            foreach(player in level.players)
                if(isDefined(player.pers["isBot"]))
                    player Suicide();
            break;
        case 2:
            foreach(player in level.players)
                if(isDefined(player.pers["isBot"]))
                    kick(player GetEntityNumber());
            break;
        case 3:
            SetDvar("testClients_doMove",0);
            SetDvar("testClients_doAttack",0);
            SetDvar("testClients_doReload",0);
            SetDvar("testClients_watchKillcam",0);
            break;
        case 4:
            SetDvar("testClients_doMove",1);
            SetDvar("testClients_doAttack",1);
            SetDvar("testClients_doReload",1);
            SetDvar("testClients_watchKillcam",1);
            break;
        case 5:
            foreach(player in level.players)
                if(isDefined(player.pers["isBot"]))
                    player SetOrigin(self TraceBullet());
            break;
        case 6:
            level.CustomBotSpawn = self TraceBullet();
            foreach(player in level.players)
                if(isDefined(player.pers["isBot"]))
                {
                    player SetOrigin(level.CustomBotSpawn);
                    player thread BotSpawnLocation();
                }
            break;
        case 7:
            level.CustomBotSpawn = undefined;
            break;
        case 8:
            foreach(player in level.players)
                if(isDefined(player.pers["isBot"]))
                    player SetPlayerAngles(VectorToAngles(self GetTagOrigin("j_head") - player GetTagOrigin("j_head")));
            break;
        default:
            break;
    }
    
    if(isDefined(print))self iPrintln(print);
}

BotSpawnLocation()
{
    while(isDefined(level.CustomBotSpawn))
    {
        self waittill("spawned_player");
        self SetOrigin(level.CustomBotSpawn);
    }
}