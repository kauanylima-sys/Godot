extends Area2D

@export var jogadores_necessarios := 1

var jogadores: Array = []
var venceu := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not jogadores.has(body):
		jogadores.append(body)

	if jogadores.size() >= jogadores_necessarios:
		_mostrar_vitoria()


func _on_body_exited(body: Node2D) -> void:
	jogadores.erase(body)


func _mostrar_vitoria() -> void:
	if venceu:
		return
	venceu = true

	var camada = CanvasLayer.new()

	var fundo = ColorRect.new()
	fundo.color = Color(0, 0, 0, 0.6)
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	camada.add_child(fundo)

	var label = Label.new()
	label.text = "VITÓRIA!"
	label.add_theme_font_size_override("font_size", 64)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	camada.add_child(label)

	get_tree().current_scene.add_child(camada)
	get_tree().paused = true
