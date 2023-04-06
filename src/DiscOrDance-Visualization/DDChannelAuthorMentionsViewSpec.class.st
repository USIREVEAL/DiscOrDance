"
TODO
"
Class {
	#name : #DDChannelAuthorMentionsViewSpec,
	#superclass : #DDAuthorMentionsViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDChannelAuthorMentionsViewSpec >> initialize [
	super initialize.
	self name: 'Author mentions - (channel restricted)';
		entityFilter: [ :entities | | channel authors others |
			others := entities reject: [ :each | each isKindOf: DDAuthor ].
			authors := entities select: [ :each | each isKindOf: DDAuthor ].
			channel := (authors first server channelsNamed: DDVisualization restrictViewToChannel name) first.
			authors := authors select: [ :each | channel authors includes: each ].
			(authors , others)
		].
]
