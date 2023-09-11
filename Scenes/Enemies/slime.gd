extends CharacterBody2D


const ExpCrystalScene = preload("res://Scenes/Loot/exp_crystal.tscn")

@export var speed := 16.0
@export var exp_min := 0
@export var exp_max := 1

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
	_disable_processing()
	_drop_exp()
	await $Effects.animation_finished
	queue_free()
	


func _disable_processing() -> void:
	$CollisionShape.set_deferred("disabled", true)
	$HurtboxComponent.queue_free()
	$HitboxComponent.queue_free()
	set_physics_process(false)


func _drop_exp() -> void:
	var amount := randi_range(exp_min, exp_max)
	if amount == 0:
		return
	var exp_crystal := ExpCrystalScene.instantiate()
	exp_crystal.global_position = global_position
	exp_crystal.amount = amount
	exp_crystal.rotation_degrees = randi_range(0, 180)
	get_tree().get_first_node_in_group("LootNode").call_deferred("add_child", exp_crystal)
