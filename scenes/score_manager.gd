extends Node

# Прямая лаконичная ссылка на текстовое поле очков в HUD
@onready var score_label: Label = get_tree().current_scene.find_child("ScoreLabel", true, false)

func _ready() -> void:
	_update_score_ui()

# Эту функцию по-прежнему вызывают MatchDetector и BombController при взрывах фишек
func add_score(destroyed_count: int) -> void:
	# 🔥 ПРЯМАЯ ЗАПИСЬ: Просто капаем очками в центральный банк игры
	GameManager.total_score += destroyed_count
	print("SCORE_MANAGER: В банк зачислено +", destroyed_count, " очков. Всего: ", GameManager.total_score)
	
	# Сразу обновляем текст на экране
	_update_score_ui()

# Функция, которая просто синхронизирует буквы на экране с реальностью
func _update_score_ui() -> void:
	if score_label:
		score_label.text = "СЧЁТ: " + str(GameManager.total_score)
