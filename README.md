# Vicinity

Vicinity replicates iBeacons and supports broadcasting and detecting low-energy bluetooth devices in the background.

It is built with CoreBluetooth framework and doesn't use CoreLocation to implement iBeacons.  CoreLocation itself limits how it can be used when apps are in the background, whereas CoreBluetooth fully supports background operations.

## What is iBeacon

The term iBeacon describes the ability of low-engergy bluetooth devices to broadcast and detect proximity of devices by analyzing the received signal strength of the wireless bluetooth signal.  

In the iOS SDK iBeacons are implemented in the CoreLocation framework—which places many limits on how it can be used in the background.

The CoreBluetooth framework itself supports RSSI (received signal strength indication), which is all that it is needed to replicate the iBeacon sections of CoreLocation.

The problem with using CoreLocation to detect iBeacons is this functionality is very limited once an app is in the background.  CoreBluetooth has much greater background support of iOS apps.  With CoreBluetooth, you can broadcast as a peripheral and detect as a central while in the background.  The framework will even allow limited actions within your app code while these services are running.

## INBeaconService

The heart of this is `INBeaconService`.  This replicates how iBeacons work by analyzing RSSI of low-energy bluetooth broadcasts.  Most of the work is done using `CBPeripheralManager` and `CBCentralManager`, which are classes in the CoreBluetooth framework.

Getting this to work effectively required a two things:

1. interpreting the RSSI values reliably, taking into account sensor noise and signal spikes
1. converting the RSSI values to distances

## Signal Noise

When Reading data from sensors on iOS, be that accelerometer or RSSI, the values can contain a lot of noise and spikes.  I initially tried to use a weighted average which didn't work that well.  Applying an "easing function" to smooth out the incoming signal values worked much better.

## RSSI to Distance

Converting the RSSI values to distances was a matter of trial and error.  I also cheated by realizing that iBeacons uses fuzzy distance terms like "Far", "Near", and "Immediate".  The reason for these values became obvious once we analyzed the actual data.  Bluetooth RSSI flucuates wildly at ranges beyond five feet and becomes more accurate at values less than 1 foot.

Supposedly, different bluetooth devices are going to have varying signal strengths, but the smattering of iOS devices we measured reported the same values.


## Conclusion

We hope this simple app will come in useful.

Contact us with questions!
