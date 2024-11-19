# Dojo Learns Basic Math!

The earth is, of course, flat.

However, for some ridiculous reason getting the distance from New York to Paris is not as simple
as putting a really long ruller between the two.

Let's create a quick console tool that would accept as input two cities and calculate the
distance between two cities if we were to walk in a straight line. Translate to your own walking speed.

* In the resources folder there is a world-cities.csv file that includes cities and their lattitude & longitude.
* We should try to use the Haversine formula:

```
a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)`
c = 2 ⋅ atan2( √a, √(1−a) )
d = R ⋅ c

# where: 	φ is latitude, λ is longitude, R is earth’s radius(if it wasn't flat, it would be somewhere around 6371 km).
# note that angles need to be in radians to pass to trig functions!

```

Part 1:
---------------

Run a program that is able to output the distance between any two cities in the dataset (accept as cli input if feeling funky)


Part 2:
------

Already done? Use the google maps api and display the eart surface distance AND the driving distance.


Remember to add your solution!
