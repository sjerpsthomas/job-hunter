class_name MainScreen
extends Node2D


var score: int = 0:
	set(new_score):
		score = new_score
		%Score.text = str("SCORE  ", score)

var shake: float
var pitch: int

enum State {
	NORMAL,
	EXECUTING,
	GAME_OVER
}

var state := State.NORMAL

var select_count: int:
	set(new_select_count):
		select_count = new_select_count
		%UI.set_select_count(select_count)

var discard_count: int:
	set(new_discard_count):
		discard_count = new_discard_count
		%UI.set_discard_count(discard_count)


func _unhandled_input(event: InputEvent) -> void:
	if state == State.NORMAL and event.is_action_pressed("ui_execute"):
		var items: Array[PortfolioItemsCollection.PortfolioItem] = []
		for card: Card in %Cards.get_children():
			if card.picked:
				items.append(card.item)
		
		if items.is_empty():
			pass
		else:
			execute_card_sequence(items)
		
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	position = Vector2(0.5 - randf(), 0.5 - randf()) * shake
	shake = lerpf(shake, 0, 0.1)


func execute_card_sequence(items: Array[PortfolioItemsCollection.PortfolioItem]) -> void:
	const SHORT := 1.0
	const LONG := 1.0
	
	## PROLOG
	pitch = 0
	state = State.EXECUTING
	
	if %Cards.collapse_all():
		await get_tree().create_timer(LONG).timeout
	
	
	## NUMBER OF CARDS SEQUENCE
	var card_count := items.size()
	
	spawn_text(str(card_count, " ", Locale.txt('cards' if card_count != 1 else 'card')))
	score += card_count
	do_shake(2 * card_count)
	
	await get_tree().create_timer(LONG).timeout
	
	
	## LINK SEQUENCE
	var link_count := 0
	for item in items:
		link_count += item.link_texts.size()
	
	spawn_text(str(link_count, " ", Locale.txt('links' if link_count != 1 else 'link')))
	score += 5 * link_count
	do_shake(3 * link_count)
	
	await get_tree().create_timer(LONG).timeout
	
	
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
			spawn_text(str(tag_count, " ", Locale.txt('common_tags_1'), " '", tag.to_upper(), "'", Locale.txt('common_tags_2'), " (x", common_tag_multiplier, ")"))
			do_shake(3 * 5 * tag_count * common_tag_multiplier)
			
			score += 10 * tag_count * common_tag_multiplier
			common_tag_multiplier += 1
			
			await get_tree().create_timer(SHORT).timeout
	
	
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
			spawn_text(str(duplicate_count, " ", Locale.txt('duplicate_1'), " '", item.title.to_upper(), "'", Locale.txt('duplicate_2'), " (x", duplicate_multiplier, ")"))
			do_shake(5 * 5 * duplicate_count * duplicate_multiplier)
			
			score += 20 * duplicate_count * duplicate_multiplier
			duplicate_multiplier += 1
			
			await get_tree().create_timer(SHORT).timeout
		
		# Remove all duplicates
		dup_items = dup_items.filter(func (it: PortfolioItemsCollection.PortfolioItem): return it.title != item.title)
	
	
	## EPILOG
	if select_count == 0:
		state = State.GAME_OVER
		%GameOver.init()
	else:
		state = State.NORMAL
		%Cards.discard_and_redraw()
		
		await get_tree().create_timer(SHORT).timeout


func spawn_text(text_str: String) -> void:
	%CardSequenceTexts.spawn_text(text_str)
	AudioManager.play_score(pitch)
	pitch += 1
	print(text_str)

func do_shake(new_shake: float) -> void:
	shake = new_shake
	
