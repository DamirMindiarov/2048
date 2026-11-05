extends ColorRect

# Находим твою кнопку внутри меню (проверь её имя у себя в сцене!)
@onready var restart_button: Button = $RestartButton

func _ready() -> void:
	# ВСТРОЕННЫЙ СИГНАЛ: Говорим кнопке: "При нажатии вызови функцию ниже"
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)


func _on_restart_button_pressed() -> void:
	print("МЕНЮ GAME OVER: Перезапускаю уровень с чистого листа!")
	
	# 🔥 СБРАСЫВАЕМ ВСЮ СТАТИСТИКУ В БАНКЕ ИГРЫ ПЕРЕД ПЕРЕЗАПУСКОМ:
	GameManager.bomb_count = 2
	GameManager.total_score = 0
	GameManager.current_level = 1
	
	# Перезапускаем сцену
	get_tree().reload_current_scene()
