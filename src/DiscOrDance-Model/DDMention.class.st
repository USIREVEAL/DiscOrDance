"
I am a mention of some other entity in the content of a message.

I have the form of @mention in Discord.
I have different forms in the content of the message.

I can parse a generic mention text and return an instance of the appropriate DDMention subclass.
"
Class {
	#name : #DDMention,
	#superclass : #DDMentioning,
	#instVars : [
		'mentioningEntity',
		'mentionedEntity'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #parsing }
DDMention class >> parseMention: mentionText inServer: aDDServer [
	| re entitySelector entityId |
	self flag: #FIXME. "Add mentioning entity in sender of this message"
	self deprecated: 'This method is untested and mostly unused, kept for reference on parsing mentions manually. Do not use.'.

	(mentionText matchesRegex: '<.*>') ifFalse: [ Error new signal: ('Parsing an invalid mention of the form: ' , mentionText asString) ].
	(mentionText = '<@everyone>') ifTrue: [ ^ DDEveryoneMention new ].
	(mentionText = '<@here>') ifTrue: [ ^ DDHereMention new ].

	re := '<(@?[&!]|#)([0-9]*)>' asRegex matchesPrefix: mentionText.
	entitySelector := re subexpression: 2.
	entityId := re subexpression: 3.

	(entitySelector = '@&') ifTrue: [ ^ DDRoleMention new mentionedEntity: (aDDServer getRoleWithId: entityId) ].
	(entitySelector = '@!') ifTrue: [ ^ DDUserMention new mentionedEntity: (aDDServer getAuthorWithId: entityId) ].
	(entitySelector = '#') ifTrue: [ ^ DDChannelMention new mentionedEntity: (aDDServer getChannelWithId: entityId) ].
	^ nil.
]

{ #category : #updating }
DDMention >> changeMentionee: newMentionee [
		(self mentioningEntity = self mentionedEntity)
			ifTrue: [ self mentioningEntity: newMentionee ].
		self mentionedEntity: newMentionee.

]

{ #category : #updating }
DDMention >> changeMentioner: newMentioner [
		(self mentionedEntity = self mentioningEntity)
			ifTrue: [ self mentionedEntity: newMentioner ].
		self mentioningEntity: newMentioner.

]

{ #category : #testing }
DDMention >> isChannelMention [
	^ false
]

{ #category : #testing }
DDMention >> isRoleMention [
	^ false
]

{ #category : #testing }
DDMention >> isSpecialMention [
	^ false
]

{ #category : #testing }
DDMention >> isUserMention [
	^ false
]

{ #category : #accessing }
DDMention >> mentionedEntity [
	^ mentionedEntity
]

{ #category : #accessing }
DDMention >> mentionedEntity: aMentionedEntity [
	mentionedEntity := aMentionedEntity
]

{ #category : #accessing }
DDMention >> mentioningEntity [
	^ mentioningEntity
]

{ #category : #accessing }
DDMention >> mentioningEntity: anObject [
	mentioningEntity := anObject
]

{ #category : #printing }
DDMention >> printOn: aStream [
	"Print entity type without DD prefix, followed by entity name if available"

	"Remove first 2 characters to remove DD prefix"	
	aStream << (self className allButFirst: 2).
	
	aStream << ': '.

	self mentioningEntity printOn: aStream.
	aStream << ' -> '.
	self mentionedEntity printOn: aStream.

]
