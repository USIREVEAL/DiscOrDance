"
I am a view that highlights the structure of a Discord server.

I show connections between channels and categories.
"
Class {
	#name : #DDStructureViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDStructureViewSpec >> initialize [
	super initialize.
	self name: 'Structural hierarchy - simple';
		layoutClass: RSTreeLayout;
		entityClasses:
			{ DDServer . DDCategory . DDVoiceChannel . DDTextChannel . DDStructuralEdge } asSet;
		glyphMappings: {
			DDServer -> DDServerNodeGlyph .
			DDVoiceChannel -> DDVoiceChannelNodeGlyph .
			DDTextChannel -> DDTextChannelNodeGlyph .
			DDCategory -> DDCategoryNodeGlyph .
			DDStructuralEdge -> DDTreeEdgeGlyph };
		sortingBlock: [ :entities | | structuralNodes others |
			structuralNodes := entities select: [ :each | each isKindOf: DDStructuralNode ].
			others := entities reject: [ :each | each isKindOf: DDStructuralNode ].
			
			structuralNodes sort: [ :a :b | a name asLowercase < b name asLowercase ].
			(structuralNodes, others) ].
]
