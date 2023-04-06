"
I am a view spec showing conversations that are code related and the relevant source code snippets contained in the conversation.
"
Class {
	#name : #DDCodeRelatedConversationsViewSpec,
	#superclass : #DDConversationsInChannelViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDCodeRelatedConversationsViewSpec >> initialize [
	super initialize.
	self name: 'Conversations - Code Related - (channel restricted)';
		layoutClass: RSTreeLayout;
		entityClasses: { DDConversation . DDCode . DDCodeEdge };
		glyphMappings:
			{ DDConversation -> DDConversationGlyph .
			DDCode -> DDNodeGlyph };
		entityFilter: [ :entities | | conversations code others channel |
			channel := DDVisualization restrictViewToChannel.
			others := entities reject: [ :each | (each isKindOf: DDConversation) or: [ each isKindOf: DDCode ] ].
			conversations := entities select: [ :each |
				((each isKindOf: DDConversation)
					and: [ each isEmpty or: [ (each messages at: 1) containerChannel = channel ] ])
					and: [ each involvesCode ] ].
			code := entities select: [ :each |
				((each isKindOf: DDCode)
				and: [ each isSourceCode ])
				and: [ each message containerChannel = channel ] ].
			(conversations , code , others)
		];
		metricMappings: { 
			DDCode -> {
				DDCodeSizeMetric -> #devNull .
				DDLocsMetric -> #devNull .
				DDSyntaxHighlightColorMetric -> #color .
				DDNormalizedCodeSizeMetric -> #width .
				DDNormalizedLocsMetric -> #height } }.
]
