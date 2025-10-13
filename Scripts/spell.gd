extends Area3D

var speed = 50
var lifetime = 3.0
@onready var audio = $AudioStreamPlayer3D

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	var forward = -transform.basis.z 
	forward.y = 0 
	forward = forward.normalized() 
	position += forward * -speed * delta

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("enemy"):
		body.hp -= 25
		audio.play()
		print("Enemy Hit")
		queue_free()
