"
I am an author merging multiple DDAuthors with different ids but corresponding to accounts of the same person.

When two DDAuthors have the same name, they're considered a single DDMergedAuthor.
"
Class {
	#name : #DDMergedAuthor,
	#superclass : #DDAuthor,
	#instVars : [
		'aliases',
		'authors'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #adding }
DDMergedAuthor >> addAlias: aName forAuthor: aDDAuthor [
	self aliases add: aName.
	self authors add: aDDAuthor.
	self roles addAll: (aDDAuthor roles ifNil: [ Set new ]).
	self activeChannels addAll: aDDAuthor activeChannels.
	self activeCategories addAll: aDDAuthor activeCategories.
	self sentMessages addAll: aDDAuthor sentMessages.
	aDDAuthor mergedInto: self.
	aDDAuthor sentMessages do: [ :eachMessage |
			eachMessage author: self.
			eachMessage userMentions do: [ :each | each changeMentioner: self ].
			eachMessage roleMentions do: [ :each | each changeMentioner: self ].
			eachMessage channelMentions do: [ :each | each changeMentioner: self ].
			eachMessage specialMentions do: [ :each | each changeMentioner: self ].
			eachMessage mentions select: [ :each | each isKindOf: DDMention ] thenDo: [ :each | each changeMentioner: self ].
	].

]

{ #category : #accessing }
DDMergedAuthor >> aliases [
	^ aliases
]

{ #category : #accessing }
DDMergedAuthor >> aliases: aString [
	aliases := aString
]

{ #category : #accessing }
DDMergedAuthor >> authors [
	^ authors
]

{ #category : #accessing }
DDMergedAuthor >> authors: aDDAuthor [
	authors := aDDAuthor
]

{ #category : #initialization }
DDMergedAuthor >> initialize [
	super initialize.
	
	self aliases: Set new.
	self authors: Set new.
]

{ #category : #testing }
DDMergedAuthor >> isMergedAuthor [
	^ true
]

{ #category : #accessing }
DDMergedAuthor >> mergedInto [
	^ self
]
