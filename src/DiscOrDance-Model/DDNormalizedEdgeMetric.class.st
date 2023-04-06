"
I am a metric for edges.
I am normalized between 0.0 and 10.0
"
Class {
	#name : #DDNormalizedEdgeMetric,
	#superclass : #DDNormalizedMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedEdgeMetric class >> minValue [
	^ 1
]

{ #category : #accessing }
DDNormalizedEdgeMetric class >> upperBound [
	^ 10.0
]
