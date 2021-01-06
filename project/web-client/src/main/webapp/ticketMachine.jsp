<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.solent.com528.project.impl.dao.jaxb.PriceCalculatorDAOJaxbImpl"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.dto.PricingDetails"%>
<%@page import="org.solent.com528.project.model.dao.PriceCalculatorDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoder"%>
<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dto.Ticket" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    //Used to write messages on webpage 
    String errorMessage = "";
    String message = "";
    
    //Create new ticket object    
    Ticket ticket = new Ticket();
    
    // Getting and setting Initial values
    String ticketString = request.getParameter("ticketStr");
    String startStationString = request.getParameter("startStation");
    String endStationString = request.getParameter("endStation");
    String zoneString = request.getParameter("zone");  
    String destinationStationName = request.getParameter("destinationStationName");
    String actionString = request.getParameter("action");
    String validToTimeString = "";
    int endZone = 0;
    double ticketPrice = 0;
    int zonesTravelled = 1;
    
    Date currentTime = new Date();
    String currentTimeString = currentTime.toString();
    
    List<Station> stationList = new ArrayList<Station>();
    
    // accessing service 
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
        
    String startStationName = WebClientObjectFactory.getStationName();
    Integer startStationZone = WebClientObjectFactory.getStationZone();
   
    // return list of stations
    if (zoneString == null) {
        stationList = stationDAO.findAll();  
    } 
    else {
        try {
            Integer zone = Integer.parseInt(zoneString);
            stationList = stationDAO.findByZone(zone);
        } catch (Exception e) {
        }
    }
    message = "";
    
    // Obtain valid to time (24hrs)
    try {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.HOUR_OF_DAY, 24);
        validToTimeString = calendar.getTime().toString();
    } catch (Exception ex) {
    }
        
    // Get price file and pass to calculator
    String file = "target/priceCalculatorDAOJaxbImplFile.xml";
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb = new PriceCalculatorDAOJaxbImpl(file);
    
    // Get service
    PriceCalculatorDAO pricecalculatorDAO = serviceFacade.getPriceCalculatorDAO();
    pricecalculatorDAO.getPricingDetails();
    
    //set price for current time
    double zonePrice = pricecalculatorDAO.getPricePerZone(currentTime);
    Rate rate = priceCalculatorDAOJaxb.getRate(currentTime);
    
    //Logic works oout the price    
    try {
        endZone = Integer.parseInt(zoneString);
        zonesTravelled = Math.abs(startStationZone - endZone);
        if (zonesTravelled == 0) {
                zonesTravelled = 1;
            } 
        ticketPrice = zonesTravelled * zonePrice;
        ticket.setCost(ticketPrice);
        
        } catch (Exception e) {
    }
    
    try {
        //Setting ticket variables
    ticket.setStartStation(startStationName);
    ticket.setIssueDate(currentTime);
    ticket.setRate(rate);
    ticket.setEndStation(destinationStationName);;
    if (startStationZone != null && startStationName != null && destinationStationName != null && endZone != 0 && ticketPrice != 0) {
        //Create an encoded ticket
        ticketString = TicketEncoderImpl.encodeTicket(ticket);
    }
    
    
    } catch (Exception e) {
        errorMessage = "Unable to set ticket information and and encrypt";
    }  
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage gate Locks</title>
        <style>               
            div {justify-content: center;}
            h1 {justify-content: center;
                color: darkslateblue;
                font-family: "Times New Roman", Times, serif;
            }
            table {
                justify-content: center;
            }
            button {             
                justify-content: center;
            }
            textArea {
                margin-left: auto;
                margin-right: auto;
            }
        </style>
    </head>
    <body>
        <h1>Generate a New Ticket</h1>
        <p><a href="./">Back</a></p>
        <!-- print error message if there is one -->
        <div style="color:green;"><%=message%></div>
        <div style="color:red;"><%=errorMessage%></div>

        <form action="./ticketMachine.jsp?zone=<%= endZone%>"  method="post">
            <table>
                <tr>
                    <td>Starting Zone:</td>
                    <td><%=startStationZone%></td>
                </tr>
                <tr>
                    <td>Starting Station:</td>
                    <td><%=startStationName%></td>
                </tr>

                <tr>
                    <td>
                        Destination Zone:
                    </td>
                    <td>
                        <%
                            for (Integer selectZone : zones) {
                        %>
                        <form action="./ticketMachine.jsp" method="get">
                            <input type="hidden" name="zone" value="<%= selectZone%>">
                            <button type="submit" >Zone&nbsp;<%= selectZone%></button>
                        </form> 
                        <%
                            }
                        %>

                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Destination Zone Selection:</td>
                    <td><%= endZone%></td>
                </tr>
                <tr>
                    <td>Destination Station:</td>
                    <td>
                        <select name="destinationStationName" id="destinationStationName">
                            <%
                                for (Station station : stationList) {
                            %>
                            <option value="<%=station.getName()%>"><%=station.getName()%></option>
                            <%
                                }
                            %>
                    </td>
                </tr>
                
                <tr>
                    <td>Valid From Time:</td>
                    <td>
                        <p><%=currentTimeString%></p>
                    </td>
                </tr>

                <tr>
                    <td>Valid To Time:</td>
                    <td>
                        <p><%=validToTimeString%></p>
                    </td>
                </tr>
                <tr>
                    <td>Ticket Cost:</td>
                    <td>
                        <p>£<%=ticketPrice%>0</p>
                    </td>
                </tr>
            </table>
            <button type="submit">Create Ticket</button>
        </form> 
        <h1>Encoded Ticket</h1>
        <textarea id="ticketTextArea" rows="10" cols="200"><%=ticketString%></textarea>

    </body>
</html>