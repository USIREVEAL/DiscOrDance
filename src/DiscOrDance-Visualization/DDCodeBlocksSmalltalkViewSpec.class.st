"
I am a viewspec showing smalltalk highlighted code blocks.
"
Class {
	#name : #DDCodeBlocksSmalltalkViewSpec,
	#superclass : #DDCodeBlocksViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCodeBlocksSmalltalkViewSpec >> initialize [
	super initialize.
	self
		name: 'Code blocks view - smalltalk';
		sortingBlock: [ :entities | entities sorted: [ :a :b | a locs > b locs ] ];
		entityFilter: [ :entities |	entities select: [ :each | {#smalltalk . #st} includes: each syntaxHighlight ] ].
]
