BuildMenu()
{
    self endon("disconnect");
    self endon("death");
    self.MenuOpen = false;
    self.Menu = spawnstruct();
    self InitialisingMenu();
    self MenuStructure();
    self thread MenuDeath();
    while (1)
    {
        if(self adsButtonPressed() && self actionslotfourbuttonpressed() && self.MenuOpen == false)
        {
            self MenuOpening();
            self LoadMenu("redemption");
        }
        else if(self MeleeButtonPressed() && self.MenuOpen == true)
        {
            if(isDefined(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]))
            {
                self SubMenu(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]);
                wait 0.2;
            }
            else
            {
                self MenuClosing();
                wait 1;
            }
        }
        else if (self actionslotonebuttonpressed() && self.MenuOpen == true)
        {
            self.Menu.System["MenuCurser"] -= 1;
            if (self.Menu.System["MenuCurser"] < 0)
            {
                self.Menu.System["MenuCurser"] = self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size - 1;
            }
            self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
            wait.2;
        }
        else if (self actionslottwobuttonpressed() && self.MenuOpen == true)
        {
            self.Menu.System["MenuCurser"] += 1;
            if (self.Menu.System["MenuCurser"] >= self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size)
            {
                self.Menu.System["MenuCurser"] = 0;
            }
            self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
            wait.2;
        }
        else if(self usebuttonpressed() && self.MenuOpen == true)
        {
                wait 0.2;
                if(self.Menu.System["MenuRoot"]=="Clients Menu") self.Menu.System["ClientIndex"]=self.Menu.System["MenuCurser"];
                self thread [[self.Menu.System["MenuFunction"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]]](self.Menu.System["MenuInput"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
                wait 0.2;
        }
        wait 0.05;
    }
}    



MainMenu(Menu, Return)
{
    self.Menu.System["GetMenu"] = Menu;
    self.Menu.System["MenuCount"] = 0;
    self.Menu.System["MenuPrevious"][Menu] = Return;
}
MenuOption(Menu, Index, Texte, Function, Input)
{
    self.Menu.System["MenuTexte"][Menu][Index] = Texte;
    self.Menu.System["MenuFunction"][Menu][Index] = Function;
    self.Menu.System["MenuInput"][Menu][Index] = Input;
}
SubMenu(input)
{
    self.Menu.System["MenuCurser"] = 0;
    self.Menu.System["Texte"] fadeovertime(0.05);
    self.Menu.System["Texte"].alpha = 0;
    self.Menu.System["Texte"] destroy();
    self.Menu.System["Credits"] destroy();
    self.Menu.System["Title"] destroy();
    self thread LoadMenu(input);
    if(self.Menu.System["MenuRoot"]=="Client Function")
    {
    self.Menu.System["Title"] destroy();
    player = level.players[self.Menu.System["ClientIndex"]];
    self.Menu.System["Title"] = self createFontString("default", 2.0);
    self.Menu.System["Title"] setPoint("LEFT", "TOP", 205, 10);
    self.Menu.System["Title"] setText("[" + player.MyAccess + "^7] " + player.name);
    self.Menu.System["Title"].sort = 3;
    self.Menu.System["Title"].alpha = 1;
    }
}
LoadMenu(menu)
{
    self.Menu.System["Credits"] = self createFontString("objective", 1.1);
    self.Menu.System["Credits"] setPoint("LEFT", "TOP", 205, 435);
    self.Menu.System["Credits"] setText("made by roach");
    self.Menu.System["Credits"].sort = 4;
    self.Menu.System["Credits"].alpha = 1;
    self.Menu.System["MenuCurser"] = 0;
    self.Menu.System["MenuRoot"] = menu;
    self.Menu.System["Title"] = self createFontString("default", 2.0);
    self.Menu.System["Title"] setPoint("LEFT", "TOP", 205, 10);
    self.Menu.System["Title"] setText(menu);
    self.Menu.System["Title"].sort = 3;
    self.Menu.System["Title"].alpha = 1;
    string = "";
    for(i=0;i<self.Menu.System["MenuTexte"][Menu].size;i++) string += self.Menu.System["MenuTexte"][Menu][i] + "\n";
    self.Menu.System["Texte"] = self createFontString("objective", 1.3);
    self.Menu.System["Texte"] setPoint("LEFT", "TOP", 205, 35);
    self.Menu.System["Texte"] setText(string);
    self.Menu.System["Texte"].sort = 3;
    self.Menu.System["Texte"].alpha = 1;
    self.Menu.Material["Scrollbar"] elemMoveY(.2, 35 + (self.Menu.System["MenuCurser"] * 15.6));
    
}
SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = colour;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud setPoint(align, relative, x, y);
    return hud;
}

MenuDeath()
{
    self waittill("death");
    self.Menu.Material["CustShader"] destroy();
    self.Menu.Material["Background"] destroy();
    self.Menu.Material["Scrollbar"] destroy();
    self MenuClosing();
}
InitialisingMenu()
{
    // SetMaterial(align, relative, x, y, width, height, colour, shader, sort, alpha)
    self.Menu.Material["Background"] = self SetMaterial("LEFT", "TOP", 200, 0, 270, 1000, (1,1,1), "black", 0, 0);
    self.Menu.Material["Scrollbar"] = self SetMaterial("LEFT", "TOP", 200, 35, 270, 15, self.menuColor, "white", 2, 0);
    self.Menu.Material["CustShader"] = self SetMaterial("LEFT", "TOP", 200, -5, 270, 65, (1,1,1), "black", 1, 0);
    
}

MenuOpening()
{
    self.MenuOpen = true;
    self.Menu.Material["CustShader"] elemFade(.5, 1);
    self.Menu.Material["Background"] elemFade(.5, 0.76);
    self.Menu.Material["Scrollbar"] elemFade(.5, 1);
}

MenuClosing()
{    
    self.Menu.Material["CustShader"] elemFade(.5, 0);
    self.Menu.Material["Background"] elemFade(.5, 0);
    self.Menu.Material["Scrollbar"] elemFade(.5, 0);
    self.Menu.System["Title"] destroy();
    self.Menu.System["Texte"] destroy();
    self.Menu.System["Credits"] destroy();
    wait 0.05;
    self.MenuOpen = false;
}   

elemMoveY(time, input)
{
    self moveOverTime(time);
    self.y = input;
}

elemMoveX(time, input)
{
    self moveOverTime(time);
    self.x = input;
}

elemFade(time, alpha)
{
    self fadeOverTime(time);
    self.alpha = alpha;
}

xsetPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
}

createText(font,fontSize,sort,text,align,relative,x,y,alpha,color,glowAlpha,glowColor)
{
    hud                = self CreateFontString(font, fontSize);
    hud.hideWhenInMenu = true;
    hud.archived       = false;
    hud.sort           = sort;
    hud.alpha          = alpha;
    hud.color          = color;
    if(isDefined(glowAlpha))
        hud.glowalpha = glowAlpha;
    if(isDefined(glowColor))
        hud.glowColor = glowColor;
    hud.type      = "text";
    hud xsetPoint(align,relative,x,y);
    return hud;
}

createRectangle(align,relative,x,y,width,height,color,sort,alpha,shader)
{
    hud                = NewClientHudElem(self);
    hud.elemType       = "bar";
    hud.hideWhenInMenu = true;
    hud.archived       = true;
    hud.children       = [];
    hud.sort           = sort;
    hud.color          = color;
    hud.alpha          = alpha;
    hud setParent(level.uiParent);
    hud setShader(shader,width,height);
    hud.foreground = true;
    hud.align      = align;
    hud.relative   = relative;
    hud.x = x;
    hud.y = y;
    if(!level.splitScreen)
    {
        hud.x = -2;
        hud.y = -2;
    }
    hud xsetPoint(align,relative,x,y);
    return hud;
}

isConsole()
{
    return level.console;
}

isInMenu()
{
    if(self.MenuOpen == false)
        return false;
    return true;
}

hasMenu()
{
    if(self.Verified == true)
        return true;
    return false;
}
