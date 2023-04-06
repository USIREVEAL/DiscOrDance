Class {
	#name : #DDConcept,
	#superclass : #DDRoot,
	#instVars : [
		'concept',
		'conceptType'
	],
	#category : #'DiscOrDance-Model-Unused'
}

{ #category : #accessing }
DDConcept >> concept [
	^ concept
]

{ #category : #accessing }
DDConcept >> concept: anObject [
	concept := anObject
]

{ #category : #accessing }
DDConcept >> conceptType [
	^ conceptType
]

{ #category : #accessing }
DDConcept >> conceptType: anObject [
	conceptType := anObject
]
