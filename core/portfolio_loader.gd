class_name LoadingScreen
extends Node2D


static var has_error := false

var collection_response_count := 0
var collection_response_size: int

var is_finished := false

signal finished
signal errored


# -
func _ready():
	collection_response_count = 0
	collection_response_size = 2
	
	request_portfolio_items()
	request_portfolio_tags()


# (Finishes loading)
func finish() -> void:
	is_finished = true
	finished.emit()


# -
func _process(_delta: float) -> void:
	if has_error:
		errored.emit()


# (Calls portfolio items HTTP request)
func request_portfolio_items() -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_portfolio_items_completed)

	var error = http_request.request("https://www.thomassjerps.nl/api/jh-portfolio-items?locale=" + Locale.locale)
	print("sent request to /api/jh-portfolio-items/")
	if error != OK:
		push_error("HTTP error")
		has_error = true


# (Handles portfolio items HTTP request)
func _portfolio_items_completed(
	result: int,
	_response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
):
	# Error handling
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("HTTP error: " + str(result))
		has_error = true
		return
	
	# Get response as array of dicts, pass to collection
	var body_text := body.get_string_from_utf8()
	var response: Array = JSON.parse_string(body_text)
	PortfolioItemsCollection.finished.connect(_on_collection_finished)
	PortfolioItemsCollection.assign(response)


# (Calls portfolio tags HTTP request)
func request_portfolio_tags() -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_portfolio_tags_completed)

	var error := http_request.request("https://www.thomassjerps.nl/api/jh-portfolio-tags?locale=" + Locale.locale)
	print("sent request to /api/jh-portfolio-tags/")
	if error != OK:
		push_error("HTTP error")
		has_error = true


# (Handles portfolio items HTTP request)
func _portfolio_tags_completed(
	result: int,
	_response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
):
	# Error handling
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("HTTP error: " + str(result))
		has_error = true
		return
	
	# Get response as array of dicts, pass to collection
	var body_text = body.get_string_from_utf8()
	var response: Array = JSON.parse_string(body_text)
	PortfolioTagsCollection.finished.connect(_on_collection_finished)
	PortfolioTagsCollection.assign(response)


# (Handles a collection finishing its ingestion)
func _on_collection_finished() -> void:
	print("someone finished!")
	
	collection_response_count += 1
	
	if collection_response_count == collection_response_size:
		print("done!")
		call_deferred("finish")
