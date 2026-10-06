extends Area2D

@export_file("*.tscn") var proxima_fase: String = ""   # opcional: se vazio, usa a próxima numérica
@export var jogadores_necessarios := 1
@export var tempo_vitoria := 1.5

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


# Descobre o caminho da próxima fase: Fase_1.tscn -> Fase_2.tscn
func _achar_proxima_fase() -> String:
	if proxima_fase != "":
		return proxima_fase

	var atual = get_tree().current_scene.scene_file_path   # ex: res://Fase_1.tscn
	var regex = RegEx.new()
	regex.compile("(\\d+)(\\.tscn)$")
	var m = regex.search(atual)
	if m == null:
		return ""

	var numero = int(m.get_string(1)) + 1
	return atual.substr(0, m.get_start(1)) + str(numero) + ".tscn"


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

	# o timer ignora a pausa
	await get_tree().create_timer(tempo_vitoria, true).timeout

	# despausar antes de trocar, senão a próxima fase começa travada
	get_tree().paused = false

	var destino = _achar_proxima_fase()
	print("Portal: indo para '", destino, "'")

	if destino == "" or not ResourceLoader.exists(destino):
		push_error("Portal: cena não encontrada: '" + destino + "'. Escolha a fase no Inspetor.")
		return

	var erro = get_tree().change_scene_to_file(destino)
	if erro != OK:
		push_error("Portal: erro ao trocar de cena, código: " + str(erro))
