<%@ page import="com.darksoulsdeaths.*" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Dark Souls death counter - Stats</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
    <style type="text/css">
    </style>
</head>
<%!
    public static String getRowsForChart(ArrayList<int[]> counts) {
        if(counts.size() <= 0)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for(int[] row : counts)
        {
            int option = row[0];
            int count = row[1];
            sb.append("['").append(option).append("', ").append(count).append(")],");
        }
        int idx = sb.length();
        if(sb.charAt(idx) == ',')
        {
            sb.deleteCharAt(idx);
        }
        return sb.toString();
    }
    public static String getRowsForChartNoQuotes(ArrayList<int[]> counts) {
        if(counts.size() <= 0)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for(int[] row : counts)
        {
            int option = row[0];
            int count = row[1];
            sb.append("[").append(option).append(", ").append(count).append(")],");
        }
        int idx = sb.length();
        if(sb.charAt(idx) == ',')
        {
            sb.deleteCharAt(idx);
        }
        return sb.toString();
    }
%>
<%
    //lists of various info to use in charts
    //TODO:why is this forcing outdated compiler level? (< 1.7)
    ArrayList<int[]> countsOfDeaths = new ArrayList<int[]>();
    ArrayList<int[]> countsOfAdpp = new ArrayList<int[]>();
    ArrayList<int[]> countsOfPlaythroughs = new ArrayList<int[]>();
    ArrayList<int[]> countsOfProgress = new ArrayList<int[]>();
    ArrayList<int[]> countsOfSmornstein = new ArrayList<int[]>();
    ArrayList<int[]> countsOfOptionals = new ArrayList<int[]>();

    //default player info
    String name = "";
    int deaths = 0;
    int progress = 0;
    int playthrough = 0;
    int adpp = 0;
    int averageDeaths = 0;
    int averageAdpp = 0;
%>
<body>
    <div class="header">
    </div>
    <div class="wrapper">
    <div class="container">
        <div class="navbar">
        <ul>
            <li><a href="../index.html">Home</a></li>
            <li><a href="stats.py">Stats</a></li>
            <li><a href="../about.html">About</a></li>
            <li><a href="../FAQ.html">FAQ</a></li>
        </ul>
        </div>
        <div class="content">
            <table id="table-char" style="display:none;">
            <tr>
                <td>Character: <span id="span-char" class="span-stat"></span></td>
            </tr>
            </table>
        <h2 class="your-stats" style="display:none;">Your average deaths per playthrough: <span id="span-ADPP" class="span-stat"></span></h2>
        <h2 class="your-stats" style="display:none; margin-bottom:0px;">Global average: <span id="span-averageADPP" class="span-stat"></span></h2>
        <div id="chart-ADPP"></div>
            <h2 class="your-stats" style="display:none;">Your total deaths across all playthroughs: <span id="span-deaths" class="span-stat"></span></h2>
            <h2 class="your-stats" style="display:none; margin-bottom:0px;">Global average: <span id="span-averageDeaths" class="span-stat"></span></h2>
            <div id="chart-deaths"></div>
            <h2 class="your-stats" style="display:none;">Your current playthrough: <span id="span-playthrough" class="span-stat"></span></h2>
            <div id="chart-playthrough"></div>
            <h2 class="your-stats" style="display:none;">Your current progress in this playthrough: <span id="span-progress" class="span-stat"></span> (approximate)</h2>
            <div id="chart-progress"></div>
            <h2 class="all-stats">Percent of players who completed each optional area:</h2>
            <div id="chart-optional"></div>
            <h2 class="all-stats">Top 5 favorite nicknames for Ornstein &amp; Smough:</h2>
            <div id="chart-smornstein"></div>
        </div>
    </div>
    </div>
    </body>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        var character = '<%=name%>';
        var deaths = <%=deaths%>;
        var ADPP = <%=adpp%>;
        var averageDeaths = <%=averageDeaths%>;
        var averageADPP = <%=averageAdpp%>;
        var playthrough = <%=playthrough%>;
        var progress = <%=progress%>;
        var fsize = '25'; // Larger font size if the player-specific titles don't show up.
        var fname = 'Marcellus SC'; // Fancier font, same deal.
        var fcolor = '#EEEEEE';
        var titleADPP = 'Average Deaths per Playthrough for All Players: ';
        var titleDeaths = 'Total Death Counts for All Players: ';

        if(character !== "") // Show how the submitted character compares with global stats.
        							// Users can still browse global stats without submitting a character,
        							// in which case player-specific elements won't display.
        {
          document.getElementById('span-char').innerHTML = character;
          document.getElementById('table-char').style.display = "table";
          yourStats = document.getElementsByClassName("your-stats");
          for (var i = 0; i < yourStats.length; i++)
          {
        	yourStats[i].style.display = "block";
          }
          fname = 'Arial';
          fsize = '15';
          fcolor = '#CCBB00';
        }
        else // Tweak title wording and change the remaining h2 elements to match the google chart headers
        {
          allstats = document.getElementsByClassName('all-stats');
          for(var i=allstats.length; i>0; i--)
          {
        	allstats[i-1].className = 'nochar-stats';
          }
          titleADPP = titleADPP + averageADPP;
          titleDeaths = "Average Total Deaths for All Players: " + averageDeaths;
        }
        document.getElementById('span-ADPP').innerHTML = ADPP;
        document.getElementById('span-deaths').innerHTML = deaths;
        document.getElementById('span-averageDeaths').innerHTML = averageDeaths;
        document.getElementById('span-averageADPP').innerHTML = averageADPP;
        switch(playthrough)
        {
         case 0:
         			document.getElementById('span-playthrough').innerHTML = "New Game";
        			break;
         case 1:
         			document.getElementById('span-playthrough').innerHTML = "New Game +";
        			break;
         case 2:
         			document.getElementById('span-playthrough').innerHTML = "New Game +2";
        			break;
         case 3:
         			document.getElementById('span-playthrough').innerHTML = "New Game +3";
        			break;
         case 4:
         			document.getElementById('span-playthrough').innerHTML = "New Game +4";
        			break;
         case 5:
         			document.getElementById('span-playthrough').innerHTML = "New Game +5";
        			break;
         case 6:
         			document.getElementById('span-playthrough').innerHTML = "New Game +6";
        			break;
         case 7:
         			document.getElementById('span-playthrough').innerHTML = "New Game +7";
        			break;
        }
        if(progress > 1)
        {
         progress = 1;
        }
        document.getElementById('span-progress').innerHTML = progress * 100 + '%';

        // Load the Visualization API and the piechart package.
        google.load('visualization', '1.0', {'packages':['corechart']});

        // Set a callback to run when the Google Visualization API is loaded.
        google.setOnLoadCallback(drawChartADPP);
        google.setOnLoadCallback(drawChartDeaths);
        google.setOnLoadCallback(drawChartPlaythrough);
        google.setOnLoadCallback(drawChartProgress);
        google.setOnLoadCallback(drawChartOptional);
        google.setOnLoadCallback(drawChartSmornstein);

        // Callback that creates and populates a data table,
        // instantiates the pie chart, passes in the data and
        // draws it.
        function drawChartADPP() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('number', 'Deaths');
          data.addColumn('number', 'Players');
          data.addRows([
            <%= getRowsForChartNoQuotes(countsOfAdpp)%>
            ]);

          var options = {
            title: titleADPP,
                titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
            width:1000, height:400,
            hAxis: {title: 'Deaths', titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{max:1000},
                        ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]},
            vAxis: {title: 'Players', titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            curveType: 'function',
            enableInteractivity:'false',
            legend: {position: 'none'},
                backgroundColor: 'none',
                colors: ['#CCBB00']
          };

          // Create and draw the visualization.
          new google.visualization.LineChart(document.getElementById('chart-ADPP')).
              draw(data, options);
        }

        function drawChartDeaths() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('number', 'Deaths');
          data.addColumn('number', 'Players');
          data.addRows([
            <%= getRowsForChartNoQuotes(countsOfDeaths)%>
            ]);

          var options = {
            title: titleDeaths,
                titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
            width:1000, height:400,
            hAxis: {title: 'Deaths', titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'},
                        ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]},
            vAxis: {title: 'Players', titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            curveType:'function',
            enableInteractivity:'false',
            legend: {position: 'none'},
                backgroundColor: 'none',
                colors: ['#CCBB00']
          };

          // Create and draw the visualization.
          new google.visualization.LineChart(document.getElementById('chart-deaths')).
              draw(data, options);
        }

        function drawChartPlaythrough() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('number', 'Playthrough');
          data.addColumn('number', 'Survivors');
          data.addRows([
            <%= getRowsForChartNoQuotes(countsOfPlaythroughs)%>
            ]);

          var options = {
            title:"Global Completion Rate:",
                titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
                curveType: "function",
            width: 1000, height: 400,
            vAxis: {title:"% of players completed", titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            hAxis: {baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, ticks: [{v:0, f:'NG'},{v:1, f:'NG+'},{v:2, f:'NG+2'},{v:3, f:'NG+3'},{v:4, f:'NG+4'},{v:5, f:'NG+5'},{v:6, f:'NG+6'},{v:7, f:'NG+7'}], textStyle: {color: '#CCCCCC'}},
            legend: {position: 'none'},
            enableInteractivity:'false',
            backgroundColor: 'none',
                colors: ['#CCBB00']
                        }

          // Create and draw the visualization.
          new google.visualization.LineChart(document.getElementById('chart-playthrough')).
              draw(data, options);
        }

        function drawChartProgress() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('number', 'Playthrough');
          data.addColumn('number', 'Survivors');
          data.addRows([
            <%= getRowsForChartNoQuotes(countsOfProgress)%>
            ]);

          var options = {
            title:"Global Completion Rate (within current playthrough):",
                titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
                curveType: "none",
            width: 1000, height: 400,
            vAxis: {title:"% of players completed", titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            hAxis: {baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, ticks: [{v:0, f:' '},{v:1, f:'Asylum Demon'},{v:2, f:'1st Bell'},{v:3, f:'2nd Bell'},{v:4, f:"Sen\'s Fortress"},{v:5, f:'Anor Londo'},{v:6, f:'1/4 Lord Souls'},{v:7, f:'2/4 Lord Souls'}, {v:8, f:'3/4 Lord Souls'}, {v:9, f:'4/4 Lord Souls'}], textStyle: {color: '#CCCCCC'}},
            legend: {position: 'none'},
            enableInteractivity:'false',
            backgroundColor: 'none',
                colors: ['#CCBB00']
                        }

          // Create and draw the visualization.
          new google.visualization.LineChart(document.getElementById('chart-progress')).
              draw(data, options);
        }

        function drawChartOptional() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('string', 'Deaths');
          data.addColumn('number', 'Frequency');
          data.addRows([
            <%= getRowsForChart(countsOfOptionals)%>
            ]);

          var options = {
            width:1000, height:400,
            hAxis: {textStyle: {color: '#CCCCCC'}},
            vAxis: {title: '% of players completed', titleTextStyle: {color: '#CCCCCC'},textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            bar: {groupWidth: '90%'},
            enableInteractivity:'false',
            legend: {position: 'none'},
                backgroundColor: 'none',
                colors: ['#CCBB00']
          };

          // Create and draw the visualization.
          new google.visualization.ColumnChart(document.getElementById('chart-optional')).
              draw(data, options);
        }

        function drawChartSmornstein() {
          // Create and populate the data table.
          var data = new google.visualization.DataTable();
          data.addColumn('string', 'Deaths');
          data.addColumn('number', 'Frequency');
          data.addRows([
            <%= getRowsForChart(countsOfSmornstein)%>
            ]);

          var options = {
            width:1000, height:400,
            hAxis: {textStyle: {color: '#CCCCCC'}},
            vAxis: {title: 'Votes', titleTextStyle: {color: '#CCCCCC'}, textStyle: {color: '#CCCCCC'}, baselineColor:'#CCCCCC', gridlines: {color:'#666666'}, viewWindow:{min:0}},
            bar: {groupWidth: '90%'},
            enableInteractivity:'false',
            legend: {position: 'none'},
                backgroundColor: 'none',
                colors: ['#CCBB00']
          };

          // Create and draw the visualization.
          new google.visualization.ColumnChart(document.getElementById('chart-smornstein')).
              draw(data, options);
        }
    </script>
    <script type="text/javascript">
      //TODO:analytics
    </script>
</html>