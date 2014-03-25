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

    ###
    $targetContainer = $("#content")
    $targetContainer.html(JSON.stringify(@story_list))
    ###

    targetContainer = d3.select("#content")

    sections = targetContainer.selectAll("section")
      .data(@story_list)
    .enter().append("section")
      .attr('class', (d) -> d.type)
      .text("boop")

    targetContainer.selectAll('.photoBigText')
    .style "background-image", (d) ->
      "url("+d.photoUrl+")"
    .append("h2")
    .text (d) ->
      d.title



    @handleWindowResize()
    that = this
    $(window).on('resize', -> that.handleWindowResize() )

    @makeNavSectionList()
    return @story_list

  makeNavSectionList: ->
    # Make the navigation which appears at the top of the page
    $navlist = $("#nav-section-list")
    $navlist.html("")

    _.each @story_list, (section, i) ->
      #console.log section
      $link = $("<a></a>").attr("href", "#"+i).html(i + 1)
      $listItem = $("<li></li>").html($link)
      $navlist.append($listItem)


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

  handleWindowResize: ->
    @verticalCenterPhotoTitles()

    windowHeight = $(window).height()
    $(".photoBigText .photo-background").css({
        minHeight: windowHeight
    })
    $(".photoCaption .photo-background").css({
        minHeight: windowHeight
    })

