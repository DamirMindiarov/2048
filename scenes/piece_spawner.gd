extends Node

# Ссылка на сцену фишки, укажи свой точный путь на диске
const PIECE_SCENE = preload("res://scenes/game_piece.tscn")

# Массив картинок-заглушек, укажи свои рабочие пути к файлам PNG
const PIECE_TEXTURES = [
	#preload("res://assets_piece/circle_black.png"),
	#preload("res://assets_piece/circle_close.png"),
	#preload("res://assets_piece/circle_empty.png"),
	preload("res://assets_piece/square_black.png"),
	preload("res://assets_piece/square_empty.png"),
	preload("res://assets_piece/triangle_black.png"),
	preload("res://assets_piece/triangle_empty.png")
]

# ОДНА ЕДИНСТВЕННАЯ ФУНКЦИЯ СПАВНА
func spawn_pieces(count: int) -> void:
	
	var grid_board = get_parent().get_node("GridBoard")
	if not grid_board:
		return
		
		
		# 1. Собираем пустые клетки
	var empty_cells = []
	for cell in grid_board.get_children():
		if cell is Control:
			# ЖЕСТКАЯ ПРОВЕРКА: клетка считается пустой, только если в ней вообще 0 детей,
			# ЛИБО если среди её детей НЕТ узлов с именем GamePiece!
			var has_piece = false
			for child in cell.get_children():
				if "GamePiece" in child.name or child.has_method("move_to_cell"):
					has_piece = true
			
			# Если это обычная клетка-подложка (Cell) и в ней нет фишки — она пустая!
			if cell.name.begins_with("Cell") or "@Control@" in cell.name:
				if not has_piece:
					empty_cells.append(cell)
			
			
	# 2. Рождаем фишки на свободных местах
	for i in range(count):
		if empty_cells.size() == 0:
			break
			
		var random_index = randi() % empty_cells.size()
		var target_cell = empty_cells[random_index]
		empty_cells.remove_at(random_index)
		
		
		if PIECE_SCENE:
			var new_piece = PIECE_SCENE.instantiate()
			
			if PIECE_TEXTURES.size() > 0:
				var random_texture_idx = randi() % PIECE_TEXTURES.size()
				new_piece.texture = PIECE_TEXTURES[random_texture_idx]

			
			target_cell.add_child(new_piece)
