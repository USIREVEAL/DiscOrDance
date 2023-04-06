"
I am a normalized version of the DDMaxDailySentMessagesMetric.
"
Class {
	#name : #DDNormalizedMaxDailySentMessagesMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedMaxDailySentMessagesMetric class >> nonNormalizedMetricClass [
	^ DDMaxDailySentMessagesMetric
]
