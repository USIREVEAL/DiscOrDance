"
I am a configuration defining limits of messages retrieved in querying operations by a DDScraper.
"
Class {
	#name : #DDGlobalConfiguration,
	#superclass : #DDRoot,
	#instVars : [
		'limitMessages',
		'messagesPerChannel'
	],
	#category : #'DiscOrDance-Base'
}

{ #category : #initialization }
DDGlobalConfiguration >> initialize [
	super initialize.
	self limitMessages: true.
	self messagesPerChannel: 100.
]

{ #category : #accessing }
DDGlobalConfiguration >> limitMessages [
	^ limitMessages
]

{ #category : #accessing }
DDGlobalConfiguration >> limitMessages: anObject [
	limitMessages := anObject
]

{ #category : #accessing }
DDGlobalConfiguration >> messagesPerChannel [
	^ messagesPerChannel
]

{ #category : #accessing }
DDGlobalConfiguration >> messagesPerChannel: anObject [
	messagesPerChannel := anObject
]
