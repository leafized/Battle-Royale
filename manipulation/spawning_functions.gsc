spawnCarepackage(ent_num, origin, angles, is_solid, type, isperk ,perkname, lowerMessage)
{
    if(level.spawnedCP[ent_num ] == false)
    {
        level.spawnedCP[ent_num] = true;
        level.spawnCP[ent_num] = spawn("script_model", origin + (0,0,15)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
        level.spawnCP[ent_num] SetModel( "com_plasticcase_" + type);
        if(is_solid)
        {
            level.spawnCP[ent_num] CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        }
        level.spawnCP[ent_num].message = lowerMessage;
        
        level.spawnCP[ent_num].perk = isperk;
        level.spawnCP[ent_num].perkname = perkname;
    }
}

spawnTeleporter(ent_num, origin, lowerMessage, flag_end)
{
    if(level.spawnedTP[ent_num] == false)
    {
        level.spawnedTP[ent_num] = true;
        level.spawnTP[ent_num] = spawn("script_model", origin + (0,0,15)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
        level.spawnTP[ent_num] SetModel( "prop_flag_neutral");
        level.spawnTP[ent_num].message = lowerMessage;
        level.spawnTP[ent_num].destination = flag_end;
        
    }
}

spawnMapModel(ent_num , type , origin, isHeli)
{
    level.spawnedModel[ent_num] = true;
    level.spawnModel[ent_num]   = spawn("script_model", origin);
    level.spawnModel[ent_num]   setModel(type);
}

spawnWeapon(ent_num, weapon, origin, angles, lowerMessage, allowPickup)
{
   if(level.spawnedWep[ent_num ] == false)
   {
       level.spawnedWep[ent_num] = true;
       level.spawnWep[ent_num] = spawn("script_model", origin + (0,0, 45)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
       level.spawnWep[ent_num] SetModel( GetWeaponModel( weapon ) );
       level.spawnWep[ent_num].message = "Press ^3[{+activate}] ^7to pickup ^3" + lowerMessage;
       level.spawnWep[ent_num].weap = weapon;
   }
}
spawnWeaponRand(ent_num, origin, angles)
{
   if(level.spawnedWep[ent_num ] == false)
   {
       weapon = level.weaponList[level.weaponList.size ];
       level.spawnedWep[ent_num] = true;
       level.spawnWep[ent_num] = spawn("script_model", origin + (0,0, 45)); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> );
       level.spawnWep[ent_num] SetModel( GetWeaponModel( weapon ) );
       level.spawnWep[ent_num].message = "Press ^3[{+activate}] ^7to pickup ^3" + getWeaponNameString(weapon.id);
       level.spawnWep[ent_num].weap = weapon;
   }
}
spawnRandomWeapon(ent_num , origin)
{
    level.RandomWepCP[ent_num]        = spawn( "script_model", origin + (0,0,5) );
    level.RandomWepCP[ent_num].angles = (0,0,0);
    level.RandomWepCP[ent_num] setModel( "com_plasticcase_friendly" );
    level.WeaponModelCP[ent_num] = spawn("script_model",level.WeaponModelCP[ent_num].origin + (0,0,30));
    level.WeaponModelCP[ent_num].angles = (0,0,0);
    wait .1;
    level.randomModel[ent_num] = level.weaponList[RandomInt( level.weaponList.size)];
        level.WeaponModelCP[ent_num] setModel(GetWeaponModel(level.randomModel[ent_num]));
}

 
spawnBox(ent_num , origin)
{
    level.packRB[ent_num]        = spawn( "script_model", origin + (0,0,5) );
    level.packRB[ent_num].angles = (0,0,0);
    level.packRB[ent_num] setModel( "com_plasticcase_friendly" );
    level.wepRB[ent_num] = spawn("script_model",level.packRB[ent_num].origin + (0,0,30));
    level.wepRB[ent_num].angles = (0,0,0);
    for(;;)
    {
        level.wepmodel[ent_num] = level.weaponList[RandomInt( level.weaponList.size)];
        level.wepRB[ent_num] setModel(GetWeaponModel(level.wepmodel[ent_num]));
        wait 0.2;
    }
}

spawnCamera(ent_num, origin, angles, lowerMessage)
{
    level.cameraTV[ent_num] = spawn("script_model", origin + (0,0,5));
    level.cameraTV[ent_num] SetModel( "com_widescreen_monitor" );
    level.cameraTV[ent_num].angles = angles;
    level.cameraTV[ent_num].message = lowerMessage;
}
spawnCamControl(ent_num, origin, angles, lowerMessage, tp_origin)
{
    level.cameraCTRL[ent_num] = spawn("script_model", origin + (0,0,5));//com_laptop_2_open
    level.cameraCTRL[ent_num] SetModel( "com_laptop_2_open" );
    level.cameraCTRL[ent_num].angles = angles;
    level.cameraCTRL[ent_num].message = lowerMessage;
    level.cameraCTRL[ent_num].tp = tp_origin;
}
 addFogEnt()
{
    if(!isDefined(level.fog_ent))
    {
        level.fog_ent = [];
    }
    i = level.fog_ent.size;
    level.fog_ent[i] = SpawnFx(level._effect["nuke_aftermath"],level.mapCenter);
}

