package com.darksoulsdeaths;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Properties;

public class StartClass implements ServletContextListener //TODO:what do we actually call this?
{
    static Properties properties; //TODO: is this the appropriate place for this info?
    private ConnectionManager cm;

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent)
    {
        //TODO
    }

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent)
    {
        System.out.println("ServletContextListener initializing."); //TODO:DEBUG
        properties = new Properties();
        InputStream input = null;

        try
        {
            input = new FileInputStream("D:/web/darksoulsdeaths/config.properties"); //TODO
            properties.load(input);
            cm = new ConnectionManager();
        }
        catch(IOException e)
        {
            System.out.println("Config.properties file not found.  Checking environment variable...");
            try
            {
                URI jdbUri = new URI(System.getenv("JAWSDB_URL"));
                properties.setProperty("driverName", "com.mysql.cj.jdbc.Driver");
                properties.setProperty("userName", jdbUri.getUserInfo().split(":")[0]);
                properties.setProperty("userPass", jdbUri.getUserInfo().split(":")[1]);
                properties.setProperty("connectionUrl", "jdbc:mysql://" + jdbUri.getHost() + ":" + jdbUri.getPort() + jdbUri.getPath());
            }
            catch(URISyntaxException u)
            {
                System.out.println("ERROR: Unable to parse environment variable JAWSDB_URL");
            }
            catch(Exception x)
            {
                System.out.println("ERROR: Failed to read properties from JAWSDB_URL!");
                System.out.println(x.getMessage());
                x.printStackTrace(); //TODO:DEBUG
            }
            try
            {
                String id = System.getenv("analyticsId");
                properties.setProperty("analyticsId", id);
                System.out.println("Set analytics ID: " + id); //TODO:DEBUG
            }
            catch(Exception x)
            {
                System.out.println("ERROR: Failed to read analyticsId from environment variable!");
                x.printStackTrace(); //TODO:DEBUG
            }
            try
            {
                properties.setProperty("maxFailures", System.getenv("maxFailures"));
                properties.setProperty("maxAttempts", System.getenv("maxAttempts"));
                properties.setProperty("updateCallPw", System.getenv("updateCallPw"));
                properties.setProperty("resetCallPw", System.getenv("resetCallPw"));
            }
            catch(Exception x)
            {
                System.out.println("ERROR: Failed to read DB reset config from environment variables!");
                x.printStackTrace(); //TODO:DEBUG
            }
        }
    }

    public static String getProperty(String propName)
    {
        return properties.getProperty(propName);
    }
}
