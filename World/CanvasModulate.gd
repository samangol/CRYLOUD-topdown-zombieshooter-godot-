extends CanvasModulate

const nightColor = Color.black
const dayColor = Color('#8f8f8f')
const timeRate = 0

var time = 0

func _process(delta: float) -> void:
	self.time += delta * timeRate
	self.color = nightColor.linear_interpolate(dayColor, abs(sin(time)))
