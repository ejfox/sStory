sStory = (sections) ->
    console.log "test"
    
    container = d3.select("#container")
    
    container.selectAll('.section')
    .data(sections)
    .enter().append("div")
        .attr("class", "section")
        .text((d,i) -> i)