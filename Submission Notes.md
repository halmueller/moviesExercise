### Submission from Hal Mueller

## Extras

My surprise feature was a thorough impementation of Accessibility traits and hints,
to make the app usable by low-vision and unsighted movie fans. Sensible traits and
hints are available throughout, so that a tap on a UI element gives semantically
useful information like the name of a movie, instead of just "tableview cell".
For instance, the rating stars stack speaks the IMDB rating, instead of "button,
button, button..." This is best experienced on device, not on simulator.

## Known bugs
There are a couple of points that I'd like to fix, but I'm not going to have any time
to work on this project in the next few days, and it's time to get it out the door.

I couldn't solve the puzzle of the varying return type in the "director" JSON element. Sometimes
a film has a single director as a string, and sometimes it has multiple directors,
as an array. I'm certain that there's an elegant solution using a Decoder override
that will allow me to use Codable, but it has eluded me and I'm out of time to work
on this project. The `directorsArray` and `directorsWrapper` branches have my two
attempts at this. JSONSerialization would have worked, of course, and would have
been my backup if this had been an urgently needed feature.

The detail view does not handle landscape orientation. The right way to solve this
is to split it into two UIViews, for the top and the bottom of the specified layout.
Those would be continaed in a StackView, which changes orientation with the device,
showing the "bottom" section to the right of the "top" section. 

