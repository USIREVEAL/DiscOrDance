Class {
	#name : #DDComplexConversationsInChannelViewSpec,
	#superclass : #DDComplexConversationsViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDComplexConversationsInChannelViewSpec >> initialize [
	super initialize.
	self name: 'Conversations (complex view) - (channel restricted)';
		layoutClass: RSFlowLayout;
		entityClasses: { DDConversation } asSet;
		entityFilter: [ :entities | | conversations others channel |
			channel := DDVisualization restrictViewToChannel.
			others := entities reject: [ :each | each isKindOf: DDConversation ].
			conversations := entities select: [ :each |
				(each isKindOf: DDConversation) and: [ each isEmpty or: [ (each messages at: 1) containerChannel = channel ] ] ].
			(conversations , others)
		];
		sortingBlock: [ :entities | | others conversations |
			others := entities reject: [ :each | each isKindOf: DDConversation].
			conversations := DDConversation timeSorted: (entities select: [ :each | (each isKindOf: DDConversation) and: [ each messages size > 0 ] ]).
			(conversations , others) ].
]
