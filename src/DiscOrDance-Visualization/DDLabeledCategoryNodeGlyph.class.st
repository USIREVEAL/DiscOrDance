"
I am a glyph representing a Discord category.
i have a label with the category name as text.
"
Class {
	#name : #DDLabeledCategoryNodeGlyph,
	#superclass : #DDCategoryNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDLabeledCategoryNodeGlyph >> shapeForRoassal [
	| newComposite newLabel |

	newLabel := RSLabel new.
	newLabel text: self entity name.
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
