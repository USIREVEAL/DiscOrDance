"
I am a view spec showing code blocks in messages.

I map different colors to code blocks with a known syntax highlight.
I use DDSyntaxHighlightColorMetric to map colors to code blocks.

"
Class {
	#name : #DDCodeBlocksViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCodeBlocksViewSpec >> initialize [
	super initialize.
	self name: 'Code blocks view';
		layoutClass: RSGridLayout;
		entityClasses:
			{ DDCode } asSet;
		glyphMappings:
			{ DDCode -> DDNodeGlyph };
		metricMappings: { 
			DDCode -> {
				DDCodeSizeMetric -> #devNull .
				DDLocsMetric -> #devNull .
				DDSyntaxHighlightColorMetric -> #color .
				DDNormalizedCodeSizeMetric -> #width .
				DDNormalizedLocsMetric -> #height } }.
]
