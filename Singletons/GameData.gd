extends Node

enum ENEMY_TYPE { ZIPPER, BIO, BOMBER }
enum POWERUP_TYPE { HEALTH, SHIELD }

const HOMING_MISSILE_GROUP : String = "homingMissile"
const ENEMY_SHIP : String = "enemyShip"
const SAURCER_GROUP : String = "saurcer"
const ENEMY_BULLET : String = "enemyBullet"


var collisionDamage : int = 40
var missileDamage : int = 15

const POWER_UPS = {
	POWERUP_TYPE.HEALTH: preload("res://assets/misc/powerupGreen_bolt.png"),
	POWERUP_TYPE.SHIELD: preload("res://assets/misc/shield_gold.png")
}
