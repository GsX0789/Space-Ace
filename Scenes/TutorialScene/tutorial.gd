extends Control

@onready var info_1_en: Label = $MC/Info1_EN
@onready var info_1_br: Label = $MC/Info1_BR
@onready var info_2_en: Label = $MC/Info2_EN
@onready var info_2_br: Label = $MC/Info2_BR
@onready var info_3_en: Label = $MC/Info3_EN
@onready var info_3_br: Label = $MC/Info3_BR
@onready var info_4_en: Label = $MC/Info4_EN
@onready var info_4_br: Label = $MC/Info4_BR

var enList = []
var brList = [] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enList = [info_1_en,info_2_en,info_3_en,info_4_en]
	brList = [info_1_br,info_2_br,info_3_br,info_4_br]
	
func BrTranslation() -> void:
	for br in brList:
		br.show()
	for en in enList:
		en.hide()
		
func EnTranslation() -> void:
	for br in brList:
		br.hide()
	for en in enList:
		en.show()


func _on_br_translation_pressed() -> void:
	BrTranslation()


func _on_en_translation_pressed() -> void:
	EnTranslation()


func _on_back_to_menu_pressed() -> void:
	GameManager.LoadMainScene()
