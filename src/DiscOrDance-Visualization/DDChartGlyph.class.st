"
I am an abstract superclass of chart based glyphs.

My subclasses know how to create a chart for their data representation.
"
Class {
	#name : #DDChartGlyph,
	#superclass : #DDNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDChartGlyph >> chartForRoassal [
	^ self subclassResponsibility.
]

{ #category : #testing }
DDChartGlyph >> needPlaceholderGlyph [
	^ false
]

{ #category : #rendering }
DDChartGlyph >> shapeForRoassal [
	| composite group chart |
	self needPlaceholderGlyph
		ifTrue: [
				^ RSBox new model: self;
						color: Color gray ].
	composite := RSComposite new.

	group := RSGroup new.
	chart := self chartForRoassal.
	chart container: group.
	chart build.
	composite add: group asShape.
	composite adjustToChildren.

	^ composite
]
