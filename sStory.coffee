sStory = (sections) ->    
    container = d3.select("#container")
    
    container.selectAll('.section')
    .data(sections)
    .enter().append("div")
        .attr("class", "section")
        .html((d,i) ->
            switch d.type
                when "image"
                    console.log "image"
                    html = ich.image(d, true)
#                    console.log image_html
                when "image2"
                    console.log "image2"
                    html = ich.image2(d, true)
                when "image3"
                    console.log "image3"
                    html = ich.image3(d, true)
                when "vimeo"
                    console.log "vimeo"
                    #html = ich.vimeo(d, true)
                when "soundcloud"
                    console.log "soundcloud"
                    #html = ich.soundcloud(d, true)                    
                when "map"
                    console.log "map"
                when "timeline"
                    console.log "timeline"
                
#            console.log d 
            return html
        )