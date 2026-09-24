# moro_orchestra
Standalone musicians script for RedM.

Spawns musician NPCs at configured positions (piano, guitar, fiddle, jaw harp, trumpet...).  
Players can walk up to a musician and press a key to make them start or stop playing.  
Only one musician plays at a time, and the state is synchronised by the server to all players.

## Features

- NPCs spawn only when a player is nearby and are removed when the player moves away.
- A musician can be placed on a map prop (piano bench, chair...): the ped snaps to the nearest matching prop, with an offset.
- Interaction is blocked while swimming, running, mounted, in combat or dead.
- The server checks the player's distance before accepting a toggle.

## Installation

Add `moro_piano` to your `server.cfg` or `resources.cfg` file.

## Config

`PropSearchRadius` is the radius used to find the prop the musician sits on.  
`ActivationDistance` is the distance at which musicians spawn/despawn around the player.  
`PromptDistance` is the distance at which the prompt appears.  
`DefaultMusician` is the index of the musician playing when the server starts (`nil` = nobody).  
`PromptKey` is the key used to toggle the music (Default = G).  
`LoadTimeout` is the max time (ms) to wait for a model or ped to load.  
`SpawnCheckInterval` is the delay (ms) between distance checks to spawn/despawn musicians.  
`ToggleCooldown` is the delay (ms) after a toggle before the prompt can be used again.  
`Texts` is the table of prompts texts, use your own language.  
`Musicians` is the list of musicians:
- `label` is the prompt group name.
- `model` is the ped model. 
- `scenario` is the scenario played while playing music.
- `idleScenario` is the scenario played while not playing (optional).
- `position` is the ped position and heading (`vector4`), used as is when there are no props.
- `props` is an optional list of `{ model, offset }`: the ped is placed on the closest matching prop, `offset` is a `vector4` (x, y, z, heading). If no prop is found, the musician doesn't spawn.

License: Licence MIT
Feel free to use, modify & improve it freely, provided the original author (Morojgovany) is explicitly mentioned.
