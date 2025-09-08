package test;

import org.junit.Test;

import main.java.com.example.*;

import static org.junit.Assert.*;

public class AppTest {

    @Test
    public void testAdd() {
        assertEquals(5, App.add(2, 3));
    }
}