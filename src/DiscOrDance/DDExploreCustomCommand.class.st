"
I am a command to visually explore a custom edited server.
"
Class {
	#name : #DDExploreCustomCommand,
	#superclass : #DDExploreCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #'private - utility' }
DDExploreCustomCommand >> modelType [
	^ #custom
]
