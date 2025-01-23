extends CharacterBody2D

# Preload and onready variables
@onready var at = $AnimationTree  # Reference to the AnimationTree node

# Exported variables for movement and state control
@export var speed: float = 100.0  # Movement speed
@export var isIdle: bool = true  # Indicates if the character is idle
@export var isWalking: bool = false  # Indicates if the character is walking
@export var isRunning: bool = false  # Indicates if the character is running
@export var input_direction: Vector2 = Vector2.ZERO  # Stores the direction of input

# Process function called every frame
func _process(_delta: float) -> void:
	input_direction = Input.get_vector("left", "right", "up", "down")  # Get input direction
	out_of_combat_move()  # Handle movement when out of combat

# Physics process function called every physics frame
func _physics_process(_delta: float) -> void:
	move()  # Handle movement

# Function to handle character movement
func move() -> void:
	if input_direction != Vector2.ZERO:
		velocity = input_direction * speed  # Calculate velocity based on input direction and speed
		move_and_slide()  # Move the character
		isWalking = true  # Set walking state
		isIdle = false  # Set idle state
	else:
		input_direction = Vector2.ZERO  # Reset input direction
		isIdle = true  # Set idle state
		isWalking = false  # Set walking state

# Function to update walking animation state
func set_walking(value: bool) -> void:
	at.set("parameters/conditions/isWalking", value)  # Set walking condition in AnimationTree
	at.set("parameters/conditions/isIdle", not value)  # Set idle condition in AnimationTree

# Function to update running animation state
func set_running(value: bool) -> void:
	at.set("parameters/conditions/isWalking", not value)  # Disable walking condition in AnimationTree
	at.set("parameters/conditions/isIdle", not value)  # Disable idle condition in AnimationTree
	at.set("parameters/conditions/isRunning", value)  # Set running condition in AnimationTree

# Function to update blend positions for animations
func move_position() -> void:
	at.set("parameters/Idle/blend_position", input_direction)  # Set blend position for idle animation
	at.set("parameters/Walk/blend_position", input_direction)  # Set blend position for walk animation
	at.set("parameters/Run/blend_position", input_direction)  # Set blend position for run animation

# Function to handle movement when out of combat
func out_of_combat_move() -> void:
	if input_direction != Vector2.ZERO:
		set_walking(true)  # Update walking animation
		move_position()  # Update animation blend positions
	else:
		set_walking(false)  # Update walking animation
		if isRunning:
			isRunning = false  # Reset running state
			set_running(false)  # Update running animation
			speed = 100  # Reset speed

	if isRunning:
		isWalking = false  # Reset walking state
		set_running(true)  # Update running animation
		speed = 175  # Increase speed for running
