extends CharacterBody2D
# velocidade e pulo
const SPEED = 120.0
const JUMP = -300.0
# ataque
var atacando = false
func _physics_process(delta):
	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	# pular
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP
	# atacar
	if Input.is_action_just_pressed("ui_select") and not atacando:
		atacando = true
		$AnimatedSprite2D.play("Ataque")
	# andar
	var dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * SPEED
	move_and_slide()
	if dir != 0:
		$AnimatedSprite2D.flip_h = dir < 0
	# animações
	if not atacando:
		if dir != 0:
			$AnimatedSprite2D.play("Andar")
		else:
			$AnimatedSprite2D.stop()
# o personagem depois do ataque
func _on_animated_sprite_2d_animation_finished():
	atacando = false
	
	
