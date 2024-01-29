import * as d3 from "d3";

let WellOverviewHook = {
  mounted() {
    var perforations
    
    var margin = {top: 50, right: 50, bottom: 50, left: 75};
    var width = 450;
    var height = 750;

    var svg = d3.select("#well-overview-chart")
      .append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
      .append("g")
          .attr("transform", 
              "translate(" + margin.left + ", " + margin.top + ")");

    var xScale = d3.scaleLinear(); 
    var xAxis = svg.append("g");
    var yScale = d3.scaleLinear();
    var yAxis = svg.append("g");
    var scatter;
    var zoomRect;

    var minZoom = 0.5;
    var maxZoom = 20;
    var zoom = d3.zoom()
      .scaleExtent([minZoom, maxZoom])
      // .translateExtent([[0, 0], [width, height]])
      .on("zoom", updateChart);

    // redirect when clicking on perforation
    function openPerforationOverview(perforation) {
      window.open(
        window.location.protocol +
          "//" +
          window.location.host +
          "/perforation/" +
          perforation.id +
          "/overview"
      );
    }

    function updateChart(e) {
      var newX = e.transform.rescaleX(xScale);
      var newY = e.transform.rescaleY(yScale);

      // update the axes with the new boundaries 
      xAxis.call(d3.axisBottom(newX));
      yAxis.call(d3.axisLeft(newY));

      // update the circle positions 
      scatter.selectAll("circle")
          .attr("cx", function(d) {return newX(d.phase)})
          .attr("cy", function(d) {return newY(d.depth)})
      }

    this.handleEvent("reset-zoom", () => {
      console.log("SUP")
      zoomRect.transition().duration(250).call(zoom.transform, d3.zoomIdentity);
    })

    this.pushEvent("fetch-plotting-data", {}, (reply, ref) => {
      perforations = reply.perforations
      var depthBuffer = 15;
      var minDepth = reply.min_depth - depthBuffer;
      var maxDepth = reply.max_depth + depthBuffer;

      // set an invisible rectangle on top of the chart area
      // this will be used to capture the zoom events
      zoomRect = svg.append("rect")
          .attr("width", width)
          .attr("height", height)
          .style("fill", "none")
          .style("pointer-events", "all")
          // .attr("transform", "translate(" + margin.left + ", " + margin.top + ")")
          .call(zoom);
      
      // add title 
      svg.append("text")
        .attr("x",  width / 2 )
        .attr("y", -10)
        .attr("text-anchor", "middle")
        .style("font-family", "Helvetica")
        .style("font-size", 20)
        .text("Well Overview");

      // set X axis properties
      svg.append("text")
        .attr("x", width / 2 )
        .attr("y", height + 40)
        .attr("text-anchor", "middle")
        .style("font-family", "Helvetica")
        .style("font-size", 12)
        .text("Phase (° Clockwise from High Side)");

      xScale.domain([0, 360]).range([0, width]);

      xAxis.attr("transform", "translate(0," + height + ")")
        .call(
          d3.axisBottom(xScale).
          tickValues([0, 60, 120, 180, 240, 300, 360])
        );

      // set Y axis properties
      svg.append("text")
        .attr("text-anchor", "middle")
        .attr("transform", "rotate(-90)")
        .attr("x", -height/2)
        .attr("y", -50)
        .style("font-family", "Helvetica")
        .style("font-size", 12)
        .text("Depth (m)");

      yScale.domain([maxDepth, minDepth]).range([height, 0]);
      yAxis.call(d3.axisLeft(yScale))

      // add a clipPath -> everything outside this area won't be drawn 
      svg.append("defs").append("SVG:clipPath")
        .attr("id", "clip")
        .append("SVG:rect")
        .attr("width", width + 10)
        .attr("height", height)
        .attr("x", -5)
        .attr("y", 0);

      // create the scatter variable: where both the circles and the brush take place
      scatter = svg.append("g");scatter.attr("clip-path", "url(#clip)");

      // tooltip container
      var tooltip = d3
        .select("#well-overview-chart-wrapper")
        .append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

      // plot the perforations
      scatter.selectAll("circle")
        .data(perforations)
        .enter()
        .append("circle")
          .attr("cx", function (d) { return xScale(d.phase) })
          .attr("cy", function (d) { return yScale(d.depth) })
          .attr("r", function (d) { return 8 * d.exit_diameter })
          .style("fill", "#CC0000")
        .on("mouseover", function (event, d) {
          console.log("TOOLTIP")
          tooltip.transition().style("opacity", 1);
          tooltip
            .html(
              "Perforation: " + d.name + "</br>" +
              "Depth: " + d.depth + "m" + "</br>" +
              "Phase: " + d.phase + "°" + "</br>"
            )
            .style("left", event.pageX + 20 + "px")
            .style("top", event.pageY + "px");
        })
        .on("mouseout", function (event, d) {
          tooltip.style("opacity", 0);
        })
        .on("click", function (event, d) {
          openPerforationOverview(d);
        })
        .on("auxclick", function (event, d) {
          openPerforationOverview(d);
        });
    });
  },
};

export { WellOverviewHook };
