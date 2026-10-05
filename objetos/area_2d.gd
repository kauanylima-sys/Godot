extends Area2D

@export_file("*.tscn") var proxima_fase: String
@export var mostrar_vitoria := false
func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null or global_position.distance_to(player.global_position) > 60:
		return
	set_physics_process(false)
	if mostrar_vitoria:
		var camada = CanvasLayer.new()
		var label = Label.new()
		label.text = "VITÓRIA!"
		label.add_theme_font_size_override("font_size", 64)
		label.position = Vector2(400, 250)
		camada.add_child(label)
		add_child(camada)
		get_tree().paused = true
	elif proxima_fase != "":
		get_tree().change_scene_to_file.call_deferred(proxima_fase)
