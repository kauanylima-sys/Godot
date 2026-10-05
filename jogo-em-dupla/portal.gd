extends Area2D

const PLAYERS := ["player_1", "player_2"]

const FASE_2 := "res://fase_2.tscn"
const FASE_FINAL := "res://fase_final.tscn"

var players_no_portal: Array = []


func _on_body_entered(body: Node2D) -> void:
	if body.name in PLAYERS and not players_no_portal.has(body.name):
		players_no_portal.append(body.name)
	
	if players_no_portal.size() == PLAYERS.size():
		_trocar_de_fase()


func _on_body_exited(body: Node2D) -> void:
	players_no_portal.erase(body.name)


func _trocar_de_fase() -> void:
	var cena = get_tree().current_scene
	
	if cena.name == "fase_1":
		get_tree().change_scene_to_file.call_deferred(FASE_2)
	elif cena.name == "fase_2":
		get_tree().change_scene_to_file.call_deferred(FASE_FINAL)
