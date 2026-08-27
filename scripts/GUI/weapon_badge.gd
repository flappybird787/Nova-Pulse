extends Control
class_name WeaponBadge

## which weapon this specific badge instance represents, set per-instance in the inspector
@export_enum("Missile", "Railgun", "Turbolaser") var weapon_name : String

@export var icon_rect : TextureRect
@export var title_label : Label
@export var description_label : Label

## how much to darken the whole badge while it's still locked
@export var locked_modulate : Color = Color(0.25, 0.25, 0.25, 1)

# badge flavor text/icon per weapon, keyed to match upgrade_name / weapon_name above
const BADGE_DATA = {
	"Missile": {
		"icon": "res://assets/upgrades/missile.svg",
		"title": "Missile Expert",
		"description": "Beat the game
		 using missiles"
	},
	"Railgun": {
		"icon": "res://assets/upgrades/railgun.svg",
		"title": "Railgun Expert",
		"description": "Beat the game
		 using railguns"
	},
	"Turbolaser": {
		"icon": "res://assets/upgrades/turbolaser.svg",
		"title": "Turbolaser Expert",
		"description": "Beat the game
		 using turbolasers"
	}
}

## fallback art/text shown before the badge is unlocked
const LOCKED_ICON = "res://assets/upgrades/blank_upgrade.svg"
const LOCKED_TITLE = "???"
const LOCKED_DESCRIPTION = "Locked"

func _ready() -> void:
	refresh()


## re-reads the unlock state and updates the visuals - safe to call any time
## (eg. right after a win, in case the badge is already on screen)
func refresh() -> void:
	var unlocked = AchievementManager.is_unlocked(weapon_name)

	if unlocked:
		var data = BADGE_DATA.get(weapon_name, {})
		icon_rect.texture = load(data.get("icon", ""))
		title_label.text = data.get("title", "")
		description_label.text = data.get("description", "")
		modulate = Color(1, 1, 1, 1)
	else:
		icon_rect.texture = load(LOCKED_ICON)
		title_label.text = LOCKED_TITLE
		description_label.text = LOCKED_DESCRIPTION
		modulate = locked_modulate
