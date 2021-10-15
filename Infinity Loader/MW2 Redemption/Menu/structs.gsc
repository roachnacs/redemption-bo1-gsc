MenuArrays(menu)
{
    if(!isDefined(self.menu["items"][menu]))
        self.menu["items"][menu] = SpawnStruct();
    if(!isDefined(self.temp["memory"]))
        self.temp["memory"] = [];
    if(!isDefined(self.temp["memory"]["menu"]))
        self.temp["memory"]["menu"] = [];
    if(!isDefined(self.menuParent))
        self.menuParent = [];
    self.menu["items"][menu].name = [];
    self.menu["items"][menu].name2 = [];
    self.menu["items"][menu].func = [];
    self.menu["items"][menu].input1 = [];
    self.menu["items"][menu].input2 = [];
    self.menu["items"][menu].input3 = [];
}

addMenu(menu,title)
{
    self MenuArrays(menu);
    self.menu["items"][menu].title = title;
    self.temp["memory"]["menu"]["currentmenu"] = menu;
    
    if(!isDefined(self.menu["items"][menu].name))
        self.menu["items"][menu].name = [];
    if(!isDefined(self.menu["items"][menu].name2))
        self.menu["items"][menu].name2 = [];
    if(!isDefined(self.menu["items"][menu].func))
        self.menu["items"][menu].func = [];
    if(!isDefined(self.menu["items"][menu].input1))
        self.menu["items"][menu].input1 = [];
    if(!isDefined(self.menu["items"][menu].input2))
        self.menu["items"][menu].input2 = [];
    if(!isDefined(self.menu["items"][menu].input3))
        self.menu["items"][menu].input3 = [];
}

addOpt(name, func, input1, input2, input3)
{
    menu = self.temp["memory"]["menu"]["currentmenu"];
    count = self.menu["items"][menu].name.size;
    
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    self.menu["items"][menu].input1[count] = input1;
    self.menu["items"][menu].input2[count] = input2;
    self.menu["items"][menu].input3[count] = input3;
}

newMenu(menu)
{
    if(!isDefined(menu))
    {
        menu = self.menuParent[self.menuParent.size-1];
        self.menuParent[self.menuParent.size-1] = undefined;
    }
    else
    {
        self.menuParent[self.menuParent.size] = self getCurrent();
        self MenuArrays(self.menuParent[self.menuParent.size-1]);
    }
    self.menu["currentMenu"] = menu;
    self runMenuIndex(menu);
    self SetMenuTitle();
    self drawText();
}
