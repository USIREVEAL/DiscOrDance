"
I am a DDAuthorActivityTimelineViewSpec that sorts authors by their first appearence.
"
Class {
	#name : #DDAuthorActivityTimelineOldestViewSpec,
	#superclass : #DDAuthorActivityTimelineViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorActivityTimelineOldestViewSpec >> initialize [
	super initialize.
	self
		name: 'Author activity span timeline - oldest';
		sortingBlock: [ :entities | | authors others |
			authors := entities select: [ :each | each isKindOf: DDAuthor ].
			others := entities reject: [ :each | each isKindOf: DDAuthor ].
			authors := DDAuthor firstMessageSorted: authors.
			(authors, others) ].

]
