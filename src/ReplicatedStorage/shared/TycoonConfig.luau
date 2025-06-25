--!strict
-- TycoonConfig.lua
-- This ModuleScript holds all static data and configurations for our tycoon types.
-- By centralizing this data, we can easily add, remove, or modify tycoon types
-- without changing the core game logic.

local TycoonConfig = {} -- This table will be returned when the module is required.

-- Define our different tycoon types
-- Each entry in this table represents a different tycoon type a player can choose.
-- The key (e.g., "MinerTycoon") will be used as a unique identifier.
TycoonConfig.TycoonTypes = {
	-- Miner Tycoon: Focuses on raw resource extraction
	MinerTycoon = {
		DisplayName = "Miner Colony",
		Description = "Specializes in raw resource extraction. Great for producing ores!",
		TemplatePath = "ServerStorage.TycoonTemplates.MinerTycoonTemplate", -- Path to its template model
		InitialResources = { -- Define initial resources for this tycoon type
			Money = 100,
			Ore = 50,
			Energy = 20,
		},
		-- Add more properties here as needed (e.g., unique starting droppers, special abilities)
	},

	-- Refiner Tycoon: Focuses on processing raw materials into refined goods
	RefinerTycoon = {
		DisplayName = "Refiner Colony",
		Description = "Focuses on processing raw materials into refined goods. Essential for trade!",
		TemplatePath = "ServerStorage.TycoonTemplates.RefinerTycoonTemplate",
		InitialResources = {
			Money = 100,
			ProcessedMetal = 10,
			Energy = 50,
		},
	},

	-- Other potential tycoon types (commented out for now, but ready to be added!)
	-- CombatTycoon = {
	--     DisplayName = "Combat Outpost",
	--     Description = "Builds defenses and trains combat units. Protects the galaxy!",
	--     TemplatePath = "ServerStorage.TycoonTemplates.CombatTycoonTemplate",
	--     InitialResources = {
	--         Money = 150,
	--         WeaponsParts = 20,
	--         Energy = 30,
	--     },
	-- },
}

-- You can add other configurations here, like Gacha item definitions, upgrade costs, etc.
TycoonConfig.GachaItems = {
	-- Example structure for gacha items
	CommonDropperBlueprint = {
		DisplayName = "Common Ore Dropper Blueprint",
		Rarity = "Common",
		Weight = 50, -- For gacha probability calculation
		Description = "A basic blueprint for an ore dropper."
	},
	RareEnergyCell = {
		DisplayName = "Rare Energy Cell",
		Rarity = "Rare",
		Weight = 10,
		Description = "Provides a small boost of energy."
	}
	-- More gacha items will go here
}


return TycoonConfig -- This makes the 'TycoonConfig' table accessible to other scripts.