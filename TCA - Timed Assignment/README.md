# COM504TCA-2020-2021-Students

TCA for COM504 / COM528 2020

DO NOT FORK OR CLONE THIS REPOSITORY.
DOWNLOAD THE ZIP FILE.

# Assessment Task 

In this assessment you will be asked to complete the documentation for a java project using use case diagrams and robustness diagrams.

You will also be asked to write additional unit tests and complete the Java Server Pages (JSP's) associated with the project.

## Prerequisites

Before you start make sure that you have the correct packages installed on your computer.
If you have been following the course using your own computer, you should already have all of the following installed.
(You can use a MAC or a Linux based computer but this assessment has only been tested on a PC).

This assessment has been tested against Netbeans 8.1 and Java 8 AND Netbeans 12 and Java 11.
This means you can do the assessment using university machines (java 8/NB 8.x) or on your own home machine if you have installed Java 11

Instructions for both scenarios are provided below.

## Java 11 / Netbeans 12
You will need:
* java 11 JDK
* Netbeans 12 (11 will also do)
* apache maven
* Tomcat

Instructions for installing these packages are provided with the class notes

## Java 8 
You will need:
* java 8 JDK (do NOT use a later version with Netbeans 8.2) https://www.oracle.com/java/technologies/javase-jdk8-downloads.html
* Netbeans 8.2 (Jave EE or All version) with the optional tomcat package (which is an option in the installer) https://download.netbeans.org/netbeans/8.2/rc/
* apache maven https://maven.apache.org/install.html
 
Instructions for installing these packages are provided with the class notes

## Getting Started

This TCA is designed for you to complete at home. 

It should be possible to complete the assessment in 2 hours but due to the special circumstances you will have 24 hours to submit your response.

You will be given access to a ZIP FILE containing a maven project.

Download and extract this zip file to a folder in your user account on the C: drive on your machine.

Before you begin the assessment, make sure you can compile project using maven 
```
mvn clean install
```
Check you can load and run the project in tomcat from netbeans and that you can access the web page of the application at http://localhost:8080/ticketgate/

Contact your tutor if you have any problems at this stage.

You may, if you find it useful, access your previous work through git or use any other on line resources which helps you to complete this exercise. 

At the end of the assessment you will upload your completed code to SOL

If you have any problems getting started, the instructions are not clear or you get seriously stuck because of a technical problem not related to this exercise, talk to your tutor.

### Assessment
For this assessment you will be required to:
1. Read the scenario.
2. Complete the use case and robustness diagrams in the [UMLmodel/drawio](../master/ticketgate/UMLmodel) folder .
3. Complete the provided code demonstrating you understand how a complex object oriented project is constructed.

The full exercise begins in the section below; Project Brief : Station Ticket System

### Finishing up
At the end of the allocated time you will be asked to stop work.

To make saving the project manageable, clean out all target folders before zipping by using
```
mvn clean
```
Zip your cleaned git project, Name the zip file WITH YOUR NAME and submit it to sol. e.g. yourname-date-COM528TCA.zip

Where 'yourname' should be replaced with your name and date should be replaced with the current date.

e.g. craiggallen-27-12-19-COM528TCA.zip

Upload the zipped file to SOL

## Assessment criteria
 
We will allocate 50% of marks for design documentation and 50% for implementation.

There is no requirement to complete the documentation before you complete the code. 
However any documentation you submit should reflect the implementation. 
Do as much as you can of ALL the tasks to maximise your overall score. 
So don't spend too much time on any one task.

### Design and documentation (UML) (50%)

All of the models are contained in in the [UMLmodel/drawio](../master/ticketgate/UMLmodel) folder 

1. Complete use-case diagram	20%

2. Complete robustness diagram	25%

3. Ensure markdown references refer to your diagrams (gif) which describe usage of your code	5%

### Implementation (50%)

4. complete the test classes in the ticket-gate-model and ticket-gate-service module (25%). 

Tests need added to this project to test the ticket-gate-model and the ticket-gate-service

Specifically you MUST complete the uncompleted tests (three test methods 6% each ) in [GateServiceTest.java](../master/ticketgate/service/src/test/java/solent/ac/uk/com504/examples/ticketgate/service/test/GateServiceTest.java)

and you MUST complete the uncompleted test (one test method 7%) in [TicketJaxbTest.java](../master/ticketgate/model/src/test/java/solent/ac/uk/com504/examples/ticketgate/model/test/TicketJaxbTest.java)  to test the Ticket.toXML() and Ticket.fromXML()


5. Complete the user JSP for opening a gate(25%).

Specifically you should complete [openGate.jsp](../master/ticketgate/web/src/main/webapp/openGate.jsp)

You do not need to change any other code in this project.

# Project Brief : Station Ticket System version 0.1

## Scenario

![alt text](../master/images/gate.jpg "Figure gate.jpg")

A ticket system provides customers the means to create encoded tickets which are validated by 'gates' to allow entry or exit.

When a ticket created the passenger enters the following fields on a JSP page.
* dateFrom - the date from which this ticket can be used. (Dates are in the format 15-04-2020 10:19:20)
* dateto - the date when the ticket will expire and no longer open the gate.
* zones - the number of zones over which the ticket may be used (1-6)
* startingStation - the station at which the ticket was issued and from which the passenger departs.

This creates data for a Ticket encoded in XML which would be written to the RFID or magnetic strip ticket.

On a running system this JSP is at http://localhost:8080/ticketgate/generateTicket.jsp

A snapshot of this jsp is shown below

![alt text](../master/images/generateTicketJSP.png "Figure generateTicketJSP.png")

The system takes the data content of the ticket (dateFrom,dateTo,zones,startingStation) and encodes it with a private key held in the ticket management system in order to generate the field encodedKey which can only be decoded with a complementary public key in the gate ticket reader.

To simulate a gate reader, an openGate.jsp is provided which allows the ticket data to be pasted into a ticket field. 

On a running system the JSP is at http://localhost:8080/ticketgate/openGate.jsp

Pasting the generated Ticket XML into the field and pressing 'Open Gate' simulates swiping the ticket in the ticket reader.
An image of a working version of this page with a correct ticket pasted into the field is shown below.

![alt text](../master/images/openGateJSP.png "Figure openGateJSP.png")

The gate opens when the 'Open Gate' button is pressed if

a) The zones in the encoded ticket is equal to or less than the zones travelled field

b) The current time is correctly formatted and between the dateFrom and dateTo dates in the ticket XML

c) The ticket data field is populated with a correct ticket xml (this can be pasted from the generateTicket.jsp mentioned above)

The ticket data xml contains the encodedKey which must be decoded with a public key by the ticket reader in the gate. 
If the decoded data content of the ticket matches the ticket content ((dateFrom,dateTo,zones,startingStation) then this is a valid ticket and the gate can open.

Finally, the privateKey and publicKey files for the system are generated as part of the maven build using the 
 [GenerateKeys.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/crypto/GenerateKeys.java) 
 class called by the  maven exec plugin in the [service/pom.xml](../master/ticketgate/service/pom.xml)
These keys are included by the build in the class path of the web application.

These privateKeys and publickey files are read from the class path and used by the  
 [AsymmetricCryptography.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/crypto/AsymmetricCryptography.java)
class to encode the ticket. 

You should also include the process for generating and using these keys in your use case and robustness diagrams.

All of the classes in the system are included in the [UML class diagram](../master/ticketgate/UMLmodel/images/classDiagram.png) which helps explain the relationships between them.

## Tasks

In this exercise you will complete the design documentation and implementation of such a simple ticket system.

All the draw.io diagrams and easyUML models should be placed in the  [UMLmodel sub-project](../master/ticketgate/UMLmodel) 

You are provided with a UML class diagram [UML class diagram](../master/ticketgate/UMLmodel/images/classDiagram.png) which documents the boundary interfaces that the system must use. 
These interfaces are already implemented for you.

The classes in the UML class diagram have been created in the [model sub-project](../master/ticketgate/model) .
You are provided with implementation code which supports the service described by the model.

## Part 1 - Design documentation
You are required to document the use case using a UML use case diagram with draw.io (https://www.draw.io/). 
You must save the drawing as both an image and a drawio file.

It is STRONGLY suggested that you save your work as you go along to avoid any disasters.

You should start with the template draw.io drawings provided in the uml project.

You should save your use case diagram as a drawio file along with draw-io images in the uml project (template files are provided).

You should then create a robustness diagram to expand the use case and show how JSPs and processes interact with the boundary interfaces provided. 
To guide you a partly completed robustness diagram is provided.

When you have finished, save both the drawio and image files to your project so that they can be picked up by the README.MD file and displayed on git.

Your documentation should reflect the actual implementation and you may modify your documentation as you proceed.

## Part 2 - Implementation

You should then proceed to implement the various methods required for the use cases.

Read the Project Structure section below for more information on what is provided and how to complete your code.

Skeleton code is provided for you and you may also reuse any examples from previous classes.

(If you choose to use any other external examples, code or libraries you MUST ATTRIBUTE THE WORK and incorporate the relevant LICENCE both in licence comments at the top of the relevant class where the work is used and in the README for the code).

### ticketgate service

The ticketgate service project provides the underlying engine for creating and verifying tickets.

The implementation classes work so DO NOT alter these classes.

Most of the web application has been implemented and it's behaviour can be used to help you complete the use case and robustness diagrams.

However you are asked to write additional junit tests in the class 
 [GateServiceTest.java](../master/ticketgate/service/src/test/java/solent/ac/uk/com504/examples/ticketgate/service/test/GateServiceTest.java)

and you MUST complete the uncompleted test in [TicketJaxbTest.java](../master/ticketgate/model/src/test/java/solent/ac/uk/com504/examples/ticketgate/model/test/TicketJaxbTest.java)  to test the Ticket.toXML() and Ticket.fromXML()

### ticket-gate-web
The web application is assembled in the ticketgate web project. 
To run this application use netbeans to run tomcat.

The application should be available at http://localhost:8080/

Most of the web application has been implemented and it's behaviour can be used to help you complete the use case and robustness diagrams.

In this exercise you will be asked to complete the [openGate.jsp](../master/ticketgate/web/src/main/webapp/openGate.jsp) in the web interface to allow hotel guest to open a door using a ticket xml generated by the (provided working) [generateTicket.jsp](../master/ticketgate/web/src/main/webapp/generateTicket.jsp). 

### Project Structure

The following notes provide additional help with understanding the project structure within which you are to work.

This (ticketgate) folder contains a partially completed project which you will complete as part of this exercise.

In the ticketgate project, run maven with
```
mvn clean install
```

The project should build.

Import the ticket-gate project and its maven sub projects into netbeans. Also import the uml project.

The ticket-gate project is a multi-module maven project which means that the parent project causes the sub projects to be built in the order determined by the following section in the pom.xml

```
    <modules>
        <module>model</module>
        <module>service</module>
        <module>web</module>
    </modules>
```
### UMLmodel

The UMLmodel project contains the easyUML uml model, use cases, robustness diagrams and class diagrams for this project. 
Do not change the class diagram but do use the robustness diagrams and use case diagram templates in the drawio folder. 
Save your completed use cases and robustness diagrams here both as xml and as gif images so that they will show up in the README.md in git.

### ticket-gate-model

The ticket-gate-model project contains model classes and interfaces which have been generated and then expanded from the ticketgate-uml class diagrams. 
You should implement your code using interfaces from this model. 
DO NOT change this module.

However you are asked to write additional junit tests in the class 
[TicketJaxbTest.java](../master/ticketgate/model/src/test/java/solent/ac/uk/com504/examples/ticketgate/model/test/TicketJaxbTest.java)
to test the ticket.toXML() and ticket.fromXML()

### ticket-gate-service

The ticket-gate-service project provide the underlying engine for creating and verifying tickets.

These classes work so DO NOT alter these classes.

The 
[GateEntryServiceImpl.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/service/GateEntryServiceImpl.java)
and the
[GateManagementServiceImpl.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/service/GateManagementServiceImpl.java)

classes provide implementations of the respective interfaces
 
[GateEntryService.java](../master/ticketgate/model/src/main/java/solent/ac/uk/com504/examples/ticketgate/model/service/GateEntryService.java)
 
 and the 
 
[GateManagementService.java](../master/ticketgate/model/src/main/java/solent/ac/uk/com504/examples/ticketgate/model/service/GateManagementService.java) 


These classes use the  
[AssymetricCryptography.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/crypto/AsymmetricCryptography.java) 
 class to read the privateKey and publicKey files from the class path and use these to create and verify the encodedKey in tickets. 

New and unique privateKey and publicKey files  are generated by the 
[GenerateKeys.java](../master/ticketgate/service/src/main/java/solent/ac/uk/com504/examples/ticketgate/crypto/GenerateKeys.java)
 class during the maven build so that they are available on the class path of the running system. (this uses the exec-maven-plugin in the 
[service/pom.xml](../master/ticketgate/service/pom.xml)
 )

You do not need to modify these implementation classes BUT you do need to complete the junit tests in the class 
[GateServiceTest.java](../master/ticketgate/service/src/test/java/solent/ac/uk/com504/examples/ticketgate/service/test/GateServiceTest.java)

### ticket-gate-web

The ticket-gate-web project contains partly completed JSP's.

The generateTicket.jsp uses the gateManagementService which is obtained as a singleton from the ServiceFactoryImpl class.

The openGate.jsp uses the gateService which is obtained as a singleton from the ServiceFactoryImpl class.

Some of this JSP is implemented for you however you must Complete the JSP's to allow a customer to open a door.

There is a ReST service implementation within ticketgate-web. 

There is also a Rester file which can be used to test POSTs to the ReST interface in the rester folder

You should include the ReST interface in your documentation but you DO NOT need to test or modify the ReST service.
