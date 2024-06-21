# A container with button signals
class_name ButtonContainer extends PanelContainer

signal button_down
signal button_up
signal pressed
signal toggled

# Button to forward signals from
@export var _ButtonPath:NodePath

var InnerButton

var action_mode:
	get: return InnerButton.action_mode
	set(value): InnerButton.action_mode = value
var button_group:
	get: return InnerButton.button_group
	set(value): InnerButton.button_group = value
var button_mask:
	get: return InnerButton.button_mask
	set(value): InnerButton.button_mask = value
var button_pressed:
	get: return InnerButton.button_pressed
	set(value): InnerButton.button_pressed = value
var disabled:
	get: return InnerButton.disabled
	set(value): InnerButton.disabled = value
var keep_pressed_outside:
	get: return InnerButton.keep_pressed_outside
	set(value): InnerButton.keep_pressed_outside = value
var toggle_mode:
	get: return InnerButton.toggle_mode
	set(value): InnerButton.toggle_mode = value

func _pressed(): InnerButton._pressed()
func _toggled(toggled_on:bool): InnerButton._toggled(toggled_on)
func is_hovered(): InnerButton.is_hovered()
func set_pressed_no_signal(state:bool): InnerButton.set_pressed_no_signal(state)

func Monitor(button):
	var inner = InnerButton
	if inner:
		inner.button_down.disconnect(_on_button_down)
		inner.button_up.disconnect(_on_button_up)
		inner.pressed.disconnect(_on_pressed)
		inner.toggled.disconnect(_on_toggled)
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)
	button.pressed.connect(_on_pressed)
	button.toggled.connect(_on_toggled)
	InnerButton = button
	
func _ready():
	Monitor(get_node(_ButtonPath))

func _on_button_down(): button_down.emit()
func _on_button_up(): button_up.emit()
func _on_pressed(): pressed.emit()
func _on_toggled(state:bool): toggled.emit(state)
