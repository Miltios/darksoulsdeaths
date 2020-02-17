package com.darksoulsdeaths;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

//TODO: redirect system.out.println to someplace useful

public class DataManager
{
    private static String schemaString = ConnectionManager.getSchemaString();

    private DataManager(){}
    static
    {
        //
    }
    public static Map<String,Integer> getDeathAndADPPAverages()
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
}
