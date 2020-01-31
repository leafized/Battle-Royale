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
#define debugging = false;

init()
{
     
    level thread onPlayerConnect();
    level.airDropCrates = getEntArray( "care_package", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    
    foreach( models in StrTok( "foliage_cod5_tree_pine05_large, foliage_pacific_tropic_shrub01,foliage_shrub_desertspikey, vehicle_little_bird_armed,prop_flag_neutral", "," ))
     PreCacheModel( models );
     foreach(shades in StrTok( "cardicon_painkiller,compassping_enemyfiring,hint_health", "," ))
     PreCacheShader( shades );
     
     level.wepL = ["mp5k_mp","mp5k_acog_mp","mp5k_akimbo_mp","mp5k_eotech_mp","mp5k_fmj_mp","mp5k_reflex_mp","mp5k_rof_mp","mp5k_silencer_mp","mp5k_thermal_mp","mp5k_xmags_mp","mp5k_acog_fmj_mp","mp5k_acog_rof_mp","mp5k_acog_silencer_mp","mp5k_acog_xmags_mp","mp5k_akimbo_fmj_mp","mp5k_akimbo_rof_mp","mp5k_akimbo_silencer_mp","mp5k_akimbo_xmags_mp","mp5k_eotech_fmj_mp","mp5k_eotech_rof_mp","mp5k_eotech_silencer_mp","mp5k_eotech_xmags_mp","mp5k_fmj_reflex_mp","mp5k_fmj_rof_mp","mp5k_fmj_silencer_mp","mp5k_fmj_thermal_mp","mp5k_fmj_xmags_mp","mp5k_reflex_rof_mp","mp5k_reflex_silencer_mp","mp5k_reflex_xmags_mp","mp5k_rof_silencer_mp","mp5k_rof_thermal_mp","mp5k_rof_xmags_mp","mp5k_silencer_thermal_mp","mp5k_silencer_xmags_mp","mp5k_thermal_xmags_mp"];  
    level thread mapSetup();
    SetDvar( "g_hardcore", 1 );
    
    level.onOneLeftEvent = ::onOneLeftEvent;
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

