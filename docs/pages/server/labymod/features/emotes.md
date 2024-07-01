The `EmotePacket` is a client-bound packet that allows servers to let NPCs perform emotes.

???+ warning "Important Note"

    To prevent abuse, this does not work for real players. You can only perform emotes on players that have the second half of their UUID entirely being 0 (-> 64 least significant bits are 0, or the second long value equals 0).<br/> You therefore need to spawn them with a uuid like this.

## Creating the Emote Model

The packet uses the `Emote` model.

### Play an Emote

Create the model with `Emote.play(UUID, int)` to create an emote with the unique id of the npc and the id of the emote to perform.
```java
Emote emote = Emote.play(npcUniqueId, 2);
```

### Stop an Emote

Create the model with `Emote.stop(UUID)` to stop the current emote of the npc.
```java
Emote emote = Emote.stop(npcUniqueId);
```

## Sending the Packet

```java
// Create a List of emotes (array is also possible)
List<Emote> emotes = new ArrayList<>();

// Add all emotes you want to perform
emotes.add(emote);

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new EmotePacket(emotes));
```

## Available Emotes

The following emotes are available:

<script>
    const nextElementSibling = document.getElementById("available-emotes").parentElement;
    fetch("https://neo.labymod.net/emotes/index.json")
        .then(response => response.json())
        .then(data => {
            const emotes = data.emotes;
            const emoteList = document.createElement("ul");
            emoteList.classList.add("emote-list");

            for (let emotesKey in emotes) {
                const emote = emotes[emotesKey];
                if(emote.draft) {
                    continue;
                }

                const emoteItem = document.createElement("li");
                
                const emoteId = document.createElement("code");
                emoteId.textContent = emotesKey;
                emoteItem.appendChild(emoteId);

                const emoteName = document.createElement("span");
                emoteName.textContent = " - " + emote.name;
                emoteItem.appendChild(emoteName);

                emoteList.appendChild(emoteItem);
            }

            nextElementSibling.appendChild(emoteList);
        })
        .catch(() => {
            const errorElement = document.createElement("p");
            errorElement.textContent = "Failed to load available emotes :(";
            nextElementSibling.appendChild(errorElement);
        })
</script>