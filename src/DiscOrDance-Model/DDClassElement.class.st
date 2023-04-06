"
I am a code element referring to a class in the host language.
"
Class {
	#name : #DDClassElement,
	#superclass : #DDCodeElement,
	#instVars : [
		'referencedClassName'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDClassElement >> name [
	^ self referencedClassName
]

{ #category : #accessing }
DDClassElement >> referencedClassName [
	^ referencedClassName
]

{ #category : #accessing }
DDClassElement >> referencedClassName: aString [
	referencedClassName := aString
]
