extends CPUParticles2D


func _ready():
	emitting = true

func _on_finished():
	call_deferred("queue_free")
