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
			"name" : "Umbot Lanu",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 4,
			"effect" : "When this creature is summoned, draw 1 card. During an eclipse, add +1/+0 counter for every “Umbot” creature on your side of the field.",
		},
		"Umbot_Zuma" : {
			"name" : "Umbot Zuma",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, gain 1 energy. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},
		"Umbot_Plum" : {
			"name" : "Umbot Plum",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, gain 1 life. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Fisa" : {
			"name" : "Umbot Fisa",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, send the top card of your opponent’s deck to the graveyard. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Skal" : {
			"name" : "Umbot Skal",
			"type" : "Robotic",
			"top_counter" : "1",
			"bot_counter" : "1",
			"cost" : 3,
			"effect" : "When this creature is summoned, your opponent takes 1 damage. During an eclipse, add a +1/+0 counter for every “Umbot” creature on your side of the field.",
		},"Umbot_Champion_Vila" : {
			"name" : "Umbot Champion Vila",
			"type" : "Robotic",
			"top_counter" : "4",
			"bot_counter" : "3",
			"cost" : 12,
			"effect" : "Once per turn, you can discard 1 card to destroy 1 creature your opponent controls. During an eclipse, add a +2/+3 counter to this card.",
		},"Lunarbird_Eule" : {
			"name" : "Lunarbird Eule",
			"type" : "Dark",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is an eclipse, add a +0/+2 counter to this card. When this card is summoned, set the environment to eclipse.",
		},"Weatherbird_Sonnenfalke" : {
			"name" : "Weatherbird Sonnenfalke",
			"type" : "Fire",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is sunny, add a +0/+2 counter to this card. When this card is summoned, set the environment to sunny.",
		},
		"Weatherbird_Regengans" : {
			"name" : "Weatherbird Regengans",
			"type" : "Water",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is rainy, add a +0/+2 counter to this card. When this card is summoned, set the environment to rainy.",
		},
		"Weatherbird_Albatros" : {
			"name" : "Weatherbird Albatros",
			"type" : "Wind",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is windy, add a +0/+2 counter to this card. When this card is summoned, set the environment to windy.",
		},
		"Weatherbird_Geier" : {
			"name" : "Weatherbird Geier",
			"type" : "Earth",
			"top_counter" : "2",
			"bot_counter" : "2",
			"cost" : 6,
			"effect" : "When the environment is dusty, add a +0/+2 counter to this card. When this card is summoned, set the environment to dusty.",
		}, 
	},
	"Spells" : {
		"Counter" : {
			"name" : "Counter",
			"cost" : 4,
			"effect" : "Activate this spell in response to your opponent’s activation of a spell. Negate the activation of that spell."
		},
		"Umbot_Parade" : {
			"name" : "Umbot Parade",
			"cost" : 14,
			"effect" : "(Artifact Equivalent) Destroy this card if there is no eclipse. All “Umbot” creatures gain (Cascade Equivalent).",
		},
		"Umbot_Factory" : {
			"name" : "Umbot Factory",
			"cost" : 8,
			"effect" : "Add an “Umbot” creature from your deck to your hand."
		},
		"Clear_Weather" : {
			"name" : "Clear Weather",
			"cost" : 5,
			"effect" : "Set the Environment to Cloudy"
		},
	}
	
}
