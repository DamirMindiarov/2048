extends Node


var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
const MIN_DRAG: float = 40.0 

# Твоя кастомная функция, которая делает честный return в момент отпускания
func check_swipe(event: InputEvent) -> String:
	# 1. СТАРТ: Палец нажат строго внутри сетки — запоминаем начальную точку
	if event.button_mask == 1 and get_parent().get_node("GridBoard").get_global_rect().has_point(event.position):
		if start_pos == Vector2.ZERO:
			start_pos = event.position
		return ""
			
	# 2. ФИНИШ: Кнопку отпустили (button_mask == 0)
	elif event.button_mask == 0:
		# Проверяем, был ли вообще зафиксирован старт жеста
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
