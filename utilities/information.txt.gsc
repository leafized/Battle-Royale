/*
    
    TO GAMEMODE USERS : This mode is still in beta, and is being developed. Currently maps are not in a finished state.
    You will need to create your own map, ask someone to make a map for you, or wait until i finish adding supported maps.
    
    Note: This game mode is NOT finished, and this code may not work as expected. Please wait until a public release, or expect occasional bugs.
    
    Note: You can change the starting weapon by changing game_weapon to the weapon of your choice. Remember that thi weapon will have NO AMMO
    
    Note: Leafized is the main project head, so please consult me for any issues, bugs, or errors you may notice.
    
    This project is updated daily, and will support new features. This project is currently free.
    
    If you wish to donate for my time, https://paypal.me/erinandbrad is my paypal. 
    If you wish to contribute, feel free to do so and request a branch.
    
    Thank you for participating!
    
    
    
    
    Current Maps with features
    Derail
    Rust
    Highrise
    
    
    
    
    
    
    
    TO MAP CREATORS
    
    [1] This source code is public but created by and for Leafized.
    [2] You have access to this only through Infinity Loader.
    [3] All functions needed to create a map are going to be listed above.
    [4] You must go to main and change map_mode to 1 instead of 0. This will load your custom maps, all default supported maps will not load.
    You must add maps via the array system provided. This is the best method for map loading. All maps must be 1 to 1
    Example:
    
    level.mapList = ["mp_rust"];
    level.mapFunc = [::custom_rust];
    
    level.mapList[0] is mp_rust.
    level.mapFunc[0] is the function.
    
    All spawn functions must pass through the map edit page.
    All functions are testing and working, any changes to the scripts may cause unexpected errors. Do not change unless you know what you are doing.
    All functions are proprietary, so i ask that you do not use this code to make a mod menu.
    Map editor source code is also available at http://github.com/Leafized/MW-Editor
    
    
    ========== START FUNCTION LISTING ======================
    
 
        
      1. Information and Guide:
            -You must be able to understand basic GSC to understand how this works.
            -The code should be easy to understand and implement in your own right.
            -Spawning systems may chane, location monitoring will change as well.
            
      2. Custom Functions
           -This is a  list of all current custom functions within this mod.
           
           spawnCarepackage(ent_num,origin,angles,is_solid,type,lowerMessage,notify_bool)
           spawns a carepackage.
           
           spawnMapModel(ent_num,type,origin,isHeli)
           spawns a map model / helicopter
           
           spawnSpecial(ent_num,entity_item,origin,lowerMessage,canPickup,isPerk,isAmmo,isKillstreak)
           spawns  perks, attachments, ammo,etc..
           
           spawnWeapon(ent_num,weapon,origin,angles,lowerMessage,allowPickup)
           
           spawnWeaponRand(ent_num,origin,angles)
           spawnRandomWeapon(ent_num,origin)
           
           spawnBox(ent_num,origin)
           spawnCamera(ent_num,origin,angles,lowerMessage)
           spawnCamControl(ent_num,origin,angles,lowerMessage,tp_origin)
           spawnHeli(newlocs);
           
           
           monitorWeaps()
           -monitors weapon 
           
           monitorPerks()
           -monitors perks / special spawns
           
           buttonMonitor()
           - monitors buttons
            - aim + knife to print location
           pLocation() 
           - prints current location
           
           
       4. 
*/