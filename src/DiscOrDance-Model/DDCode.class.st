"
I am a piece of source code in the content of a DDMessage.
"
Class {
	#name : #DDCode,
	#superclass : #DDNode,
	#instVars : [
		'message',
		'codeSource',
		'ast'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #'private accessing' }
DDCode class >> supportedSyntaxes [
	| syntaxTags |
	syntaxTags := DDSyntaxHighlightColorMetric highlightDictionary keys asOrderedCollection.
	syntaxTags remove: #none.
	^ syntaxTags asSet
]

{ #category : #'accessing - ast' }
DDCode >> codeClasses [
	"Return classes in the code based on heuristics"
	| classes |
	classes := self codeVariables select: [ :each | (each asString at: 1) isUppercase ].
	^ classes.

]

{ #category : #'accessing - ast' }
DDCode >> codeFeatures: anRBNodeType with: aSelector in: anAST [
	"Extract feature given by a selector from nodes of anRBNodeType in the abstract syntax tree anAST"
	| features |
	features := OrderedCollection new.
	anAST ifNotNil: [ | nodes | 
		nodes := anAST allChildren.
		features addAll:
			(nodes select: [ :eachNode |
				eachNode isKindOf: anRBNodeType ]
			thenCollect: aSelector). ].
	^ features
]

{ #category : #'accessing - ast' }
DDCode >> codeLiterals [
	^ self codeFeatures: RBLiteralValueNode with: #value in: self parsedAST.

]

{ #category : #'accessing - ast' }
DDCode >> codeMethods [
	^ self codeFeatures: RBMessageNode with: #selector in: self parsedAST.

]

{ #category : #accessing }
DDCode >> codeSource [
	^ codeSource
]

{ #category : #accessing }
DDCode >> codeSource: anObject [
	ast := nil.
	codeSource := anObject
]

{ #category : #'accessing - ast' }
DDCode >> codeVariables [
	"Return variable names in the code with at least 2 characters"
	| vars |
	vars := self codeFeatures: RBVariableNode with: #name in: self parsedAST.
	^ vars reject: [ :each | each size < 2 ].

]

{ #category : #testing }
DDCode >> isSourceCode [
	^ self class supportedSyntaxes includes: self syntaxHighlight. 
]

{ #category : #metrics }
DDCode >> locs [
	self flag: #FIXME. "These are not real locs, we should refine this in the actually correct metric."
	^ codeSource lines size.
]

{ #category : #accessing }
DDCode >> message [
	^ message
]

{ #category : #accessing }
DDCode >> message: anObject [
	message := anObject
]

{ #category : #accessing }
DDCode >> name [
	^ self codeSource
]

{ #category : #'accessing - external' }
DDCode >> openInDiscord [
	<vzContextMenu>
	self message openInBrowser.

]

{ #category : #'accessing - ast' }
DDCode >> parsedAST [
	ast ifNotNil: [ ^ ast ].
	({#st . #smalltalk} includes: self syntaxHighlight) ifFalse: [ ^ nil ].
	self flag: #FIXME. "Remove first line from codeSource to avoid errors in parsing due to syntax specifier."
	ast := [ CodeParser parse: self codeSource. ] on: Exception do: [  ^ nil. ].
	^ ast
]

{ #category : #metrics }
DDCode >> size [
	^ codeSource size.
]

{ #category : #metrics }
DDCode >> syntaxHighlight [
	| firstLine |
	"One-liners are not syntax highlighted"
	(self codeSource lines size <= 1)
		ifTrue: [ ^ #none ].
	firstLine := self codeSource readStream nextLine trimmed.
	"We consider possible highlight tags only short tags"
	((firstLine size < 10) and: [ firstLine isNotEmpty ])
		ifTrue: [ ^ firstLine asLowercase asSymbol ].
	^ #none.

]
