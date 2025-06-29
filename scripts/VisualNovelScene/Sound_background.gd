extends AudioStreamPlayer

const sounds = {
	"default": preload("res://assets/BGM/beanfeast.mp3"),
	"sad": preload("res://assets/BGM/beanfeast.mp3"),
	"happy": preload("res://assets/BGM/beanfeast.mp3"),
	"angry": preload("res://assets/BGM/beanfeast.mp3")
}



func play_sound(sound: String):
	if sounds.has(sound):
		stream = sounds[sound]
		play()  # <-- chama .play() no AudioStreamPlayer (self)
	else:
		push_warning("Som não encontrado: " + sound)
