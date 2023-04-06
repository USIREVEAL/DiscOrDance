"
I am a view spec showing conversations and their flow in a channel.

I link messages between them.
I highlight message types according to their length and content.

"
Class {
	#name : #DDConversationFlowViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDConversationFlowViewSpec >> initialize [
	super initialize.
	self name: 'Conversation Flow - (channel restricted)';
		layoutClass: RSNoLayout;
		entityClasses:
			{ DDMessage . DDConversationFlowEdge . DDNextConversationEdge } asSet;
		glyphMappings:
			{ DDMessage -> DDPositionalMessageGlyph .
			DDConversationFlowEdge -> DDConversationFlowEdgeGlyph .
			DDNextConversationEdge -> DDNextConversationEdgeGlyph };
		entityFilter: [ :entities | | messages others |
			others := entities reject: [ :each | each isKindOf: DDMessage ].
			messages := entities select: [ :each |
				(each isKindOf: DDMessage) and: [ each containerChannel = DDVisualization restrictViewToChannel ] ].
			(messages , others)
		].
]
