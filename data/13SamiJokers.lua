-- needs debuff handling
SMODS.Joker{
    key = 'Gitano',
    name = 'Gitano',
    rarity = 1,
    atlas = 'Jokers',
	cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = {x = 0, y = 18},
    config = { 
      extra = {
        missingBuffs = {"handSize", "discard", "mult"},
        handSizeBonus = 1,
        discardBonus = 1,
        multBonus = 8,
        appliedBuffs = {handSize = 0, discards = 0, mult = 0, },
        colours = {G.C.ORANGE, G.C.ORANGE, G.C.ORANGE},
        tagClass = {"Caster"},
        tagFaction = {"Sami"}
      }
    },
    loc_vars = function(self,info_queue,center)
        return {
            vars = 
            {
                center.ability.extra.handSizeBonus, center.ability.extra.discardBonus, center.ability.extra.multBonus,
                colours = {
                    center.ability.extra.colours[1],
                    center.ability.extra.colours[2],
                    center.ability.extra.colours[3]
                },
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then
            if card.ability.extra.appliedBuffs.handSize > 0 then
                G.hand:change_size(card.ability.extra.appliedBuffs.handSize)
            end
            if card.ability.extra.appliedBuffs.discards > 0 then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.appliedBuffs.discards
                ease_discard(card.ability.extra.appliedBuffs.discards)
            end
        else
            GetGitanoBuff(card)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.appliedBuffs.handSize > 0 then
            G.hand:change_size(-card.ability.extra.appliedBuffs.handSize)
        end
        if card.ability.extra.appliedBuffs.discards > 0 then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.appliedBuffs.discards
            ease_discard(-card.ability.extra.appliedBuffs.discards)
        end
    end,
    calculate = function(self,card,context)
        if context.using_consumeable and context.consumeable.ability.name == 'The High Priestess' and not context.blueprint then
            GetGitanoBuff(card)
        end
        if context.joker_main and card.ability.extra.appliedBuffs.mult > 0 then
            return {
                mult = card.ability.extra.appliedBuffs.mult,
                card = card
            }
        end
    end,
    set_badges = function(self, card, badges)
        aktsBadgeHelper(self,card,badges)
    end
}