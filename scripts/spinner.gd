extends Node2D

var rot = 0
var speed = 20
var accel = 0
var d = 0
var cen = Vector2(500,500)
var rewards = [ ]
var lines = [ ]
var rad = 350
var col = Color(255,0,0)
var h = 100
var w = 200
var done = 100
@export var addblood: int = 0

signal spun


func addReward(odds, value):
	var label = Label.new()
	label.text = str(value)
	label.position = Vector2(200, 200)  # where the label is placed
	label.add_theme_font_size_override("font_size", 60)
	label.set_size(Vector2(w,h))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(label)
	
	#label.set_size(Vector2(200, 50))  # set a known size
	#label.pivot_offset = label.rect_size / 2  # set pivot to center
	
	
	rewards.append([odds,value,label])

func _process(delta: float) -> void:
	if (d == 0):
		addReward(50,50)
		addReward(50,100)
		addReward(100,25)
		addReward(25,200)
		addReward(10,1000)
	d += delta
	speed -= accel*delta
	if (speed < 0): 
		speed = 0
	rot += speed*delta
	cen = Vector2(get_viewport_rect().size / 2)
	
	lines.clear()
	lines.append(Vector2(sin(rot)*rad,cos(rot)*rad)+cen)
	var oddSum = 0
	var tempSum = 0
	for x in rewards:
		oddSum += x[0]
		
	for x in rewards:
		tempSum += x[0]
		var offset = 2*PI*tempSum/oddSum
		if fmod(rot+offset,2*PI) < done and speed == 0 and fmod(rot+offset,2*PI) > PI/2:
			addblood = x[1]
			print(str(fmod(rot+offset,2*PI)/PI))
			print(str(x[1]))
			spun.emit()
			done = fmod(rot+offset,2*PI)
		lines.append(Vector2(sin(rot+offset)*rad,cos(rot+offset)*rad)+cen)
	for i in rewards.size():
		var middle
		if i == rewards.size():
			middle = (Vector2(sin(rot)*rad,cos(rot)*rad)) + lines[i] - cen
		else:
			middle = lines[i]+lines[i+1]-2*cen
		var temp_ang = middle.angle()
		#var r = 100 + rad/2
		#var a = atan(50/r)
		#var p = a*r/(r+100)
		middle = cen + Vector2(cos(temp_ang)*rad/1.3,sin(temp_ang)*rad/1.3)-Vector2(w/2*cos(temp_ang),w/2*sin(temp_ang))+Vector2(h/2*sin(temp_ang),-h/2*cos(temp_ang))
		rewards[i][2].position = middle
		rewards[i][2].rotation = temp_ang
	
	
	
	queue_redraw()
	

func _draw() -> void:
	draw_circle(cen,rad,col)
	for x in lines:
		draw_line(cen,x,Color(0,0,0),3)
	

func _on_stop_wheel_pressed() -> void:
	accel = 5
	
