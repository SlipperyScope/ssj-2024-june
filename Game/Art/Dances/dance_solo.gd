extends AnimatedSprite2D

func _ready():
	sprite_frames.set_animation_speed("shuffle",2)
	play("shuffle")
	$Music.play()
