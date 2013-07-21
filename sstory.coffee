class sStory
  constructor: (@story_list) ->    
    if @story_list is undefined
      throw "No story_list defined"
    
  render: ->
    console.log("re-render")
    $content = $('#content')
    $content.html("")
    
    templates = {}
    $(".section-template").each(->
        templateSource = $(this).html()
        templates[$(this).attr('id')] = Handlebars.compile(templateSource)
    )
    
    _.each(@story_list, (section, i) ->
        #console.log "section =>", section
        # Append the contents of each section to the page
        sectionHtml = templates["section-template-"+section.type](section)
        sectionContent = $("<div id='"+i+"' class='"+section.type+"'></div>").html(sectionHtml)
        $content.append(sectionContent)
    )
    $content.append(JSON.stringify(@story_list))
    return @story_list
    
  story_list: ->
    # Return the master story list object, the heart of everything
    @story_list
    
class sStoryEditor
  constructor: (@story) ->    
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
          inputs: ['embedCode', 'caption']
          mustHave: ['embedCode']
        videoVimeo:
          inputs: ['embedCode', 'caption']
          mustHave: ['embedCode']
      sound:
        soundSoundcloud:
          inputs: ['title', 'embedCode']
          mustHave: ['embedCode']
      location:
        locationSinglePlace:
          inputs: ['address', 'caption', 'photoUrl']
          mustHave: ['address', 'caption']
    
    @giveSectionsID()
    @renderSectionList()
    @renderSectionTypeSelector()
  
  giveSectionsID: () ->
    newStory = []

    _.each(@story.story_list, (section) ->
        if section.id is undefined
          section.id = _.uniqueId("s")
        newStory.push(section)
    )
    @story.story_list = newStory
    
  renderSectionEditor: ->
    # Depending on what type of section the user wants to add
    # we show a different set of inputs which are grabbed
    # from their Handlebars templates
    
    templates = {}
    $(".editor-template").each(->
        templateSource = $(this).html()
        templates[$(this).attr('id')] = Handlebars.compile(templateSource)
    )
    
    newSectionType = $("#new-section-type").val()
    newSectionSubType = $("#sub-section-type").val()    
    
    $editor = $("#editor-inputs")

    $editor.html("")
    that = this
    _.each(@sectionTypes[newSectionType][newSectionSubType].inputs, (input) ->
        sectionData = that.sectionTypes[newSectionType][newSectionSubType]

        mustHave = $.inArray(input, sectionData.mustHave) > -1
        
        $template = $(templates['editor-template-'+input]())
        
        if mustHave
          $template.addClass("must-have")
        
        $editor.append($template)
    )
    
  renderSectionList: ->
    # Render a re-arrangeable list of each section for the editor
    $content = $('#section-list')
    
    $content.html("")
    
    that = this
    
    #console.log("@story", @story)
    _.each(@story.story_list, (section, i) ->
        # Append the contents of each section to the page        
        sectionIcon = ""
        sectionMainType = ""
        #console.log section.type
        
        switch section.type
          when "photoBigText"
            sectionMainType = "photo"
          when "photoCaption"
            sectionMainType = "photo"            
          
          when "videoYoutube"
            sectionMainType = "video"
          when "videoVimeo"
            sectionMainType = "video"
            
          when "soundSoundcloud"
            sectionMainType = "sound"
          
          when "locationSinglePlace"
            sectionMainType = "location"
          
        switch sectionMainType
          when "photo"
            sectionIcon = "<i class=\"icon-camera\"></i>"
          when "video"
            sectionIcon = "<i class=\"icon-video\"></i>"
          when "sound"
            sectionIcon = "<i class=\"icon-volume-up\"></i>"
          when "location"
            sectionIcon = "<i class=\"icon-location-circled\"></i>"
        
        deleteIcon = "<i class=\"icon-cancel-squared delete-section\"></i>"
        sectionContent = deleteIcon + sectionIcon + " "
        if section.title isnt undefined
          sectionContent += section.title
        $content.append($("<li id='"+i+"' data-id='"+section.id+"'>"+sectionContent+"</li>"))
        
        $("i.delete-section").on("click", ->
            that.deleteSection($(this).parent().attr('data-id'))
        )
    )

    $sortable = $content.sortable()
    
    that = this
    
    $sortable.bind('sortupdate', ->        
        sortedList = []
        $(this).children().each(() ->          

            sortedList.push($(this).attr("data-id"))
        )

        that.reorderStoryList(sortedList)
        sortableSet = true
    );
    
  reorderStoryList: (sortedList) ->
    console.log "sL", sortedList
    oldList = @story.story_list
    
    newStoryList = []
    _.each(sortedList, (listItemID) ->
      section = _.find(oldList, (section) ->
          return section.id is listItemID
      )
      
      newStoryList.push(section)      
    )
    console.log "new sL", newStoryList
    @story.story_list = newStoryList
    
    # Update the page
    @renderSectionList()
    @story.render()
    
    
  renderSectionSubTypeSelector: (section) ->
    # Each section type has a subtype, for example
    # photo has the subtypes 'photoBigText' and 'photoCaption'
    # so we render a selector for each of these subtypes
 
    if section is undefined
      section = "photo"
      
    subsections = @sectionTypes[section]
    $select = $("#sub-section-type")
    
    $select.html("")
    
    _.each(_.keys(subsections), (sectionType) -> 
      $option = $('<option value="'+sectionType+'">'+sectionType+'</option>')
      $select.append($option)
    )
    
    that = this
    $select.on("change", ->
      that.renderSectionEditor()
    )
    
  
  renderSectionTypeSelector: ->
    # Each section type has a type, like 'photo', 'video', 'audio'
    # we want to render a selector for each of these types
    
    $select = $("#new-section-type")
    $select.html("")

    _.each(_.keys(@sectionTypes), (sectionType) ->
      $option = $('<option value="'+sectionType+'">'+sectionType+'</option>')
      $select.append($option)
    )
  
    that = this
    $select.on("change", ->
      that.renderSectionSubTypeSelector($(this).val())
      that.renderSectionEditor()
    )

    @renderSectionSubTypeSelector()
    @renderSectionEditor()
    
  deleteSection: (delSection) ->
    console.log("Delete "+delSection)
    
    newlist = _.reject(@story.story_list, (section, k) ->
        console.log("k>", k, "delSection>", delSection)
        if section.id is delSection
          return true
        else
          false
    )
    
    @story.story_list = newlist
    console.log('@story', @story)

    # Update the page
    @renderSectionList()
    @story.render()
    
  addSection: (section) ->
    # Add a new section to @story.list()
    
    sectionCount = d3.max(_.keys(@story.story_list)); # Figure how many sections there are
    console.log("count:", sectionCount)
    
    # Create the new section     
    newSectionNum = (+sectionCount)+1
    
    newSection = {}
    
    $("#editor-inputs input").each((el) ->
        if $(this).val() isnt ""
          newSection[$(this).attr('id').split("-")[2]] = $(this).val()
    )
    
    newSection.type = $("#sub-section-type").val() 
    
    @story.story_list[newSectionNum] = newSection
    console.log("=>", @story)
    
    # Give the new section an ID 
    @giveSectionsID()
    
    # Update the page
    @renderSectionList()
    @story.render()









# This should eventually be in the main page's HTML not here
    
$(document).ready(->
  
  story_list = [
        {
          photoUrl: "http://farm8.staticflickr.com/7043/6990444744_7db8937884_b.jpg"
          type: "photoBigText"}
        ,{
          photoUrl: "http://farm8.staticflickr.com/7112/7136431759_889039ace4_b.jpg"
          title: "Livestreamers!"
          type: "photoBigText"
        }
        ,{
          photoUrl: "http://farm8.staticflickr.com/7112/7136431759_889039ace4_b.jpg"
          title: "booom-ba-booom"
          type: "photoBigText"
        }
        ,{
          photoUrl: "http://farm8.staticflickr.com/7112/7136431759_889039ace4_b.jpg"
          title: "another!!"
          type: "photoBigText"
        }
        ,{
          photoUrl: "http://farm8.staticflickr.com/7112/7136431759_889039ace4_b.jpg"
          title: "and another!!!"
          type: "photoBigText"
        }
  ]
  
  story = new sStory(story_list)

  story.render()

  storyEditor = new sStoryEditor(story)
  
  d3.select("#add-section")
    .on("click", ->
      storyEditor.addSection()
      $("#editor-inputs input").val(" ")
    )
)