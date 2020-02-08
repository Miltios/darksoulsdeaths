package com.darksoulsdeaths;

public class Utilities
{
    private static boolean debug = false; //TODO:move this to a config file or something and provide different levels

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
}
