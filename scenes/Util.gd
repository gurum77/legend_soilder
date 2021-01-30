extends Node

func play_animation(animated_sprite, anim, from_start_frame=false):
	if animated_sprite == null:
		return
	if animated_sprite.frames.has_animation(anim) == false:
		return
		
	if from_start_frame == true:
		animated_sprite.frame = 0
	animated_sprite.visible = true
	animated_sprite.play(anim)
	
