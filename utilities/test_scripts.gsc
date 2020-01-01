 healthMonitor()
 {
     self endon("disconnect");
     for(;;)
     {
         p = 0;
         self.HudHealth destroy();
         self.HudHText destroy();
         self.HudAmmoText destroy();
         self.HealthIcon destroy();
                  for (p = 0; p < level.players.size; p++)
         {
                self.teamicon[p] destroy();
         }
         self.HealthIcon  = createRectangle2("LEFT","TOPLEFT",5,-10,15,15,"hint_health",3,1);
         self.HudHealth   = createRectangle("LEFT","TOPLEFT",0,10,0 + (self.health),15,(.2,.4,1),"white",2,.7);
         self.HudHText    = createText(getFont(),1.3,"LEFT","TOPLEFT",20,-10,3,1,self.health,(1,1,1));
         self.HudAmmoText = createText(getFont(),1.3,"RIGHT","BOTTOMRIGHT",-10,5,3,1,"Ammo ^7" +self returnAmmo(),(1,1,1));
         
         for (p = 0; p < level.players.size; p++)
         {
            self.teamicon[p] = self createRectangle("LEFT","TOPLEFT",45 + (15 * p),-5,15,15,(.2,.4,1),"compassping_enemyfiring",4,1);
         }
         
         wait .05;
     }
 }
 returnAmmo()
 {
     return self getCurrentWeaponClipAmmo() + "^7 / " + self GetWeaponAmmoStock( self GetCurrentWeapon() );
 }

onOneLeftEvent( team )
{
    winner = getLastLivingPlayer();
   
    wait 1;
    level.showingFinalKillcam = true;
   
    foreach( player in level.players )
        player thread do_killcam_final( winner );
       
    while ( level.showingFinalKillcam )
        wait ( 0.05 );    
    level thread maps\mp\gametypes\_gamelogic::endGame( winner, &"MP_ENEMIES_ELIMINATED" );    
}
do_killcam_final( attacker )
{
    attackerNum  = attacker GetEntityNumber();
   
    maxtime   = 6;
    camtime   = 4;
    postdelay = 2;
   
    predelay      = .2;
    killcamlength = camtime + postdelay + 1;
    killcamoffset = camtime + predelay;
   
    self notify ( "begin_killcam", getTime() );
   
    visionSetNaked( "mpOutro", 6 );
    setDvar( "scr_gameended", 1 ); // 1 - end game | 2 - round
   
    // ignore spectate permissions
    self allowSpectateTeam("allies", true);
    self allowSpectateTeam("axis", true);
    self allowSpectateTeam("freelook", true);
    self allowSpectateTeam("none", true);
   
    self.sessionstate         = "spectator";
    self.forcespectatorclient = attackerNum;
   
    self.killcamentity = attacker;
    self.archivetime   = killcamoffset;
    self.killcamlength = killcamlength;
    self.psoffsettime  = 0;
    thread doFinalKillCamFX( self.archivetime - .05 - predelay );
   
    if ( isDefined( attacker ) && level.showingFinalKillcam ) // attacker may have disconnected
    {
        self openMenu( "killedby_card_display" );
        self SetCardDisplaySlot( attacker, 7 );
    }
    wait killcamoffset + .1;
   
    level.showingFinalKillcam = false;
}
 
doFinalKillCamFX( camTime )
{
    if ( isDefined( level.doingFinalKillcamFx ) )
        return;
    level.doingFinalKillcamFx = true;
   
    intoSlowMoTime = camTime;
    if ( intoSlowMoTime > 1.0 )
    {
        intoSlowMoTime = 1.0;
        wait( camTime - 1.0 );
    }
   
    setSlowMotion( 1.0, 0.25, intoSlowMoTime ); // start timescale, end timescale, lerp duration
    wait( intoSlowMoTime + .5 );
    setSlowMotion( 0.25, 1, 1.0 );
   
    level.doingFinalKillcamFx = undefined;
}
getFont()
{
    return "default";
}

retClass()
{
    return self getWeaponClass(weapon);
}
SpawnBots5()
{
    for(i = 0; i < 3; i++)
    {
        ent = addtestclient();
        wait 1;
        ent.pers["isBot"] = true;
        ent initBot();
        wait 0.1;
    }
}

initBot()
{
    
    self endon( "disconnect" );
    self notify("menuresponse", game["menu_team"], "autoassign");
    wait 0.5;
    self notify("menuresponse", "changeclass", "class" + randomInt( 5));

}

getWeaponNameString(base_weapon)
{
    tableRow         = tableLookup("mp/statstable.csv",4,base_weapon,0);
    weaponNameString = tableLookupIString("mp/statstable.csv",0,tableRow,3);
    return weaponNameString;
}
 

notifyHud(msg1,msg2,msg3,time)
{
notifyData             = spawnstruct();
notifyData.titleText   = msg1; //Line 1
notifyData.notifyText  = msg2; //Line 2
notifyData.notifyText2 = msg3; //Line 3
notifyData.glowColor   = m_Color; //RGB Color array divided by 100
notifyData.Duration    = time;
self thread notifyMessage( notifyData );
}

notifyMessage( notifyData )
{
    self endon ( "death" );
    self endon ( "disconnect" );
    
    if ( !isDefined( notifyData.slot ) )
        notifyData.slot = 0;
    
    slot = notifyData.slot;

    if ( !isDefined( notifyData.type ) )
        notifyData.type = "";
    
    if ( !isDefined( self.doingSplash[ slot ] ) )
    {
        self thread showNotifyMessage( notifyData );
        return;
    }/*
    else if ( notifyData.type == "rank" && self.doingSplash[ slot ].type != "challenge" && self.doingSplash[ slot ].type != "killstreak" )
    {
        self thread showNotifyMessage( notifyData );
        return;
    }*/
    
    self.splashQueue[ slot ][ self.splashQueue[ slot ].size ] = notifyData;
}

setNotyTheme()
{
    self.menuColors = (.2,0.4,1);
    if ( level.splitscreen )
    {
        titleSize     = 1.5;
        textSize      = 1;
        iconSize      = 24;
        font          = "default";
        point         = "TOP";
        relativePoint = "BOTTOM";
        yOffset       = 30;
        xOffset       = 0;
    }
    else
    {
        titleSize     = 1.4;
        textSize      = 1.2;
        iconSize      =  0;
        font          = "objective";
        point         = "RIGHT";
        relativePoint = "LEFT";
        yOffset       = 10;
        xOffset       = -10;
    }
    
    self.notifyTitle = createFontString( font, titleSize );
    self.notifyTitle setPoint( point, undefined, xOffset, yOffset );
    self.notifyTitle.glowColor      = self.menuColors;
    self.notifyTitle.glowAlpha      = .7;
    self.notifyTitle.hideWhenInMenu = true;
    self.notifyTitle.archived       = false;


    self.notifyText = createFontString( font, textSize );
    self.notifyText setParent( self.notifyTitle );
    self.notifyText setPoint( point, relativePoint, 0, yOffset );
    self.notifyText.glowColor      = self.menuColors;
    self.notifyText.glowAlpha      = .7;
    self.notifyText.hideWhenInMenu = true;
    self.notifyText.archived       = false;
    self.notifyText.alpha          = 0;

    self.notifyText2 = createFontString( font, textSize );
    self.notifyText2 setParent( self.notifyTitle );
    self.notifyText2 setPoint( point, relativePoint, 0, yOffset );
    self.notifyText2.glowColor      = self.menuColors;
    self.notifyText2.glowAlpha      = .7;
    self.notifyText2.hideWhenInMenu = true;
    self.notifyText2.archived       = false;
    self.notifyText2.alpha          = 0;
    
    self.notifyIcon.alpha = 0;

    self.doingSplash = [];
    self.doingSplash[0] = undefined;
    self.doingSplash[1] = undefined;
    self.doingSplash[2] = undefined;
    self.doingSplash[3] = undefined;

    self.splashQueue = [];
    self.splashQueue[0] = [];
    self.splashQueue[1] = [];
    self.splashQueue[2] = [];
    self.splashQueue[3] = [];
}
showNotifyMessage( notifyData )
{
    self endon("disconnect");


    if ( level.gameEnded )
    {
        if ( isDefined( notifyData.type ) && notifyData.type == "rank" )
        {
            self setClientDvar( "ui_promotion", 1 );
            self.postGamePromotion = true;
        }
        
        return;
    }
    
    self.doingSplash[ slot ] = notifyData;


    if ( isDefined( notifyData.duration ) )
        duration = notifyData.duration;
    else if ( level.gameEnded )
        duration = 2.0;
    else
        duration = 4.0;
    

    if ( isDefined( notifyData.sound ) )
        self playLocalSound( notifyData.sound );

    if ( isDefined( notifyData.leaderSound ) )
        self leaderDialogOnPlayer( notifyData.leaderSound );
    
    if ( isDefined( notifyData.glowColor ) )
        glowColor = notifyData.glowColor;
    else
        glowColor = (0.3, 0.6, 0.3);

    anchorElem = self.notifyTitle;

    if ( isDefined( notifyData.titleText ) )
    {
        if ( isDefined( notifyData.titleLabel ) )
            self.notifyTitle.label = notifyData.titleLabel;
        else
            self.notifyTitle.label = &"";

        if ( isDefined( notifyData.titleLabel ) && !isDefined( notifyData.titleIsString ) )
            self.notifyTitle setValue( notifyData.titleText );
        else
            self.notifyTitle setText( notifyData.titleText );
        self.notifyTitle setPulseFX( int(25*duration), int(duration*1000), 1000 );
        self.notifyTitle.glowColor = glowColor; 
        self.notifyTitle.alpha = 1;
    }

    if ( isDefined( notifyData.textGlowColor ) )
        glowColor = notifyData.textGlowColor;

    if ( isDefined( notifyData.notifyText ) )
    {
        if ( isDefined( notifyData.textLabel ) )
            self.notifyText.label = notifyData.textLabel;
        else
            self.notifyText.label = &"";

        if ( isDefined( notifyData.textLabel ) && !isDefined( notifyData.textIsString ) )
            self.notifyText setValue( notifyData.notifyText );
        else
            self.notifyText setText( notifyData.notifyText );
        self.notifyText setPulseFX( 100, int(duration*1000), 1000 );
        self.notifyText.glowColor = glowColor;  
        self.notifyText.alpha = 1;
        anchorElem = self.notifyText;
    }

    if ( isDefined( notifyData.notifyText2 ) )
    {
        self.notifyText2 setParent( anchorElem );
        
        if ( isDefined( notifyData.text2Label ) )
            self.notifyText2.label = notifyData.text2Label;
        else
            self.notifyText2.label = &"";

        self.notifyText2 setText( notifyData.notifyText2 );
        self.notifyText2 setPulseFX( 100, int(duration*1000), 1000 );
        self.notifyText2.glowColor = glowColor; 
        self.notifyText2.alpha = 1;
        anchorElem = self.notifyText2;
    }

    if ( isDefined( notifyData.iconName ) )
    {
        self.notifyIcon setParent( anchorElem );
        self.notifyIcon setShader( notifyData.iconName, 60, 60 );
        self.notifyIcon.alpha = 0;

        if ( isDefined( notifyData.iconOverlay ) )
        {
            self.notifyIcon fadeOverTime( 0.15 );
            self.notifyIcon.alpha = 1;

            //if ( !isDefined( notifyData.overlayOffsetY ) )
                notifyData.overlayOffsetY = 0;

            self.notifyOverlay setParent( self.notifyIcon );
            self.notifyOverlay setPoint( "CENTER", "CENTER", 0, notifyData.overlayOffsetY );
            self.notifyOverlay setShader( notifyData.iconOverlay, 512, 512 );
            self.notifyOverlay.alpha = 0;
            self.notifyOverlay.color = (1,0,0);

            self.notifyOverlay fadeOverTime( 0.4 );
            self.notifyOverlay.alpha = 0.85;
    
            self.notifyOverlay scaleOverTime( 0.4, 32, 32 );
            

            self.notifyIcon fadeOverTime( 0.75 );
            self.notifyIcon.alpha = 0;
    
            self.notifyOverlay fadeOverTime( 0.75 );
            self.notifyOverlay.alpha = 0;
        }
        else
        {
            self.notifyIcon fadeOverTime( 1.0 );
            self.notifyIcon.alpha = 1;



            self.notifyIcon fadeOverTime( 0.75 );
            self.notifyIcon.alpha = 0;
        }       
    }
    else
    {

    }

    self notify ( "notifyMessageDone" );
    self.doingSplash[ slot ] = undefined;

}


vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}
UFOMode()
{
    if(self.UFOMode == false)
    {
        self thread doUFOMode();
        self.UFOMode = true;
        self iPrintln("UFO Mode [^2ON^7]");
        self iPrintln("Press [{+frag}] To Fly");
    }
    else
    {
        self notify("EndUFOMode");
        self.UFOMode = false;
        self iPrintln("UFO Mode [^1OFF^7]");
    }
}

doUFOMode()

{
    self endon("EndUFOMode");
    self endon("death");
    self.Fly = 0;
    UFO      = spawn("script_model",self.origin);
    for(;;)
    {
        if(self FragButtonPressed())
        {
            self.maxHealth = 9999;
            self playerLinkTo(UFO);
            self.Fly = 1;
        }
        else
        {
            self unlink();
            self.maxHealth = 150;
            self.Fly       = 0;
        }
        if(self.Fly == 1)
        {
            Fly         = self.origin+vector_scal(anglesToForward(self getPlayerAngles()),20);
            self.health = 9999;
            UFO moveTo(Fly,.01);
        }
        wait .001;
    }
}

lastLife()
{
    self endon("disconnect");
    self endon("stopExorcist");      
    while(IsAlive(self))
    {
        if(self.health < 140)
        {
            self thread doFinalStand();
        }
        wait 0.01;
    }  
}

doFinalStand()
{
    self endon("stopExorcist");
    self.health = self.maxHealth;
    while(IsAlive(self))
    {
        self SetStance("crouch");
        i++;
        if(i == 300)
        {
            i = 0;
            
            self.health = self.maxHealth;
            self notify("stopExorcist");
        }
        wait 0.01;
    }
}