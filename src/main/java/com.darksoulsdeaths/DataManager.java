package com.darksoulsdeaths;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//TODO: redirect system.out.println to someplace useful

class DataManager
{
    private static String schemaString = ConnectionManager.getSchemaString();

    private DataManager(){}
    static
    {
        //
    }
    static Map<String,Integer> getDeathAndADPPAverages()
    {
        Map<String,Integer> result = new HashMap<>();

        Connection c = ConnectionManager.getConnection();
        try
        {
            String sql = "SELECT * FROM " + schemaString + "deathandadppaverages";
            PreparedStatement statement = c.prepareStatement(sql);
            if(statement.execute())
            {
                ResultSet rs = statement.getResultSet();
                if(rs.last())
                {
                    int rowCount = rs.getRow();
                    if(rowCount == 0)
                    {
                        System.out.println("Found no rows for getDeathAndADPPAverages!");
                        result.put("deaths", 0);
                        result.put("adpp", 0);
                        return result;
                    }
                    else if(rowCount > 1)
                    {
                        System.out.println("Found multiple rows for getDeathAndADPPAverages!  Returning only the first row...");
                    }
                    rs.beforeFirst();
                }
                if(rs.next())
                {
                    result.put("deaths", rs.getInt("round(avg(deaths))"));
                    result.put("adpp", rs.getInt("round(avg(adpp))"));
                }
            }
        }
        catch(SQLException e)
        {
            System.out.println("Failed to get death and ADPP averages!");
            e.printStackTrace();
        }
        return result;
    }
    static List<Map<String,Integer>> getADPPCounts()
    {
        String sql = "SELECT rangeIndex, count FROM " + schemaString + "adppcounts " +
                "ORDER BY rangeIndex ASC";
        return getListMapInteger(sql, "Failed to get death and ADPP averages!");
    }
    static List<Map<String,Integer>> getDeathCounts()
    {
        String sql = "SELECT rangeIndex, count FROM " + schemaString + "deathcounts " +
                "ORDER BY rangeIndex ASC";
        return getListMapInteger(sql, "Failed to get death counts!");
    }
    static List<Map<String,String>> getOptionalCounts()
    {
        return getListMapString("SELECT optionalareasname, percentage FROM " + schemaString + "optionalcounts", "Failed to get optional area counts!");
    }
    static List<Map<String,Integer>> getPlaythroughCounts()
    {
        return getListMapInteger("SELECT * FROM " + schemaString + "playthroughcounts", "Failed to get optional area counts!");
    }
    static List<Map<String,Integer>> getProgressCounts()
    {
        return getListMapInteger("SELECT progress, percentage FROM " + schemaString + "progresscounts", "Failed to get progress counts!");
    }
    static List<Map<String,String>> getSmornsteinCounts()
    {
        return getListMapString("SELECT smornsteinname, count FROM " + schemaString + "smornsteincounts", "Failed to get smornstein counts!");
    }
    private static List<Map<String,String>> getListMapString(String sql, String error)
    {
        List<Map<String,String>> result = new ArrayList<>();

        Connection c = ConnectionManager.getConnection();
        try
        {
            PreparedStatement statement = c.prepareStatement(sql);
            if(statement.execute())
            {
                ResultSet rs = statement.getResultSet();
                ResultSetMetaData meta = rs.getMetaData();
                while(rs.next())
                {
                    Map<String,String> row = new HashMap<>();
                    //we're not doing this dynamically with variable column counts/types because our data structure only supports one thing anyway
                    String keyColName = meta.getColumnName(1);
                    String valColName = meta.getColumnName(2);
                    row.put(keyColName, rs.getString(keyColName));
                    row.put(valColName, rs.getString(valColName));
                    result.add(row);
                }
            }
        }
        catch(SQLException e)
        {
            System.out.println(error);
            e.printStackTrace();
        }
        return result;
    }
    private static List<Map<String,Integer>> getListMapInteger(String sql, String error)
    {
        List<Map<String,Integer>> result = new ArrayList<>();

        Connection c = ConnectionManager.getConnection();
        try
        {
            PreparedStatement statement = c.prepareStatement(sql);
            if(statement.execute())
            {
                ResultSet rs = statement.getResultSet();
                ResultSetMetaData meta = rs.getMetaData();
                while(rs.next())
                {
                    Map<String,Integer> row = new HashMap<>();
                    //we're not doing this dynamically with variable column counts/types because our data structure only supports one thing anyway
                    String keyColName = meta.getColumnName(1);
                    String valColName = meta.getColumnName(2);
                    row.put(keyColName, rs.getInt(keyColName));
                    row.put(valColName, rs.getInt(valColName));
                    result.add(row);
                }
            }
        }
        catch(SQLException e)
        {
            System.out.println(error);
            e.printStackTrace();
        }
        return result;
    }
    public static boolean submitCharacter(Map<String,String> data)
    {
        Connection c = ConnectionManager.getConnection();
        try
        {
            String playerid = data.get("playerid");
            String name = data.get("name");
            int deaths = Integer.parseInt(data.get("deaths"));
            int playthrough = Integer.parseInt(data.get("playthrough"));
            double progress = Double.parseDouble(data.get("progress"));
            boolean shitholes = Boolean.parseBoolean(data.get("shitholes"));
            boolean dragonbros = Boolean.parseBoolean(data.get("dragonbros"));
            boolean asylum = Boolean.parseBoolean(data.get("asylum"));
            boolean painted = Boolean.parseBoolean(data.get("painted"));
            boolean manus = Boolean.parseBoolean(data.get("manus"));
            int smornstein = Integer.parseInt(data.get("smornstein"));
            int adpp;
            if(progress == 0) //treat as progress = .02 but don't want to mess up charts by explicitly setting progress as such
            {
                adpp = deaths * 50;
            }
            else
            {
                adpp = (int) Math.round(deaths/(playthrough+progress));
            }

            //we might consider "ON DUPLICATE KEY UPDATE" instead, but every field is getting replaced anyway
            String sql = "REPLACE INTO characters (playerid, charactername, deaths, playthrough, progress, shitholes, " +
                    "dragonbros, asylum, paintedworld, manus, smornstein, adpp) " +
                    "VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement statement = c.prepareStatement(sql);
            statement.setString(1, playerid);
            statement.setString(2, name);
            statement.setInt(3, deaths);
            statement.setInt(4, playthrough);
            statement.setDouble(5, progress);
            statement.setBoolean(6, shitholes);
            statement.setBoolean(7, dragonbros);
            statement.setBoolean(8, asylum);
            statement.setBoolean(9, painted);
            statement.setBoolean(10, manus);
            statement.setInt(11, smornstein);
            statement.setInt(12, adpp);
            statement.executeUpdate();

            return true;
        }
        catch(SQLException e)
        {
            e.printStackTrace();
            return false;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
}
