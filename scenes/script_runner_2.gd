extends Sprite2D

var rot = 0
var velocity = -20
var accel = 0
var cen = Vector2(500,500)
var rad = 350
@export var addblood: int = 0

signal spun

func _ready():
	# took this code for how to draw this circle from chatgpt
	# Set the size of the sprite based on the radius
	self.texture = load("res://assets/images/blood-wood-texture.png")
	var tex_size = texture.get_size()
	var desired_size = rad * 2.0
	var scale_factor = desired_size / tex_size.x  # assume square texture
	self.scale = Vector2(scale_factor, scale_factor)
	
func _process(delta: float) -> void:
	velocity += accel*delta
	if (velocity > 0): 
		velocity = 0
	rot = velocity*delta
	cen = Vector2(get_viewport_rect().size / 2)
		
	self.rotate(rot)
	
	queue_redraw()
	

func _draw() -> void:	
	# took this code for how to draw this circle from chatgpt
	position = cen
	var mat = ShaderMaterial.new()
	mat.shader = Shader.new()
	mat.shader.code = """
		shader_type canvas_item;
		void fragment() {
			vec2 uv = UV - vec2(0.5);
			if (length(uv) > 0.5) {
				discard;
			}
			COLOR = texture(TEXTURE, UV);
		}
	"""
	self.material = mat
	

func _on_stop_wheel_pressed() -> void:
	accel = 5
