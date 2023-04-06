"
I am a DDAuthorActivityTimelineViewSpec that sorts authors by their last message.
"
Class {
	#name : #DDAuthorActivityTimelineLastActiveViewSpec,
	#superclass : #DDAuthorActivityTimelineViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorActivityTimelineLastActiveViewSpec >> initialize [
	super initialize.
	self
		name: 'Author activity span timeline - last active';
		sortingBlock: [ :entities | | authors others |
			authors := entities select: [ :each | each isKindOf: DDAuthor ].
			others := entities reject: [ :each | each isKindOf: DDAuthor ].
			authors := DDAuthor lastMessageSorted: authors.
			(authors, others) ].

]
