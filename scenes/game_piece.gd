extends TextureRect

const EXPLOSION_SCENE = preload("res://scenes/explosion_effect.tscn")

# 🔥 НАША НОВАЯ ФУНКЦИЯ ДЛЯ ЧЕСТНОЙ СМЕРТИ:
func destroy_with_explosion() -> void:
	if EXPLOSION_SCENE:
		var effect = EXPLOSION_SCENE.instantiate()
		var center_offset = size / 2.0
		effect.global_position = global_position + center_offset
		effect.texture = texture
		
		get_tree().current_scene.add_child(effect)
		
	# И только ПОСЛЕ спавна частиц окончательно удаляем фишку из памяти!
	queue_free()
