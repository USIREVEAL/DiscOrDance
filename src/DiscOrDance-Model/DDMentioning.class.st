"
I am an edge conneting two entities, a mentioning entity and a mentioned entity.
"
Class {
	#name : #DDMentioning,
	#superclass : #DDEdge,
	#instVars : [
		'times'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDMentioning >> initialize [
	super initialize.
	times := 1.
]

{ #category : #accessing }
DDMentioning >> mentionedEntity [
	self subclassResponsibility
]

{ #category : #accessing }
DDMentioning >> mentionedEntity: aDDNode [
	self subclassResponsibility
]

{ #category : #accessing }
DDMentioning >> mentioningEntity [
	self subclassResponsibility
]

{ #category : #accessing }
DDMentioning >> mentioningEntity: aDDNode [
	self subclassResponsibility
]

{ #category : #accessing }
DDMentioning >> node1 [
	^ self mentioningEntity
]

{ #category : #accessing }
DDMentioning >> node1: aDDNode [
	self mentioningEntity: aDDNode
]

{ #category : #accessing }
DDMentioning >> node2 [
	^ self mentionedEntity
]

{ #category : #accessing }
DDMentioning >> node2: aDDNode [
	self mentionedEntity: aDDNode
]

{ #category : #accessing }
DDMentioning >> times [
	^ times
]

{ #category : #accessing }
DDMentioning >> times: aNumber [
	times := aNumber
]
