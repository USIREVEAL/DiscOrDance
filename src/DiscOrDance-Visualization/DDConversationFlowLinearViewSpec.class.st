"
I am a view spec showing conversations and their flow in a channel as a linear sequence of messages.

"
Class {
	#name : #DDConversationFlowLinearViewSpec,
	#superclass : #DDConversationFlowViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDConversationFlowLinearViewSpec >> initialize [
	super initialize.
	self name: 'Conversation Flow Linear - (channel restricted)';
		layoutClass: RSHorizontalTreeLayout;
		glyphMappings:
			{ DDMessage -> DDMessageGlyph .
			DDConversationFlowEdge -> DDConversationFlowEdgeGlyph };
		sortingBlock: [ :entities | | others messages |
			others := entities reject: [ :each | each isKindOf: DDMessage].
			messages := DDMessage timeSorted: (entities select: [ :each | (each isKindOf: DDMessage) ]).
			(messages , others) ].

]
