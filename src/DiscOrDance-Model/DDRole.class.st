"
I am a role in the permission hierarchy of Discord.
"
Class {
	#name : #DDRole,
	#superclass : #DDNode,
	#instVars : [
		'id'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #comparing }
DDRole >> = aRole [
	^ aRole id = self id
]

{ #category : #comparing }
DDRole >> hash [
	^ self id hash
]

{ #category : #accessing }
DDRole >> id [
	^ id
]

{ #category : #accessing }
DDRole >> id: anObject [
	id := anObject
]
