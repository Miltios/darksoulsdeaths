<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <noscript>
        <p>Sorry, we can't analyze your stats without scripting enabled.</p>
    </noscript>
    <title>Dark Souls death counter - Results</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css" />
    <style type="text/css">
        html
        {
            background-image:url(images/BG_torchbastards_fade.jpg);
        }
    </style>
</head>
<body>
    <div class="header">
    </div>
    <div class="wrapper">
        <div class="container">
            <div class="navbar">
                <ul>
                    <li><a href="index">Home</a></li>
                    <li><a href="stats">Stats</a></li>
                    <li><a href="about">About</a></li>
                    <li><a href="FAQ">FAQ</a></li>
                </ul>
            </div>
            <div class="content">
                <p>Here are your results!  Click the link next to one of your characters to refine your stats.</p>
                <table id="table-results">
<!--TODO: convert this loop to java
    charList = 	getCharsAndDeaths()

    for x in range(0, len(charList)):
        name = charList[x][0]
        buttonText = "Stats for this character"
        if name in playerIDCharacterList:
            buttonText = "Update this character"
        print("""
            <tr id="char{x}" class="tr-char" style='display: block;'>
                <td>Character: <span id="span-char{x}">{name}</span></td>
                <td>Total deaths: <span id="span-deaths{x}">{deaths}</span></td>
                    <td><form id="saveFile" method="POST" action="submit.py" target="_blank" >
                            <input type="hidden" name="name" value="{name}" />
                            <input type="hidden" name="deaths" value="{deaths}" />
                            <input type="submit" id="submit" value="{buttonText}" />
                        </form>
            </tr>""".format(x=x, name=name, deaths=charList[x][1], buttonText=buttonText))
-->
                </table>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    //TODO:analytics
</script>
</html>