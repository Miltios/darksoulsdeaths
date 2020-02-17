package com.darksoulsdeaths;

import java.util.List;
import java.util.Map;

public class Utilities
{
    private static boolean debug = true; //TODO:move this to a config file or something and provide different levels

    private Utilities(){}

    public static void log(String s)
    {
        if(debug)
        {
            System.out.println(s);
        }
    }

    public static void removeTrailingChar(StringBuilder sb, char c)
    {
        if(sb.charAt(sb.length()-1) == c)
        {
            sb.deleteCharAt(sb.length()-1);
        }
    }

    public static String mapToJson(Map<String,?> map)
    {
        if(map == null)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("{\n");
        for(String key : map.keySet())
        {
            sb.append("\"").append(key).append("\":\"").append(map.get(key)).append("\",");
        }
        removeTrailingChar(sb, ',');
        sb.append("\n}");
        return sb.toString();
    }
    public static String listMapToJson(List<Map<String,?>> list)
    {
        StringBuilder sb = new StringBuilder();
        sb.append("{\n");
        for(Map<String,?> map : list)
        {
            sb.append(mapToJson(map));
        }
        sb.append("\n}");
        return sb.toString();
    }
}
