"
I am a control point controller for tree vertical edges.
"
Class {
	#name : #DDTreeCPAPController,
	#superclass : #RSVerticalCPAPController,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #hooks }
DDTreeCPAPController >> controlPointsFrom: from to: to [
	^ Array
		with: from
		with: from x @ (from y + 10)
		with: to x @ (from y + 10)
		with: to
]
