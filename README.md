### S-Story makes it easy to make full-browser-width magazine-style mini-sites. 

Designed to make it easy to make beautiful photo-essays with other embedded media types like video, audio, or timelines. [Watch an introductory video](https://vimeo.com/50500145).

The images, videos, and embeds are fully responsive. They always stretch to be fullscreen, whether on an enormous display, or an iPhone. Simply provide your URLs, embeds, and text, and know that your story can be seen on any device. You can [see a basic demo here](http://ejfox.github.com/sStory/) or an example story based on [OWS's 1 year anniversary in NYC](http://ejfox.github.com/sStory/nyc_s17.html).

sStory [also has a tool to aid in creating your JSON](http://ejfox.github.com/sStory/make_story.html) based on images / captions / embeds you provide. 

sStory allows you to create sections made of:

1. Large image 
2. Large image with caption
3. Large image with paragraphs of text
4. Embedded video from Vimeo
5. Embedded audio from SoundCloud
6. Embedded verite timeline
7. Plain text


Coming soon:

+ Embedded leaflet maps

Sections are passed to S-Story in an array of objects. For example:

    var sections = [
    {
    	title: "Text-only"
    	,type: "text"
    	,text: "Lorem ipsum dolor sit etc… use for long text, please."
    }
    ,{
        title: "Large Image"
        ,type: "image"
        ,url: "http://large-image-url.com"
    },
    {
        title: "Large Image with Caption"
        ,type: "image2"
        ,url: "http://large-image-url.com"
        ,caption: "Caption string goes here."
    },
    {
        title: "Large Image with Paragraphs"
        ,type: "image3"
        ,url: "http://large-image-url.com"
        ,caption: "<h3>Lorem ipsum dolor sit amet</h3> <p>consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p> <p> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>"
    },
    {
      title: "Embedded Vimeo Video"
      ,type: "vimeo"
      ,url: "http://player.vimeo.com/video/36256273?byline=0&portrait=0&color=ffffff"
      ,caption: "Even videos can have captions, though not often."
    },
    {
        title: "Part 5 (Embedded Soundcloud audio)"
        ,type: "soundcloud"
        ,embed: "<iframe width='100%' height='166' scrolling='no' frameborder='no' src='http://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F37934185&amp;auto_play=false&amp;show_artwork=false&amp;color=000000'></iframe>"
    },
    {
        title: "Timeline section (Verite timeline)"
        ,type: "timeline"
        ,url: "https://docs.google.com/spreadsheet/pub?key=0ApAkxBfw1JT4dExOOVg4b29FWG5nOURTLTlCbDhsTVE&output=html"
    },
	{
	    title: "TODO: Map section (Leaflet map)"
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
	}
    ]
    
Once you've created the objecrs for each of your sections, creating the sStory is as simple as
    
    /* Add all of the sections to the specified container */
    $('#container').sStory(sections)
    
---

### How to add sections to sStory

You can use the [sStory make_story tool](http://ejfox.github.com/sStory/make_story.html) to easily create your sStory if you don't want to get your hands messy with JSON. [This video shows how to do that.](https://vimeo.com/50500145)

#### Images 
You simply need the URL of the image. For images with long captions (image3) you can include any HTML that you like in the caption. 

#### Vimeo
If you go to your video and click share. Vimeo's sharing box will appear. Copy the embed code and paste it into your embed code section.

![Vimeo howto](http://ejfox.github.com/sStory/howto/howto-vimeo.png)

#### Soundcloud
Go to your soundcloud track and click share. Soundcloud's sharing box will appear. You will need to get the src URL from the embed code and copy it over.

\<iframe width="100%" height="166" scrolling="no" frameborder="no" src=***"http://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F58373178&show_artwork=true"***>\</iframe>

#### Timeline
From your google spreadsheet, which is formatted to the [correct specifications](https://docs.google.com/a/digitalartwork.net/previewtemplate?id=0AppSVxABhnltdEhzQjQ4MlpOaldjTmZLclQxQWFTOUE&mode=public), go to **File > Publish to Web** - in the window that pops up, you want to copy and paste the URL at the bottom of the window. 
