"
I am a normalized version of the DDSentMessagesMetric.
"
Class {
	#name : #DDNormalizedSentMessagesMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedSentMessagesMetric class >> nonNormalizedMetricClass [
	^ DDSentMessagesMetric
]
