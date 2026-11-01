extends Node

# Главная функция движения, которую ты вызываешь из game.gd
func move_all_pieces(direction: String) -> void:
	var grid_board = get_parent().get_node("GridBoard")
	if not grid_board:
		print("ДВИЖЕНИЕ: Ошибка! Родитель GridBoard не найден.")
		return
		
	print("\n=== КОНТРОЛЛЕР ДВИЖЕНИЯ: СТАРТ СДВИГА ДО УПОРА В СТОРОНУ -> ", direction, " ===")
	print("ДВИЖЕНИЕ: Всего дочерних узлов у GridBoard: ", grid_board.get_child_count())
	
	match direction:
		"LEFT":
			for r in range(10):
				for c in range(1, 10):
					_process_piece_move(grid_board, r, c, -1, 0)
		"RIGHT":
			for r in range(10):
				for c in range(8, -1, -1):
					_process_piece_move(grid_board, r, c, 1, 0)
		"UP":
			for c in range(10):
				for r in range(1, 10):
					_process_piece_move(grid_board, r, c, 0, -1)
		"DOWN":
			for c in range(10):
				for r in range(8, -1, -1):
					_process_piece_move(grid_board, r, c, 0, 1)
					
	print("=== КОНТРОЛЛЕР ДВИЖЕНИЯ: СДВИГ ЗАВЕРШЕН ===\n")

# Вспомогательная функция, которая толкает ОДНУ конкретную фишку до упора
func _process_piece_move(grid_board: GridContainer, r: int, c: int, step_x: int, step_y: int) -> void:
	var current_idx = r * 10 + c
	if current_idx >= grid_board.get_child_count():
		return
		
	var current_cell = grid_board.get_child(current_idx)
	if not current_cell is Control:
		return
		
	# === 🔥 ИЩЕМ СТРОГО ФИШКУ, ИГНОРИРУЯ ПОЛ ===
	var piece = null
	
	# Перебираем всё, что лежит внутри клетки пола
	for child in current_cell.get_children():
		# Если имя узла содержит GamePiece (или это @GamePiece@)
		if "GamePiece" in child.name:
			piece = child
			break
			
	# Если внутри этой клетки пола фишки НЕТ (лежит только Background) — выходим!
	if piece == null:
		return
		
	print("ДВИЖЕНИЕ: Найдена РЕАЛЬНАЯ фишка в строке ", r, ", столбце ", c, " (Индекс ячейки: ", current_idx, ") | Имя узла: ", piece.name)
	
	var current_r = r
	var current_c = c
	var best_cell = current_cell
	
	# Шагаем в цикле в сторону свайпа, пока не упрэмся в край или другую фишку
	while true:
		var next_r = current_r + step_y
		var next_c = current_c + step_x
		
		if next_r < 0 or next_r > 9 or next_c < 0 or next_c > 9:
			break
			
		var next_idx = next_r * 10 + next_c
		if next_idx >= grid_board.get_child_count():
			break
			
		var next_cell = grid_board.get_child(next_idx)
		
		# === ПРОВЕРЯЕМ, ЕСТЬ ЛИ В СЛЕДУЮЩЕЙ КЛЕТКЕ СВОЯ ФИШКА ===
		var has_obstacle_piece = false
		for child in next_cell.get_children():
			if "GamePiece" in child.name:
				has_obstacle_piece = true
				break
		
		# Если в следующей клетке фишек нет — путь свободен (даже если там лежит Background пола)
		if not has_obstacle_piece:
			best_cell = next_cell
			current_r = next_r
			current_c = next_c
		else:
			break # Упёрлись в другую фишку!
			
	# Если мы нашли клетку получше той, где стояли — переносим фишку туда!
	if best_cell != current_cell:
		print("  => ПЕРЕНОС: Перемещаю фишку из ячейки ", current_idx, " в ячейку ", best_cell.get_index())
		current_cell.remove_child(piece)
		best_cell.add_child(piece)
