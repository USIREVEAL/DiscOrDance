"
I am an element referring to a method in the host language.
"
Class {
	#name : #DDMethodElement,
	#superclass : #DDCodeElement,
	#instVars : [
		'referencedMethodName'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDMethodElement >> name [
	^ self referencedMethodName
]

{ #category : #accessing }
DDMethodElement >> referencedMethodName [
	^ referencedMethodName
]

{ #category : #accessing }
DDMethodElement >> referencedMethodName: aString [
	referencedMethodName := aString
]
