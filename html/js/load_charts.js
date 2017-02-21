google.charts.load('current', {'packages':['corechart', 'table']});
google.charts.setOnLoadCallback(drawChart);
function drawChart() {
  var filename = document.getElementById("test_selector").options.item(document.getElementById("test_selector").options.selectedIndex).value;
  var results = JSON.parse($.ajax({
      url: "results/" + filename + ".json",
      dataType: "json",
      async: false
      }).responseText);
  
      
  // Create our data table out of JSON data loaded from server.
  charts = new Array;
  chart_num = 0;
  document.getElementById("charts").innerHTML = "";
  Object.keys(results).forEach(function (key) {
    document.getElementById("charts").innerHTML += '<div><div id="' + key + '"></div>';
    document.getElementById("charts").innerHTML += '<div id="' + key + '_table" align="center"></div></div>';
    outJson = results[key];
    var data = new google.visualization.DataTable(outJson);
    var options = {
      title: key,
      height: 500,
      tooltip: {isHtml: true},
      hAxis: {
        title: 'Tests'
      },
      vAxis: {
        title: 'Time (s)'
      }
    };
    var formatter = new google.visualization.NumberFormat({pattern: '#.######'});
    formatter.format(data, 1);
    formatter.format(data, 2);
    formatter.format(data, 3);
    charts[chart_num] = new google.visualization.ColumnChart(document.getElementById(key));
    charts_table = new google.visualization.Table(document.getElementById(key + "_table"));
    charts_table.draw(data, {height: 200});
    charts[chart_num].draw(data, options);
    chart_num++;
  });
}
