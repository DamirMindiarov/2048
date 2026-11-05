extends Node

# === 🧩 НАСТРОЙКА РАЗМЕРА ИГРОВОГО ПОЛЯ ===
# Просто меняй эту цифру! 6 означает поле 6х6, 5 означает 5х5 и так далее.
var board_size: int = 5

# Твои старые переменные здоровья и золота остаются ниже без изменений...
# === 💨 НАСТРОЙКИ ВИЗУАЛЬНОГО ШЛЕЙФА ===
var trail_steps: int = 5         # Количество остаточных копий по пути полёта (steps)
var trail_opacity: float = 0.1   # Начальная прозрачность призраков (ghost.modulate.a)

var bomb_count: int = 2
var bomb_radius: int = 1

var total_score: int = 0
var current_level: int = 1
var score_per_level: int = 1
