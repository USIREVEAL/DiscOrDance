"
I am an interesting DDMessage since I match one or more interest criteria.
"
Class {
	#name : #DDPointOfInterest,
	#superclass : #DDNode,
	#instVars : [
		'message',
		'channel',
		'criteria'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDPointOfInterest >> channel [
	^ channel
]

{ #category : #accessing }
DDPointOfInterest >> channel: aDDChannel [
	channel := aDDChannel
]

{ #category : #accessing }
DDPointOfInterest >> criteria [
	^ criteria
]

{ #category : #accessing }
DDPointOfInterest >> criteria: anObject [
	criteria := anObject
]

{ #category : #accessing }
DDPointOfInterest >> message [
	^ message
]

{ #category : #accessing }
DDPointOfInterest >> message: anObject [
	message := anObject
]

{ #category : #accessing }
DDPointOfInterest >> name [
	^ self criteria
]

{ #category : #'accessing - external' }
DDPointOfInterest >> openInDiscord [
	<vzContextMenu>
	self message openInBrowser.

]
