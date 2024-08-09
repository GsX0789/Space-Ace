extends Node

signal on_powerUp_hit(powerUp : GameData.POWERUP_TYPE)
signal on_player_hit(damage : int)
signal on_player_life_bonus(amount : int)
signal on_player_scored(score_amount : int)
signal on_player_death()
