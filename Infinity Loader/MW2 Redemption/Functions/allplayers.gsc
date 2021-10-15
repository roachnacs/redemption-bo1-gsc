AllPlayersThread(num,print)
{
    if(!isDefined(num))
        return;
    
    foreach(player in level.players)
        if(!player isHost() && !player isDeveloper())
            player thread AllPlayerFunctions(num,self);
    
    if(isDefined(print))
        self iPrintln(print);
}

AllPlayerFunctions(num,player)
{
    switch(num)
    {
        case 0:
            self Suicide();
            break;
        case 1:
            Kick(self GetEntityNumber());
            break;
        case 2:
            self FreezeControls(true);
            break;
        case 3:
            self FreezeControls(false);
            break;
        case 4:
            self SetOrigin(player TraceBullet());
            break;
        case 5:
            self AllChallenges(self);
            break;
        case 6:
            self SetPrestige(10,self);
            break;
        default:
            break;
    }
}