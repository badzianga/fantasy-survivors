extends CharacterBody2D


@export var speed := 16.0
@export var health := 3

@onready var sprite := $Sprite
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	sprite.flip_h = velocity.x < 0
	
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	area.queue_free()
	health -= 1
	if health <= 0:
		queue_free()
