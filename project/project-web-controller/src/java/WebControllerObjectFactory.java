
import java.util.logging.LogManager;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
//import org.solent.com528.project.model.service.ServiceFacade;
//import org.solent.com528.project.model.service.ServiceObjectFactory;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author dsqui
 */
public class WebControllerObjectFactory implements ServletContextListener{

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
   // final static Logger LOG = LogManager.getLogger(WebControllerObjectFactory.class);
    
//    @Override
//    public void contextInitialized(ServletContextEvent sce) {
//        LOG.debug("WEB OBJECT FACTORY context initialised");
//        // nothing to do
//    }
//
//    @Override
//    public void contextDestroyed(ServletContextEvent sce) {
//        LOG.debug("WEB OBJECT FACTORY shutting down context");
//        if (serviceObjectFactory != null) {
//            synchronized (WebObjectFactory.class) {
//                LOG.debug("WEB OBJECT FACTORY shutting down serviceObjectFactory");
//                serviceObjectFactory.shutDown();
//                LOG.debug("WEB OBJECT FACTORY shutting down derby database");
//                shutdownDerby();
//                LOG.debug("WEB OBJECT FACTORY derby shutdown");
//            }
//
//        }
//    }
    
}
