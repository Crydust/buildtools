package be.crydust.greeter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {

    private final static Logger log = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {
        log.info("App main");
        Greeter g = new Greeter("world");
        g.readProperties();
        System.out.println(g.greet());
        log.info("App main done");
    }

}

