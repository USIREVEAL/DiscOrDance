"
I am a structural edge.
I represent parent-child relations in the hierarchy of server-categories-channels.
"
Class {
	#name : #DDStructuralEdge,
	#superclass : #DDEdge,
	#instVars : [
		'parent',
		'child'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDStructuralEdge >> child [
	^ child
]

{ #category : #accessing }
DDStructuralEdge >> child: aDDStructuralNode [
	child := aDDStructuralNode
]

{ #category : #accessing }
DDStructuralEdge >> node1 [
	^ self parent
]

{ #category : #accessing }
DDStructuralEdge >> node1: aDDStructuralNode [
	self parent: aDDStructuralNode
]

{ #category : #accessing }
DDStructuralEdge >> node2 [
	^ self child
]

{ #category : #accessing }
DDStructuralEdge >> node2: aDDStructuralNode [
	self child: aDDStructuralNode
]

{ #category : #accessing }
DDStructuralEdge >> parent [
	^ parent
]

{ #category : #accessing }
DDStructuralEdge >> parent: aDDStructuralNode [
	parent := aDDStructuralNode
]
