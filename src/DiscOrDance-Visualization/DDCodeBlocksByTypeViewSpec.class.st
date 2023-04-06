"
I am a specialization of DDCodeBlocksViewSpec.

I sort blocks by their type.

"
Class {
	#name : #DDCodeBlocksByTypeViewSpec,
	#superclass : #DDCodeBlocksViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCodeBlocksByTypeViewSpec >> initialize [
	super initialize.
	self
		name: 'Code blocks view - by type';
		layoutClass: RSFlowLayout;
		sortingBlock: [ :entities | (entities groupedBy: #syntaxHighlight) flattened ].
]
