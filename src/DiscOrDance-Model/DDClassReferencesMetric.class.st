"
I am a metric mapping the number of class references in a DDClassNode entity.
"
Class {
	#name : #DDClassReferencesMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDClassReferencesMetric class >> description [
	^ 'Number of references to this class contained in code blocks'
]

{ #category : #accessing }
DDClassReferencesMetric class >> selectorOrBlock [
	^ [ :node | (node connectedNodes select: [ :each | each isKindOf: DDClassElement ]) size ].
]

{ #category : #accessing }
DDClassReferencesMetric class >> shortName [
	^ 'CLASS_REFERENCES'
]
