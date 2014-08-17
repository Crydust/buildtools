package be.crydust.greeter;

import java.io.IOException;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Greeter {

    private final static Logger log = LoggerFactory.getLogger(Greeter.class);

    private String format = "Howdy %s.";
    private final String name;

    public Greeter(final String name) {
        log.trace("Greeter constructor");
        this.name = name;
    }

    public void readProperties() {
        log.trace("Greeter readProperties");
        try {
            final Properties properties = new Properties();
            properties.load(getClass().getResourceAsStream("/greeter.properties"));
            this.format = properties.getProperty("format");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void setFormat(String format) {
        log.trace("Greeter setFormat");
        this.format = format;
    }

    public String greet() {
        log.trace("Greeter greet");
        return String.format(format, name);
    }
}

