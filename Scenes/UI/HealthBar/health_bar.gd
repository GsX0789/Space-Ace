extends TextureProgressBar

signal died()

const COLOR_DANGER : Color = Color.RED
const COLOR_MID : Color = Color.ORANGE
const COLOR_GOOD : Color = Color.GREEN

@export var lowerHealth = 30
@export var midHealth = 75
@export var maxHealth : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetColor()

func SetColor() -> void:
	max_value = maxHealth
	value = maxHealth
	tint_progress = COLOR_GOOD
	
func IncrementBar(valueToIncrement : int) -> void:
	value += valueToIncrement
	if(value <= 0):
		died.emit()
	if(value <= lowerHealth):
		tint_progress = COLOR_DANGER
	elif(value <= midHealth):
		tint_progress = COLOR_MID
	else:
		tint_progress = COLOR_GOOD

func TakeDamage(damageAmount : int) -> void:
	IncrementBar(-damageAmount)	

		

