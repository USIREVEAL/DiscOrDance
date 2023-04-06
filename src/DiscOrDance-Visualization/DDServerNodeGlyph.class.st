"
I am a glyph representing a Discord server.
"
Class {
	#name : #DDServerNodeGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #initialization }
DDServerNodeGlyph >> initialize [
	super initialize.
	self width: 15.
	self height: 15.
	self color: Color lightGray.
]
