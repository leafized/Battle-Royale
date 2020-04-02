
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define game_weapon = "defaultweapon_mp";
#define debugging = false;

init()
{
     
    level thread onPlayerConnect();
    level.airDropCrates = getEntArray( "care_package", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    
    PreCacheItem( "throwingknife_rhand_mp" );
    foreach( models in StrTok( "com_widescreen_monitor,com_laptop_2_open,foliage_cod5_tree_pine05_large, foliage_pacific_tropic_shrub01,foliage_shrub_desertspikey, vehicle_little_bird_armed,prop_flag_neutral", "," ))
     PreCacheModel( models );
     foreach(shades in StrTok( "cardicon_painkiller,compassping_enemyfiring,hint_health", "," ))
     PreCacheShader( shades );
     level thread mapSetup();
    SetDvar( "g_hardcore", 1 );
    
    level.onOneLeftEvent = ::onOneLeftEvent;
    level.onPlayerKilled = ::onPlayerKilled;
    setDvar( "scr_" + level.gameType + "_numlives", 1 );    
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
        self thread spawnThreads();
    }
}
onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId )
{    
    player sayAll("I have eliminated ^1" + self.name );
}
