class sStory
  constructor: (@story_list, @options) ->
    # Make sure that sStory is being started
    # with a story_list, and that it is an array
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    if @story_list is undefined
      throw "No story_list defined"

    if !typeIsArray(@story_list)
      throw "The story_list is not an array"

    #if @options is undefined
    @options = 
      targetID: '#content'

  render: ->
    # Render the sStory
    targetID = @options.targetID

    targetContainer = d3.select(targetID)

    sections = targetContainer.selectAll("section")
      .data(@story_list)
    .enter().append("section")
      .attr('class', (d) -> d.type)
      .attr('data-title', (d) -> d.title)
      .attr('id', (d,i) -> 'section'+(i+1))

    ## Photo Sections ##

    # photoBigText
    photoBigText = targetContainer.selectAll('.photoBigText')
    .attr('class', 'photoBigText photo')
    .style "background-image", (d) ->
      "url("+d.photoUrl+")"
    .append("h2")
      .text (d) ->
        d.title

    # photoCaption
    photoCaption = targetContainer.selectAll('.photoCaption')
    .attr('class', 'photoCaption photo')
    .style "background-image", (d) -> "url("+d.photoUrl+")"

    photoCaption.append("h2")
    .text (d) ->
      d.title

    photoCaption.append("aside")
    .attr("class", "caption")
    .html (d) ->
      d.caption

    #photoMulti
    photoMulti = targetContainer.selectAll('.photoMulti')
    .attr('data-layout', '12312')

    photoMulti.selectAll('img')
    .data(photoMulti[0][0].__data__.photoUrlArray)
    .enter()
    .append('img')
    .attr('src', (d) ->
      d
    )

    ## Video Sections ##

    #videoYoutube
    videoYoutube = targetContainer.selectAll(".videoYoutube")
    .append("div")
    .attr("class", "video-container")
      .html (d) -> d.embedCode

    #videoVimeo
    videoVimeo = targetContainer.selectAll(".videoVimeo")
    .append("div")
    .attr("class", "video-container")
      .html (d) -> d.embedCode

    ## Sound Section ##

    #soundSoundcloud
    soundSoundcloud = targetContainer.selectAll(".soundSoundcloud")
    .html (d) -> d.embedCode

    ## Code Sections ##

    #codeGist
    codeGist = targetContainer.selectAll(".codeGist")
    .html (d) ->
      gistHtml = ""
      id = d.url.split('/')[4]
      $.get "https://api.github.com/gists/"+id, (d) ->
        _.each(d.files, (d) ->
            gistHtml += "<h3>"+d.filename+"</h3>"
            gistHtml += "<div class='content'>"+d.content+"</div>"
        )

      return gistHtml

    #codeTributary
    codeTributary = targetContainer.selectAll(".codeTributary")
    .append("iframe")
    .attr("src", (d) -> d.url )

    ## Text ##
    text = targetContainer.selectAll(".text")
    .html((d) -> d.html)

    ## Timeline Sections ##

    #timelineVerite
    timelineVerite = targetContainer.selectAll(".timelineVerite")
    .append("div")
    .attr("class", "timeline-container")
      .html (d) -> d.embedCode

    timelineStorify = targetContainer.selectAll('.timelineStorify')
    .append("div")
    .attr("class", "timeline-container")
      .html (d) -> d.embedCode

    ## Location Sections ##

    #locationSinglePlace
    locationSinglePlace = targetContainer.selectAll(".locationSinglePlace")
    .append("div")
    .attr("class", "map")
    .attr "data-address", (d) ->
      d.address
    .attr "data-caption", (d) ->
      d.caption
    .attr "data-zoom", (d) ->
      d.zoom
    .style "height", @windowHeight

    #locationTimeline
    locationTimeline =  targetContainer.selectAll('locationTimeline')
    .append("div")
    .attr("class", "map multi-location")  

    that = this
    $(window).on('resize', -> that.handleWindowResize() )

    @renderMaps()
    @renderPhotosets()
    @makeNavSectionList()
    @handleWindowResize()



    @windowHeight = $(window).height()
    $('.photo').css('height', @windowHeight)
    return @story_list

  makeNavSectionList: ->
    # Make the navigation which appears at the top of the page
    $navlist = $("#navigation")
    $navlist.html("")

    _.each @story_list, (section, i) ->
      listClass = ""
      content = i+1
      if section.title isnt undefined
        content = section.title
        listClass = 'titled'

      $link = $("<a></a>").attr("href", "#section"+(i+1)).html(content)
      $listItem = $("<li class='"+listClass+"' id='"+i+"'></li>")
      .attr('data-background-image', -> 
        section.photoUrl
      )
      .css('background-image', ->
        if section.photoUrl isnt undefined
          "url("+section.photoUrl+")"
      )    
      .append($('<div class="outerContainer"> </div>'))
      .append($('<div class="innerContainer"> </div>'))
      .append($('<div class="element"> </div>'))
      .html($link)

      $navlist.append($listItem)

    # Make the nav list titles fit their containers
    $navlist.find('li:not(.titled)').fitText(0.1)


    # Manipulate the header to show different sides
    $header = $('#header-content')

    $('#header-front').click ->
      $header.removeClass('show-front')
      $header.addClass('show-bottom')

    # Animate window scroll position to element
    # when it's navigation item has been clicked
    $('#navigation').click (event) ->
      $evtTgt = $(event.target)
      if $evtTgt.prop('tagName') is 'A'
        targetID = $evtTgt.prop('hash')
        $target = $(targetID)

        $('html,body').animate(
          {
            scrollTop: $target.offset().top
          }, 
          1000
        )
        event.preventDefault()

      else
        $header.removeClass('show-bottom')
        $header.addClass('show-front')

    $(window).on 'scroll', ->
      $sections = $('section')
      handleScroll($sections)

  handleWindowResize: ->
    @verticalCenterPhotoTitles()

    that = this
    $('#navigation li.titled a').each( (i, el) ->
      that.verticalCenterElement( $(el), $(el).parent() )
    )

    windowHeight = $(window).height()
    $(".photoBigText .photo-background").css({
        minHeight: windowHeight
    })
    $(".photoCaption .photo-background").css({
        minHeight: windowHeight
    })      
      
  handleScroll = (sections) ->
    $header = $('#header-content')

    scrollTop = $(window).scrollTop()
    bodyHeight = $('body').height()
    
    if scrollTop > 500
      position = ( (scrollTop + $(window).height()) / bodyHeight ) * 100
    else
      position = ( scrollTop / bodyHeight ) * 100

    if position > 100
      position = 100

    $('#progress').css('width', position+'%')
    

    # Adjust size of header depending on whether
    # we are at the top of the page or not
    if scrollTop >= 110 
      $header.addClass('small')
      $header.css('margin-top', '1em')
    else
      $header.removeClass('small')
      $header.css('margin-top', 0)

  verticalCenterElement: (el, parEl)->
    # Vertical center an element within another
    # used for vertically centering titles
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

  renderPhotosets: ->
    multiPhotoPadding = $('.photoMulti').first().css('padding')
    $('.photoMulti').photosetGrid({
      gutter: multiPhotoPadding+'px'
    });

  renderMaps: ->
    # Render all the leaflet map sections in the story
    that = this
    $(".map").each(->
      mapId = _.uniqueId("map_")
      $(this).attr("id", mapId)

      # Grab the map information that's been added by D3
      # to the data-* properties | address, caption, zoom

      address = $(this).attr("data-address")
      caption = $(this).attr("data-caption")
      zoom = $(this).attr("data-zoom")

      if zoom is undefined or zoom is ""
        zoom = 14

      latLon = []

      # Geocode the address and map it
      geoCode = that.geocodeLocationRequest(address)
      geoCode.done( (result) ->
        #console.log("geoCode result", result)
        result = result[0]
        latLon = [result.lat, result.lon]

        map = L.map(mapId, {
            scrollWheelZoom: false
        }).setView(latLon, zoom)

        layer = new L.StamenTileLayer("toner-lite");
        map.addLayer(layer);

        # Create the circle that marks the point on the map
        circle = L.circle(latLon, 120, {
            color: 'red'
            fillColor: 'red'
            fillOpacity: 0.8
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
    # Make a request to geocode a location
    # returns the jQuery AJAX call to avoid callback craziness
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


