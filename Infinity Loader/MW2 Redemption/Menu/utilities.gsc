createText(font,fontSize,sort,text,align,relative,x,y,alpha,color,glowAlpha,glowColor)
{
    uiElement                = self CreateFontString(font, fontSize);
    uiElement.hideWhenInMenu = true;
    uiElement.archived       = false;
    uiElement.sort           = sort;
    uiElement.alpha          = alpha;
    uiElement.color          = color;
    if(isDefined(glowAlpha))
        uiElement.glowalpha = glowAlpha;
    if(isDefined(glowColor))
        uiElement.glowColor = glowColor;
    uiElement.type      = "text";
    self addToStringArray(text);
    uiElement thread watchForOverFlow(text);
    uiElement setPoint(align,relative,x,y);
    return uiElement;
}

createServerText(font,fontScale,align,relative,x,y,sort,alpha,text,color)
{
    textElem                = CreateServerFontString(font,fontScale);
    textElem.hideWhenInMenu = true;
    textElem.archived       = true;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    textElem setPoint(align,relative,x,y);
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    
    return textElem;
}

createRectangle(align,relative,x,y,width,height,color,sort,alpha,shader)
{
    uiElement                = NewClientHudElem(self);
    uiElement.elemType       = "bar";
    uiElement.hideWhenInMenu = true;
    uiElement.archived       = true;
    uiElement.children       = [];
    uiElement.sort           = sort;
    uiElement.color          = color;
    uiElement.alpha          = alpha;
    uiElement setParent(level.uiParent);
    uiElement setShader(shader,width,height);
    uiElement.foreground = true;
    uiElement.align      = align;
    uiElement.relative   = relative;
    uiElement.x = x;
    uiElement.y = y;
    if(!level.splitScreen)
    {
        uiElement.x = -2;
        uiElement.y = -2;
    }
    uiElement setPoint(align,relative,x,y);
    return uiElement;
}

setPoint(point,relativePoint,xOffset,yOffset,moveTime)
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

ChangeFontScaleOverTime1(scale,time)
{
    self ChangeFontScaleOverTime(time);
    self.FontScale = scale;
}

hudMoveY(y,time)
{
    self MoveOverTime(time);
    self.y = y;
    wait time;
}

hudMoveX(x,time)
{
    self MoveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveXY(x,y,time)
{
    self MoveOverTime(time);
    self.x = x;
    self.y = y;
    wait time;
}

hudFade(alpha,time)
{
    self FadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudFadenDestroy(alpha,time,time2)
{
    if(isDefined(time2))
        wait time2;
    self hudFade(alpha,time);
    self destroy();
}

hudFadeColor(color,time)
{
    self FadeOverTime(time);
    self.color = color;
}

hudFadeGlowColor(color,time)
{
    self FadeOverTime(time);
    self.GlowColor = color;
}

divideColor(c1,c2,c3)
{
    return(c1/255,c2/255,c3/255);
}

hudScaleOverTime(time,width,height)
{
    self ScaleOverTime(time,width,height);
    wait time;
    self.width = width;
    self.height = height;
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = GetArrayKeys(array);
    for(a=0;a<keys.size;a++)
        destroyAll(array[keys[a]]);
    array destroy();
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a=name.size-1;a>=0;a--)
        if(name[a] == "]")
            break;
    return(GetSubStr(name,a+1));
}

destroyAfter(time)
{
    wait time;
    if(isDefined(self))
        self destroy();
}

isInMenu()
{
    if(!isDefined(self.playerSetting["isInMenu"]))
        return false;
    return true;
}

hasMenu()
{
    if(self getVerification() > 0)
        return true;
    return false;
}

isInArray(array,text)
{
    for(a=0;a<array.size;a++)
        if(array[a] == text)
            return true;
    return false;
}

getMenuName()
{
    return level.menuName;
}

getCurrent()
{
    return self.menu["currentMenu"];
}

getCursor()
{
    return self.menu["curs"][self getCurrent()];
}

setCursor(curs)
{
    self.menu["curs"][self getCurrent()] = curs;
}

isConsole()
{
    return level.console;
}

GetPlayerArray()
{
    players = GetEntArray("player","classname");
    return players;
}

SpawnScriptModel(origin,model,angles,time,clip)
{
    if(isDefined(time))
        wait time;
    ent = spawn("script_model",origin);
    ent SetModel(model);
    if(isDefined(angles))
        ent.angles = angles;
    if(isDefined(clip))
        ent CloneBrushModelToScriptModel(clip);
    return ent;
}

TraceBullet()
{
    return BulletTrace(self GetEye(),self GetEye()+vectorScale(AnglesToForward(self GetPlayerAngles()),1000000),0,self)["position"];
}

vectorScale(vector,scale)
{
    vector = (vector[0] * scale,vector[1] * scale,vector[2] * scale);
    return vector;
}

getClosest(origin,array,ex)
{
    if(isDefined(ex) && array.size > 1 && array[0] == ex)
        closest = array[1];
    else
        closest = array[0];
    min     = distance(closest.origin,origin);
    
    for(a=1;a<array.size;a++)
    {
        if(isDefined(ex) && array[a] == ex)
            continue;
        
        if(distance(array[a].origin,origin) < min)
        {
            min     = distance(array[a].origin,origin);
            closest = array[a];
        }
    }
    return closest;
}

isDeveloper()
{
    if(self getName() == "CF4_99" || self getName() == "CF4 Zodiac")
        return true;
    return false;
}

isFiring1()
{
    if(isConsole())
        address = 0x0830CC17B + (self GetEntityNumber() * 0x3700);
    else
        address = 0x01B0E3B8 + (self GetEntityNumber() * 0x366C);
    byte    = ReadByte(address);
    
    if(byte == 0x06)
        return true;
    return false;
}

SetVision(vision)
{
    self VisionSetNakedForPlayer(vision,.5);
}

Keyboard(title,func,input1)
{
    self closeMenu1();
    
    letters    = [];
    lettersTok = StrTok("0ANan: 1BObo; 2CPcp> 3DQdq$ 4ERer# 5FSfs- 6GTgt* 7HUhu+ 8IViv@ 9JWjw/ ^KXkx_ !LYly[ ?MZmz]"," ");
    for(a=0;a<lettersTok.size;a++)
    {
        letters[a] = "";
        for(b=0;b<lettersTok[a].size;b++)
            letters[a] += lettersTok[a][b]+"\n";
    }
    
    keyboard = [];
    keyboard["background"] = self createRectangle("CENTER","CENTER",0,0,320,200,(0,0,0),1,.8,"white");
    keyboard["title"] = self createText("objective",1.5,2,title,"CENTER","CENTER",0,-85,1,(1,1,1));
    keyboard["string"] = self createText("objective",1.3,2,"","CENTER","CENTER",0,-60,1,(1,1,1));
    for(a=0;a<letters.size;a++)
        keyboard["keys"+a] = self createText("smallfixed",1,3,letters[a],"CENTER","CENTER",-119+(a*20),-30,1,(1,1,1));
    keyboard["controls"] = self createText("objective",.9,2,"[{+melee}] Back/Exit - [{+activate}] Select - [{weapnext}] Space - [{+gostand}] Confirm","CENTER","CENTER",0,80,1,(1,1,1));
    keyboard["scroller"] = self createRectangle("CENTER","CENTER",keyboard["keys0"].x+.1,keyboard["keys0"].y,15,15,(0.6468253968253968, 0, 0.880952380952381),2,1,"white");
    
    cursY        = 0;
    cursX        = 0;
    stringLimit  = 32;
    string       = "";
    if(isConsole())
        multiplier = 18.5;
    else
        multiplier = 16.5;
    wait .5;
    
    while(1)
    {
        self FreezeControls(true);
        if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
        {
            cursY -= self isButtonPressed("+actionslot 1");
            cursY += self isButtonPressed("+actionslot 2");
            if(cursY < 0 || cursY > 5)
                cursY = (cursY < 0 ? 5 : 0);
            
            keyboard["scroller"] hudMoveY(keyboard["keys0"].y+(multiplier*cursY),.05);
            wait .1;
        }
        if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4"))
        {
            cursX -= self isButtonPressed("+actionslot 3");
            cursX += self isButtonPressed("+actionslot 4");
            if(cursX < 0 || cursX > 12)
                cursX = (cursX < 0 ? 12 : 0);
            
            keyboard["scroller"] hudMoveX(keyboard["keys0"].x+.1+(20*cursX),.05);
            wait .1;
        }
        if(self UseButtonPressed())
        {
            if(string.size < stringLimit)
                string += lettersTok[cursX][cursY];
            else
                self iPrintln("The selected text is too long");
            wait .2;
        }
        if(self isButtonPressed("weapnext"))
        {
            if(string.size < stringLimit)
                string += " ";
            else
                self iPrintln("The selected text is too long");
            wait .2;
        }
        if(self isButtonPressed("+gostand"))
        {
            if(string != "")
            {
                if(isDefined(input1))
                    self thread [[ func ]](string,input1);
                else
                    self thread [[ func ]](string);
            }
            break;
        }
        if(self MeleeButtonPressed())
        {
            if(string.size > 0)
            {
                backspace = "";
                for(a=0;a<string.size-1;a++)
                    backspace += string[a];
                string = backspace;
                wait .2;
            }
            else break;
        }
        keyboard["string"] SetSafeText(string);
        wait .05;
    }
    
    destroyAll(keyboard);
    self FreezeControls(false);
}

NumberPad(title,func,player)
{
    self closeMenu1();
    
    if(title == "Change Prestige")
        self iPrintln("^1WARNING: ^7Change prestige will kick you from the game");
    
    letters    = [];
    lettersTok = StrTok("0 1 2 3 4 5 6 7 8 9"," ");
    for(a=0;a<lettersTok.size;a++)
        letters[a] = lettersTok[a];
    
    NumberPad = [];
    NumberPad["background"] = self createRectangle("CENTER","CENTER",0,0,300,100,(0,0,0),1,.8,"white");
    NumberPad["title"] = self createText("objective",1.5,2,title,"CENTER","CENTER",0,-40,1,(1,1,1));
    NumberPad["controls"] = self createText("objective",.9,2,"[{+melee}] Back/Exit - [{+activate}] Select - [{+gostand}] Confirm","CENTER","CENTER",0,35,1,(1,1,1));
    NumberPad["string"] = self createText("objective",1.3,2,"","CENTER","CENTER",0,-15,1,(1,1,1));
    for(a=0;a<letters.size;a++)
        NumberPad["keys"+a] = self createText("smallfixed",1,3,letters[a],"CENTER","CENTER",-90+(a*20),10,1,(1,1,1));
    NumberPad["scroller"] = self createRectangle("CENTER","CENTER",NumberPad["keys0"].x,NumberPad["keys0"].y,15,15,divideColor(255,0,15),2,1,"white");
    
    cursX       = 0;
    stringLimit = 32;
    string      = "";
    wait .3;
    
    while(1)
    {
        self FreezeControls(true);
        if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4"))
        {
            cursX -= self isButtonPressed("+actionslot 3");
            cursX += self isButtonPressed("+actionslot 4");
            if(cursX < 0 || cursX > 9)
                cursX = (cursX < 0 ? 9 : 0);
            NumberPad["scroller"] hudMoveX(NumberPad["keys0"].x + (20 * cursX),.05);
            wait .1;
        }
        if(self UseButtonPressed())
        {
            if(string.size < stringLimit)
                string += lettersTok[cursX];
            else self iPrintln("The selected text is too long");
            wait .2;
        }
        if(self isButtonPressed("+gostand"))
        {
            if(isDefined(player))
                self thread [[ func ]](int(string),player);
            else
                self thread [[ func ]](int(string));
            break;
        }
        if(self MeleeButtonPressed())
        {
            if(string.size > 0)
            {
                backspace = "";
                for(a=0;a<string.size-1;a++)
                    backspace += string[a];
                string = backspace;
                wait .2;
            }
            else break;
        }
        NumberPad["string"] SetSafeText(string);
        wait .05;
    }
    
    destroyAll(NumberPad);
    self FreezeControls(false);
}

SV_GameSendServerCommand(string,player)
{
    if(isConsole())
        address = 0x822548D8;
    else
        address = 0x588480;
    
    RPC(address,player GetEntityNumber(),0,string);
}

Cbuf_AddText(string)
{
    if(isConsole())
        address = 0x82224990;
    else
        address = 0x563D10;
    
    RPC(address,0,string);
}

MonitorButtons()
{
    if(isDefined(self.MonitoringButtons))
        return;
    self.MonitoringButtons = true;
    
    if(!isDefined(self.buttonAction))
        self.buttonAction = ["+stance","+gostand","weapnext","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4"];
    if(!isDefined(self.buttonPressed))
        self.buttonPressed = [];
    
    for(a=0;a<self.buttonAction.size;a++)
        self thread ButtonMonitor(self.buttonAction[a]);
}

ButtonMonitor(button)
{
    self endon("disconnect");
    
    self.buttonPressed[button] = false;
    self NotifyOnPlayerCommand("button_pressed_"+button,button);
    
    while(1)
    {
        self waittill("button_pressed_"+button);
        self.buttonPressed[button] = true;
        wait .025;
        self.buttonPressed[button] = false;
    }
}

isButtonPressed(button)
{
    return self.buttonPressed[button];
}

SetPlayerModel(model)
{
    self SetModel(model);
}