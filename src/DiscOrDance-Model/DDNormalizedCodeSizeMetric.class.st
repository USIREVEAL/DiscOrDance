"
I am a normalized version of DDCodeSizeMetric.
"
Class {
	#name : #DDNormalizedCodeSizeMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedCodeSizeMetric class >> nonNormalizedMetricClass [
	^ DDCodeSizeMetric
]
