extends CharacterBody2D

const SPEED = 80

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
	velocity = dir * SPEED
	move_and_slide()
