package com.avernet.signal.root;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController("/")
public class RootController {

    @GetMapping("/")
    public String root() {
        return "Signal API is running";
    }
}
