
local function config(name)
    return settings.startup['px:trap-'..name].value
    end
  
  local function sprite(name)
    return '__BiterTrap_1.0.0__/assets/'..name
    end
    
  local function sound(name)
    return '__BiterTrap_1.0.0__/assets/'..name
    end
  
 data:extend({
    
    -- This is the item that is used to place the entity on the map.
    {
      type = 'item',
      name = 'px-trap-item',
      
      icon      =  sprite 'trap.png',
      icon_size =  32     ,
      order     = 'z'     ,

      place_result = 'px-trap-entity',
      stack_size   =  50            ,
      },
  
    })
 data:extend({
      {
        type = "simple-entity",  -- or "furnace", "container", or other entity types depending on what behavior you want
        name = "px-trap-entity",
        icon = sprite("trap.png"),
        icon_size = 32,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "px-trap-item"},
        max_health = 100,
        corpse = "small-remnants",
        collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        picture = {
          filename = sprite("trap.png"),
          width = 32,
          height = 32,
        }
      }
    })
    
  data:extend({
    {
      type = "recipe",
      name = "px-trap-recipe",
      energy_required = 1,
      enabled = false,
      ingredients = {
        { type = "item", name = "steel-plate", amount = 1 },
      },
      results = { { type = "item", name = "px-rs-item", amount = 1 } }
    },
     -- This is the technology that will unlock the recipe.
    {
      name = 'px-trap-technology',
      type = 'technology',
      
      -- Technology icons are quite large, so it is important
      -- to specify the size. As all icons are squares this is only one number.
      icon = sprite 'trap-technology.png',
      icon_size = 128,
      

        prerequisites = {"electric-energy-distribution-1"},
        
        effects = {
          { type   = 'unlock-recipe',
            recipe = 'px-trap-recipe'
            },

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