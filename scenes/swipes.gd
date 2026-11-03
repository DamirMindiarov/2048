extends Node


var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
const MIN_DRAG: float = 40.0 

# Твоя кастомная функция, которая делает честный return в момент отпускания
func check_swipe(event: InputEvent) -> String:
	# 1. СТАРТ: Проверяем именно НАЖАТИЕ (клик/тап), а не просто ведение зажатого пальца
	if event is InputEventMouseButton and event.is_pressed():
		# Проверяем, было ли это ПЕРВОЕ касание строго внутри сетки
		if get_parent().get_node("GridBoard").get_global_rect().has_point(event.position):
			start_pos = event.position
			print("ДАТЧИК: Честное касание внутри поля зафиксировано на: ", start_pos)
		else:
			# Если ткнули мимо поля — сбрасываем старт, чтобы этот жест вообще не считывался при отпускании
			start_pos = Vector2.ZERO
		return ""
			
	# 2. ФИНИШ: Кнопку отпустили (event.is_released() или button_mask == 0)
	elif event is InputEventMouseButton and not event.is_pressed():
		# Проверяем, был ли вообще зафиксирован честный старт жеста
		if start_pos != Vector2.ZERO:
			end_pos = event.position
			var drag_vector: Vector2 = end_pos - start_pos
			
			# Сбрасываем старт сразу, чтобы подготовиться к следующему ходу
			start_pos = Vector2.ZERO
			
			# Если сдвиг достаточно длинный — считаем ОДИН финальный результат
			if drag_vector.length() > MIN_DRAG:
				if abs(drag_vector.x) > abs(drag_vector.y):
					return "RIGHT" if drag_vector.x > 0 else "LEFT"
				else:
					return "DOWN" if drag_vector.y > 0 else "UP"
					
		start_pos = Vector2.ZERO
		
	return ""
