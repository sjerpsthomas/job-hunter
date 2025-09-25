extends Node2D


@onready var panel := $Panel as Panel
@onready var background_rect := $Panel/Background as TextureRect
@onready var title_label := $Panel/Title as Label
@onready var subtitle_label := $Panel/Subtitle as Label
@onready var image_rect := $Panel/Image as TextureRect
@onready var tags_label := $Panel/Tags as Label
@onready var description_label := $Panel/Description as Label
@onready var links_label := $Panel/Links as Label


var collapsed := false

var link_texts: Array[String]

var target_size := Vector2(800, 600)
var target_tags_label_position := Vector2(24, 250)
var target_links_label_position := Vector2(24, 494)
var target_background_rect_alpha := 0.0


# (Initializes the card's content)
func initialize(item: PortfolioItemsCollection.PortfolioItem) -> void:
	background_rect.texture = item.image
	title_label.text = item.title
	subtitle_label.text = item.subtitle
	image_rect.texture = item.image
	tags_label.text = "    ".join(item.tags)
	description_label.text = item.description.replace("\n", " ").replace(" ", "  ").strip_edges()
	
	link_texts = item.link_texts
	expand()


func _process(_delta: float) -> void:
	# TODO: delta-independent tweening (talk by Freya Holmer)
	
	panel.size = panel.size.lerp(target_size, 0.1)
	panel.position = -panel.size / 2
	tags_label.position = tags_label.position.lerp(target_tags_label_position, 0.15)
	links_label.position = links_label.position.lerp(target_links_label_position, 0.1)
	background_rect.modulate.a = lerpf(background_rect.modulate.a, target_background_rect_alpha, 0.08)


func collapse() -> void:
	target_size = Vector2(456, 264)
	target_tags_label_position = Vector2(24, 146)
	tags_label.size.x = 432
	target_links_label_position = Vector2(24, 158)
	target_background_rect_alpha = 1.0
	
	var link_count := link_texts.size()
	links_label.text = str(link_count, "  link", "" if link_count == 1 else "s")
	
	collapsed = true

func expand() -> void:
	target_size = Vector2(800,600)
	target_tags_label_position = Vector2(24, 250)
	tags_label.size.x = 752
	target_links_label_position = Vector2(24, 494)
	target_background_rect_alpha = 0.0
	
	links_label.text = "    ".join(link_texts)
	
	collapsed = false
