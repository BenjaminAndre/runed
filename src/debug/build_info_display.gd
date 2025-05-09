extends Label
var build_info: String = ""


func _ready():
    var file = FileAccess.open("res://build_info.txt", FileAccess.READ)
    if file:
        build_info = file.get_as_text()
        file.close()
    text = build_info
