class sStory
  constructor: (@story_list) ->   
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
     
    if @story_list is undefined
      throw "No story_list defined"
      
    if !typeIsArray(@story_list)
      throw "The story_list is not an array"
    
  render: ->
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
        sectionContent = $("<section id='"+i+"' class='"+section.type+"'></section>").html(sectionHtml)
        $content.append(sectionContent)
    )
    # $content.append(JSON.stringify(@story_list))
    
    
    
    @handleWindowResize()
    that = this
    $(window).on('resize', ->
      that.handleWindowResize()
    )
    
    @renderMaps()
    
    return @story_list
    
  #story_list: ->
    # Return the master story list object, the heart of everything
    #@story_list
    
  verticalCenterElement: (el, parEl)->
    elHeight = el.innerHeight() / 2
    pageHeight = parEl.innerHeight() / 2

    $(el).css({
        paddingTop: (pageHeight - elHeight)
    })
    
  verticalCenterPhotoTitles: ->
    that = this
    $(".photoBigText h2").each(->
      that.verticalCenterElement( $(this), $(this).parent() )
    )
    
    $(".photoCaption h2").each(->
      that.verticalCenterElement( $(this), $(this).parent() )
    )
    
  handleWindowResize: ->
    @verticalCenterPhotoTitles()
    
    windowHeight = $(window).height()
    $(".photoBigText .photo-background").css({
        minHeight: windowHeight
    })
    $(".photoCaption .photo-background").css({
        minHeight: windowHeight
    })
    
  renderMaps: ->
    that = this
    $(".single-location-map").each(->
      mapId = _.uniqueId("map_")
      address = $(this).attr("data-address")
      caption = $(this).attr("data-caption")
      
      latLon = []
      $(this).attr("id", mapId)      
      
      geoCode = that.geocodeLocationRequest(address)
      
      geoCode.done( (result) ->
        #console.log("geoCode result", result)
        result = result[0]
        latLon = [result.lat, result.lon]
        
        map = L.map(mapId, {
            scrollWheelZoom: false          
        }).setView(latLon, 14)
              
        layer = new L.StamenTileLayer("toner-lite");
        map.addLayer(layer);
        
        circle = L.circle(latLon, 120, {
            color: 'red'
            fillColor: 'red'
            fillOpacity: 0.5
            closeOnClick: false
        })
        .bindPopup(caption, {
            maxWidth: 600
            maxHeight: 600
            closeButton: false  
        })
        .addTo(map)
        .openPopup();
        
      )      
    )
    
  geocodeLocationRequest: (location) ->
  	#console.log("Location", location)
  	baseUrl = "http://open.mapquestapi.com/nominatim/v1/search.php?format=json"
  	addr = "&q="+location

  	url = encodeURI(baseUrl + addr + "&addressdetails=1&limit=1")

  	$.ajax({
  		url: url
  		type: "GET"
  		dataType: "json"
  		cache: true
  	})
  
    
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
    
    $("#story-editor #save").on("click", -> that.exportStoryList())
    
    document.getElementById('story_file').addEventListener('change',( -> that.importStoryList(event, that) ), false)
    
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
    
    # @TODO Figure out why there are multiple sorting events happening
    # I think we are adding a new binding every time we refresh the list
    # it needs to be destroyed before we re-make it, or check if it's made
    # and only make it if it isn't
    
    $content.sortable("destroy")
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
    # Given an order-specific array of IDs like ["s1", "s2", "s3"]
    # re-arrange the story_list objects
    oldList = @story.story_list
    
    newStoryList = []
    _.each(sortedList, (listItemID) ->
      section = _.find(oldList, (section) ->
          return section.id is listItemID
      )
      
      newStoryList.push(section)      
    )
    @story.story_list = newStoryList
    
    @updatePage()
    
  updatePage: ->
    # Update the pagee    
    @renderSectionList()
    @story.render()
    @story.handleWindowResize()
    
    
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
    # Given a section's number in the story_list array
    # Delete it!
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

    @updatePage()
    
  addSection: (section) ->
    # Add a new section to @story.list()
    
    sectionCount = d3.max(_.keys(@story.story_list)); # Figure how many sections there are
    console.log("count:", sectionCount)
    
    # Create the new section     
    newSectionNum = (+sectionCount)+1
    
    newSection = {}
    
    $("#editor-inputs input").each((el) ->
        # For every input that isn't blank, add it to the section
        if $(this).val() isnt ""          
          newSection[$(this).attr('id').split("-")[2]] = $(this).val()
    )
    
    newSection.type = $("#sub-section-type").val() 
    
    @story.story_list[newSectionNum] = newSection
    console.log("=>", @story)
    
    # Give the new section an ID 
    @giveSectionsID()
    
    @updatePage()
    
  exportStoryList: ->
    # Save the story list as a JSON file
    blob = new Blob([JSON.stringify(@story.story_list)], {type: "application/json;charset=utf-8"});
    saveAs(blob, "sstory.json");
    
  importStoryList: (evt, that) ->

    files = evt.target.files
    fileJson = []
    
    reader = new FileReader();
    
    reader.onload = ((thefile) ->
      (e) ->
        fileJson = JSON.parse(e.target.result)
        
        that.story.story_list = fileJson
        that.story.render()
        that.giveSectionsID()
        that.renderSectionList()
        
        $("#story-editor #story_file").hide()
        
    )(files[0])
        
    reader.readAsBinaryString(files[0])
    
    
    
  makeTitlesEditable: ->
    console.log "make all the titles contentEditable and add some bindings"






# This should eventually be in the main page's HTML not here
    
$(document).ready(->
  
  story_list = []
  
  story = new sStory(story_list)

  story.render()

  storyEditor = new sStoryEditor(story)
  
  d3.select("#add-section")
    .on("click", ->
      storyEditor.addSection()
      $("#editor-inputs input").val(" ")
    )
)