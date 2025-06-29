extends AudioStreamPlayer

const sounds = {
	"default": preload("res://assets/sound_effects/Teclado.ogg")
}

func play_sound(sound: String):
	if sounds.has(sound):
		stream = sounds[sound]
		play()  # Toca o som corretamente
	else:
		push_warning("Som não encontrado: " + sound)

func stop_sound():
	stop()  # Para o som
