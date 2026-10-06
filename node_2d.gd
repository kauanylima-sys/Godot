extends CharacterBody2D
# velocidade e pulo
const SPEED = 150.0
const JUMP = -300.0
const LIMITE_QUEDA = 800.0
# ataque
var atacando = false
# morte e reaparecer
var morto = false
var posicao_inicial: Vector2

func _ready():
	add_to_group("player")   # <-- LINHA NOVA: a câmera acha o personagem por aqui
	posicao_inicial = global_position
	# conecta o sinal pelo código (não conecte também pela janela de sinais)
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(delta):
	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# pular com W
	if Input.is_physical_key_pressed(KEY_W) and is_on_floor():
		velocity.y = JUMP

	# andar com A (esquerda) e D (direita)
	var dir = 0.0
	if Input.is_physical_key_pressed(KEY_A):
		dir -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		dir += 1.0
	velocity.x = dir * SPEED

	move_and_slide()

	# checa se encostou nos espinhos
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)
		var objeto = colisao.get_collider()
		if objeto != null and objeto.name == "Espinhos":
			morrer()

	# checa se caiu da fase
	if global_position.y > LIMITE_QUEDA:
		morrer()

	if dir != 0:
		$AnimatedSprite2D.flip_h = dir < 0

	# animações
	if not atacando:
		if dir != 0:
			$AnimatedSprite2D.play("Andar")
		else:
			$AnimatedSprite2D.play("Parado")

func morrer():
	if morto:
		return
	morto = true
	set_physics_process(false)
	$AnimatedSprite2D.stop()
	await get_tree().create_timer(0.5).timeout
	global_position = posicao_inicial
	velocity = Vector2.ZERO
	atacando = false
	morto = false
	set_physics_process(true)

# personagem depois do ataque
func _on_animated_sprite_2d_animation_finished():
	atacando = false
