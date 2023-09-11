extends CanvasLayer


@onready var health_bar := $Control/HealthBar
@onready var exp_label := $Control/ExpLabel


func set_health(hp: int) -> void:
	health_bar.value = hp


func set_max_health(max_hp: int) -> void:
	health_bar.max_value = max_hp


func set_exp(experience: int) -> void:
	exp_label.text = "Exp: " + str(experience)
