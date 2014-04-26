class sStory
  constructor: (@story_list) ->
    # Make sure that sStory is being started
    # with a story_list, and that it is an array
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    if @story_list is undefined
      throw "No story_list defined"

    if !typeIsArray(@story_list)
      throw "The story_list is not an array"

  render: ->
    # Render the sStory
    targetID = "#content"

    targetContainer = d3.select(targetID)

    sections = targetContainer.selectAll("section")
      .data(@story_list)
    .enter().append("section")
      .attr('class', (d) -> d.type)

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

    ## Code Sections ##

    #codeGist
    codeGist = targetContainer.selectAll(".codeGist")
    .html (d) ->
      gistHtml = ""
      id = d.url.split('/')[4]
      $.get "https://api.github.com/gists/"+id, (d) ->
        console.log "JSON", d
        _.each(d.files, (d) ->
            gistHtml += "<h3>"+d.filename+"</h3>"
            gistHtml += "<div class='content'>"+d.content+"</div>"
        )

      return gistHtml

    #codeTributary
    codeTributary = targetContainer.selectAll(".codeTributary")
    .append("iframe")
    .attr("src", (d) -> d.url )


    #timelineVerite
    timelineVerite = targetContainer.selectAll(".timelineVerite")
    .append("div")
    .attr("class", "timeline-container")
      .html (d) -> d.embedCode

    @handleWindowResize()
    that = this
    $(window).on('resize', -> that.handleWindowResize() )

    @renderMaps()
    @makeNavSectionList()
    @renderPhotosets()

    @windowHeight = $(window).height()
    $('.photo').css('height', @windowHeight)
    return @story_list

  makeNavSectionList: ->
    # Make the navigation which appears at the top of the page
    $navlist = $("#navigation")
    $navlist.html("")

    _.each @story_list, (section, i) ->
      #console.log section
      $link = $("<a></a>").attr("href", "#"+i).html(i + 1)
      $listItem = $("<li></li>").html($link)
      $navlist.append($listItem)

    $header = $('#header-content')

    $('#header-front h1').click ->
      $header.removeClass('show-front')
      $header.addClass('show-bottom')


    $('#navigation').click ->
      $header.removeClass('show-bottom')
      $header.addClass('show-front')

    $(window).on 'scroll', ->
      scrollTop = $(window).scrollTop()
      bodyHeight = $('body').height()
      
      if scrollTop > 500
        position = ( (scrollTop + $(window).height()) / bodyHeight ) * 100
      else
        position = ( scrollTop / bodyHeight ) * 100

      if position > $(window).height()
        position = 100

      $('#progress').css('width', position+'%')
      
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

  handleWindowResize: ->
    @verticalCenterPhotoTitles()

    windowHeight = $(window).height()
    $(".photoBigText .photo-background").css({
        minHeight: windowHeight
    })
    $(".photoCaption .photo-background").css({
        minHeight: windowHeight
    })

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
      address = $(this).attr("data-address")
      caption = $(this).attr("data-caption")
      zoom = $(this).attr("data-zoom")

      if zoom is undefined or zoom is ""
        zoom = 14

      latLon = []

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


