extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_execute"):
		var items: Array[PortfolioItemsCollection.PortfolioItem] = []
		for card: Card in $Cards.get_children():
			if card.picked:
				items.append(card.item)
		
		execute_card_sequence(items)
		
		# TODO: remove picked cards (in Cards)
		
		get_viewport().set_input_as_handled()


func execute_card_sequence(items: Array[PortfolioItemsCollection.PortfolioItem]) -> void:
	## NUMBER OF CARDS SEQUENCE 
	print(str("Card count of ", items.size()))
	
	
	## DUPLICATE SEQUENCE
	print("--DUPLICATE SEQUENCE--")
	
	# Get all duplicates
	var dup_items: Array[PortfolioItemsCollection.PortfolioItem] = items.duplicate()
	while dup_items.size() != 0:
		# Get the item that is to be duplicated
		var item := dup_items[0]
		var duplicate_count := 1
		
		# Get the amount of duplicates of this item
		for i in range(1, dup_items.size()):
			if dup_items[i].title == item.title:
				duplicate_count += 1
		
		# Don't continue if no duplicates found
		if duplicate_count >= 2:
			print(str("Duplicate count of ", duplicate_count, " for ", item.title))
			pass
		
		# Remove all duplicates
		dup_items = dup_items.filter(func (it: PortfolioItemsCollection.PortfolioItem): return it.title != item.title)
	
	
	## LINK SEQUENCE
	print("--LINK SEQUENCE--")
	
	# Get total link count
	var link_count := 0
	for item in items:
		link_count += item.link_texts.size()
	
	print(str("Link count of ", link_count))
	
	
	## DUPLICATE TAG SEQUENCE
	print("--DUPLICATE TAG SEQUENCE--")
	
	# Get duplicate tags
	for tag in PortfolioTagsCollection.portfolio_tags:
		var tag_count := 0
		
		for item in items:
			if tag in item.tags:
				tag_count += 1
		
		if tag_count >= 2:
			print(str("Duplicate tag of ", tag_count, " for ", tag))
