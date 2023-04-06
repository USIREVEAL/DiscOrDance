"
I am an edge between chronologically subsequent (possibly unrelated) conversations.
"
Class {
	#name : #DDNextConversationEdge,
	#superclass : #DDEdge,
	#instVars : [
		'preceding',
		'following'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDNextConversationEdge >> following [
	^ following
]

{ #category : #accessing }
DDNextConversationEdge >> following: aDDConversation [
	following := aDDConversation
]

{ #category : #accessing }
DDNextConversationEdge >> node1 [
	^ preceding
]

{ #category : #accessing }
DDNextConversationEdge >> node1: aVZNode [
	self preceding: aVZNode
]

{ #category : #accessing }
DDNextConversationEdge >> node2 [
	^ following
]

{ #category : #accessing }
DDNextConversationEdge >> node2: aVZNode [
	self following: aVZNode
]

{ #category : #accessing }
DDNextConversationEdge >> preceding [
	^ preceding
]

{ #category : #accessing }
DDNextConversationEdge >> preceding: aDDConversation [
	preceding := aDDConversation
]
