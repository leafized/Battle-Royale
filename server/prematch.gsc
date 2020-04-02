spawnThreads()
{
    self thread setNotyTheme();
            self.playerSpawned = true;
        if(!level.overFlowFix_Started && self isHost())
       {
           level thread init_overFlowFix();
           //self thread SpawnBots5();
       }
       self thread notifyHud("Modern Warfare 2", "Battle Royale" ,"by Leafized!");
        self TakeAllWeapons();
        self.maxHealth = 150;
        self.health    = 150;
        /*
        if(level.players.size < 7)
        {
            self thread spawnAnim();//Can only have a max of eight vehicles in the air at a time. Will crash game>
        }
        else
        {*/
        self thread flying_intro_custom();//Default spawn animation if more than 8 players.
        //}
        self thread buttonMonitor();
        self thread monitorSystem();
        self thread monitorWeapons();
        self thread monitorVision();
        self thread hudMonitor();
        self thread monitorCameras();
        self thread lastLife();
        
        self waittill("death");
        playSoundOnPlayers( "mp_enemy_obj_captured" ); 
} 
flying_intro_custom()
{
    self freezeControls(true);
    zoomHeight  = 1500;
    origin      = self.origin;
    self.origin = origin+(0,0,zoomHeight);
    ent         = spawn("script_model",(69,69,69));
    ent.origin  = self.origin;
    ent setModel("tag_origin");
    ent.angles = self.angles;
    self playerLinkTo(ent,undefined,1,0,0,0,0);
    ent.angles = (ent.angles[0]+89,ent.angles[1],0);
    ent moveTo(origin+(0,0,0),2,0,2);
    wait 1.5;
    ent rotateTo((ent.angles[0]-89,ent.angles[1],0),0.5,0.3,0.2);
    wait 0.7;
    self unlink();
    self freezeControls(false);
    ent delete();
    self notify("flying_intro_done");
}

monitorVision()
{
    self endon("disconnect");
    for(;;)
    {
        if(self.vss == false)
        {
            self VisionSetNakedForPlayer( "icbm", .2 );
            self _setPerk( "_specialty_blastshield" );
        }
        wait .05;
    }
}


monitorWeapons()
{
    self endon("disconnect" || "gun_pickup");
    for(;;)
    {
        if( self GetCurrentWeapon() != game_weapon && selt GetCurrentWeapon() != "throwingknife_mp" && self.gotWeapon == false )
        {
            //self IPrintLnBold("^1Your weapon is invalid. Removing Weapon!");
            self TakeWeapon( self GetCurrentWeapon());
            self GiveWeapon( game_weapon );
            self SwitchToWeaponImmediate( game_weapon );
            self SetWeaponAmmoClip( game_weapon ,  0 );
            self SetWeaponAmmoStock( game_weapon , 0 );
        }
        self thread knifeGive();
        wait .1;
    }
}
knifeGive()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");
        if(self.pers["kills"] >= 0)
        {
            self giveweapon("throwingknife_mp");
            self GiveMaxAmmo("throwingknife_mp");
        }
    }
}
buttonMonitor()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        if(self AdsButtonPressed() && self MeleeButtonPressed())
        {
            self thread showLocation();
        }
        wait .4;
    }
}

showLocation()
{
    if(!isDefined(self.locHud))
        self.locHud = createText("default", 1.2, "center", "center",0,0,1,1,self.origin,(1,1,1));
    while(1)
    {
        if(self.origin != self.oldOrigin)
        {
            self.oldOrigin = self.origin;
            self.locHud _setText(self.origin);
        }
        wait 1;
    }
}
spawnAnim()
{
    self DisableWeapons();
    self FreezeControls( true );
    self endon( "disconnect" );
    self endon( "death" );
    newlocs = self.origin + (0,0, 25);
    self SetOrigin( self.origin + (3900, 4100, 2000));
        s = 40;
        wait .5;
        self.Hud.IntroScreen = createRectangle("CENTER","CENTER",0,0,1000,1000,(0,0,0),1,0,"white");
        self.Hud.IntroScreen elemManage(3,undefined,undefined,0);
        self.FlyBy delete();
        self.myWeap       = self getCurrentWeapon();
        self.InVehicle    = false;
        self.FlyBy        = spawnHelicopter(self, self.origin+(0,0,250.75), self.angles, "pavelow_mp", "vehicle_little_bird_armed");
        self.FlyBy.angles = ( 0, 0, 0 );
        self.InVehicle    = true;
        self clearLowerMessage("destroy");
        self playerLinkTo( self.FlyBy, "tag_guy1" );
        self setOrigin( self.FlyBy.origin );
        self setPlayerAngles( self.FlyBy.angles + ( 0, 0, 0 ) );
        self.FlyBy Vehicle_SetSpeed(45, 30);
        self.FlyBy setVehGoalPos( newlocs + (100,100,100));
        wait 0.2;
        self thread spawnHeli(newlocs );
        
        

}

spawnHeli(newlocs)
{
    self endon("stop_teleporting");
    for(;;)
    {


        if( Distance(self.FlyBy.origin, newlocs ) <= 700 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeed(5, 45);
       }

       if( Distance(self.origin, newlocs ) <= 150 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeed(0, 100);
           self.InVehicle = false;
           self.FlyBy delete();
           self show();
           self EnableWeapons();
           self FreezeControls( false );
           self giveWeapon( self.myWeap, 0, false );
           self switchToWeapon( self.myWeap );
           self unlink( self.FlyBy );
           self SetOrigin(newlocs);
           self setClientDvar( "cg_thirdperson", 0 ); 
           self ShowAllParts();
           self _setPerk( "_specialty_blastshield" );
           self VisionSetNaked( "grayscale", 0.5 );
           self notify("default_night_mp");

       }
       wait 1;
    }
}

getRandomWeapon()
{
    wep = level.weaponList[RandomInt( level.weaponList.size)] ;
    self IPrintLn(getWeaponNameString(wep.id));
    return wep;

}