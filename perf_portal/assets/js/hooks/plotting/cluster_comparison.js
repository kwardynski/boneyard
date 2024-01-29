import * as d3 from "d3";

let ClusterComparison = {
  mounted() {
    console.log("select mounted");

    var svg = d3
      .select("#cluster-comparison-chart")
      .append("svg")
      .attr("width", 650)
      .attr("height", 600);

    var xMargin = 150;
    var yMargin = 75;
    var width = svg.attr("width") - xMargin;
    var height = svg.attr("height") - yMargin;

    this.handleEvent("at-least-one-nil", (payload) => {
      alert("Please select two clusters");
    });

    this.handleEvent("same-cluster-selected", (payload) => {
      alert("Please select different clusters");
    });

    this.handleEvent("plot-perforations", (reply) => {
      svg.selectAll("*").remove();

      console.log(reply);

      var minScaleDepth = 0;
      var maxScaleDepth = reply.max_depth;

      var xScale = d3.scaleLinear().domain([0, 360]).range([0, width]);
      var xAxis = d3
        .axisBottom()
        .scale(xScale)
        .tickValues([0, 60, 120, 180, 240, 300, 360]);

      var yScale = d3
        .scaleLinear()
        .domain([maxScaleDepth, minScaleDepth])
        .range([height, 0]);

      var g = svg
        .append("g")
        .attr(
          "transform",
          "translate(" + xMargin / 2 + "," + yMargin / 2 + ")"
        );

      // Title
      svg
        .append("text")
        .attr("x", (width + xMargin) / 2)
        .attr("y", 15)
        .attr("text-anchor", "middle")
        .style("font-family", "Helvetica")
        .style("font-size", 20)
        .text("Cluster Comparison");

      // X label
      svg
        .append("text")
        .attr("x", (width + xMargin) / 2)
        .attr("y", height + 70)
        .attr("text-anchor", "middle")
        .style("font-family", "Helvetica")
        .style("font-size", 12)
        .text("Phase (° Clockwise from High Side)");

      // Y label
      svg
        .append("text")
        .attr("text-anchor", "middle")
        .attr("transform", "translate(40," + 300 + ")rotate(-90)")
        .style("font-family", "Helvetica")
        .style("font-size", 12)
        .text("Depth (m)");

      // Transform
      g.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

      g.append("g").call(d3.axisLeft(yScale));

      // Plot Perforations
      svg
        .append("g")
        .selectAll("dot")
        .data(reply.perforations)
        .enter()
        .append("circle")
        .attr("cx", function (d) {
          return xScale(d.phase);
        })
        .attr("cy", function (d) {
          return yScale(d.depth);
        })
        .attr("r", function (d) {
          return 12 * d.exit_diameter;
        })
        .attr("opacity", 0.65)
        .attr("stroke", "black")
        .attr("transform", "translate(" + xMargin / 2 + "," + yMargin / 2 + ")")
        .style("fill", function (d) {
          return d.color;
        });

      // Add Legend
      svg
        .append("g")
        .selectAll("legendDots")
        .data(reply.legend_values)
        .enter()
        .append("circle")
        .attr("cx", function (d) {
          return xScale(d.phase);
        })
        .attr("cy", function (d) {
          return yScale(d.depth);
        })
        .attr("r", function (d) {
          return 5;
        })
        .attr("opacity", 0.65)
        .attr("stroke", "black")
        .attr("transform", "translate(" + xMargin / 2 + "," + yMargin / 2 + ")")
        .style("fill", function (d) {
          return d.color;
        });

      svg
        .append("g")
        .selectAll("legendLabels")
        .data(reply.legend_values)
        .enter()
        .append("text")
        .attr("x", function (d) {
          return xScale(d.phase) + 10;
        })
        .attr("y", function (d) {
          return yScale(d.depth);
        })
        .text(function (d) {
          return d.text;
        })
        .attr("text-anchor", "left")
        .style("alignment-baseline", "middle")
        .attr(
          "transform",
          "translate(" + xMargin / 2 + "," + yMargin / 2 + ")"
        );
    });
  },
};

export { ClusterComparison };
