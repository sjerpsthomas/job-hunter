extends Node


class PortfolioItem:
	var title: String
	var subtitle: String
	var image: Texture
	var tags: Array[String]
	var description: String
	var link_texts: Array[String]
	
	# -
	func _init(dict: Dictionary) -> void:
		# Error handling
		@warning_ignore("standalone_expression")
		if ["id", "title", "subtitle", "tagIds", "description", "linkTexts"].any(func (it: String): not (it in dict)):
			push_error("Conversion error")
			LoadingScreen.has_error = true
			return
		
		# Assignment
		title = String(dict["title"])
		subtitle = String(dict["subtitle"])
		# (image handled later)
		tags = []
		tags.assign(dict["tags"] as Array)
		description = String(dict["description"])
		link_texts = []
		link_texts.assign((dict["links"] as Array).map(func (it): return it["text"]))


signal finished


var portfolio_items: Array[PortfolioItem]

var image_response_count := 0
var image_response_size: int


# (Assigns the portfolio items, according to the response object)
func assign(response: Array) -> void:
	portfolio_items = []
	portfolio_items.assign(response.map(func (dict: Dictionary): return PortfolioItem.new(dict)))
	
	# TEMP: load temp images from disk maybe
	var actually_load_images = true
	if not actually_load_images:
		print("items done")
		finished.emit()
	
	image_response_count = 0
	image_response_size = response.size()
	
	# Make requests for images
	for i in range(response.size()):
		# Get dict, image url
		var image_url: String = "https://www.thomassjerps.nl" + response[i]["image"]
		
		if not actually_load_images:
			# TEMP: load temp image from disk
			portfolio_items[i].image = preload("res://core/card/foto.png")
			continue
		
		var http_request := HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_http_request_completed.bind(i, image_url))

		var error := http_request.request(image_url)
		if error != OK:
			LoadingScreen.has_error = true
			push_error("HTTP error")
			return


func _http_request_completed(
	result: int,
	_response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
	index: int,
	url: String
):
	# Error handling
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("HTTP error")
		LoadingScreen.has_error = true
		return
	
	# Get extension, load image from buffer
	var ext = url.get_extension()
	var image := Image.new()
	var error: Error
	match ext:
		'jpg': error = image.load_jpg_from_buffer(body)
		'png': error = image.load_png_from_buffer(body)
	
	# Error handling
	if error != OK:
		push_error("Image error")
		LoadingScreen.has_error = true
		return
	
	# Create texture
	var texture := ImageTexture.create_from_image(image)
	
	# Assign to portfolio item
	portfolio_items[index].image = texture
	
	prints(url,'size:',texture.get_size())
	
	image_response_count += 1
	if image_response_count == image_response_size:
		print("items done")
		finished.emit()
