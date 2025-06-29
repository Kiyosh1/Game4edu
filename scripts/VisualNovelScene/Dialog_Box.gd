extends Control

@onready var charName = %CharacterName
@onready var dialog = %Dialog
@onready var audio_player = %TextSound
@onready var choice_list = %VBoxContainer

signal choice_selected(anchor)

const ANIMATION_SPEED = 30
var animate_text = true
const ChoiceBtn = preload("res://scenes/VisualNovel/playersChooise.tscn")

func _process(delta):
	if animate_text:
		if dialog.visible_ratio < 1:
			dialog.visible_ratio += (1.0 / dialog.text.length()) * (ANIMATION_SPEED * delta)
			
			if not audio_player.playing:
				audio_player.play_sound("default")
		else:
			animate_text = false
			audio_player.stop_sound()

func _ready():
	choice_list.hide()

func change_line(speaker: String, line: String):
	charName.text = speaker
	dialog.text = line
	dialog.visible_ratio = 0
	animate_text = true
	choice_list.hide()  # Esconde choices quando nova linha aparece

func display_choices(choices: Dictionary):
	# Limpa choices anteriores
	for child in choice_list.get_children():
		child.queue_free()
	
	# Adiciona novas choices
	for choice in choices["choices"]:
		var choice_btn = ChoiceBtn.instantiate() 
		choice_btn.text = choice["text"]
		choice_btn.pressed.connect(_on_choice_btn_pressed.bind(choice["goto"]))
		choice_list.add_child(choice_btn)
	
	choice_list.show()

func _on_choice_btn_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_list.hide()  # Esconde após seleção

func skip_text_animation():
	dialog.visible_ratio = 1
	animate_text = false
	audio_player.stop_sound()
