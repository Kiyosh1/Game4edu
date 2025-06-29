extends Control

func _ready() -> void:
	for _button in get_tree().get_nodes_in_group("button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))

func _on_button_pressed(button: Button):
	match button.name:
		"back":
			get_tree().change_scene_to_file("res://Interface/main_menu/menu.tscn")
