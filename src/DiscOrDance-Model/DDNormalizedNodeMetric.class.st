"
I am a metric for nodes.
I am normalized between 0.0 and 100.0
"
Class {
	#name : #DDNormalizedNodeMetric,
	#superclass : #DDNormalizedMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedNodeMetric class >> upperBound [
	^ 100.0
]
