"
I am a node glyph with a simple lable showing the name of my entity.
"
Class {
	#name : #DDSimpleLabeledNodeGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDSimpleLabeledNodeGlyph >> shapeForRoassal [
	| newComposite newLabel |

	newLabel := RSLabel new.
	newLabel text: self entity name.
	newLabel color: Color black.
	
	"Reduce font size for longer labels"
	(newLabel text size > 10)
		ifTrue: [ newLabel fontSize: ((self width / 14.0) round: 0) ]
		ifFalse: [ newLabel fontSize: ((self width / 8.0) round: 0) ].

	newComposite := RSComposite new.
	newComposite model: self entity.
	"RSLocation new center; move: newShape on: newLabel."
	newComposite shapes: { newLabel }.
	newComposite adjustToChildren.
	self color: Color veryLightGray.

	^ newComposite 

]
