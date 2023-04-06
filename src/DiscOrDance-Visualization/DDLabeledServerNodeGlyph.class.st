"
I am a glyph representing a Discord server.
I have a label in the form 'Server: srver_name'.
"
Class {
	#name : #DDLabeledServerNodeGlyph,
	#superclass : #DDServerNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDLabeledServerNodeGlyph >> shapeForRoassal [
	| newComposite newLabel |

	newLabel := RSLabel new.
	newLabel text: 'Discord server: ' , self entity printString.
	newLabel color: Color black.

	newComposite := RSComposite new.

	newComposite model: self entity.
	"RSLocation new center; move: newShape on: newLabel."
	newComposite shapes: { newLabel }.
	newComposite adjustToChildren.
	self width: newComposite width + 15.
	self height: newComposite height + 5.

	^ newComposite 

]
