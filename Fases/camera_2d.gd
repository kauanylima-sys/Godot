extends Camera2D

@export var suavidade := 8.0

func _ready():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position_smoothing_enabled = false
	offset = Vector2.ZERO
	top_level = true
	make_current()

func _process(delta):
	var jogadores = get_tree().get_nodes_in_group("player")
	var lider: Node2D = null
	for p in jogadores:
		if lider == null or p.global_position.x > lider.global_position.x:
			lider = p

	if lider == null:
		return

	global_position = global_position.lerp(lider.global_position, min(1.0, suavidade * delta))

	# debug: mostra todos do grupo a cada ~1 segundo
	if Engine.get_process_frames() % 60 == 0:
		var texto = "Grupo (" + str(jogadores.size()) + "): "
		for p in jogadores:
			texto += p.name + " x=" + str(snapped(p.global_position.x, 1)) + " | "
		print(texto, " LÍDER: ", lider.name)
