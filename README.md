# Vesc Status

The Vesc Status is an Iphone based app written in Objective-C that allows users to track, record, graph, and pull up past ride data, all in the same app.

Users can also record 0-20 acceleration, and view a large full screen speedometer, all based off of the vesc erpm data.

Full features include:

   - Keep settings for up to 4 boards
   - Switch between US and Metric systems
   - Push notifications for 20%, 50%, and 100% of battery status
   - Acceleration Timer
   - Speedometer
   - Live time display of 18 data points, including time, distance, speed, battery amps, motor amps, and more
   - Graphing with Battery Voltage, Battery Amps, Motor Amps, FET Temp, and Speed
   - Record vesc data into a "session" and pull up past "sessions" in the ride history tab
   - You can view current vesc data without recording a session
   - Battery meter with percentage

This app is for use with the adafruit UART bluetooth module only.

You can purchase this chip from us, Rocket Boards, at http://www.rocketboards.club/ pre assebled for all vesc versions.

You can also purchase this chip from adafruit un-assembled, and you would need to wire it like this with a jst-6 or jst-7 plug, depending on the version of your vesc:

    VESC Pin (RX) -> Adafruit TX
    VESC Pin (TX) -> Adafruit RX
    VESC Pin (GND) -> Adafruit GND + Adafruit CTS
    VESC Pin (VCC) -> Adafruit vIN

The bluetooth communication code for getting current vesc values was written by gpxiBen, and his repository can be found here: https://github.com/gpxlBen/VESC_Logger

If you would like to donate to this project, you can do so here: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=U84LWR2P7WSQN
Buying the chips from us is also a way of helping donate towards the dvelopment of this software.
