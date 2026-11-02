extends Node

# Главная функция движения, которую ты вызываешь из game.gd
func move_all_pieces(direction: String) -> void:
	var grid_board = get_parent().get_node("GridBoard")
	if not grid_board: return
		
	# Берём размер из конфига
	var size = GameManager.board_size
	
	match direction:
		"LEFT":
			for r in range(size):
				for c in range(1, size):
					_process_piece_move(grid_board, r, c, -1, 0, size)
		"RIGHT":
			for r in range(size):
				for c in range(size - 2, -1, -1):
					_process_piece_move(grid_board, r, c, 1, 0, size)
		"UP":
			for c in range(size):
				for r in range(1, size):
					_process_piece_move(grid_board, r, c, 0, -1, size)
		"DOWN":
			for c in range(size):
				for r in range(size - 2, -1, -1):
					_process_piece_move(grid_board, r, c, 0, 1, size)

# Добавь параметр size в конец нашей вспомогательной функции
func _process_piece_move(grid_board: GridContainer, r: int, c: int, step_x: int, step_y: int, size: int) -> void:
	# Формула индекса теперь использует динамический размер!
	var current_idx = r * size + c
	if current_idx >= grid_board.get_child_count(): return
	
	var current_cell = grid_board.get_child(current_idx)
	if not current_cell is Control or current_cell.get_child_count() == 0: return
		
	var piece = null
	for child in current_cell.get_children():
		if "GamePiece" in child.name:
			piece = child
			break
	if piece == null: return
	
	var current_r = r
	var current_c = c
	var best_cell = current_cell
	
	while true:
		var next_r = current_r + step_y
		var next_c = current_c + step_x
		
		# Проверяем динамические границы (от 0 до size - 1)
		if next_r < 0 or next_r > (size - 1) or next_c < 0 or next_c > (size - 1):
			break
			
		var next_idx = next_r * size + next_c
		if next_idx >= grid_board.get_child_count(): break
			
		var next_cell = grid_board.get_child(next_idx)
		
		var has_obstacle_piece = false
		for child in next_cell.get_children():
			if "GamePiece" in child.name:
				has_obstacle_piece = true
				break
				
		if not has_obstacle_piece:
			best_cell = next_cell
			current_r = next_r
			current_c = next_c
		else:
			break
			
	if best_cell != current_cell:
		current_cell.remove_child(piece)
		best_cell.add_child(piece)
