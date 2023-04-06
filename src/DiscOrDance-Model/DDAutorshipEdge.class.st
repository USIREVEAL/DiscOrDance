"
I am an edge between an author and a message he sent.
"
Class {
	#name : #DDAutorshipEdge,
	#superclass : #DDEdge,
	#instVars : [
		'author',
		'message'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDAutorshipEdge >> author [
	^ author
]

{ #category : #accessing }
DDAutorshipEdge >> author: aDDAuthor [
	author := aDDAuthor
]

{ #category : #accessing }
DDAutorshipEdge >> message [
	^ message
]

{ #category : #accessing }
DDAutorshipEdge >> message: aDDMessage [
	message := aDDMessage
]

{ #category : #accessing }
DDAutorshipEdge >> node1 [
	^ author
]

{ #category : #accessing }
DDAutorshipEdge >> node1: aDDAuthor [
	self author: aDDAuthor
]

{ #category : #accessing }
DDAutorshipEdge >> node2 [
	^ message
]

{ #category : #accessing }
DDAutorshipEdge >> node2: aDDMessage [
	self message: aDDMessage
]
