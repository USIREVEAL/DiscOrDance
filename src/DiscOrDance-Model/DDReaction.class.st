"
I am a reaction to a DDMessage.

I know the emoji representing this reaction and how many different DDAuthors reacted in this way to the message.
"
Class {
	#name : #DDReaction,
	#superclass : #DDNode,
	#instVars : [
		'message',
		'count',
		'emoji'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #'as yet unclassified' }
DDReaction class >> createFromDS: aDSReaction withMessage: aDDMessage [
	| server newReaction |
	
	server := aDDMessage containerChannel containerServer.
	newReaction := self new.
	newReaction count: aDSReaction count.
	newReaction message: aDDMessage.
	[ newReaction emoji: (server getEmojiWithId: aDSReaction emoji name). ]
		on: NotFound
		do: [ | emoji |
			emoji := DDEmoji new id: aDSReaction emoji name.
			server addEmoji: emoji.
			newReaction emoji: emoji.
		].
	
	^ newReaction
]

{ #category : #accessing }
DDReaction >> count [
	^ count
]

{ #category : #accessing }
DDReaction >> count: anObject [
	count := anObject
]

{ #category : #accessing }
DDReaction >> emoji [
	^ emoji
]

{ #category : #accessing }
DDReaction >> emoji: anObject [
	emoji := anObject
]

{ #category : #accessing }
DDReaction >> message [
	^ message
]

{ #category : #accessing }
DDReaction >> message: anObject [
	message := anObject
]
