
--[[

  Hello!
  
  The data stage of this tutorial mod is going to demonstrate the following things:
    
    > Reading mod startup settings
    
    > Using simple functions to make repetitive code shorter
    
    > Using name prefixes to ensure compatibility with other mods
    
    > Creating an entity 
    
    > Creating an item to place the entity
    
    > Creating a recipe to craft the item
    
    > Conditionally Creating a technology to unlock the recipe
    
    > Bonus: Changing existing prototypes based on what other mods are installed

  Abbreviations used:
    
    > HCG = Hand Crank Generator
    
    > data "stage", settings "stage" = In factorio each "stage" of the startup process
        is divided into three "phases". I.e. the data stage consists of data.lua,
        data-updates.lua and data-final-fixes.lua. This mod does not use updates or 
        final-fixes.
    
  ]]

local function config(name)
    return settings.startup['px:trap-'..name].value
    end
  
  local function sprite(name)
    return '__BiterTrap_1.0.0__/assets/'..name
    end
    
  local function sound(name)
    return '__BiterTrap_1.0.0__/assets/'..name
    end
  
   
  
  -- To add new prototypes to the game I descripe each prototype in a table.
  -- Then each of these tables is put together into one large table, and that large
  -- table is handed to data:extend() which will put it into data.raw where
  -- the game engine can find them.
  
  data:extend({
    
    -- This is the item that is used to place the entity on the map.
    {
      type = 'item',
      name = 'px-trap-item',
      
      -- In lua any function that is called with exactly one argument
      -- can be written without () brackets if the argument is a string or table.
      
      -- here we call sprite() which will return the full path:
      -- '__eradicators-hand-crank-generator__/sprite/hcg-item.png'
      
      icon      =  sprite 'trap.png',
      icon_size =  32     ,
      order     = 'z'     ,
      
      -- This is the name of the entity to be placed.
      -- For convenience the item, recipe and entity
      -- often have the same name, but this is not required.
      -- For demonstration purposes I will use explicit
      -- names here.
      place_result = 'px-trap-entity',
      stack_size   =  50            ,
      },
  
    })
    
  
    
  -- The next step is slightly more complicated. According to the "lore" of this
  -- mod the player only gets a single HCG. But because some people might want
  -- more than one there is a "mod setting" that enables a technology and recipe.
  
  -- So I have to read the setting and only create the technology and recipe prototypes
  -- if the setting is enabled.
  data:extend({
    {
      type = "recipe",
      name = "px-trap-recipe",
      energy_required = 1,
      enabled = false,
      ingredients = {
        { type = "item", name = "steel-plate", amount = 1 },
      },
      results = { { type = "item", name = "px:rs-item", amount = 1 } }
    },
     -- This is the technology that will unlock the recipe.
    {
      name = 'px-trap-technology',
      type = 'technology',
      
      -- Technology icons are quite large, so it is important
      -- to specify the size. As all icons are squares this is only one number.
      icon = sprite 'trap-technology.png',
      icon_size = 128,
      
      -- Like recipes, technologies can also have normal and expensive difficulty.
      -- In mods where both difficulties should have the same recipe there are two
      -- possible ways to specify this. One is to only specify normal= and leave
      -- out expensive=. The more commonly used way is to put all properties that would
      -- go into the normal= subtable directly into the main prototype. I demonstrate
      -- this approach here by commenting out the normal= sub-table construction [1].
      -- This is also the way that most vanilla recipes and technologies are specified.
      
      -- normal = { -- [1] put parameters directly into prototype
        
        -- Deciding when a recipe becomes available is an important balancing decision.
        prerequisites = {"electric-energy-distribution-1"},
        
        effects = {
          { type   = 'unlock-recipe',
            recipe = 'px-trap-recipe'
            },
            
          -- The "nothing" effect is used to implement research effects
          -- that the engine does not support directly. It places a marker
          -- with a description in the technology menu so that the player
          -- knows what is going to happen. The actual effect has to be implemented
          -- by the mod in control stage.
          { type = 'nothing',
            effect_description = {'px-trap.trapping'},
            },
            
          },

        unit = {
          count = 150,
          ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack"  , 1},
            },
          time = 30,
          },
          
        -- }, -- [1] put parameters directly into prototype
      
      order = "c-e-b2",
      },
  })