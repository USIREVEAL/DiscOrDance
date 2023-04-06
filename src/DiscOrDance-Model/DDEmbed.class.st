"
I am an embedded link in a message.
In Discord I am usually sent as a simple link that is expanded in a preview of the linked content.

I have an url link to the original content embedded.
I also have some fields that are populated automatically by Discord when the linked content is retrieved and parsed.
"
Class {
	#name : #DDEmbed,
	#superclass : #DDNode,
	#instVars : [
		'type',
		'description',
		'url',
		'timestamp',
		'fields'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #initialization }
DDEmbed class >> createFromDS: aDSEmbed [
	| newEmbed |
	newEmbed := self new.
	newEmbed name: aDSEmbed title.
	newEmbed type: aDSEmbed type.
	newEmbed description: aDSEmbed description.
	newEmbed url: aDSEmbed url.
	newEmbed timestamp: aDSEmbed timestamp.
	newEmbed fields: (aDSEmbed fields collect: [ :each | DDEmbedField createFromDS: each ]).
	^ newEmbed
]

{ #category : #accessing }
DDEmbed >> description [
	^ description
]

{ #category : #accessing }
DDEmbed >> description: anObject [
	description := anObject
]

{ #category : #accessing }
DDEmbed >> fields [
	^ fields
]

{ #category : #accessing }
DDEmbed >> fields: anObject [
	fields := anObject
]

{ #category : #accessing }
DDEmbed >> timestamp [
	^ timestamp
]

{ #category : #accessing }
DDEmbed >> timestamp: anObject [
	timestamp := anObject
]

{ #category : #accessing }
DDEmbed >> type [
	^ type
]

{ #category : #accessing }
DDEmbed >> type: anObject [
	type := anObject
]

{ #category : #accessing }
DDEmbed >> url [
	^ url
]

{ #category : #accessing }
DDEmbed >> url: anObject [
	url := anObject
]
