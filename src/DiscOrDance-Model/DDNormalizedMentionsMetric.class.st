"
I am a normalized version of the DDMentionsMetric.
"
Class {
	#name : #DDNormalizedMentionsMetric,
	#superclass : #DDNormalizedEdgeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedMentionsMetric class >> nonNormalizedMetricClass [
	^ DDMentionsMetric
]

{ #category : #accessing }
DDNormalizedMentionsMetric class >> upperBound [
	^ 5.0
]
