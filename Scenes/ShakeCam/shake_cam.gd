extends Camera2D

const RANGE_OFFSET : Vector2 = Vector2(-5.0,5.0)

#Shake time and offset!!
@onready var shake_time: Timer = $ShakeTime
var shake_offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	#Setting the default values
	shake_offset = offset
	SignalManager.on_player_hit.connect(on_player_hit)
	set_process(false)

func _process(delta: float) -> void:
	#Only works it set_process is set to true
	ShakeCam()

func GetRandomShakeAmount() -> float:
	#Get a random value between -5 and 5
	return randf_range(RANGE_OFFSET.x, RANGE_OFFSET.y)

func ShakeCam() -> void:
	offset = Vector2(
		shake_offset.x + GetRandomShakeAmount(),
		shake_offset.y + GetRandomShakeAmount()
	)
	
func on_player_hit(v : int) -> void:
	set_process(true)
	shake_time.start()

func _on_shake_time_timeout() -> void:
	set_process(false)
