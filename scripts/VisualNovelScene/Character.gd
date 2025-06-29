extends Node2D
@onready var sprite = $sprite

const CHARACTERS_FILES = {
	"robot_2":{
		"angry":preload("res://assets/Chars/robot_2/01.png"),
		"sad":preload("res://assets/Chars/robot_2/02.png"),
		"normal":preload("res://assets/Chars/robot_2/03.png"),
		"happy":preload("res://assets/Chars/robot_2/04.png")
	},
	"emi":{
		"angry":preload("res://assets/Chars/robot_2/01.png"),
		"sad":preload("res://assets/Chars/robot_2/02.png"),
		"normal":preload("res://assets/Chars/robot_2/03.png")
	},
	"chai":{
		"angry":preload("res://assets/Chars/robot_2/01.png"),
		"sad":preload("res://assets/Chars/robot_2/02.png"),
		"normal":preload("res://assets/Chars/robot_2/03.png")
	},
	"mei":{
		"angry":preload("res://assets/Chars/robot_2/01.png"),
		"sad":preload("res://assets/Chars/robot_2/02.png"),
		"normal":preload("res://assets/Chars/robot_2/03.png")
	}
}

func change_character(character:String, mood:String):
	sprite.texture = CHARACTERS_FILES[character][mood]

	
	
func _ready():
	pass
