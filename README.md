# sStory
sStory is designed to make it easy to tell beautiful stories on the web with a variety of media. It is meant to take care of the presentation and technical aspects of telling a story through the web, so that creators can focus on narratives and gathering material. 

sStory is an open-source self-hosted solution so that creators, journalists, and newsrooms can publish their work online without trusting someone else's servers or avoiding dodgy terms of service.

* Easily stitch together sections made of photos, videos, sounds, maps and more
* Extendable, made to fit into pre-existing systems
* Supports YouTube, Vimeo, SoundCloud for embedding media
* Your story's structure is stored in hand-editable JSON
* A focus on beautiful presentation and interactions

## Getting Started


### Include dependencies
Include jQuery, Underscore, D3, Handlebars, Sortable, and Leaflet which sStory depend on. After that, pull in sStory and it's stylesheet. 

```
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="http://underscorejs.org/underscore.js"></script>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script src="handlebars.js" type="text/javascript" charset="utf-8"></script>  
<script src="jquery.sortable.js" type="text/javascript" charset="utf-8"></script>
<script src="lib/leaflet.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="leaflet.css" type="text/css" media="screen" charset="utf-8">

<script src="sstory.js"></script>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" charset="utf-8">
```

### Create your story list
The story_list is the heart of every sStory, and it is essentially an array of objects, one for each section. It is order-specific, with the first item appearing at the top of the page. 

Simply create a new sStory and feed it the story_list array, and then render. 

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
          type: 'photoBigText'
          title: 'Making beautiful stories easy'
        }
  ]
  
  var story = new sStory(story_list)

  story.render()

})
```

## Section Types
### Photo
Photo sections stretch to fill the entire browser window (images will be cropped and display differently on devices with different aspect ratios). They **must have** a photo URL. They can **optionally** have a title or caption. 

There are two types of photo section.

**photoBigText:** Which is for photos with no title, or photos with just a title.
```
{
  type: 'photoBigText'  
  photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
  title: 'Making beautiful stories easy'
}
```

**photoCaption:** Which is for photos with a caption, or with a caption and a title.
```
{
  type: 'photoCaption'  
  photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
  title: 'Making beautiful stories easy'
}
```

### Video
You can add video sections with embedded videos from YouTube or Vimeo. You will give the entire embed code to sStory. 

**videoYoutube:** Add videos from YouTube by using their embed code. You can find it in the _share_ tab beneath each video by clicking the _embed_ button. You don't need to change any of the options. You will be given some code for an iFrame embed.

```
{
  type: 'videoYoutube'  
  embedCode: '<iframe width="420" height="315" src="//www.youtube.com/embed/dQw4w9WgXcQ?rel=0" frameborder="0" allowfullscreen></iframe>'
}
```

**videoVimeo:** Vimeo videos can be added the same way YouTube videos are added. Simply add the embed code to sStory. You can find Vimeo's embed code by clicking on the _share_ button that appears in the top-right of videos.

```
{
  type: 'videoVimeo'  
  embedCode: '<iframe src="http://player.vimeo.com/video/35912908?badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/35912908">FACETURE</a> from <a href="http://vimeo.com/user9669590">Phil Cuttance</a> on <a href="https://vimeo.com">Vimeo</a>.</p>'
}
```

### Sound
**soundSoundcloud:** Audio from soundcloud can be embedded as well. You can find the embed code by clicking on the _share_ button in the bottom of each Soundcloud player. It is the iframe code labeled _Widget Code_. 

```
{
  type: 'soundSoundcloud'  
  embedCode: '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F99067369"></iframe>'
}
```

### Location
**locationSinglePlace:** A single location with an address and a caption. A leaflet map is generated with a marker and a popup with the provided caption. An optional photoUrl can be provided to add an image to the popup. 
```
{
  type: 'locationSinglePlace'
  address: "1600 Pennsylvania Ave NW  Washington, DC"
  caption: "An address!"
}
```

## Adding new section types
Sections in sStory are made of 4 simple things: the **section template** which is the handlebars template for how the section appears on the page, any new **editor input template** if needed, and the **section specification** which details for sStory what inputs a section has, and which are mandatory. 

#### Section Template
The section template is currently defined in the story HTML, but should be moved to a separate file with the rest of the section templates. 

Check this example of photoBigText's section template.

```
<script id="section-template-photoBigText" class="section-template" type="text/x-handlebars-template">
<div class="photo-background" style="background-image: url({{photoUrl}})">
{{#if title}}
  <h2>{{title}}</h2>
{{/if}}
</div>
</script>
```

#### Editor Input Template
Every section type takes different inputs, but they share many. The inputs currently included are **photoUrl**, **title**, **caption**, **embedCode**, **address**. If your new section type only uses these, you need not worry about an editor input template. If you were adding a new "person" section type, you might want to give it a "Full Name" input.

Check these input templates for **photoUrl** and **title** used by the **photoBigText** section template.
```
<script id="editor-template-photoUrl" class="editor-template" type="text/x-handlebars-template">
<p>
  <i class="icon-infinity"></i> <input type="text" id="editor-section-photoUrl" placeholder="Photo URL"></input>  
</p>
</script>

<script id="editor-template-title" class="editor-template" type="text/x-handlebars-template">
<p>
   <i class="icon-dot-3"></i> <input type="text" id="editor-section-title" placeholder="Title"></input>  
</p>
</script>
```

#### Section Specification
Section specifications can be found in the sStoryEditor constructor. There are 4 categories, containing objects for each section type. The *inputs* array contains every input the section could possibly have. The *mustHave* array contains the inputs the section must have to display. 

```
@sectionTypes =
  photo:
    photoBigText:
      inputs: ['title', 'photoUrl']
      mustHave: ['photoUrl']
    photoCaption:
      inputs: ['title', 'photoUrl', 'caption']
      mustHave: ['photoUrl', 'caption']
  video:
    videoYoutube:
      inputs: ['embedCode']
      mustHave: ['embedCode']
    videoVimeo:
      inputs: ['embedCode']
      mustHave: ['embedCode']
  sound:
    soundSoundcloud:
      inputs: ['embedCode']
      mustHave: ['embedCode']
  location:
    locationSinglePlace:
      inputs: ['address', 'caption', 'photoUrl']
      mustHave: ['address', 'caption']
```