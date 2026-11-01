@tool # 🔥 ВАЖНО: Приказывает Godot запускать этот скрипт прямо в редакторе!
extends GridContainer

# Подгружаем шаблон одной клетки
const CELL_SCENE = preload("res://scenes/cell.tscn")

# Функция просто лежит здесь и ждет, пока её вызовет главный скрипт Game
func generate_grid() -> void:
	print("Игровое поле: Получил команду от Game. Строю сетку 10х10...")
	
	for i in range(100):
		if CELL_SCENE:
			var new_cell = CELL_SCENE.instantiate()
			add_child(new_cell)
			
	print("Игровое поле: Сетка успешно построена!")
	
