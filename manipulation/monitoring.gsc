
monitorSystem()
{
    self endon("disconnect");
    for(;;)
    {
        if(self.origin != self.oldOrigin && debugging == true)
        {
            self.Hudx destroy();
            self.Hudx      = createText(getFont(),1,"CENTER","TOP",0,0,0,1,self.origin,(0,1,0));
            self.oldOrigin = self.origin;
            self.Hudx _setText(self.origin);
        }
        wait .5;
        for(a=0;a<level.spawnTP.size;a++)
        {
            if(Distance( self.origin, level.spawnTP[a].origin ) < 80)
            {
                self setLowerMessage("tpFlag" + a, "Press ^3[{+activate}] ^7to teleport to " + level.spawnTP[a].message);
                
                if(self UseButtonPressed())
                {
                    self SetOrigin( level.spawnTP[a].destination );
                    wait .1;
                }
            }
            else if(Distance( self.origin, level.spawnTP[a].origin ) > 80)
            {
                self clearLowerMessage("tpFlag" + a);
            }
            if(a > level.spawnTP.size)
            {
                a = 0;
            }
            
            
        }
        for(i=0;i<level.RandomWepCP.size;i++)
            {
                if(distance(self.origin, level.RandomWepCP[i].origin) < 100)
                {
                    
                    self setLowerMessage("ranGun" + i, "Press ^3[{+activate}] ^7to Select a random Weapon",undefined, 50);
                    if(self usebuttonpressed())
                    {
                        
                        self notify("gun_pickup");
                        self.gotWeapon = true;
                        wait .3;
                        self takeWeapon(self getCurrentWeapon());
                        self freezeControls(false);
                        self giveWeapon( level.randomModel[i], RandomInt(9));
                        self SwitchToWeapon(level.randomModel[i]);
                    }
                }
                else if(distance(self.origin, level.RandomWepCP[i].origin) > 100)
                {
                    self clearLowerMessage("ranGun" + i);
                }
                if(i > level.RandomWepCP.size)
                {
                    i = 0;
                }
            }
            
            for(b=0;b<level.packRB.size;b++)
        {
            if(distance(self.origin, level.packRB[b].origin) <100)
            {
                
                self setLowerMessage("getGun" + b, "Press ^3[{+activate}] ^7to Select a random Weapon",undefined, 50);
                if(self usebuttonpressed())
                {
                    self.gotWeapon = true;
                    self notify("gun_pickup");
                wait 1;
                    
                    self takeWeapon(self getCurrentWeapon());
                    self freezeControls(false);
                    self giveWeapon( level.wepmodel[b], RandomInt(9));
                    self SwitchToWeapon(level.wepmodel[b]);
                    level.packRB[b] destroy();
                    level.wepmodel[b] destroy();
                }
            }
            else if(distance(self.origin, level.packRB[b].origin) > 100)
            {
                self clearLowerMessage("getGun" + b);
            }
            if(b > level.packRB.size)
            {
                b = 0;
            }
        }
        
        
        for(c=0;c<level.spawnWep.size;c++)
        {   
            
            if(Distance( self.origin, level.spawnWep[c].origin ) <= 100)
            {
                self setLowerMessage("msg"+ c, "" + level.spawnWep[c].message, undefined, 50);
                if(self UseButtonPressed() && level.spawnedCP[c] == true)
               {
                   self.gotWeapon = true;
                   self notify("gun_pickup");
                   self giveWeapon(level.spawnWep[c].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[c].weap);
                   if(retClass() == "weapon_pistol")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[c], RandomInt(30) );
                   }                   self SwitchToWeapon( level.spawnWep[c].weap);
                   if(retClass() == "weapon_sniper")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[c], RandomInt(60) );
                   }
                   self clearLowerMessage("msg" + i);
                   level.spawnWep[c] delete();
                   level.spawnCP[c] delete();
                   level.spawnedCP[c] = false;
               }
            }
           if(Distance( self.origin, level.spawnWep[c].origin ) > 100)
            {
                self clearLowerMessage("msg" + c);
            }
            
        }
        
         for(d=0;d<level.spawnCP.size;d++)
       {   
           if(Distance( self.origin, level.spawnCP[d].origin ) <= 70)
           {
               self setLowerMessage("messageBox" + d , "Press ^3[{+activate}] ^7 to pickup ^3" + level.spawnCP[d].message, undefined, 50 );
               
              if(self useButtonPressed())
              {
                  self IPrintLn("Perk Given | " + level.spawnCP[d].message);
                  self _setPerk("_" + level.spawnCP[d].perk);
                  level.spawnCP[d] destroy();
                  
              }
           }
            
          if(Distance( self.origin, level.spawnCP[d].origin ) > 70)
           {
               self clearLowerMessage("messageBox" + d );
           }
           
           if(d > level.spawnCP.size)
           {
               d = 0;
           }
           
       }
       
        wait .2;
    }
}
