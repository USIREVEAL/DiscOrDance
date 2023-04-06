"
I am a metric.
I map the number of mentions in a DDMentioning edge.
"
Class {
	#name : #DDMentionsMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDMentionsMetric class >> description [
	^ 'Number of mentions'
]

{ #category : #accessing }
DDMentionsMetric class >> selectorOrBlock [
	^ [ :edge | edge times ]
]

{ #category : #accessing }
DDMentionsMetric class >> shortName [
	^ 'MENTIONS'
]

{ #category : #accessing }
DDMentionsMetric class >> upperBound [
	^ 5.0
]
