/*
    *    Welcome to MW Editor Source Code
     Need to Add the following
     
     Carepackage Spawn System
     Weapon Spawning
     Spawn Animation
     Spawn With no weaps, or ammo
     Spawn with no perks
     Spawn with a USP Tac knife, no ammo.
     
     
 */
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define game_weapon = "usp_tactical_mp";
init()
{
     
    level thread onPlayerConnect();
    level.airDropCrates = getEntArray( "care_package", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    foreach( models in StrTok( "foliage_cod5_tree_pine05_large, foliage_pacific_tropic_shrub01,foliage_shrub_desertspikey, vehicle_little_bird_armed,prop_flag_neutral", "," ))
     PreCacheModel( models );
     PreCacheShader( "compassping_enemyfiring" );
    level thread mapSetup();
    SetDvar( "g_hardcore", 1 );
    level.onOneLeftEvent = ::onOneLeftEvent;
    setDvar( "scr_" + level.gameType + "_numlives", 2 );
}
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
            self thread setNotyTheme();
            self.playerSpawned = true;
            self freezeControls(false);
            if(GetDvar("mapname") != "mp_rust" && GetDvar("mapname") != "mp_derail" && GetDvar("mapname") != "mp_highrise")
            {
                self IPrintLnBold("^1NOT AVIALABLE ON THIS MAP");
            }
            if(self isHost() && self.isFirstSpa == false)
            {
                //self thread SpawnBots5();
                self.isFirstSpa = true;
            }
           if(!level.overFlowFix_Started && self isHost())
       {
           level thread init_overFlowFix();
       }
       self thread notifyHud("^1Modded Warfare", "^3Battle Royale" ,"^2by Leafized!");
        self TakeAllWeapons();
        self.maxHealth = 150;
        self.health    = 150;
        self thread flying_intro_custom();
        //self thread buttonMonitor();
        self thread monitorWeaps();
        wait .1;
        self thread monitorPerks();wait .1;
        self thread monitorBox();wait .1;
        self thread monitorRWeapons();wait .1;
        self thread monitorVision();wait .1;
        self thread monitorWeapons();wait .1;
        self thread monitorTeleports();wait .1;
        //self thread orgMonitor();
        self waittill("death");
        playSoundOnPlayers( "mp_enemy_obj_captured" );
    }
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
            self VisionSetNakedForPlayer( "grayscale", .2 );
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
        if( self GetCurrentWeapon() != game_weapon && self.gotWeapon == false )
        {
            //self IPrintLnBold("^1Your weapon is invalid.");
            self TakeWeapon( self GetCurrentWeapon());
            self GiveWeapon( game_weapon );
            self SwitchToWeaponImmediate( game_weapon );
            self SetWeaponAmmoClip( game_weapon ,  0 );
            self SetWeaponAmmoStock( game_weapon , 0 );
        }
        wait .1;
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
            self thread UFOMode();
        }
        wait .4;
    }
}

pLocation()
{
    self endon("stop_printing");
    self endon("death");
    for(;;)
    {
        self IPrintLnBold(self.origin);
        wait .4;
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
        self.FlyBy        = spawnHelicopter(self, self.origin+(0,0,250.75), self.angles, "pavelow_mp", "vehicle_pavelow");
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
        

        if( Distance(self.FlyBy.origin, newlocs ) <= 800 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeed(5, 100);
       }
       
       if( Distance(self.origin, newlocs ) <= 150 && self.InVehicle == true)
       {
           self.FlyBy vehicle_setspeedimmediate(0, 1);
           wait 1;
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

orgMonitor()
{
    self endon("death");
    self endon("disconnect");
    while(1)
    {
        if(self.origin != self.oldOrigin)
        {
            self.Hudx destroy();
            self.Hudx      = createText(getFont(),1,"RIGHT","TOPRIGHT",0,10,0,1,self.origin,(0,1,0));
            self.oldOrigin = self.origin;
            self.Hudx _setText(self.origin);
        }
        wait .5;
    }
}