extends CharacterBody2D

const SPEED = 80
var boat

const EMBARK_THRESHOLD = 50

func _ready():
	$SpawnParticles.emitting = true

func _physics_process(_delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir.x:
		$Anim.play("side")
		$Anim.flip_h = not dir.x > 0
	elif dir.y > 0:
		$Anim.play("forward")
	elif dir.y < 0:
		$Anim.play("backward")
	else:
		$Anim.play("idle")
	if Input.is_action_just_pressed("exit_boat") and global_position.distance_to(boat.global_position) < EMBARK_THRESHOLD:
		boat.embark()
		call_deferred("queue_free")
	velocity = dir * SPEED
	move_and_slide()
