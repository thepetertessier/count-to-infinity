# fast_set.gd
class_name FastSet

# Internal storage
var _elements: Array    # dynamic array of the elements
var _pos: Dictionary    # maps element -> its index in _elements

func _init():
	_elements = []
	_pos = {}

# Adds `x` if not already present. Returns true if added, false if it was already in the set.
func add(x) -> bool:
	if _pos.has(x):
		return false
	_elements.append(x)
	_pos[x] = _elements.size() - 1
	return true

# Removes `x` if present. Returns true if removed, false if it wasn't in the set.
func remove(x) -> bool:
	if not _pos.has(x):
		return false
	var idx: int = _pos[x]
	var last = _elements[_elements.size() - 1]
	# Move last element into idx
	_elements[idx] = last
	_pos[last] = idx
	# Pop off the end
	_elements.pop_back()
	_pos.erase(x)
	return true

# Pops and returns *some* element (the last one in the array), or `null` if empty.
func pop_any() -> Variant:
	if _elements.is_empty():
		return null
	var x = _elements[_elements.size() - 1]
	_pos.erase(x)
	_elements.pop_back()
	return x

# Optional: check membership in O(1)
func has(x) -> bool:
	return _pos.has(x)

# Optional: get current size
func size() -> int:
	return _elements.size()
