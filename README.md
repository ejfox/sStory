# sStory
sStory is designed to make it easy to tell beautiful stories on the web with a variety of media. It will take care of the presentation and technical aspects of telling a story through the web so that creators can focus on the narrative and gathering great material.

sStory is an open-source self-hosted solution so that creators, journalists, and newsrooms can publish their work online without trusting someone else's server or terms of service. It is also meant to be customized and extended, Pull Requests and ideas welcome!


* Easily stitch together sections made of photos, videos, sounds, maps and more
* Focused on beautiful presentation and interactions
* Extendable, made to fit into pre-existing systems and CMS
* Supports YouTube, Vimeo, SoundCloud, and more for embedding media
* Your story's structure is stored in hand-editable JSON

## Getting Started


### Include dependencies and set up
**template.html** in the main directory is an example of an HTML file with all of the dependencies if you are a beginner. 

If you are using sStory in it's own standalone website, you can do this and skip to [creating the story_list](#create-your-story-list).

#### Custom Installation

You will need to include jQuery, Underscore, D3, Handlebars, Sortable, and Leaflet which sStory depend on. After that, pull in sStory and it's stylesheet.

```
<!-- External libraries for sStory -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="http://underscorejs.org/underscore.js"></script>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script src="lib/leaflet.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="leaflet.css" type="text/css" media="screen" charset="utf-8">

<!-- sStory -->
<script src="sstory.js"></script>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" charset="utf-8">
```

You will also need a DOM element with the id of **#content** which sStory will fill with the content of the story. 
```
<body>
<div id="#content"></div>
</body>
```

### Create your story list
The story_list is the heart of every sStory, and it is essentially an array of objects, one for each section. It is order-specific, with the first item appearing at the top of the page.

Once the document has loaded, simply create a new sStory and feed it the story_list array, and then render.

```
$(document).ready(function(){

  var story_list = [
        {
          type: 'locationSinglePlace'
          ,address: "1600 Pennsylvania Ave NW  Washington, DC"
          ,caption: "An address!"
        }
        ,{
          photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
          ,type: 'photoBigText'
          ,title: 'Making beautiful stories easy'
        }
  ]

  var story = new sStory(story_list)

  story.render()

})
```

![Here's what that example story looks like](https://github.com/ejfox/sStory/raw/tabula-rasa/documentation/basic_story.png)


## Section Types
### Photo
Photo sections stretch to fill the entire browser window (images will be cropped and display differently on devices with different aspect ratios). They **must have** a photo URL. They can **optionally** have a title or caption.

There are two types of photo section.

**photoBigText:** Which is for photos with no title, or photos with just a title.
```
{
  type: 'photoBigText'
  ,photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
  ,title: 'Making beautiful stories easy'
}
```

**photoCaption:** Which is for photos with a caption, or with a caption and a title.
```
{
  type: 'photoCaption'
  ,photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
  ,title: 'Making beautiful stories easy'
  ,caption: '<h3>Hello world!</h3><p>Lorem ipsum <em>dolor sit</em> amet. Include styled <span style="color: red">HTML</span>!'

}
```

**photoMulti:** is for including multiple photos in a single section, and doesn't support captions or titles.
```
  {
    type: 'photoMulti'
    ,photoUrlArray: ['http://37.media.tumblr.com/76cd2f0e146ac4d6251bd9ff28eb8307/tumblr_ms91cgSwmX1qcn8pro1_1280.jpg', 'http://24.media.tumblr.com/9a5c41e468022c91dfd201053d1a099b/tumblr_ms91cgSwmX1qcn8pro2_1280.jpg', 'http://24.media.tumblr.com/5aeb959fd9c416f18e80d27b84384f1b/tumblr_ms91cgSwmX1qcn8pro3_1280.jpg']
  }
```    

### Video
You can add video sections with embedded videos from YouTube or Vimeo. You will give the entire embed code to sStory.

**videoYoutube:** Add videos from YouTube by using their embed code. You can find it in the _share_ tab beneath each video by clicking the _embed_ button. You don't need to change any of the options. You will be given some code for an iFrame embed.

```
{
  type: 'videoYoutube'
  ,embedCode: '<iframe width="420" height="315" src="//www.youtube.com/embed/dQw4w9WgXcQ?rel=0" frameborder="0" allowfullscreen></iframe>'
}
```

**videoVimeo:** Vimeo videos can be added the same way YouTube videos are added. Simply add the embed code to sStory. You can find Vimeo's embed code by clicking on the _share_ button that appears in the top-right of videos.

```
{
  type: 'videoVimeo'
  ,embedCode: '<iframe src="http://player.vimeo.com/video/35912908?badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/35912908">FACETURE</a> from <a href="http://vimeo.com/user9669590">Phil Cuttance</a> on <a href="https://vimeo.com">Vimeo</a>.</p>'
}
```

### Sound
**soundSoundcloud:** Audio from soundcloud can be embedded as well. You can find the embed code by clicking on the _share_ button in the bottom of each Soundcloud player. It is the iframe code labeled _Widget Code_.

```
{
  type: 'soundSoundcloud'
  ,embedCode: '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F99067369"></iframe>'
}
```

### Location
**locationSinglePlace:** A single location with an address and a caption. A leaflet map is generated with a marker and a popup with the provided caption. An optional photoUrl can be provided to add an image to the popup.
```
{
  type: 'locationSinglePlace'
  ,address: "1600 Pennsylvania Ave NW  Washington, DC"
  ,caption: "An address!"
}
```

**locationTimeline:** A list of locations with an address, a date/time, and a caption. A leaflet map is generated with a marker and pop-up for each item. An optional photoUrl can be provided to add an image to the popup. Navigation will be provided to move forward and backward between items.

```
{
  type: 'locationTimeline'
  list: [
  	{
  		address: "1600 Pennsylvania Ave NW  Washington, DC"
  		,caption: "An address!"
  		,time: "1-1-1792"
	}
	,{
  		address: "2 15th St. NW Washington, D.C."
  		,caption: "An address!"
  		,time: "1-1-1848"
	}
	,{
  		address: "2 Lincoln Memorial Cir NW, Washington, DC"
  		,caption: "An address!"
  		,time: "1-1-1868"
	}
  ]
}
```

### Code
**codeGist:** Include a [Gist](http://gist.github.com), which can be multiple files and display their source code on the page.

```
{
  type: 'codeGist'
  ,url: 'http://gist.github.com/ejfox/4260347'
}
```

**codeTributary:** Embed a live Tributary example.

```
{
  type: 'codeTributary'
  ,url: 'http://tributary.io/tributary/2958568/'
}
```

### Timeline
**timelineVerite:** Include a [Timeline JS](http://timeline.verite.co/) timeline embed, which you can find at step 4 of [TimelineJS walkthrough here](http://timeline.knightlab.com/).
```
{
  type: 'timelineVerite'
  ,embedCode: "<iframe src='http://cdn.knightlab.com/libs/timeline/latest/embed/index.html?source=0ApAkxBfw1JT4dFVxOEk0aGRxbk9URE9yeDJKMXNIS3c&font=Bevan-PotanoSans&maptype=toner&lang=en&start_at_slide=1&height=650' width='100%' height='650' frameborder='0'></iframe>"
}
```
**timelineStorify:** Include an embedded storify by copying in the embed code from the *Distribute* tab at the top of a storify page.

```
{
  type: 'timelineStorify'
  embedCode: '<script src="//storify.com/ejfox/occupy-oakland-may-1st-general-strike.js" type="text/javascript" language="javascript"></script><noscript>[<a href="//storify.com/ejfox/occupy-oakland-may-1st-general-strike" target="_blank">View the story "Occupy Oakland - May 1st General Strike" on Storify</a>]</noscript>'
}
```


## FAQ

