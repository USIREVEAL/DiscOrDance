"
I am a command to visually explore a raw server.
"
Class {
	#name : #DDExploreRawCommand,
	#superclass : #DDExploreCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #'private - utility' }
DDExploreRawCommand >> modelType [
	^ #raw
]
