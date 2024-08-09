extends ParallaxBackground

@onready var parallax_layer_1: ParallaxLayer = $ParallaxLayer1
@onready var parallax_layer_2: ParallaxLayer = $ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxLayer3

const SCROLL_SPEED : float = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parallax_layer_1.motion_offset.y += SCROLL_SPEED * delta * 0.2
	parallax_layer_2.motion_offset.y += SCROLL_SPEED * delta * 0.3
	parallax_layer_3.motion_offset.y += SCROLL_SPEED * delta * 0.4

func SetRunning(isRunning : bool) -> void:
	set_process(isRunning)
