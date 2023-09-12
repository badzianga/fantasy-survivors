extends CanvasLayer


@onready var health_bar := $Control/HealthBar
@onready var exp_bar := $Control/ExpBar
@onready var lvl_label := $Control/LvlLabel


func set_health(hp: int) -> void:
	health_bar.value = hp


func set_max_health(max_hp: int) -> void:
	health_bar.max_value = max_hp


func set_exp(experience: int) -> void:
	exp_bar.value = experience


func set_max_exp(max_experience: int) -> void:
	exp_bar.max_value = max_experience


func set_level(level: int) -> void:
	lvl_label.text = "Level: " + str(level)
