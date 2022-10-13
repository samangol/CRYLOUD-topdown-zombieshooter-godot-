# `ItemProtoset`

Inherits: [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html)

## Description

A resource type holding a set of inventory item prototypes in JSON format.

## Properties

* `json_data: String` - JSON string containing item prototypes.

## Methods

* `parse(json: String)` - Parses the given json string and generates a new `prototypes` dictionary.
* `get(id: String) -> Dictionary` - Returns the prototype with the given ID.
* `has(id: String) -> bool` - Checks if a prototype with the given ID exists.
* `get_item_property(id: String, property_name: String, default_value)` - Returns the value of the property with the given name from the prototype with the given ID. In case the value can not be found, the default value is returned.
