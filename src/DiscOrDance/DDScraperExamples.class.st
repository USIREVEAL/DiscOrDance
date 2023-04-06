"
I am a collection of examples of how to use the DiscOrDance scraper to interact with models (generate and load).
"
Class {
	#name : #DDScraperExamples,
	#superclass : #Object,
	#category : #'DiscOrDance-Scraper-Examples'
}

{ #category : #utility }
DDScraperExamples class >> createCompleteModel [
	| scraper ddConfig |
	"Download and store a local model for all the servers registered in the DiscOrDance bot without any message limit.
	Beware that this may take SOME time given Discord's rate limits."
	<script>
	
	ddConfig := DDGlobalConfiguration new
		limitMessages: false.
	scraper := DDScraper new
		globalConfiguration: ddConfig;
		createModel.
	scraper model inspect.

]

{ #category : #utility }
DDScraperExamples class >> createDummyModel [
	| scraper ddConfig |
	"Download and store a local model for an example server registered in the DiscOrDance bot with a custom global configuration"
	<script>
	
	ddConfig := DDGlobalConfiguration new
		limitMessages: true;
		messagesPerChannel: 25.
	scraper := DDScraper new
		globalConfiguration: ddConfig;
		createDummyModel.
	scraper model inspect.

]

{ #category : #utility }
DDScraperExamples class >> createPartialModel [
	| scraper ddConfig |
	"Download and store a local model for a server registered in the DiscOrDance bot where the server name matches the partial string"
	<script>
	
	ddConfig := DDGlobalConfiguration new
		limitMessages: true;
		messagesPerChannel: 25.
	scraper := DDScraper new
		globalConfiguration: ddConfig;
		createPartialModel: 'Wolfenmark'.
	scraper model inspect.

]

{ #category : #utility }
DDScraperExamples class >> loadModel [
	"Load all the models saved in this instance and inspect them."
	<script>

	| scraper |
	scraper := DDScraper new loadModel.
	scraper model inspect.

]

{ #category : #examples }
DDScraperExamples >> runCreateCompleteModel [
	<script: 'self createCompleteModel.'>
]

{ #category : #examples }
DDScraperExamples >> runCreateDummyModel [
	<script: 'self createDummyModel.'>
]

{ #category : #examples }
DDScraperExamples >> runCreatePartialModel [
	<script: 'self createPartialModel.'>
]

{ #category : #examples }
DDScraperExamples >> runLoadModel [
	<script: 'self loadModel.'>
]
