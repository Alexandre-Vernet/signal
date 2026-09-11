package com.avernet.signal.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;

@Getter
@Setter
public class ApiErrorResponse {

    TypeError type = TypeError.BUSINESS;

    ErrorCodeEnum errorCode;

    String message;

    HttpStatus httpStatus;

    LocalDateTime timestamp = LocalDateTime.now();

    public ApiErrorResponse(ErrorCodeEnum errorCode, String message, HttpStatus httpStatus) {
        this.errorCode = errorCode;
        this.message = message;
        this.httpStatus = httpStatus;
    }
}
