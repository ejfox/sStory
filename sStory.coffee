makeTimeline = (d,i) ->
	timelineoptions = {
		type:       'timeline'
		width:      '100%'
		height:     '620'
		source:     d.url
		embed_id:   'timeline'+i
	}
	$(document).ready(->
	    createStoryJS(timelineoptions)
	)	

sStory = (sections) ->    
    container = d3.select("#container")

    container.selectAll('.section')
    .data(sections)
    .enter().append("div")
        .attr("class", (d,i) ->
	 			return "section "+d.type+" "+d.type+i
				)
        .html((d,i) ->
            switch d.type
                when "image"
                    console.log "image"
                    html = ich.image(d, true)
                when "image2"
                    console.log "image2"
                    html = ich.image2(d, true)
                when "image3"
                    console.log "image3"
                    html = ich.image3(d, true)
                when "vimeo"
                    console.log "vimeo"				
                    html = ich.vimeo(d, true)										
                when "soundcloud"
                    console.log "soundcloud"
                    html = ich.soundcloud(d, true)                    
                when "map"
                    console.log "map"
                when "timeline"
                    html = "<h2>"+d.title+"</h2> "
                    html += "<div id='timeline"+i+"'></div>"
                    makeTimeline(d,i)
                    console.log "timeline"
              
            return html
        )
				.style("background-image", (d,i) ->
				    if d.type is "image" or d.type is "image2" or d.type is "image3"
					    return "url('"+d.url+"')"
				)