/*
  All current custom functions and their params
  spawnCarepackage(ent_num,origin,angles,is_solid,type,lowerMessage,notify_bool) spawns a carepackage
    spawnWeapon(ent_num,isRandomWeapon,weapon,origin,angles,lowerMessage,allowPickup) spawns a weapon
    returnMap() gets the name of the map
    spawnSpecial(ent_num,attachment,effect,origin,lowerMessage,canPickup) spawns a effect with a perk or boost
    spawnMapModel(ent_num,type,origin) spawns a model in the map.
    spawnBox(ent_num,origin) spawns a mystery box.
    spawnTeleporter(ent_num,origin,lowerMessage,flag_end); There must be 2 flags. one for each way.
    
*/
returnMap()
{
    return GetDvar("mapname");
}

mapSetup()
{

    level.mapList = ["mp_rust","mp_derail","mp_highrise"];
    level.mapFunc = [::map_mp_rust,::map_mp_outpost, ::map_mp_highrise];
    currentMap    = getDvar("mapname");
    for(i=0;i<level.mapList.size;i++)
    {
        if(level.mapList[i]==currentMap)
        {
            if(isDefined(level.mapFunc[i]))
            {
                level thread [[level.mapFunc[i]]]();
                return true;
            }
        }
    }
    return false;
}

map_mp_rust()
{

    spawnRandomWeapon(0,(1546.74, 1396.64, -229.348));
    
    spawnWeapon(0,"cheytac_mp",(839.695, 478.659, -235.577),undefined,"Intervention",false);
    spawnWeapon(1,"deserteaglegold_mp",(1533.15, 945.376, -245.814),undefined,"Desert Eagle Gold",false);
    spawnWeapon(2,level.weaponList[RandomInt(1000)],(478.385, 1800.66, -226.032),undefined,"Weapon",false);
    spawnWeapon(3,level.weaponList[RandomInt(1000)],(440.567,817.016, -197.875),undefined,"Weapon",false);
    
    spawnMapModel(0,"foliage_cod5_tree_pine05_large" , (-79.5368, 883.821,-239.389));
    spawnMapModel(1,"foliage_cod5_tree_pine05_large" , (-58.9049, 260.902,-239.536));
    spawnMapModel(2,"foliage_cod5_tree_pine05_sm" , (1074.05, 511.428, -238.365));
    spawnMapModel(3,"projectile_rpg7", (725.493, 1084.04, 268.125));
   
    //spawnSpecial(0,"specialty_falldamage",(478.385, 1800.66, -200.032),"Commando Pro",true,true);
    spawnCarepackage(0,(-79.5368, 883.821,-239.389),undefined,true,"friendly",true,"specialty_falldamage"," ^5Commando Pro", true);
}

map_mp_highrise()
{
    spawnTeleporter(0,(-2321.26,8798.52,2850.01),"Rooftop",(-2747.33,6755.14,3216.13));
    spawnTeleporter(1,(-2747.33,6755.14,3216.13),"Crane",(-2321.26,8798.52,2850.01));
    
    spawnTeleporter(2,(1074.44,6821.90,2824.13),"Room Ledge",(2.11159, 6395.93,3020.13));
    spawnTeleporter(3,(2.11159, 6395.93,3020.13), "Stairway",(1074.44,6821.90,2824.13));
    
    spawnWeapon(1,"masada_xmags_mp",(2.07819,5943.06,3020.13),undefined,"ACR Extended Mags",true);
    spawnWeapon(0,"mp5k_fmj_mp",(-2721.27, 6258.91, 3216.13),undefined,"MP5k Custom",true);
    spawnWeapon(2,"cheytac_thermal_mp",(-1584.99,6182.79,2976.13),undefined,"Intervention Thermal",true);
}

map_mp_outpost()
{
    spawnWeapon(0,"deserteaglegold_mp",(2741.54, 2212.63, 128.125),undefined,"Press [{+activate}] to pickup!",true);
    spawnWeapon(1, "deserteagle_mp",(-2038.69,-1367.7,33.125), undefined, undefined, false);
    spawnWeapon(2, "ump45_silencer_mp",(-1962.21,-1495.88,73.125), undefined, undefined, false);
    spawnWeapon(3, "masada_xmags_mp",(3350.66,3781.62,-15.875), undefined, undefined, false);
    spawnWeapon(4, "m16_heartbeat_mp",(1852.97,3353.07,428.125), undefined, undefined, false);
    spawnWeapon(5, "scar_silencer_mp",(2644.99,2384.36, 186.125), undefined, undefined, false);
    spawnWeapon(6, "mp5k_thermal_mp",(1780.4,3329.33,142.125), undefined, undefined, false);
    spawnWeapon(7, "aa12_xmags_mp",(701.305,-903.714,155.879), undefined, undefined, false);
    spawnWeapon(8, "rpg_mp",(-967.169,-2184.87,130.125), undefined, undefined, false);
    spawnWeapon(9, "m4_fmj_shotgun_mp",(-454.699,-2175.11,118.125), undefined, undefined, false);
    spawnWeapon(10, "cheytac_mp",(49.6679,-3631.61,90.125), undefined, " Intervention", false);
    
    spawnMapModel(0,"vehicle_little_bird_armed", (-866.476, 1533.88, -15.875) + (0,0,120), true);
}
