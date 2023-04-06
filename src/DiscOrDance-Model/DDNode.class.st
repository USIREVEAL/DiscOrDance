"
I am the root of the nodes in the DiscOrDance model hierarchy.
"
Class {
	#name : #DDNode,
	#superclass : #VZNode,
	#instVars : [
		'name'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #converting }
DDNode >> asVZNode [
	self model: self.
	^ self
]

{ #category : #interacting }
DDNode >> fillContextMenu: aMenu inContext: aVZContext [
	| methods |
	self flag: #FIXME. "Method duplication to fulfill requirements ov VZEntity for both branches of the hierarchy"

	super fillContextMenu: aMenu inContext: aVZContext.

	methods := (Pragma allNamed: #vzContextMenu from: self class to: DDNode) collect: #method.
	methods sort: [ :a :b | a selector < b selector ].

	aMenu addGroup: [ :group |
		methods do: [ :method |
			group
				addItem: [ :item |
						item name: (VZGlyph new prettifyMenuName: method selector);
						action: [ self perform: method selector ] ] ]
	].
]

{ #category : #accessing }
DDNode >> name [
	^ name
]

{ #category : #accessing }
DDNode >> name: anObject [
	name := anObject
]

{ #category : #printing }
DDNode >> printOn: aStream [
	"Print entity type without DD prefix, followed by entity name if available"

	"Remove first 2 characters to remove DD prefix"	
	aStream << (self className allButFirst: 2).
	
	aStream << ': '.

	self name
		ifNotNil: [ aStream << self name asString ]
		ifNil: [ aStream << '<nameless>' ].

]

{ #category : #printing }
DDNode >> printString [
	"Return entity type without DD prefix, followed by entity name if available"
	| string |
	
	string := ''.
	"Remove first 2 characters to remove DD prefix"
	"string := (self class name asString allButFirst: 2) , ': '."
	
	self name
		ifNotNil: [ string := string , self name asString ]
		ifNil: [ string := string , '<nameless>' ].
	
	^ string
]
