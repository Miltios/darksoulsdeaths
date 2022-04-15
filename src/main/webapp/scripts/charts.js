//TODO: dummy values
//TODO: let vs var
//TODO: display char name on stats (and possibly submission) page?
let averageDeaths = 'unknown';
let averageADPP = 'unknown';
const fsize = '16'; // Larger font size if the player-specific titles don't show up.
const fname = 'Marcellus SC'; // Fancier font, same deal.
const fcolor = '#EEEEEE';
const chonk = 540;
const tall = 221;
const noMargin = {width:'490', height:'161'}; /*set chart width/height to (chonk - Y axis size) and (tall - X axis size) to remove margin/padding*/
const accentColor = '#ebc38b';
const statsBackground = '#5c5c5c';
const baseColor = '#9a9a9a';
const textColor = '#e4e4e4';

//TODO:specify default chart dimensions, colors, etc.

//TODO:switches for certain elements to toggle or reformat based on player data. Will need to be tweaked for new page format/IDs once uncommented.
let titleADPP = 'Average Deaths per Playthrough for All Players: ';
let titleDeaths = 'Average Total Deaths for All Players: ';


let pendingCharts = [];
let chartsCallback = null;
function initChartGateway ()
{
    pendingCharts = ['adpp','deaths','playthrough', 'progress', 'optional', 'smornstein'];
}
function passChartGateway(chart)
{
    let index = pendingCharts.indexOf(chart);
    if(index === -1)
    {
        console.error('Could not find chart "' + '" in pending list!');
        return;
    }
    pendingCharts.splice(index,1);
    if(pendingCharts.length === 0)
    {
        finishChartGateway();
    }
}
function finishChartGateway()
{
    if(typeof chartsCallback === 'function')
    {
        chartsCallback();
    }
}

//invoked by google callback once charts API is loaded
function loadChartData()
{
    //TODO: should probably have a gate function for all of this rather than ping-ponging it
    initChartGateway();
    fetch('/request/getdeathandadppaverages')
        .then(response => response.json())
        .then(data => {
            averageDeaths = data.deaths;
            averageADPP = data.adpp;
            titleDeaths = "Average Total Deaths for All Players: " + averageDeaths;
            titleADPP = 'Average Deaths per Playthrough for All Players: ' + averageADPP;

            fetch('/request/getadppcounts')
                .then(response => response.json())
                .then(data => {
                    drawChartADPP(formatNumericData(data), document.getElementById('chartADPP'));
                    passChartGateway('adpp');
                });

            fetch('/request/getdeathcounts')
                .then(response => response.json())
                .then(data => {
                    drawChartDeaths(formatNumericData(data), document.getElementById('chartDeaths'));
                    passChartGateway('deaths');
                });

            fetch('/request/getplaythroughcounts')
                .then(response => response.json())
                .then(data => {
                    drawChartPlaythrough(formatNumericData(data), document.getElementById('chartPlaythrough'));
                    passChartGateway('playthrough');
                });

            fetch('/request/getprogresscounts')
                .then(response => response.json())
                .then(data => {
                    drawChartProgress(formatProgressData(data), document.getElementById('chartProgress'));
                    passChartGateway('progress');
                });

            fetch('/request/getoptionalcounts')
                .then(response => response.json())
                .then(data => {
                    //HACK: make the axis labels more compact, because a Google Charts API bug isn't allowing the decluttering options to work
                    for(let i=0; i<data.length; i++)
                    {
                        switch(data[i].optionalareasname)
                        {
                            case 'Lower Undead Burg/Depths':
                                data[i].optionalareasname = 'Depths';
                                break;
                            case 'Great Hollow/Ash Lake':
                                data[i].optionalareasname = 'Ash Lake';
                                break;
                            case 'Undead Asylum (2nd visit)':
                                data[i].optionalareasname = 'Asylum (revisit)';
                                break;
                            case 'Painted World of Ariamis':
                                data[i].optionalareasname = 'Painted World';
                                break;
                            case 'Additional Content (beat Manus)':
                                data[i].optionalareasname = 'Manus';
                                break;
                        }
                    }
                    drawChartOptional(formatOptionalData(data), document.getElementById('chartOptional'));
                    passChartGateway('optional');
                });

            fetch('/request/getsmornsteincounts')
                .then(response => response.json())
                .then(data => {
                    drawChartSmornstein(formatSmornsteinData(data), document.getElementById('chartSmornstein'));
                    passChartGateway('smornstein');
                });
        });

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

function drawChartADPP(chartData, parentEl)
{
    if(typeof charData.deaths === 'number' && typeof charData.playthrough === 'number' && typeof charData.progress === 'number')
    {
        let adpp;
        if(charData.progress === 0 && charData.playthrough === 0) //treat as progress = .02 but don't want to mess up charts by explicitly setting progress as such in the DB
        {
            adpp = charData.deaths * 50;
        }
        else
        {
            adpp = Math.round(charData.deaths/(charData.playthrough+charData.progress));
        }
        titleADPP = '';
        document.getElementById('span-ADPP').innerHTML = adpp;
        document.getElementById('span-averageADPP').innerHTML = averageADPP;
    }

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
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{max:1000},
            ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]
        },
        vAxis: {
            title: 'Players',
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
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
    if(typeof charData.deaths === 'number')
    {
        document.getElementById('span-deaths').innerHTML = charData.deaths;
        document.getElementById('span-averageDeaths').innerHTML = averageDeaths;
        titleDeaths = '';
    }
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
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [0,100,200,300,400,500,600,700,800,900,{v:1000, f:'1000+'}]},
        vAxis: {
            title: 'Players',
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
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
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        hAxis: {
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [{v:0, f:'NG'},{v:1, f:'NG+'},{v:2, f:'NG+2'},{v:3, f:'NG+3'},{v:4, f:'NG+4'},{v:5, f:'NG+5'},{v:6, f:'NG+6'},{v:7, f:'NG+7'}],
            textStyle: {color: textColor}
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
        width:chonk, height:tall+60,
        chartArea:noMargin,
        vAxis: {
            title:"% of players completed",
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            viewWindow:{min:0}
        },
        hAxis: {
            baselineColor:baseColor,
            gridlines: {color:statsBackground},
            ticks: [{v:0, f:' '},{v:1, f:'Asylum Demon'},{v:2, f:'1st Bell'},{v:3, f:'2nd Bell'},{v:4, f:"Sen\'s Fortress"},{v:5, f:'Anor Londo'},{v:6, f:'1/4 Lord Souls'},{v:7, f:'2/4 Lord Souls'}, {v:8, f:'3/4 Lord Souls'}, {v:9, f:'4/4 Lord Souls'}],
            textStyle: {color: textColor},
            slantedText: true
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
    data.addRows(chartData);

    var options = {
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            textStyle: {color: textColor},
            slantedText: false
        },
        vAxis: {
            title: '% of players completed',
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
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
    data.addRows(chartData);

    var options = {
        width:chonk, height:tall,
        chartArea:noMargin,
        hAxis: {
            textStyle: {color: textColor},
            slantedText: false
        },
        vAxis: {
            title: 'Votes',
            titleTextStyle: {color: textColor},
            textStyle: {color: textColor},
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