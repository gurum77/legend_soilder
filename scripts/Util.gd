extends Node
# jumping 하는 node의 z index값
const JUMPING_NODE_Z_INDEX = 3
const JUMPING_NODE_COLLISION_MASK = 0

# airplane의 z_index값
const AIRPLANE_NODE_Z_INDEX = 4

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

func is_equal_double(d1, d2, tol=0.1)->bool:
	if abs(d1 - d2) > tol:
		return false
	return true
	
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
	if node.z_index == JUMPING_NODE_Z_INDEX:
		return true
	if node.has_method("collision_mask") && node.collision_mask == 0:
		return true
		
	var parent = node.get_parent()
	if parent.z_index == JUMPING_NODE_Z_INDEX:
		return true
	if parent.has_method("collision_mask") && parent.collision_mask == 0:
		return true
	return false
