extends Node2D

@onready var character = %Char
@onready var dialog_ui = %DialogUi
@onready var backrground = %background
@onready var audioPlayer = %AudioStreamPlayer

var questions = 0
var questions_right = 0

const backgrounds = [
	preload("res://assets/backgrounds/Backstreet_Spring_Afternoon.png"),
	preload("res://assets/backgrounds/Backstreet_Spring_Cloudy.png"),
	preload("res://assets/backgrounds/Temple_Spring_Clouds.png"),
	preload("res://assets/backgrounds/Temple_Spring_Rain.png"),
]

var dialog_index = 0
var background = 3
var song = "sad"
var dialog_data
var dialogs = []
var processing_choice = false

func _ready():
	$AudioStreamPlayer.volume_db = -20
	dialog_data = load_dialogue("res://scenes/VisualNovel/assets/dialogs/V2.json")
	dialog_ui.choice_selected.connect(_on_choice_selected)
	
	var json_path = GlobalValues.dialog_json_file_path
	audioPlayer.play_sound("default")
	if json_path != "":
		load_dialogue(json_path)
	
	if dialogs.size() > 0:
		process_line()

func _input(event):

	if processing_choice:
		return
		
	if event.is_action_pressed("next_line"):
		print("next line")
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			print("next line afther")
			
			if dialog_index == dialogs.size() :
				print("final")
				get_tree().change_scene_to_file("res://level.tscn")
			elif dialog_index == dialogs.size() - 1 :
				if questions == 0:
					get_tree().change_scene_to_file("res://level.tscn")
				# Calcula porcentagem de acerto com proteção contra divisão por zero
				
				var percentual_acerto = 0.0
				if questions > 0:
					percentual_acerto = float(questions_right) / float(questions)
				
				# Constroi a mensagem de resultado
				var msg = "Você acertou " + str(questions_right) + "/" + str(questions) + "\n"
				
				# Adiciona avaliação com formatação condicional
				if questions == 0:
					msg += "[color=#aaaaaa]Nenhuma questão respondida[/color]"
				elif percentual_acerto > 0.7:
					msg += "[color=#00ff00][b]Você foi muito bem![/b][/color]"
				elif percentual_acerto > 0.4:
					msg += "[wave amp=50 freq=5][color=#ffff00]Você foi bem, mas pode melhorar![/color][/wave]"
				else: 
					msg += "[shake rate=20 level=5][color=#ff0000]Você precisa estudar mais![/color][/shake]"
				
				# Exibe a mensagem no diálogo
				dialog_ui.dialog.bbcode_enabled = true  # Ativa BBCode para rich text
				dialog_ui.dialog.text = msg
				dialog_ui.dialog.visible_ratio = 1  # Mostra todo o texto imediatamente
				dialog_index += 1
			elif dialog_index < dialogs.size() - 1:
				dialog_index += 1
				process_line()
				
	elif event.is_action_pressed("prev_line"):
		if dialog_index > 0:
			dialog_index -= 1
			process_line()

func process_line():
	
	var line_info = dialogs[dialog_index]
	print("this is line")
	print(line_info)
	print(line_info.has("choices"))
	if line_info.has("goto"):
		var anchor_info = get_anchor_tag(line_info["goto"])
		var new_index = anchor_info["new_index"]

		if new_index != -1 and new_index != dialog_index:  # Evita loop infinito
			dialog_index = new_index
			process_line()
		return

	elif line_info.has("anchor"):
		if dialog_index < dialogs.size() - 1:
			dialog_index += 1
			process_line()
		return
		
	elif line_info.has("choices"):
		processing_choice = true
		dialog_ui.display_choices(line_info)
		
	elif line_info.has("song"):
		audioPlayer.play_sound[line_info['song']]
		
	else:
		dialog_ui.change_line(line_info["char"], line_info["text"])
		character.change_character(line_info["char"], line_info["mood"])

func get_anchor_tag(anchor: String) -> Dictionary:
	for i in range(dialogs.size()):
		if dialogs[i].has("anchor") and dialogs[i]["anchor"] == anchor:
			var is_right = dialogs[i].get("isRight", false)
			if is_right:
				questions_right += 1
			return {"new_index": i, "is_right": is_right}
	return {"new_index": -1, "is_right": false} 

func load_dialogue(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data:
			dialogs = data.get("dialogs", [])
			song = data.get("song", "sad")
			background = data.get("background", 3)
			return data
	push_error("Failed to load JSON from: " + path)
	return {}

func _on_choice_selected(anchor: String):
	questions += 1
	var anchor_info = get_anchor_tag(anchor)
	var new_index = anchor_info["new_index"]
	if new_index != -1:
		dialog_index = new_index
		processing_choice = false
		process_line()
