"
I am a glyph representing a conversation.
"
Class {
	#name : #DDConversationGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDConversationGlyph >> shapeForRoassal [
	| newShape |
	newShape := RSBox new.
	(self entity isEmpty) ifTrue: [
		self color: Color red.
		self width: 14.0.
		self height: 14.0. ]
	ifFalse: [
		self entity involvesCode ifTrue: [ self color: Color black. ].
		self height: 7.0 * self entity participatingAuthors size.
		self width: 7.0 * self entity messages size. ].
	^ newShape.
]
