"
I am a DDConversationsViewSpec restricted to a specific channel selected via the 'DDVisualization restrictViewToChannel' mechanism.
"
Class {
	#name : #DDConversationsInChannelViewSpec,
	#superclass : #DDConversationsViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDConversationsInChannelViewSpec >> initialize [
	super initialize.
	self name: 'Conversations - (channel restricted)';
		layoutClass: RSFlowLayout;
		entityClasses:
			{ DDConversation } asSet;
		glyphMappings:
			{ DDConversation -> DDConversationGlyph };
		entityFilter: [ :entities | | conversations others channel |
			channel := DDVisualization restrictViewToChannel.
			others := entities reject: [ :each | each isKindOf: DDConversation ].
			conversations := entities select: [ :each |
				(each isKindOf: DDConversation) and: [ each isEmpty or: [ (each messages at: 1) containerChannel = channel ] ] ].
			(conversations , others)	];
		sortingBlock: [ :entities | | others conversations |
			others := entities reject: [ :each | each isKindOf: DDConversation].
			conversations := DDConversation timeSorted: (entities select: [ :each | (each isKindOf: DDConversation) and: [ each messages size > 0 ] ]).
			(conversations , others) ].
]
