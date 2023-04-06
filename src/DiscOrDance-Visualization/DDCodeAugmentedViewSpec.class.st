"
I am a view spec showing classes linked to their mentions in messages.
"
Class {
	#name : #DDCodeAugmentedViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCodeAugmentedViewSpec >> initialize [
	super initialize.
	self name: 'Class links view';
		layoutClass: RSRadialTreeLayout;
		entityClasses:
			{ DDClassElement . DDClassNode . DDCodeReferenceEdge } asSet;
		glyphMappings: {
			DDClassElement -> DDSmallGlyph .
			DDClassNode -> DDNodeGlyph .
			DDCodeReferenceEdge -> VZEdgeGlyph }.
]
