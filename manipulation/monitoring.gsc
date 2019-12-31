
monitorTeleports()
{
    self endon("disconnect");
    for(;;)
    {
        for(i=0;i<level.spawnTP.size;i++)
        {
            if(Distance( self.origin, level.spawnTP[i].origin ) < 80)
            {
                self setLowerMessage("tpFlag" + i, "Press ^3[{+activate}] ^7to teleport to " + level.spawnTP[i].message);
                
                if(self UseButtonPressed())
                {
                    self SetOrigin( level.spawnTP[i].destination );
                    wait .1;
                }
            }
            else if(Distance( self.origin, level.spawnTP[i].origin ) > 80)
            {
                self clearLowerMessage("tpFlag" + i);
            }
            if(i > level.spawnTP.size)
            {
                i = 0;
            }
        }
        wait .2;
    }
}

monitorRWeapons()
{
    self endon("disconnect");
    for(;;)
    {
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
        wait .2;
    }
}

monitorBox()
{
    self endon("disconnect");
    for(;;)
    {
        for(i=0;i<level.packRB.size;i++)
        {
            if(distance(self.origin, level.packRB[i].origin) <100)
            {
                
                self setLowerMessage("getGun" + i, "Press ^3[{+activate}] ^7to Select a random Weapon",undefined, 50);
                if(self usebuttonpressed())
                {
                    self.gotWeapon = true;
                    self notify("gun_pickup");
                wait 1;
                    self takeWeapon(self getCurrentWeapon());
                    self freezeControls(false);
                    self giveWeapon( level.wepmodel[i], RandomInt(9));
                    self SwitchToWeapon(level.wepmodel[i]);
                }
            }
            else if(distance(self.origin, level.packRB[i].origin) > 100)
            {
                self clearLowerMessage("getGun" + i);
            }
            if(i > level.packRB.size)
            {
                i = 0;
            }
        }
        wait .2;
    }
}
monitorDeadBoi()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("death");
        self thread monitorWeapons();
        self.playerSpawned = false;
        wait .2;
    }
}
 monitorWeaps()
{
    self thread monitorDeadBoi();
    self endon("disconnect");
    for(;;)
    {

        //Monitor Weapons
        for(i=0;i<level.spawnWep.size;i++)
        {   
            
            if(Distance( self.origin, level.spawnWep[i].origin ) <= 100)
            {
                self setLowerMessage("msg"+ i, "" + level.spawnWep[i].message, undefined, 50);
               if(self UseButtonPressed() && level.spawnedCP[i] == true)
               {
                   self.gotWeapon = true;
                   self notify("gun_pickup");
                   self giveWeapon(level.spawnWep[i].weap);
                   wait .05;
                   self SwitchToWeapon( level.spawnWep[i].weap);
                   if(retClass() == "weapon_pistol")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[i], RandomInt(30) );
                   }                   self SwitchToWeapon( level.spawnWep[i].weap);
                   if(retClass() == "weapon_sniper")
                   {
                       self SetWeaponAmmoStock( level.spawnWep[i], RandomInt(60) );
                   }
                   self clearLowerMessage("msg" + i);
                   level.spawnWep[i] delete();
                   level.spawnCP[i] delete();
                   level.spawnedCP[i] = false;
               }
            }
           if(Distance( self.origin, level.spawnWep[i].origin ) > 100)
            {
                self clearLowerMessage("msg" + i);
            }
            
        }
        wait .1;
    }
}


monitorPerks()
{
    self endon("disconnect");
    for(;;)
    {
       for(i=0;i<level.spawnCP.size;i++)
       {   
           if(Distance( self.origin, level.spawnCP[i].origin ) <= 70)
           {
               self setLowerMessage("messageBox" + i , "Press ^3[{+activate}] ^7 to pickup ^3" + level.spawnCP[i].message, undefined, 50 );
               
              if(self useButtonPressed())
              {
                  self IPrintLn("Perk Given | " + level.spawnCP[i].message);
                  self _setPerk("_" + level.spawnCP[i].perk);
                  
                  
              }
           }
            
           if(Distance( self.origin, level.spawnCP[i].origin ) > 70)
           {
               self clearLowerMessage("messageBox" + i );
           }
           
           if(i > level.spawnCP.size)
           {
               i = 0;
           }
           
       }
       wait .1;
    }
}
