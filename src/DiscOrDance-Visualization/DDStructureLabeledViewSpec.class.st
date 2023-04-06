"
I am a view that highlights the structure of a Discord server.

I show connections between channels and categories.
I show labeled glyphs for server and categories.
"
Class {
	#name : #DDStructureLabeledViewSpec,
	#superclass : #DDStructureViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDStructureLabeledViewSpec >> initialize [
	super initialize.
	self name: 'Structural hierarchy - labeled';
		layoutClass: RSTreeLayout;
		glyphMappings: {
			DDServer -> DDLabeledServerNodeGlyph .
			DDVoiceChannel -> DDVoiceChannelNodeGlyph .
			DDTextChannel -> DDTextChannelNodeGlyph .
			DDCategory -> DDLabeledCategoryNodeGlyph .
			DDStructuralEdge -> DDTreeEdgeGlyph }

]
