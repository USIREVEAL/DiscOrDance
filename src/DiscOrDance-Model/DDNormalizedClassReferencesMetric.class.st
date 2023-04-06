"
I am a normalized version of DDClassReferencesMetric.
"
Class {
	#name : #DDNormalizedClassReferencesMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedClassReferencesMetric class >> lowerBound [
	^ 100.0
]

{ #category : #accessing }
DDNormalizedClassReferencesMetric class >> nonNormalizedMetricClass [
	^ DDClassReferencesMetric
]

{ #category : #accessing }
DDNormalizedClassReferencesMetric class >> upperBound [
	^ 1000.0
]
