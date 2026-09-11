package com.avernet.signal.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;

@Getter
@Setter
public class ApiException extends RuntimeException {

    private ErrorCodeEnum errorCode;
    private HttpStatus httpStatus;

    public ApiException(ErrorCodeEnum errorCode, String message, HttpStatus httpStatus) {
        super(message);
        this.errorCode = errorCode;
        this.httpStatus = httpStatus;
    }
}
