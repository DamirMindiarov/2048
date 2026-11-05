extends Node

@onready var level_label: Label = get_tree().current_scene.find_child("LevelLabel", true, false)


func _ready() -> void:
	_update_level_ui()

func _process(delta: float) -> void:
	# 🔥 БЕРЕМ НАСТРОЙКУ ШАГА НАПРЯМУЮ ИЗ ГЛАВНОГО ПУЛЬТА!
	var step = GameManager.score_per_level
	
	# Вычисляем, какой уровень должен быть при текущем глобальном счете
	var target_level = floor((GameManager.total_score * 1.0) / step) + 1
	
	# Если уровень в банке игры стал выше нашего текущего — апаем его!
	if target_level > GameManager.current_level:
		GameManager.current_level = target_level
		print("🏆 LEVEL_MANAGER: Наступил новый УРОВЕНЬ: ", GameManager.current_level)
		_update_level_ui()
		_give_level_reward()

func _update_level_ui() -> void:
	if level_label:
		level_label.text = "УРОВЕНЬ: " + str(GameManager.current_level)

func _give_level_reward() -> void:
	# Награда: прибавляем бомбу в глобальный банк игры
	GameManager.bomb_count += 1
	
	# Обновляем текст на кнопке бомбы (x2 -> x3)
	var bomb_button = get_tree().current_scene.find_child("BombButton", true, false)
	if bomb_button and bomb_button.has_method("_update_ui"):
		bomb_button._update_ui()
