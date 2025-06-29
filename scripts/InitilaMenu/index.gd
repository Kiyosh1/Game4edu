extends VBoxContainer

@onready var container = %Continer_BTN  # Certifique-se que este nó existe na cena

var buttons = [
	{ "text":"Rota 1", "screen":"aa", "enable": true},
	{ "text":"Rota 2", "screen":"bb", "enable": true},
	{ "text":"Rota 3", "screen":"cc", "enable": true},
	{ "text":"Rota 4", "screen":"dd", "enable": true},
]

const RotaBTN = preload("res://scenes/btn_rota.tscn")

func _ready() -> void:
	for btn in buttons:
		var btn_to_add = RotaBTN.instantiate()
		print(btn['text'])
		btn_to_add.text = btn['text']  # Corrigido: propriedade 'text' diretamente
		container.add_child(btn_to_add)  # Adiciona ao container, não à cena pré-carregada
		
		# Opcional: Conectar sinal pressed se necessário
		# btn_to_add.pressed.connect(_on_button_pressed.bind(btn['screen']))
