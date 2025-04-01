import os
from dotenv import load_dotenv
load_dotenv()

from baml_client import b
from baml_client.types import Hikes


def parse_hikes(hikes: str) -> Hikes:
  return b.ExtractHikes(hikes)

hike_description = """
Just spent the day exploring the Reflection Lakes Trail at Mount Rainier National Park in Washington state. This is definitely an easy-moderate difficulty trail that's perfect if you want gorgeous views without killing yourself on elevation gain. It's only about 2 miles round trip with minimal climbing.
The highlight has to be the stunning reflections of Mount Rainier in the crystal-clear alpine lakes - hence the name! I went early morning when the water was perfectly still and got some incredible photos. The trail winds through beautiful subalpine meadows that were filled with wildflowers. Saw lots of wildlife too - a few deer and even a black bear in the distance (don't worry, it was just minding its own business). The trail connects to several others if you want to extend your hike. Definitely bring your camera for this one, the mountain views reflected in the lakes are absolutely postcard-perfect!
"""

hikes = parse_hikes(hike_description)
print(hikes)
# print(hikes)
# print(hikes.name)
# print(hikes.location)
# print(hikes.difficulty)
# print(hikes.distance)
# print(hikes.attractions)
