In contrast to the LabyMod 3 Server API, the LabyMod 4 Server API doesn't communicate with JsonElements. Instead, it
writes data directory into a ByteBuffer. This is a more efficient way of communication and allows for more flexibility
in the data that can be sent.

The downside of this is that it is even more important to read and write packets correctly. Because of this, it is
recommended to share the classes on the server and client-side. We for example use the `core` artifact, which you will
also use, in LabyMod 4.

For an easier process of creating packets, we provide the classes `PayloadReader` and `PayloadWriter`. Both contain
a variety of methods to read and write data from and to the ByteBuffer for any types thinkable. From collections and
arrays to nullable objects.

If you are still unsure if you are doing everything correctly, please don't hesitate to check out the Packets of the
LabyMod Protocol
on [GitHub](https://github.com/LabyMod/labymod4-server-api/tree/master/core/src/main/java/net/labymod/serverapi/core/packet)
or ask on [our Discord Server for Developers](https://labymod.net/dc/dev).

## Creating a Packet

For our example packet, we'll be reading and writing a nullable component, an integer and a collection of objects with a
string and a bunch of booleans.

First, we'll create that implements the `Packet` interface. And create all the fields we want to read and write. Also,
we create a record for the object that our List will contain. <br/>
__Don't mind the field names, they are just placeholders for this example.__

```java
import net.labymod.serverapi.api.model.component.ServerAPIComponent;
import net.labymod.serverapi.api.packet.Packet;
import net.labymod.serverapi.api.payload.io.PayloadReader;
import net.labymod.serverapi.api.payload.io.PayloadWriter;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.List;

public class ExamplePacket implements Packet {

  private ServerAPIComponent component;
  private int color;
  private List<ExamplePacketObject> objects;

  public ExamplePacket(
      @Nullable ServerAPIComponent component,
      @NotNull List<ExamplePacketObject> objects,
      int color
  ) {
    // Throw an exception if the list is null
    Objects.requireNonNull(objects, "Objects list cannot be null");
    
    // Assign the values to the fields
    this.component = component;
    this.objects = objects;
    this.color = color;
  }

  public @Nullable ServerAPIComponent getComponent() {
    return this.component;
  }

  public int getColor() {
    return this.color;
  }

  /**
   * This can be annotated with {@link NotNull}, as the list is never null. 
   * We know that because our constructor is throwing an exception if no list
   * is provided. And if for some reason the list is null upon reading, it 
   * will never be handed over to the PacketHandler.
   */
  public @NotNull List<ExamplePacketObject> getObjects() {
    return this.objects;
  }

  /**
   * It's always a good idea to override the {@link Object#toString()} method to
   * provide a human-readable representation of the object.
   */
  @Override
  public String toString() {
    return "ExamplePacket{" +
        "component=" + component +
        ", color=" + color +
        '}';
  }

  /**
   * The record is a simple data class that is used to store the data of
   * the objects list.
   */
  public record ExamplePacketObject(
      String name,
      boolean editable,
      boolean createdByUser,
      boolean global
  ) {

    /**
     * It's always a good idea to override the {@link Object#toString()} method 
     * to provide a human-readable representation of the object.
     */
    @Override
    public String toString() {
      return "ExamplePacketObject{" +
          "name='" + name + '\'' +
          ", editable=" + editable +
          ", createdByUser=" + createdByUser +
          ", global=" + global +
          '}';
    }
  }
}
```

## Write the Packet

To write the packet, we need to override the `write` method of the `Packet` interface. Be sure not to call
`super.write`, as this will throw an exception upon writing the packet.

???+ danger "Important"
    Always keep in mind that the order of writing and reading the values of the Packet must be the same, also the types must match. You can't write a variable integer and read a normal integer. If you are unsure what to do (or if what you've done is correct), don't hesitate to ask on [our Discord Server for Developers](https://labymod.net/dc/dev).

```java
@Override
public void write(@NotNull PayloadWriter writer) {
  // Write the nullable component
  writer.writeOptional(
      this.component, // The component
      writer::writeComponent // the consumer to write the component
  );
  
  // Write the color. We're using writeVarInt here, as variable integers are 
  // more efficient on the network stack for smaller values. Alternatively 
  // you can use PayloadWriter#writeInt
  writer.writeVarInt(this.color);
  
  // Write the list of objects
  writer.writeCollection(
      this.objects, // The list to write
      object -> { // the consumer is called for every object in the list
        // write the name
        writer.writeString(object.name());
        
        // write the boolean values
        writer.writeBoolean(object.editable());
        writer.writeBoolean(object.createdByUser());
        writer.writeBoolean(object.global());
      }
  );
}
```

## Read the Packet

To read the packet, we need to override the `read` method of the `Packet` interface. Be sure not to call
`super.read`, as this will throw an exception upon reading the packet.

???+ danger "Important"
    Always keep in mind that the order of writing and reading the values of the Packet must be the same, also the types must match. You can't write a variable integer and read a normal integer. If you are unsure what to do (or if what you've done is correct), don't hesitate to ask on [our Discord Server for Developers](https://labymod.net/dc/dev).

```java
@Override
public void read(@NotNull PayloadReader reader) {
  // Read the optional component
  this.component = reader.readOptional(reader::readComponent);
  
  // Read the color as variable integer. 
  this.color = reader.readVarInt();

  // Read the list of objects
  this.objects = reader.readList(() -> { // the supplier is called for every object in the list
    return new ExamplePacketObject(
        reader.readString(), // read the name
        reader.readBoolean(), // read the editable boolean
        reader.readBoolean(), // read the createdByUser boolean
        reader.readBoolean() // read the global boolean
    );
  });
}
```

## Final Words

That's it. You've successfully created a packet that can be sent the to or from the server. 
Now all you have to do is to [register the Packet](/pages/server/protocols/#register-a-packet) in your Protocol. <br/>



