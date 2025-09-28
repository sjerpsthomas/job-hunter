extends Node2D


var score: int = 0:
	set(new_score):
		score = new_score
		%Score.text = str("SCORE  ", score)

var shake: float

var select_count: int:
	set(new_select_count):
		select_count = new_select_count
		%UI.set_select_count(select_count)

var discard_count: int:
	set(new_discard_count):
		discard_count = new_discard_count
		%UI.set_discard_count(discard_count)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_execute"):
		var items: Array[PortfolioItemsCollection.PortfolioItem] = []
		for card: Card in %Cards.get_children():
			if card.picked:
				items.append(card.item)
		
		execute_card_sequence(items)
		
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	position = Vector2(randf(), randf()) * shake
	shake = lerpf(shake, 0, 0.1)


func execute_card_sequence(items: Array[PortfolioItemsCollection.PortfolioItem]) -> void:
	## PROLOG
	if %Cards.collapse_all():
		await get_tree().create_timer(1).timeout
	
	## NUMBER OF CARDS SEQUENCE
	var card_count := items.size()
	
	spawn_text(str(card_count, " CARDS"))
	score += card_count
	do_shake(2 * card_count)
	
	await get_tree().create_timer(1).timeout
	
	
	## LINK SEQUENCE
	var link_count := 0
	for item in items:
		link_count += item.link_texts.size()
	
	spawn_text(str(link_count, " TOTAL LINKS"))
	score += 2 * link_count
	do_shake(3 * link_count)
	
	await get_tree().create_timer(1).timeout
	
	
	## COMMON TAG SEQUENCE
	var common_tag_multiplier := 1
	
	for tag in PortfolioTagsCollection.portfolio_tags:
		var tag_count := 0
		var common := true
		
		for item in items:
			if tag in item.tags:
				tag_count += 1
			else:
				common = false
		
		if common and tag_count >= 2:
			spawn_text(str(tag_count, " COMMON ", tag.to_upper(), " TAGS (x", common_tag_multiplier, ")"))
			do_shake(3 * 5 * tag_count * common_tag_multiplier)
			
			score += 5 * tag_count * common_tag_multiplier
			common_tag_multiplier += 1
			
			await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	
	## DUPLICATE SEQUENCE
	var dup_items: Array[PortfolioItemsCollection.PortfolioItem] = items.duplicate()
	var duplicate_multiplier := 1
	
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
			spawn_text(str(duplicate_count, " DUPLICATE ", item.title.to_upper(), " (x", duplicate_multiplier, ")"))
			do_shake(5 * 5 * duplicate_count * duplicate_multiplier)
			
			score += 10 * duplicate_count * duplicate_multiplier
			duplicate_multiplier += 1
			
			await get_tree().create_timer(0.5).timeout
		
		# Remove all duplicates
		dup_items = dup_items.filter(func (it: PortfolioItemsCollection.PortfolioItem): return it.title != item.title)
	
	await get_tree().create_timer(0.5).timeout
	
	## EPILOG
	%Cards.discard_and_redraw()
	
	await get_tree().create_timer(0.5).timeout


func spawn_text(text_str: String) -> void:
	%CardSequenceTexts.spawn_text(text_str)

func do_shake(new_shake: float) -> void:
	shake = new_shake
	
