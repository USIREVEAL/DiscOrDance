"
I am an emoji.

I have a code representing myself.
"
Class {
	#name : #DDEmoji,
	#superclass : #DDNode,
	#instVars : [
		'id'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #comparing }
DDEmoji >> = anEmoji [
	(anEmoji isKindOf: self class) ifFalse: [ ^ false ].
	^ self id = anEmoji id
]

{ #category : #comparing }
DDEmoji >> hash [
	^ self id hash
]

{ #category : #accessing }
DDEmoji >> id [
	^ id
]

{ #category : #accessing }
DDEmoji >> id: anObject [
	id := anObject
]
