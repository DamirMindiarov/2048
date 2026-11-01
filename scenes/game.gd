@tool # 🔥 ВАЖНО: Приказывает Godot запускать этот скрипт прямо в редакторе!
extends Control

@onready var grid_board: GridContainer = $MainLayout/GridBoard
@onready var detector: Node = $MainLayout/swipes
@onready var piece_spawner: Node = $MainLayout/PieceSpawner
@onready var movement_controller: Node = $MainLayout/MovementController


func _ready() -> void:
	print("Главный скрипт Game запущен!")
	grid_board.generate_grid()
	piece_spawner.spawn_pieces(7)
	
func _input(event: InputEvent) -> void:
	var swipe = detector.check_swipe(event)

	if swipe != "":
			print("ГЛАВНЫЙ СКРИПТ GAME ПОЙМАЛ ХОД: ", swipe)
			movement_controller.move_all_pieces(swipe)
			piece_spawner.spawn_pieces(7)
