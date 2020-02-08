package com.darksoulsdeaths;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager
{
    private static Connection conn = null;

    private static final String driverName = StartClass.getProperty("driverName");
    private static final String connectionUrl = StartClass.getProperty("connectionUrl");
    private static final String userName = StartClass.getProperty("userName");
    private static final String userPass = StartClass.getProperty("userPass");

    public ConnectionManager()
    {
        try
        {
            Class.forName(driverName);
            Utilities.log("Registered driver " + driverName + "!");
        }
        catch(ClassNotFoundException e)
        {
            System.out.println(e.toString());
        }
    }

    public static Connection getConnection()
    {
        if(conn == null)
        {
            try
            {
                conn = DriverManager.getConnection(connectionUrl, userName, userPass);
                System.out.println("Created new DB connection."); //TODO:DEBUG
            }
            catch(SQLException e)
            {
                System.out.println("Failed to establish DB connection!");
                e.printStackTrace(System.out); //TODO: replace this hack with proper logging
                System.exit(1);
            }
        }
        return conn;
    }

    public static String getSchemaString()
    {
        String schema = StartClass.getProperty("schemaName");
        if(schema != null)
        {
            return schema + ".";
        }
        return "";
    }

    public static void closeConnection()
    {
        try
        {
            conn.close();
        }
        catch(SQLException e)
        {
            System.out.println("Failed to close DB connection!");
            e.printStackTrace();
        }
    }
}
