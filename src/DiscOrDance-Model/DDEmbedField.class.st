"
I am a field in a DDEmbed.

I have a name and a value.
"
Class {
	#name : #DDEmbedField,
	#superclass : #DDNode,
	#instVars : [
		'value'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #initialization }
DDEmbedField class >> createFromDS: aDSEmbedField [
	| newField |
	newField := self new.
	newField name: aDSEmbedField name.
	newField value: aDSEmbedField value.
	^ newField

]

{ #category : #printing }
DDEmbedField >> printOn: aStream [
	super printOn: aStream.
	aStream << ' = ' << self value asString.
]

{ #category : #accessing }
DDEmbedField >> value [
	^ value
]

{ #category : #accessing }
DDEmbedField >> value: anObject [
	value := anObject
]
