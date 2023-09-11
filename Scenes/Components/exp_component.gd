class_name ExpComponent
extends Node2D


signal exp_updated

@export var grab_area_radius := 16.0

var experience := 0


func _ready() -> void:
	$GrabArea/CollisionShape.shape.radius = grab_area_radius


func _on_grab_area_entered(crystal: ExpCrystal) -> void:
	crystal.grab()


func _on_collect_area_entered(crystal: ExpCrystal) -> void:
	experience += crystal.collect()
	exp_updated.emit()
