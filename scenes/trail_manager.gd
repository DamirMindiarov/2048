extends Node

# Виртуальный список-карта, чтобы помнить текстуру и позицию фишки ДО свайпа
# Хранит: { ID_фишки: {"pos": Vector2, "texture": Texture2D} }
var old_data: Dictionary = {}

# 1. КОМАНДА (Вызывается из game.gd перед движением): Запоминаем данные фишек
func save_positions() -> void:
	old_data.clear()
	var grid_board = get_parent().get_node_or_null("GridBoard")
	if not grid_board: return
	
	for cell in grid_board.get_children():
		if cell is Control and cell.get_child_count() > 0:
			for child in cell.get_children():
				if "GamePiece" in child.name and child is TextureRect:
					# Запоминаем уникальный ID фишки, её глобальную позицию и её картинку из Paint
					old_data[child.get_instance_id()] = {
						"pos": child.global_position,
						"texture": child.texture,
						"size": child.size
					}

# 2. КОМАНДА (Вызывается из game.gd после движения): Спавним остаточные копии
func draw_trails() -> void:
	var grid_board = get_parent().get_node_or_null("GridBoard")
	if not grid_board: return
	
	for cell in grid_board.get_children():
		if cell is Control and cell.get_child_count() > 0:
			for child in cell.get_children():
				if "GamePiece" in child.name:
					var piece_id = child.get_instance_id()
					
					# Если эта фишка только что куда-то летела
					if old_data.has(piece_id):
						var start_pos = old_data[piece_id]["pos"]
						var end_pos = child.global_position
						
						# Если координаты изменились — значит, был сдвиг!
						if start_pos != end_pos:
							var piece_texture = old_data[piece_id]["texture"]
							var piece_size = old_data[piece_id]["size"]
							
							# 🔥 СПАВНИМ ОСТАТОЧНЫЕ КОПИИ МЕЖДУ СТАРТОМ И ФИНИШЕМ!
							# Сделаем, например, 3 промежуточных призрака по пути полета
							var steps = GameManager.trail_steps
							for i in range(1, steps + 1):
								# Математически вычисляем точку между стартом и финишем
								# t = 0.25, 0.5, 0.75 пути
								var t = float(i) / float(steps + 1)
								var spawn_pos = start_pos.lerp(end_pos, t)
								
								# Создаем статичную картинку-призрак
								_spawn_ghost_image(spawn_pos, piece_texture, piece_size)

# 3. ВНУТРЕННЯЯ ФУНКЦИЯ: Рождение и быстрое таяние одной картинки-копии
func _spawn_ghost_image(pos: Vector2, img_texture: Texture2D, img_size: Vector2) -> void:
	var ghost = TextureRect.new()
	ghost.texture = img_texture
	ghost.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ghost.stretch_mode = TextureRect.STRETCH_SCALE
	ghost.size = img_size
	
	# Кидаем её на самый верх сцены (поверх сетки), чтобы она никому не мешала
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = pos
	
	# Делаем её изначально полупрозрачной
	ghost.modulate.a = GameManager.trail_opacity
	
	# Робот-аниматор мгновенно (за 0.12 секунды) растворяет её в ноль
	var tween = create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	# Сама очищает память смартфона
	tween.tween_callback(ghost.queue_free)
