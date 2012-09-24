### S-Story makes it easy to make full-browser-width magazine-style mini-sites. 

It is designed to make it easy to make beautiful photo-essays with other embedded media types like video, audio, or timelines. The effort should be spent building the story, not building the story's website, so I've done my best to make it as easy as possible to simply take image URLs and type some text, and get something great. 

The images, videos, and embeds are fully responsive. They always stretch to be fullscreen, whether on an enormous display, or an iPhone. Simply provide your URLs, embeds, and text, and know that your story can be seen on any device. 

It allows you to create sections made of:

1. Large image 
2. Large image with caption
3. Large image with paragraphs of text
4. Embedded video from Vimeo
5. Embedded audio from SoundCloud
6. Embedded map powered by Leaflet.js **TODO**
7. Embedded verite timeline

Build your site as your normally would, but for the content of your S-Story include a "#container" element and your "#nav" element. Style your site as you normally would. 

Each section is given a class of ".section" and what type of section it is "image1, image2, image3, vimeo, soundcloud, map, timeline" and an id that denotes which section it is.

Sections are passed to S-Story in an array of objects. For example:

    var sections = [{
        title: "The beginning (Large image)"
        ,type: "image"
        ,url: "http://large-image-url.com"
        ,height: "500px"
    },
    {
        title: "Part 2 (Large image w/ caption)"
        ,type: "image2"
        ,url: "http://large-image-url.com"
        ,height: "600px"
        ,caption: "Caption string goes here."
    },
    {
        title: "Part 3 (Large image w/ paragraphs)"
        ,type: "image3"
        ,url: "http://large-image-url.com"
        ,height: "800px"
        ,text: "<h3>Lorem ipsum dolor sit amet</h3> <p>consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p> <p> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>"
    },
    {
      title: "Part 4 (Embedded Vimeo video)"
      ,type: "vimeo"
      ,url: "http://vimeo-url.com"
      ,height: "500px"  
    },
    {
        title: "Part 5 (Embedded Soundcloud audio)"
        ,type: "soundcloud"
        ,url: "http://soundcloud-url.com"
    },
    {
        title: "Map section (Leaflet map)"
        ,type: "map"
        ,locations: [
        {
            popup: "This is what comes up when you click on a polygon."        
            ,points: [[37.80857, -122.27092], 
                    [37.80905, -122.27079], 
                    [37.80913, -122.27134]]
            ,options: {
                color: "red",
                weight: 8
            }
        },
        {
            popup: "This is another polygon to click on"        
            ,points: [[37.80857, -122.27092], 
                    [37.80905, -122.27079], 
                    [37.80913, -122.27134],
                    [37.80865, -122.27147]]
            ,options: {
                color: "red",
                weight: 8
            }
        }
        ]
    },
    {
        title: "Timeline section (Verite timeline)"
        ,type: "timeline"
        ,url: "https://docs.google.com/spreadsheet/pub?key=0ApAkxBfw1JT4dExOOVg4b29FWG5nOURTLTlCbDhsTVE&output=html"
    }]
    
    /* Add all of the sections to the specified container */
    $('#container').sStory(sections)
