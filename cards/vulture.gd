extends CardObject

func _init():
	card_name = "VULTURE"
	card_description = "Foul winged scavenger \nFEAST: ?"
	card_unlock = "Enter the boneyard. Feast on cards that have perished this match to regain health"
	art_path = "res://cards/art/vulture.png"
	perk_path #= "res://Perks/" + rarity.to_lower() + "/" + perk_name + ".gd"
	health = 3
	attack = 2
	status = []


func apply(player, index):
	pass
	
func on_damage_received(dmg_amt):
	pass
	
func on_damage_given(dmg_amt):
	pass
