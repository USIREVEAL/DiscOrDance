"
I am an edge between a class and a code element.
"
Class {
	#name : #DDCodeReferenceEdge,
	#superclass : #DDEdge,
	#instVars : [
		'referenceClass',
		'codeElement'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDCodeReferenceEdge >> codeElement [
	^ codeElement
]

{ #category : #accessing }
DDCodeReferenceEdge >> codeElement: aDDCodeElement [
	codeElement := aDDCodeElement
]

{ #category : #accessing }
DDCodeReferenceEdge >> node1 [
	^ referenceClass
]

{ #category : #accessing }
DDCodeReferenceEdge >> node1: aVZNode [
	self referenceClass: aVZNode
]

{ #category : #accessing }
DDCodeReferenceEdge >> node2 [
	^ codeElement
]

{ #category : #accessing }
DDCodeReferenceEdge >> node2: aVZNode [
	self codeElement: aVZNode
]

{ #category : #accessing }
DDCodeReferenceEdge >> referenceClass [
	^ referenceClass
]

{ #category : #accessing }
DDCodeReferenceEdge >> referenceClass: aDDClassNode [
	referenceClass := aDDClassNode
]
