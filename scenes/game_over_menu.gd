extends ColorRect

# Находим твою кнопку внутри меню (проверь её имя у себя в сцене!)
@onready var restart_button: Button = $RestartButton

func _ready() -> void:
	# ВСТРОЕННЫЙ СИГНАЛ: Говорим кнопке: "При нажатии вызови функцию ниже"
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)

# Эта функция сработает строго в момент клика по кнопке "ИГРАТЬ СНОВА"
func _on_restart_button_pressed() -> void:
	print("МЕНЮ GAME OVER: Перезапускаю уровень с чистого листа!")
	
	# Магическая строчка, которая полностью обнуляет игру и запускает её заново
	get_tree().reload_current_scene()
