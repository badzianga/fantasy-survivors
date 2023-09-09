extends Control


enum BUS {
	MASTER,
	MUSIC,
	SOUNDS,
}


func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$Options/HBoxContainer/VBoxContainer/Fullscreen.button_pressed = false
	else:
		$Options/HBoxContainer/VBoxContainer/Fullscreen.button_pressed = true

	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		$Options/HBoxContainer/VBoxContainer/VSync.button_pressed = true
	else:
		$Options/HBoxContainer/VBoxContainer/VSync.button_pressed = false

	$Options/HBoxContainer/VBoxContainer/HBoxContainer/Master.value = _get_volume(BUS.MASTER)
	$Options/HBoxContainer/VBoxContainer/HBoxContainer2/Music.value = _get_volume(BUS.MUSIC)
	$Options/HBoxContainer/VBoxContainer/HBoxContainer3/Sounds.value = _get_volume(BUS.SOUNDS)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Maps/world.tscn")


func _on_options_pressed() -> void:
	_show_and_hide($Options, $MenuW)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_show_and_hide($Menu, $Options)


func _on_fullscreen_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_v_sync_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_master_value_changed(value: float) -> void:
	_set_volume(BUS.MASTER, value)


func _on_music_value_changed(value: float) -> void:
	_set_volume(BUS.MUSIC, value)


func _on_sounds_value_changed(value: float) -> void:
	_set_volume(BUS.SOUNDS, value)


func _show_and_hide(first: Control, second: Control) -> void:
	first.show()
	second.hide()


func _set_volume(bus_index: int, value: float) -> void:
	if value == -60.0:
		value = -80.0
	AudioServer.set_bus_volume_db(bus_index, value)


func _get_volume(bus_index: int) -> float:
	return AudioServer.get_bus_volume_db(bus_index)
