# sStory
sStory is designed to make it easy to tell beautiful stories on the web with a variety of media. It will take care of the presentation and technical aspects of telling a story through the web so that creators can focus on the narrative and gathering great material.

sStory is an open-source self-hosted solution so that creators, journalists, and newsrooms can publish their work online without trusting someone else's server or terms of service. It is also meant to be customized and extended, Pull Requests and ideas welcome!


* Easily stitch together sections made of photos, videos, sounds, maps and more
* Focused on beautiful presentation and interactions
* Extendable, made to fit into pre-existing systems and CMS
* Supports YouTube, Vimeo, SoundCloud, and more for embedding media
* Your story's structure is stored in hand-editable JSON

## Getting Started


### Set up
**index.html** in the main directory is an example of an HTML file with all of the dependencies. 

If aren't including sStory into a pre-existing site or CMS, you can rename and modify **index.html** and skip to [creating the story_list](#create-your-story-list).

#### Custom Installation

You will need to sStory itself (both JS and CSS), as well as *3rdparty.min.js* which contains all of the 3rd party JS files combined and minified. The maps also default to using [Stamen map tiles](http://maps.stamen.com/#watercolor/12/37.7706/-122.3782), which you will need to include if you will be using any map sections. 

```
<script src="lib/js/3rdparty.min.js" type="text/javascript" charset="utf-8"></script>
<script src="http://maps.stamen.com/js/tile.stamen.js?v1.2.4" type="text/javascript"></script>  
<script src="lib/js/sstory.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="lib/styles/style.css" type="text/css" media="screen" title="sStory Styles" charset="utf-8">
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
// Story list
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
```

![Here's what that example story looks like](https://github.com/ejfox/sStory/raw/tabula-rasa/documentation/basic_story.png)

If you'd like to have a header with navigation / the title of your article, include the following HTML. Replace the content of the `<h1>` and `<h4>` tags with your own title / subtitle. 
```
<nav id="header">
  <div id="header-content" class="show-front">
    <div id="header-front">
      <h1 id="title">Title of this story</h1>
      <h4 id="subtitle">Subtitle / Section title</h4>
    </div>

    <ul id="navigation">
    </ul>

    <div id="header-bottom"><div id="progress" style="width: 0%;">&nbsp;</div></div>
  </div>
</nav>
```

## Section Types
All sections, even if they do not require it, can accept a 'title' parameter which will be displayed in the navigation menu. 

### Text

Text sections accept HTML and display it in an easy-to-read line width. Currently text sections are very basic, but will soon include the ability for asides with a variety of media.
```
{
  type: 'text'
  ,html: '<h2>Scraping your own data</h2><p>This morning as I was browsing my Twitter feed, <a href="http://www.people-press.org/obama-romney-voter-preferences/">I found Pew had released an interesting set of data</a>. Of course my first instinct is to visualize it. However, their data was locked in a table on their website. It wasn’t available for download as a CSV, or through a JSON API. <strong>Oh well, let’s make our own.</strong></p>'
}
```

### Photo
Photo sections stretch to fill the entire browser window (images will be cropped and display differently on devices with different aspect ratios). They **must have** a photo URL. They can **optionally** have a title or caption.

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

### Code

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


## FAQ

#### How big is it?
sStory itself is 34kb uncompressed. It's dependencies are around 388kb, but include things like jQuery and Underscore which you may already be serving. 

#### How do I adjust the size of photos?
Short answer: you can't. Photos will stretch to fill the screen, and if the aspect ratio of the user's screen is different than the photo, the sides of the photo may be cropped out. Because of this, only content in the center of the photo can be guaranteed to be seen on all screens. 