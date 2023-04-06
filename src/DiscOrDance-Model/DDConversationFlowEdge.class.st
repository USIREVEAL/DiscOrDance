"
I am a conversation flow edge.

I connect a message to the chronologically following one in a channel in the same conversation.
"
Class {
	#name : #DDConversationFlowEdge,
	#superclass : #DDEdge,
	#instVars : [
		'preceding',
		'following'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDConversationFlowEdge >> following [
	^ following
]

{ #category : #accessing }
DDConversationFlowEdge >> following: aDDMessage [
	following := aDDMessage
]

{ #category : #accessing }
DDConversationFlowEdge >> node1 [
	^ preceding
]

{ #category : #accessing }
DDConversationFlowEdge >> node1: aVZNode [
	self preceding: aVZNode
]

{ #category : #accessing }
DDConversationFlowEdge >> node2 [
	^ following
]

{ #category : #accessing }
DDConversationFlowEdge >> node2: aVZNode [
	self following: aVZNode
]

{ #category : #accessing }
DDConversationFlowEdge >> preceding [
	^ preceding
]

{ #category : #accessing }
DDConversationFlowEdge >> preceding: aDDMessage [
	preceding := aDDMessage
]
