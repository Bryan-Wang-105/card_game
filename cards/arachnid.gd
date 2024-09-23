extends CardObject

func _init():
	card_name = "ARACHNID"
	card_description = "Shrewd web weaver. \nENTANGLE: ?"
	card_unlock = "Entraps 1 creature into its web. Entrapped cards cannot interact for 1 turn"
	art_path = "res://cards/art/spider.png" 
	perk_path #= "res://Perks/" + rarity.to_lower() + "/" + perk_name + ".gd"
	health = 1
	attack = 2
	status = []


func apply(player, index):
	pass
	
func on_damage_received(dmg_amt):
	pass
	
func on_damage_given(dmg_amt):
	pass
