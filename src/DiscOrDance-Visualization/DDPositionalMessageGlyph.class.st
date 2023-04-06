"
I am a glyph representing a DDMessage.

I show my content as tooltip.
I position myself according to my timestamp.
"
Class {
	#name : #DDPositionalMessageGlyph,
	#superclass : #DDMessageGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDPositionalMessageGlyph >> shapeForRoassal [
	| newShape |
	newShape := super shapeForRoassal.
	self origin: (self timeBasedPosition).
	^ newShape
]

{ #category : #positioning }
DDPositionalMessageGlyph >> timeBasedPosition [
	"Return a time based position for the current glyph.
	Vertically divide the space in 24 slots of 'DDMessageGlyph slotSizeWidth' width and position it in the corresponding hour slot.
	Horizontally generate a column for each day that is two 'DDMessageGlyph slotSizeWidth' wide and position it corresponding to the minutes fraction."
	| timeStamp socketWidth |
	socketWidth := 10.0.
	timeStamp := self entity createdAt asDateAndTime.
	self flag: #FIXME. "Offsets working only on my locale, quick hack to get correct paper picture"
	^ (((timeStamp - (DateAndTime tomorrow translateToUTC offset: -1)) days) * socketWidth * self class slotSizeWidth - socketWidth) + (timeStamp minute / 60.0 * self class slotSizeWidth * socketWidth)
		@
		((timeStamp hour24) * self class slotSizeHeight)
]
