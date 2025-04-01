
class Hikes {
  name string
  location string
  difficulty string
  distance float
  attractions string[]
}


function ExtractHikes(hikes: string) -> Hikes {
  client "openai/gpt-4o"
  prompt #"
    Extract from this content:
    {{ hikes }}
    {{ ctx.output_format }}
  "#
}

test TestName {
  functions [ExtractHikes]
  args {
    hikes #"
Just got back from an amazing hike at Mount Rainier National Park in Washington! The Skyline Trail Loop was absolutely worth the challenge. It's rated as moderate-difficult, mainly because of the 1,700 feet of elevation gain that definitely got my heart pumping. The loop is about 5.5 miles, and I spent a good 4 hours taking it all in.

The views were absolutely spectacular - so many wildflowers in bloom, and I could see Mount Adams, Mount St. Helens, and Mount Hood on the horizon. The trail starts at Paradise visitor center and takes you through alpine meadows with streams and waterfalls. Saw a family of marmots sunning themselves on the rocks! The Nisqually Glacier view point was definitely my favorite spot - truly breathtaking. Bring layers though, it gets chilly even in summer at those elevations!


    "#
  }
}
