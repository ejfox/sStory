class sStory
  constructor: (@story_list) ->    
    if @story_list is undefined
      throw "No story_list defined"
    
  render: ->
    $content = $('#content')
    $content.html("")
    _.each(@story_list, (section, i) ->
        # Append the contents of each section to the page
        sectionContent = JSON.stringify(section)        
        $content.append($("<h2>"+sectionContent+"</h2>"))
    )
    return @story_list
    
  list: ->
    # Return the story list object
    @story_list
    
class sStoryEditor
  constructor: (@story) ->
    @story_list = @story.list()
    #console.log("@story_list", @story.list())
    
    @sectionTypes =
      photo:
        photoBigText:
          inputs: ['url', 'title']
        photoCaption:
          inputs: ['url', 'caption', 'title']
      video:
        videoYouTube:
          inputs: ['embedCode', 'caption']
        videoVimeo:
          inputs: ['embedCode', 'caption']
      sound:
        soundSoundcloud:
          inputs: ['embedCode', 'title']
      location:
        locationSinglePlace:
          inputs: ['address', 'caption', 'photo']
    
    @renderList()
    @renderSectionTypeSelector()
    
          
  renderSectionTypeSelector: ->
    $select = $("#new-section-type")

    _.each(_.keys(@sectionTypes), (sectionType) ->
      $option = $('<option value="'+sectionType+'">'+sectionType+'</option>')
      $select.append($option)
    )
    
    @renderSectionEditor()
    
  renderSectionEditor: ->
    templates = {}
    $(".editor-template").each(->
        templateSource = $(this).html()
        templates[$(this).attr('id')] = Handlebars.compile(templateSource)
    )
    console.log("templates!!", templates)
    $editor = $("#editor-inputs")
    
    
    
    
    
  renderList: ->
    $content = $('#section-list')
    
    $content.html("")    
    _.each(@story_list, (section, i) ->
        # Append the contents of each section to the page
        sectionContent = JSON.stringify(section)        
        $content.append($("<li>"+sectionContent+"</li>"))
    )

    $sortable = $content.sortable()
    
    $sortable.bind('sortupdate', ->
        console.log("re-sort!", $(this))
        sortableSet = true
    );
    
    
  addSection: (section) ->
    sectionCount = d3.max(_.keys(@story.list())); # Figure how many sections there are
    console.log("count:", sectionCount)
    
    # Create the new section     
    newSectionNum = (+sectionCount)+1
    @story_list[newSectionNum] =
      title: "Section "+(newSectionNum+1)
      type: "photo1"
      
    # Update the page
    @renderList()
    @story.render()









# This should eventually be in the main page's HTML not here
    
$(document).ready(->
  
  story_list = 
        0: 
          title: "Section1"
          type: "photo1",
        1:
          title: "Section2"
          type: "photo2"
  
  story = new sStory(story_list)

  story.render()

  storyEditor = new sStoryEditor(story)
  
  d3.select("#add-section")
    .on("click", ->
      storyEditor.addSection()
    )
)