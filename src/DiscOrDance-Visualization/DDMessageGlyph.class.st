"
I am a glyph representing a DDMessage.

I show my content as tooltip.
"
Class {
	#name : #DDMessageGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #'accessing - defaults' }
DDMessageGlyph class >> slotSizeHeight [
	^ 15.0
]

{ #category : #'accessing - defaults' }
DDMessageGlyph class >> slotSizeWidth [
	^ 15.0
]

{ #category : #initialization }
DDMessageGlyph >> initialize [
	super initialize.
	self width: self class slotSizeWidth.
	self height: self class slotSizeHeight.
	self color: Color veryLightGray.

]

{ #category : #rendering }
DDMessageGlyph >> shapeForRoassal [
	| newShape |
	newShape := (self entity content size > 0)
		ifFalse: [
			self width: self width / 2.0.
			self height: self height / 2.0.
			RSBox new ]
		ifTrue: [ RSEllipse new ].
	newShape border: Color black.
	(self entity lineCount > 1) ifTrue: [ self color: Color black ].
	(self entity lineCount = 1) ifTrue: [ self color: Color gray ].
	(self entity wordCount <= 1) ifTrue: [ self color: Color veryLightGray ].
	
	^ newShape
]
