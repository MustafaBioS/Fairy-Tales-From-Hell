extends CharacterBody3D

@onready var camera = $Camera3D

var SPEED = 7.5
var JUMP_VELOCITY = 4.5
const sensitivity = 0.003
var sliding = false
var crouched = false

var bullet = load("res://Scenes/spell.tscn")
@onready var pos = $player/CSGCylinder3D/pos

@onready var animation = $AnimationPlayer
@onready var slide = $CanvasLayer/Slide
@onready var jump = $CanvasLayer/Jump
@onready var sprint = $CanvasLayer/Sprint



func player():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump.modulate.a = 0.5
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump"):
		jump.modulate.a = 1


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	if Input.is_action_just_pressed("slide") and is_on_floor() and sliding == false:
		animation.play("slide")
		sliding = true
		slide.modulate.a = 0.5
		SPEED = 15.0
		JUMP_VELOCITY = 5.0
		
		await get_tree().create_timer(1.0).timeout
		
		sliding = true
		animation.play("RESET")	
		SPEED = 7.5
		JUMP_VELOCITY = 4.5
		await get_tree().create_timer(2.0).timeout
		sliding = false
	
	if sliding == false:
		slide.modulate.a = 1
	
	if Input.is_action_just_released("slide"):
		animation.play("RESET")	
		SPEED = 7.5
		JUMP_VELOCITY = 4.5
		slide.modulate.a = 1
		sliding = true
		await get_tree().create_timer(2.0).timeout
		sliding = false
		
	if Input.is_action_just_pressed("run"):
		SPEED = 12.5
		JUMP_VELOCITY = 6.0
		sprint.modulate.a = 0.5
	if Input.is_action_just_released("run"):
		SPEED = 7.5
		JUMP_VELOCITY = 4.5
		sprint.modulate.a = 1

	if Input.is_action_just_pressed("crouch") and crouched == false:
		print("crouching")
		animation.play("crouch")
		SPEED = 4.0
		JUMP_VELOCITY = 1.0
		crouched = true
	
	elif Input.is_action_just_pressed("crouch") and crouched == true:
		print("uncrouching")
		animation.play("RESET")
		SPEED = 7.5
		JUMP_VELOCITY = 4.5
		crouched = false
		
	var hp = GameManager.hp
	
	if hp <= 0:
		get_tree().reload_current_scene()
		hp = 100
		
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
		
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("attack"):
		animation.play("attack")

		
func _attack():
	var instance = bullet.instantiate()
	instance.position = pos.global_position
	instance.transform.basis = pos.global_transform.basis
	get_parent().add_child(instance)
		
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
