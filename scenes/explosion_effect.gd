extends CPUParticles2D

func _ready() -> void:
	# Сразу запускаем взрыв
	emitting = true
	# Через время жизни частиц полностью стираем узел, чтобы не забивать память телефона
	await get_tree().create_timer(lifetime).timeout
	queue_free()
