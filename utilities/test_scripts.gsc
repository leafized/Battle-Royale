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
        level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
        level.spawnSP[ent_num] = spawn("script_model", origin);
        level.spawnSP[ent_num] SetModel( "com_plasticcase_friendly" );
        level.spawnSP[ent_num].message = lowerMessage;
        level.spawnSP[ent_num].isPerk = isPerk;
        level.spawnSP[ent_num].origin = origin ;
        if(isPerk)
        {
            level.spawnSP[ent_num].atr = entity_item;
        }
        wait .05;
        level.spawnSP[ent_num ].eff = PlayLoopedFX( level._effect["ac130_light_red_blink"], .1, origin );//ac130_flare; PlayFXOnTag( <effect id >, <entity>, <tag name> )
         level.spawnedSP[ent_num] = true;
    }
}
 
 
monitorPerks()
{
    for(i=0;i<level.spawnSP.size;i++)
  {   
      if(Distance( self.origin, level.spawnSP[i].origin ) <= 70)
      {
          self setLowerMessagE("gg" + i , "Press ^3[{+activate}] ^7 to pickup ^3" + level.spawnSP[i].message );
          
          if(self useButtonPressed() && level.spawnSP[i].isPerk == true)
         {
             self IPrintLn("Perk Given");
             self _setPerk("_" + level.spawnSP[i].atr);
 
         }
         if(self UseButtonPressed() && level.spawnSP[i].isHeal == true)
         {
             
         }
      }
     else if(Distance( self.origin, level.spawnSP[i].origin ) >= 70)
      {
          self clearLowerMessage("gg" + i );
      }
      if(i > level.spawnSP.size)
      {
          i = 0;
      }
      
  }
  wait .1;
  
}