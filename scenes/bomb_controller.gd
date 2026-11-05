extends Node

@onready var grid_board: GridContainer = get_tree().current_scene.find_child("GridBoard")

# Переменная-тумблер, хранящая нашу единственную функцию взрыва
var active_mode: Callable = explode_area_3x3

func get_cell_index_under_point(global_point: Vector2) -> int:
	for i in range(grid_board.get_child_count()):
		var cell = grid_board.get_child(i)
		if cell.get_global_rect().has_point(global_point):
			return i
	return -1

func get_piece_in_cell(cell_index: int) -> TextureRect:
	var cell = grid_board.get_child(cell_index)
	for child in cell.get_children():
		if "GamePiece" in child.name and child is TextureRect:
			return child
	return null

# Главная функция, которую пинает кнопка при отпускании пальца
func explode_cell(epicenter_index: int) -> void:
	if active_mode.is_valid():
		active_mode.call(epicenter_index)

# НАША ЕДИНСТВЕННАЯ РАБОЧАЯ ФУНКЦИЯ ВЗРЫВА 3х3
func explode_area_3x3(epicenter_index: int) -> void:
	var size: int = 5
	var epicenter_row: int = floor((epicenter_index * 1.0) / size)
	var epicenter_col = epicenter_index % size
	
	var radius = GameManager.bomb_radius
	var total_destroyed: int = 0
	
	var start_offset = -radius
	var end_offset = radius + 1
	
	for r_offset in range(start_offset, end_offset):
		for c_offset in range(start_offset, end_offset):
			var target_row = epicenter_row + r_offset
			var target_col = epicenter_col + c_offset
			
			if target_row >= 0 and target_row < size and target_col >= 0 and target_col < size:
				var neighbor_index = target_row * size + target_col
				var piece = get_piece_in_cell(neighbor_index)
				if piece and piece.has_method("destroy_with_explosion"):
					piece.destroy_with_explosion()
					total_destroyed += 1
					
	if total_destroyed > 0:
		var score_manager = get_tree().current_scene.find_child("ScoreManager", true, false)
		if score_manager and score_manager.has_method("add_score"):
			score_manager.add_score(total_destroyed)
			
# Просто дописываем новую функцию в самый низ файла:
func explode_cross(epicenter_index: int) -> void:
	var size: int = 5
	var epicenter_row: int = floor((epicenter_index * 1.0) / size)
	var epicenter_col = epicenter_index % size
	var total_destroyed: int = 0
	
	for i in range(grid_board.get_child_count()):
		var r: int = floor((i * 1.0) / size)
		var c = i % size
		
		# Если клетка лежит на той же строке или том же столбце — взрываем!
		if r == epicenter_row or c == epicenter_col:
			var piece = get_piece_in_cell(i)
			if piece and piece.has_method("destroy_with_explosion"):
				piece.destroy_with_explosion()
				total_destroyed += 1
				
	if total_destroyed > 0:
		var score_manager = get_tree().current_scene.find_child("ScoreManager", true, false)
		if score_manager and score_manager.has_method("add_score"):
			score_manager.add_score(total_destroyed)
