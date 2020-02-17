package com.darksoulsdeaths;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/request/*")
public class ServletController extends HttpServlet
{
    private int failures = 0;
    private int attempts = 0;

    public ServletController() {
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
        Utilities.log("Received GET request: " + request.getRequestURI());

        PrintWriter writer = response.getWriter();
        try
        {
            String action = request.getRequestURI().toLowerCase().split("/request/")[1];
            switch (action)
            {
                case "ping":
                    response.setContentType("text/html");
                    writer.println("pong!");
                    break;
                case "getdeathandadppaverages":
                    //TODO:just a debug for DB connection
                    response.setContentType("application/JSON");
                    writer.println(Utilities.mapToJson(DataManager.getDeathAndADPPAverages()));
                    break;
                default:
                    response.setContentType("text/html");
                    writer.println("ERROR: Unable to process request: " + action);
                    break;
            }
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            response.setContentType("text/html");
            writer.println("ERROR: Unable to process request; no action specified.");
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
        Utilities.log("Received POST request: " + request.getRequestURI());

        PrintWriter writer = response.getWriter();
        try
        {
            String action = request.getRequestURI().toLowerCase().split("/request/")[1];
            switch (action)
            {
                case "processfile":
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    Map<String,Integer> deathsMap;
                    try
                    {
                        List<FileItem> fileItems = upload.parseRequest(request);
                        FileItem file = fileItems.get(0); //TODO:safety!
                        deathsMap =  FileController.getDeathsFromFile(file);


                        request.setAttribute("fileData", deathsMap);
                        request.getRequestDispatcher("/results.jsp").forward(request, response);
                    }
                    catch (Exception e)
                    {
                        e.printStackTrace();
                        writer.println("An unexpected error occurred.");
                    }
                    break;
                case "submit":
                    Map<String,Object> charData;
                    try
                    {
                        charData = new HashMap<>();
                        charData.put("name", request.getParameter("name"));
                        charData.put("deaths", request.getParameter("deaths"));
                        request.setAttribute("charData", charData);
                        request.getRequestDispatcher("/submit.jsp").forward(request, response);
                    }
                    catch (Exception e)
                    {
                        e.printStackTrace();
                        writer.println("An unexpected error occurred.");
                    }
                    break;
                case "stats":
                    //TODO:take the submitted form data, put it in the DB, and forward user to the regular /stats page (we are currently in /request/stats)
                    request.getRequestDispatcher("/stats.jsp").forward(request, response);
                    break;
                case "resetlimiter":
                    response.setContentType("application/JSON");
                    try
                    {
                        String password = request.getReader().readLine(); //not normally how we'd do this, but it's nice to keep this particular feature user-unfriendly
                        if(password == null || !password.equals(StartClass.properties.getProperty("resetCallPw")))
                        {
                            System.out.println("Failed to reset limiter: Invalid Password");
                            writer.println("{");
                            writer.println("\"success\":false,");
                            writer.println("\"error\":\"Invalid password\"");
                            writer.println("}");
                            return;
                        }
                        else
                        {
                            attempts = 0;
                            failures = 0;
                            System.out.println("Reset limiter.");
                            writer.println("{");
                            writer.println("\"success\":true,");
                            writer.println("\"message\":\"Limiter reset successfully.\"");
                            writer.println("}");
                        }
                    }
                    catch(Exception e)
                    {
                        e.printStackTrace();
                        System.out.println("Failed request: " + e.getMessage());
                        writer.println("{");
                        writer.println("\"success\":false,");
                        writer.println("\"error:\" An unexpected error occurred.\"");
                        writer.println("}");
                    }
                    break;
                default:
                    response.setContentType("text/html");
                    writer.println("ERROR: Unable to process request: " + action);
                    break;
            }
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            response.setContentType("text/html");
            writer.println("ERROR: Unable to process request; no action specified.");
        }
    }
}