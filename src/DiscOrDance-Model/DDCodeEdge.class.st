"
I am a generic edge between an entity and a DDCode element.
"
Class {
	#name : #DDCodeEdge,
	#superclass : #DDEdge,
	#instVars : [
		'code',
		'entity'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDCodeEdge >> code [
	^ code
]

{ #category : #accessing }
DDCodeEdge >> code: aDDCode [
	code := aDDCode
]

{ #category : #accessing }
DDCodeEdge >> entity [
	^ entity
]

{ #category : #accessing }
DDCodeEdge >> entity: aDDNode [
	entity := aDDNode
]

{ #category : #accessing }
DDCodeEdge >> node1 [
	^ code
]

{ #category : #accessing }
DDCodeEdge >> node1: aVZNode [
	self code: aVZNode
]

{ #category : #accessing }
DDCodeEdge >> node2 [
	^ entity
]

{ #category : #accessing }
DDCodeEdge >> node2: aVZNode [
	self entity: aVZNode
]
