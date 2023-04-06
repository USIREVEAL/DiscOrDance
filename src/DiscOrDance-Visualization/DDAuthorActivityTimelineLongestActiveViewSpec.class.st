"
I am a DDAuthorActivityTimelineViewSpec that sorts authors by their activity span.
"
Class {
	#name : #DDAuthorActivityTimelineLongestActiveViewSpec,
	#superclass : #DDAuthorActivityTimelineViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorActivityTimelineLongestActiveViewSpec >> initialize [
	super initialize.
	self
		name: 'Author activity span timeline - longest active';
		sortingBlock: [ :entities | | authors others |
			authors := entities select: [ :each | each isKindOf: DDAuthor ].
			others := entities reject: [ :each | each isKindOf: DDAuthor ].
			authors := DDAuthor lifespanSorted: authors.
			(authors, others) ].

]
