extends CardObject

func _init():
	card_name = "VIPER"
	card_description = "Noxious creature. \nSTRIKE: ?"
	card_unlock = "Poison targeted creature. Poisoned creatures take 1 dmg at EOT"
	art_path = "res://cards/art/snake.png" 
	perk_path #= "res://Perks/" + rarity.to_lower() + "/" + perk_name + ".gd"
	health = 2
	attack = 3
	status = []


func apply(player, index):
	pass
	
func on_damage_received(dmg_amt):
	pass
	
func on_damage_given(dmg_amt):
	pass
