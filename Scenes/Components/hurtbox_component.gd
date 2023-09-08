class_name HurtboxComponent
extends Area2D


@export var cooldown_seconds := 0.0
@export var health_component: HealthComponent
@export var collision_shape: CollisionShape2D

@onready var cooldown_timer := $CooldownTimer


func _ready() -> void:
	if cooldown_seconds != 0.0:
		cooldown_timer.wait_time = cooldown_seconds


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if not cooldown_timer.is_stopped():
		return
	
	if cooldown_seconds != 0.0:
		cooldown_timer.start()
		collision_shape.set_deferred("disabled", true)
	
	health_component.apply_damage(hitbox.damage)
	
	if hitbox.destroy_on_collision:
		hitbox.queue_free()  # destroy attack


func _on_cooldown_timer_timeout() -> void:
	collision_shape.set_deferred("disabled", false)
