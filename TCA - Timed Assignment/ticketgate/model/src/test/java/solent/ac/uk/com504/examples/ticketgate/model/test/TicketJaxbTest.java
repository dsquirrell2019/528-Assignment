/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.model.test;

import java.util.Date;
import org.junit.Test;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateEntryService;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateManagementService;
import solent.ac.uk.com504.examples.ticketgate.service.ServiceFactoryImpl;
/**
 * TEST THAT ticket.toXML and ticket.fromXML both work
 * 
 * create and populate a ticket using new ticket()
 * convert the ticket to an xml string
 * convert the xml string back to a new  ticket
 * check that the data in the two tickets are the same
 * 
 * @author cgallen
 */
public class TicketJaxbTest {

    /**
     * Test that a ticket can be marshalled and un-marshalled to xml using Ticket.toXML() and Ticket.fromXML methods
     */

    @Test
    public void testTicketXML() {
        // test if ticket created
        String zonesTravelled = "1";
        Date validFrom = new Date();
        // add 24 hours 1000 ms * 60 secs * 60 mins * 24 hrs to current time
        long validToLong = validFrom.getTime() + 1000 * 60 * 60 * 24;
        Date validTo = new Date(validToLong);

        String startStation = "Victoria";
        String encodedKey = "xyz123";
        // create valid ticket for use in tests
        Ticket ticket = new Ticket();
        
        ticket.setStartStation(startStation);
        ticket.setValidFrom(validFrom);
        ticket.setValidTo(validTo);
        ticket.setEncodedKey(encodedKey);
        ticket.setZones(zonesTravelled);
        
        //create xml for ticket
        String ticketXML = ticket.toXML();
        
        //create ticket from xml
        Ticket xmlTicket = ticket.fromXML(ticketXML);
        
        //compare xml encoded ticket and original
        assertEquals(xmlTicket.toString(),ticket.toString());

    }

}
