extends Resource
class_name BackgroundHistory

@export var max_history: int = 5
var history: Array[String] = []

# Add a new entry to the front of the history
func add(entry: String) -> void:
	history.insert(0, entry)
	if history.size() > max_history:
		history.remove_at(history.size() - 1)

# Check if an entry is in the recent history
func contains(entry: String) -> bool:
	return entry in history

# Clear the history
func clear() -> void:
	history.clear()
