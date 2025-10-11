extends CharacterBody3D

enum States {attack, idle, chase, die}

var target = null
var hp = 100
var gravity = 9.8
var state = States.idle
var speed = 7.5
var accel = 10

@onready var animation = $AnimationPlayer
@onready var navagent = $NavigationAgent3D
@onready var mesh = $MeshInstance3D


func _ready():
	if Menu.enemy == "shrek":
		print("spawned shrek")
		mesh.set_surface_override_material(0, preload("uid://b4ej4pwbtsjqi"))
	elif Menu.enemy == "harry":
		print("spawned harry")
		mesh.set_surface_override_material(0, preload("uid://cqdlfmbb3sknc"))

func _process(delta):
	if hp <= 0:
		state = States.die
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity
	if state == States.idle:
		velocity = Vector3.ZERO
		#animation.play("")
	elif state == States.chase:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		navagent.target_position = target.global_position
		var direction = navagent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		#animation.play("")
	
	move_and_slide()
	

func _on_chase_zone_body_entered(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		target = body
		state = States.chase

func _on_chase_zone_body_exited(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		target = null
		state = States.idle
