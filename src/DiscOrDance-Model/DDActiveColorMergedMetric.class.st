"
I am a metric mapping author type and activity status to color.

I map color magenta to DDMergedAuthors.
I use mappings from my superclass otherwise.
"
Class {
	#name : #DDActiveColorMergedMetric,
	#superclass : #DDActiveColorMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDActiveColorMergedMetric class >> description [
	^ 'Type or activity status of an author'
]

{ #category : #accessing }
DDActiveColorMergedMetric class >> selectorOrBlock [
	"Merged authors are magenta, green active members, gray inactive members, red previously active non-members, black inactive non-members"
	^ [ :node |
		(node isKindOf: DDMergedAuthor)
			ifTrue: [ Color magenta ]
			ifFalse: [ super selectorOrBlock value: node ].
		].
]

{ #category : #accessing }
DDActiveColorMergedMetric class >> shortName [
	^ 'MERGED_OR_ACTIVITY_STATUS'
]
