extends Node

# Функция проверяет поле и возвращает true, если мест больше НЕТ (Конец игры)
func is_game_over() -> bool:
	# Находим сетку GridBoard (она лежит на том же уровне)
	var grid_board = get_parent().get_node("GridBoard")
	if not grid_board:
		return false
		
	# Сканируем ячейки на пустоту
	for cell in grid_board.get_children():
		if cell is Control:
			var has_piece = false
			# Проверяем, сидит ли внутри клетки фишка GamePiece
			for child in cell.get_children():
				if "GamePiece" in child.name:
					has_piece = true
					break
			
			# Если мы нашли хотя бы одну клетку, в которой НЕТ фишки — игра продолжается!
			if not has_piece:
				return false
				
	# Если цикл проверил все 100 клеток и свободных мест вообще не нашлось — это поражение!
	return true
