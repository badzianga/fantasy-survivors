extends CharacterBody2D


@export var speed := 16.0

var direction: Vector2

@onready var sprite := $Sprite
@onready var health := $HealthComponent as HealthComponent
@onready var effects := $Effects


func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.health_depleted.connect(_on_health_depleted)


func _physics_process(_delta: float) -> void:
	direction = global_position.direction_to(GameData.player.global_position)
	velocity = direction * speed
	
	sprite.flip_h = velocity.x < 0
	
	move_and_slide()


func _on_health_changed() -> void:
	effects.play("hurt")


func _on_health_depleted() -> void:
	effects.play("death")
	disable_processing()
	await $Effects.animation_finished
	queue_free()


func disable_processing() -> void:
	$CollisionShape.set_deferred("disabled", true)
	$HurtboxComponent.queue_free()
	$HitboxComponent.queue_free()
	set_physics_process(false)
