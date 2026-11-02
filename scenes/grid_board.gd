@tool
extends GridContainer

const CELL_SCENE = preload("res://scenes/cell.tscn")

func generate_grid() -> void:
	for child in get_children():
		child.queue_free()
		
	var grid_size = GameManager.board_size
	columns = grid_size
	
	print("\n=== АВТО-ГЕНЕРАЦИЯ ПОЛЯ ", grid_size, "x", grid_size, " ===")
	
	# 1. МАТЕМАТИКА АВТО-РАЗМЕРА: 
	# Берем полную ширину экрана (у нас в проекте это 720 пикселей)
	var board_width = 720.0
	
	# Делим ширину на количество клеток, получая идеальный размер для сохранения пропорций 1:1
	var perfect_cell_size = board_width / grid_size
	print("АВТО-РАЗМЕР: Каждая клетка автоматически получит размер: ", perfect_cell_size, "x", perfect_cell_size, " px")
	
	# 2. СТРОИМ СЕТКУ
	var total_cells = grid_size * grid_size
	for i in range(total_cells):
		if CELL_SCENE:
			var new_cell = CELL_SCENE.instantiate()
			
			# 🔥 ВОТ ОНА — АВТОМАТИКА! 
			# Прямо кодом выставляем идеальный минимальный размер для X и Y одновременно!
			if new_cell is Control:
				new_cell.custom_minimum_size = Vector2(perfect_cell_size, perfect_cell_size)
				
			add_child(new_cell)
			
	print("=== АВТО-ГЕНЕРАЦИЯ ЗАВЕРШЕНА ===\n")
