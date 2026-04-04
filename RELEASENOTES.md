## 0.25.0







feature: add selector aliasing and export visibility for container classes

* add ':' selector aliases that map to -objectAtIndex: (NSArray) and -objectForKey: (NSDictionary) so callers can use the concise colon selector
* expose container class globals via `MULLE_OBJC_CONTAINER_FOUNDATION_GLOBAL_VAR` and rename loader category to MulleObjCDeps to centralize dependency metadata




   changed to (result != nil) == expect for correct intersectsSet: behavior
