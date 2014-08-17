package be.crydust.greeter;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;
import org.junit.Test;

public class GreeterTest {

    @Test
    public void testGreet() {
        Greeter g = new Greeter("dummy");
        g.setFormat("%s");
        assertThat(g.greet(), is("dummy"));
    }

}
