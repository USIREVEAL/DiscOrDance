"
I am a topic with a description and a list of keywords.
"
Class {
	#name : #DDTopic,
	#superclass : #DDNode,
	#instVars : [
		'keywords',
		'description'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #converting }
DDTopic >> asJSONDictionary [
	^ { #keywords -> self keywords .
		#description -> self description } asDictionary
]

{ #category : #accessing }
DDTopic >> description [
	^ description
]

{ #category : #accessing }
DDTopic >> description: anObject [
	description := anObject
]

{ #category : #initialization }
DDTopic >> initialize [
	super initialize.
	keywords := OrderedCollection new.
]

{ #category : #accessing }
DDTopic >> keywords [
	^ keywords
]

{ #category : #accessing }
DDTopic >> keywords: anObject [
	keywords := anObject
]
