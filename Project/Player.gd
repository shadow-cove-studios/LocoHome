extends CharacterBody3D
var captureMouse = false
@onready var camera = $head/Camera3D
@onready var head = $head
var jumpForce = 10
var gravity = 9.81
const sensitivity = 0.003
var direction = 0.0
var movementVector = 0
var lookVector = 0
var speed = 10
func _unhandled_input(event):
	if event is InputEventMouseMotion and captureMouse:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("Left","Right","forward","Backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	if Input.is_action_just_pressed("Toggle MouseLock"):
		captureMouse = not captureMouse
		if captureMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_MAX)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity*delta
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = jumpForce
	if Input.is_action_pressed("forward"):
		pass
	move_and_slide()
