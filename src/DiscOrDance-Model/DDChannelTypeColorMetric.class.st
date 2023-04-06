"
I am a metric mapping channel type to a color.
"
Class {
	#name : #DDChannelTypeColorMetric,
	#superclass : #DDColorMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDChannelTypeColorMetric class >> description [
	^ 'Color for text and voice channels'
]

{ #category : #accessing }
DDChannelTypeColorMetric class >> selectorOrBlock [
	^ 	[ :node | node isTextChannel
			ifTrue: [ Color cyan ]
			ifFalse: [ Color gray ] ].

]

{ #category : #accessing }
DDChannelTypeColorMetric class >> shortName [
	^ 'CHANNEL_TYPE'
]
