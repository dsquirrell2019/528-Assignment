/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package solent.ac.uk.com504.examples.ticketgate.service.test;

import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket;
import solent.ac.uk.com504.examples.ticketgate.service.ServiceFactoryImpl;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateManagementService;
import solent.ac.uk.com504.examples.ticketgate.model.service.GateEntryService;

/**
 * TESTS OF THE GATE SERVICES
 *
 * TODO YOU NEED TO COMPLETE THE TESTS BELOW WHICH HAVE NO CODE YOUR TEST MUST
 * MEET THE SPECIFICAITON GIVEN IN THE TEST DOCUMENTATION ABOVE EACH TEST METHOD
 */
public class GateServiceTest {

    private GateManagementService lockManagementService = null;
    private GateEntryService gateEntryService = null;

    private Date validFrom = null;
    private Date validTo = null;

    private Ticket ticket = null;

    @Before
    public void init() {
        lockManagementService = ServiceFactoryImpl.getGateManagementService();
        assertNotNull(lockManagementService);

        gateEntryService = ServiceFactoryImpl.getGateEntryService();
        assertNotNull(gateEntryService);

        validFrom = new Date();

        // test if ticket created
        String zonesTravelled = "1";

        // add 24 hours 1000 ms * 60 secs * 60 mins * 24 hrs to current time
        long validToLong = validFrom.getTime() + 1000 * 60 * 60 * 24;
        validTo = new Date(validToLong);

        String startStation = "Waterloo";

        // create valid ticket for use in tests
        ticket = lockManagementService.createTicket(zonesTravelled, validFrom, validTo, startStation);
        assertNotNull(ticket);

    }

    @Test
    public void testInitialisation() {
        // simply tests inititialisation in @before method
    }

    /**
     * TEST TO check gate opens if current time is between validFrom and validTo
     * time and NUMBER OF ZONES is correct
     */
    @Test
    public void testgateOpens() {

        Date currentTime = new Date(validFrom.getTime() + 1000 * 60);
        String zonesTravelled = "1";
        boolean open = gateEntryService.openGate(ticket, zonesTravelled, currentTime);
        assertTrue(open);
    }



    /**
     * WRITE A TEST TO check gate doesn't open with wrong number of zones
     */
    @Test
    public void testgateShutWrongZones() {

        Date currentTime = new Date(validFrom.getTime() + 1000 * 60);
        String zonesTravelled = "70";
        boolean open = gateEntryService.openGate(ticket, zonesTravelled, currentTime);
        assertFalse(open);
    }

    /**
     * WRITE A TEST TO check gate doesn't open if current time before validFrom
     * time
     */
    @Test
    public void testCurrentTimeBeforeValidFrom() {

        Date currentTime = new Date(validFrom.getTime() - 1000 * 60);
        String zonesTravelled = "1";
        boolean open = gateEntryService.openGate(ticket, zonesTravelled, currentTime);
        assertFalse(open);
    }

    /**
     * WRITE A TEST TO check gate doesn't open if current time after validTo
     * time
     */
    @Test
    public void testCurrentTimeAfterValidTo() {

         Date currentTime = new Date(validFrom.getTime() + 2000 * 60 * 60 * 24);
        String zonesTravelled = "1";
        boolean open = gateEntryService.openGate(ticket, zonesTravelled, currentTime);
        assertFalse(open);

    }
}
