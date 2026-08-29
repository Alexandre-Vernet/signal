package com.avernet.signal;

import org.springframework.boot.SpringApplication;

public class TestSignalApplication {

	public static void main(String[] args) {
		SpringApplication.from(SignalApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
