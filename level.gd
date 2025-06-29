extends Node2D

func _ready():
	# Verifica se os botões existem antes de conectar
	var buttons = get_tree().get_nodes_in_group("button")
	if buttons.size() > 0:
		for button in buttons:
			if button is Button:
				button.pressed.connect(_on_button_pressed.bind(button))
			else:
				push_warning("Nó no grupo 'button' não é um Button: " + button.name)
	else:
		push_warning("Nenhum botão encontrado no grupo 'button'")

func _on_button_pressed(button: Button):
	match button.name:
		"voltar":
			var err = get_tree().change_scene_to_file("res://Interface/main_menu/menu.tscn")
			if err != OK:
				push_error("Falha ao mudar de cena: " + str(err))
		_:
			print("Botão pressionado: ", button.name)
