class_name OSM extends Node

enum Msg {
	Initialize,
	Open,
	Close,
	Minimize,
	Maximize
}

enum FappType {
	Fapplet,
	Launcher,
	Widget
}

## Info about installed fapps
class FappInfo:
	## Fapplet manifest DO NOT MODIFY
	var Manifest:Manifest
	## True if fapp has been instantiated
	var Installed:bool
	## Ref to the scene instance
	var Instance:Fapplet
	## True if app can execute code
	var Running:bool
	## True if app is in the foreground
	var Active:bool
