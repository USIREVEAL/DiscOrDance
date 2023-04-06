"
I am a metric mapping the number of authors active in a channel.
"
Class {
	#name : #DDActiveAuthorsMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDActiveAuthorsMetric class >> description [
	^ 'Number of authors active in a text channel'
]

{ #category : #accessing }
DDActiveAuthorsMetric class >> selectorOrBlock [
	^ [ :node | node authors size ].
]

{ #category : #accessing }
DDActiveAuthorsMetric class >> shortName [
	^ 'ACTIVE_AUTHORS'
]
