class_name ExpComponent
extends Node2D


signal exp_updated
signal levelled_up

@export var grab_area_radius := 16.0

var experience := 0
var level := 1
var experience_to_next_level: int


func _ready() -> void:
	$GrabArea/CollisionShape.shape.radius = grab_area_radius
	_calculate_required_experience()


func _on_grab_area_entered(crystal: ExpCrystal) -> void:
	crystal.grab()


func _on_collect_area_entered(crystal: ExpCrystal) -> void:
	_add_experience(crystal.collect())


func _calculate_required_experience() -> void:
	experience_to_next_level = round(4 * level + pow(level, 1.45))


func _add_experience(amount: int) -> void:
	experience += amount
	exp_updated.emit()

	if experience >= experience_to_next_level:
		level += 1
		experience -= experience_to_next_level
		_calculate_required_experience()
		levelled_up.emit()
		_add_experience(0)
