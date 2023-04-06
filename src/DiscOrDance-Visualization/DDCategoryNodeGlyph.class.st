"
I am a glyph representing a Discord category.
"
Class {
	#name : #DDCategoryNodeGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #initialization }
DDCategoryNodeGlyph >> initialize [
	super initialize.
	self width: 60.
	self height: 15.
	self color: Color veryLightGray.
]
