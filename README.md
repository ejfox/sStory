# sStory
sStory is designed to make it easy to tell beautiful stories on the web with a variety of media. It is meant to take care of the presentation and technical aspects of telling a story through the web, so that creators can focus on narratives and gathering material. 

sStory is an open-source self-hosted solution so that creators can feel comfortable publishing their work online without trusting someone else's servers or avoiding dodgy terms of service. It is also designed to be heavily customizable and extendable, so you can fit it into your pre-existing systems. 

## Getting Started


### Include dependencies
Include jQuery, Underscore, D3, Handlebars, Sortable, and Leaflet which sStory depend on. After that, pull in sStory and it's stylesheet. 

```
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="http://underscorejs.org/underscore.js"></script>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script src="handlebars.js" type="text/javascript" charset="utf-8"></script>  
<script src="jquery.sortable.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="leaflet.css" type="text/css" media="screen" charset="utf-8">

<script src="sstory.js"></script>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" charset="utf-8">
```

### Create your story list

```
$(document).ready(function(){
  
  story_list = [
        {
          type: 'locationSinglePlace'
          ,address: "1600 Pennsylvania Ave NW  Washington, DC"
          ,caption: "An address!!"
        }
        ,{
          photoUrl: 'http://farm9.staticflickr.com/8315/8018537908_eb5ac81027_b.jpg'
          type: 'photoBigText'
          title: 'Making beautiful stories easy'
        }
  ]
  
  story = new sStory(story_list)

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
### Location