The `EconomyDisplayPacket` is a client-bound packet that allows servers to display balance information of multiple
virtual currencies in the HUD of the LabyMod player.

![Example Economy Display](/assets/files/serverapi/economy_display.gif)

## The Economy Display Model

There are several constructors available in the `EconomyDisplay` class. If you're managing the Economy Displays with the
LabyModPlayer object, you won't need to create the model yourself.

The following methods are available to update the values of an Economy Display:

- `#balance(double)` - Updates the balance of the economy. Default is `0`.
- `#visible(boolean)` - Updates the visibility state of the economy. Default is `true`.
- `#iconUrl(String)` - Allows you to update the icon of the economy. Default is `null`.
- `#decimalFormat(DecimalFormat)` - Allows you to update the format and divisor of the economy.

???+ note

    When sending an custom Economy Display (meaning that the key is neither `bank` nor `cash`) to the player and no icon url is set, the default icon of the cash economy will be used.

## Managing via LabyModPlayer (Recommended)

The `LabyModPlayer` class provides a range of methods to manage the economy displays.

### Get an Economy Display

All economy displays updated or sent with either the update or send method will be stored in the `LabyModPlayer`
object. <br/>
Economies sent outside the LabyModPlayer object cannot be accessed via the methods below.

=== ":fontawesome-solid-building-columns: Bank Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Get the Bank Economy Display
    EconomyDisplay bankEconomy = labyModPlayer.bankEconomy();
    ```

=== ":fontawesome-solid-money-bill: Cash Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Get the Cash Economy Display
    EconomyDisplay cashEconomy = labyModPlayer.cashEconomy();
    ```

=== ":fontawesome-solid-dollar-sign: Custom Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Get the Custom Economy Display. Replace "custom" with the key of your custom 
    // economy
    EconomyDisplay customEconomy = labyModPlayer.getEconomy("custom"); // Nullable!
    ```

### Update an Economy Display

You can directly update the economy stored in the `LabyModPlayer` object and send it to the player.

Methods to update the economy display's values are shown in the [Economy Display Model](#the-economy-display-model).

=== ":fontawesome-solid-building-columns: Bank Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Update the Bank Economy Display
    labyModPlayer.updateBankEconomy(economy -> {
      // Update the values of the economy
    });
    ```

=== ":fontawesome-solid-money-bill: Cash Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Update the Cash Economy Display
    labyModPlayer.updateCashEconomy(economy -> {
      // Update the values of the economy
    });
    ```

=== ":fontawesome-solid-dollar-sign: Custom Economy"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Update the Custom Economy Display. Replace "custom" with the key of your 
    // custom economy
    labyModPlayer.updateEconomy("custom", economy -> {
      // Update the values of the economy
    });
    ```

### Send an Economy Display

When updating an economy, you can either use [Update an Economy Display](#update-an-economy-display) or the following
method to store and send it
to the player.

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Store and Send the Economy Display
labyModPlayer.sendEconomy(economyDisplay);
```

## Sending via the LabyModProtocol

While not recommended, it is also possible to send the economy displays directly via the `LabyModProtocol`.<br/>
But keep in mind, that you have to store the economies yourself if you want to update them later.

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new EconomyDisplayPacket(economyDisplay));
```
