"
I am a command to visually explore a cleaned server.
"
Class {
	#name : #DDExploreCleanedCommand,
	#superclass : #DDExploreCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #'private - utility' }
DDExploreCleanedCommand >> modelType [
	^ #clean
]
