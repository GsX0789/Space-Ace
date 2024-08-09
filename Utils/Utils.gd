class_name Utils

static func SetAndStartTimer(timer : Timer, target : float, variance : float) -> void:
	timer.wait_time = randf_range(target - variance, target + variance)
	timer.start()
