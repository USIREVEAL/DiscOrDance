"
I am a view spec showing points of interest in messages.

I link channels to messages containing points of interest.
I link messages containing points of interest to their context.
"
Class {
	#name : #DDPointOfInterestViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDPointOfInterestViewSpec >> initialize [
	super initialize.
	self name: 'Points of Interest';
		layoutClass: RSTreeLayout;
		entityClasses:
			{ DDPointOfInterest } asSet;
		glyphMappings:
			{ DDPointOfInterest -> DDNodeGlyph }
]
