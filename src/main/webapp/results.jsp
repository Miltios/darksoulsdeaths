<%@ page import="java.util.Map" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <noscript>
        <p>Sorry, we can't analyze your stats without scripting enabled.</p>
    </noscript>
    <title>Dark Souls death counter - Results</title>
    <link rel="stylesheet" type="text/css" href="../styles/styles.css" />
    <style type="text/css">
        html
        {
            background-image:url(../images/BG_torchbastards_fade.jpg);
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
                    <li><a href="../index">Home</a></li>
                    <li><a href="../stats">Stats</a></li>
                    <li><a href="../about">About</a></li>
                    <li><a href="../FAQ">FAQ</a></li>
                </ul>
            </div>
            <div class="content">
                <p>Here are your results!  Click the link next to one of your characters to refine your stats.</p>
                <table id="table-results">
                <%
                String buttonText = "Stats for this character"; //TODO: change to "Update this character" if returning user
                Map<String,Integer> data = (Map)request.getAttribute("fileData");
                int i=0;
                for(String name : data.keySet())
                {
                    int deaths = data.get(name);
                    //TODO:HTML encode character names when displaying?
                %>
                    <tr id="char<%=i%>" class="tr-char" style="display:block">
                        <td>Character: <span id="span-char<%=i%>"><%=name%></span></td>
                        <td>Total deaths: <span id="span-deaths<%=i%>"><%=deaths%></span></td>
                        <td><form id="saveFile" method="POST" action="request/submit" target="_blank">
                            <input type="hidden" name="name" value="<%=name%>" />
                            <input type="hidden" name="deaths" value="<%=deaths%>" />
                            <input type="submit" id="submit" value="<%=buttonText%>" />
                        </form></td>
                    </tr>
                <%
                    i++;
                }
                %>
                </table>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    //TODO:analytics
</script>
</html>