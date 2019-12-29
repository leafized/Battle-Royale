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
    for(i = 0; i < 5; i++)
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

spawnSpecial(ent_num, entity_item, origin, lowerMessage, canPickup, isPerk , isAmmo, isKillstreak)
{
    if(level.spawnedSP[ent_num] == false)
    {
        level.spawnSP[ent_num] = true;
        level.spawnSP[ent_num].effect = effect;
        PlayFX( level._effect[effect ], origin );//ac130_flare
        level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
        level.spawnSPF[ent_num] = spawn("script_model", origin);
        level.spawnSPF[ent_num] SetModel( "" );
        level.spawnSP[ent_num].message = lowerMessage;
        level.spawnSP[ent_num].isPerk = isPerk;
        if(isPerk)
        {
            level.spawnSP[ent_num].atr = entity_item;
        }
        wait .05;
        level.spawnSP[ent_num ].eff = PlayLoopedFX( level._effect["ac130_light_red_blink"], .1, origin );//ac130_flare; PlayFXOnTag( <effect id >, <entity>, <tag name> )
         level.spawnedSP[ent_num] = true;
    }
}