extends Node

# Ссылка на наш текстовый узел на экране (укажи точный путь от корня, если нужно)
@onready var score_label: Label = get_node("/root/Game/ScoreLabel")

var current_score: int = 0

# Единственная функция: принимает количество уничтоженных фишек
func add_score(destroyed_count: int) -> void:
	# Математика баланса: за каждую уничтоженную фишку даём, например, 10 очков
	var points_earned = destroyed_count
	
	# Прибавляем к общему счёту
	current_score += points_earned
	print("SCORE_MANAGER: Начислено +", points_earned, " очков. Текущий счёт: ", current_score)
	
	# Сразу же обновляем текст на экране смартфона
	if score_label:
		score_label.text = "СЧЁТ: " + str(current_score)
