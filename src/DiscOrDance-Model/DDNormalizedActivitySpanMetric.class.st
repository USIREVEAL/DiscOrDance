"
I am a normalized version of the DDActivitySpanMetric.
"
Class {
	#name : #DDNormalizedActivitySpanMetric,
	#superclass : #DDNormalizedDurationMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedActivitySpanMetric class >> nonNormalizedMetricClass [
	^ DDActivitySpanMetric
]

{ #category : #accessing }
DDNormalizedActivitySpanMetric class >> upperBound [
	^ 600.0
]
