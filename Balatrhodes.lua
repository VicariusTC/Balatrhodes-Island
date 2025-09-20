----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas({
    key = 'modicon',
    path = 'modicon.png',
    px = 34,
    py = 34
})

SMODS.Rarity{
    key = "Transformed",
    default_weight = 0,
    badge_colour = HEX("6B2980"),
    pools = {["Joker"] = true},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

Balatrhodes_Config = SMODS.current_mod.config

SMODS.load_file("data/globals.lua")()
SMODS.load_file("data/findJokers.lua")()
SMODS.load_file("data/jokerFunctions.lua")()
SMODS.load_file("data/jokers.lua")()
SMODS.load_file("data/consumables.lua")()
SMODS.load_file("data/enhancements.lua")()
SMODS.load_file("data/00RhodesJokers.lua")()
SMODS.load_file("data/01AegirJokers.lua")()
SMODS.load_file("data/02IberiaJokers.lua")()
SMODS.load_file("data/03KazimierzJokers.lua")()
SMODS.load_file("data/04LeithanienJokers.lua")()
SMODS.load_file("data/05SargonJokers.lua")()
SMODS.load_file("data/06LateranoJokers.lua")()
SMODS.load_file("data/07ColumbiaJokers.lua")()
SMODS.load_file("data/08RhineLabJokers.lua")()
SMODS.load_file("data/10SiracusaJokers.lua")()
SMODS.load_file("data/11HigashiJokers.lua")()
SMODS.load_file("data/15RimBillitonJokers.lua")()
SMODS.load_file("data/16VictoriaJokers.lua")()
SMODS.load_file("data/17TaraJokers.lua")()

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {
		align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6
	}, nodes = {
        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = localize("akts_jokers_only_config"), scale = 1, w = 0, shadow = true, ref_table = Balatrhodes_Config, ref_value = "balatrhodes_only"},
            }},
            
        }},
	}}
end
----------------------------------------------
------------MOD CODE END----------------------
    
