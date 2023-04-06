"
I am the root of the edges in the DiscOrDance model hierarchy.
"
Class {
	#name : #DDEdge,
	#superclass : #VZEdge,
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #interacting }
DDEdge >> fillContextMenu: aMenu inContext: aVZContext [
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
