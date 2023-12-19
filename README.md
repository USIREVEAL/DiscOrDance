# DiscOrDance <a href="https://discord.com/api/oauth2/authorize?client_id=1093077234924916736&permissions=66536&scope=bot"><button style="vertical-align:middle;margin:0px 15px; padding:4px 10px;">Add REVEAL DiscOrDance Bot to Server</button></a>

<div align="center">
    <i><b>DiscOrDance is a programmable interactive visualization tool to explore Discord servers of software development communities.</b></i>
    <br /><img style="margin-top:5px;" width=64px src="docs/assets/images/DoD Logo.png" alt="DiscOrDance Logo" />
</div>

<div style="display:flex;margin-top:15px;margin-bottom:15px;">
    <div style="flex:1; margin-right:5px;">
        <img src="https://discordance.si.usi.ch/files/demo-short.gif" alt="DiscOrDance short demo animated gif." />
    </div>
    <div style="flex:3; margin-left:5px;">
        DiscOrDance is a bot, a scraper, and a visualization tool developed in <a href="https://pharo.org">Pharo</a> 8, aiming to support research in software engineering. After being added to a Discord server, the DiscOrDance bot can build an internal domain model of the server containing all the visible history. When model creation is complete, one can interactively explore authors, channels, messages and all the other classes in the domain model. Live inspection of an instance of a Discord server is enhanced by DiscOrDance with specific views targeted at progressively discover and understand the information contained in the selected server.
    <br /><br />
        DiscOrDance is being developed by <a href="https://www.inf.usi.ch/phd/raglianti/">Marco Raglianti</a> as part of his Ph.D. in Software Engineering.
    </div>
</div>

# Requirements
 - Pharo 8

# Quickstart Guide: Using DiscOrDance from Pharo
 
To start using DiscOrDance in Pharo create a fresh image of __Pharo 8__ and run the following commands in a playground:

```st
Metacello new
    baseline: 'DiscOrDance';
    repository: 'github://USIREVEAL/discordance:main';
	onWarning: [ :ex | (ex isKindOf: MCMergeOrLoadWarning) ifTrue: [ ex load ] ifFalse: [ ex resume ] ];
	load.
```

### <a name="creating"></a>Create a Private Bot

To create a private bot:
- Log in to https://discord.com/developers/applications
- Create a `New Application` through the button
- Give it a name and accept the Terms of Service for Discord
- (Optional) Add description and tags in the `General Information`
- Go to `Settings -> Bot` in the left pane
- Click on `Reset Token` and copy or take note of the `TOKEN` (see `'YOUR_API_TOKEN_HERE'` in the [Customize section](#customize-discordance-to-explore-private-servers)) to authorize the bot (in case you lose this you can generate it again from here)
- In the `Privileged Gateway Intents`, enable `Server Member Intent` and `Message Content Intent` and save the changes
- Go to `Oauth2 -> URL Generator` and add `bot` scope and `Read Message History` permissions

Copy and use the generated link to add the newly created bot to a server of interest (See [Adding DiscOrDance to the server](#adding)).

### Add Token to Pharo

To make a private server visible to DiscOrDance after adding the bot to the server (see [Create a Private Bot](#creating)), set the generated api token as value for the environment variable `DISCORD_API_TOKEN`:

```st
Smalltalk os environment at: 'DISCORD_API_TOKEN' put: 'YOUR_API_TOKEN_HERE'.
```

Open DiscOrDance in Pharo (`World Menu -> DiscOrDance -> DiscOrDance`) and scrape and analyze the server.

# Adding the REVEAL DiscOrDance Bot to a server

The REVEAL DiscOrDance bot can be added on public servers. By sharing your server with us and the research community, also through DiscOrDance, you enable us and other researchers forking this project to investigate interesting insights in how developers interact in your community.

### For Server Admins

If you are an administrator of a Discord server about software development (e.g., programming languages, software projects, framework communities) interested in the analyses available through DiscOrDance or its extension, do not hesitate to contact [wolfenmark](https://github.com/wolfenmark) via GitHub, us at [REVEAL](https://reveal.si.usi.ch/people/), or to open an issue/pull-request in this project.

DiscOrDance is a research tool and we are interested in new potential insights to improve software engineering practices among the community.

### Privacy Notice

Adding the REVEAL DiscOrDance bot to a server allows us to mine its data. DiscOrDance uses the lowest number of permissions needed to accomplish its tasks. The bot needs only the `read message history` permission, so it is safe to add to a public server (any user account can already mine the full history of a public server, although violating Discord’s ToS on bots).

## <a name="adding"></a>Adding REVEAL DiscOrDance to the server

When logged in Discord’s website with a server admin account, add the DiscOrDance public bot (DoD_Public) to the server by clicking here:
 - <a href="https://discord.com/api/oauth2/authorize?client_id=1093077234924916736&permissions=66536&scope=bot"><button style="vertical-align:middle;margin:5px;">Add Public Bot to Server</button></a>
 - Select the server of interest from the list and confirm. Requested permissions should include only `Read Message History`.
 - Confirm and authorize the following steps.

# Publications

DiscOrDance has been used in the following publications:

 - Riggio, E., Raglianti, M., & Lanza, M. (2023). [Conversation Disentanglement As-a-Service](https://ieeexplore.ieee.org/document/10173991). _Proceedings of ICPC 2023 (31st International Conference on Program Comprehension)_, pages 59-63, IEEE.
 - Raglianti, M., Nagy, C., Minelli, R., & Lanza, M. (2022). [DiscOrDance: Visualizing Software Developers Communities on Discord](https://ieeexplore.ieee.org/document/9978235). _Proceedings of ICSME 2022 (38th International Conference on Software Maintenance and Evolution)_, pages 474-478, IEEE.
 - Raglianti, M., Nagy, C., Minelli, R., & Lanza, M. (2022). [Using Discord Conversations as Program Comprehension Aid](https://ieeexplore.ieee.org/document/9796229). _Proceedings of ICPC 2022 (30th International Conference on Program Comprehension)_, pages 597-601, ACM.
 - Raglianti, M., Minelli, R., Nagy, C., & Lanza, M. (2021). [Visualizing Discord Servers](https://ieeexplore.ieee.org/abstract/document/9604869). Proceedings of VISSOFT 2021 (9th Working Conference on Software Visualization), pages 150-154, IEEE.

# Additional Documentation

Additional documentation can be found in the form of research papers, presentations, and a demo clip on: https://discordance.si.usi.ch.

# FAQ

### I have errors when importing with Metacello or nothing is imported except the baseline

 - Make sure you are in a __Pharo 8__ image. DiscOrDance is currently compatible and tested only with Pharo 8. Porting to the latest version of Pharo is under evaluation but it means porting the main dependencies too (at the moment out of scope).

 - Additionally try to remove the `onWarning:` block from the Metacello import command to have a better understanding of the failures that may cause errors.

### Approximate Scraping time

 - Our tests indicate that to mine 200k messages it takes less than one hour (due to Discord API rate limitations and depending on the analyses performed). This timing may vary greatly depending on the messages present on the server but it should serve as a rule of thumb to identify potential problems slowing down the scraping process.

# License and Contacts

DiscOrDance is released under the MIT License. See [LICENSE](LICENSE) for details.

© [Marco Raglianti](https://www.inf.usi.ch/phd/raglianti/) (a.k.a. [wolfenmark](https://github.com/wolfenmark) on GitHub). [REVEAL](https://reveal.si.usi.ch/people/) @ [Software Institute](https://www.si.usi.ch), [Università della Svizzera italiana (USI)](https://www.usi.ch), Lugano, Switzerland