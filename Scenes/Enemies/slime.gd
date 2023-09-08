extends CharacterBody2D


@export var speed := 16.0

var direction: Vector2

@onready var sprite := $Sprite
@onready var health := $HealthComponent as HealthComponent

func _ready() -> void:
	health.health_depleted.connect(_on_health_depleted)


func _physics_process(_delta: float) -> void:
	direction = global_position.direction_to(GameData.player.global_position)
	velocity = direction * speed
	
	sprite.flip_h = velocity.x < 0
	
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	area.queue_free()
	health.apply_damage(1)


func _on_health_depleted() -> void:
	queue_free()
