"
I am a collection of examples of DiscOrDance visualizations.
"
Class {
	#name : #DDVisualizationExample,
	#superclass : #SpApplication,
	#category : #'DiscOrDance-Visualization-Examples'
}

{ #category : #examples }
DDVisualizationExample class >> baseExample [
	<script>
	"Open a server selector instance of DiscOrDance."

	DDVisualization new showServerSelector.
]

{ #category : #examples }
DDVisualizationExample class >> createOverview [
	"Create an overview by directly manipulating the canvas."
	| dd server c overview |
	<script>

	dd := DDScraper new loadModel.
	server := dd model servers at: 3.

	c := RSCanvas new.
	overview := server overview: c.
	c add: overview.
	RSGridLayout on: c shapes.

	overview @ RSDraggable.

	c @ RSCanvasController.
	c zoomToFit.
	c inspect.

]

{ #category : #examples }
DDVisualizationExample class >> inspectSampleModel [
	<script>

	| dd server |
	dd := DDScraper new createDummyModel.
	server := dd model servers at: 1.
	server inspect.
]

{ #category : #examples }
DDVisualizationExample class >> openSampleModelWithVizor [
	<script>
	
	DDVisualization new loadExampleModel;
	open.
]

{ #category : #examples }
DDVisualizationExample >> runBaseExample [
	<script: 'self baseExample'>
]

{ #category : #examples }
DDVisualizationExample >> runCreateOverview [
	<script: 'self createOverview'>
]

{ #category : #examples }
DDVisualizationExample >> runInspectSampleModel [
	<script:	'self inspectSampleModel.'>
]

{ #category : #examples }
DDVisualizationExample >> runOpenSampleModelWithVizor [
	<script:	'self openSampleModelWithVizor.'>
]
