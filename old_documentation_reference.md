# Old manual dependency installation (not required anymore)

## Install DiscordST from Juraj Kubelka

```smalltalk
"This code installs the DiscordSt library and its dependencies in the current environment"
Metacello new
	baseline: #DiscordSt;
	repository: 'github://JurajKubelka/DiscordSt/src';
	load.
```


#### Inspect a server object to explore data and structures

```smalltalk
"Inspect this to get a view on the guilds accessible by the DiscOrDance bot"
DSBot new
	token: 'YOUR_DISCORD_BOT_TOKEN';
	servers.
```

## Install Roassal3
```smalltalk
"Install Roassal 3"
Metacello new
	baseline: 'Roassal3';
	repository: 'github://ObjectProfile/Roassal3:v0.9.6b';
	"The next line is needed to resolve conflicting versions of [g|G]eometry packages in the dependencies"
	onConflictUseIncoming;
	load.
```

#### Test Roassal3

```smalltalk
"Test Roassal3"
RSChartExample new example01Markers open.
```

# Additional steps

From iceberg "add -> import existing clone" to import DiscOrDance source code.
Then from the working copy of discorddance-pharo load all the packages with right click -> Load (maybe there's a better way to do this but in the end I will provide a Baseline for installation with Metacello).

# Old useful snippets

## Save a model and start inspecting it

To save a local copy of the model and start inspecting it run the following code in a playground.

```smalltalk

| ddScraper ddVisual dd d101 |
"Download and store a local model for all the servers registered in the DiscOrDance bot"
ddScraper := DDScraper new createModel.
ddScraper inspect.

"Load local model and create a flat channel view of a specific server"
dd := DDScraper new loadModel.
d101 := dd model servers at: 2.

ddVisual := DDVisualization new createFlatChannelView: d101.
ddVisual canvas inspect.

ddVisual := DDVisualization new createCategoryHierarchyView: d101.
ddVisual canvas inspect.
```

## Create model and save it

```smalltalk
"Download and store a local model for all the servers registered in the DiscOrDance bot"
| ddScraper |

ddScraper := DDScraper new createModel.
ddScraper := nil.
ddScraper := DDScraper new loadModel.
ddScraper inspect.
```

## Install Roassal2

```smalltalk
"Load Roassal2"
Metacello new
	baseline: 'Roassal2';
	repository: 'github://ObjectProfile/Roassal2/src';
	load.
```

## Uninstall Roassal2

**Warning: I didn't succesfully use this, I ended up corrupting the image and starting from scratch. This is here only as a base reference.**

```smalltalk
"Unload Roassal2"
Gofer new
	package: 'Roassal2';
	unload.
```

## Test Roassal2

```smalltalk
"Test Roassal2"
b := RTMondrian new.
	b shape label.
	b nodes: (1 to: 100).
	b edges connectFrom: [ :i | i // 2 ].
	b layout cluster.
	b open.
```
