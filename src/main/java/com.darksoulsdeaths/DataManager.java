package com.darksoulsdeaths;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DataManager
{
    private static String schemaString = ConnectionManager.getSchemaString();

    private DataManager(){}
    static
    {
        //
    }
    public static String getDeathAndADPPAverages()
    {
        StringBuilder result = new StringBuilder();

        Connection c = ConnectionManager.getConnection();
        try
        {
            String sql = "SELECT * FROM " + schemaString + "deathandadppaverages";
            PreparedStatement statement = c.prepareStatement(sql);
            if(statement.execute())
            {
                ResultSet rs = statement.getResultSet();
                while(rs.next()) //TODO: this is not in a useful format
                {
                    result.append("Deaths: ").append(rs.getInt("round(avg(deaths))"));
                    result.append("ADPP: ").append(rs.getInt("round(avg(adpp))"));
                }
            }
        }
        catch(SQLException e)
        {
            //TODO
            System.out.println("Failed to get death and ADPP averages!");
            e.printStackTrace();
        }
        return result.toString();
    }
}
