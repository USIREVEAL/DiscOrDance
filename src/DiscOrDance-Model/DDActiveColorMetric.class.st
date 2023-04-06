"
I am a metric mapping activity status to color.

I map Color green to members that have been active.
I map Color grey to members that have not been active yet.
I map Color red to non-members that have been previously active.
I map Color black to non-members (not anymore) that have been mentioned but didn't send any message.
"
Class {
	#name : #DDActiveColorMetric,
	#superclass : #DDColorMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDActiveColorMetric class >> description [
	^ 'Activity status of an author'
]

{ #category : #accessing }
DDActiveColorMetric class >> selectorOrBlock [
	"Active members are green, inactive members gray, previously active non-members red, inactive non-members black"
	^ [ :node |
			(node isMember)
				ifTrue: [
					(node isActive)
						ifTrue: [ Color green ]
						ifFalse: [ Color gray ] ]
				ifFalse: [
					(node isActive)
						ifTrue: [ Color red ]
						ifFalse: [ Color black ].
				].
		].
]

{ #category : #accessing }
DDActiveColorMetric class >> shortName [
	^ 'ACTIVITY_STATUS'
]
