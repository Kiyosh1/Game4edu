extends Node2D

@onready var container_btns = %VBoxContainer

# Dicionário de ícones por tipo
var type_icons = {
	"historia": preload("res://assets/btn_icons/book_icon.svg"),
	"quest": preload("res://assets/btn_icons/medal.svg"),
	"game": preload("res://assets/btn_icons/game_icon.svg"),
}

var buttons = [
	{"title": "Histórias", "type": "historia", "scene": "res://scenes/VisualNovel/Root_VN.tscn", "json_path": "res://scenes/VisualNovel/assets/dialogs/1.json"},
	{"title": "Missões", "type": "quest", "scene": "res://scenes/VisualNovel/Root_VN.tscn", "json_path": "res://scenes/VisualNovel/assets/dialogs/2.json"}
]

func _ready():
	create_buttons()
	
	# Conexão opcional para botões existentes
	var existing_buttons = get_tree().get_nodes_in_group("button")
	for button in existing_buttons:
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))

func create_buttons():
	# Limpa botões existentes
	for child in container_btns.get_children():
		child.queue_free()
	
	# Cria novos botões
	for btn_data in buttons:
		var new_button = Button.new()
		new_button.text = "  " + btn_data["title"]  # Espaço para o ícone
		new_button.name = btn_data["type"]
		
		# Configuração do estilo
		new_button.custom_minimum_size = Vector2(300, 60)
		new_button.add_theme_font_size_override("font_size", 24)
		#new_button.text_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# Adiciona ícone se existir para o tipo
		if type_icons.has(btn_data["type"]):
			var icon_texture = type_icons[btn_data["type"]]
			new_button.icon = icon_texture
			new_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# Conecta o sinal com todos os dados do botão
		new_button.pressed.connect(_on_dynamic_button_pressed.bind(btn_data))
		
		container_btns.add_child(new_button)

func _on_dynamic_button_pressed(btn_data: Dictionary):
	print("Botão pressionado: ", btn_data["title"])
	
	# Atualiza o caminho do JSON global
	GlobalValues.dialog_json_file_path = btn_data["json_path"]
	
	# Muda para a cena especificada
	var err = get_tree().change_scene_to_file(btn_data["scene"])
	if err != OK:
		push_error("Falha ao mudar de cena: " + str(err))

func _on_button_pressed(button: Button):
	match button.name:
		"voltar":
			var err = get_tree().change_scene_to_file("res://scenes/VisualNovel/Root_VN.tscn")
			if err != OK:
				push_error("Falha ao mudar de cena: " + str(err))
