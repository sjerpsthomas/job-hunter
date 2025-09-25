extends Node


signal finished


var portfolio_tags: Array[String]


# (Assigns the portfolio tags, according to the response object)
func assign(response: Array) -> void:
	portfolio_tags = []
	portfolio_tags.assign(response)
	
	print("tags done")
	
	finished.emit()
