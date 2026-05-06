return {
    descriptions = {
        Joker = {
            j_akts_AmiyaC = {
                name = "Amiya",
                text = {
                    {
                        "Creates an unowned",
                        "{C:red}Rhodes Island {}Joker ",
                        "when obtained",
                        "{C:inactive,s:0.8}(Must have room)"
                    },
                    {
                        "Gains {C:red}+#1#{} Mult when",
                        "another {C:red}Rhodes Island{}",
                        "Joker triggers.",
                        "(Up to {C:attention}#3#{} times a round)",
                        "{C:inactive,s:0.8}(Currently{} {C:red,s:0.8}+#2#{} {C:inactive,s:0.8}Mult)",
                    }
                },
            },
            j_akts_Kaltsit = {
                name = "Kal'tsit",
                text = {
                    {
                        "Creates a {C:spectral}Mon3tr{}",
                        "Summon when obtained or when",
                        "{C:attention}Boss Blind{} is selected,",
                        "{C:inactive,s:0.8}(Must have room)"
                    },
                    {
                        "Scored {C:attention}True{} cards give {C:money}$#1#{}."
                    }
                },
            },
            j_akts_FangAlter = {
                name = "Fang the Fire-Sharpened",
                text = {
                    {
                        "{C:red}+#1#{} Mult for {C:attention}#3#{} hands.",              
                    },
                    {
                        "Earn {C:money}$#2#{} at end of round."
                    },
                    {
                        "Creates a random",
                        "{C:attention}Joker Tag{} when sold."
                    }
                },
            },
            j_akts_Gavial = {
                name = "Gavial",
                text = {
                    {
                        "Adds {C:dark_edition}Foil{} to 1 other", 
                        "{C:green}Medic{} Joker when obtained."             
                    },
                    {
                        "Scored cards randomly give",
                        "between {X:mult,C:white}X#1#{} and {X:mult,C:white}X#2#{} Mult.",
                        "{C:attention} Wild Cards{} give between",
                        "{X:mult,C:white}X#3#{} and {X:mult,C:white}X#4#{} Mult instead."
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Gavial the Invincible{}",
                        "when played hand contains.",
                        "{C:attention}5 Wild Cards{}."
                    }
                },
            },
            j_akts_GavialAlter = {
                name = "Gavial the Invincible",
                text = {
                    {
                        "Scored cards randomly give",
                        "between {X:mult,C:white}X#1#{} and {X:mult,C:white}X#2#{} Mult.",
                        "{C:attention} Wild Cards{} give between",
                        "{X:mult,C:white}X#3#{} and {X:mult,C:white}X#4#{} Mult instead."
                    },
                    {
                        "{C:attention}Prevents Death{} and adds required",
                        "chips to {C:red}Chip Debt{} if score is",
                        "greater than {C:attention}#7#%{} of Blind Requirement.",
                        "Gains {C:dark_edition}Eternal{} while you have {C:red}Chip Debt{}",
                        "{C:inactive,s:0.8}Currently{} {C:red,s:0.8}#5#{} {C:inactive,s:0.8}in debt.",
                        "{C:inactive,s:0.8}(total debt is {}{C:red,s:0.8}#6#{}{C:inactive,s:0.8} chips){}"
                    },
                    --[[{
                        "You {C:attention}lose{} if {C:red}Chip Debt{}",
                        "is greater than the current",
                        "blind requirement.",
                    }]]
                }
            },
            j_akts_Yato = {
                name = "Yato",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "{C:blue}+#1#{} Chips during {C:attention}first",
                        "{C:attention}hand of{} a {C:attention}round{} or during",
                        "first hand {C:attention}after being obtained."
                    },
                }
            },
            j_akts_YatoAlter = {
                name = "Kirin R Yato",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "{C:blue}+#1#{} Chips and {C:red}+#2#{} Mult during",
                        "{C:attention}first hand of{} a {C:attention}round{} or during",
                        "first hand {C:attention}after being obtained.",
                        "This Effect applies {C:attention}16{} times if",
                        "this Joker was obtained {C:attention}this round."
                    },
                },      
            },

            j_akts_ProjektRed = {
                name = "Projekt Red",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "If played hand scores less than",
                        "{C:attention}1/#1#{} of Blind Requirement, that",
                        "played hand's score becomes {C:attention}1/#1#{}",
                        "of Blind Requirement.",
                        "{C:inactive}(Changes to {}{C:attention}1/#2#{} {C:inactive}during {C:attention}first",
                        "{C:inactive}hand after this Joker {C:attention}is obtained{}{C:inactive}.)",
                        "{C:inactive}(Values adjust based on",
                        "{C:attention}number of hands {}{C:inactive}per round.)"
                    },
                },      
            },

            j_akts_Mudrock = {
                name = "Mudrock",
                text = {
                    {
                        "{C:attention}Stone Cards'{} rank is treated as",
                        "the {C:attention}most common rank{} held in hand.",
                        "{C:inactive}(Currently {C:attention}#1#{}{C:inactive})",
                    },
                    {
                        "Every {C:attention}#2#{} {C:inactive}[#3#]{} times cards are drawn,",
                        "the {C:attention}lowest ranked{} card in",
                        "hand is enhanced to a {C:attention}Stone card{}.",
                    },
                },      
            },

            j_akts_Civilight = {
                name = "Civilight Eterna",
                text = {
                    {
                        "Adds {C:attention}#1#{} unenhanced cards with",
                        "{C:attention}Red Seal{} to deck when obtained.",
                    },
                    {
                        "Balances out {C:attention}ranks{} of all scored cards",
                        "by {C:attention}#2#{} when scoring a card with a {C:attention}Red Seal{}.",
                    },
                    {
                        "Balance {C:chips}Chips{} and {C:mult}Mult{} by {C:attention}#3#%{} when",
                        "scoring a card with a {C:attention}Red Seal{}."
                    }
                },
            },

            j_akts_Logos = {
                name = "Logos",
                text = {
                    {
                        "{C:mult}+#7#{} Mult for {C:attention}each unique rank",
                        "that was scored this round.",
                        "{C:inactive,s:0.8}(Currently{} {C:mult,s:0.8}+#8#{} {C:inactive,s:0.8}Mult)"
                    },
                    {
                        "Immediately {C:attention}win the Blind",
                        "if {C:attention}every rank{} was",
                        "scored this round.",
                        "{C:inactive}(Currently #1# out of 13 played)"
                    },
                    {
                        "{C:attention}+#6#{} hand size, but",
                        "{C:attention}-#2#{} hand size for",
                        "every {C:attention}#3#{} {C:inactive}[#4#]{} times this",
                        "Joker's effect wins a blind.",
                        "{C:inactive}(Currently{} {C:attention}#5#{} {C:inactive}hand size){}"
                    },
                },
            },

            j_akts_Blaze = {
                name = "Blaze",
                text = {
                    {
                        "Played cards with {C:hearts}#1#{} suit",
                        "give {C:red}+#2#{} Mult when scored.",
                    },
                    {
                        "Every {C:attention}#3#th{}{C:inactive}[#4#] {}scored {C:hearts}#1#{} card",
                        "gives {C:red}+#5#{} Mult instead, then",
                        "this Joker loses {C:money}$#6#{} sell value.",
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Blaze the Igniting Spark{}",
                        "at {C:attention}end of round{} if this",
                        "Joker has {C:money}$#7#{} of sell value."
                    }
                },
            },

            j_akts_BlazeAlter = {
                name = "Blaze the Igniting Spark",
                text = {
                    {
                        "Played cards with {C:hearts}#1#{} suit",
                        "give {C:red}+#2#{} Mult and apply",
                        "{C:attention}AoE {}{C:red}Burn Elemental Injury{}",
                        "equal to {C:attention}their rank{}",
                        "to the blind.",
                        "If the blind is under the",
                        "effect of a {C:red}Burn Elemental Burst{},",
                        "they give {C:red}+#3#{}{C:attention} AoE{} Mult instead."

                    },
                    {
                        "#4#",
                    },
                },
            },

            j_akts_Rosmontis = {
                name = "Rosmontis",
                text = {
                    {
                        "If {C:attention}first hand{} of round",
                        "contains exactly {C:attention}#1#{} Stone Cards,",
                        "gain {C:blue}+#3#{} hand and those",
                        "Stone Cards gain {C:chips}+#2#{} Chips.",
                    },
                    {
                        "Played Stone cards apply their",
                        "chips as an {C:attention}AoE{} twice."
                    },
                },
            },

            j_akts_Gladiia = {
                name = "Gladiia",
                text = {
                    {
                        "Creates an unowned {C:red}Aegir{}",
                        "Joker every {C:attention}#1# Flushes{} played",
                        "{C:inactive,s:0.8}(Must have room)",
                        "{C:inactive,s:0.8}(Currently{} {C:green,s:0.8}#2#{} {C:inactive,s:0.8}out of{} {C:green,s:0.8}#1#{} {C:inactive,s:0.8}played)"
                    },
                    {
                        "Scoring {C:attention}#3#s{} in {C:attention}Flushes{} are.",
                        "enhanced to {C:attention}Hooked Cards{}."
                    }
                },
            },
            j_akts_Skadi = {
                name = "Skadi",
                text = {
                    {
                        "{C:attention}+#1#{} hand size per",
                        "{C:red}Abyssal Hunter{} Joker",
                        "owned.",
                        "{C:inactive,s:0.8}(Currently{} {C:attention,s:0.8}+#2#{} {C:inactive,s:0.8}hand size)",
                    },
                    {
                        "Gains {X:mult,C:white}X#3#{} Mult per",
                        "{C:red}Abyssal Hunter{} Joker",
                        "owned and an additional",
                        "{X:mult,C:white}X#4#{} Mult if you own {C:attention}#5#+",
                        "{C:red}Abyssal Hunter{} Jokers.",
                        "{C:inactive,s:0.8}(Currently{} {X:mult,C:white,s:0.8}X#6#{} {C:inactive,s:0.8}Mult)",
                    }
                },
            },
            j_akts_Specter = {
                name = "Specter",
                text = {
                    {
                        "Scoring {C:attention}#3#s{} or higher give",
                        "{C:red}+#2#{} Mult and scoring {C:attention}#3#s{} or",
                        "lower give {C:blue}+#1#{} Chips."
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Specter the Unchained{}",
                        "when a Flush Five is played."
                    }
                },
            },
            j_akts_SpecterAlter = {
                name = "Specter the Unchained",
                text = {
                    {
                        "Scoring {C:attention}#3#s{} or higher give",
                        "{C:red}+#2#{} Mult and scoring {C:attention}#3#s{} or",
                        "lower give {C:blue}+#1#{} Chips."
                    },
                    {
                        "Prevents Death if",
                        "hand contains a scoring {C:attention}#3#{},",
                        "then each scoring card",
                        "gives {X:mult,C:white}X#5#{} Mult.",
                        "{C:inactive}(Once only, #4# left.)"
                    }
                },
            },
            j_akts_Andreana = {
                name = "Andreana",
                text = {
                    {
                        "Earns {C:money}$#1#{} and gains",
                        "{C:blue}+#2#{} Chips if less than",
                        "{C:attention}#3#%{} of blind requirement",
                        "is fulfilled.",
                        "{C:inactive}(Currently {}{C:blue}+#4# {C:inactive}Chips){}",
                    }
                },
            },

            j_akts_Lumen = {
                name = "Lumen",
                text = {
                    {
                        "{C:attention}Ammo{} {C:inactive}[#1#]{}: {C:attention}Removes{} debuffs",
                        "from the {C:attention}#5#{} leftmost",
                        "debuffed cards in played",
                        "hand, then enhances them",
                        "to {C:attention}temporary Steel Cards{}",
                    },
                    {
                        "Gains {C:blue}+#3#{} Chips each",
                        "time a {C:attention}Steel{} or",
                        "{C:attention}Gold Card is scored.",
                        "{C:inactive}(Currently {}{C:blue}+#4# {C:inactive}Chips){}",
                    },
                    --[[
                    {
                        "{C:attention} Temporary Steel Cards{}",
                        "gain an additional trigger",
                        "after being {C:attention}scored.",
                        "{C:inactive}(Max. #2#)"
                    },
                    ]]
                },
            },

            j_akts_Glaucus = {
                name = "Glaucus",
                text = {
                    {
                        "Each {C:attention}Gold{} or {C:attention}Steel{} Card held in hand ",
                        "has a {C:green}#1# in #2#{} chance to be",
                        "unenhanced at {C:attention}end of round{}.",
                        "Gives {C:money}$#3#{} and gains {X:mult,C:white}X#4#{} Mult",
                        "for {C:attention}each card{} unenhanced this way.",
                        "{C:inactive}(Currently{} {X:mult,C:white}X#5#{} {C:inactive}Mult)"
                    },
                },
            },

            j_akts_NearlRadiant = {
                name = "Nearl the Radiant Knight",
                text = {
                    {
                        "Enhances leftmost scored card",
                        "to {C:attention}True{} card if poker hand",
                        "contains both a {C:attention}Straight{}",
                        "and a {C:attention}King{}.",
                        "Creates a {C:spectral}Nearl the Radiant Knight{}",
                        "Summon when sold.",
                        "{C:inactive,s:0.8}(Must have room)"
                    }
                },
            },
            j_akts_Mlynar = {
                name = "Mlynar",
                text = {
                    {
                        "Transforms into {C:spectral}Mlynar (Active){}",
                        "for {C:attention}#1#{} hands during",
                        "the {C:attention}final hand of a round{} if",
                        "less than {C:attention}#2#%{} of",
                        "Blind Requirement has been met."
                    }
                },
            },
            j_akts_MlynarActive = {
                name = "Mlynar (Active)",
                text = {
                    {
                        "Reduces Blind Requirement by",
                        "{C:attention}#1#%{} per scored card,",
                        "plus an additional {C:attention}#2#%{} if",
                        "scored card is {C:attention}True Card{},",
                        "plus an additional {C:attention}#3#%{}",
                        "during {C:attention}final hand{} of a round."
                    },
                    {
                        "{C:inactive}Reverts into Mlynar{}",
                        "{C:inactive}in{} {C:attention}#4#{}{C:inactive} hand(s).",
                    }
                },
            },

            j_akts_Gravel = {
                name = "Gravel",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "Each scored card gives {C:chips}+#1#{} chips",
                        "if the {C:attention}combined{} ranks of all",
                        "scored cards is {C:attention}#2# or less{}.",
                    },
                    {
                        "{C:attention}+#3#{} hand size until {C:attention}first hand{} is",
                        "played after obtaining this Joker.",
                    }
                },
            },

            j_akts_Flametail = {
                name = "Flametail",
                text = {
                    {
                        "{C:green}#6# in #5#{} chance to",
                        "gain {C:dark_edition}Negative{} when obtained.",
                        "{C:inactive,s:0.8}(Likelihood is doubled if you{}",
                        "{C:inactive,s:0.8} own a {}{C:red,s:0.8}Kazimierz{} {C:inactive,s:0.8}Joker.)",
                    },
                    {
                        "{C:green}#1# in #2#{} chance to",
                        "gain {C:money}$#3#{} and {C:red}+#4# discards{}",
                        "when discarding cards.",
                        "{C:inactive,s:0.8}(Likelihood increases each{}",
                        "{C:inactive,s:0.8}time this effect does not",
                        "{C:inactive,s:0.8}trigger and resets when triggered.)"
                    }
                },
            },
            j_akts_Fartooth = {
                name = "Fartooth",
                text = {
                    {
                        "Gives {C:red}+ Mult{} equal to",
                        "{C:attention}#1#{} times the difference",
                        "between highest and lowest",
                        "ranked card held in hand.",
                        "{C:inactive,s:0.8}(Factor increases based on{}",
                        "{C:inactive,s:0.8}number of {}{C:red,s:0.8}Pinus Sylvestris{}",
                        "{C:inactive,s:0.8}Jokers owned.){}"
                    },
                    {
                        "Creates a {C:purple}Tarot Card{}",
                        "at end of round if all",
                        "cards held in hand have",
                        "{C:attention}different ranks.",
                    }
                },
            },

            j_akts_Ebenholz = {
                name = "Ebenholz",
                text = {
                    {
                        "Gives {X:mult,C:white}X#1#{} Mult if",
                        "blind requirement has not",
                        "been met, otherwise",
                        "{C:attention}stores{} that Mult. {C:inactive}(Max. #2# times){}",
                        "{C:inactive}(Currently{} {C:green}#3#{} {C:inactive}stored){}",
                    },
                    {
                        "During {C:attention}Small Blind{} or",
                        "{C:attention}Big Blind{}, automatically",
                        "{C:attention}stores{} {C:mult}Mult{} instead of",
                        "giving {C:mult}Mult{} if hand",
                        "contains {C:attention}no{} scoring",
                        "{C:attention}face cards."
                    }
                },
            },

            j_akts_Tomimi = {
                name = "Tomimi",
                text = {
                    {
                        "Gives {C:blue}+#1#{} Chips while in the",
                        "{C:attention}left half{} of all owned Joker Slots",
                        "and {C:red}+#2#{} Mult while in the {C:attention}right half.",
                        "{C:inactive,s:0.8}(Counts as left if Joker is in the middle.)"
                    },
                    {
                        "Randomly applies {C:attention}1{} of the",
                        "following when {C:attention}hand is played{}:",
                        "{X:attention,C:white}1{} : Enhances leftmost unenhanced ",
                        "card in played hand to {C:attention}Wild Card{}.",
                        "{X:attention,C:white}2{} : This Joker's other effect    ",
                        "gains {C:blue}+#3#{} Chips and {C:red}+#4#{} Mult.",
                        "{X:attention,C:white}3{} : Every played card permanently",
                        "gains {C:blue}+#5#{} Chips when scored."
                    }
                },
            },
            j_akts_Pepe = {
                name = "Pepe",
                text = {
                    {
                        "If the card in the {C:attention}center{} of",
                        "played hand is {C:attention}enhanced{},",
                        "Apply its effect as an {C:attention}AoE{}.",
                        "{C:inactive,s:0.8}(If possible)",
                        "The {C:attention}AoE{} applies to the",
                        "full hand instead if this effect",
                        "applies on {C:attention}consecutive hands{}.",
                        "{C:inactive,s:0.8}(AoE efficacy is reduced to {C:attention,s:0.8}#1#%{}",
                        "{C:inactive,s:0.8} for cards in first and last position.)"
                    }
                },
            },

            j_akts_Spuria = {
                name = "Spuria",
                text = {
                    {
                        "{X:tarot,C:white,s:1.25}Geek",
                        "Retriggers {C:attention}all scored cards{}.",
                        "Retriggers them {C:attention}an additional time{}",
                        "for each {C:green}Sniper{} Joker owned",
                        "{C:inactive} (Currently{C:green} #1#{}{C:inactive} owned)",
                    },
                    {
                        "Played cards have a {C:green}#5# in #2#{} chance",
                        "to be {C:attention}debuffed{}."
                    },
                    {
                        "{C:green}#5# in #4#{} chance to gain",
                        "{C:blue}-#3#{} hands when a card is scored."
                    },
                },
            },
            j_akts_Lemuen = {
                name = "Lemuen",
                text = {
                    {
                        "{C:attention}Ammo{} {C:inactive}[#1#]{}: If played hand's level",
                        "is {C:attention}#2# or higher{}, retrigger",
                        "{C:attention}first{} scored card {C:attention}once{} for each",
                        "{C:attention}level of hand{}, then {C:attention}destroy{}",
                        "that card, set hand's level to {C:attention}1{} ",
                        "and create {C:attention}#3#{} {C:dark_edition}Negative{} copies",
                        "of a random {C:planet}Planet{} card",
                        "with {C:money}$#4#{} sell value.",
                        "{C:inactive,s:0.8}(Doubles the amount of retriggers if",
                        "{C:inactive,s:0.8}hand is {}{C:attention,s:0.8}Straight{}{C:inactive,s:0.8} or better",
                        "{C:inactive,s:0.8}and triples them if hand is",
                        "{C:attention,s:0.8}Straight Flush{} {C:inactive,s:0.8}or better.)",
                    },
                },
            },
            j_akts_Fiametta = {
                name = "Fiametta",
                text = {
                    {
                        "{X:tarot,C:white,s:1.25}Geek",
                        "The card in the {C:attention}center{} of",
                        "scored hand gives {X:mult,C:white}X#1#{} {C:attention}AoE{} Mult.",
                        "{C:inactive,s:0.8}(Effect is doubled while this{}",
                        "{C:inactive,s:0.8}Joker has more than {}{C:attention,s:0.8}$#2#{} {C:inactive,s:0.8}sell value.)"
                    },
                },
            },

            j_akts_Executor = {
                name = "Executor",
                text = {
                    {
                        "Enhances rightmost unenhanced",
                        "scored card to {C:attention}Glass Card{}",
                        "until after scoring if poker hand",
                        "is a {C:attention}Three of a Kind{}",
                        "{C:green}#1# in #2#{} chance for this effect",
                        "to enhance {C:attention}two{} cards instead.",
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Executor the Ex Foedere{}",
                        "after using 1 each of",
                        "{C:tarot}Justice, Judgement{} and {C:tarot}Emperor{}",
                        "Tarot cards. {C:inactive}(#3# of 3 used.)"
                    }
                },
            },

            j_akts_ExecutorAlter = {
                name = "Executor the Ex Foedere",
                text = {
                    {
                        "{C:attention}Ammo{} {C:inactive}[#1#]{}: When a {C:attention}Glass Card{} is",
                        "destroyed while scoring, each",
                        "other scoring card permanently",
                        "gains {C:mult}+#3#{} Mult when scored."
                    },
                    {
                        "Enhances rightmost unenhanced",
                        "scored card to {C:attention}Glass Card{}",
                        "until after scoring if poker hand",
                        "is a {C:attention}Three/Four/Five of a Kind{}",
                        "{C:green}#4#%{} chance for this effect",
                        "to enhance {C:attention}all{} scored cards instead.",
                        "{C:inactive,s:0.8}(Chance increases by {}{C:green,s:0.8}#5#%{} {C:inactive,s:0.8}each time",
                        "{C:inactive,s:0.8} ammo is used.)"
                    }
                },
            },

            j_akts_Surfer = {
                name = "Surfer",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "Earns {C:money}$#1#{} when obtained if",
                        "you own {C:attention}less than #2# Jokers.",
                    },
                    {
                        "Reduces {C:attention}Blind Requirement",
                        "by {C:attention}#3#%{} for every hand played",
                        "this round when a hand is played.",
                    },
                },
            },

            j_akts_Astgenne = {
                name = "Astgenne",
                text = {
                    {
                        "Gains {C:mult}+#1#{} Mult if the {C:attention}leftmost",
                        "{C:attention}scored card{} is {C:attention}enhanced{},",
                        "then gains {C:mult}+#2#{} Mult if the {C:attention}second",
                        "{C:attention}scored card{} has the {C:attention}same enhancement{},",
                        "then gains {C:mult}+#3#{} Mult if the {C:attention}third",
                        "{C:attention}scored card{} has the {C:attention}same enhancement{}.",
                        "{C:inactive,s:0.8}(Currently {}{C:mult,s:0.8}+#4#{}{C:inactive,s:0.8} Mult)"
                    },
                },
            },
            j_akts_Saria = {
                name = "Saria",
                text = {
                    {
                        "All {C:planet}Planet{} cards held in hand",
                        "gain {C:dark_edition}Negative{}.",
                    },
                    {
                        "Gives {C:mult}Mult{} equal to double the amount",
                        "of Mult on all {C:planet}Planet{} cards",
                        "held in hand.",
                        "{C:inactive}(Currently {}{C:red}+#2#{} {C:inactive}Mult)"
                    },
                    {
                        "{C:attention}Heals{} all Jokers by {C:green}#1#",
                        "at {C:attention}end of round{}.",
                    },
                },
            },

            j_akts_Silence = {
                name = "Silence",
                text = {
                    {
                        "{C:attention}Retriggers{} the first activated {C:green}Medic",
                        "or {C:red}Rhine Lab{} Joker each hand if you",
                        "have {C:attention}#1# or more {}{C:planet}Planet{} cards."
                    },
                    {
                        "{C:attention}Heals{} the Joker with the most",
                        "lost sell value by {C:green}#2# {}at {C:attention}end of round{}.",
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Silence the Paradigmatic{}",
                        "at {C:attention}end of round{} after this",
                        "Joker has {C:attention}healed{} a",
                        "total of{C:money} $#3# {}sell value.{C:inactive} [#4#]"
                    },
                },
            },

            j_akts_SilenceAlter = {
                name = "Silence the Paradigmatic",
                text = {
                    {
                        "{C:attention}Retriggers{} the first activated ",
                        "{C:green}Medic, Supporter{} or {C:red}Rhine Lab{}",
                        "Joker each hand.",
                    },
                    {
                        "{C:attention}Heals{} the Joker with the most",
                        "lost sell value by {C:green}#1# {}when {C:attention}hand is played{}.",
                        "Gains {C:chips}+#2#{} Chips for every",
                        "{C:money}${} this Joker {C:attention}overheals{}.",
                        "{C:inactive}(Currently {}{C:chips}+#3#{}{C:inactive} Chips){}"
                    },
                    {
                        "If a {C:dark_edition}non-Negative{} Joker is {C:attention}debuffed{},",
                        "removes that debuff when hand is played, also",
                        "that Joker {C:attention}cannot be debuffed{} until the",
                        "{C:attention}end of the Ante{} and becomes {C:dark_edition}Polychrome{}.",
                        "{C:inactive}(Once only, #4# left)"
                    },
                },
            },

            j_akts_Ifrit = {
                name = "Ifrit",
                text = {
                    {
                        "{C:mult}+#1#{} Mult and {C:attention}+#1#{} {C:red}Burn Elemental Injury{}",
                        "for each {C:attention}Straight{} or {C:attention}Straight Flush",
                        "played this run. {C:inactive}(Currently {C:red}+#3#{}{C:inactive})",
                    },
                    {
                        "If you play a {C:attention}Straight Flush{} while",
                        "the blind is under the effect ",
                        "of a {C:red}Burn Elemental Burst{},",
                        "increases this Joker's",
                        "{C:attention}other effect's{} values by {C:attention}#4#{}."
                    },
                    {
                        "#5#",
                    },
                },
            },

            j_akts_Provence = {
                name = "Provence",
                text = {
                    {
                        "{C:chips}+#1#{} Chips for every",
                        "{C:attention}#2#% of Blind Requirement{} beaten.",
                        "{C:green}#3# in #4#{} chance to give {C:attention}double{}",
                        "the amount of Chips.",
                        "{C:inactive}Changes to {}{C:green}#3# in #5#{}{C:inactive} if you own",
                        "{C:attention}#6#+{} {C:red}#7#{} {C:inactive}and/or{} {C:red}#8# {}{C:inactive}Jokers.",
                    },
                },
            },

            j_akts_Vulpisfoglia = {
                name = "Vulpisfoglia",
                text = {
                    {
                        "Earn an extra {C:money}$#1#{} of {C:attention}interest{} for",
                        "every {C:money}$#2#{} you have at end of round",
                    },
                    {
                        "Gives {C:chips}+#4#{} Chips if played hand",
                        "contains exactly {C:attention}#3#{} scoring cards.",
                        "{C:inactive,s:0.8}(Reduces by 1 each time this effect",
                        "{C:inactive,s:0.8}triggers and resets at 0.)",
                        "If this effect triggers when {C:attention}1{} card",
                        "{C:attention}is scored{}, also earns {C:money}$#5#{}",
                        "and gives {C:mult}+#6#{} Mult."
                    },
                },
            },

            j_akts_Utage = {
                name = "Utage",
                text = {
                    {
                        "If this Joker's {C:attention}sell value{} is higher",
                        "than {C:money}$#1#{}, it becomes {C:money}$#1#{}",
                        "when {C:attention}Blind is selected.",
                        "Earns {C:money}$1{} for each {C:money}${} of {C:attention}sell value",
                        "lost this way.",
                    },
                    {
                        "{C:mult}+#2#{} Mult for each {C:money}${} of {C:attention}sell value",
                        "that is missing from all owned Jokers.",
                        "{C:inactive,s:0.8}(Currently{} {C:mult,s:0.8}+#3#{}{C:inactive,s:0.8} Mult)"
                    }
                },
            },
            
            j_akts_Kichisei = {
                name = "Kichisei",
                text = {
                    {
                        "{C:chips}+#1#{} Chips for each {C:attention}suit{} that scored ",
                        "a {C:attention}Flush{} this round.",
                        "{C:inactive,s:0.8}(Currently{} {C:chips,s:0.8}+#2#{}{C:inactive,s:0.8} Chips)",
                    }
                },
            },

            j_akts_Leizi = {
                name = "Leizi",
                text = {
                    {
                        "If the card to the {C:attention}right{} of a {C:attention}scored",
                        "{C:attention}enhanced card{} is unenhanced, {C:attention}move{}",
                        "that enhancement to card to the right.",
                        "{C:inactive}(Triggers up to twice per hand){}",
                    },
                    {
                        "Transforms into",
                        "{C:spectral}Leizi the Thunderbringer{}",
                        "after this effect triggers {C:attention}#1#{} {C:inactive}[#2#]{} times.",
                    }
                },
            },

            j_akts_SwireAlter = {
                name = "Swire the Elegant Wit",
                text = {
                    {
                        "{X:money,C:white,s:1.25}Merchant",
                        "Can spend {C:money}$#1#{} to destroy {C:attention}1{}",
                        "selected card. {C:inactive}(Doubles cost when applied",
                        "{C:inactive}and resets at end of round)"
                    },
                    {
                        "Gives {C:mult}Mult{} equal to the {C:attention}total{} amount",
                        "this Joker's Rental Tag spent and",
                        "the amount of {C:money}money{} this Joker's",
                        "other ability spent {C:attention}this round{}.",
                        "{C:inactive,s:0.8}(Currently{} {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Mult)"
                    }
                },
            },

            j_akts_Conviction = {
                name = "Conviction",
                text = {
                    {
                        "{C:mult}+#1#{} Mult",
                        "{C:green}#2# in #4#{} chance to give {C:mult}+#5#{} Mult instead"
                    },
                    {
                        "{C:green}#2# in #3#{} chance to be debuffed",
                        "until {C:attention}start of next round{} when",
                        "{C:attention}Blind{} is selected"
                    }
                },
            },

            j_akts_Cement = {
                name = "Cement",
                text = {
                    {
                        "{C:blue}+#1#{} Chips",
                        "{C:blue}-#2#{} Chips each time a card is scored.",
                        "{C:inactive}(Resets at end of round){}",
                    },
                    {
                        "{C:inactive}This Jokers values are ",
                        "{C:inactive}doubled in {}{C:green}#3#{} {C:inactive}rounds.{}",
                    }
                },
            },

            j_akts_Warmy = {
                name = "Warmy",
                text = {
                    {
                        "{C:attention}Doubles{} the first effect of",
                        "{C:red}Burn Elemental Burst{}."
                    },
                    {
                        "{C:attention}+#1#{} {C:red}Burn Elemental Injury{}",
                        "each hand played.",
                        "{C:inactive,s:0.8}(Changes to{} {C:attention,s:0.8}+#2#{}{C:inactive,s:0.8} if a {C:red,s:0.8}Burn Elemental Burst{}",
                        "{C:inactive,s:0.8} did not trigger last round.)"
                    },
                    {
                        "{X:mult,C:white}X#3#{} Mult if the Blind is under the",
                        "effect of a {C:red}Burn Elemental Burst{},",
                    },
                    {
                        "#4#",
                    },
                },
            },

            j_akts_Phantom = {
                name = "Phantom",
                text = {
                    {
                        "{X:attention,C:white,s:1.25}Fast Redeploy",
                        "Creates a {C:spectral}Clone{} Summon",
                        "when obtained or when",
                        "{C:tarot}Death Tarot Card{} is used. {C:inactive}(Max. #1#){}",
                        "{C:inactive,s:0.8}(Must have room)",
                    },
                    {
                        "Gives between {X:chips,C:white}X#2#{} and {X:chips,C:white}X#3#{} Chips",
                        "during {C:attention}first hand{} after this",
                        "Joker is obtained or a {C:spectral}Clone{} Summon",
                        "is used.",
                    }
                },
            },

            j_akts_Goldenglow = {
                name = "Goldenglow",
                text = {
                    {
                        "Each card {C:attention}held in hand{} gives",
                        "Chips {C:chips}equal to its rank{}.",
                    },
                    {
                        "Each card has a {C:green}#1# in #2#{} chance",
                        "to be destroyed and give",
                        "Chips {C:chips}equal to #3# times",
                        "{C:chips}its rank{} instead.",
                    }
                },
            },

            j_akts_Saileach = {
                name = "Saileach",
                text = {
                    {
                        "Creates a {C:dark_edition}Negative{} {C:attention}Eternal{}",
                        "{C:spectral}Banner{} when obtained.",
                    },
                    {
                        "When playing hand with {C:attention}0{} discards",
                        "remaining, {C:attention}debuffs{} leftmost undebuffed",
                        "{C:spectral}Banner{} until End of Ante, then",
                        "this Joker gives {C:money}$#1#{} and {C:chips}+#2#{} chips",
                        "each time a Joker triggers or a card is",
                        "scored this hand. {C:inactive}(except itself){}"
                    },
                    {
                        "Removes 1 {C:dark_edition}Negative{} {C:attention}Eternal{} {C:spectral}Banner",
                        "from Jokers when sold or destroyed."
                    }
                },
            },

            j_akts_Rockrock = {
                name = "Rockrock",
                text = {
                    {
                        "Each card in your {C:attention}most played",
                        "{C:attention}hand{} gives {C:red}+#2#{} Mult when scored.",
                        ""
                    },
                    {
                        "{X:red,C:white}Overload:{} Until the end of this",
                        "round or until this ability is cancelled,",
                        "each card in your {C:attention}most played",
                        "{C:attention} hand{} gives {C:red}Mult{} equal to the number",
                        "of times that {C:attention}poker hand{} has",
                        "been played this run.",
                        "This Joker is {C:attention}disabled{} for 1 hand for",
                        "every hand played while {X:red,C:white}Overload{} was",
                        "active afterwards {C:inactive}[#1#]{}",
                    },
                },
            },

            j_akts_Necrass = {
                name = "Necrass",
                text = {
                    {
                        "{C:attention}Destroys{} debuffed Jokers ",
                        "when {C:attention}hand is played{}.",
                    },
                    {
                        "Creates a {C:dark_edition}Negative{}", 
                        "{C:spectral}Servant of Lamentation{} when", 
                        "a Joker is {C:attention}destroyed",
                        "or a {C:attention}Blind{} is defeated. {C:inactive}(Max. 2)",
                        "Upgrades the {C:attention}least upgraded",
                        "{C:spectral}Servant of Lamentation{} instead",
                        "if you own {C:attention}#1#{} {C:spectral}Servants of Lamentation{}"
                    }
                },
            },

            j_akts_ServantLesser = {
                name = "Servant of Lamentation",
                text = {
                    {
                        "This Joker has been upgraded {C:attention}#5#{} times.",
                        "{C:attention}Eternal{}, but destroys itself if",
                        "you dont own a {C:spectral}Necrass Joker{}.",
                    },
                    {
                        "If you own another {C:spectral}Servant of Lamentation{}",
                        "that has been upgraded {C:attention}#7# times",
                        "{C:attention}fuses{} into a {C:spectral}Special Form{} with it.",
                    },
                    {
                        "{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult.",
                        "{X:attention,C:white}Upgrade 1:{} {C:chips}+#3#{} Chips for every",
                        "Joker destroyed by a {C:spectral}Necrass{}",
                        "Joker this run. {C:inactive}(Currently {C:chips}+#4#{}{C:inactive} Chips)",
                    },
                    {
                        "{X:attention,C:white}Upgrade 2:{} Earn {C:money}$#6#{} when",
                        "another Joker is {C:attention}destroyed{}.",
                    },
                },
            },

            j_akts_ServantGreater = {
                name = "Greater Servant of Lamentation",
                text = {
                    {
                        "This Joker has been upgraded {C:attention}#4#{} times.",
                        "Can be upgraded {C:attention}infinitely{}.",
                        "{C:attention}Eternal{}, but destroys itself if",
                        "you dont own a {C:spectral}Necrass{} Joker.",
                    },
                    {
                        "{X:chips,C:white}X#1#{} Chips and {X:mult,C:white}X#2#{} Mult.",
                        "Gains {X:chips,C:white}X#3#{} Chips each time",
                        "this Joker is upgraded",
                        "by a {C:spectral}Necrass{} Joker.",
                    },
                    {
                        "Creates a {C:attention}debuffed{} {C:dark_edition}Negative{}",
                        "{C:spectral}Joker{} at end of round",
                        "after this Joker has been upgraded {C:attention}#5# times{}."
                    }
                },
            },

            j_akts_Walter = {
                name = "Wis'adel",
                text = {
                    {
                        "Enhances {C:attention}#1#{} random cards in",
                        "Deck to {C:attention}Revenant Cards{} when",
                        "Blind is selected.",
                    },
                    {
                        "Applies {C:chips}Chips{} from hands played",
                        "that contain {C:attention}Revenant Cards{} to each",
                        "blind of the ante.",
                    },
                    {
                        "{X:red,C:white}Overload:{} Enhances up to {C:attention}#2#{} random",
                        "unenhanced cards held in hand",
                        "to undebuffable {C:attention}Revenant Cards{},",
                        "but enhances {C:attention}#3#{} less card to",
                        "{C:attention}Revenant Card{} next round"
                    }
                },
            },
        },
        SummonConsumableType = {
            c_akts_Mon3tr = {
                name = "Mon3tr", --name of card
                text = { --text of card
                    "Enhances up to {C:attention}#1#{} selected",
                    "cards to {C:attention}True Cards{}",
                    "If card is already {C:attention}True{},",
                    "add {C:blue}20{} Chips to it."
                },
            },
            c_akts_NearlTheRadiant = {
                name = "Nearl the Radiant Knight", --name of card
                text = { --text of card
                    {
                        "Gives {X:mult,C:white}X#1#{} Mult and lose {C:money}$#2#{} when",
                        "{C:attention}True Cards{} are in scored hand",
                        "while held in hand."
                    },
                    {
                        "Destroys itself and creates a",
                        "{C:spectral}Nearl the Radiant Knight{} Joker",
                        "when playing hand with less",
                        "than {C:money}$#2#{} or when used.",
                        "{C:inactive,s:0.8}(Must have room)"
                    }
                },
            },
            c_akts_Clone = {
                name = "Clone",
                text = { 
                    {
                        "Your {C:attention}last played hand",
                        "gains {C:chips}+#1#{} Chips.",
                        "{C:attention}Decreases{} by {C:chips}#2#{} for every",
                        "{C:spectral}Clone{} Summon used.",
                        "{C:attention}Increases{} by {C:chips}#3#{} for every",
                        "{C:spectral}Clone{} Summon sold. {C:inactive}(Max. #4#)",
                        "{C:inactive}Last played hand:{C:green} #5#"
                    },
                },
            },
        },
        Enhanced = {
            m_akts_True = {
                name = "True",
                text = {
                    "{C:blue}+#1#{} extra Chips",
                    "and {C:red}+#2#{} Mult.",
                    "Card cannot be debuffed."
                }
            },
            m_akts_Hook = {
                name = "Hooked Card",
                text = {
                    "Transforms card",
                    "to the {C:attention}left{} of this",
                    "card into {C:attention}this card{}",
                    "when scored during",
                    "{C:attention}first hand of round.{}"
                },
            },
            m_akts_TempSteel = {
                name = "Temporary Steel Card",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "while this card",
                    "stays in hand",
                    "Unenhances self",
                    "after this effect",
                    "triggers {C:attention}#2#{} times."
                },
            },
            m_akts_BloodAmber = {
                name = "Blood Amber",
                text = {
                    "{C:blue}#1#{} Chips",
                    "no rank or suit",
                    "{C:attention}Destroys{} self after being played."
                }
            },
            m_akts_Revenant = {
                name = "Revenant Card",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "Can be used as any suit.",
                    "Reverts at end of round."
                }
            },
        },  
        Blind = {
            bl_akts_renegade = {
                name = "The Renegade",
                text = {
                    "{C:attention}Destroys{} all cards",
                    "in winning hand."
                },
            },
            bl_akts_singer = {
                name = "The Singer",
                text = {
                    "All Jokers lose {C:attention}$#1#{} Sell Value",
                    "each hand. Debuffs all Jokers with",
                    "{C:attention}$0{} Sell Value"
                },
            },
            bl_akts_patriot = {
                name = "The Patriot",
                text = {
                    "{C:chips}-#1#{} Base Chips",
                },
            },
            bl_akts_sanguinarch = {
                name = "The Sanguinarch",
                text = {
                    "Adds {C:attention}20{} {C:red}Blood Ambers{} to",
                    "Deck. Removes {C:attention}5{} {C:red}Blood Ambers{}",
                    "from Deck for each remaining hand",
                    "after Blind is {C:attention}defeated."
                },
            },
            bl_akts_source_code = {
                name = "The Source Code",
                text = {
                    "Every {C:attention}second{} Play/Discard",
                    "is {C:red}out of your control.",
                },
            },
            bl_akts_carnevale = {
                name = "The Carnevale",
                text = {
                    "{C:attention}Doubles{} Blind Payout if",
                    "score catches fire. {C:money}$0{} otherwise",
                },
            },
        },
        Other = {
            ---info queue popups------
            ChipDebt = {
                name = "Chip Debt",
                text = {
                    "Pay off {C:attention}5%{} of ",
                    "{C:red}total debt{} each time",
                    "cards are drawn.",
                    "Any chips {C:attention}past the",
                    "{C:attention}blind requirement{} are",
                    "used to pay off the debt."            
                },
            },
            StoredMult = {
                name = "Stored Mult",
                text = {
                    "{C:red}Expends{} all",
                    "{C:attention}stored charges{} when",
                    "the Joker gives Mult."
                },
            },
            AoEHit = {
                name = "AoE",
                text = {
                    "Affects cards to the",
                    "{C:attention}left{} and {C:attention}right{} of",
                    "named card, at",
                    "{C:attention}50%{} efficacy."
                },
            },
            elementalInjury = {
                name = "Elemental Injury",
                text = {
                    "Triggers an {C:attention}Elemental Burst{}",
                    "on current blind when",
                    "Elemental Injury reaches {C:attention}100{}.", 
                },
            },
            burnBurst = {
                name = "Elemental Burst (Burn)",
                text = {
                    "Immediately adds {C:attention}10%{} of",
                    "required chips to score.",
                    "All Jokers give",
                    "{X:mult,C:white}X1.2{} more mult."
                },
            },
            Heal = {
                name = "Heal",
                text = {
                    "If the targeted Joker's {C:attention}sell value",
                    "is {C:attention}less than{} their default {C:attention}sell value{},",
                    "{C:attention}increases{} their sell value by the",
                    "specified amount.",
                },
            },

            Overload = {
                name = "Overload",
                text = {
                    "Can be used {C:attention}once per Ante{},",
                    "during a {C:attention}Blind"
                },
            },
            --------Joker Subclasses---------------
            Geek = {
                name = "Geek",
                text = {
                    "Has increased sell value.",
                    "Loses {C:money}$1{} of sell value after",
                    "hand is played.",
                    "{C:attention}Debuffs{} self at {C:money}$0{} sell value."
                },
            },
            FastRedeploy = {
                name = "Fast Redeploy",
                text = {
                    "Can be sold for {C:money}$0{} to",
                    "create a {C:attention}Fast Redeploy{} Joker",
                    "if no other Jokers",
                    "have been sold this round.",
                },
            },
            Merchant = {
                name = "Merchant",
                text = {
                    "Always spawns with a",
                    "{C:attention}Rental Sticker",
                    "{C:attention}Destroys{} self when entering",
                    "shop while in {C:attention}debt{}."
                },
            },
            --------Packs---------------
            p_akts_redeploy_pack = {
                name = "Fast Redeploy Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {X:attention,C:white}Fast Redeploy{} Jokers",
                },
            },
            --------Other---------------
            edition_negative_consumable = {
                name = "Negative",
                text = {
                    "{C:dark_edition}+1{} consumable slot",
                },
            },
        },
        Tag = {
            tag_akts_redeploy_tag = {
                name = "Fast Redeploy Tag",
                text = {
                    "Creates a Fast Redeploy Pack.",
                }, 
            },
        },
    },
    misc = {
        dictionary = {
            k_akts_Vanguard = "Vanguard",
            k_akts_Guard = "Guard",
            k_akts_GuardMedic = "Guard/Medic",
            k_akts_GuardSniper = "Guard/Sniper",
            k_akts_Defender = "Defender",
            k_akts_Sniper = "Sniper",
            k_akts_Caster = "Caster",
            k_akts_CasterGuard = "Caster/Guard",
            k_akts_Supporter = "Supporter",
            k_akts_SupporterMedic = "Supporter/Medic",
            k_akts_Medic = "Medic",
            k_akts_Specialist = "Specialist",
            k_akts_SpecialistVanguard = "Specialist/Vanguard",
            k_akts_SpecialistGuard = "Specialist/Guard",

            k_akts_Rhodes = "Rhodes Island",
            k_akts_RhodesSargon = "Rhodes Island/Sargon",
            k_akts_EliteOpRhodes = "Elite Op/Rhodes Island",
            k_akts_EliteOpRhodesYan = "Elite Op/Rhodes Island/Yan",
            k_akts_Kazimierz = "Kazimierz",
            k_akts_PinusKazimierz = "Pinus Sylvestris/Kazimierz",
            k_akts_Abyssal = "Abyssal Hunter",
            k_akts_AbyssalAegir = "Abyssal Hunter/Aegir",
            k_akts_Iberia = "Iberia",
            k_akts_IberiaAegir = "Iberia/Aegir",
            k_akts_Leithanien = "Leithanien",
            k_akts_Sargon = "Sargon",
            k_akts_Laterano = "Laterano",
            k_akts_Columbia = "Columbia",
            k_akts_BlacksteelColumbia = "Blacksteel/Columbia",
            k_akts_RhineColumbia = "Rhine Lab/Columbia",
            k_akts_Siracusa = "Siracusa",
            k_akts_Higashi = "Higashi",
            k_akts_Yan = "Yan",
            k_akts_Minos = "Minos",
            k_akts_RimBil = "Rim Billiton",
            k_akts_Victoria = "Victoria",
            k_akts_Tara = "Tara",
            k_akts_Babel = "Babel",

            akts_plus_summon = "+1 Summon",
            akts_retreat = "RETREAT!",
            akts_AoE = "AoE!",
            akts_smeared_aoe = "Smeared!",
            akts_plus_Stored = "Stored!",
            akts_hp_down = "Health Down!",
            akts_no_hp = "No HP!",
            akts_merchant_bye = "NO DP!",
            akts_stunned = "Stunned!",
            akts_bind_apply = "Bound!",
            akts_downgrade = "Downgrade!",
            akts_crit = "Critical!",
            akts_heal = "Healed!",

            akts_transform = "Transform!",
            akts_transform_revert = "Reverted!",
            akts_transform_unchained = "UNCHAINED!",

            akts_plus_Mon3tr = "SCREEECH!",
            akts_gavial_edition = "Buffed!",
            akts_debt_payment = "Debt Payment!",
            akts_debt_free = "NO DEBT!",
            akts_gavial_win = "Soul of the Jungle!",
            akts_CE_Balance = "Reconstructed!",
            akts_logos_win = "PERISH!",
            akts_red_active = "Chill.",

            akts_plus_seaborn = "+1 Aegir",
            akts_tidal = "Tidal Elegy",

            akts_textRadiantC = "BLAZING SUN!",
            akts_textRadiantJ = "RADIANT!",
            akts_mlynar_score = "CUT!",
            akts_Dodged = "Dodged!",

            akts_double_trigger = "Double Trigger!",
            akts_fedex_spec = "Damnatus!",

            akts_surfer_score = "DEF Down!",

            akts_silence_immortal = "Immortal!",

            akts_saileach_banner = "For Glory!",

            akts_summon_greater = "Fused!",

            akts_Walter_Bang = "BANG!",

            akts_plus_hook = "Hooked!",

            k_akts_transformed = "Awoken",

            akts_current = "Current",
            akts_damage = "Damage", 
            akts_injury = "Elemental Injury", 
            akts_burst_active = "Burst is Active!",
            akts_burst_trigger = "Burst Activated!",
            akts_cancel = "Cancel",

            k_akts_redeploy_pack = "Fast Redeploy Pack",

            akts_blind_renegade = "BANG!",
            akts_blind_patriot = " times current ante",
            akts_jokers_only_config = "Balatrhodes Jokers only?",
        },
        labels = {
            k_akts_transformed = "Awoken",
        }
    }
    
}