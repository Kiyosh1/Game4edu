extends Node2D
var simultaneous_scene = preload("res://scenes/vn.tscn").instantiate()

func on_button_pressed() -> void:
	GlobalValues.dialog_json_file_path = "res://assets/dialogs/1.json"
	print("test")
	get_tree().root.add_child(simultaneous_scene)
	pass # Replace with function body.
