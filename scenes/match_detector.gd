extends Node

# Главная функция: ищет любые соприкасающиеся группы от 3 штук и удаляет их
func check_and_destroy_matches() -> int:
	var grid_board = get_parent().get_node("GridBoard")
	if not grid_board: return 0
		
	# Динамический размер из конфига
	var size = GameManager.board_size
	
	var cells_to_clear = []
	var visited = []
	# Заполняем массив visited под новую общую площадь (size * size)
	for i in range(size * size):
		visited.append(false)
		
	# Меняем range(10) на range(size)
	for r in range(size):
		for c in range(size):
			var idx = r * size + c
			if visited[idx]: continue
				
			var cell = grid_board.get_child(idx)
			var base_texture = _get_piece_texture_path(cell)
			if base_texture == "":
				visited[idx] = true
				continue
				
			var current_group = []
			var queue = [Vector2(c, r)]
			visited[idx] = true
			
			while queue.size() > 0:
				var current_pos = queue.pop_front()
				var current_idx = current_pos.y * size + current_pos.x
				var current_cell = grid_board.get_child(current_idx)
				current_group.append(current_cell)
				
				var directions = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
				for dir in directions:
					var next_c = current_pos.x + dir.x
					var next_r = current_pos.y + dir.y
					
					# Границы теперь динамические
					if next_c >= 0 and next_c < size and next_r >= 0 and next_r < size:
						var next_idx = next_r * size + next_c
						if not visited[next_idx]:
							var next_cell = grid_board.get_child(next_idx)
							var next_texture = _get_piece_texture_path(next_cell)
							if next_texture == base_texture:
								visited[next_idx] = true
								queue.append(Vector2(next_c, next_r))
								
			if current_group.size() >= 3:
				for g_cell in current_group:
					if not g_cell in cells_to_clear:
						cells_to_clear.append(g_cell)

	var destroyed_count = cells_to_clear.size()
	if destroyed_count > 0:
		for cell in cells_to_clear:
			for child in cell.get_children():
				if "GamePiece" in child.name:
					child.queue_free()
					
	return destroyed_count


# Вспомогательная функция (остаётся прежней, вытаскивает путь к картинке)
func _get_piece_texture_path(cell: Control) -> String:
	for child in cell.get_children():
		if "GamePiece" in child.name and child.texture:
			return child.texture.resource_path
	return ""
