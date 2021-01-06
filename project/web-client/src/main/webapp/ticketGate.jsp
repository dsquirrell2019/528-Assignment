<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="java.io.StringReader"%>
<%@page import="java.io.StringReader"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Date"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoder"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    //refresh page every 20s
    response.setIntHeader("Refresh", 20);
    
    //Write errors back to page
    String errorMessage = "";
    
    //get current time
    Date currentTime = new Date(); 
        
    //initialisations
    Date dateOfIssue = null;
    String destinationStation = null;
    Integer zone = null; 
    
    boolean isDateValid = false;
    boolean isFormatValid = false;
    boolean isStationValid = false;    
    boolean isTicketValid = false;
    
    List<Station> stationList = new ArrayList<Station>();
    
    // accessing service   
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
    
    String model = "org.solent.com528.project.model.dto";
    
    //obtain initial values
    String destinationStationString = request.getParameter("destinationStationName");
    String encodedTicketString = request.getParameter("ticketStr");
    String zoneString = request.getParameter("zone");
    
    // return list of stations
    if (zoneString == null) {
        stationList = stationDAO.findAll();
    } else {
        try {
            zone = Integer.parseInt(zoneString);
            stationList = stationDAO.findByZone(zone);
        } catch (Exception ex) {
            
        }
    }
  
    //If there is ticket data available
    if (encodedTicketString != null) {
        try {
            //set Jaxb context
            JAXBContext context = JAXBContext.newInstance(model);
            Unmarshaller jaxbUnMarshaller = context.createUnmarshaller();
            
            //get ticket object from marshalling encoded string
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(encodedTicketString));
            
            //get date and destination of ticket
            dateOfIssue = ticket.getIssueDate();
            destinationStation = ticket.getEndStation();
            
        } catch (Exception e) {
            
        }
    }

    //check the correct station
    try {
        isStationValid = destinationStationString.equals(destinationStation);
    } catch (Exception e) {
        
    }
    //check the correct format
    try {
        isFormatValid = TicketEncoderImpl.validateTicket(encodedTicketString);
    } catch (Exception e) {
        
    }
    // Check expiry date matches
    try {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(dateOfIssue);
        calendar.add(Calendar.HOUR_OF_DAY, 24);
        isDateValid = currentTime.before(calendar.getTime());
    } catch (Exception e) {
        
    }    
    
    //if all above are OK, ticket assumed to be valid
    if (isStationValid && isFormatValid && isDateValid) {
        isTicketValid = true;
    } 
    else {
        isTicketValid = false ;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Open gate</title>
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
        <h1>Open Ticket Gate</h1>
        <p><a href="./">Back</a></p>
        <% if (isTicketValid) { %>
        <div style="color:green;font-size:x-large">OPEN</div>
        <%  } else {  %>
        <div style="color:red;font-size:x-large">LOCKED</div>
        <% }%>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>
        <form action="./ticketGate.jsp"  method="post" >
            <table>
                <tr>
                    <td>Valid Format:</td>
                    <td>
                        <p><%=isFormatValid%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Date</td>
                    <td>
                        <p><%=isDateValid%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Station</td>
                    <td>
                        <p><%=isStationValid%></p>
                    </td>
                </tr>

                <tr>
                    <td>
                        Arrival Zone:
                    </td>
                    <td>
                        <%
                            for (Integer selectZone : zones) {
                        %>
                        <form action="./ticketGate.jsp" method="get">
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
                    <td>Arrival Station:</td>
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
        </form> 
    <tr>
        <td>Current Time:</td>
        <td>
            <p><%= currentTime.toString()%> (Refreshed every 20 seconds)</p>
        </td>
    </tr>
    <tr>
        <td>Ticket Data:</td>
        <td><textarea name="ticketStr" rows="14" cols="120"><%=encodedTicketString%></textarea></td>
    </tr>
</table>
<button type="submit" >Unlock Gate</button>
</form> 
</body>
</html>
