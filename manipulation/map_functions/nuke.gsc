delaythread_nuke( delay, func )
{
    level endon ( "nuke_cancelled" );

    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( delay );
    
    thread [[ func ]]();
}

doNuke( allowCancel )
{
    SetDvarIfUninitialized( "scr_nukeTimer", 10 );
    
    level endon ( "nuke_cancelled" );
    
    level.nukeInfo.player = self;
    level.nukeInfo.team = self.pers["team"];

    level.nukeIncoming = true;
    
    //maps\mp\gametypes\_gamelogic::pauseTimer();
    //level.timeLimitOverride = true;
    //setGameEndTime( int( gettime() + (level.nukeTimer * 1000) ) );
    SetDvar( "ui_bomb_timer", 4 ); // Nuke sets '4' to avoid briefcase icon showing

    if( level.teambased )
    {
        thread teamPlayerCardSplash( "used_nuke", self, self.team );
    }
    else
    {
        if( !level.hardcoreMode )
            self IPrintLnBold( &"MP_FRIENDLY_TACTICAL_NUKE" );
    }

    level thread delaythread_nuke( (level.nukeTimer - 3.3), ::nukeSoundIncoming );
    level thread delaythread_nuke( level.nukeTimer, ::nukeSoundExplosion );
    level thread delaythread_nuke( level.nukeTimer, ::nukeSlowMo );
    level thread delaythread_nuke( level.nukeTimer, ::nukeEffects );
    level thread delaythread_nuke( (level.nukeTimer + 0.25), ::nukeVision );
    level thread delaythread_nuke( (level.nukeTimer + 1.5), ::nukeDeath );
    level thread delaythread_nuke( (level.nukeTimer + 1.5), ::nukeEarthquake );
    level thread nukeAftermathEffect();
    level thread update_ui_timers();

    if ( level.cancelMode && allowCancel )
        level thread cancelNukeOnDeath( self ); 

    // leaks if lots of nukes are called due to endon above.
    clockObject = spawn( "script_origin", (0,0,0) );
    clockObject hide();

    nukeTimer = level.nukeTimer;
    while( nukeTimer > 0 )
    {
        // TODO: get a new sound for this so we don't remind people of the old nuke
        clockObject playSound( "ui_mp_nukebomb_timer" );
        wait( 1.0 );
        nukeTimer--;
    }
}

cancelNukeOnDeath( player )
{
    player waittill_any( "death", "disconnect" );

    if ( isDefined( player ) && level.cancelMode == 2 )
        player thread maps\mp\killstreaks\_emp::EMP_Use( 0, 0 );


    //maps\mp\gametypes\_gamelogic::resumeTimer();
    //level.timeLimitOverride = false;

    SetDvar( "ui_bomb_timer", 0 ); // Nuke sets '4' to avoid briefcase icon showing
    level.nukeIncoming = undefined;

    level notify ( "nuke_cancelled" );
}

nukeSoundIncoming()
{
    level endon ( "nuke_cancelled" );

    foreach( player in level.players )
        player playlocalsound( "nuke_incoming" );
}

nukeSoundExplosion()
{
    level endon ( "nuke_cancelled" );

    foreach( player in level.players )
    {
        player playlocalsound( "nuke_explosion" );
        player playlocalsound( "nuke_wave" );
    }
}

nukeEffects()
{
    level endon ( "nuke_cancelled" );

    SetDvar( "ui_bomb_timer", 0 );
    //setGameEndTime( 0 );

    level.nukeDetonated = true;

    foreach( player in level.players )
    {
        playerForward = anglestoforward( player.angles );
        playerForward = ( playerForward[0], playerForward[1], 0 );
        playerForward = VectorNormalize( playerForward );
    
        nukeDistance = 5000;
        /# nukeDistance = getDvarInt( "scr_nukeDistance" ); #/

        nukeEnt = Spawn( "script_model", player.origin + ( playerForward * nukeDistance ) );
        nukeEnt setModel( "tag_origin" );
        nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
        nukeEnt thread nukeEffect( player );
        //player.nuked = true;
    }
}

nukeEffect( player )
{
    level endon ( "nuke_cancelled" );

    player endon( "disconnect" );

    waitframe();
    PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin", player );
}

nukeAftermathEffect()
{
    level endon ( "nuke_cancelled" );

    level waittill ( "spawning_intermission" );
    
    afermathEnt = getEntArray( "mp_global_intermission", "classname" );
    afermathEnt = afermathEnt[0];
    up = anglestoup( afermathEnt.angles );
    right = anglestoright( afermathEnt.angles );

    PlayFX( level._effect[ "nuke_aftermath" ], afermathEnt.origin, up, right );
}

nukeSlowMo()
{
    level endon ( "nuke_cancelled" );
    
    SetSlowMotion( 1.0, 0.25, 0.5 );
    level waittill( "nuke_death" );
    SetSlowMotion( 0.25, 1, 2.0 );
}

nukeVision()
{
    level endon ( "nuke_cancelled" );

    level.nukeVisionInProgress = true;
    VisionSetNaked( "mpnuke", 3 );

    level waittill( "nuke_death" );

    VisionSetNaked( level.nukeVisionSet, 5 );
    VisionSetNakeD( "default", 5);
    
    VisionSetPain( level.nukeVisionSet );
}

nukeDeath()
{
    level endon ( "nuke_cancelled" );

    level notify( "nuke_death" );
    
    maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    
    AmbientStop(1);

    foreach( player in level.players )
    {
        // don't kill teammates
        if( level.teambased )
        {
            if( IsDefined( level.nukeInfo.team ) && player.team == level.nukeInfo.team )
                continue;
        }
        // ffa, don't kill the player who called it
        else
        {
            if( IsDefined( level.nukeInfo.player ) && player == level.nukeInfo.player )
                continue;
        }

        player.nuked = true;    
        if ( isAlive( player ) && player != self)
            player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
    }

    level thread nuke_EMPJam();

    level.nukeIncoming = undefined;
}

nukeEarthquake()
{
    level endon ( "nuke_cancelled" );

    level waittill( "nuke_death" );

}

nuke_EMPJam()
{
    level endon ( "game_ended" );

    level maps\mp\killstreaks\_emp::destroyActiveVehicles( level.nukeInfo.player, getOtherTeam( level.nukeInfo.team ) );

    // since nukes do emp damage, might as well emp jam for a little while also

    // end emp threads
    if( level.teambased )
    {
        level notify( "EMP_JamTeam" + "axis" );
        level notify( "EMP_JamTeam" + "allies" );
    }
    else
    {
        level notify( "EMP_JamPlayers" );
    }

    // set this up to end itself if called again
    level notify( "nuke_EMPJam" );
    level endon( "nuke_EMPJam" );

    if( level.teambased )
    {
        level.teamNukeEMPed[ getOtherTeam( level.nukeInfo.team ) ] = true;
    }
    else
    {
        level.teamNukeEMPed[ level.nukeInfo.team ] = true;
        level.teamNukeEMPed[ getOtherTeam( level.nukeInfo.team ) ] = true;
    }

    level notify( "nuke_emp_update" );

/#
    level.nukeEmpTimeout = GetDvarFloat( "scr_nuke_empTimeout" );
#/
    level thread keepNukeEMPTimeRemaining();
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( level.nukeEmpTimeout );

    if( level.teambased )
    {
        level.teamNukeEMPed[ getOtherTeam( level.nukeInfo.team ) ] = false;
    }
    else
    {
        level.teamNukeEMPed[ level.nukeInfo.team ] = false;
        level.teamNukeEMPed[ getOtherTeam( level.nukeInfo.team ) ] = false;
    }

    foreach( player in level.players )
    {
        if( level.teambased && player.team == level.nukeInfo.team )
            continue;

        player.nuked = undefined;
    }

    // we want the nuke vision to last the rest of this match, leaving here in case we change our minds :)
    //level.nukeVisionInProgress = undefined;
    //VisionSetNaked( "", 5.0 ); // go to default visionset

    level notify( "nuke_emp_update" );
    level notify ( "nuke_emp_ended" );
}

keepNukeEMPTimeRemaining()
{
    level notify( "keepNukeEMPTimeRemaining" );
    level endon( "keepNukeEMPTimeRemaining" );

    level endon( "nuke_emp_ended" );

    // we need to know how much time is left for the unavailable string
    level.nukeEmpTimeRemaining = int( level.nukeEmpTimeout );
    while( level.nukeEmpTimeRemaining )
    {
        wait( 1.0 );
        level.nukeEmpTimeRemaining--;
    }
}

nuke_EMPTeamTracker()
{
    level endon ( "game_ended" );

    for ( ;; )
    {
        level waittill_either ( "joined_team", "nuke_emp_update" );

        foreach ( player in level.players )
        {
            if ( player.team == "spectator" )
                continue;

            if( level.teambased )
            {
                if( IsDefined( level.nukeInfo.team ) && player.team == level.nukeInfo.team )
                    continue;
            }
            else
            {
                if( IsDefined( level.nukeInfo.player ) && player == level.nukeInfo.player )
                    continue;
            }

            player SetEMPJammed( level.teamNukeEMPed[ player.team ] );
        }
    }
}

update_ui_timers()
{
    level endon ( "game_ended" );
    level endon ( "disconnect" );
    level endon ( "nuke_cancelled" );
    level endon ( "nuke_death" );

    nukeEndMilliseconds = (level.nukeTimer * 1000) + gettime();
    SetDvar( "ui_nuke_end_milliseconds", nukeEndMilliseconds );

    level waittill( "host_migration_begin" );

    timePassed = maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

    if ( timePassed > 0 )
    {
        SetDvar( "ui_nuke_end_milliseconds", nukeEndMilliseconds + timePassed );
    }
}