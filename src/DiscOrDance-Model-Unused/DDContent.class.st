Class {
	#name : #DDContent,
	#superclass : #DDRoot,
	#instVars : [
		'category',
		'content',
		'contentType',
		'attachments',
		'embeds',
		'size'
	],
	#category : #'DiscOrDance-Model-Unused'
}

{ #category : #accessing }
DDContent >> attachments [
	^ attachments
]

{ #category : #accessing }
DDContent >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
DDContent >> category [
	^ category
]

{ #category : #accessing }
DDContent >> category: anObject [
	category := anObject
]

{ #category : #accessing }
DDContent >> content [
	^ content
]

{ #category : #accessing }
DDContent >> content: anObject [
	content := anObject
]

{ #category : #accessing }
DDContent >> contentType [
	^ contentType
]

{ #category : #accessing }
DDContent >> contentType: anObject [
	contentType := anObject
]

{ #category : #accessing }
DDContent >> embeds [
	^ embeds
]

{ #category : #accessing }
DDContent >> embeds: anObject [
	embeds := anObject
]

{ #category : #accessing }
DDContent >> size [
	^ size
]

{ #category : #accessing }
DDContent >> size: anObject [
	size := anObject
]
