extends Resource
class_name CardObject

var card_name: String
var card_description: String
var card_unlock: String
var art_path #= "res://Assets/perkPictures/PerkPics/" + perk_name + ".png" 
var perk_path #= "res://Perks/" + rarity.to_lower() + "/" + perk_name + ".gd"
var health
var attack
var status
