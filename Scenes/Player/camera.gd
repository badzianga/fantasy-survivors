extends Camera2D


func _ready() -> void:
	var top_left := $Positions/TopLeft
	limit_left = top_left.position.x
	limit_top = top_left.position.y
	
	var bottom_right := $Positions/BottomRight
	limit_right = bottom_right.position.x
	limit_bottom = bottom_right.position.y
