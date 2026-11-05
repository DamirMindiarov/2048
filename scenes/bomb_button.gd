extends Control

@onready var icon: TextureRect = $Icon
@onready var count_label: Label = $CountLabel
@onready var controller: Node = $BombController # Ссылка на наш новый узел расчётов

var drag_ghost: TextureRect = null

func _ready() -> void:
	_update_ui()

func _input(event: InputEvent) -> void:
	# Коротко ловим события и сразу отправляем в нужные подфункции
	if event is InputEventMouseButton and event.is_pressed():
		_on_drag_started(event.position)
			
	elif event is InputEventMouseMotion:
		_on_dragging(event.position)
			
	elif event is InputEventMouseButton and not event.is_pressed():
		_on_drag_ended(event.position)

# --- 🛠️ КРАСИВОЕ РАЗБИТИЕ НА МИКРО-ФУНКЦИИ ---

func _on_drag_started(pos: Vector2) -> void:
	# Проверяем клик по кнопке и наличие баланса
	if get_global_rect().has_point(pos) and GameManager.bomb_count > 0:
		GameManager.bomb_count -= 1
		_update_ui()
		_create_drag_ghost(pos)

func _on_dragging(pos: Vector2) -> void:
	if drag_ghost != null:
		drag_ghost.global_position = pos - (drag_ghost.size / 2.0)

func _on_drag_ended(pos: Vector2) -> void:
	if drag_ghost == null: return
	
	# Просим контроллер выдать индекс ячейки под пальцем
	var cell_idx = controller.get_cell_index_under_point(pos)
	
	# Проверяем у контроллера, есть ли в этой ячейке реальная цель
	if cell_idx != -1 and controller.get_piece_in_cell(cell_idx) != null:
		controller.explode_cell(cell_idx)
	else:
		_refund_bomb()
		
	_destroy_drag_ghost()

func _create_drag_ghost(start_pos: Vector2) -> void:
	if icon:
		drag_ghost = icon.duplicate() as TextureRect
		drag_ghost.modulate.a = 0.7
		get_tree().current_scene.add_child(drag_ghost)
		drag_ghost.global_position = start_pos - (drag_ghost.size / 2.0)

func _destroy_drag_ghost() -> void:
	if drag_ghost:
		drag_ghost.queue_free()
		drag_ghost = null

func _refund_bomb() -> void:
	print("❌ БОМБА: Цели нет или промах. Возвращаю заряд...")
	GameManager.bomb_count += 1
	_update_ui()

func _update_ui() -> void:
	if count_label: count_label.text = "x" + str(GameManager.bomb_count)
	if icon: icon.modulate.a = 0.5 if GameManager.bomb_count == 0 else 1.0
