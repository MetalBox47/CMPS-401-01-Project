extends Node

# enum declares an array of constants
enum CREATURES {Umbot_Lanu, Umbot_Zuma, Umbot_Plum, Umbot_Fisa, Umbot_Skal, Umbot_Champion_Vila, Lunarbird_Eule, Weatherbird_Sonnenfalke, Weatherbird_Regengans, Weatherbird_Albatros, Weatherbird_Geier}
# CREATURES attributes = [name, type, top_counter, bot_counter, cost, effect]

enum SPELLS {Counter, Umbot_Parade, Umbot_Factory, Clear_Weather}
# SPELLS attributes = [name, cost, effect]

# You can access the keys with 'dot' syntax (DATA.Creatures) or 'bracket' syntax (DATA["Creatures"]
const DATA = {
	"Creatures" : {
		"Umbot_Lanu" : {
			"rarity" : "CommonCard",
			"name" : "Umbot Lanu",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 4,
			"effect" : "When this creature is summoned, draw 1 card. During an eclipse, add +1/+0 counter for every “Umbot” creature on your side of the field.",
		},
		"Umbot_Zuma" : {
			"rarity" : "CommonCard",
			"name" : "Umbot Zuma",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, gain 1 energy. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},
		"Umbot_Plum" : {
			"rarity" : "CommonCard",
			"name" : "Umbot Plum",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, gain 1 life. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Fisa" : {
			"rarity" : "CommonCard",
			"name" : "Umbot Fisa",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, send the top card of your opponent’s deck to the graveyard. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Skal" : {
			"rarity" : "CommonCard",
			"name" : "Umbot Skal",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, your opponent takes 1 damage. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Champion_Vila" : {
			"rarity" : "RareCard",
			"name" : "Umbot Champion Vila",
			"type" : "Robotic",
			"top_counter" : "4",
			"bot_counter" : "3",
			"cost" : 12,
			"effect" : "Once per turn, you can discard 1 card to destroy 1 creature your opponent controls. During an eclipse, add a +2/+3 counter to this card.",
		},"Lunarbird_Eule" : {
			"rarity" : "LegendaryCard",
			"name" : "Lunarbird Eule",
			"type" : "Dark",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is an eclipse, add a +0/+2 counter to this card. When this card is summoned, set the environment to eclipse.",
		},"Weatherbird_Sonnenfalke" : {
			"rarity" : "RareCard",
			"name" : "Weatherbird Sonnenfalke",
			"type" : "Fire",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is sunny, add a +0/+2 counter to this card. When this card is summoned, set the environment to sunny.",
		},
		"Weatherbird_Regengans" : {
			"rarity" : "RareCard",
			"name" : "Weatherbird Regengans",
			"type" : "Water",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is rainy, add a +0/+2 counter to this card. When this card is summoned, set the environment to rainy.",
		},
		"Weatherbird_Albatros" : {
			"rarity" : "RareCard",
			"name" : "Weatherbird Albatros",
			"type" : "Wind",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is windy, add a +0/+2 counter to this card. When this card is summoned, set the environment to windy.",
		},
		"Weatherbird_Geier" : {
			"rarity" : "RareCard",
			"name" : "Weatherbird Geier",
			"type" : "Earth",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is dusty, add a +0/+2 counter to this card. When this card is summoned, set the environment to dusty.",
		},
		"Chlorchestra_Blossoon" : {
			"rarity" : "CommonCard",
			"name" : "Chlorchestra Blossoon",
			"type" : "Earth",
			"top_counter" : "2",
			"bot_counter" : "3",
			"cost" : 6,
			"effect" : "Once per turn, if the environment is sunny, you can summon one Plant creature from your hand without paying its cost, but that creature becomes a 0/1.",
		}, 
		"Chlorchestra_Harpaster" : {
			"rarity" : "CommonCard",
			"name" : "Chlorchestra Harpaster",
			"type" : "Plant",
			"top_counter" : "1",
			"bot_counter" : "2",
			"cost" : 4,
			"effect" : "Once per turn, if the environment is sunny, you can summon 1 Bulb Token (0/1 Plant, no additional effect).",
		}, 
		"Chlorchestra_Timpaniris" : {
			"rarity" : "CommonCard",
			"name" : "Chlorchestra Timpaniris",
			"type" : "Plant",
			"top_counter" : "1",
			"bot_counter" : "2",
			"cost" : 4,
			"effect" : "Once per turn, if the environment is sunny, you can destroy one target creature.",
		},
		"Chlorchestra_Glorgan" : {
			"rarity" : "CommonCard",
			"name" : "Chlorchestra Glorgan",
			"type" : "Plant",
			"top_counter" : "1",
			"bot_counter" : "2",
			"cost" : 4,
			"effect" : "Once per turn, if the environment is sunny, you can discard 1 card from your opponent’s hand.",
		},
		"Chlorchestra_Trumpansy" : {
			"rarity" : "RareCard",
			"name" : "Chlorchestra Trumpansy",
			"type" : "Plant",
			"top_counter" : "1",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "Once per turn, if the environment is sunny, you can look at the top 3 cards of your deck; add 1 creature from those 3 cards to your hand and send the rest to the graveyard. If none were creatures, send all 3 to the graveyard.",
		},
		"Chlorchestra_Conductare" : {
			"rarity" : "RareCard",
			"name" : "Chlorchestra Timpaniris",
			"type" : "Earth",
			"top_counter" : "2",
			"bot_counter" : "3",
			"cost" : 10,
			"effect" : "When this card is summoned, add 1 “Clorchestra” creature from your deck to your hand.",
		},
		
	},
	"Spells" : {
		"Counter" : {
			"rarity" : "RareCard",
			"name" : "Counter",
			"cost" : 4,
			"effect" : "Activate this spell in response to your opponent’s activation of a spell. Negate the activation of that spell."
		},
		"Umbot_Parade" : {
			"rarity" : "SecretCard",
			"name" : "Umbot Parade",
			"cost" : 14,
			"effect" : "(Artifact Equivalent) Destroy this card if there is no eclipse. All “Umbot” creatures gain (Cascade Equivalent).",
		},
		"Umbot_Factory" : {
			"rarity" : "RareCard",
			"name" : "Umbot Factory",
			"cost" : 8,
			"effect" : "Add an “Umbot” creature from your deck to your hand."
		},
		"Clear_Weather" : {
			"rarity" : "LegendaryCard",
			"name" : "Clear Weather",
			"cost" : 5,
			"effect" : "Set the Environment to Cloudy."
		},
		"Compost" : {
			"rarity" : "CommonCard",
			"name" : "Compost",
			"cost" : 5,
			"effect" : "Sacrifice 1 creature you control; target Plant creature gains its Attack and HP."
		},
		"Connected_Roots" : {
			"rarity" : "LegendaryCard",
			"name" : "Connected Roots",
			"cost" : 15,
			"effect" : "The HP of each Plant creature you control becomes equal to the total HP of all Plant creatures you control."
		},
		"Chlorchestra_Rehearsal" : {
			"rarity" : "RareCard",
			"name" : "Chlorchestra Rehearsal",
			"cost" : 6,
			"effect" : "You can only activate this card if you control a “Chlorchestra” creature. Draw 2 cards and discard 1 card."
		},
		"Chlorchestra_Symphony" : {
			"rarity" : "SecretCard",
			"name" : "Chlorchestra_Symphony",
			"cost" : 20,
			"effect" : "You can only activate this card if you control at least 1 “Chlorchestra Blossoon”, “Chlorchestra Harpaster”, “Chlorchestra Timpaniris”, “Chlorchestra Glorgan”, “Chlorchestra Trumpansy”, and “Chlorchestra Conductare”. Destroy all cards your opponent controls."
		},
		"Copy_Machine" : {
			"rarity" : "RareCard",
			"name" : "Copy Machine",
			"cost" : 10,
			"effect" : "Create a 0/1 token with the same name and effect as a target Robotic creature you control."
		},
		"Bird_Call" : {
			"rarity" : "CommonCard",
			"name" : "Bird_Calle",
			"cost" : 10,
			"effect" : "Add 1 “Weatherbird” or “Lunarbird” creature from your deck to your hand.",
		},
		
	}
	
}
