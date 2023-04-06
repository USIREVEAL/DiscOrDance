"
I am an abstract source code element.
"
Class {
	#name : #DDCodeElement,
	#superclass : #DDNode,
	#instVars : [
		'code',
		'index'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDCodeElement >> code [
	^ code
]

{ #category : #accessing }
DDCodeElement >> code: anObject [
	code := anObject
]

{ #category : #accessing }
DDCodeElement >> index [
	^ index
]

{ #category : #accessing }
DDCodeElement >> index: anObject [
	index := anObject
]

{ #category : #'accessing - external' }
DDCodeElement >> openInDiscord [
	<vzContextMenu>
	self code message openInBrowser.

]
