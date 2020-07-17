//TODO: dummy values
//TODO: let vs var
var character = 'TempCharacterName';
var deaths = 999;
var ADPP = 888;
var averageDeaths = 777;
var averageADPP = 666;
var playthrough = 555;
var progress = 0.8;
var fsize = '16'; // Larger font size if the player-specific titles don't show up.
var fname = 'Marcellus SC'; // Fancier font, same deal.
var fcolor = '#EEEEEE';
var chonk = 540;
var tall = 221;
var noMargin = {width:'490', height:'171'}; /*set chart width/height to (chonk - Y axis size) and (tall - X axis size) to remove margin/padding*/
var accentColor = '#e4e4e4';
var statsBackground = '#5c5c5c';
var baseColor = '#9a9a9a';
var titleADPP = 'Average Deaths per Playthrough for All Players: ';

//TODO:specify default chart dimensions, colors, etc.

//TODO:switches for certain elements to toggle or reformat based on player data. Will need to be tweaked for new page format/IDs once uncommented.
titleADPP = titleADPP + averageADPP;
titleDeaths = "Average Total Deaths for All Players: " + averageDeaths;
/*if(character !== "") // Show how the submitted character compares with global stats.
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
document.getElementById('span-progress').innerHTML = progress * 100 + '%';*/

//loadChartData(); //invoked by google callback once charts API is loaded
                    //TODO:should we have a gate function to make sure google and charts.js are both loaded before calling loadChartData?

function loadChartData()
{
    //TODO: gate function for all charts, or just callback each one individually?
    fetch('/request/getadppcounts')
        .then(response => response.json())
        .then(data => drawChartADPP(formatNumericData(data), document.getElementById('chartADPP')));

    fetch('/request/getdeathcounts')
        .then(response => response.json())
        .then(data => drawChartDeaths(formatNumericData(data), document.getElementById('chartDeaths')));

    fetch('/request/getplaythroughcounts')
        .then(response => response.json())
        .then(data => drawChartPlaythrough(formatNumericData(data), document.getElementById('chartPlaythrough')));

    fetch('/request/getprogresscounts')
        .then(response => response.json())
        .then(data => drawChartProgress(formatProgressData(data), document.getElementById('chartProgress')));

    fetch('/request/getoptionalcounts')
        .then(response => response.json())
        .then(data => drawChartOptional(formatOptionalData(data), document.getElementById('chartOptional')));

    fetch('/request/getsmornsteincounts')
        .then(response => response.json())
        .then(data => drawChartSmornstein(formatSmornsteinData(data), document.getElementById('chartSmornstein')));


    function formatNumericData(json)
    {
        let formatted = [];
        for(let i=0; i<json.length; i++)
        {
            let row = json[i];
            let values = [];
            for(let prop in row)
            {
                if(row.hasOwnProperty(prop))
                {
                    values.push(parseInt(row[prop]));
                }
            }
            formatted.push(values);
        }

        return formatted;
    }

    //TODO: we could probably merge these three functions if the JSON returned properties in the right order
    function formatProgressData(json)
    {
        let formatted = [];
        for(let i=0; i<json.length; i++)
        {
            formatted.push([parseInt(json[i].progress), parseInt(json[i].percentage)]);
        }

        return formatted;
    }
    function formatOptionalData(json)
    {
        let formatted = [];
        for(let i=0; i<json.length; i++)
        {
            formatted.push([json[i].optionalareasname, parseInt(json[i].percentage)]);
        }

        return formatted;
    }
    function formatSmornsteinData(json)
    {
        let formatted = [];
        for(let i=0; i<json.length; i++)
        {
            formatted.push([json[i].smornsteinname, parseInt(json[i].count)]);
        }

        return formatted;
    }
}

//TODO: vestigial?
/*function onChartDataLoaded(res)
{
    drawChartADPP(dataADPP, elADPP);
    drawChartDeaths(dataDeaths, elDeaths);
    drawChartPlaythrough(dataPlaythrough, elPlaythrough);
    drawChartProgress(dataProgress, elProgress);
    drawChartOptional(dataOptional, elOptional);
    drawChartSmornstein(dataSmornstein, elSmornstein);
}*/



function drawChartADPP(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'Deaths');
    data.addColumn('number', 'Players');
    data.addRows(chartData);

    var options = {
        title: titleADPP,
        titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            title: 'Deaths',
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{max:1000},
            ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]
        },
        vAxis: {
            title: 'Players',
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        curveType: 'function',
        //enableInteractivity:'false',
        legend: {position: 'none'},
            backgroundColor: 'none',
        colors: [accentColor]
    };

    // Create and draw the visualization.
    new google.visualization.LineChart(parentEl).draw(data, options);
}

function drawChartDeaths(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'Deaths');
    data.addColumn('number', 'Players');
    data.addRows(chartData);

    var options = {
        title: titleDeaths,
        titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            title: 'Deaths',
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]},
        vAxis: {
            title: 'Players',
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        curveType:'function',
        //enableInteractivity:'false',
        legend: {position: 'none'},
            backgroundColor: 'none',
        colors: [accentColor]
    };

    // Create and draw the visualization.
    new google.visualization.LineChart(parentEl).draw(data, options);
}

function drawChartPlaythrough(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'Playthrough');
    data.addColumn('number', 'Survivors');
    data.addRows(chartData);

    var options = {
        title:"Global Completion Rate:",
        titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
        curveType: "function",
        width:chonk, height:tall,
        chartArea:noMargin,
        vAxis: {
            title:"% of players completed",
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        hAxis: {
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [{v:0, f:'NG'},{v:1, f:'NG+'},{v:2, f:'NG+2'},{v:3, f:'NG+3'},{v:4, f:'NG+4'},{v:5, f:'NG+5'},{v:6, f:'NG+6'},{v:7, f:'NG+7'}],
            textStyle: {color: accentColor}
        },
        legend: {position: 'none'},
        //enableInteractivity:'false',
        backgroundColor: 'none',
        colors: [accentColor]
    }

    // Create and draw the visualization.
    new google.visualization.LineChart(parentEl).draw(data, options);
}

function drawChartProgress(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'Playthrough');
    data.addColumn('number', 'Survivors');
    data.addRows(chartData);

    var options = {
        title:"Global Completion Rate (within current playthrough):",
        titleTextStyle: {color: fcolor, fontSize: fsize, fontName: fname},
        curveType: "none",
        width:chonk, height:tall,
        chartArea:noMargin,
        vAxis: {
            title:"% of players completed",
            titleTextStyle: {color: accentColor},
            textStyle: {color: accentColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        hAxis: {
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [{v:0, f:' '},{v:1, f:'Asylum Demon'},{v:2, f:'1st Bell'},{v:3, f:'2nd Bell'},{v:4, f:"Sen\'s Fortress"},{v:5, f:'Anor Londo'},{v:6, f:'1/4 Lord Souls'},{v:7, f:'2/4 Lord Souls'}, {v:8, f:'3/4 Lord Souls'}, {v:9, f:'4/4 Lord Souls'}],
            textStyle: {color: accentColor},
            slantedText: true,
            slantedTextAngle: 45
        },
        legend: {position: 'none'},
        //enableInteractivity:'false',
        backgroundColor: 'none',
        colors: [accentColor]
    }

    // Create and draw the visualization.
    new google.visualization.LineChart(parentEl).draw(data, options);
}

function drawChartOptional(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Deaths');
    data.addColumn('number', 'Frequency');
    data.addRows(chartData);

    var options = {
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            textStyle: {color: accentColor},
            slantedText: true,
            slantedTextAngle: 45
        },
        vAxis: {
            title: '% of players completed',
            titleTextStyle: {color:accentColor},
            textStyle: {color:accentColor},
            baselineColor: baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        bar: {groupWidth: '90%'},
        //enableInteractivity:'false',
        legend: {position: 'none'},
        backgroundColor: 'none',
        colors: [accentColor]
    };

    // Create and draw the visualization.
    new google.visualization.ColumnChart(parentEl).draw(data, options);
}

function drawChartSmornstein(chartData, parentEl)
{
    // Create and populate the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Deaths');
    data.addColumn('number', 'Frequency');
    data.addRows(chartData);

    var options = {
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            textStyle: {color: accentColor},
            slantedText: true,
            slantedTextAngle: 45
        },
        vAxis: {
            title: 'Votes',
            titleTextStyle: {color:accentColor},
            textStyle: {color:accentColor},
            baselineColor: baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        bar: {groupWidth: '90%'},
        //enableInteractivity:'false',
        legend: {position: 'none'},
        backgroundColor: 'none',
        colors: [accentColor]
    };

    // Create and draw the visualization.
    new google.visualization.ColumnChart(parentEl).draw(data, options);
}