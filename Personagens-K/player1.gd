extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

@export var altura_limite: float = 1000.0

var posicao_inicial: Vector2


func _ready() -> void:
	posicao_inicial = global_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if global_position.y > altura_limite:
		renascer()


func renascer() -> void:
	global_position = posicao_inicial
	velocity = Vector2.ZERO
