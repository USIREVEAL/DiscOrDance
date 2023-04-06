"
I am an abstract command that can be executed.
"
Class {
	#name : #DDCommand,
	#superclass : #Object,
	#category : #'DiscOrDance-Commands'
}

{ #category : #execution }
DDCommand >> execute [
	self subclassResponsibility.
]
