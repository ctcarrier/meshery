package common

import rego.v1

path(obj, mutated) if {
	patch_array(obj, mutated)
}

patch_array(arr, mutated) := path if {
	contains(arr, "_")
	index := array_pos(arr)
	prefix_path := array.slice(arr, 0, index)
	suffix_path := array.slice(arr, index + 1, count(arr))
	value_to_patch := object.get(mutated, prefix_path, "")
	array_index_to_be_patched := array_index_to_patch(count(value_to_patch))
	intermediate_path := array.concat(prefix_path, [array_index_to_be_patched])
	path := array.concat(intermediate_path, suffix_path)
}

patch_array(arr, mutated) := path if {
	not "_" in arr
	path := arr
}

array_index_to_patch(no_of_elements) := index if {
	no_of_elements == 0

	# 0 based array indexing is followed
	index := "0"
}

array_index_to_patch(no_of_elements) := index if {
	not no_of_elements == 0

	# 0 based array indexing is followed
	index := format_int(no_of_elements - 1, 10)
}

array_pos(arr_path) := k if {
	some "_", k in arr_path
}

extract_components(services, selectors) := {component.traits.meshmap.id: component |
	selector := selectors[_]
	service := services[_]
	is_relationship_feasible(selector, service.type)
	component := service
}

is_relationship_feasible(selector, compType) if {
	selector.kind == "*"
}

is_relationship_feasible(selector, compType) if {
	selector.kind == compType
}

has_key(x, k) if {
	x[k]
}
