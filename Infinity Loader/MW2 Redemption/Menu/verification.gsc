setVerification(a,proper,player)
{
    if(player isHost() || player isDeveloper() || isDefined(player.playerSetting["verification"]) && player getVerification() == a)
        return;
    
    player.playerSetting["verification"] = level.MenuStatus[a];
    if(player isInMenu())
    {
        if(player getCurrent() != "main")
            player thread newMenu("main");
        player setCursor(0);
        player thread closeMenu1();
    }
    if(a > 0)
        player thread welcomeMessage();
    self iPrintln("You changed the client's verification to: "+proper);
}

getVerification()
{
    if(!isDefined(self.playerSetting["verification"]))
        return 0;
    
    for(a=0;a<level.MenuStatus.size;a++)
        if(self.playerSetting["verification"] == level.MenuStatus[a])
            return a;
}

SetVerificationAllPlayers(a,proper)
{
    foreach(player in level.players)
    {
        if(player isHost() || player isDeveloper() || isDefined(player.playerSetting["verification"]) && player getVerification() == a)
            continue;
        
        player.playerSetting["verification"] = level.MenuStatus[a];
        if(player isInMenu())
        {
            if(player getCurrent() != "main")
                player thread newMenu("main");
            player setCursor(0);
            player thread closeMenu1();
        }
        if(a > 0)
            player thread welcomeMessage();
    }
    if(level.players.size > 1)
        self iPrintln("You changed the client's verification to: "+proper);
}