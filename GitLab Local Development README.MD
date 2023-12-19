# On a new image

Copy the following script and edit GITLAB_USERNAME and GITLAB_TOKEN with your username and token to access the development repository.

In a playground run the script (or associate this as a new image script).

```smalltalk
"Add credentials to be able to clone DiscOrDance"
Iceberg enableMetacelloIntegration: true.
Iceberg remoteTypeSelector: #httpsUrl.
IceCredentialStore current
    storeCredential: (IcePlaintextCredentials new
        username: 'GITLAB_USERNAME';
        password: 'GITLAB_TOKEN';
        host: 'gitlab.reveal.si.usi.ch';
        yourself).

"Install DiscOrDance and dependencies"
Metacello new
    baseline: 'DiscOrDance';
    repository: 'gitlab://gitlab.reveal.si.usi.ch:wolfenmark/discordance-pharo';
	onWarning: [ :ex | (ex isKindOf: MCMergeOrLoadWarning) ifTrue: [ ex load ] ifFalse: [ ex resume ] ];
    load.

DiscOrDance openForDevelopment.
```

After finishing image creation you can start the DiscOrDance UI by the world menu: DiscOrDance -> DiscOrDance.

If you want to open some convenience browsers scoped on DiscOrDance relevant classes you can use DiscOrDance -> Utilities -> Open for Development.

You can create a model by scraping a server and start exploring it.
