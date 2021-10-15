MenuTheme(color)
{
    self.menu["Main_Color"] = color;
    hud = ["barTop","barBottom","scroller","Dev"];
    for(a=0;a<hud.size;a++)
        if(isDefined(self.menu["ui"][hud[a]]))
            self.menu["ui"][hud[a]] hudFadeColor(self.menu["Main_Color"],.5);
    hud = ["MenuName","title"];
    for(a=0;a<hud.size;a++)
        if(isDefined(self.menu["ui"][hud[a]]))
            self.menu["ui"][hud[a]] hudFadeGlowColor(self.menu["Main_Color"],.5);
    
    if(isDefined(self.CenteredMenu))
    {
        self.menu["ui"]["text"][self getCursor()] hudFadeColor(self.menu["Main_Color"],.5);
        self.menu["Curs_Color"] = self.menu["Main_Color"];
    }
}

ResetDesign(bypass)
{
    if(!isDefined(self.CenteredMenu) && !isDefined(bypass))return;
    
    colorvars = ["Background_Color","Title_Color","Option_Color"];
    colorvals = [divideColor(0,0,0),divideColor(255,255,255),divideColor(255,255,255)];
    for(a=0;a<colorvars.size;a++)self.menu[colorvars[a]] = colorvals[a];
    self.menu["Curs_Color"] = self.menu["Option_Color"];
    
    hudvars = ["Background_Width","Background_Height","Banner_Width","Banner_Height","BannerBottom_Width","BannerBottom_Height","Scroller_Width","Scroller_Height"];
    hudvals = [500,1000,2,1000,500,2,500,14];
    for(a=0;a<hudvars.size;a++)self.menu[hudvars[a]] = hudvals[a];
    
    posvars = ["X","Y","TitleY","MenuNameY","OptionsY","BannerX","BannerY","BannerBottomY","BannerBottomX","TitleX","OptionX","MenuNameX"];
    posvals = [450,-100,-165,-210,-130,200,0,-180,450,210,210,210];
    for(a=0;a<posvars.size;a++)self.menu[posvars[a]] = posvals[a];
    
    utilvars = ["MaxOptions","OptionsCenter","OptionsSeparation"];
    utilvals = [18,9,15];
    for(a=0;a<utilvars.size;a++)self.menu[utilvars[a]] = utilvals[a];
    
    shadervars = ["Background_Shader","Banner_Shader","Scroller_Shader"];
    shadervals = ["white","white","white"];
    for(a=0;a<shadervars.size;a++)self.menu[shadervars[a]] = shadervals[a];
    
    alphavars = ["Background_Alpha","Banner_Alpha","Scroller_Alpha","Title_Alpha","Option_Alpha"];
    alphavals = [.9,1,1,1,1];
    for(a=0;a<alphavars.size;a++)self.menu[alphavars[a]] = alphavals[a];
    
    fontvars = ["Title_Font","Option_Font","Dev_Font"];
    fontvals = ["default","default","objective"];
    for(a=0;a<fontvars.size;a++)self.menu[fontvars[a]] = fontvals[a];
    
    alignmentvars = ["Title_Align","MenuName_Align","Dev_Align","Option_Align"];
    alignmentvals = ["LEFT","LEFT","LEFT","LEFT"];
    for(a=0;a<alignmentvars.size;a++)self.menu[alignmentvars[a]] = alignmentvals[a];
    
    scalevars = ["Title_Fontscale","Option_Fontscale","MenuName_Fontscale","Dev_Fontscale"];
    scalevals = [1.8,1.3,1.8,.8];
    for(a=0;a<scalevars.size;a++)self.menu[scalevars[a]] = scalevals[a];
    
    if(self hasMenu() && self isInMenu())
    {
        self.menu["ui"]["background"] thread hudMoveXY(self.menu["X"],self.menu["Y"],.3);
        self.menu["ui"]["scroller"] thread hudMoveXY(self.menu["X"],self.menu["Y"]-40,.3);
        self.menu["ui"]["barTop"] thread hudMoveXY(self.menu["BannerX"],self.menu["BannerY"],.3);
        self.menu["ui"]["barBottom"] thread hudMoveXY(self.menu["BannerBottomX"],self.menu["BannerBottomY"],.3);
        
        self.menu["ui"]["title"] setPoint(self.menu["Title_Align"],"CENTER",self.menu["TitleX"],self.menu["TitleY"]);
        self.menu["ui"]["MenuName"] setPoint(self.menu["MenuName_Align"],"CENTER",self.menu["MenuNameX"],self.menu["MenuNameY"]);
        self.menu["ui"]["Dev"] setPoint(self.menu["Dev_Align"],"CENTER",self.menu["TitleX"],self.menu["MenuNameY"]+15);
        
        for(a=0;a<self.menu["ui"]["text"].size;a++)
            if(isDefined(self.menu["ui"]["text"][a]))
                self.menu["ui"]["text"][a] setPoint(self.menu["Option_Align"],"CENTER",self.menu["OptionX"],self.menu["OptionsY"]+(a*self.menu["OptionsSeparation"]));
        self.menu["ui"]["scroller"] thread hudMoveY(self.menu["ui"]["text"][self getCursor()].y+1,.2);
        
        self.menu["ui"]["background"] thread hudScaleOverTime(.3,self.menu["Background_Width"],self.menu["Background_Height"]);
        self.menu["ui"]["scroller"] thread hudScaleOverTime(.3,self.menu["Scroller_Width"],self.menu["Scroller_Height"]);
        self.menu["ui"]["barTop"] thread hudScaleOverTime(.3,self.menu["Banner_Width"],self.menu["Banner_Height"]);
        self.menu["ui"]["barBottom"] hudScaleOverTime(.3,self.menu["BannerBottom_Width"],self.menu["BannerBottom_Height"]);
        self RefreshMenu();
    }
    
    self.CenteredMenu = undefined;
}

CenterTheme(bypass)
{
    if(isDefined(self.CenteredMenu) && !isDefined(bypass))return;
    
    colorvars = ["Background_Color","Title_Color","Option_Color"];
    colorvals = [divideColor(0,0,0),divideColor(255,255,255),divideColor(255,255,255)];
    for(a=0;a<colorvars.size;a++)self.menu[colorvars[a]] = colorvals[a];
    self.menu["Curs_Color"] = self.menu["Main_Color"];
    
    hudvars = ["Background_Width","Background_Height","Banner_Width","Banner_Height","BannerBottom_Width","BannerBottom_Height","Scroller_Width","Scroller_Height"];
    hudvals = [250,1000,2,1000,2,1000,0,0];
    for(a=0;a<hudvars.size;a++)self.menu[hudvars[a]] = hudvals[a];
    
    posvars = ["X","Y","TitleY","MenuNameY","OptionsY","BannerX","BannerY","BannerBottomY","BannerBottomX","TitleX","OptionX","MenuNameX"];
    posvals = [0,0,-165,-210,-130,-125,0,0,125,0,0,0];
    for(a=0;a<posvars.size;a++)self.menu[posvars[a]] = posvals[a];
    
    utilvars = ["MaxOptions","OptionsCenter","OptionsSeparation"];
    utilvals = [18,9,15];
    for(a=0;a<utilvars.size;a++)self.menu[utilvars[a]] = utilvals[a];
    
    shadervars = ["Background_Shader","Banner_Shader","Scroller_Shader"];
    shadervals = ["white","white","white"];
    for(a=0;a<shadervars.size;a++)self.menu[shadervars[a]] = shadervals[a];
    
    alphavars = ["Background_Alpha","Banner_Alpha","Scroller_Alpha","Title_Alpha","Option_Alpha"];
    alphavals = [.9,1,1,1,1];
    for(a=0;a<alphavars.size;a++)self.menu[alphavars[a]] = alphavals[a];
    
    fontvars = ["Title_Font","Option_Font","Dev_Font"];
    fontvals = ["default","default","objective"];
    for(a=0;a<fontvars.size;a++)self.menu[fontvars[a]] = fontvals[a];
    
    alignmentvars = ["Title_Align","MenuName_Align","Dev_Align","Option_Align"];
    alignmentvals = ["CENTER","CENTER","CENTER","CENTER"];
    for(a=0;a<alignmentvars.size;a++)self.menu[alignmentvars[a]] = alignmentvals[a];
    
    scalevars = ["Title_Fontscale","Option_Fontscale","MenuName_Fontscale","Dev_Fontscale"];
    scalevals = [1.9,1.3,1.9,.8];
    for(a=0;a<scalevars.size;a++)self.menu[scalevars[a]] = scalevals[a];
    
    if(self hasMenu() && self isInMenu())
    {
        self.menu["ui"]["background"] thread hudMoveXY(self.menu["X"],self.menu["Y"],.3);
        self.menu["ui"]["scroller"] thread hudMoveXY(self.menu["X"],self.menu["Y"]-40,.3);
        self.menu["ui"]["barTop"] thread hudMoveXY(self.menu["BannerX"],self.menu["BannerY"],.3);
        self.menu["ui"]["barBottom"] thread hudMoveXY(self.menu["BannerBottomX"],self.menu["BannerBottomY"],.3);
        
        self.menu["ui"]["title"] setPoint(self.menu["Title_Align"],"CENTER",self.menu["TitleX"],self.menu["TitleY"]);
        self.menu["ui"]["MenuName"] setPoint(self.menu["MenuName_Align"],"CENTER",self.menu["MenuNameX"],self.menu["MenuNameY"]);
        self.menu["ui"]["Dev"] setPoint(self.menu["Dev_Align"],"CENTER",self.menu["TitleX"],self.menu["MenuNameY"]+15);
        
        for(a=0;a<self.menu["ui"]["text"].size;a++)
            if(isDefined(self.menu["ui"]["text"][a]))
                self.menu["ui"]["text"][a] setPoint(self.menu["Option_Align"],"CENTER",self.menu["OptionX"],self.menu["OptionsY"]+(a*self.menu["OptionsSeparation"]));
        self.menu["ui"]["scroller"] thread hudMoveY(self.menu["ui"]["text"][self getCursor()].y+1,.2);
        
        self.menu["ui"]["background"] thread hudScaleOverTime(.3,self.menu["Background_Width"],self.menu["Background_Height"]);
        self.menu["ui"]["scroller"] thread hudScaleOverTime(.3,self.menu["Scroller_Width"],self.menu["Scroller_Height"]);
        self.menu["ui"]["barTop"] thread hudScaleOverTime(.3,self.menu["Banner_Width"],self.menu["Banner_Height"]);
        self.menu["ui"]["barBottom"] hudScaleOverTime(.3,self.menu["BannerBottom_Width"],self.menu["BannerBottom_Height"]);
        self RefreshMenu();
    }
    
    self.CenteredMenu = true;
}