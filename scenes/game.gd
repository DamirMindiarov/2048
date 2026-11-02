#@tool # 🔥 ВАЖНО: Приказывает Godot запускать этот скрипт прямо в редакторе!
extends Control

@onready var grid_board: GridContainer = $MainLayout/GridBoard
@onready var detector: Node = $MainLayout/swipes
@onready var piece_spawner: Node = $MainLayout/PieceSpawner
@onready var movement_controller: Node = $MainLayout/MovementController
@onready var game_over_detector: Node = $MainLayout/GameOverDetector
@onready var game_over_menu: Control = $GameOverMenu
@onready var match_detector: Node = $MainLayout/MatchDetector
@onready var score_manager: Node = $MainLayout/ScoreManager


func _ready() -> void:
	print("Главный скрипт Game запущен!")
	grid_board.generate_grid()
	piece_spawner.spawn_pieces(2)
	
func _input(event: InputEvent) -> void:
	var swipe = detector.check_swipe(event)

	if swipe != "":
		print("ГЛАВНЫЙ СКРИПТ GAME ПОЙМАЛ ХОД: ", swipe)
		
		# 1. ДВИЖЕНИЕ: Приказываем сдвинуть фишки до упора
		movement_controller.move_all_pieces(swipe)
		
		# 🔥 ЖДЁМ КАДР: Даём Godot физически перекинуть фишки в новые ячейки пола!
		await get_tree().process_frame
		
		# 2. УНИЧТОЖЕНИЕ: Ищем и взрываем соприкасающиеся группы "3 рядом"
		var destroyed_pieces = match_detector.check_and_destroy_matches()
		score_manager.add_score(destroyed_pieces)
		
		# 🔥 СНОВА ЖДЁМ КАДР: Даём движку полностью стереть взорванные фишки из памяти телефона!
		await get_tree().process_frame
		
		# 3. СПАВН: Докидываем на честные освободившиеся места 2 новые фишки
		piece_spawner.spawn_pieces(2)
		
		# 🔥 СНОВА ЖДЁМ КАДР: Чтобы новые фишки прогрузились на поле перед проверкой проигрыша
		await get_tree().process_frame
		
		# 4. КОНЕЦ ИГРЫ: Проверяем, забилось ли поле окончательно
		if game_over_detector.is_game_over():
			game_over_menu.visible = true
