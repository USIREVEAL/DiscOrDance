"
I am a special mention.

I can be either @here or @everyone.
"
Class {
	#name : #DDSpecialMention,
	#superclass : #DDMention,
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #testing }
DDSpecialMention >> isAtEveryone [
	^ false
]

{ #category : #testing }
DDSpecialMention >> isAtHere [
	^ false
]

{ #category : #testing }
DDSpecialMention >> isSpecialMention [
	^ true
]
