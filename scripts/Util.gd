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
	
func show_message(scene, msg):
	var dlg = MyAcceptDialog.new()
	dlg.dialog_text = msg
	scene.add_child(dlg)
	dlg.popup_centered()

func is_equal_vector2(vec1, vec2, tol)->bool:
	if abs(vec1.x - vec2.x) > tol:
		return false
	if abs(vec1.y - vec2.y) > tol:
		return false
	return true
	
# jump 중인지?
func is_jumping(var node:Node2D)->bool:
	if node == null:
		return false
	if node.z_index == 3:
		return true
	if node.has_method("collision_mask") && node.collision_mask == 0:
		return true
		
	var parent = node.get_parent()
	if parent.z_index == 3:
		return true
	if parent.has_method("collision_mask") && parent.collision_mask == 0:
		return true
	return false
