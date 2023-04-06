"
I am an abstract superclass for node glyphs in DiscOrDance.
"
Class {
	#name : #DDNodeGlyph,
	#superclass : #VZNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #initialization }
DDNodeGlyph >> initialize [
	super initialize.
	self height: 15.
	self width: 15.
]
