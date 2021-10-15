FixOverflow()
{
    level.overflow       = NewHudElem();
    level.overflow.alpha = 0;
    level.overflow setText("marker");

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if(level.strings.size >= 45)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
            for(a=0;a<level.players.size;a++)
                if(level.players[a] hasMenu() && level.players[a] isInMenu())
                    level.players[a] thread RefreshMenu();
        }
    }
}

SetSafeText(text)
{
    self notify("stop_TextMonitor");
    self AddToStringArray(text);
    self thread watchforoverflow(text);
}

AddToStringArray(text)
{
    if(!isInArray(level.strings,text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

WatchForOverflow(text)
{
    self endon("stop_TextMonitor");
    
    while(isDefined(self))
    {
        self SetText(text);
        level waittill("FIX_OVERFLOW");
    }
}